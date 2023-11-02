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
     -Dotel.resource.attributes=service.name=selenium-event-bus \
     -jar  $SELENIUM_JAR --ext $TRACER_DEPS \
     event-bus &
sleep 2
java $OTEL_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-sessions \
     -jar  $SELENIUM_JAR --ext $TRACER_DEPS \
     sessions &
sleep 2
java $OTEL_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-session-queue \
     -jar  $SELENIUM_JAR --ext $TRACER_DEPS \
     sessionqueue &
sleep 2
java $OTEL_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-distributor \
     -jar  $SELENIUM_JAR --ext $TRACER_DEPS \
     distributor --sessions http://localhost:5556 --sessionqueue http://localhost:5559 --bind-bus false &
sleep 2
java $OTEL_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-router \
     -jar  $SELENIUM_JAR --ext $TRACER_DEPS \
     router --sessions http://localhost:5556 --distributor http://localhost:5553 --sessionqueue http://localhost:5559 &
sleep 2
java $OTEL_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-node \
     -jar  $SELENIUM_JAR --ext $TRACER_DEPS node -D selenium/standalone-firefox:4.5.3-20221024 '{"browserName": "firefox"}' &
