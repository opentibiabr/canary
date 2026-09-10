# Hardware Sizing and Capacity Planning

Size a Canary server for its map, scripts, player activity and target response
times. Estimate a range for that workload and build, with reserve for busy
periods; online population alone does not determine RAM or CPU requirements.

## Measure Player Activity

The same number of connected players can generate very different workloads:

| Activity | Work to account for |
| --- | --- |
| Idle or online training | Connected player state, periodic updates, training actions and any recurring spells or custom scripts. Training still consumes resources. |
| Hunting | Movement, pathfinding, active monster AI, combat, loot, scripts and updates sent to nearby players. |
| Crowded events or PvP | Interactions between nearby creatures, area effects and updates reaching many spectators. Concentrated activity can cost more than the same population spread across the map. |

Compare similar activity mixes; a multiplier such as "one hunter equals five
trainers" needs measurement. Count actual connected sessions consistently:
website/status counters may apply filters, and offline training is not a
connected session. Total spawned monsters also differ from active monsters.

## Collect a Representative Baseline

Start with a full weekly cycle, including busy hours, saves and events; two to
four weeks can improve coverage. Even a long record with little load variation
cannot establish the cost of growth.

Record these measurements over aligned time windows:

- **Population:** actual online sessions and available aggregate activity counters.
- **CPU:** process, dispatcher and worker utilization, plus host contention and
  VM limits. A saturated dispatcher can constrain the game while other cores idle.
- **Memory:** resident memory (RSS), available host memory, swap and memory
  pressure. Account for the database, website and other services on the machine.
- **Service quality:** queue/scheduling delays, errors and rejected work where
  exposed. Keep averages, p95/p99, maxima and overload duration, with the sampling
  window stated. A p99 covers 99% of observations; it is not a maximum.
- **Context:** build, configuration, map, hardware and uptime. Separate records
  after substantial changes.

On Linux and supported Windows versions, threads are named `canary-dispatch`
for the dispatcher, `canary-wrk-N` for general pool workers, and `canary-ai`
for dedicated monster compute workers. These labels help identify CPU activity
in thread views of tools that display OS thread names, such as `htop`, `ps` and
`perf` on Linux;
use the process/thread IDs to distinguish workers sharing a label. Windows uses
[`SetThreadDescription`](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-setthreaddescription),
available from Windows 10 version 1607 and Windows Server 2016, with runtime
detection so older systems retain their default names. Thread naming is
best-effort and runs at startup, without per-task renaming. Other platforms
currently keep their default names.
Threads share process memory; do not sum RSS repeated in a thread view when
estimating the server's RAM usage.

Consider cheap OS counters every 5 seconds and population snapshots every
30–60 seconds. Validate overhead, bound retention and analyze outside the game
process. Five-second averages can hide shorter spikes. Avoid frequent scans of
game entities, full memory-map scans, continuous profiling and per-player logging
for this initial estimate. For optional application telemetry, see
[Metrics](../metrics/README.md); check availability and overhead before enabling it.

Utilization should be interpreted alongside latency and saturation, as described
in [Google SRE's monitoring guidance](https://sre.google/sre-book/monitoring-distributed-systems/).
Linux documents [RSS and available memory](https://docs.kernel.org/filesystems/proc.html)
and [resource pressure (PSI)](https://docs.kernel.org/accounting/psi.html).
RSS is approximate and does not represent total host memory demand.

## Calculate Average and Incremental Resource Use

Express process CPU in **core equivalents** so percentages have an explicit
denominator:

```text
CPU core equivalents = change in process CPU seconds / elapsed wall seconds
```

For example, 0.40 core equivalents means 40% of one logical CPU, not 40% of the
whole machine. A multithreaded process can exceed 1.0.

For comparable, stable windows, let `N` be the average online session count,
`R` the average RSS in MiB and `C` the CPU core equivalents:

```text
Average RAM per online session = R / N                         (N > 0)
Average CPU per online session = C / N                         (N > 0)
Estimated additional RAM per session = (R2 - R1) / (N2 - N1)   (N2 > N1)
Estimated additional CPU per session = (C2 - C1) / (N2 - N1)   (N2 > N1)
```

**Illustrative numbers only; these are not measured Canary requirements:**

| Comparable window | Average online sessions | Average RSS | CPU core equivalents |
| --- | ---: | ---: | ---: |
| A | 100 | 4,000 MiB | 0.40 |
| B | 200 | 5,000 MiB | 0.65 |

The average RAM per session falls from **40 MiB** to **25 MiB**, because shared
memory is spread across more sessions. The estimated incremental use is
**10 MiB** and **0.0025 core equivalents** per additional session. The implied
RAM baseline is **3,000 MiB**: doubling population need not double total memory.

Real estimates need more windows with comparable activity, world state and
uptime. Map loading, items, Lua state, caches and allocator retention affect RAM;
RSS may stay high after players leave. Investigate persistent growth at similar
loads. Estimate peaks separately from averages, validate predictions on later
days, and report uncertainty. Do not project far beyond the observed population
or infer a player limit from average CPU alone: consumed CPU can plateau while
queues and delays continue growing.

## Choose Hardware and Review Capacity

Compare machines using the same representative Canary workload in a test
environment. Per-core performance, cache, memory latency/bandwidth, build options
and VPS contention matter. DDR4/DDR5 describes performance characteristics, not
a conversion of required RAM capacity. GHz and vCPU counts alone are insufficient;
the [SPEC overview](https://www.spec.org/cpu2017/Docs/overview.html) explains why
the actual application and workload are the best comparison.

- **Increase capacity** before expected busy-period demand exhausts the limiting
  resource. Check whether delays require more resources or a fix for a blocking
  script/database operation.
- **Keep capacity** when service targets and reserve are met, or evidence for a
  smaller machine is insufficient.
- **Consider reducing capacity** after sustained spare capacity across busy
  periods, with a smaller candidate able to cover peaks, retained memory and
  other services. An initial reserve of 25–30% unused capacity is a planning
  example to validate, not a universal safe threshold. A quiet night or restart
  is insufficient evidence.

Use different thresholds and observation periods for increases and reductions,
with a minimum interval between changes. Update recommendations as data arrives;
schedule resizing around maintenance and provider constraints. A stop/start may
be required, as documented for
[Amazon EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/change-instance-type-of-ebs-backed-instance.html).

State the workload, observed population range, limiting resource, uncertainty
and reserve with each recommendation. For financial cost, divide the period's
actual hosting cost by its total connected player-hours; an upgrade instead
depends on plan price differences and migration costs.
