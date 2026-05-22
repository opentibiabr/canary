param(
    [Parameter(Mandatory = $true)]
    [string]$InputDir,
    [string]$OutputDir,
    [string]$VcpkgInstalled
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $InputDir -PathType Container)) {
    throw "Input directory not found: $InputDir. Pass -InputDir with the directory that contains the link audit artifacts."
}

$InputDir = (Resolve-Path -LiteralPath $InputDir).Path

if (-not $OutputDir) {
    $OutputDir = Join-Path $InputDir "link-audit-extract"
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
$OutputDir = (Resolve-Path -LiteralPath $OutputDir).Path
$OutputDirWithSeparator = $OutputDir.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar

$Patterns = "link.exe|/VERBOSE:LIB|/MAP|LINK_LIBRARIES|libcrypto|libssl|libcurl|mariadbclient|lua51|libprotobuf|libprotobuf-lite|libprotoc|absl_|fmt|spdlog|pugixml|argon2|zs\.lib|bcrypt|ncrypt|crypt32|ws2_32|Searching|Found|Loaded|Referenced in|Processed|LNK"

Write-Host "InputDir: $InputDir"
Write-Host "OutputDir: $OutputDir"

if ($VcpkgInstalled) {
    Write-Host "VcpkgInstalled: $VcpkgInstalled"
}

# 1) Extract interesting lines from existing logs, if any
$LogFiles = Get-ChildItem $InputDir -Recurse -File -Include "*.log","*.txt" -ErrorAction SilentlyContinue |
    Where-Object {
        -not $_.FullName.StartsWith($OutputDirWithSeparator, [System.StringComparison]::InvariantCultureIgnoreCase)
    }

if ($LogFiles) {
    Select-String -Path $LogFiles.FullName -Pattern $Patterns -CaseSensitive:$false |
        Set-Content (Join-Path $OutputDir "existing-logs-interesting-lines.txt") -Encoding utf8

    Write-Host "OK: existing-logs-interesting-lines.txt"
} else {
    Write-Host "SKIP: no .log/.txt files found to extract"
}

# 2) Locate and extract .map data
$MapFiles = Get-ChildItem $InputDir -Recurse -File -Filter "*.map" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending

$Map = $MapFiles | Select-Object -First 1

if ($Map) {
    Write-Host "Map: $($Map.FullName)"

    Select-String $Map.FullName -Pattern "libcrypto|libssl|libcurl|mariadbclient|libprotobuf|libprotobuf-lite|libprotoc|absl_|fmt|spdlog|pugixml|argon2|zs\.lib" -CaseSensitive:$false |
        Set-Content (Join-Path $OutputDir "map-libs.txt") -Encoding utf8

    Select-String $Map.FullName -Pattern "libcrypto|libssl|BN_|RSA_|EVP_|PEM_|BIO_|SSL_|ERR_|CRYPTO_|SHA|HMAC|RAND_|AES_|X509_|OPENSSL_" -CaseSensitive:$false |
        Set-Content (Join-Path $OutputDir "map-openssl-symbols.txt") -Encoding utf8

    Select-String $Map.FullName -Pattern "libprotobuf|libprotobuf-lite|libprotoc|MessageLite|protobuf" -CaseSensitive:$false |
        Set-Content (Join-Path $OutputDir "map-protobuf-symbols.txt") -Encoding utf8

    Write-Host "OK: map-libs.txt"
    Write-Host "OK: map-openssl-symbols.txt"
    Write-Host "OK: map-protobuf-symbols.txt"
} else {
    Write-Host "SKIP: no .map file found"
}

# 3) Locate response files / tlog / link command, if present
$LinkMetadataFiles = Get-ChildItem $InputDir -Recurse -File -Include "*.rsp","*.tlog","link.txt" -ErrorAction SilentlyContinue

if ($LinkMetadataFiles) {
    Select-String -Path $LinkMetadataFiles.FullName -Pattern $Patterns -CaseSensitive:$false |
        Set-Content (Join-Path $OutputDir "link-metadata-interesting-lines.txt") -Encoding utf8

    Write-Host "OK: link-metadata-interesting-lines.txt"
} else {
    Write-Host "SKIP: no .rsp/.tlog/link.txt files found"
}

# 4) Final artifact sizes
Get-ChildItem $InputDir -Recurse -File -Include "canary.exe","canary.pdb","*.map" -ErrorAction SilentlyContinue |
    Select-Object FullName, @{Name="MB";Expression={[math]::Round($_.Length / 1MB, 2)}}, LastWriteTime |
    Sort-Object MB -Descending |
    Format-Table -AutoSize |
    Out-String |
    Set-Content (Join-Path $OutputDir "artifact-sizes.txt") -Encoding utf8

Write-Host "OK: artifact-sizes.txt"

# 5) Largest files from the installed vcpkg tree
if ($VcpkgInstalled -and (Test-Path $VcpkgInstalled -PathType Container)) {
    Get-ChildItem $VcpkgInstalled -Recurse -File -Include "*.lib","*.exe","*.pdb" -ErrorAction SilentlyContinue |
        Select-Object FullName, @{Name="MB";Expression={[math]::Round($_.Length / 1MB, 2)}} |
        Sort-Object MB -Descending |
        Select-Object -First 100 |
        Format-Table -AutoSize |
        Out-String |
        Set-Content (Join-Path $OutputDir "vcpkg-largest-files.txt") -Encoding utf8

    Write-Host "OK: vcpkg-largest-files.txt"
} elseif ($VcpkgInstalled) {
    Write-Host "SKIP: vcpkg_installed not found at $VcpkgInstalled"
} else {
    Write-Host "SKIP: no vcpkg_installed path provided"
}

Write-Host ""
Write-Host "Extraction complete."
Write-Host "Generated files in:"
Write-Host $OutputDir
