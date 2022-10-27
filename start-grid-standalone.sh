#!/bin/bash -x

jps | grep selenium | awk '{print $1}' | while read line; do
    echo 'Killing process id ' $line
    kill -9 $line
done

SELENIUM_JAR="selenium-server-4.5.3.jar"
JAEGAR_JVM_ARGS="-Dotel.traces.exporter=jaeger -Dotel.exporter.jaeger.endpoint=http://localhost:14250 "
COURSIER="$(coursier fetch -p io.opentelemetry:opentelemetry-exporter-jaeger:1.19.0 io.grpc:grpc-netty:1.50.2)"
 
java $JAEGAR_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-standalone \
     -jar  $SELENIUM_JAR --ext $COURSIER standalone