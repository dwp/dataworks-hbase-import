data "template_file" "hbase_snapshot_importer_script" {
  template = file("files/hbase-snapshot-importer.sh.tpl")
  vars = {
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

data "aws_iam_policy_document" "hbase_s3_import" {
  statement {
    sid    = "GetSnapshotFromExportBucket"
    effect = "Allow"

    actions = [
      "kms:Decrypt"
    ]

    resources = [
      data.terraform_remote_state.hbase_export.outputs.hbase_export_bucket.key_arn,
    ]
  }
}

resource "aws_iam_policy" "hbase_s3_import" {
  name        = "IngestHbaseS3Import"
  description = "Allow Ingestion EMR cluster to import HBASE Snapshots from the export bucket"
  policy      = data.aws_iam_policy_document.hbase_s3_import.json
}

resource "aws_iam_role_policy_attachment" "emr_ingest_hbase_main" {
  role       = data.terraform_remote_state.internal_compute.outputs.emr_instance_role.id
  policy_arn = aws_iam_policy.hbase_s3_import.arn
}
