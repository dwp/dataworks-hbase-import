#!/bin/bash

SNAPSHOT_NAME=$1
SNAPSHOT_SOURCE_BUCKET=$2
SNAPSHOT_SOURCE_PREFIX=$3

HBASE_ROOT_BUCKET=${hbase_root_bucket}
HBASE_ROOT_DIR=${hbase_root_dir}


echo "importing snapshot '$${SNAPSHOT_NAME}' from 's3://$${SNAPSHOT_SOURCE_BUCKET}/$${SNAPSHOT_SOURCE_PREFIX}'"
hbase snapshot export -snapshot $${SNAPSHOT_NAME} -copy-from s3://$${SNAPSHOT_SOURCE_BUCKET}/$${SNAPSHOT_SOURCE_PREFIX} -copy-to s3://$${HBASE_ROOT_BUCKET}/$${HBASE_ROOT_DIR}
if [ $? != 0 ]; then
    echo "import failed. exiting..."
    exit 1
else
    echo "import finished"
fi
