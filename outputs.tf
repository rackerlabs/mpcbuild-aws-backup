output "backup_vault_id" {
  description = "Id of AWS Backup Vault"
  value       = var.customer_key_arn != "" ? aws_backup_vault.vault_custom_encryption.0.id : aws_backup_vault.vault_default_encryption.0.id
}

output "backup_recovery_points" {
  description = "Recovery points of AWS Backup Vault"
  value       = var.customer_key_arn != "" ? aws_backup_vault.vault_custom_encryption.0.recovery_points : aws_backup_vault.vault_default_encryption.0.recovery_points
}

output "backup_plan_id" {
  description = "Id of AWS Backup Plan"
  value       = aws_backup_plan.backup_plan.id
}

output "backup_plan_version" {
  description = "AWS Backup Plan Version"
  value       = aws_backup_plan.backup_plan.version
}
