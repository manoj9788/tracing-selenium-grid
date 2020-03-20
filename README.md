# tracing-selenium-grid

A simple project to showcase Selenium 4's Tracing capability using Jaeger client with Selenium Grid

## Jaeger

All-in-one is an executable designed for quick local testing, launches the Jaeger UI, collector, query, and agent, with an in memory storage component.

The simplest way to start the all-in-one is to use the pre-built image published to DockerHub (a single command line).

```
$ docker run -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HTTP_PORT=9411 \
  -p 5775:5775/udp \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 14268:14268 \
  -p 14250:14250 \
  -p 9411:9411 \
  jaegertracing/all-in-one:1.17
  ```
  You can then navigate to http://localhost:16686 to access the Jaeger UI.

