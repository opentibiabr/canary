param(
	[switch]$NoBuild,
	[switch]$SkipCleanup,
	[switch]$Lan,
	[string]$CleanupUntil = "168h"
)

$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
	$PSNativeCommandUseErrorActionPreference = $false
}

Set-Location -LiteralPath $PSScriptRoot

function Test-CommandExists {
	param([string]$Name)

	return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

function Stop-WithMessage {
	param([string]$Message)

	Write-Error $Message
	exit 1
}

function Invoke-DockerProbe {
	param([string[]]$Arguments)

	$previousErrorActionPreference = $ErrorActionPreference
	$ErrorActionPreference = "Continue"
	try {
		& docker @Arguments > $null 2> $null
		$exitCode = $LASTEXITCODE
	} finally {
		$ErrorActionPreference = $previousErrorActionPreference
	}

	return $exitCode
}

function Get-EnvValue {
	param(
		[string]$Path,
		[string]$Name,
		[string]$DefaultValue
	)

	$line = Get-Content -LiteralPath $Path | Where-Object { $_ -match "^$([regex]::Escape($Name))=" } | Select-Object -First 1
	if (-not $line) {
		return $DefaultValue
	}

	return $line.Substring($line.IndexOf("=") + 1)
}

function Set-EnvValue {
	param(
		[string]$Path,
		[string]$Name,
		[string]$Value
	)

	$lines = @(Get-Content -LiteralPath $Path)
	$found = $false
	for ($i = 0; $i -lt $lines.Count; $i++) {
		if ($lines[$i] -match "^$([regex]::Escape($Name))=") {
			$lines[$i] = "$Name=$Value"
			$found = $true
			break
		}
	}

	if (-not $found) {
		$lines += "$Name=$Value"
	}

	[System.IO.File]::WriteAllText((Resolve-Path -LiteralPath $Path), (($lines -join "`n") + "`n"), [System.Text.UTF8Encoding]::new($false))
}

function Get-PrimaryLanIPv4 {
	$defaultRoute = Get-NetRoute -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue |
		Where-Object { $_.NextHop -and $_.NextHop -ne "0.0.0.0" } |
		Sort-Object RouteMetric, InterfaceMetric |
		Select-Object -First 1

	if ($defaultRoute) {
		$ip = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $defaultRoute.InterfaceIndex -ErrorAction SilentlyContinue |
			Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" } |
			Select-Object -First 1
		if ($ip) {
			return $ip.IPAddress
		}
	}

	$ip = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
		Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" -and $_.InterfaceAlias -notlike "vEthernet*" } |
		Sort-Object InterfaceMetric |
		Select-Object -First 1
	if ($ip) {
		return $ip.IPAddress
	}

	return $null
}

if (-not (Test-CommandExists "docker")) {
	Stop-WithMessage "Docker was not found. Install Docker Desktop, start it, then run this script again: https://docs.docker.com/get-started/get-docker/"
}

if ((Invoke-DockerProbe -Arguments @("info")) -ne 0) {
	Stop-WithMessage "Docker is installed but the daemon is not running. Start Docker Desktop or the Docker service, then run this script again."
}

if ((Invoke-DockerProbe -Arguments @("compose", "version")) -ne 0) {
	Stop-WithMessage "Docker Compose v2 was not found. Update Docker Desktop or install the Docker Compose plugin."
}

if (-not (Test-Path -LiteralPath ".env")) {
	if (-not (Test-Path -LiteralPath ".env.dist")) {
		Stop-WithMessage "Missing .env.dist. Run this script from the docker directory in a complete Canary checkout."
	}
	Copy-Item -LiteralPath ".env.dist" -Destination ".env"
	Write-Host "Created docker/.env from docker/.env.dist."
}

if ($Lan) {
	$lanIp = Get-PrimaryLanIPv4
	if (-not $lanIp) {
		Stop-WithMessage "Could not detect a LAN IPv4 address. Edit docker/.env manually and set CANARY_SERVER_IP to the address other PCs can reach."
	}

	$myaacPort = Get-EnvValue -Path ".env" -Name "MYAAC_HTTP_PORT" -DefaultValue "8080"
	Set-EnvValue -Path ".env" -Name "CANARY_SERVER_IP" -Value $lanIp
	Set-EnvValue -Path ".env" -Name "MYAAC_SITE_URL" -Value "http://${lanIp}:${myaacPort}"
	Write-Host "Configured docker/.env for LAN access at ${lanIp}."
}

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
