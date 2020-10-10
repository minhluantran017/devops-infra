# Output values
output "AWS_VPC_ID" {
   value   = aws_vpc.devops_vpc.id
}
output "AWS_SUBNET_ID" {
   value   = aws_subnet.devops_public_subnet.id
}
output "AWS_SECURITY_GROUP_ID" {
   value   = aws_security_group.devops_public_sg.id
}
output "AWS_ACCESS_KEY_ID" {
   value   = aws_iam_access_key.devops_access_key.id
}
output "AWS_ACCESS_SECRET_KEY" {
   value   = aws_iam_access_key.devops_access_key.secret
}
output "AWS_ROLE_ARN" {
   value   = aws_iam_instance_profile.devops_profile.arn
}