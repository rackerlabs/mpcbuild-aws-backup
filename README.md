# mpcbuild-aws-backup
This module deploy AWS Backup plan to create snapshots of AWS resources

## Basic Usage
```HCL
module "backup" {
  source = "git@github.com:rackerlabs/mpcbuild-aws-backup//?ref=v0.12.0"
  select_by_tags   = true
  vault_name       = "BackupVaultMPC"
  environment      = var.environment
}
```  

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.60.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| backup\_tag\_key | Value of the key for the tag used to select resource to backup | `string` | `"Backup"` | no |
| backup\_tag\_value | Value of the value for the tag used to select resource to backup | `string` | `"true"` | no |
| create\_vault | Create new vault in the account | `bool` | `true` | no |
| cron\_schedule | CRON expression to handle the scheduling of backups | `string` | `"cron(0 5 * * ? *)"` | no |
| customer\_key\_arn | AWS CMK ARN for vault encryption | `string` | `""` | no |
| dynamodb\_arns | List to DynamoDB tables to backup (if resource selection is used, ARN's only') | `list` | `[]` | no |
| ebs\_arns | List to EBS volumes to backup (if resource selection is used, ARN's only) | `list` | `[]` | no |
| ec2\_arns | List to EC2 instances to backup (if resource selection is used, ARN's only) | `list` | `[]` | no |
| efs\_arns | List to EFS file systems to backup (if resource selection is used, ARN's only') | `list` | `[]` | no |
| environment | Application environment for which this resource is being created. Preferred values are Development, Integration, PreProduction, Production, QA, Staging, or Test. | `string` | `"Development"` | no |
| rds\_arns | List to RDS instances to backup (if resource selection is used, ARN's only, Aurora doesn't apply) | `list` | `[]` | no |
| replicate\_snapshots | Copy snapshots to another vault in other region | `bool` | `false` | no |
| replication\_vault\_arn | ARN of the vault used for replication | `string` | `""` | no |
| retention\_days | Time in days that each recovery point will be saved | `number` | `35` | no |
| select\_by\_resource | Backup selection based on tags | `bool` | `false` | no |
| select\_by\_tags | Backup selection based on tags | `bool` | `false` | no |
| tags | Custom tags to apply to all resources. | `map(string)` | `{}` | no |
| use\_cmk | Use AWS CMK to encrypt vault | `bool` | `false` | no |
| vault\_name | Vault Name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| backup\_plan\_id | Id of AWS Backup Plan |
| backup\_plan\_version | AWS Backup Plan Version |
| backup\_recovery\_points | Recovery points of AWS Backup Vault |
| backup\_vault\_id | Id of AWS Backup Vault |

