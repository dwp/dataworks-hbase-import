data "template_file" "hbase_snapshot_importer_script" {
  template = file("files/hbase-snapshot-importer.sh.tpl")
  vars = {
        snapshot_source_bucket = local.snapshot_source_bucket
        snapshot_source_prefix = local.snapshot_source_prefix
        hbase_root_bucket = local.hbase_root_bucket
        hbase_root_dir = local.hbase_root_dir
  }
}

resource "aws_s3_bucket_object" "hbase_snapshot_importer_script" {
  bucket     = data.terraform_remote_state.common.outputs.config_bucket.id
  key        = "component/hbase-importer/hbase-snapshot-importer.sh"
  content    = data.template_file.hbase_snapshot_importer_script.rendered
  kms_key_id = data.terraform_remote_state.common.outputs.config_bucket_cmk.arn
}

data "local_file" "hbase_snapshot_restorer_script" {
  filename = "files/hbase-snapshot-restorer.sh"
}

resource "aws_s3_bucket_object" "hbase_snapshot_restorer_script" {
  bucket     = data.terraform_remote_state.common.outputs.config_bucket.id
  key        = "component/hbase-importer/hbase-snapshot-restorer.sh"
  content    = data.local_file.hbase_snapshot_restorer_script.content
  kms_key_id = data.terraform_remote_state.common.outputs.config_bucket_cmk.arn
}

