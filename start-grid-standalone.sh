#!/bin/bash -x

ps auxw | grep selenium-server-4.0.0-alpha-5.jar | awk '{print $2}' | xargs kill
 
java -DJAEGER_SERVICE_NAME="selenium-standalone" \
    -DJAEGER_AGENT_HOST=localhost \
    -DJAEGER_AGENT_PORT=14250 \
    -jar selenium.jar \
    --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.2.0 \
        io.grpc:grpc-okhttp:1.26.0) \
    standalone