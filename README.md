# tracing-selenium-grid

TL;DR: A simple project to showcase Selenium 4's Tracing capability using Jaeger with Selenium Grid

## Observability 
It is a measure of how well internal states of a system can be inferred from knowledge of its external outputs. It helps bring visibility into systems. – Wikipedia

Selenium 4 has number of new exciting features and one such is a cleaner code for Selenium Grid along with support for distributed tracing via OpenTelemetry APIs.
This is pretty exciting and important feature for the admins and devops engineers to trace the flow of control through the Grid for each and every command.

Distributed tracing has two parts:

1. Code instrumentation: Adding instrumentation code in your application to produce traces. The major instrumentation parts are done neatly by the developers of Selenium project, which leaves us to consume it by using Selenium Grid start-up command along with Jaeger.

2. Collection of data and providing meaning over it, Jaeger has a UI which allows us to view traces visually well.

Steps to start tracing your tests,

* Start Jaeger via docker(as its easy)

* Instrument your Selenium Grid start-up command with Jaeger tracing as in start-grid.sh and start-grid-standalone.sh for standalone mode.

* Now execute your tests tests, and navigate to `http://localhost:16686/` to view the outputs.


## Jaeger

Jaeger stores and queries traces exported by applications instrumented with OpenTelemetry. All-in-one is an executable designed for quick local testing, launches the Jaeger UI, collector, query, and agent, with an in memory storage component.

The simplest way to start the all-in-one is to use the pre-built image published to DockerHub (a single command line).

```
$ docker run --rm -it --name jaeger \
    -p 16686:16686 \
    -p 14250:14250 \
    jaegertracing/all-in-one:1.17
  ```
  You can then navigate to http://localhost:16686 to access the Jaeger UI.

