## Introduction

This image is customized according to [Debezium Connect 1.7](https://github.com/debezium/docker-images/tree/main/connect/1.7).

## Build image

```
cd custom-debezium-docker/
docker build -t landykingdom/debezium:1.7 .
```

## Run container

Prepare connector json files. Example json:

```json
{
  "connector.class": "io.debezium.connector.mysql.MySqlConnector",
  "database.hostname": "your mysql host",
  "database.port": "3306",
  "database.user": "your mysql account",
  "database.password": "your mysql password",
  "database.server.id": "your mysql id",
  "database.server.name": "your server name",
  "database.include.list": "your database",
  "table.include.list": "your tables",
  "database.history.kafka.bootstrap.servers": "kafka:9092",
  "database.history.kafka.topic": "your history topic",
  "include.schema.changes": "false",
  "tombstones.on.delete": "false",
  "transforms": "rename",
  "transforms.rename.type": "io.debezium.transforms.ByLogicalTableRouter",
  "transforms.rename.topic.regex": "^(.*)\\.(.*)\\.(.*)$",
  "transforms.rename.topic.replacement": "$1-$2-$3"
}
```

Start a container. 
Assume that connector json files is in the `/your-connectors-dir` directory.

```shell
docker run -it --rm --name debezium-connect -e BOOTSTRAP_SERVERS=your-kafka:9092 -v /your-connectors-dir:/opt/kafka-connect/connectors landykingdom/debezium:1.7
```
