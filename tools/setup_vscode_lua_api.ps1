<#
.SYNOPSIS
Configures VSCode Lua Language Server to use Canary's generated Lua API stubs.

.DESCRIPTION
Run this script from the repository root. It updates the local
.vscode/settings.json file so LuaLS reads docs/lua-api/lua_api.d.lua through
the workspace library. If the repository has a .luarc.json file, the script also
updates that project configuration because LuaLS gives it priority over VSCode
settings.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$SettingsPath = ".vscode/settings.json",
    [string]$LuaRcPath = ".luarc.json",
    [string]$LuaApiLibraryPath = '${workspaceFolder}/docs/lua-api',
    [string]$LuaRcLibraryPath = "docs/lua-api",
    [string[]]$LuaRcIgnoreDirectories = @(
        ".git",
        ".vs",
        "artifacts",
        "build",
        "cache",
        "cmake-build-*",
        "database_backup",
        "logs",
        "Release",
        "RelWithDebInfo",
        "Testing",
        "vcproj",
        "vcpkg_installed"
    ),
    [int]$MinimumPreloadFileSizeKb = 1000
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

function Remove-JsonComments {
    param([string]$Text)

    $builder = [System.Text.StringBuilder]::new()
    $inString = $false
    $escape = $false
    $index = 0

    while ($index -lt $Text.Length) {
        $char = $Text[$index]
        $next = if ($index + 1 -lt $Text.Length) { $Text[$index + 1] } else { [char]0 }

        if (-not $inString -and $char -eq "/" -and $next -eq "/") {
            while ($index -lt $Text.Length -and $Text[$index] -ne "`n") {
                $index++
            }
            if ($index -lt $Text.Length) {
                [void]$builder.Append($Text[$index])
            }
            $index++
            continue
        }

        if (-not $inString -and $char -eq "/" -and $next -eq "*") {
            $index += 2
            while ($index + 1 -lt $Text.Length -and -not ($Text[$index] -eq "*" -and $Text[$index + 1] -eq "/")) {
                if ($Text[$index] -eq "`n") {
                    [void]$builder.Append("`n")
                }
                $index++
            }
            $index += 2
            continue
        }

        [void]$builder.Append($char)

        if ($char -eq '"' -and -not $escape) {
            $inString = -not $inString
        }

        $escape = $inString -and $char -eq "\" -and -not $escape
        if ($char -ne "\") {
            $escape = $false
        }

        $index++
    }

    return $builder.ToString()
}

function ConvertTo-OrderedHashtable {
    param([object]$Value)

    if ($null -eq $Value) {
        return $null
    }

    if ($Value -is [string] -or $Value -is [ValueType]) {
        return $Value
    }

    if ($Value -is [System.Collections.IDictionary]) {
        $hash = [ordered]@{}
        foreach ($key in $Value.Keys) {
            $hash[$key] = ConvertTo-OrderedHashtable $Value[$key]
        }
        return $hash
    }

    if ($Value -is [System.Collections.IEnumerable]) {
        $items = [System.Collections.Generic.List[object]]::new()
        foreach ($item in $Value) {
            $items.Add((ConvertTo-OrderedHashtable $item))
        }
        return ,$items.ToArray()
    }

    $properties = @($Value.PSObject.Properties)
    if ($properties.Count -gt 0) {
        $hash = [ordered]@{}
        foreach ($property in $properties) {
            $hash[$property.Name] = ConvertTo-OrderedHashtable $property.Value
        }
        return $hash
    }

    return $Value
}

function Get-ArraySetting {
    param(
        [System.Collections.IDictionary]$Settings,
        [string]$Key
    )

    if (-not $Settings.Contains($Key) -or $null -eq $Settings[$Key]) {
        return @()
    }

    $value = $Settings[$Key]
    if ($value -is [System.Collections.IEnumerable] -and $value -isnot [string]) {
        return @($value)
    }

    return @($value)
}

function Add-UniqueString {
    param(
        [System.Collections.Generic.List[object]]$List,
        [string]$Value
    )

    foreach ($entry in $List) {
        if ($entry -is [string] -and $entry -eq $Value) {
            return
        }
    }

    $List.Add($Value)
}

function Remove-LegacyEntries {
    param(
        [object[]]$Entries,
        [string[]]$LegacyPaths
    )

    $result = [System.Collections.Generic.List[object]]::new()
    foreach ($entry in $Entries) {
        if ($entry -is [string] -and $LegacyPaths -contains $entry) {
            continue
        }
        $result.Add($entry)
    }
    return ,$result.ToArray()
}

function Resolve-RepositoryPath {
    param(
        [string]$RepoRoot,
        [string]$Path
    )

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return $Path
    }

    return Join-Path $RepoRoot $Path
}

function Read-JsonSettings {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return [ordered]@{}
    }

    $rawJson = Get-Content -Raw -Path $Path
    if ([string]::IsNullOrWhiteSpace($rawJson)) {
        return [ordered]@{}
    }

    $json = Remove-JsonComments $rawJson
    $json = [regex]::Replace($json, ",(\s*[\]}])", '$1')
    return ConvertTo-OrderedHashtable ($json | ConvertFrom-Json)
}

function Set-LibrarySetting {
    param(
        [System.Collections.IDictionary]$Settings,
        [string]$Key,
        [string]$LibraryPath,
        [string[]]$LegacyPaths
    )

    $libraryEntries = Remove-LegacyEntries (Get-ArraySetting $Settings $Key) $LegacyPaths
    $library = [System.Collections.Generic.List[object]]::new()
    foreach ($entry in $libraryEntries) {
        $library.Add($entry)
    }

    Add-UniqueString $library $LibraryPath
    $Settings[$Key] = @($library)
}

function Set-MinimumIntegerSetting {
    param(
        [System.Collections.IDictionary]$Settings,
        [string]$Key,
        [int]$Minimum
    )

    if (-not $Settings.Contains($Key) -or $null -eq $Settings[$Key]) {
        $Settings[$Key] = $Minimum
        return
    }

    $current = 0
    if (-not [int]::TryParse([string]$Settings[$Key], [ref]$current) -or $current -lt $Minimum) {
        $Settings[$Key] = $Minimum
    }
}

function Set-StringArraySetting {
    param(
        [System.Collections.IDictionary]$Settings,
        [string]$Key,
        [string[]]$Values
    )

    $entries = Get-ArraySetting $Settings $Key
    $updated = [System.Collections.Generic.List[object]]::new()
    foreach ($entry in $entries) {
        $updated.Add($entry)
    }

    foreach ($value in $Values) {
        Add-UniqueString $updated $value
    }

    $Settings[$Key] = @($updated)
}

function Write-JsonSettings {
    param(
        [System.Collections.IDictionary]$Settings,
        [string]$Path
    )

    $jsonOutput = ($Settings | ConvertTo-Json -Depth 20)
    $jsonOutput = $jsonOutput.TrimEnd() + [Environment]::NewLine
    Set-Content -Path $Path -Value $jsonOutput -Encoding UTF8
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$fullSettingsPath = Resolve-RepositoryPath $repoRoot $SettingsPath
$settingsDirectory = Split-Path -Parent $fullSettingsPath
if (-not (Test-Path $settingsDirectory)) {
    New-Item -ItemType Directory -Path $settingsDirectory | Out-Null
}

$settings = Read-JsonSettings $fullSettingsPath
$legacyLibraryPaths = @(
    "./docs/lua_api.lua",
    "docs/lua_api.lua",
    '${workspaceFolder}/docs/lua_api.lua',
    "./docs/lua-api/lua_api.lua",
    "docs/lua-api/lua_api.lua",
    '${workspaceFolder}/docs/lua-api/lua_api.lua'
)

Set-LibrarySetting $settings "Lua.workspace.library" $LuaApiLibraryPath $legacyLibraryPaths

$legacyRuntimePluginPaths = @(
    "./docs/lua_api.json",
    "docs/lua_api.json",
    '${workspaceFolder}/docs/lua_api.json',
    "./docs/lua-api/lua_api.json",
    "docs/lua-api/lua_api.json",
    '${workspaceFolder}/docs/lua-api/lua_api.json'
)

if ($settings.Contains("Lua.runtime.plugin")) {
    $pluginEntries = Remove-LegacyEntries (Get-ArraySetting $settings "Lua.runtime.plugin") $legacyRuntimePluginPaths
    if ($pluginEntries.Count -gt 0) {
        $settings["Lua.runtime.plugin"] = @($pluginEntries)
    } else {
        $settings.Remove("Lua.runtime.plugin")
    }
}

if (-not $settings.Contains("Lua.workspace.checkThirdParty")) {
    $settings["Lua.workspace.checkThirdParty"] = $false
}

if ($PSCmdlet.ShouldProcess($fullSettingsPath, "Update VSCode LuaLS settings")) {
    Write-JsonSettings $settings $fullSettingsPath
}

$updatedLuaRc = $false
$fullLuaRcPath = Resolve-RepositoryPath $repoRoot $LuaRcPath
if (Test-Path $fullLuaRcPath) {
    $luaRcSettings = Read-JsonSettings $fullLuaRcPath
    Set-LibrarySetting $luaRcSettings "workspace.library" $LuaRcLibraryPath $legacyLibraryPaths
    Set-MinimumIntegerSetting $luaRcSettings "workspace.preloadFileSize" $MinimumPreloadFileSizeKb
    Set-StringArraySetting $luaRcSettings "workspace.ignoreDir" $LuaRcIgnoreDirectories
    if (-not $luaRcSettings.Contains("workspace.checkThirdParty")) {
        $luaRcSettings["workspace.checkThirdParty"] = $false
    }

    if ($PSCmdlet.ShouldProcess($fullLuaRcPath, "Update LuaLS project settings")) {
        Write-JsonSettings $luaRcSettings $fullLuaRcPath
    }
    $updatedLuaRc = $true
}

Write-Host "VSCode Lua API library configured: $LuaApiLibraryPath"
Write-Host "Settings file: $SettingsPath"
if ($updatedLuaRc) {
    Write-Host "LuaLS project config updated: $LuaRcPath"
}
Write-Host "Install the VSCode Lua extension if it is not installed."
