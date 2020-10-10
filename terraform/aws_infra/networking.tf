### Networking

# Create VPC
resource "aws_vpc" "devops_vpc" {
   cidr_block  = "10.69.0.0/16"
   tags        = merge(local.base_tags, { Name = "devops-vpc" })
}

# Create public subnet
resource "aws_subnet" "devops_public_subnet" {
   vpc_id     = aws_vpc.devops_vpc.id
   cidr_block = "10.69.10.0/24"
   tags       = merge(local.base_tags, { Name = "devops-public-subnet" })
}

# Create private subnet
resource "aws_subnet" "devops_private_subnet" {
   vpc_id     = aws_vpc.devops_vpc.id
   cidr_block = "10.69.20.0/24"
   tags       = merge(local.base_tags, { Name = "devops-private-subnet" })
}

# Create internet gateway
resource "aws_internet_gateway" "devops_igw" {
   vpc_id = aws_vpc.devops_vpc.id
   tags   = merge(local.base_tags, { Name = "devops-igw" })
}

# Create Elastic IP - Conditional
resource "aws_eip" "devops_nat_eip" {
   count = var.enable_nat_gw == true ? 1 : 0
   vpc   = true
   tags  = merge(local.base_tags, { Name = "devops-nt-eip" })
}

# Create NAT gateway - conditional
resource "aws_nat_gateway" "devops_nat_gw" {
   count          = var.enable_nat_gw == true ? 1 : 0
   allocation_id  = aws_eip.devops_nat_eip[0].id
   subnet_id      = aws_subnet.devops_public_subnet.id
   tags           = merge(local.base_tags, { Name = "devops-nat-gw" })
}

# Create public route table
resource "aws_route_table" "devops_public_rtb" {
   vpc_id = aws_vpc.devops_vpc.id
   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.devops_igw.id
   }
   route {
      cidr_block = "::/0"
      gateway_id = aws_internet_gateway.devops_igw.id
   }
   tags = merge(local.base_tags, { Name = "devops-public-rtb" })
}

# Create private route table
resource "aws_route_table" "devops_private_rtb" {
   count   = var.enable_nat_gw == true ? 1 : 0
   vpc_id  = aws_vpc.devops_vpc.id
   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.devops_nat_gw[0].id
   }
   route {
      cidr_block = "::/0"
      gateway_id = aws_nat_gateway.devops_nat_gw[0].id
   }
   tags = merge(local.base_tags, { Name = "devops-private-rtb" })
}

# Associate to public subnet
resource "aws_route_table_association" "public_asso" {
   subnet_id      = aws_subnet.devops_public_subnet.id
   route_table_id = aws_route_table.devops_public_rtb.id
}

# Associate to private subnet
resource "aws_route_table_association" "private_asso" {
   count          = var.enable_nat_gw == true ? 1 : 0
   subnet_id      = aws_subnet.devops_private_subnet.id
   route_table_id = aws_route_table.devops_private_rtb[0].id
}

# Create security group
resource "aws_security_group" "devops_public_sg" {
   name_prefix    = "devops-public-sg"
   vpc_id         = aws_vpc.devops_vpc.id
   ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow inbound SSH access"
      cidr_blocks = var.ssh_access_cidr
   }
   egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all ounbound access"
      cidr_blocks = ["0.0.0.0/0"]
   }
   tags = merge(local.base_tags, { Name = "devops-public-sg" })
}