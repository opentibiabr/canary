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

## Usage

This is an **advanced** feature. While you can simply enable OStream and get metrics in your logs, that is not recommended to do in production. Prometheus can be run efficiently in production with minimal impact to server performance.

_Enabling OStream:_

```config.lua
metricsEnableOstream = true
metricsOstreamInterval = 1000
```

If you **don't** how what Prometheus and Grafana are, you need to learn that first: https://prometheus.io/ is your starting point. You can come back to this feature once you've understood how to install and run this software.

## Metrics

We export all kinds of metrics, but the most important ones are:

Here's an interactive demo of a dashboard from a real production server: https://snapshots.raintank.io/dashboard/snapshot/bpiq45inK3I2Xixa2d7oNHWekdiDE6zr

- Latency metrics for C++ methods
- Latency metrics for Lua functions
- Latency metrics for SQL queries
- Latency metrics for Dispatcher tasks
- Latency metrics for DB Lock contention

**Screenshot**
![grafana](https://github.com/opentibiabr/canary/assets/223760/b307c335-9af9-4c1a-bf7e-5c3dc86a016d)

## Analytics

We also export analytic event, counters and other useful data. This is useful for debugging and understanding the behavior of the server. Some interesting ones are:

- Stats around monsters killed (per monster type, player, etc)
- Stats around raw exp and total exp gained
- Stats around wealth gained (based on gold and item drops, with their NPC value)

### Examples:

_Note: you can normally see player names here, I've hidden those for privacy._

**Raw exp/h**
![exp-per-hour](https://github.com/opentibiabr/canary/assets/223760/3a873aca-f2e4-4d19-8e61-ed20c176a30f)

**Raw gold/h**
![gold-per-hour](https://github.com/opentibiabr/canary/assets/223760/1c0d1e99-c4b9-4d9a-aced-75ac376b4673)

**Monsters killed/h**
![monsters-per-hour](https://github.com/opentibiabr/canary/assets/223760/4d8c9e19-d579-4405-a018-fc69c79a11c2)
