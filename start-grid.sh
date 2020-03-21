#!/bin/bash -x

java -DJAEGER_SERVICE_NAME="selenium-session-map" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.2.0 \
        io.grpc:grpc-okhttp:1.26.0) \
     sessions &
    
sleep 2

java -DJAEGER_SERVICE_NAME="selenium-distributor" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.2.0 \
        io.grpc:grpc-okhttp:1.26.0) \
     distributor -s http://localhost:5556 &

sleep 2

java -DJAEGER_SERVICE_NAME="selenium-router" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.2.0 \
        io.grpc:grpc-okhttp:1.26.0) \
     router -s http://localhost:5556 -d http://localhost:5553 &

sleep 2

java -DJAEGER_SERVICE_NAME="selenium-node" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.2.0 \
        io.grpc:grpc-okhttp:1.26.0) \
     node -D selenium/standalone-firefox:3.141.59 '{"browserName": "firefox"}' &
     
