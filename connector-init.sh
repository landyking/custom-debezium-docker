#!/bin/bash

# Wait for Kafka Connect listener
echo "Waiting for Kafka Connect to start listening on $CONNECT_REST_HOST_NAME:$CONNECT_REST_PORT"
while : ; do
    curl_status=$(curl -s -o /dev/null -w %{http_code} http://$CONNECT_REST_HOST_NAME:$CONNECT_REST_PORT/connectors)
    echo -e $(date) " Kafka Connect listener HTTP state: " $curl_status " (waiting for 200)"
    if [ $curl_status -eq 200 ] ; then
        break
    fi
    sleep 5 
done

json_files=`ls /opt/kafka-connect/connectors/*.json`
if [ -z $json_files ] ; then
    echo "can't found json files in /opt/kafka-connect/connectors. ##### exit #####"
    kill 1
fi
for entry in $json_files
do
    connector_name=`basename $entry|cut -d'.' -f1`
    echo "try create connector[$connector_name]"
    curl_status=$(curl -s -o /dev/null -w %{http_code} -X PUT http://$CONNECT_REST_HOST_NAME:$CONNECT_REST_PORT/connectors/$connector_name/config \
        -H 'Content-Type: application/json; charset=utf-8' \
        -d "@$entry")
    if [ ! $curl_status -eq 200 ] ; then
        echo "create connector[$connector_name] unsuccessfully. response status code: $curl_status . ##### exit #####"
        kill 1
    else
        echo "create connector[$connector_name] successfully"
    fi
done

echo "###################################################"
echo "######## Connectors Initialize Over ###############"
echo "###################################################"