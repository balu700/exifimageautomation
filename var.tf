#Create Variables
variable "function_name" {
  default = "exif"
}
variable "handler_name" {
  default = "exif_python"
}
variable "runtime" {
  default = "python3.6"
}
variable "timeout" {
  default = "900"
}

variable "lambda_role_name" {
  default = ""
}

variable "lambda_iam_policy_name" {
  default = ""
}

variable "bucket_name" {
  default = ""
}

variable "environment" {
  default = "dev"
}