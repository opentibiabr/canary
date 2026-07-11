# Multi-channel cluster development example

Brings up MariaDB, Redis, and three Canary channel processes sharing the
same database, the same Redis instance, and the same read-only datapack/
map, per [docs/multichannel/ARCHITECTURE.md](../../docs/multichannel/ARCHITECTURE.md).

**Not build-tested**: the sandbox this PR was authored in had no working
Docker daemon (see [docs/multichannel/TEST_PLAN.md](../../docs/multichannel/TEST_PLAN.md)).
Review the Dockerfile/compose file before relying on this beyond local
experimentation, and expect to iterate on it against a real Docker
environment.

## Topology

| Service | Channel id | PvP type | Login gateway | Host game port | Host status port |
|---|---|---|---|---|---|
| `channel1` | 1 | no-pvp | yes (host port 7171) | 7172 | 7173 |
| `channel2` | 2 | no-pvp | no (internal only) | 8172 | 8173 |
| `channel3` | 3 | pvp | no (internal only) | 9172 | 9173 |

Each channel is the same built image, distinguished only by the
`CANARY_CHANNEL_ID` environment variable read at process startup (see
`ChannelContext`, priority CLI > env > fallback) and by its own generated
`config.lua` (see `entrypoint.sh`).

## Known Phase 1 limitation: every channel still runs its own login listener

This PR wires the channel-aware login *character list* (§3.2), but does
**not** yet gate whether a given process actually starts its login
listener based on `loginProtocolEnabled`/`channels.login_gateway` - that
runtime gating is Phase 2 work (see
[ARCHITECTURE.md §3.2](../../docs/multichannel/ARCHITECTURE.md)). In this
example, that's worked around at the Docker layer instead: only
`channel1`'s login port (7171) is published to the host. `channel2` and
`channel3` still run a login listener internally, but nothing outside
their container network can reach it, so the practical effect is the same
as having a single login gateway. Once Phase 2 lands, this workaround can
be removed.

## Prerequisites

- Docker with Compose v2.
- The map file must already exist at
  `data-otservbr-global/world/otservbr.otbm` in your checkout (or whichever
  `mapName`/datapack you use) before starting the stack - it is mounted
  read-only and shared by all three channels, so no channel can trigger a
  first-time download. Run a normal single-channel server once first if
  you don't already have it, or download it manually.

## Usage

```sh
cd docker/multichannel
docker compose up -d --build
```

First boot imports `schema.sql` and seeds the three `channels` rows via
`seed-channels.sql` (both mounted into MariaDB's
`/docker-entrypoint-initdb.d/`, so they only run once, against an empty
data volume).

Tear down (keeps the database/log volumes):

```sh
docker compose down
```

Wipe everything, including the database:

```sh
docker compose down -v
```

## Manual test checklist

See [SCENARIOS.md](SCENARIOS.md) for the full numbered scenario list this
stack is meant to support once Phase 2 wires session/switch enforcement
into the engine. With just this PR's Phase 1 changes, what you can
concretely observe today:

1. All three channels boot and stay up (`docker compose ps`).
2. A modern-protocol client's character list shows three worlds
   (Channel 1/2/3) once `multiChannelEnabled=true` and the `channels` table
   is populated - confirm with a packet-level check or the existing test
   client tooling, since this repo's automated tests don't drive a real
   client (see TEST_PLAN.md §15.4).
3. `redis-cli -h localhost ping` (if you expose Redis's port, not done by
   default in this compose file) confirms Redis is reachable from the
   host for debugging.
4. Stopping `channel2` does not affect `channel1`/`channel3` - restart it
   and confirm the other two were unaffected the whole time.
