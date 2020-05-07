variable "aws_region" {
    type    = string
    description = "The AWS region to create the environment."
    default = "us-east-1"
}

variable "enable_nat_gw" {
    type    = bool
    description = "Enable NAT gateway deployment? AWS may charge you for this."
    default = false
}

provider "aws" {
    region      = "${var.aws_region}"
}

### Networking

# Create VPC
resource "aws_vpc" "devops-vpc" {
    cidr_block  = "10.69.0.0/16"
    tags        = {
        Name = "devops-vpc"
        namespace   = "devops"
        project     = "demo"
    }
}

# Create public subnet
resource "aws_subnet" "devops-public-subnet" {
    vpc_id     = "${aws_vpc.devops-vpc.id}"
    cidr_block = "10.69.10.0/24"
    tags       = {
        Name        = "devops-public-subnet"
        namespace   = "devops"
        project     = "demo"
        ispublic    = "true"
    }
}

# Create private subnet
resource "aws_subnet" "devops-private-subnet" {
    vpc_id     = "${aws_vpc.devops-vpc.id}"
    cidr_block = "10.69.20.0/24"
    tags       = {
        Name        = "devops-private-subnet"
        namespace   = "devops"
        project     = "demo"
        ispublic    = "false"
    }
}

# Create internet gateway
resource "aws_internet_gateway" "devops-igw" {
    vpc_id    = "${aws_vpc.devops-vpc.id}"
    tags      = {
        Name = "devops-igw"
        namespace   = "devops"
        project     = "demo"
    }
}

# Create Elastic IP - Conditional
resource "aws_eip" "nat" {
    count   = "${var.enable_nat_gw == true ? 1 : 0}"
    vpc     = true
}

# Create NAT gateway - conditional
resource "aws_nat_gateway" "gw" {
    count           = "${var.enable_nat_gw == true ? 1 : 0}"
    allocation_id   = "${aws_eip.nat.id}"
    subnet_id       = "${aws_subnet.public.id}"
    tags = {
        Name = "gw NAT"
    }
}

# Create route table
resource "aws_route_table" "devops-route-table" {
    vpc_id  = "${aws_vpc.devops-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.devops-igw.id}"
    }
    tags    = {
        Name = "devops-route-table"
    }
}
# Associate to subnet
resource "aws_route_table_association" "a" {
    subnet_id      = "${aws_subnet.devops-public-subnet.id}"
    route_table_id = "${aws_route_table.devops-route-table.id}"
}

# Create security group
resource "aws_security_group" "devops-public-sg" {
    name        = "devops-public-sg"
    vpc_id      = "${aws_vpc.devops-vpc.id}"
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = { Name = "devops-public-sg" }
}

### IAM

# Create DevOps user
resource "aws_iam_user" "devops-user" {
    name = "devops"
}

# Create policy for DevOps user
resource "aws_iam_user_policy" "devops-user-policy" {
    name = "devops-user-policy"
    user = "${aws_iam_user.devops-user.name}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": [
            "ec2:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
        }
    ]
}
EOF
}

# Create Access Key for DevOps user
resource "aws_iam_access_key" "devops-access-key" {
    user    = "${aws_iam_user.devops-user.name}"
}

# Create DevOps role
resource "aws_iam_role" "devops-role" {
    name = "devops-role"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
EOF
}

# Create DevOps instance profile
resource "aws_iam_instance_profile" "devops-profile" {
    name = "devops-profile"
    role = "${aws_iam_role.devops-role.name}"
}

# Create policy for Role
resource "aws_iam_role_policy" "devops-role-policy" {
    name = "devops-role-policy"
    role = "${aws_iam_role.devops-role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": [
            "ec2:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
        }
    ]
}
EOF
}
# Output values
output "AWS_SUBNET_ID" {
    value   = "${aws_subnet.devops-public-subnet.id}"
}
output "AWS_SG_ID" {
    value   = "${aws_security_group.devops-public-sg.id}"
}

output "AWS_ACCESS_KEY_ID" {
    value     = "${aws_iam_access_key.devops-access-key.id}"
}
output "AWS_ACCESS_SECRET_KEY" {
    value     = "${aws_iam_access_key.devops-access-key.secret}"
}
output "AWS_ROLE_ARN" {
    value   = "${aws_iam_instance_profile.devops-profile.arn}"
}