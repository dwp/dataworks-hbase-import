#!/bin/bash

SNAPSHOT_NAME=$1
SNAPSHOT_SOURCE_LOCATION=$2

HBASE_ROOT_BUCKET=${hbase_root_bucket}
HBASE_ROOT_DIR=${hbase_root_dir}


echo "importing snapshot $${SNAPSHOT_NAME} from $${SNAPSHOT_SOURCE_LOCATION}"
hbase snapshot export -snapshot $${SNAPSHOT_NAME} -copy-from s3a://$${SNAPSHOT_SOURCE_LOCATION} -copy-to s3a://$${HBASE_ROOT_BUCKET}/$${HBASE_ROOT_DIR}
if [ $? != 0 ]; then
    echo "import failed. exiting..."
    exit 1
else
    echo "import finished"
fi

