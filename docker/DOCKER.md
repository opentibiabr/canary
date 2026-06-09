# Canary Docker Quickstart

This directory contains the lightweight Docker quickstart for Canary. It is meant
for people who want to run a local test server without compiling Canary locally.

The quickstart currently starts:

- MariaDB
- Canary server from the published runtime image
- MyAAC from the `slawkens/myaac` `develop` branch
- `opentibiabr/login-server` for the client login webservice
- Test accounts and characters, when enabled

MyAAC is used only as the website/AAC. The MyAAC login webservice file is
removed from the quickstart image, so clients should use `login-server`.

## Local Development Only

This quickstart is for local development, testing, and LAN demos. Do not expose
it directly to the public Internet or run it as a production deployment with the
default settings.

Before using it outside a trusted local network:

- Change all default database and MyAAC admin passwords.
- Disable or remove test accounts by setting `CANARY_TEST_ACCOUNTS=false`.
- Review firewall rules for the published TCP ports.
- Pin image tags instead of relying on rolling `latest` tags.

## Requirements

- Docker with Docker Compose v2
- Network access to pull the published Canary image and build the MyAAC image

For a step-by-step beginner guide, see
[`docs/docker/quickstart-for-beginners.md`](../docs/docker/quickstart-for-beginners.md).

## Start The Server

Run these commands from the `docker` directory:

```bash
cp .env.dist .env
docker compose up -d --build
```

On Windows PowerShell, you can use the guarded start script:

```powershell
.\up.ps1
```

To configure `docker/.env` automatically for other PCs on your LAN:

```powershell
.\up.ps1 -Lan
```

On Linux or macOS, you can use:

```bash
sh ./up.sh
```

To configure `docker/.env` automatically for other PCs on your LAN:

```bash
LAN=true sh ./up.sh
```

These scripts run Compose with `--remove-orphans` and then perform a safe
cleanup. They remove stopped containers and dangling images that belong to this
Compose project, then remove unused Docker build cache older than seven days.
They do not remove Docker volumes, so the MariaDB database and Canary runtime
data are preserved.

Docker build cache is Docker-wide, so the start scripts only prune cache older
than seven days. This keeps cleanup data-safe while avoiding aggressive cache
removal that would make every rebuild slow.

Watch the logs:

```bash
docker compose logs -f server
docker compose logs -f myaac
docker compose logs -f login-server
```

Stop the stack:

```bash
docker compose down
```

Remove persisted database and server data:

```bash
docker compose down -v
```

## Safe Docker Cleanup

Docker can accumulate old build cache and unused layers after repeated builds.
The quickstart start scripts keep this under control without deleting user data:

- `docker container prune --filter label=com.docker.compose.project=otbr`
- `docker image prune --filter label=com.docker.compose.project=otbr`
- `docker builder prune --filter until=168h`

Avoid using `docker system prune -a --volumes` for routine cleanup. It can remove
images, volumes, and data from unrelated Docker projects.

The build-cache cleanup is Docker-wide because Docker does not expose a reliable
Compose-project label for build cache entries. The age filter keeps this safe for
routine quickstart usage.

To start without cleanup:

```powershell
.\up.ps1 -SkipCleanup
```

```bash
SKIP_CLEANUP=true sh ./up.sh
```

To keep a different build cache window, set the age filter:

```powershell
.\up.ps1 -CleanupUntil 72h
```

```bash
CLEANUP_UNTIL=72h sh ./up.sh
```

## Default URLs And Ports

With the default `.env` values:

- MyAAC site: `http://localhost:8080`
- Client login webservice: `http://localhost:8088/login`
- MyAAC admin panel: `http://localhost:8080/admin`
- Login-server HTTP port: `8088`
- Canary login protocol port: `7171`
- Canary game protocol port: `7172`
- Canary status protocol port: `7173`
- Test login: `@test1`
- Test password: `test`
- MyAAC admin login: `myaacadmin`
- MyAAC admin password: `admin123`

The database is only exposed inside the Docker network by default. Add a database
tool profile later, such as Adminer, instead of requiring new users to connect
directly to MariaDB.

## Client Setup

Point the client login webservice to:

```text
http://localhost:8088/login
```

The client login webservice is provided by `opentibiabr/login-server`, not by
MyAAC. MyAAC's own login webservice file is removed from the quickstart image to
avoid accidental use.

The login-server advertises `CANARY_SERVER_IP` and `CANARY_GAME_PORT` to the
client. For local quickstart, keep:

```env
CANARY_SERVER_IP=127.0.0.1
CANARY_GAME_PORT=7172
```

If the client runs on another machine, change `CANARY_SERVER_IP` to the LAN or
public address that the client can reach.

## Environment Contract

The public Docker configuration contract for Canary uses `CANARY_*`.

Do not add new public Canary settings using `MYSQL_*`, `OT_*`, or raw Lua config
variable names. The compose file translates `CANARY_*` into the variables needed
by MariaDB, MyAAC, and login-server.

### Database

```env
CANARY_DB_HOST=db
CANARY_DB_PORT=3306
CANARY_DB_NAME=canary
CANARY_DB_USER=canary
CANARY_DB_PASSWORD=canary
CANARY_DB_ROOT_PASSWORD=root
```

`CANARY_DB_HOST` should usually stay as `db` inside Docker Compose. MariaDB runs
on port `3306` inside the Docker network.

### Server Image, Identity, And Ports

```env
CANARY_IMAGE=ghcr.io/opentibiabr/canary:latest
CANARY_SERVER_NAME=OpenTibiaBR Canary
CANARY_SERVER_IP=127.0.0.1
CANARY_SERVER_LOCATION=BRA
CANARY_LOGIN_PORT=7171
CANARY_GAME_PORT=7172
CANARY_STATUS_PORT=7173
CANARY_STATUS_TIMEOUT=5000
```

`CANARY_IMAGE` defaults to the rolling `latest` tag for a convenient first-run
experience. That tag can change over time. For reproducible support, demos, or
shared environments, set `CANARY_IMAGE` to a specific published tag or digest
when one is available.

The quickstart publishes `CANARY_LOGIN_PORT`, `CANARY_GAME_PORT`, and
`CANARY_STATUS_PORT` to the host using the same port values configured in
`.env`. Keep these values distinct unless you intentionally add a Compose
override for custom port mappings.

`CANARY_SERVER_IP` is the address sent to the client in the world list. It is not
the Docker service name.

### Data Pack And Test Data

```env
CANARY_TEST_ACCOUNTS=true
CANARY_DATA_PACK=data-otservbr-global
CANARY_MAP_URL=https://github.com/opentibiabr/canary/releases/download/v3.5.0/otservbr.otbm
```

The Docker image intentionally does not embed the large `.otbm` map file. On the
first run with `CANARY_DATA_PACK=data-otservbr-global`, the entrypoint downloads
the map from `CANARY_MAP_URL` if it is missing.

When `CANARY_TEST_ACCOUNTS=true`, the container imports:

- `docker/data/01-test_account.sql`
- `docker/data/02-test_account_players.sql`

The default test account password is `test`.
For a first login, use account `@test1` with password `test`.

### MyAAC

```env
MYAAC_HTTP_PORT=8080
MYAAC_SITE_URL=http://localhost:8080
MYAAC_REF=develop
MYAAC_ADMIN_ACCOUNT=myaacadmin
MYAAC_ADMIN_EMAIL=admin@localhost.local
MYAAC_ADMIN_PASSWORD=admin123
MYAAC_ADMIN_PLAYER=ADM1
MYAAC_CLIENT_VERSION=1501
MYAAC_TIMEZONE=America/Fortaleza
```

`MYAAC_REF` is the Git ref used when building the MyAAC image. The default is
`develop`, which tracks the MyAAC branch compatible with Canary `main`. To test
a tag or another branch, change `MYAAC_REF` and rebuild:

```bash
docker compose build --no-cache myaac
docker compose up -d
```

The MyAAC container waits until the Canary schema exists, writes its own
`config.local.php`, imports the MyAAC tables, and creates the admin account on
first startup.

The generated MyAAC server path contains the runtime `config.lua` needed for
database and status settings. It does not mount the full Canary datapack into
the web container, and it does not include MyAAC's client login webservice file.

### Login Server

```env
LOGIN_SERVER_IMAGE=opentibiabr/login-server:latest
LOGIN_HTTP_PORT=8088
LOGIN_GRPC_PORT=9090
LOGIN_RATE_LIMITER_RATE=2
LOGIN_RATE_LIMITER_BURST=5
```

These variables belong to `opentibiabr/login-server`, which starts by default.
`LOGIN_SERVER_IMAGE` also defaults to a rolling `latest` tag. Pin this image to a
specific tag or digest when you need reproducible behavior.
With the default ports, the client login URL is:

```text
http://localhost:8088/login
```

## Data Persistence

Docker volumes used by this quickstart:

- `db-volume`: MariaDB data
- `server-data`: Canary shared runtime data and backups

MyAAC stores its persistent state in the shared Canary database. Its generated
`config.local.php` is recreated from `.env` whenever the container starts.

When an existing Canary schema is detected, the server entrypoint writes a
database backup. With the default `CANARY_DB_NAME=canary`, the backup path is:

```text
/data/canary.sql
```

That path is inside the `server-data` Docker volume.
If `CANARY_DB_NAME` changes, the backup file name follows that database name.

## Runtime Image

The quickstart uses:

```yaml
image: ghcr.io/opentibiabr/canary:latest
```

This keeps the Canary service lightweight for users. Local Canary compilation
should live in a separate development compose file that uses
`docker/Dockerfile.dev` and the required vcpkg cache credentials.

Use `CANARY_IMAGE` only when testing another published or locally loaded Canary
runtime image. The default quickstart should stay on the official image.

The MyAAC image is built locally from `slawkens/myaac` because the quickstart
tracks `MYAAC_REF=develop` by default. This build installs PHP dependencies with
Composer, but it does not compile Canary.

## CI Coverage

The GitHub Actions job `Docker Quickstart Smoke` runs after `Build - Docker` and
validates the user-facing quickstart with the Docker image produced by the same
CI run whenever the Compose file, quickstart MyAAC image, seed SQL files, or the
smoke workflow changes.

The smoke test starts the stack from a clean database, checks that MyAAC answers
on `http://localhost:8080`, verifies that MyAAC's `login.php` webservice is not
present, and confirms that `opentibiabr/login-server` can return the seeded test
account through `http://localhost:8088/login`.

## Troubleshooting

If the client receives the character list but cannot enter the game, check:

- `CANARY_SERVER_IP` is reachable from the client machine.
- `CANARY_GAME_PORT` is open on the host.
- The `server` container is running: `docker compose ps`.
- The `login-server` container is running: `docker compose ps login-server`.
- The MyAAC container is running: `docker compose ps myaac`.
- The server log does not show database connection errors:

```bash
docker compose logs server
docker compose logs myaac
docker compose logs login-server
```

If the server waits for the database, check:

```bash
docker compose logs db
docker compose ps
```
