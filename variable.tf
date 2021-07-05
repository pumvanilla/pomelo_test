variable "region" {
  default     = "ap-southeast-1"
  description = "AWS region"
}

variable "ec2_policy" {
  type = list(string)
  default = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"]
}

variable "codedeploy_policy" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess",
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  ]
}