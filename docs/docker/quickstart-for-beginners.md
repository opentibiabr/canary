# Docker Quickstart For Beginners

This guide starts a local Canary test server with Docker. It does not compile
Canary on your machine.

The stack starts:

- MariaDB
- Canary game server
- MyAAC website and admin panel
- `opentibiabr/login-server` for client login

## Before You Start

Install Docker from the official Docker guide:

```text
https://docs.docker.com/get-started/get-docker/
```

After installing Docker, start Docker Desktop or the Docker service before
running any commands below.

You also need internet access on the first start. Docker must download images,
MyAAC source files, and the OTServBR global map.

## Local Use Only

This guide is for local testing and LAN demos. Do not expose this quickstart
directly to the public Internet with the default settings.

The default setup includes test accounts and simple local credentials so a new
user can log in quickly. Before using it outside a trusted local network, change
the passwords in `docker/.env`, set `CANARY_TEST_ACCOUNTS=false`, and review the
host firewall rules.

## Start On Your Own PC

Open a terminal in the repository root, then enter the `docker` directory:

```bash
cd docker
```

On Windows PowerShell:

```powershell
.\up.ps1
```

On Linux or macOS:

```bash
sh ./up.sh
```

The script creates `docker/.env` from `docker/.env.dist` if it does not already
exist. It also performs safe Docker cleanup without deleting database volumes.

Open the website:

```text
http://localhost:8080
```

Use this client login URL:

```text
http://localhost:8088/login
```

Default test account:

```text
login: @test1
password: test
```

## Start For Other PCs On Your Network

Use this when the client runs on another computer in the same local network.

On Windows PowerShell:

```powershell
.\up.ps1 -Lan
```

On Linux or macOS:

```bash
LAN=true sh ./up.sh
```

This detects the LAN IPv4 address and writes it to `docker/.env` as
`CANARY_SERVER_IP`. The login server uses this address in the character list so
other PCs can enter the game world.

After the script finishes, it prints Docker disk usage. Open the MyAAC website
from another PC using:

```text
http://LAN_IP:8080
```

Use this client login URL on the other PC:

```text
http://LAN_IP:8088/login
```

Replace `LAN_IP` with the address configured by the script, for example
`192.168.1.50`.

## Useful Commands

Show running services:

```bash
docker compose ps
```

Watch server logs:

```bash
docker compose logs -f server
```

Watch website logs:

```bash
docker compose logs -f myaac
```

Watch login-server logs:

```bash
docker compose logs -f login-server
```

Stop the stack without deleting data:

```bash
docker compose down
```

Delete the database and persisted server data:

```bash
docker compose down -v
```

## Troubleshooting

If the script says Docker was not found, install Docker and restart your
terminal.

If the script says Docker is not running, start Docker Desktop or the Docker
service and try again.

If another PC can see the character list but cannot enter the game, check
`CANARY_SERVER_IP` in `docker/.env`. It must be the LAN address reachable from
the other PC, not `127.0.0.1`.

If another PC cannot open the website or login URL, check the firewall on the
host machine. The quickstart uses these TCP ports:

- `7171`
- `7172`
- `7173`
- `7174` (11.00 legacy world port)
- `7175` (8.60 legacy world port)
- `8080`
- `8088`

If the first start is slow, wait for the map download and MyAAC build to finish.
Later starts are faster because Docker reuses downloaded data and images.
