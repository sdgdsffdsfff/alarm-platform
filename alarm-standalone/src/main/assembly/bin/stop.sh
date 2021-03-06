#!/bin/bash
. `dirname $0`/env.sh
cd $DEPLOY_DIR

SERVER_NAME=`sed '/dubbo.application.name/!d;s/.*=//' $CONF_FILE | tr -d '\r'`

if [ -z "$SERVER_NAME" ]; then
    SERVER_NAME=`hostname`
fi

PIDS=`ps -ef | grep java | grep "$CONF_DIR" |awk '{print $2}'`
if [ -z "$PIDS" ]; then
    echo "ERROR: The $SERVER_NAME does not started!"
    exit 1
fi

if [ "$1" == "dump" ]; then
    /bin/sh $BIN_DIR/dump.sh
fi

echo "Stopping the $SERVER_NAME($PIDS) ..."
for PID in $PIDS ; do
    kill $PID > /dev/null 2>&1
done

COUNT=0
while [ $COUNT -lt 1 ]; do    
    echo "checking pids[$PIDS]"
    sleep 1
    COUNT=1
    for PID in $PIDS ; do
        PID_EXIST=`ps -f -p $PID | grep java`
        if [ -n "$PID_EXIST" ]; then
            COUNT=0
            break
        fi
    done
done

echo "OK!"
