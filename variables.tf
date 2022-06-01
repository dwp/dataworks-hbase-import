variable "assume_role" {
  type        = string
  default     = "ci"
  description = "IAM role assumed by Concourse when running Terraform"
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "source_hbase_snapshot_workspace" {
  type        = string
  description = "Terraform workspace used to source snapshot"
}