variable "etl_bucket_names" {
  type        = set(string)
  description = "List of bucket needed for the project"
}

variable "etl_service_account_name" {
  type        = string
  description = "value"
}