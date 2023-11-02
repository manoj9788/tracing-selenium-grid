#!/bin/bash -x

jps | grep selenium | awk '{print $1}' | while read line; do
    echo 'Killing process id ' $line
    kill -9 $line
done

./mvnw dependency:copy-dependencies -DincludeScope=runtime

SELENIUM_JAR="selenium-server.jar"
TRACER_DEPS="./target/dependency"
OTEL_JVM_ARGS="-Dotel.traces.exporter=otlp -Dotel.java.global-autoconfigure.enabled=true"
 
java $OTEL_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-standalone \
     -jar  $SELENIUM_JAR --ext $TRACER_DEPS standalone --selenium-manager true --log-level FINE
