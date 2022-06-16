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
  description = "Allow Ingestion EMR cluster to import HBASE Snapshots from the export bucket in ${local.source_hbase_snapshot_environment}"
  policy      = data.aws_iam_policy_document.hbase_s3_import.json
}

resource "aws_iam_role_policy_attachment" "emr_ingest_hbase_main" {
  role       = data.terraform_remote_state.internal_compute.outputs.emr_instance_role.id
  policy_arn = aws_iam_policy.hbase_s3_import.arn
}
