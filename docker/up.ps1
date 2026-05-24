param(
	[switch]$NoBuild,
	[switch]$SkipCleanup,
	[string]$CleanupUntil = "168h"
)

$ErrorActionPreference = "Stop"

Set-Location -LiteralPath $PSScriptRoot

$projectName = if ($env:COMPOSE_PROJECT_NAME) { $env:COMPOSE_PROJECT_NAME } else { "otbr" }

$composeArgs = @("compose", "up", "-d", "--remove-orphans")
if (-not $NoBuild) {
	$composeArgs += "--build"
}

& docker @composeArgs
if ($LASTEXITCODE -ne 0) {
	exit $LASTEXITCODE
}

if (-not $SkipCleanup) {
	& docker container prune --force --filter "label=com.docker.compose.project=$projectName"
	if ($LASTEXITCODE -ne 0) {
		exit $LASTEXITCODE
	}

	& docker image prune --force --filter "label=com.docker.compose.project=$projectName"
	if ($LASTEXITCODE -ne 0) {
		exit $LASTEXITCODE
	}

	if ($CleanupUntil) {
		& docker builder prune --force --filter "until=$CleanupUntil"
	} else {
		& docker builder prune --force
	}
	if ($LASTEXITCODE -ne 0) {
		exit $LASTEXITCODE
	}
}

& docker system df
