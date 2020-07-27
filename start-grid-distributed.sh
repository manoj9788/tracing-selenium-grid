#!/bin/bash -x

java -DJAEGER_SERVICE_NAME="selenium-session-map" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.6.0 \
        io.grpc:grpc-okhttp:1.29.0) \
     sessions &
    
sleep 2

java -DJAEGER_SERVICE_NAME="selenium-distributor" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.6.0 \
        io.grpc:grpc-okhttp:1.29.0) \
     distributor --sessions http://localhost:5556 &

sleep 2

java -DJAEGER_SERVICE_NAME="selenium-router" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.6.0 \
        io.grpc:grpc-okhttp:1.29.0) \
     router --sessions http://localhost:5556 --distributor http://localhost:5553 &

sleep 2

java -DJAEGER_SERVICE_NAME="selenium-node" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.6.0 \
        io.grpc:grpc-okhttp:1.29.0) \
     node -D selenium/standalone-firefox:3.141.59 '{"browserName": "firefox"}' &
     
