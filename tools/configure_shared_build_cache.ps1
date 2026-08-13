[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter()]
    [string] $CacheRoot,

    [Parameter()]
    [switch] $AuditOnly,

    [Parameter()]
    [switch] $CleanTransientVcpkg,

    [Parameter()]
    [string[]] $CleanSharedFingerprintTransients = @(),

    [Parameter()]
    [switch] $UnregisterCurrentRepository
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($env:OS -ne "Windows_NT") {
    throw "This helper persists Windows user environment variables. Follow docs/development/shared-build-cache.md for non-Windows setup."
}

if (
    $AuditOnly -and
    ($CleanTransientVcpkg -or $CleanSharedFingerprintTransients.Count -gt 0 -or $UnregisterCurrentRepository)
) {
    throw "-AuditOnly cannot be combined with a mutating option."
}

function Get-EnvironmentValue {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Name
    )

    foreach ($scope in @("Process", "User", "Machine")) {
        $value = [Environment]::GetEnvironmentVariable($Name, $scope)
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            return $value
        }
    }

    return $null
}

function Get-FullPath {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    $fullPath = [IO.Path]::GetFullPath($Path)
    $pathRoot = [IO.Path]::GetPathRoot($fullPath)
    if ($fullPath -eq $pathRoot) {
        return $fullPath
    }

    return $fullPath.TrimEnd(
        [IO.Path]::DirectorySeparatorChar,
        [IO.Path]::AltDirectorySeparatorChar
    )
}

function Get-SolutionCacheDefinition {
    param(
        [Parameter(Mandatory = $true)]
        [string] $RepositoryRoot
    )

    foreach ($relativeProjectPath in @(
        "vcproj\canary.vcxproj",
        "vc18\otclient.vcxproj",
        "vc17\otclient.vcxproj"
    )) {
        $projectPath = Join-Path $RepositoryRoot $relativeProjectPath
        if (-not (Test-Path -LiteralPath $projectPath -PathType Leaf)) {
            continue
        }

        try {
            [xml] $project = Get-Content -LiteralPath $projectPath -Raw
        } catch {
            throw "The Solution cache project is malformed: $projectPath"
        }
        $configurations = @(
            $project.SelectNodes("//*[local-name()='ProjectConfiguration']") |
                ForEach-Object { [string] $_.Include } |
                Where-Object { $_ -match '^(.+)\|x64$' } |
                ForEach-Object { ($_ -split '\|', 2)[0] } |
                Select-Object -Unique
        )
        if ($configurations.Count -eq 0) {
            throw "The Solution cache project declares no x64 configurations: $projectPath"
        }

        $projectDirectory = Split-Path -Parent $projectPath
        return [pscustomobject]@{
            Project        = $projectPath
            Props          = Join-Path $projectDirectory ".canary-shared-cache\SharedVcpkgCache.props"
            Configurations = $configurations
        }
    }

    return $null
}

function Assert-LocalFixedVolume {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string] $Description
    )

    $fullPath = Get-FullPath -Path $Path
    $existingPath = $fullPath
    while (-not (Test-Path -LiteralPath $existingPath)) {
        $parentPath = Split-Path -Parent $existingPath
        if ([string]::IsNullOrWhiteSpace($parentPath) -or $parentPath -eq $existingPath) {
            throw "$Description has no verifiable existing filesystem ancestor: $fullPath"
        }
        $existingPath = $parentPath
    }
    while (-not [string]::IsNullOrWhiteSpace($existingPath)) {
        $existingItem = Get-Item -LiteralPath $existingPath -Force
        if ($existingItem.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            throw "$Description traverses a reparse point and cannot prove local filesystem semantics: $existingPath"
        }
        $parentPath = Split-Path -Parent $existingPath
        if ([string]::IsNullOrWhiteSpace($parentPath) -or $parentPath -eq $existingPath) {
            break
        }
        $existingPath = $parentPath
    }

    $pathRoot = [IO.Path]::GetPathRoot($fullPath)
    if ([string]::IsNullOrWhiteSpace($pathRoot)) {
        throw "$Description does not resolve to a filesystem volume: $fullPath"
    }
    $drive = [IO.DriveInfo]::new($pathRoot)
    if (-not $drive.IsReady -or $drive.DriveType -ne [IO.DriveType]::Fixed) {
        throw "$Description must use a ready local fixed volume: $fullPath"
    }
}

function Test-PathWithin {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string] $Parent
    )

    $fullPath = "$(Get-FullPath -Path $Path)$([IO.Path]::DirectorySeparatorChar)"
    $fullParent = "$(Get-FullPath -Path $Parent)$([IO.Path]::DirectorySeparatorChar)"
    return $fullPath.StartsWith($fullParent, [StringComparison]::OrdinalIgnoreCase)
}

function Test-SharedFingerprintIdentity {
    param(
        [Parameter(Mandatory = $true)]
        [string] $CacheRoot,
        [Parameter(Mandatory = $true)]
        [string] $Schema,
        [Parameter(Mandatory = $true)]
        [string] $Fingerprint
    )

    if ($Schema -notmatch "^v[0-9]+$" -or $Fingerprint -notmatch "^[0-9a-fA-F]{64}$") {
        return $false
    }
    $shortFingerprint = $Fingerprint.Substring(0, 24).ToLowerInvariant()
    $identityPath = Join-Path $CacheRoot "metadata\$Schema\$shortFingerprint.txt"
    if (-not (Test-Path -LiteralPath $identityPath -PathType Leaf)) {
        return $false
    }
    try {
        Assert-LocalFixedVolume -Path $identityPath -Description "The shared fingerprint identity"
    } catch {
        return $false
    }
    $identityLine = Get-Content -LiteralPath $identityPath |
        Where-Object { $_.StartsWith("fingerprint=", [StringComparison]::OrdinalIgnoreCase) } |
        Select-Object -First 1
    return $identityLine -eq "fingerprint=$Fingerprint"
}

function Set-UserEnvironmentValue {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string] $Value
    )

    $currentValue = [Environment]::GetEnvironmentVariable($Name, "User")
    if ($currentValue -eq $Value) {
        return $false
    }

    if ($PSCmdlet.ShouldProcess("Windows user environment", "set $Name")) {
        [Environment]::SetEnvironmentVariable($Name, $Value, "User")
        [Environment]::SetEnvironmentVariable($Name, $Value, "Process")
        return $true
    }

    return $false
}

function Enter-SharedCacheOperationLock {
    param(
        [Parameter(Mandatory = $true)]
        [string] $LockPath,

        [Parameter(Mandatory = $true)]
        [IO.FileMode] $FileMode
    )

    $deadline = [DateTime]::UtcNow.AddSeconds(30)
    while ($true) {
        try {
            return [IO.File]::Open(
                $LockPath,
                $FileMode,
                [IO.FileAccess]::ReadWrite,
                [IO.FileShare]::None
            )
        } catch [IO.IOException] {
            if ([DateTime]::UtcNow -ge $deadline) {
                throw "Unable to acquire the shared-cache operation lock within 30 seconds: $LockPath"
            }
            Start-Sleep -Milliseconds 100
        }
    }
}

function Get-GitCommonDirectory {
    param(
        [Parameter(Mandatory = $true)]
        [string] $RepositoryRoot
    )

    $commonDirectory = (& git -C $RepositoryRoot rev-parse --path-format=absolute --git-common-dir 2>$null).Trim()
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($commonDirectory)) {
        throw "Unable to identify the Git common directory for $RepositoryRoot."
    }

    return (Get-FullPath -Path $commonDirectory)
}

function Get-RegisteredGitCommonDirectories {
    param(
        [Parameter(Mandatory = $true)]
        [string] $RegistryPath
    )

    if (-not (Test-Path -LiteralPath $RegistryPath -PathType Leaf)) {
        return @()
    }

    $registry = Get-Content -Raw -LiteralPath $RegistryPath | ConvertFrom-Json
    if ($registry.schema -ne 2) {
        throw "Unsupported shared-cache repository registry schema in $RegistryPath."
    }

    return @(
        $registry.repositories |
            ForEach-Object {
                if ([string]::IsNullOrWhiteSpace($_.gitCommonDir)) {
                    throw "The shared-cache repository registry contains an empty Git common directory."
                }
                [pscustomobject]@{
                    GitCommonDirectory = Get-FullPath -Path $_.gitCommonDir
                    WorktreeRoots      = @(
                        $_.worktreeRoots |
                            ForEach-Object { Get-FullPath -Path $_ }
                    )
                }
            }
    )
}

function Set-RegisteredGitCommonDirectories {
    param(
        [Parameter(Mandatory = $true)]
        [string] $RegistryPath,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [string[]] $GitCommonDirectories,

        [Parameter()]
        [string] $RemoveGitCommonDirectory
    )

    $registryDirectory = Split-Path -Parent $RegistryPath
    [void] (New-Item -ItemType Directory -Path $registryDirectory -Force)
    $registryLockPath = "$RegistryPath.lock"
    $registryLock = $null
    try {
        $registryLock = [IO.File]::Open(
            $registryLockPath,
            [IO.FileMode]::OpenOrCreate,
            [IO.FileAccess]::ReadWrite,
            [IO.FileShare]::None
        )
        $finalGitCommonDirectories = [Collections.Generic.HashSet[string]]::new(
            [StringComparer]::OrdinalIgnoreCase
        )
        $registeredSnapshots = @{}
        foreach ($registeredRepository in Get-RegisteredGitCommonDirectories -RegistryPath $RegistryPath) {
            [void] $finalGitCommonDirectories.Add($registeredRepository.GitCommonDirectory)
            $registeredSnapshots[$registeredRepository.GitCommonDirectory] = @($registeredRepository.WorktreeRoots)
        }
        foreach ($gitCommonDirectory in $GitCommonDirectories) {
            [void] $finalGitCommonDirectories.Add((Get-FullPath -Path $gitCommonDirectory))
        }
        if (-not [string]::IsNullOrWhiteSpace($RemoveGitCommonDirectory)) {
            [void] $finalGitCommonDirectories.Remove((Get-FullPath -Path $RemoveGitCommonDirectory))
        }

        $registry = [ordered]@{
            schema       = 2
            repositories = @(
                $finalGitCommonDirectories |
                    Sort-Object -Unique |
                    ForEach-Object {
                        $enumerationComplete = $false
                        $worktreeRoots = @(
                            Get-GitWorktreeRoots `
                                -GitCommonDirectory $_ `
                                -Complete ([ref] $enumerationComplete)
                        )
                        if (-not $enumerationComplete -and $registeredSnapshots.ContainsKey($_)) {
                            $worktreeRoots = @(
                                $worktreeRoots + $registeredSnapshots[$_] |
                                    Sort-Object -Unique
                            )
                        }
                        $normalizedCommonDirectory = $_.Replace("\", "/").ToLowerInvariant()
                        $pathBytes = [Text.Encoding]::UTF8.GetBytes($normalizedCommonDirectory)
                        $sha256 = [Security.Cryptography.SHA256]::Create()
                        try {
                            $repositoryId = [Convert]::ToHexString($sha256.ComputeHash($pathBytes)).ToLowerInvariant()
                        } finally {
                            $sha256.Dispose()
                        }
                        [ordered]@{
                            id           = $repositoryId
                            gitCommonDir = $_
                            worktreeRoots = @($worktreeRoots | Sort-Object -Unique)
                        }
                    }
            )
        }
        $json = $registry | ConvertTo-Json -Depth 4
        $temporaryPath = "$RegistryPath.$PID.tmp"
        [IO.File]::WriteAllText(
            $temporaryPath,
            "$json$([Environment]::NewLine)",
            [Text.UTF8Encoding]::new($false)
        )
        try {
            if (Test-Path -LiteralPath $RegistryPath -PathType Leaf) {
                [IO.File]::Move($temporaryPath, $RegistryPath, $true)
            } else {
                [IO.File]::Move($temporaryPath, $RegistryPath)
            }
        } finally {
            if (Test-Path -LiteralPath $temporaryPath -PathType Leaf) {
                Remove-Item -LiteralPath $temporaryPath -Force
            }
        }
    } catch [IO.IOException] {
        throw "Unable to update the shared-cache repository registry: $($_.Exception.Message)"
    } finally {
        if ($null -ne $registryLock) {
            $registryLock.Dispose()
        }
    }
}

function Get-GitWorktreeRoots {
    param(
        [Parameter(Mandatory = $true)]
        [string] $GitCommonDirectory,

        [Parameter()]
        [ref] $Complete
    )

    if ($null -ne $Complete) {
        $Complete.Value = $false
    }

    if (-not (Test-Path -LiteralPath $GitCommonDirectory)) {
        Write-Warning "Registered Git common directory is unavailable and remains registered: $GitCommonDirectory"
        return @()
    }

    $worktreeOutput = & git "--git-dir=$GitCommonDirectory" worktree list --porcelain 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Unable to enumerate the registered Git repository: $GitCommonDirectory"
        return @()
    }

    $worktreeRoots = @()
    $enumerationComplete = $true
    foreach ($worktreeLine in $worktreeOutput | Where-Object { $_ -like "worktree *" }) {
        $worktreeRoot = Get-FullPath -Path $worktreeLine.Substring(9)
        if (-not (Test-Path -LiteralPath $worktreeRoot -PathType Container)) {
            Write-Warning "Registered worktree is unavailable and was excluded from the active roots: $worktreeRoot"
            $enumerationComplete = $false
            continue
        }
        try {
            $actualGitCommonDirectory = Get-GitCommonDirectory -RepositoryRoot $worktreeRoot
        } catch {
            Write-Warning "Registered worktree could not be verified and was excluded: $worktreeRoot"
            $enumerationComplete = $false
            continue
        }
        if ($actualGitCommonDirectory -ne (Get-FullPath -Path $GitCommonDirectory)) {
            Write-Warning "Registered worktree resolves to another Git common directory and was excluded: $worktreeRoot"
            $enumerationComplete = $false
            continue
        }
        $worktreeRoots += $worktreeRoot
    }

    if ($null -ne $Complete) {
        $Complete.Value = $enumerationComplete
    }

    return $worktreeRoots
}

function Get-CMakeCacheValue {
    param(
        [Parameter(Mandatory = $true)]
        [string] $CachePath,

        [Parameter(Mandatory = $true)]
        [string] $Name
    )

    $match = Select-String -LiteralPath $CachePath -Pattern "^$([regex]::Escape($Name)):[^=]+=(.*)$" |
        Select-Object -First 1
    if ($null -eq $match) {
        return $null
    }

    return $match.Matches[0].Groups[1].Value
}

function Assert-NoActiveBuildProcesses {
    $buildProcessNames = @(
        "cc",
        "cc1",
        "cc1plus",
        "cl",
        "clang",
        "clang++",
        "clang-cl",
        "cmake",
        "c++",
        "g++",
        "gcc",
        "jom",
        "ld",
        "link",
        "lld",
        "lld-link",
        "make",
        "msbuild",
        "ninja",
        "protoc",
        "vcpkg"
    )
    $activeBuildProcesses = @(Get-Process -Name $buildProcessNames -ErrorAction SilentlyContinue)
    if ($activeBuildProcesses.Count -eq 0) {
        return
    }

    $processSummary = ($activeBuildProcesses |
        Sort-Object ProcessName, Id |
        ForEach-Object { "$($_.ProcessName):$($_.Id)" }) -join ", "
    throw "Refusing to clean transient directories while build-related processes are running: $processSummary"
}

$repositoryRoot = (& git rev-parse --show-toplevel 2>$null).Trim()
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($repositoryRoot)) {
    throw "Run this helper from a Canary Git worktree."
}
$repositoryRoot = Get-FullPath -Path $repositoryRoot
$currentGitCommonDirectory = Get-GitCommonDirectory -RepositoryRoot $repositoryRoot

$vcpkgRoot = Get-EnvironmentValue -Name "VCPKG_ROOT"
if ([string]::IsNullOrWhiteSpace($vcpkgRoot)) {
    throw "VCPKG_ROOT must point to the shared vcpkg installation."
}
$vcpkgRoot = Get-FullPath -Path $vcpkgRoot
if (-not (Test-Path -LiteralPath (Join-Path $vcpkgRoot "vcpkg.exe") -PathType Leaf)) {
    throw "VCPKG_ROOT does not contain vcpkg.exe: $vcpkgRoot"
}

if ([string]::IsNullOrWhiteSpace($CacheRoot)) {
    $CacheRoot = Get-EnvironmentValue -Name "CANARY_SHARED_CACHE_ROOT"
}
if ([string]::IsNullOrWhiteSpace($CacheRoot)) {
    $CacheRoot = Join-Path (Split-Path -Parent $vcpkgRoot) "canary-build-cache"
}
$CacheRoot = Get-FullPath -Path $CacheRoot
if ($CacheRoot.StartsWith("\\", [StringComparison]::Ordinal)) {
    throw "The shared cache must use a local filesystem, not a UNC path."
}
Assert-LocalFixedVolume -Path $CacheRoot -Description "The shared cache"
$repositoryRegistryPath = Get-FullPath -Path (Join-Path $CacheRoot "registry\v2\repositories.json")
$operationLockPath = Get-FullPath -Path (Join-Path $CacheRoot "registry\v2\operation.lock")
$operationLock = $null
if (-not $WhatIfPreference) {
    if ($AuditOnly) {
        if (-not (Test-Path -LiteralPath $operationLockPath -PathType Leaf)) {
            throw "Audit cannot prove a stable registry snapshot because the shared-cache operation lock is not initialized. Run normal setup first."
        }
        $operationLock = Enter-SharedCacheOperationLock -LockPath $operationLockPath -FileMode Open
    } else {
        [void] (New-Item -ItemType Directory -Path (Split-Path -Parent $operationLockPath) -Force)
        $operationLock = Enter-SharedCacheOperationLock -LockPath $operationLockPath -FileMode OpenOrCreate
    }
}

try {
if ($UnregisterCurrentRepository) {
    if (-not (Test-Path -LiteralPath $repositoryRegistryPath -PathType Leaf)) {
        throw "The current repository cannot be unregistered because no repository registry exists."
    }
    if ($PSCmdlet.ShouldProcess($repositoryRegistryPath, "unregister the current Git repository")) {
        Set-RegisteredGitCommonDirectories `
            -RegistryPath $repositoryRegistryPath `
            -GitCommonDirectories @() `
            -RemoveGitCommonDirectory $currentGitCommonDirectory
    }
    if ($WhatIfPreference) {
        Write-Output "Preview only: -WhatIf prevented repository registry changes."
    } else {
        $remainingWorktreeRootSet = [Collections.Generic.HashSet[string]]::new(
            [StringComparer]::OrdinalIgnoreCase
        )
        foreach ($remainingRepository in Get-RegisteredGitCommonDirectories -RegistryPath $repositoryRegistryPath) {
            $remainingEnumerationComplete = $false
            $remainingRoots = @(
                Get-GitWorktreeRoots `
                    -GitCommonDirectory $remainingRepository.GitCommonDirectory `
                    -Complete ([ref] $remainingEnumerationComplete)
            )
            if (-not $remainingEnumerationComplete) {
                $remainingRoots = @(
                    $remainingRoots + $remainingRepository.WorktreeRoots |
                        Sort-Object -Unique
                )
            }
            foreach ($remainingRoot in $remainingRoots) {
                [void] $remainingWorktreeRootSet.Add($remainingRoot)
            }
        }

        $updatedBaseDirSet = [Collections.Generic.HashSet[string]]::new(
            [StringComparer]::OrdinalIgnoreCase
        )
        $existingBaseDirs = Get-EnvironmentValue -Name "SCCACHE_BASEDIRS"
        if (-not [string]::IsNullOrWhiteSpace($existingBaseDirs)) {
            foreach ($baseDir in $existingBaseDirs.Split(";", [StringSplitOptions]::RemoveEmptyEntries)) {
                [void] $updatedBaseDirSet.Add((Get-FullPath -Path $baseDir))
            }
        }
        $previousManagedBaseDirs = Get-EnvironmentValue -Name "CANARY_SCCACHE_BASEDIRS"
        if (-not [string]::IsNullOrWhiteSpace($previousManagedBaseDirs)) {
            foreach ($baseDir in $previousManagedBaseDirs.Split(";", [StringSplitOptions]::RemoveEmptyEntries)) {
                [void] $updatedBaseDirSet.Remove((Get-FullPath -Path $baseDir))
            }
        }
        foreach ($remainingRoot in $remainingWorktreeRootSet) {
            [void] $updatedBaseDirSet.Add($remainingRoot)
        }
        $remainingManagedRoots = ($remainingWorktreeRootSet | Sort-Object) -join ";"
        $updatedBaseDirs = ($updatedBaseDirSet | Sort-Object) -join ";"
        [void] (Set-UserEnvironmentValue -Name "CANARY_SCCACHE_BASEDIRS" -Value $remainingManagedRoots)
        [void] (Set-UserEnvironmentValue -Name "SCCACHE_BASEDIRS" -Value $updatedBaseDirs)
        Write-Output "The current Git repository family was removed from the shared-cache registry and managed sccache roots."
    }
    return
}

$registeredRepositorySnapshots = @{}
$registeredGitCommonDirectories = [Collections.Generic.HashSet[string]]::new(
    [StringComparer]::OrdinalIgnoreCase
)
foreach ($registeredRepository in Get-RegisteredGitCommonDirectories -RegistryPath $repositoryRegistryPath) {
    [void] $registeredGitCommonDirectories.Add($registeredRepository.GitCommonDirectory)
    $registeredRepositorySnapshots[$registeredRepository.GitCommonDirectory] = @($registeredRepository.WorktreeRoots)
}
$legacyManagedBaseDirs = Get-EnvironmentValue -Name "CANARY_SCCACHE_BASEDIRS"
if (-not [string]::IsNullOrWhiteSpace($legacyManagedBaseDirs)) {
    foreach ($legacyWorktreeRoot in $legacyManagedBaseDirs.Split(";", [StringSplitOptions]::RemoveEmptyEntries)) {
        if (-not (Test-Path -LiteralPath $legacyWorktreeRoot -PathType Container)) {
            continue
        }
        try {
            $legacyGitCommonDirectory = Get-GitCommonDirectory -RepositoryRoot $legacyWorktreeRoot
            [void] $registeredGitCommonDirectories.Add($legacyGitCommonDirectory)
        } catch {
            Write-Warning "Unable to migrate a legacy managed sccache root into the repository registry: $legacyWorktreeRoot"
        }
    }
}
$currentRepositoryRegistered = $registeredGitCommonDirectories.Contains($currentGitCommonDirectory)
$currentRepositoryIsAuditCandidate = $AuditOnly -and -not $currentRepositoryRegistered
if (-not $AuditOnly -or $currentRepositoryIsAuditCandidate) {
    [void] $registeredGitCommonDirectories.Add($currentGitCommonDirectory)
}

$worktreeRootSet = [Collections.Generic.HashSet[string]]::new(
    [StringComparer]::OrdinalIgnoreCase
)
$auditIncomplete = $currentRepositoryIsAuditCandidate
$repositoryFamilies = @(
    foreach ($gitCommonDirectory in $registeredGitCommonDirectories | Sort-Object) {
        $familyEnumerationComplete = $false
        $familyWorktreeRoots = @(
            Get-GitWorktreeRoots `
                -GitCommonDirectory $gitCommonDirectory `
                -Complete ([ref] $familyEnumerationComplete)
        )
        $available = (Test-Path -LiteralPath $gitCommonDirectory) -and $familyEnumerationComplete
        if (-not $available) {
            $auditIncomplete = $true
        }
        if (-not $familyEnumerationComplete -and $registeredRepositorySnapshots.ContainsKey($gitCommonDirectory)) {
            $familyWorktreeRoots = @(
                $familyWorktreeRoots + $registeredRepositorySnapshots[$gitCommonDirectory] |
                    Sort-Object -Unique
            )
        }
        foreach ($worktreeRoot in $familyWorktreeRoots) {
            [void] $worktreeRootSet.Add($worktreeRoot)
        }
        [pscustomobject]@{
            GitCommonDirectory = $gitCommonDirectory
            Worktrees          = $familyWorktreeRoots.Count
            Available          = $available
            Registered         = $gitCommonDirectory -ne $currentGitCommonDirectory -or $currentRepositoryRegistered -or -not $AuditOnly
        }
    }
)
$worktreeRoots = @($worktreeRootSet | Sort-Object)
$validationRoots = @($worktreeRoots + $repositoryRoot | Sort-Object -Unique)

if ($CacheRoot.StartsWith("\\", [StringComparison]::Ordinal)) {
    throw "The shared cache must use a local filesystem, not a UNC path."
}
Assert-LocalFixedVolume -Path $CacheRoot -Description "The shared cache"
Assert-LocalFixedVolume -Path $vcpkgRoot -Description "VCPKG_ROOT"
foreach ($worktreeRoot in $validationRoots) {
    Assert-LocalFixedVolume -Path $worktreeRoot -Description "Registered worktree"
    if (
        (Test-PathWithin -Path $CacheRoot -Parent $worktreeRoot) -or
        (Test-PathWithin -Path $worktreeRoot -Parent $CacheRoot)
    ) {
        throw "The shared cache must be separate from every worktree hierarchy: $worktreeRoot"
    }
}

$vcpkgVisualStudioPath = Get-EnvironmentValue -Name "CANARY_VCPKG_VISUAL_STUDIO_PATH"
$explicitVcpkgVisualStudioPath = Get-EnvironmentValue -Name "VCPKG_VISUAL_STUDIO_PATH"
$visualStudioDetectionStatus = $null
if (-not [string]::IsNullOrWhiteSpace($explicitVcpkgVisualStudioPath)) {
    $vcpkgVisualStudioPath = $explicitVcpkgVisualStudioPath
    $visualStudioDetectionStatus = "using an existing explicit vcpkg override"
}
if ([string]::IsNullOrWhiteSpace($vcpkgVisualStudioPath) -and -not $AuditOnly) {
    $compilerDetectionRoot = Get-FullPath -Path (Join-Path $CacheRoot "compiler-detection")
    if ($PSCmdlet.ShouldProcess($compilerDetectionRoot, "detect the Visual Studio instance selected by vcpkg")) {
        [void] (New-Item -ItemType Directory -Path $compilerDetectionRoot -Force)
        $compilerDetectionLockPath = Join-Path $compilerDetectionRoot "detection.lock"
        $compilerDetectionLock = $null
        try {
            $compilerDetectionLock = [IO.File]::Open(
                $compilerDetectionLockPath,
                [IO.FileMode]::OpenOrCreate,
                [IO.FileAccess]::ReadWrite,
                [IO.FileShare]::None
            )
            $vcpkgExecutable = Join-Path $vcpkgRoot "vcpkg.exe"
            $compilerArguments = @(
                "env",
                "where cl",
                "--triplet",
                "x64-windows",
                "--x-buildtrees-root=$compilerDetectionRoot"
            )
            $compilerOutput = @(& $vcpkgExecutable @compilerArguments 2>&1)
            if ($LASTEXITCODE -ne 0) {
                throw "vcpkg could not identify its Visual Studio compiler: $($compilerOutput -join [Environment]::NewLine)"
            }
            $vcpkgCompiler = $compilerOutput |
                ForEach-Object { $_.ToString().Trim() } |
                Where-Object {
                    -not [string]::IsNullOrWhiteSpace($_) -and
                    (Split-Path -Leaf $_) -eq "cl.exe" -and
                    (Test-Path -LiteralPath $_ -PathType Leaf)
                } |
                Select-Object -First 1
            if ([string]::IsNullOrWhiteSpace($vcpkgCompiler)) {
                throw "vcpkg did not return a verifiable cl.exe path."
            }
            if ($vcpkgCompiler -notmatch "^(?<root>.+)\\VC\\Tools\\MSVC\\[^\\]+\\bin\\[^\\]+\\[^\\]+\\cl\.exe$") {
                throw "Unexpected vcpkg compiler layout: $vcpkgCompiler"
            }
            $vcpkgVisualStudioPath = Get-FullPath -Path $Matches.root
            $visualStudioDetectionStatus = "detected from vcpkg compiler selection"
        } finally {
            if ($null -ne $compilerDetectionLock) {
                $compilerDetectionLock.Dispose()
            }
        }
    }
}
if (-not [string]::IsNullOrWhiteSpace($vcpkgVisualStudioPath)) {
    $vcpkgVisualStudioPath = Get-FullPath -Path $vcpkgVisualStudioPath
    $vcvarsPath = Join-Path $vcpkgVisualStudioPath "VC\Auxiliary\Build\vcvarsall.bat"
    if (-not (Test-Path -LiteralPath $vcvarsPath -PathType Leaf)) {
        throw "The pinned vcpkg Visual Studio path is not a complete C++ installation: $vcpkgVisualStudioPath"
    }
}

$binaryCache = Get-EnvironmentValue -Name "VCPKG_DEFAULT_BINARY_CACHE"
if ([string]::IsNullOrWhiteSpace($binaryCache)) {
    $binaryCache = Join-Path $CacheRoot "vcpkg-binary-cache"
}
$binaryCache = Get-FullPath -Path $binaryCache

$binarySources = Get-EnvironmentValue -Name "VCPKG_BINARY_SOURCES"
$persistBinarySources = [string]::IsNullOrWhiteSpace($binarySources)
if ([string]::IsNullOrWhiteSpace($binarySources)) {
    $binarySources = "clear;files,$binaryCache,readwrite"
}

$downloadsRoot = Get-EnvironmentValue -Name "VCPKG_DOWNLOADS"
if ([string]::IsNullOrWhiteSpace($downloadsRoot)) {
    $downloadsRoot = Join-Path $CacheRoot "vcpkg-downloads"
}
$downloadsRoot = Get-FullPath -Path $downloadsRoot

$existingBaseDirs = Get-EnvironmentValue -Name "SCCACHE_BASEDIRS"
$previousManagedBaseDirs = Get-EnvironmentValue -Name "CANARY_SCCACHE_BASEDIRS"
$baseDirSet = [Collections.Generic.HashSet[string]]::new(
    [StringComparer]::OrdinalIgnoreCase
)
if (-not [string]::IsNullOrWhiteSpace($existingBaseDirs)) {
    foreach ($baseDir in $existingBaseDirs.Split(";", [StringSplitOptions]::RemoveEmptyEntries)) {
        [void] $baseDirSet.Add((Get-FullPath -Path $baseDir))
    }
}
if (-not [string]::IsNullOrWhiteSpace($previousManagedBaseDirs)) {
    foreach ($baseDir in $previousManagedBaseDirs.Split(";", [StringSplitOptions]::RemoveEmptyEntries)) {
        [void] $baseDirSet.Remove((Get-FullPath -Path $baseDir))
    }
}
foreach ($worktreeRoot in $worktreeRoots) {
    [void] $baseDirSet.Add($worktreeRoot)
}
$sccacheBaseDirs = ($baseDirSet | Sort-Object) -join ";"
$managedSccacheBaseDirs = ($worktreeRoots | Sort-Object -Unique) -join ";"

$environmentValues = [ordered]@{
    CANARY_SHARED_CACHE_ROOT                = $CacheRoot
    CANARY_SHARED_CACHE_LOCAL_FILESYSTEM_VERIFIED = "ON"
    CANARY_SHARED_CACHE_VERIFIED_ROOT       = $CacheRoot
    CANARY_SCCACHE_BASEDIRS                 = $managedSccacheBaseDirs
    VCPKG_DEFAULT_BINARY_CACHE              = $binaryCache
    VCPKG_DOWNLOADS                         = $downloadsRoot
    SCCACHE_BASEDIRS                        = $sccacheBaseDirs
}
if (-not [string]::IsNullOrWhiteSpace($vcpkgVisualStudioPath)) {
    $environmentValues.CANARY_VCPKG_VISUAL_STUDIO_PATH = $vcpkgVisualStudioPath
}
if ($persistBinarySources) {
    $environmentValues.VCPKG_BINARY_SOURCES = $binarySources
}

$reportedEnvironmentValues = [ordered]@{}
foreach ($entry in $environmentValues.GetEnumerator()) {
    $reportedEnvironmentValues[$entry.Key] = $entry.Value
}
$reportedEnvironmentValues.VCPKG_ROOT = "$vcpkgRoot (active input; not managed by this helper)"
$reportedEnvironmentValues.RepositoryRegistry = $repositoryRegistryPath
$reportedEnvironmentValues.VCPKG_BINARY_SOURCES = if ($persistBinarySources) {
    "<local file backend configured by this helper; redacted>"
} else {
    "<existing configuration preserved and not persisted by this helper; redacted>"
}
if ([string]::IsNullOrWhiteSpace($vcpkgVisualStudioPath)) {
    $reportedEnvironmentValues.VCPKG_COMPILER_SELECTION =
        "<not configured; run setup to pin vcpkg compiler selection>"
} elseif (-not [string]::IsNullOrWhiteSpace($visualStudioDetectionStatus)) {
    $reportedEnvironmentValues.VCPKG_COMPILER_SELECTION =
        "$vcpkgVisualStudioPath ($visualStudioDetectionStatus)"
}

if (-not $AuditOnly) {
    foreach ($directory in @(
        $CacheRoot,
        (Join-Path $CacheRoot "vcpkg-installed\v2"),
        (Join-Path $CacheRoot "vcpkg-buildtrees\v2"),
        (Join-Path $CacheRoot "vcpkg-packages\v2"),
        (Join-Path $CacheRoot "metadata\v2"),
        (Join-Path $CacheRoot "vcpkg-installed\v3"),
        (Join-Path $CacheRoot "vcpkg-buildtrees\v3"),
        (Join-Path $CacheRoot "vcpkg-packages\v3"),
        (Join-Path $CacheRoot "metadata\v3"),
        (Join-Path $CacheRoot "registry\v2"),
        $binaryCache,
        $downloadsRoot
    )) {
        if ($PSCmdlet.ShouldProcess($directory, "create cache directory")) {
            [void] (New-Item -ItemType Directory -Path $directory -Force)
        }
    }

    if ($PSCmdlet.ShouldProcess($repositoryRegistryPath, "update registered Git repositories")) {
        $registryArguments = @{
            RegistryPath         = $repositoryRegistryPath
            GitCommonDirectories = @($registeredGitCommonDirectories)
        }
        Set-RegisteredGitCommonDirectories @registryArguments
    }

    $environmentChanged = $false
    foreach ($entry in $environmentValues.GetEnumerator()) {
        if (Set-UserEnvironmentValue -Name $entry.Key -Value $entry.Value) {
            $environmentChanged = $true
        }
    }

    if ($environmentChanged) {
        Write-Warning "Environment changes apply automatically to new processes. Restart open terminals after active builds finish; restart the sccache server before measuring cross-worktree hits."
    }

    $solutionCacheScript = Join-Path $repositoryRoot "tools\configure_shared_solution_cache.ps1"
    $solutionDefinition = Get-SolutionCacheDefinition -RepositoryRoot $repositoryRoot
    if (
        (Test-Path -LiteralPath $solutionCacheScript -PathType Leaf) -and
        $null -ne $solutionDefinition
    ) {
        if ([string]::IsNullOrWhiteSpace($vcpkgVisualStudioPath)) {
            throw "The Solution cache bridge requires a pinned Visual Studio instance."
        }
        foreach ($processEnvironmentEntry in @{
            CANARY_SHARED_CACHE_ROOT = $CacheRoot
            CANARY_SHARED_CACHE_LOCAL_FILESYSTEM_VERIFIED = "ON"
            CANARY_SHARED_CACHE_VERIFIED_ROOT = $CacheRoot
            CANARY_VCPKG_VISUAL_STUDIO_PATH = $vcpkgVisualStudioPath
            VCPKG_ROOT = $vcpkgRoot
        }.GetEnumerator()) {
            [Environment]::SetEnvironmentVariable(
                $processEnvironmentEntry.Key,
                $processEnvironmentEntry.Value,
                "Process"
            )
        }
        $solutionCacheArguments = @(
            "-NoLogo",
            "-NoProfile",
            "-NonInteractive",
            "-File",
            $solutionCacheScript,
            "-ProjectFile",
            $solutionDefinition.Project,
            "-OutputProps",
            $solutionDefinition.Props,
            "-Configurations",
            ($solutionDefinition.Configurations -join ","),
            "-CacheRoot",
            $CacheRoot,
            "-VcpkgRoot",
            $vcpkgRoot,
            "-VisualStudioPath",
            $vcpkgVisualStudioPath
        )
        if ($WhatIfPreference) {
            $solutionCacheArguments += "-WhatIf"
        }
        $solutionCacheOutput = @(& pwsh.exe @solutionCacheArguments 2>&1)
        if ($LASTEXITCODE -ne 0) {
            throw "The Solution cache bridge could not be configured.`n$($solutionCacheOutput -join [Environment]::NewLine)"
        }
        $solutionCacheOutput | Write-Output
    }

    if ($CleanTransientVcpkg) {
        Assert-NoActiveBuildProcesses

        $vcpkgLockPath = Join-Path $vcpkgRoot ".vcpkg-root"
        $vcpkgLockStream = $null
        try {
            $vcpkgLockStream = [IO.File]::Open(
                $vcpkgLockPath,
                [IO.FileMode]::Open,
                [IO.FileAccess]::ReadWrite,
                [IO.FileShare]::None
            )

            foreach ($directoryName in @("packages", "buildtrees")) {
                $transientRoot = Get-FullPath -Path (Join-Path $vcpkgRoot $directoryName)
                $transientParent = Get-FullPath -Path (Split-Path -Parent $transientRoot)
                $transientName = Split-Path -Leaf $transientRoot
                $transientItem = Get-Item -LiteralPath $transientRoot -Force -ErrorAction SilentlyContinue
                if (
                    $transientParent -ne $vcpkgRoot -or
                    $transientName -ne $directoryName -or
                    -not (Test-PathWithin -Path $transientRoot -Parent $vcpkgRoot) -or
                    ($null -ne $transientItem -and
                        ($transientItem.Attributes -band [IO.FileAttributes]::ReparsePoint))
                ) {
                    throw "Refusing unsafe transient-cache target: $transientRoot"
                }

                if (-not (Test-Path -LiteralPath $transientRoot -PathType Container)) {
                    continue
                }

                $measurement = Get-ChildItem -LiteralPath $transientRoot -Recurse -File -Force |
                    Measure-Object -Property Length -Sum
                if ($PSCmdlet.ShouldProcess($transientRoot, "remove disposable vcpkg $directoryName data")) {
                    Remove-Item -LiteralPath $transientRoot -Recurse -Force
                    [void] (New-Item -ItemType Directory -Path $transientRoot)
                    $removedGiB = [math]::Round($measurement.Sum / 1GB, 2)
                    Write-Output "Removed $removedGiB GiB from disposable vcpkg $directoryName data. It can be restored from the binary cache or rebuilt."
                }
            }
        } catch [IO.IOException] {
            throw "Refusing to clean because the vcpkg filesystem lock cannot be acquired: $($_.Exception.Message)"
        } finally {
            if ($null -ne $vcpkgLockStream) {
                $vcpkgLockStream.Dispose()
            }
        }
    }

    if ($CleanSharedFingerprintTransients.Count -gt 0) {
        Assert-NoActiveBuildProcesses

        foreach ($fingerprintInput in $CleanSharedFingerprintTransients | Sort-Object -Unique) {
            $fingerprint = $fingerprintInput.Trim().ToLowerInvariant()
            if ($fingerprint -notmatch "^[0-9a-f]{64}$") {
                throw "A shared fingerprint cleanup target must be a full 64-character SHA-256: $fingerprintInput"
            }
            if (-not (Test-SharedFingerprintIdentity -CacheRoot $CacheRoot -Schema "v3" -Fingerprint $fingerprint)) {
                throw "The shared fingerprint identity is missing or does not match: $fingerprint"
            }

            $shortFingerprint = $fingerprint.Substring(0, 24)
            $installedRoot = Get-FullPath -Path (Join-Path $CacheRoot "vcpkg-installed\v3\$shortFingerprint")
            $installedParent = Get-FullPath -Path (Join-Path $CacheRoot "vcpkg-installed\v3")
            if (
                (Get-FullPath -Path (Split-Path -Parent $installedRoot)) -ne $installedParent -or
                (Split-Path -Leaf $installedRoot) -ne $shortFingerprint -or
                -not (Test-PathWithin -Path $installedRoot -Parent $CacheRoot)
            ) {
                throw "Refusing an unsafe shared installed-root lock target: $installedRoot"
            }
            $vcpkgLockPath = Join-Path $installedRoot "vcpkg\vcpkg-running.lock"
            if (-not (Test-Path -LiteralPath $vcpkgLockPath -PathType Leaf)) {
                throw "The shared fingerprint has no vcpkg filesystem lock: $vcpkgLockPath"
            }

            $vcpkgLockStream = $null
            try {
                $vcpkgLockStream = [IO.File]::Open(
                    $vcpkgLockPath,
                    [IO.FileMode]::Open,
                    [IO.FileAccess]::ReadWrite,
                    [IO.FileShare]::None
                )

                foreach ($directoryName in @("vcpkg-buildtrees", "vcpkg-packages")) {
                    $schemaRoot = Get-FullPath -Path (Join-Path $CacheRoot "$directoryName\v3")
                    $transientRoot = Get-FullPath -Path (Join-Path $schemaRoot $shortFingerprint)
                    $transientItem = Get-Item -LiteralPath $transientRoot -Force -ErrorAction SilentlyContinue
                    if (
                        (Get-FullPath -Path (Split-Path -Parent $transientRoot)) -ne $schemaRoot -or
                        (Split-Path -Leaf $transientRoot) -ne $shortFingerprint -or
                        -not (Test-PathWithin -Path $transientRoot -Parent $CacheRoot) -or
                        ($null -ne $transientItem -and
                            ($transientItem.Attributes -band [IO.FileAttributes]::ReparsePoint))
                    ) {
                        throw "Refusing an unsafe shared transient-cache target: $transientRoot"
                    }
                    if (-not (Test-Path -LiteralPath $transientRoot -PathType Container)) {
                        continue
                    }
                    Assert-LocalFixedVolume -Path $transientRoot -Description "The shared transient cache"

                    $measurement = Get-ChildItem -LiteralPath $transientRoot -Recurse -File -Force |
                        Measure-Object -Property Length -Sum
                    if ($PSCmdlet.ShouldProcess($transientRoot, "remove disposable fingerprint-specific vcpkg data")) {
                        Remove-Item -LiteralPath $transientRoot -Recurse -Force
                        [void] (New-Item -ItemType Directory -Path $transientRoot)
                        $removedGiB = [math]::Round($measurement.Sum / 1GB, 2)
                        Write-Output "Removed $removedGiB GiB from $transientRoot. It can be restored from the binary cache or rebuilt."
                    }
                }
            } catch [IO.IOException] {
                throw "Refusing to clean because the fingerprint vcpkg lock cannot be acquired: $($_.Exception.Message)"
            } finally {
                if ($null -ne $vcpkgLockStream) {
                    $vcpkgLockStream.Dispose()
                }
            }
        }
    }
}

Write-Output "Shared cache configuration"
$reportedEnvironmentValues.GetEnumerator() | ForEach-Object {
    [pscustomobject]@{
        Name  = $_.Key
        Value = $_.Value
    }
} | Format-Table -AutoSize | Out-String | Write-Output

Write-Output "Registered Git repository families"
if ($repositoryFamilies.Count -eq 0) {
    Write-Output "No Git repository families are registered."
} else {
    $repositoryFamilies | Format-Table -AutoSize -Wrap | Out-String | Write-Output
}

Write-Output "Existing configure trees"
$configureTrees = foreach ($worktreeRoot in $worktreeRoots) {
    $buildRoot = Join-Path $worktreeRoot "build"
    if (-not (Test-Path -LiteralPath $buildRoot -PathType Container)) {
        continue
    }
    $buildRootItem = Get-Item -LiteralPath $buildRoot -Force
    if ($buildRootItem.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        Write-Warning "The build root is a reparse point and cannot be audited safely: $buildRoot"
        $auditIncomplete = $true
        continue
    }

    foreach ($presetDirectory in Get-ChildItem -LiteralPath $buildRoot -Directory -Force |
        Where-Object { -not ($_.Attributes -band [IO.FileAttributes]::ReparsePoint) }) {
        $cachePath = Join-Path $presetDirectory.FullName "CMakeCache.txt"
        if (-not (Test-Path -LiteralPath $cachePath -PathType Leaf)) {
            $orphanedGeneratedArtifacts = @(@(
                (Join-Path $presetDirectory.FullName "build.ninja"),
                (Join-Path $presetDirectory.FullName "canary-shared-cache.txt"),
                (Join-Path $presetDirectory.FullName "CMakeFiles")
            ) | Where-Object { Test-Path -LiteralPath $_ })
            if ($orphanedGeneratedArtifacts.Count -gt 0) {
                Write-Warning "A partially removed configure tree still contains generated artifacts but no CMakeCache.txt: $($presetDirectory.FullName)"
                $auditIncomplete = $true
            }
            continue
        }
        $cacheItem = Get-Item -LiteralPath $cachePath -Force
        if ($cacheItem.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            Write-Warning "CMakeCache.txt is a reparse point and cannot be audited safely: $cachePath"
            $auditIncomplete = $true
            continue
        }

        $cmakeHomeDirectory = Get-CMakeCacheValue -CachePath $cachePath -Name "CMAKE_HOME_DIRECTORY"
        if ([string]::IsNullOrWhiteSpace($cmakeHomeDirectory)) {
            Write-Warning "Ignoring a malformed CMake cache without CMAKE_HOME_DIRECTORY: $cachePath"
            $auditIncomplete = $true
            continue
        }
        if ((Get-FullPath -Path $cmakeHomeDirectory) -ne $worktreeRoot) {
            Write-Warning "Ignoring a CMake cache whose source directory does not match its registered worktree: $cachePath"
            $auditIncomplete = $true
            continue
        }

        $installedRoot = Get-CMakeCacheValue -CachePath $cachePath -Name "VCPKG_INSTALLED_DIR"
        if ([string]::IsNullOrWhiteSpace($installedRoot)) {
            Write-Warning "Ignoring a malformed CMake cache without VCPKG_INSTALLED_DIR: $cachePath"
            $auditIncomplete = $true
            continue
        }
        $sharedActive = Get-CMakeCacheValue -CachePath $cachePath -Name "CANARY_SHARED_VCPKG_ACTIVE"
        $sharedActiveBoolean = $sharedActive -eq "true" -or $sharedActive -eq "ON"
        $dependencyFingerprint = Get-CMakeCacheValue -CachePath $cachePath -Name "CANARY_VCPKG_DEPENDENCY_FINGERPRINT"
        if ([string]::IsNullOrWhiteSpace($dependencyFingerprint)) {
            $dependencyFingerprint = Get-CMakeCacheValue -CachePath $cachePath -Name "CANARY_VCPKG_CACHE_FINGERPRINT"
        }
        $sharedBuildtreesRoot = Get-CMakeCacheValue -CachePath $cachePath -Name "CANARY_SHARED_VCPKG_BUILDTREES_ROOT"
        $sharedPackagesRoot = Get-CMakeCacheValue -CachePath $cachePath -Name "CANARY_SHARED_VCPKG_PACKAGES_ROOT"
        $sharedSchema = ""
        $sharedContractValid = $true
        if ($sharedActiveBoolean) {
            if ($dependencyFingerprint -notmatch "^[0-9a-fA-F]{64}$") {
                $sharedContractValid = $false
            } else {
                foreach ($candidateSchema in @("v1", "v2", "v3")) {
                    $shortFingerprint = $dependencyFingerprint.Substring(0, 24).ToLowerInvariant()
                    $expectedInstalledRoot = Get-FullPath -Path (Join-Path $CacheRoot "vcpkg-installed\$candidateSchema\$shortFingerprint")
                    if ((Get-FullPath -Path $installedRoot).Equals($expectedInstalledRoot, [StringComparison]::OrdinalIgnoreCase)) {
                        $sharedSchema = $candidateSchema
                        break
                    }
                }
                if ([string]::IsNullOrWhiteSpace($sharedSchema)) {
                    $sharedContractValid = $false
                }
            }

            if ($sharedContractValid) {
                $shortFingerprint = $dependencyFingerprint.Substring(0, 24).ToLowerInvariant()
                $expectedBuildtreesRoot = Get-FullPath -Path (Join-Path $CacheRoot "vcpkg-buildtrees\$sharedSchema\$shortFingerprint")
                $expectedPackagesRoot = Get-FullPath -Path (Join-Path $CacheRoot "vcpkg-packages\$sharedSchema\$shortFingerprint")
                $sharedContractValid =
                    -not [string]::IsNullOrWhiteSpace($sharedBuildtreesRoot) -and
                    -not [string]::IsNullOrWhiteSpace($sharedPackagesRoot) -and
                    (Get-FullPath -Path $sharedBuildtreesRoot).Equals($expectedBuildtreesRoot, [StringComparison]::OrdinalIgnoreCase) -and
                    (Get-FullPath -Path $sharedPackagesRoot).Equals($expectedPackagesRoot, [StringComparison]::OrdinalIgnoreCase) -and
                    (Test-SharedFingerprintIdentity -CacheRoot $CacheRoot -Schema $sharedSchema -Fingerprint $dependencyFingerprint)
                if ($sharedContractValid) {
                    try {
                        Assert-LocalFixedVolume -Path $installedRoot -Description "The shared installed root"
                        Assert-LocalFixedVolume -Path $sharedBuildtreesRoot -Description "The shared buildtrees root"
                        Assert-LocalFixedVolume -Path $sharedPackagesRoot -Description "The shared packages root"
                    } catch {
                        $sharedContractValid = $false
                    }
                }
            }

            if (-not $sharedContractValid) {
                Write-Warning "A managed CMake cache does not identify exact, local fingerprint roots with a matching full-hash identity: $cachePath"
                $auditIncomplete = $true
            }
        }
        $legacyInstalledRoot = Get-FullPath -Path (Join-Path $presetDirectory.FullName "vcpkg_installed")
        $legacyPatterns = @(
            $legacyInstalledRoot,
            $legacyInstalledRoot.Replace("\", "/")
        ) | Select-Object -Unique
        $generatedFiles = @($cachePath)
        $ninjaPath = Join-Path $presetDirectory.FullName "build.ninja"
        if (Test-Path -LiteralPath $ninjaPath -PathType Leaf) {
            $ninjaItem = Get-Item -LiteralPath $ninjaPath -Force
            if ($ninjaItem.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                Write-Warning "build.ninja is a reparse point and cannot be audited safely: $ninjaPath"
                $auditIncomplete = $true
                continue
            }
            $generatedFiles += $ninjaPath
        }
        $legacyReferenceSearch = @{
            LiteralPath = $generatedFiles
            SimpleMatch = $true
            Pattern     = $legacyPatterns
            ErrorAction = "Stop"
        }
        $legacyReferences = @(Select-String @legacyReferenceSearch).Count -gt 0

        $sharedInstalledPrefix = Get-FullPath -Path (Join-Path $CacheRoot "vcpkg-installed")
        $sharedInstalledPrefix = $sharedInstalledPrefix.Replace("\", "/").ToLowerInvariant()
        $currentInstalledNormalized = if ([string]::IsNullOrWhiteSpace($installedRoot)) {
            ""
        } else {
            $installedRoot.Replace("\", "/").TrimEnd("/").ToLowerInvariant()
        }
        $staleSharedReferences = $false
        foreach ($generatedFile in $generatedFiles) {
            foreach ($line in Get-Content -LiteralPath $generatedFile) {
                $normalizedLine = $line.Replace("\", "/").ToLowerInvariant()
                if (
                    $normalizedLine.Contains("$sharedInstalledPrefix/") -and
                    -not $normalizedLine.Contains("$currentInstalledNormalized/") -and
                    -not $normalizedLine.EndsWith("=$currentInstalledNormalized")
                ) {
                    $staleSharedReferences = $true
                    break
                }
            }
            if ($staleSharedReferences) {
                break
            }
        }
        [pscustomobject]@{
            Worktree             = $worktreeRoot
            Preset               = $presetDirectory.Name
            SharedActive         = $sharedActiveBoolean
            Schema               = $sharedSchema
            Fingerprint          = $dependencyFingerprint
            LegacyReferences     = $legacyReferences
            StaleSharedReferences = $staleSharedReferences
            Installed            = $installedRoot
        }
    }

    $reparsePresetDirectories = @(
        Get-ChildItem -LiteralPath $buildRoot -Directory -Force |
            Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint }
    )
    foreach ($reparsePresetDirectory in $reparsePresetDirectories) {
        Write-Warning "A build preset directory is a reparse point and cannot be audited safely: $($reparsePresetDirectory.FullName)"
        $auditIncomplete = $true
    }
}

if ($null -eq $configureTrees) {
    Write-Output "No configured build trees found."
} else {
    $configureTrees | Format-Table -AutoSize -Wrap | Out-String | Write-Output
}

Write-Output "Existing Solution dependency contracts"
$solutionTrees = foreach ($worktreeRoot in $worktreeRoots) {
    $solutionDefinition = Get-SolutionCacheDefinition -RepositoryRoot $worktreeRoot
    if ($null -eq $solutionDefinition) {
        continue
    }
    $solutionPropsPath = $solutionDefinition.Props
    if (-not (Test-Path -LiteralPath $solutionPropsPath -PathType Leaf)) {
        continue
    }
    $solutionPropsDirectory = Split-Path -Parent $solutionPropsPath
    $solutionPropsDirectoryItem = Get-Item -LiteralPath $solutionPropsDirectory -Force
    $solutionPropsItem = Get-Item -LiteralPath $solutionPropsPath -Force
    if (
        ($solutionPropsDirectoryItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -or
        ($solutionPropsItem.Attributes -band [IO.FileAttributes]::ReparsePoint)
    ) {
        Write-Warning "Generated Solution cache props use a reparse point and cannot be audited safely: $solutionPropsPath"
        $auditIncomplete = $true
        continue
    }

    try {
        [xml] $solutionProps = Get-Content -LiteralPath $solutionPropsPath -Raw
    } catch {
        Write-Warning "Generated Solution cache props are malformed: $solutionPropsPath"
        $auditIncomplete = $true
        continue
    }

    $activePropertyGroups = @(
        $solutionProps.Project.PropertyGroup |
            Where-Object { $_.CanarySharedVcpkgActive -eq "true" }
    )
    if ($activePropertyGroups.Count -eq 0) {
        Write-Warning "Generated Solution cache props contain no active dependency contract: $solutionPropsPath"
        $auditIncomplete = $true
        continue
    }

    $solutionContractValid = $true
    foreach ($propertyGroup in $activePropertyGroups) {
        $schema = [string] $propertyGroup.CanarySharedVcpkgSchema
        $dependencyFingerprint = [string] $propertyGroup.CanarySharedVcpkgDependencyFingerprint
        $consumerFingerprint = [string] $propertyGroup.CanarySharedVcpkgConsumerFingerprint
        $configurationName = [string] $propertyGroup.CanarySharedVcpkgConfiguration
        $installedRoot = [string] $propertyGroup.VcpkgInstalledDir
        $buildtreesRoot = [string] $propertyGroup.CanarySharedVcpkgBuildtreesRoot
        $packagesRoot = [string] $propertyGroup.CanarySharedVcpkgPackagesRoot

        if (
            $schema -ne "v3" -or
            $dependencyFingerprint -notmatch "^[0-9a-fA-F]{64}$" -or
            $consumerFingerprint -notmatch "^[0-9a-fA-F]{64}$" -or
            [string]::IsNullOrWhiteSpace($configurationName)
        ) {
            Write-Warning "Generated Solution cache props contain an invalid schema or fingerprint: $solutionPropsPath"
            $auditIncomplete = $true
            $solutionContractValid = $false
            continue
        }

        $shortFingerprint = $dependencyFingerprint.Substring(0, 24).ToLowerInvariant()
        $expectedInstalledRoot = Get-FullPath -Path (Join-Path $CacheRoot "vcpkg-installed\$schema\$shortFingerprint")
        $expectedBuildtreesRoot = Get-FullPath -Path (Join-Path $CacheRoot "vcpkg-buildtrees\$schema\$shortFingerprint")
        $expectedPackagesRoot = Get-FullPath -Path (Join-Path $CacheRoot "vcpkg-packages\$schema\$shortFingerprint")
        $exactRoots =
            -not [string]::IsNullOrWhiteSpace($installedRoot) -and
            -not [string]::IsNullOrWhiteSpace($buildtreesRoot) -and
            -not [string]::IsNullOrWhiteSpace($packagesRoot) -and
            (Get-FullPath -Path $installedRoot).Equals($expectedInstalledRoot, [StringComparison]::OrdinalIgnoreCase) -and
            (Get-FullPath -Path $buildtreesRoot).Equals($expectedBuildtreesRoot, [StringComparison]::OrdinalIgnoreCase) -and
            (Get-FullPath -Path $packagesRoot).Equals($expectedPackagesRoot, [StringComparison]::OrdinalIgnoreCase)
        if ($exactRoots) {
            $exactRoots = Test-SharedFingerprintIdentity -CacheRoot $CacheRoot -Schema $schema -Fingerprint $dependencyFingerprint
        }
        if ($exactRoots) {
            try {
                Assert-LocalFixedVolume -Path $installedRoot -Description "The Solution installed root"
                Assert-LocalFixedVolume -Path $buildtreesRoot -Description "The Solution buildtrees root"
                Assert-LocalFixedVolume -Path $packagesRoot -Description "The Solution packages root"
            } catch {
                $exactRoots = $false
            }
        }
        if (-not $exactRoots) {
            Write-Warning "Generated Solution cache props do not identify exact, local fingerprint roots with a matching full-hash identity: $solutionPropsPath"
            $auditIncomplete = $true
            $solutionContractValid = $false
        }

        [pscustomobject]@{
            Worktree    = $worktreeRoot
            Configuration = $configurationName
            Dependency  = $dependencyFingerprint
            Consumer    = $consumerFingerprint
            Installed   = $installedRoot
        }
    }

    if ($AuditOnly -and $solutionContractValid) {
        $solutionAuditScript = Join-Path $worktreeRoot "tools\configure_shared_solution_cache.ps1"
        if (
            -not (Test-Path -LiteralPath $solutionAuditScript -PathType Leaf) -or
            -not (Test-Path -LiteralPath $solutionDefinition.Project -PathType Leaf) -or
            [string]::IsNullOrWhiteSpace($vcpkgVisualStudioPath)
        ) {
            Write-Warning "A generated Solution contract cannot be re-evaluated from its worktree: $solutionPropsPath"
            $auditIncomplete = $true
            continue
        }
        $solutionAuditConfigurations = @(
            $activePropertyGroups |
                ForEach-Object { [string] $_.CanarySharedVcpkgConfiguration } |
                Select-Object -Unique
        )
        $solutionAuditArguments = @(
            "-NoLogo",
            "-NoProfile",
            "-NonInteractive",
            "-File",
            $solutionAuditScript,
            "-AuditOnly",
            "-ProjectFile",
            $solutionDefinition.Project,
            "-OutputProps",
            $solutionPropsPath,
            "-Configurations",
            ($solutionAuditConfigurations -join ","),
            "-CacheRoot",
            $CacheRoot,
            "-VcpkgRoot",
            $vcpkgRoot,
            "-VisualStudioPath",
            $vcpkgVisualStudioPath
        )
        $solutionAuditOutput = @(& pwsh.exe @solutionAuditArguments 2>&1)
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Generated Solution cache props are stale or cannot be validated: $solutionPropsPath`n$($solutionAuditOutput -join [Environment]::NewLine)"
            $auditIncomplete = $true
        }
    }
}

if ($null -eq $solutionTrees) {
    Write-Output "No generated Solution dependency contracts found."
} else {
    $solutionTrees | Format-Table -AutoSize -Wrap | Out-String | Write-Output
}

if ($AuditOnly) {
    Write-Output "Audit only: no directories or environment variables were changed."
    if ($auditIncomplete) {
        throw "Audit incomplete: a repository is unregistered, unavailable, partially enumerated, or contains a malformed configure tree. Do not prune any shared-cache fingerprint."
    }
} elseif ($WhatIfPreference) {
    Write-Output "Preview only: -WhatIf prevented directory, registry, and environment changes."
} else {
    Write-Output "Setup complete. Reconfigure each preset normally to adopt its content-addressed vcpkg installation."
}
} finally {
    if ($null -ne $operationLock) {
        $operationLock.Dispose()
    }
}
