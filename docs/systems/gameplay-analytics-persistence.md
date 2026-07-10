# Gameplay Analytics persistence

Gameplay Analytics keeps combat collection independent from database latency. Hits, healing, experience, supplies and loot are accumulated in memory. Completed sessions enter a bounded queue and are persisted during a flush.

## Detail batching

`detailBatchSize` controls the maximum number of aggregate rows included in one multi-row `INSERT ... ON DUPLICATE KEY UPDATE` statement. The default is `250`; runtime clamping restricts the value to `1–1000`.

A typical completed session therefore uses:

1. one upsert for `analytics_sessions`;
2. one batched upsert for its monster rows;
3. one batched upsert for its spell rows;
4. one batched upsert for its damage-type rows;
5. one batched upsert for its supply rows;
6. one batched upsert for its loot rows.

Empty categories issue no query. Categories with more than `detailBatchSize` rows are split into deterministic chunks. This prevents a session with unusually many distinct monsters, spells or items from producing an unbounded SQL statement or approaching MariaDB `max_allowed_packet` unexpectedly.

The upsert semantics remain idempotent. A partially written session can be retried without adding its counters twice. Failure of any batch requeues the complete session through the reliability layer.

## Operational counters

`/analytics status` includes:

- `detailBatchSize` — effective configured limit;
- `detailBatchQueries` — batch statements attempted since startup;
- `detailRowsPersisted` — detail rows written successfully;
- `largestDetailBatch` — largest batch observed since startup.

These counters are process-local and reset after restart. They do not create high-cardinality Prometheus labels.

## Tuning

Keep the default until production data shows a reason to change it. Lower values reduce individual statement size but increase query count. Higher values reduce round trips but increase SQL string size and temporary memory use.

Recommended starting range:

```lua
detailBatchSize = 100 -- conservative
-- to
detailBatchSize = 250 -- default
```

Values above `1000` are clamped. Before increasing the default, verify flush duration, database CPU, network latency and MariaDB `max_allowed_packet`.
