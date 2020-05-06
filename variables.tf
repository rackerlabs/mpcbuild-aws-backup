variable "tags" {
  description = "Custom tags to apply to all resources."
  type        = map(string)
  default     = {}
}
variable "environment" {
  description = "Application environment for which this resource is being created. Preferred values are Development, Integration, PreProduction, Production, QA, Staging, or Test."
  type        = string
  default     = "Development"
}
variable "create_vault" {
  description = "Create new vault in the account"
  type        = bool
  default     = true
}
variable "vault_name" {
  description = "Vault Name"
  type        = string
}
variable "use_cmk" {
  description = "Use AWS CMK to encrypt vault"
  type        = bool
  default     = false
}
variable "customer_key_arn" {
  description = "AWS CMK ARN for vault encryption"
  type        = string
  default     = ""
}
variable "cron_schedule" {
  description = "CRON expression to handle the scheduling of backups"
  type        = string
  default     = "cron(0 5 * * ? *)"
}
variable "retention_days" {
  description = "Time in days that each recovery point will be saved"
  type        = number
  default     = 35
}
variable "replicate_snapshots" {
  description = "Copy snapshots to another vault in other region"
  type        = bool
  default     = false
}
variable "replication_vault_arn" {
  description = "ARN of the vault used for replication"
  type        = string
  default     = ""
}
variable "select_by_tags" {
  description = "Backup selection based on tags"
  type        = bool
  default     = false
}
variable "backup_tag_key" {
  description = "Value of the key for the tag used to select resource to backup"
  type        = string
  default     = "Backup"
}
variable "backup_tag_value" {
  description = "Value of the value for the tag used to select resource to backup"
  type        = string
  default     = "true"
}
variable "select_by_resource" {
  description = "Backup selection based on tags"
  type        = bool
  default     = false
}
variable "ebs_arns" {
  description = "List to EBS volumes to backup (if resource selection is used, ARN's only)"
  type        = list
  default     = []
}
variable "ec2_arns" {
  description = "List to EC2 instances to backup (if resource selection is used, ARN's only)"
  type        = list
  default     = []
}
variable "efs_arns" {
  description = "List to EFS file systems to backup (if resource selection is used, ARN's only')"
  type        = list
  default     = []
}
variable "rds_arns" {
  description = "List to RDS instances to backup (if resource selection is used, ARN's only, Aurora doesn't apply)"
  type        = list
  default     = []
}
variable "dynamodb_arns" {
  description = "List to DynamoDB tables to backup (if resource selection is used, ARN's only')"
  type        = list
  default     = []
}
