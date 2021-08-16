#!/bin/bash -x

ps auxw | grep selenium-server-4.0.0-alpha-7.jar | awk '{print $2}' | xargs kill
 
java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-standalone \
     -jar selenium-beta-4.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.0.0 \
        io.grpc:grpc-netty:1.35.0) \
    standalone
