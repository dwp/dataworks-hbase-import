locals {
    hbase_root_bucket = data.terraform_remote_state.internal_compute.outputs.aws_emr_cluster.root_bucket
    hbase_root_dir = data.terraform_remote_state.internal_compute.outputs.aws_emr_cluster.root_directory
}