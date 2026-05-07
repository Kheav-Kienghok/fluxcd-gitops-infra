variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Name of the AWS SSH key pair to create"
  type        = string
  default     = "fluxcd-gitops-key"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "fluxcd-gitops-instance"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 30
}
