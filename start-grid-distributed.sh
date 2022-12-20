#!/bin/bash -x
jps | grep selenium | awk '{print $1}' | while read line; do
    echo 'Killing process id ' $line
    kill -9 $line
done

SELENIUM_JAR="selenium-server-4.5.3.jar"
JAEGAR_JVM_ARGS="-Dotel.traces.exporter=jaeger -Dotel.exporter.jaeger.endpoint=http://localhost:14250 "
COURSIER="$(coursier fetch -p io.opentelemetry:opentelemetry-exporter-jaeger:1.19.0 io.grpc:grpc-netty:1.50.2)"
java $JAEGAR_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-event-bus \
     -jar  $SELENIUM_JAR --ext $COURSIER \
     event-bus &
sleep 2
java $JAEGAR_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-sessions \
     -jar  $SELENIUM_JAR --ext $COURSIER \
     sessions &
sleep 2
java $JAEGAR_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-session-queue \
     -jar  $SELENIUM_JAR --ext $COURSIER \
     sessionqueue &
sleep 2
java $JAEGAR_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-distributor \
     -jar  $SELENIUM_JAR --ext $COURSIER \
     distributor --sessions http://localhost:5556 --sessionqueue http://localhost:5559 --bind-bus false &
sleep 2
java $JAEGAR_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-router \
     -jar  $SELENIUM_JAR --ext $COURSIER \
     router --sessions http://localhost:5556 --distributor http://localhost:5553 --sessionqueue http://localhost:5559 &
sleep 2
java $JAEGAR_JVM_ARGS \
     -Dotel.resource.attributes=service.name=selenium-node \
     -jar  $SELENIUM_JAR --ext $COURSIER node -D selenium/standalone-firefox:4.5.3-20221024 '{"browserName": "firefox"}' &