FROM debezium/connect:2.2.1.Final

USER root
RUN sed -i '322 a /connector-init.sh &' /docker-entrypoint.sh
COPY connector-init.sh /
RUN chmod +x /connector-init.sh
RUN mkdir -p /opt/kafka-connect/connectors
RUN chown kafka:kafka /opt/kafka-connect/connectors

ARG JMX_AGENT_VERSION=0.16.1
RUN mkdir /kafka/etc && cd /kafka/libs &&\
        curl -so jmx_prometheus_javaagent.jar \
        https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/$JMX_AGENT_VERSION/jmx_prometheus_javaagent-$JMX_AGENT_VERSION.jar

COPY config.yaml /kafka/config/metrics.yaml

USER kafka

ENV GROUP_ID=iotcdc \
    CONFIG_STORAGE_TOPIC=iotcdc-connect-configs \
    OFFSET_STORAGE_TOPIC=iotcdc-connect-offsets \
    STATUS_STORAGE_TOPIC=iotcdc-connect-status \
    CONNECT_KEY_CONVERTER_SCHEMAS_ENABLE=false \
    CONNECT_VALUE_CONVERTER_SCHEMAS_ENABLE=false \
    BOOTSTRAP_SERVERS=kafka-1:9092,kafka-2:9092,kafka-3:9092 \
    ENABLE_JMX_EXPORTER=true
