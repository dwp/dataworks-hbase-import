#!/bin/bash

COMMAND=$1
SNAPSHOT_NAME=$2
TABLE_NAME=$3

function clone_snapshot() {
    if [ -z "${TABLE_NAME}" ]; then
        echo "'clone' command expects 'TABLE_NAME' argument, exiting..."
        exit 1
    fi

    if check_if_table_exists ${TABLE_NAME}; then
        echo "cannot clone snapshot '${SNAPSHOT_NAME}' as table with name '${TABLE_NAME}' already exists, exiting..."
        exit 1
    fi

    echo "cloning snapshot '${SNAPSHOT_NAME}' into table '${TABLE_NAME}"
    echo "clone_snapshot '${SNAPSHOT_NAME}', '${TABLE_NAME}'" | hbase shell -n
    if [ $? != 0 ]; then
        echo "restore failed. exiting..."
        exit 1
    else
        echo "restore finished"
    fi
}

function restore_snapshot() {    
    table=$(get_table_name_from_snapshot)

    if check_if_table_exists $table; then
        disable_table ${table}
    fi

    echo "restoring snapshot '${SNAPSHOT_NAME}'"
    echo "restore_snapshot '${SNAPSHOT_NAME}'" | hbase shell -n
    if [ $? != 0 ]; then
        echo "restore failed. exiting..."
        exit 1
    else
        echo "restore finished"
    fi
}

function check_if_table_exists() {
    local table_name=$1

    echo "checking if table '${table_name}' exists"
    if echo -e "exists '${table_name}'" | hbase shell 2>&1 | grep -q "does exist" 2>/dev/null 
    then
        echo "Table '${table_name}' exists"
        return 0
    else
        echo "Table '${table_name}' does not exist"
        return 1
    fi
}

function disable_table() {
    local table=$1

    echo "disabling table '${table}'"
    echo "disable '${table}'" | hbase shell -n
    if [ $? != 0 ]; then
        echo "disable table failed. exiting..."
        exit 1
    else
        echo "disable table finished"
    fi
}

function get_table_name_from_snapshot() {
    local table_name=$( hbase snapshot info -snapshot "${SNAPSHOT_NAME}" | sed -n -e 's/^.*Table: //p' )
    echo $table_name
}

case $COMMAND in
    clone)
        clone_snapshot
        ;;

    restore)
        restore_snapshot
        ;;

    *)
        echo "unknown command"
        ;;
esac
