#!/bin/bash -x
java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-standalone \
     -jar selenium-beta-4.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.0.0 \
        io.grpc:grpc-netty:1.35.0) \
     event-bus &
sleep 2
java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-standalone \
     -jar selenium-beta-4.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.0.0 \
        io.grpc:grpc-netty:1.35.0) \
     sessions &
sleep 2
java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-standalone \
     -jar selenium-beta-4.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.0.0 \
        io.grpc:grpc-netty:1.35.0) \
     sessionqueuer &
sleep 2
java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-standalone \
     -jar selenium-beta-4.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.0.0 \
        io.grpc:grpc-netty:1.35.0) \
     distributor --sessions http://localhost:5556 --sessionqueuer http://localhost:5559 --bind-bus false &
sleep 2
java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-standalone \
     -jar selenium-beta-4.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.0.0 \
        io.grpc:grpc-netty:1.35.0) \
     router --sessions http://localhost:5556 --distributor http://localhost:5553 &
sleep 2
java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-standalone \
     -jar selenium-beta-4.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.0.0 \
        io.grpc:grpc-netty:1.35.0) \
     node -D selenium/standalone-firefox:3.141.59 '{"browserName": "firefox"}' &