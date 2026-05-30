# Per-Thread MySQL Connection Model

This document describes the database concurrency rework done to fix mass-login
stalls, why it was done this way, and the changes that build on top of it
(asynchronous player load and thread-safe player save).

> TL;DR: the server used a **single MySQL connection guarded by one global
> mutex**, so *every* database query in the whole server ran one at a time. Under
> mass login (hundreds/thousands of characters at once) the dispatcher (game-loop)
> thread spent its time blocked on serialized DB I/O — the server "froze" with low
> CPU. We replaced it with **one lazily-created MySQL connection per worker
> thread**, made the query hot path **lock-free**, and moved the heavy player load
> off the dispatcher thread.

---

## 1. The problem (before)

`Database` was a singleton holding a single `MYSQL*` handle protected by a
`std::recursive_mutex`:

```cpp
MYSQL* handle = nullptr;
mutable std::recursive_mutex databaseLock;
```

Every `storeQuery` / `executeQuery` / `escapeBlob` acquired `databaseLock`. The
consequences:

- **No DB parallelism anywhere.** Two queries from two threads could never run
  at the same time, even on a 12-core machine.
- **The login path made it worse.** `ProtocolGame::login()` ran on the single
  **dispatcher thread** (the game loop) and called `IOLoginData::loadPlayerById`,
  which issues ~20 sequential SQL queries per character. With 500–1000 logins,
  the dispatcher was stuck doing serialized I/O → the world stopped updating
  (movement, combat, `SERVER_BEAT`) even though CPU was mostly idle.
- A single global lock also meant InnoDB **deadlocks were impossible** — which
  sounds nice, but it hid the fact that nothing was concurrent.

## 2. The new model: one connection per worker thread

`Database` no longer owns a single handle. Instead, each thread that touches the
database gets **its own** `ConnectionContext`, created lazily on first use:

```cpp
struct ConnectionContext {
    MYSQL* handle = nullptr;
    uint64_t maxPacketSize = 1048576;
    unsigned int lastErrno = 0;   // for transaction deadlock retry
    ~ConnectionContext();         // mysql_close
};
```

- A `thread_local ConnectionContext*` cache makes the hot path a pointer lookup
  with **no locking**.
- A central `std::vector<std::unique_ptr<ConnectionContext>>` owns the contexts
  so they can all be closed at shutdown. A `std::mutex` guards this vector, but
  it is only taken **once per thread** (when that thread opens its connection) —
  never on the query hot path.
- The connection parameters are captured once in `connect()` and reused to open
  each new per-thread connection.

```cpp
Database::ConnectionContext &Database::getContext() const {
    thread_local ConnectionContext* tlsContext = nullptr;
    if (tlsContext != nullptr) {
        return *tlsContext;          // hot path: no lock
    }
    // first query on this thread: create + register + establish (cold path)
    ...
}
```

### Why per-thread instead of an explicit acquire/release pool?

The codebase already executes a unit of work (a player load, a player save, a
whole transaction) **entirely on one thread**. With one connection per thread:

- The public API (`Database::getInstance().storeQuery(...)`) is **unchanged** —
  none of the ~150 call sites across ~27 files had to be touched.
- **Transactions and `getLastInsertId()` keep connection affinity for free**: a
  `BEGIN … COMMIT` runs on one thread, hence one connection.
- No object needs to carry a "session"/connection handle around.

An explicit `acquire/release` pool would have required threading a connection
handle through transactions and `getLastInsertId`, touching many call sites — far
more invasive for no real benefit here.

## 3. Lock-free hot path

Because a `ConnectionContext` belongs to exactly one thread (reached only through
that thread's `thread_local` cache), **the handle needs no lock**: no other
thread can ever touch it. `storeQuery` / `executeQuery` / `escapeBlob` simply use
`getContext().handle` directly.

The only remaining mutex (`connectionsMutex`) is **cold path**: it guards the
registry vector during connection creation and shutdown, never during a query.

## 4. Transactions and deadlock handling

With real concurrency, two transactions can now run at the same time, so two
things change:

1. **No global lock to hold open across a transaction.** Previously
   `beginTransaction` locked `databaseLock` and `commit`/`rollback` unlocked it.
   Now a transaction runs entirely on its thread's connection; thread affinity
   alone provides isolation. `beginTransaction/commit/rollback` operate on
   `getContext()`.

2. **InnoDB deadlocks / lock-wait timeouts are now possible** (`ER_LOCK_DEADLOCK`
   = 1213, `ER_LOCK_WAIT_TIMEOUT` = 1205) — they were impossible under the old
   global serialization. Without handling, a deadlock would turn into a *lost
   save*. So:
   - `ConnectionContext::lastErrno` records the error of the last failed query
     (kept here, not read via `mysql_errno`, so it survives an intervening
     rollback).
   - `Database::lastQueryWasDeadlock()` reports whether it was 1213/1205.
   - `DBTransaction::executeWithinTransaction[RollbackOnFailure]` now **retries
     the whole transaction** up to `TRANSACTION_MAX_ATTEMPTS = 3` when a deadlock
     is detected.

## 5. MySQL client library initialization

In a multi-threaded program, `mysql_library_init()` must run **once, before any
thread opens a connection**. `mysql_init()` does this implicitly, but that
implicit init is **not thread-safe** if two threads race on their first
connection. We therefore call `mysql_library_init()` explicitly via
`std::call_once` at the start of `connect()` (which runs single-threaded at
startup), removing the race.

Each per-thread connection also calls `mysql_thread_init()` when it is
established (required by libmysqlclient for thread-local state), and a
`thread_local` cleanup object calls `mysql_thread_end()` when the thread exits
(on that same thread, as libmysqlclient requires).

## 6. Query capture (record-replay) — used by saves

`Database` gained a small **capture mode** used to make player saves thread-safe
(see §8):

```cpp
void beginQueryCapture(std::vector<std::string>* buffer); // RAII: QueryCaptureScope
void endQueryCapture();
```

While a capture is active on the calling thread, `executeQuery()` **appends** its
SQL to the buffer and returns `true` *without executing*. `storeQuery()` is never
captured. This lets a save be **serialized on the dispatcher** (reading the live
`Player` consistently) and **replayed on a pool thread** (pure SQL, no player
access).

> Known limitation: an *incidental* `executeQuery` during a capture (only known
> case: a KV cache eviction, `KVStore::processEvictions`) would also be captured.
> It is rare (needs a new KV key during the build *and* the global KV cache at
> `MAX_SIZE`) and bounded; future hardening is to route evictions asynchronously.

## 7. Consumer: asynchronous player load (login)

With per-thread connections in place, the heavy login load was moved **off the
dispatcher thread**:

- `ProtocolGame::login()` (dispatcher) runs the cheap checks + waiting list, then
  `g_game().reserveLogin(guid)` and dispatches the heavy `loadPlayerById` to the
  thread pool.
- `loadPlayer`/`loadPlayerById` gained a `deferWorldData` flag. The audit found
  that only **2 of ~27** load steps mutate shared global state and therefore are
  unsafe to run on a pool thread:
  - `loadPlayerGuild` → writes the global guild registry (`g_game().addGuild`)
    and mutates a shared `Guild` object.
  - `loadPlayerInitializeSystem` → via the wheel, mutates a shared `Party`.
  When `deferWorldData == true`, these two (plus `updateSystem`/`exiva`, which
  must run *after* `initializeSystem` so wheel bonuses are applied before stats
  are recomputed) are **skipped** on the pool and run later on the dispatcher via
  `IOLoginData::loadPlayerWorldData()`.
- `ProtocolGame::finishLogin()` (dispatcher callback) runs `loadPlayerWorldData`,
  the protection-zone check, `placeCreature`, `acceptPackets = true`, and
  `releaseLogin` on **every** exit path (success, failure, dropped connection).
- `Game::reserveLogin/releaseLogin/isLoginPending` (a dispatcher-only set, no
  lock) reject a second concurrent login of the same character while its load is
  in flight.

Net effect: the ~20-query load no longer blocks the game loop, and N logins load
in parallel across the pool (one connection each).

## 8. Consumer: thread-safe player save

The `SaveManager` already saved players on pool threads, but it **read the live
`Player` on the pool while the dispatcher kept mutating it** — a data race (it
could persist inconsistent state or crash). Fix (record-replay):

- `IOLoginData::savePlayer` split into `buildPlayerSave` (serialize the player to
  SQL — runs on the dispatcher, consistent read) and `flushPlayerSave` (execute
  the SQL in a transaction — runs on the pool, touches no player).
- The `players.save` flag is cached on the `Player` at login
  (`Player::getSaveFlag`), so the build needs **no DB round-trip** and is pure
  CPU.
- Per-player saves are serialized/ordered via `m_flushInFlight` / `m_resavePending`
  / `onPlayerFlushed` so an older flush can never overwrite a newer one.
- `saveAll` was restructured into `buildAllPlayers` (dispatcher) +
  `flushBuiltPlayers` / `saveGuildsMapAndKV` (pool); the global save now builds on
  the dispatcher and only flushes on the pool.

## 9. Observability (logs)

The connection model emits these `info` logs:

- `Database running in per-thread connection mode ...` — once, at startup.
- `Database: opened MySQL connection #N (new worker thread reached the
  database).` — each time a new thread opens its connection (lazy). The count is
  bounded by the number of threads that touch the DB (≈ thread pool size + a
  few), **not** per login. Watching these appear during a mass-login test shows
  the parallelism ramping up.
- `Database: closing N MySQL connection(s).` — at shutdown.

Transaction deadlock retries log a `warn`. The existing
`metrics::query_latency` / `metrics::lock_latency` counters remain useful for
spotting whether the new bottleneck is the thread pool or the MySQL server.

## 10. Trade-offs and limitations

- **The bottleneck moves to the MySQL server and the thread-pool size.** Per-thread
  connections remove the *global lock*, but throughput is now capped by (a) how
  many worker threads exist and (b) what the MySQL server can sustain. For more
  login parallelism, raise the worker count (see §11) and/or reduce the number of
  queries per load.
- **More real TCP connections to MySQL** — one per worker thread. Validate against
  the server's `max_connections` (default 151). With a ~12-thread pool this is a
  non-issue.
- **`mysql_thread_end()`** is called via a `thread_local` cleanup object when a
  thread that opened a connection exits, releasing libmysqlclient's per-thread
  TLS.
- **`thread_local` assumes a single `Database` instance** (true in production via
  DI). Test harnesses that create/destroy multiple `Database` instances on the
  same thread should be aware of this.

## 11. Tuning

The number of parallel DB connections equals the number of worker threads that
touch the database, which is driven by the thread pool size
(`DEFAULT_NUMBER_OF_THREADS`, default 4; overridable). For mass-login workloads,
increasing the pool size is the highest-leverage knob, bounded by CPU cores and
MySQL `max_connections`.

## 12. Changed files

| File | Change |
|------|--------|
| `src/database/database.hpp` / `.cpp` | Per-thread `ConnectionContext`, lazy `getContext`, lock-free hot path, `mysql_library_init`, transaction deadlock retry, query capture, connection logs |
| `src/creatures/players/player.hpp` | Cached `save` flag (`getSaveFlag`/`setSaveFlag`) |
| `src/io/iologindata.hpp` / `.cpp` | `deferWorldData` param, `loadPlayerWorldData`, `buildPlayerSave`/`flushPlayerSave` split |
| `src/io/functions/iologindata_load_player.cpp` / `.hpp` | `loadPlayerGuild` self-queries; cache `save` flag in `loadPlayerBasicInfo` |
| `src/io/functions/iologindata_save_player.cpp` | `savePlayerFirst` reads cached `save` flag instead of a SELECT |
| `src/server/network/protocol/protocolgame.hpp` / `.cpp` | `login()` dispatches load to the pool; `finishLogin()` continuation |
| `src/game/game.hpp` / `.cpp` | `reserveLogin`/`releaseLogin`/`isLoginPending` |
| `src/game/scheduling/save_manager.hpp` / `.cpp` | Build-on-dispatcher / flush-on-pool; per-player flush serialization; `saveAll` restructure |
