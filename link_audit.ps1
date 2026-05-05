$ErrorActionPreference = "Stop"

$Root = "G:\opentibia\github\canary"

# Ajuste se seu build diagnóstico estiver em outro diretório.
$BuildDirCandidates = @(
    "$Root\build\windows-release-link-audit",
    "$Root\build\windows-release-openssl-evidence",
    "$Root\build\windows-release"
)

$BuildDir = $BuildDirCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $BuildDir) {
    throw "Nenhum build dir encontrado. Verifique build\windows-release*, ou ajuste `$BuildDirCandidates."
}

$OutDir = Join-Path $BuildDir "link-audit-extract"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$Patterns = "link.exe|/VERBOSE:LIB|/MAP|LINK_LIBRARIES|libcrypto|libssl|libcurl|mariadbclient|lua51|libprotobuf|libprotobuf-lite|libprotoc|absl_|fmt|spdlog|pugixml|argon2|zs\.lib|bcrypt|ncrypt|crypt32|ws2_32|Searching|Found|Loaded|Referenced in|Processed|LNK"

Write-Host "Root: $Root"
Write-Host "BuildDir: $BuildDir"
Write-Host "OutDir: $OutDir"

# 1) Extrair LINK_LIBRARIES do build.ninja
$BuildNinja = Join-Path $BuildDir "build.ninja"

if (Test-Path $BuildNinja) {
    Select-String $BuildNinja -Pattern "LINK_LIBRARIES|libcrypto|libssl|libcurl|mariadbclient|lua51|libprotobuf|libprotobuf-lite|libprotoc|absl_|fmt|spdlog|pugixml|argon2|zs\.lib" -CaseSensitive:$false |
        Set-Content (Join-Path $OutDir "build-ninja-link-libs.txt")

    Write-Host "OK: build-ninja-link-libs.txt"
} else {
    Write-Host "SKIP: build.ninja não encontrado em $BuildDir"
}

# 2) Extrair de logs existentes, se houver
$LogFiles = Get-ChildItem $Root, $BuildDir -Recurse -File -Include "*.log","*.txt" -ErrorAction SilentlyContinue |
    Where-Object {
        $_.FullName -notmatch "\\link-audit-extract\\"
    }

if ($LogFiles) {
    Select-String -Path $LogFiles.FullName -Pattern $Patterns -CaseSensitive:$false |
        Set-Content (Join-Path $OutDir "existing-logs-interesting-lines.txt")

    Write-Host "OK: existing-logs-interesting-lines.txt"
} else {
    Write-Host "SKIP: nenhum .log/.txt encontrado para extrair"
}

# 3) Localizar e extrair .map
$MapFiles = Get-ChildItem $Root, $BuildDir -Recurse -File -Filter "*.map" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending

$Map = $MapFiles | Select-Object -First 1

if ($Map) {
    Write-Host "Map: $($Map.FullName)"

    Select-String $Map.FullName -Pattern "libcrypto|libssl|libcurl|mariadbclient|libprotobuf|libprotobuf-lite|libprotoc|absl_|fmt|spdlog|pugixml|argon2|zs\.lib" -CaseSensitive:$false |
        Set-Content (Join-Path $OutDir "map-libs.txt")

    Select-String $Map.FullName -Pattern "libcrypto|libssl|BN_|RSA_|EVP_|PEM_|BIO_|SSL_|ERR_|CRYPTO_|SHA|HMAC|RAND_|AES_|X509_|OPENSSL_" -CaseSensitive:$false |
        Set-Content (Join-Path $OutDir "map-openssl-symbols.txt")

    Select-String $Map.FullName -Pattern "libprotobuf|libprotobuf-lite|libprotoc|MessageLite|protobuf" -CaseSensitive:$false |
        Set-Content (Join-Path $OutDir "map-protobuf-symbols.txt")

    Write-Host "OK: map-libs.txt"
    Write-Host "OK: map-openssl-symbols.txt"
    Write-Host "OK: map-protobuf-symbols.txt"
} else {
    Write-Host "SKIP: nenhum .map encontrado"
}

# 4) Localizar response files / tlog / link command, se existirem
$LinkMetadataFiles = Get-ChildItem $BuildDir -Recurse -File -Include "*.rsp","*.tlog","link.txt" -ErrorAction SilentlyContinue

if ($LinkMetadataFiles) {
    Select-String -Path $LinkMetadataFiles.FullName -Pattern $Patterns -CaseSensitive:$false |
        Set-Content (Join-Path $OutDir "link-metadata-interesting-lines.txt")

    Write-Host "OK: link-metadata-interesting-lines.txt"
} else {
    Write-Host "SKIP: nenhum .rsp/.tlog/link.txt encontrado"
}

# 5) Tamanho dos artefatos finais
Get-ChildItem $Root, $BuildDir -Recurse -File -Include "canary.exe","canary.pdb","*.map" -ErrorAction SilentlyContinue |
    Select-Object FullName, @{Name="MB";Expression={[math]::Round($_.Length / 1MB, 2)}}, LastWriteTime |
    Sort-Object MB -Descending |
    Format-Table -AutoSize |
    Out-String |
    Set-Content (Join-Path $OutDir "artifact-sizes.txt")

Write-Host "OK: artifact-sizes.txt"

# 6) Maiores arquivos do vcpkg instalado
$VcpkgInstalled = Join-Path $Root "vcpkg_installed\x64-windows-static-release"

if (Test-Path $VcpkgInstalled) {
    Get-ChildItem $VcpkgInstalled -Recurse -File -Include "*.lib","*.exe","*.pdb" -ErrorAction SilentlyContinue |
        Select-Object FullName, @{Name="MB";Expression={[math]::Round($_.Length / 1MB, 2)}} |
        Sort-Object MB -Descending |
        Select-Object -First 100 |
        Format-Table -AutoSize |
        Out-String |
        Set-Content (Join-Path $OutDir "vcpkg-largest-files.txt")

    Write-Host "OK: vcpkg-largest-files.txt"
} else {
    Write-Host "SKIP: vcpkg_installed não encontrado em $VcpkgInstalled"
}

Write-Host ""
Write-Host "Extração concluída."
Write-Host "Arquivos gerados em:"
Write-Host $OutDir