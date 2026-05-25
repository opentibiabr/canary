#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
DOCKER_DIR="${REPO_ROOT}/docker"
ENV_FILE="${DOCKER_DIR}/.env"

export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-otbr-smoke}"

cd "${DOCKER_DIR}"
cp .env.dist "${ENV_FILE}"

if [[ -n "${CANARY_IMAGE:-}" ]]; then
	sed -i "s|^CANARY_IMAGE=.*|CANARY_IMAGE=${CANARY_IMAGE}|" "${ENV_FILE}"
fi

if [[ -n "${CANARY_IMAGE_TAR:-}" ]]; then
	docker load --input "${REPO_ROOT}/${CANARY_IMAGE_TAR}"
fi

COMPOSE=(docker compose --env-file "${ENV_FILE}")

dump_debug() {
	echo "::group::Docker compose status"
	"${COMPOSE[@]}" ps || true
	echo "::endgroup::"

	echo "::group::Docker compose logs"
	"${COMPOSE[@]}" logs --no-color db server myaac login-server || true
	echo "::endgroup::"
}

cleanup() {
	"${COMPOSE[@]}" down -v --remove-orphans || true
}

on_exit() {
	local status=$?

	if [[ "${status}" -ne 0 ]]; then
		dump_debug
	fi

	cleanup
	exit "${status}"
}

wait_for_http_status() {
	local name="$1"
	local url="$2"
	local expected_status="$3"
	local body_file

	body_file="$(mktemp)"

	for attempt in $(seq 1 120); do
		local status
		status="$(curl -sS -o "${body_file}" -w "%{http_code}" "${url}" || true)"

		if [[ "${status}" == "${expected_status}" ]]; then
			echo "${name} returned HTTP ${expected_status}"
			rm -f "${body_file}"
			return 0
		fi

		echo "Waiting for ${name}: expected ${expected_status}, got ${status} (attempt ${attempt}/120)"
		sleep 5
	done

	echo "${name} did not return HTTP ${expected_status}" >&2
	cat "${body_file}" >&2 || true
	rm -f "${body_file}"
	return 1
}

wait_for_login_server() {
	local response_file

	response_file="$(mktemp)"

	for attempt in $(seq 1 60); do
		local status
		status="$(
			curl -sS -o "${response_file}" -w "%{http_code}" \
				-H "Content-Type: application/json" \
				-d '{"email":"@test1","password":"test","type":"login","clientversion":"1501"}' \
				http://localhost:8088/login || true
		)"

		if [[ "${status}" == "200" ]] &&
			grep -q '"worlds"' "${response_file}" &&
			grep -q 'Rook Noob 1' "${response_file}"; then
			echo "login-server returned the seeded test account"
			rm -f "${response_file}"
			return 0
		fi

		echo "Waiting for login-server: got HTTP ${status} (attempt ${attempt}/60)"
		sleep 5
	done

	echo "login-server did not return the seeded test account" >&2
	cat "${response_file}" >&2 || true
	rm -f "${response_file}"
	return 1
}

trap on_exit EXIT

cleanup

"${COMPOSE[@]}" config >/tmp/canary-docker-compose.yml
if [[ -n "${CANARY_IMAGE_TAR:-}" ]]; then
	"${COMPOSE[@]}" pull db login-server
else
	"${COMPOSE[@]}" pull db server login-server
fi
"${COMPOSE[@]}" up -d --build

wait_for_http_status "MyAAC home" "http://localhost:8080/" "200"
wait_for_http_status "MyAAC login.php" "http://localhost:8080/login.php" "404"

"${COMPOSE[@]}" exec -T myaac test ! -f /var/www/html/login.php

"${COMPOSE[@]}" exec -T server sh -lc '
	grep -q "mysqlHost = \"db\"" config.lua &&
	grep -q "mysqlDatabase = \"canary\"" config.lua &&
	grep -q "loginProtocolPort = 7171" config.lua &&
	grep -q "gameProtocolPort = 7172" config.lua &&
	grep -q "statusProtocolPort = 7173" config.lua
'

wait_for_login_server
