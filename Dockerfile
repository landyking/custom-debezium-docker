FROM debezium/connect:1.7

USER root
RUN sed -i '285 a /connector-init.sh &' /docker-entrypoint.sh
COPY connector-init.sh /
RUN chmod +x /connector-init.sh
RUN mkdir -p /opt/kafka-connect/connectors
RUN chown kafka:kafka /opt/kafka-connect/connectors

USER kafka

ENV GROUP_ID=iotcdc \
    CONFIG_STORAGE_TOPIC=iotcdc-connect-configs \
    OFFSET_STORAGE_TOPIC=iotcdc-connect-offsets \
    STATUS_STORAGE_TOPIC=iotcdc-connect-status \
    CONNECT_KEY_CONVERTER_SCHEMAS_ENABLE=false \
    CONNECT_VALUE_CONVERTER_SCHEMAS_ENABLE=false \
    BOOTSTRAP_SERVERS=kafka-1:9092,kafka-2:9092,kafka-3:9092

