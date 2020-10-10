### IAM

# Create DevOps user
resource "aws_iam_user" "devops_user" {
   name = "devops"
}

# Create policy for DevOps user
resource "aws_iam_user_policy" "devops_user_policy" {
   name = "devops-user-policy"
   user = aws_iam_user.devops_user.name
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
resource "aws_iam_access_key" "devops_access_key" {
   user    = aws_iam_user.devops_user.name
}

# Create DevOps role for EC2 resources
resource "aws_iam_role" "devops_role" {
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
resource "aws_iam_instance_profile" "devops_profile" {
   name = "devops-profile"
   role = aws_iam_role.devops_role.name
}

# Create policy for Role
resource "aws_iam_role_policy" "devops_role_policy" {
   name = "devops-role-policy"
   role = aws_iam_role.devops_role.id
   policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
      {
      "Action": [
         "ec2:*",
         "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
      }
   ]
}
EOF
}