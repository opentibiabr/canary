# Canary Metrics (OpenTelemetry)

By default, no metrics are collected or exported. To enable metrics, you must setup a metrics exporter. The following example shows how to setup a Prometheus exporter.

config.lua

```lua
metricsEnablePrometheus = true
metricsPrometheusAddress = "0.0.0.0:9464"
```

This, in and of itself will expose a Prometheus endpoint at `http://localhost:9464/metrics`. However, you will need to configure Prometheus to scrape this endpoint.

The easiest, batteries included way, to do this is using the provided `docker-compose.yml` file provided in this `metrics` directory. Simply run `docker-compose up` and you will have a Prometheus instance running and scraping the Canary metrics endpoint.

The `docker-compose.yml` file also includes a Grafana instance that is preconfigured to use the Prometheus instance as a data source. The Grafana instance is exposed at `http://localhost:3000` and the default username and password are `admin` and `admin` respectively (you will be prompted to change the password on first login).

## Metrics

We export all kinds of metrics, but the most important ones are:

- Latency metrics for C++ methods
- Latency metrics for Lua functions
- Latency metrics for SQL queries
- Latency metrics for Dispatcher tasks
- Latency metrics for DB Lock contention

## Analytics

We also export analytic event, counters and other useful data. This is useful for debugging and understanding the behavior of the server. Some interesting ones are:

- Stats around monsters killed (per monster type, player, etc)
- Stats around raw exp and total exp gained
- Stats around wealth gained (based on gold and item drops, with their NPC value)
