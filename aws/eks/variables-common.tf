variable "aws_profile" {
  type = string
  description = "AWS profile to use"
}
variable "aws_region" {
  type = string
  description = "AWS region to use"
}

variable "stack_name" {
  type = string
  description = "Stack name"
}

variable "additional_tags" {
  type    = map(string)
  description = "Additional tags to be added"
}