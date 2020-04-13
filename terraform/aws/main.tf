variable "aws_region" {
    type        = string
    description = "AWS region"
    default     = "us-east-1"
}

variable "aws_access_key" {
    type        = string
    description = "AWS access key"
}

variable "aws_secret_key" {
    type        = string
    description = "AWS secret key"
}

provider "aws" {
    region      = "${var.aws_region}"
    access_key  = "${var.aws_access_key}"
    secret_key  = "${var.aws_secret_key}"
}

# Create VPC
resource "aws_vpc" "devops-vpc" {
  cidr_block       = "10.69.0.0/16"
  tags = { Name = "devops-vpc" }
}

# Create public subnet
resource "aws_subnet" "devops-public-subnet" {
  vpc_id     = "${aws_vpc.devops-vpc.id}"
  cidr_block = "10.69.1.0/24"
  tags       = { Name = "devops-public-subnet" }
}

# Create internet gateway
resource "aws_internet_gateway" "devops-igw" {
  vpc_id    = "${aws_vpc.devops-vpc.id}"
  tags      = { Name = "devops-igw" }
}

# Create route table
resource "aws_route_table" "devops-route-table" {
  vpc_id = "${aws_vpc.devops-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.devops-igw.id}"
  }
  tags = { Name = "devops-route-table" }
}
# Associate to subnet
resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.devops-public-subnet.id}"
  route_table_id = "${aws_route_table.devops-route-table.id}"
}

# Create security group
resource "aws_security_group" "devops-sg" {
  name        = "devops-sg"
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
  tags = { Name = "devops-sg" }
}

# Create DevOps user
resource "aws_iam_user" "devops-user" {
  name = "devops-user"
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
    value   = "${aws_security_group.devops-sg.id}"
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
