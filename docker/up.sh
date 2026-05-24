#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$script_dir"

project_name="${COMPOSE_PROJECT_NAME:-otbr}"
no_build="${NO_BUILD:-false}"
skip_cleanup="${SKIP_CLEANUP:-false}"
cleanup_until="${CLEANUP_UNTIL:-168h}"
lan="${LAN:-false}"

fail() {
	printf '%s\n' "$1" >&2
	exit 1
}

command -v docker >/dev/null 2>&1 || fail "Docker was not found. Install Docker, start it, then run this script again: https://docs.docker.com/get-started/get-docker/"
docker info >/dev/null 2>&1 || fail "Docker is installed but the daemon is not running. Start Docker Desktop or the Docker service, then run this script again."
docker compose version >/dev/null 2>&1 || fail "Docker Compose v2 was not found. Update Docker Desktop or install the Docker Compose plugin."

if [ ! -f .env ]; then
	[ -f .env.dist ] || fail "Missing .env.dist. Run this script from the docker directory in a complete Canary checkout."
	cp .env.dist .env
	printf '%s\n' "Created docker/.env from docker/.env.dist."
fi

env_value() {
	key="$1"
	default="$2"
	value="$(grep -E "^${key}=" .env 2>/dev/null | tail -n 1 | cut -d= -f2- || true)"
	if [ -n "$value" ]; then
		printf '%s\n' "$value"
	else
		printf '%s\n' "$default"
	fi
}

set_env_value() {
	key="$1"
	value="$2"
	tmp_file="$(mktemp)"
	awk -v key="$key" -v value="$value" '
		BEGIN { found = 0 }
		$0 ~ "^" key "=" {
			print key "=" value
			found = 1
			next
		}
		{ print }
		END {
			if (!found) {
				print key "=" value
			}
		}
	' .env > "$tmp_file"
	mv "$tmp_file" .env
}

is_wsl() {
	[ -n "${WSL_INTEROP:-}" ] || grep -qiE "microsoft|wsl" /proc/version 2>/dev/null
}

detect_windows_lan_ip() {
	command -v powershell.exe >/dev/null 2>&1 || return 0

	powershell.exe -NoProfile -Command '
		$defaultRoute = Get-NetRoute -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue |
			Where-Object { $_.NextHop -and $_.NextHop -ne "0.0.0.0" } |
			Sort-Object RouteMetric, InterfaceMetric |
			Select-Object -First 1

		if ($defaultRoute) {
			$ip = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $defaultRoute.InterfaceIndex -ErrorAction SilentlyContinue |
				Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" } |
				Select-Object -First 1
			if ($ip) {
				$ip.IPAddress
				exit 0
			}
		}

		$ip = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
			Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" -and $_.InterfaceAlias -notlike "vEthernet*" } |
			Sort-Object InterfaceMetric |
			Select-Object -First 1
		if ($ip) {
			$ip.IPAddress
		}
	' 2>/dev/null | tr -d '\r' | awk 'NF { print; exit }'
}

detect_lan_ip() {
	if is_wsl; then
		windows_lan_ip="$(detect_windows_lan_ip)"
		if [ -n "$windows_lan_ip" ]; then
			printf '%s\n' "$windows_lan_ip"
			return
		fi
	fi

	if command -v ip >/dev/null 2>&1; then
		ip route get 1.1.1.1 2>/dev/null | awk '
			{
				for (i = 1; i <= NF; i++) {
					if ($i == "src") {
						print $(i + 1)
						exit
					}
				}
			}
		'
		return
	fi

	if command -v hostname >/dev/null 2>&1; then
		hostname -I 2>/dev/null | awk '{ print $1 }'
	fi
}

if [ "$lan" = "true" ]; then
	lan_ip="$(detect_lan_ip)"
	[ -n "$lan_ip" ] || fail "Could not detect a LAN IPv4 address. Edit docker/.env manually and set CANARY_SERVER_IP to the address other PCs can reach."
	myaac_port="$(env_value MYAAC_HTTP_PORT 8080)"
	set_env_value CANARY_SERVER_IP "$lan_ip"
	set_env_value MYAAC_SITE_URL "http://${lan_ip}:${myaac_port}"
	printf '%s\n' "Configured docker/.env for LAN access at ${lan_ip}."
fi

compose_args="up -d --remove-orphans"
if [ "$no_build" != "true" ]; then
	compose_args="$compose_args --build"
fi

# shellcheck disable=SC2086
docker compose $compose_args

if [ "$skip_cleanup" != "true" ]; then
	docker container prune --force --filter "label=com.docker.compose.project=${project_name}"
	docker image prune --force --filter "label=com.docker.compose.project=${project_name}"
	if [ -n "$cleanup_until" ]; then
		docker builder prune --force --filter "until=${cleanup_until}"
	else
		docker builder prune --force
	fi
fi

docker system df
