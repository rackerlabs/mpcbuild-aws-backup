terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.60.0"
  }
}

locals {
  tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
  }

  copy_action = {
    destination_vault_arn = var.replication_vault_arn
  }
}

####### Generate policy for backup service ########
data "aws_iam_policy_document" "backup_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["backup.amazonaws.com"]
      type        = "Service"
    }
  }
}

############ Role for AWS Backup, including managed policy ########

resource "aws_iam_role" "backup_role" {
  assume_role_policy = data.aws_iam_policy_document.backup_assume_policy.json
  name               = "BackupRole-${var.environment}"
}

resource "aws_iam_role_policy_attachment" "backup_role_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

############### Backup vault creation #################

resource "aws_backup_vault" "vault_default_encryption" {
  count = var.create_vault && var.use_cmk ? 0 : 1

  name = var.vault_name
  tags = merge(var.tags, local.tags)
}

resource "aws_backup_vault" "vault_custom_encryption" {
  count = var.create_vault && var.use_cmk ? 1 : 0

  name        = var.vault_name
  tags        = merge(var.tags, local.tags)
  kms_key_arn = var.customer_key_arn
}

############## Backup Rules ###########################

resource "aws_backup_plan" "backup_plan" {
  name = "BackupRulePlan"

  rule {
    rule_name = "BackupRule"
    target_vault_name = element(coalescelist(aws_backup_vault.vault_default_encryption.*.name,
      aws_backup_vault.vault_custom_encryption.*.name,
    ["Default"]), 0)
    schedule = var.cron_schedule
    lifecycle {
      delete_after = var.retention_days
    }
    dynamic "copy_action" {
      for_each = var.replicate_snapshots ? [local.copy_action] : []
      content {
        destination_vault_arn = copy_action.value.destination_vault_arn
        lifecycle {
          delete_after = var.retention_days
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [rule]
  }
}

############### Selection for AWS Backup by Tag ################
resource "aws_backup_selection" "backup_selection_by_tag" {
  count = var.select_by_tags ? 1 : 0

  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "BackupSelectionByTags"
  plan_id      = aws_backup_plan.backup_plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = var.backup_tag_key
    value = var.backup_tag_value
  }
}

resource "aws_backup_selection" "backup_selection_by_resource" {
  count = var.select_by_resource ? 1 : 0

  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "BackupSelectionByResources"
  plan_id      = aws_backup_plan.backup_plan.id
  resources    = concat(var.ebs_arns, var.ec2_arns, var.efs_arns, var.rds_arns, var.dynamodb_arns)
}
