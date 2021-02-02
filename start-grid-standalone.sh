#!/bin/bash -x

ps auxw | grep selenium-server-4.0.0-alpha-7.jar | awk '{print $2}' | xargs kill
 
java -DJAEGER_SERVICE_NAME="selenium-standalone" \
    -DJAEGER_AGENT_HOST=localhost \
    -DJAEGER_AGENT_PORT=14250 \
    -jar selenium-server-4.0.0-alpha-7.jar \
    --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.9.1 \
        io.grpc:grpc-netty:1.32.1) \
    standalone
