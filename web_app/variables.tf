variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-west-2"
}

variable "aws_access_key" {
  description = "The AWS access key of the account to deploy"
  default     = "<access-key>"
}

variable "aws_secret_key" {
  description = "The AWS secret key of the account to deploy"
  default     = "<secret-key>"
}

variable "vpc_cidr" {
  description = "The VPC_cidr range"
  default = "10.0.0.0/16"
}

variable "subnet1_cidr" {
  description = "First subnet cidr"
  default = "10.0.1.0/24"
}

variable "subnet2_cidr" {
  description = "Second subnet cidr"
  default = "10.0.2.0/24"
}

variable "az1" {
  description = "The first availability zone"
  default     = "us-west-2a"
}

variable "az2" {
  description = "The second availability zone"
  default     = "us-west-2b"
}

variable "ami_id" {
  description = "The AMI ID to use for the instances"
  default     = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
}

variable "instance_type" {
  description = "The instance type to use"
  default     = "t2.micro"
}

variable "s3_bucket" {
  description = "The name of the S3 bucket for remote state storage"
  default     = "hyperverge-state-bucket"
}

variable "dynamodb_table" {
  description = "The name of the DynamoDB table for state locking"
  default     = "hyperverge-terraform-lock"
}
