output "hbase_snapshot_importer_script" {
  value = "s3://${data.terraform_remote_state.common.outputs.config_bucket.id}/${aws_s3_bucket_object.hbase_snapshot_importer_script.key}"
}

output "hbase_snapshot_restorer_script" {
  value = "s3://${data.terraform_remote_state.common.outputs.config_bucket.id}/${aws_s3_bucket_object.hbase_snapshot_restorer_script.key}"
}