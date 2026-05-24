#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$script_dir"

project_name="${COMPOSE_PROJECT_NAME:-otbr}"
no_build="${NO_BUILD:-false}"
skip_cleanup="${SKIP_CLEANUP:-false}"
cleanup_until="${CLEANUP_UNTIL:-168h}"

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
