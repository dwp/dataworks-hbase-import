locals {
    snapshot_source_bucket = data.terraform_remote_state.hbase_export.outputs.hbase_export_bucket.id
    snapshot_source_prefix = "snapshots"
    hbase_root_bucket = data.terraform_remote_state.internal_compute.outputs.aws_emr_cluster.root_bucket
    hbase_root_dir = data.terraform_remote_state.internal_compute.outputs.aws_emr_cluster.root_directory

    source_hbase_snapshot_environment = var.source_hbase_snapshot_workspace == "default" ? "development" : var.source_hbase_snapshot_workspace
}