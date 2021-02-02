#!/bin/bash -x
java -DJAEGER_SERVICE_NAME="selenium-event-bus" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server-4.0.0-alpha-7.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.9.1 \
        io.grpc:grpc-netty:1.32.1) \
     event-bus &
sleep 2
java -DJAEGER_SERVICE_NAME="selenium-session-map" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server-4.0.0-alpha-7.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.9.1 \
        io.grpc:grpc-netty:1.32.1) \
     sessions &
sleep 2
java -DJAEGER_SERVICE_NAME="selenium-session-queuer" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server-4.0.0-alpha-7.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.9.1 \
        io.grpc:grpc-netty:1.32.1) \
     sessionqueuer &
sleep 2
java -DJAEGER_SERVICE_NAME="selenium-distributor" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server-4.0.0-alpha-7.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.9.1 \
        io.grpc:grpc-netty:1.32.1) \
     distributor --sessions http://localhost:5556 --sessionqueuer http://localhost:5559 --bind-bus false &
sleep 2
java -DJAEGER_SERVICE_NAME="selenium-router" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server-4.0.0-alpha-7.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.9.1 \
        io.grpc:grpc-netty:1.32.1) \
     router --sessions http://localhost:5556 --distributor http://localhost:5553 &
sleep 2
java -DJAEGER_SERVICE_NAME="selenium-node" \
     -DJAEGER_AGENT_HOST=localhost \
     -DJAEGER_AGENT_PORT=14250 \
     -jar selenium-server-4.0.0-alpha-7.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporters-jaeger:0.9.1 \
        io.grpc:grpc-netty:1.32.1) \
     node -D selenium/standalone-firefox:3.141.59 '{"browserName": "firefox"}' &