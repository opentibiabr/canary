# Docker

## Getting Started

The docker-compose files will deploy a MySQL database, a web UI for the DB and the Canary server.

All the migrations from `schema.sql` file will be automatically executed when the MySQL container start for the first time.

### Build from scratch

```bash
# Start DB first
docker compose up mysql adminer -d

# Start server
docker compose up server
```

### Use a pre build server

Uncomment the `pre-built-server` block from the `docker-compose.yaml` file.
Update the path to your binary:

```yaml
volumes:
- ./build/linux-release/bin/canary:/srv/canary/canary
```

Start the server normally

```bash
# Start DB first
docker compose up mysql adminer -d

# Start server
docker compose up pre-built-server
```
