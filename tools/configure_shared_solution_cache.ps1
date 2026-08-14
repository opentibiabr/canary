[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [ValidateNotNullOrEmpty()]
    [string] $Configuration = "All",
    [string[]] $Configurations = @(),
    [string] $Platform = "x64",
    [string] $ProjectFile,
    [string] $OutputProps,
    [string] $CacheRoot,
    [string] $VcpkgRoot,
    [string] $VisualStudioPath,
    [string] $CMakePath,
    [string] $MSBuildPath,
    [string] $FingerprintInputDirectory,
    [switch] $ValidateOnly,
    [switch] $AuditOnly,
    [string] $ExpectedDependencyFingerprint,
    [string] $ExpectedConsumerFingerprint,
    [string] $ExpectedInstalledRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-FullPath {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,
        [string] $BasePath = (Get-Location).Path
    )

    $fullPath = if ([IO.Path]::IsPathRooted($Path)) {
        [IO.Path]::GetFullPath($Path)
    } else {
        [IO.Path]::GetFullPath((Join-Path $BasePath $Path))
    }
    $pathRoot = [IO.Path]::GetPathRoot($fullPath)
    if ($fullPath -eq $pathRoot) {
        return $fullPath
    }

    return $fullPath.TrimEnd(
        [IO.Path]::DirectorySeparatorChar,
        [IO.Path]::AltDirectorySeparatorChar
    )
}

function Get-EnvironmentValue {
    param([Parameter(Mandatory = $true)][string] $Name)

    foreach ($scope in @("Process", "User", "Machine")) {
        $value = [Environment]::GetEnvironmentVariable($Name, $scope)
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            return $value
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

function Resolve-Executable {
    param(
        [string] $Candidate,
        [Parameter(Mandatory = $true)]
        [string] $Name
    )

    if (-not [string]::IsNullOrWhiteSpace($Candidate)) {
        $candidatePath = Get-FullPath -Path $Candidate
        if (Test-Path -LiteralPath $candidatePath -PathType Leaf) {
            return $candidatePath
        }
        throw "$Name was not found: $candidatePath"
    }

    $command = Get-Command $Name -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $command) {
        return Get-FullPath -Path $command.Source
    }

    return $null
}

function Assert-MSBuildPropertyQuerySupport {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Executable
    )

    $versionOutput = @(& $Executable -nologo -version 2>&1)
    $msbuildExitCode = $LASTEXITCODE
    if ($msbuildExitCode -ne 0) {
        throw "MSBuild version detection failed for $Executable with exit code $msbuildExitCode."
    }

    $versionMatch = [regex]::Match(
        ($versionOutput -join [Environment]::NewLine),
        '(?m)^\s*(\d+\.\d+(?:\.\d+){0,2})\s*$'
    )
    if (-not $versionMatch.Success) {
        throw "MSBuild did not report a recognizable version: $Executable"
    }

    $msbuildVersion = [version] $versionMatch.Groups[1].Value
    if ($msbuildVersion -lt [version] "17.8") {
        throw "MSBuild 17.8 or newer is required for evaluated property queries. Found $msbuildVersion at $Executable."
    }
}

function Assert-SafeMSBuildDimension {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Value,
        [Parameter(Mandatory = $true)]
        [string] $Description
    )

    if (
        [string]::IsNullOrWhiteSpace($Value) -or
        $Value.Length -gt 128 -or
        $Value -notmatch '^[A-Za-z0-9_. -]+$'
    ) {
        throw "Unsupported $Description name: $Value"
    }
}

function Import-VisualStudioEnvironment {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Root,
        [Parameter(Mandatory = $true)]
        [string] $PreservedVcpkgRoot
    )

    $developerCommand = Join-Path $Root "Common7\Tools\VsDevCmd.bat"
    if (-not (Test-Path -LiteralPath $developerCommand -PathType Leaf)) {
        throw "Visual Studio developer environment was not found: $developerCommand"
    }

    $environmentLines = & cmd.exe /d /s /c "`"$developerCommand`" -no_logo -arch=x64 -host_arch=x64 && set"
    if ($LASTEXITCODE -ne 0) {
        throw "Visual Studio developer environment initialization failed with exit code $LASTEXITCODE."
    }

    foreach ($line in $environmentLines) {
        $separator = $line.IndexOf("=")
        if ($separator -le 0) {
            continue
        }
        [Environment]::SetEnvironmentVariable(
            $line.Substring(0, $separator),
            $line.Substring($separator + 1),
            "Process"
        )
    }

    # VsDevCmd may select the Visual Studio bundled vcpkg. The repository contract
    # owns the active vcpkg root, so restore it after importing compiler variables.
    [Environment]::SetEnvironmentVariable("VCPKG_ROOT", $PreservedVcpkgRoot, "Process")
}

function Get-MSBuildProperties {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Executable,
        [Parameter(Mandatory = $true)]
        [string] $Project,
        [Parameter(Mandatory = $true)]
        [string] $BuildConfiguration,
        [Parameter(Mandatory = $true)]
        [string] $BuildPlatform
    )

    $propertyNames = @(
        "VcpkgRoot",
        "VcpkgManifestRoot",
        "VcpkgTriplet",
        "VcpkgHostTriplet",
        "VcpkgConfiguration",
        "VcpkgEnableManifest",
        "PlatformToolset",
        "WindowsTargetPlatformVersion",
        "CanaryVcpkgBuildType",
        "CanaryVcpkgFeatureFlags",
        "CanaryVcpkgManifestFeatures",
        "CanaryVcpkgManifestNoDefaultFeatures",
        "CanaryVcpkgOverlayPorts",
        "CanaryVcpkgOverlayTriplets",
        "CanaryVcpkgInstallOptions"
    ) -join ","

    $arguments = @(
        $Project,
        "-nologo",
        "-nodeReuse:false",
        "-p:Configuration=$BuildConfiguration",
        "-p:Platform=$BuildPlatform",
        "-p:CanarySharedVcpkgDisable=true",
        "-getProperty:$propertyNames"
    )
    $output = & $Executable @arguments 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "MSBuild property evaluation failed for $BuildConfiguration|$BuildPlatform.`n$($output -join [Environment]::NewLine)"
    }

    $json = $output -join [Environment]::NewLine
    $jsonStart = $json.IndexOf("{")
    if ($jsonStart -lt 0) {
        throw "MSBuild did not return its evaluated properties as JSON."
    }

    return ($json.Substring($jsonStart) | ConvertFrom-Json).Properties
}

function Convert-ContractResult {
    param([Parameter(Mandatory = $true)][string] $Path)

    $result = [ordered]@{}
    foreach ($line in Get-Content -LiteralPath $Path) {
        $separator = $line.IndexOf("=")
        if ($separator -le 0) {
            continue
        }
        $result[$line.Substring(0, $separator)] = $line.Substring($separator + 1)
    }

    foreach ($requiredName in @(
        "active",
        "schema",
        "implementation-sha256",
        "dependency-fingerprint",
        "consumer-fingerprint",
        "installed-root",
        "buildtrees-root",
        "packages-root",
        "target-triplet",
        "host-triplet"
    )) {
        if (-not $result.Contains($requiredName) -or [string]::IsNullOrWhiteSpace($result[$requiredName])) {
            throw "The shared-cache resolver omitted '$requiredName'."
        }
    }

    return $result
}

function ConvertTo-MSBuildOptionString {
    param(
        [Parameter(Mandatory = $true)]
        [Collections.IDictionary] $Contract,
        [Parameter(Mandatory = $true)]
        [pscustomobject] $Properties
    )

    $options = [Collections.Generic.List[string]]::new()
    if (-not [string]::IsNullOrWhiteSpace($Properties.CanaryVcpkgFeatureFlags)) {
        $featureFlags = $Properties.CanaryVcpkgFeatureFlags.Replace(";", ",")
        $options.Add("--feature-flags=$featureFlags")
    }
    foreach ($feature in @($Properties.CanaryVcpkgManifestFeatures -split ";" | Where-Object { $_ })) {
        $options.Add("--x-feature=$feature")
    }
    if ($Properties.CanaryVcpkgManifestNoDefaultFeatures -match "^(1|ON|TRUE|YES)$") {
        $options.Add("--x-no-default-features")
    }
    foreach ($overlayPort in @($Properties.CanaryVcpkgOverlayPorts -split ";" | Where-Object { $_ })) {
        $options.Add("`"--overlay-ports=$overlayPort`"")
    }
    foreach ($overlayTriplet in @($Properties.CanaryVcpkgOverlayTriplets -split ";" | Where-Object { $_ })) {
        $options.Add("`"--overlay-triplets=$overlayTriplet`"")
    }
    foreach ($installOption in @($Properties.CanaryVcpkgInstallOptions -split ";" | Where-Object { $_ })) {
        $options.Add($installOption)
    }
    $options.Add("`"--x-buildtrees-root=$($Contract['buildtrees-root'])`"")
    $options.Add("`"--x-packages-root=$($Contract['packages-root'])`"")

    return $options -join " "
}

function Invoke-ContractResolver {
    param(
        [Parameter(Mandatory = $true)]
        [string] $BuildConfiguration,
        [Parameter(Mandatory = $true)]
        [pscustomobject] $Properties,
        [Parameter(Mandatory = $true)]
        [bool] $Prepare
    )

    if ($Properties.VcpkgEnableManifest -notmatch "^(1|ON|TRUE|YES)$") {
        throw "The Solution configuration $BuildConfiguration|$Platform does not enable vcpkg manifest mode."
    }
    foreach ($requiredProperty in @("VcpkgTriplet", "VcpkgHostTriplet", "PlatformToolset")) {
        if ([string]::IsNullOrWhiteSpace($Properties.$requiredProperty)) {
            throw "The Solution configuration $BuildConfiguration|$Platform does not define $requiredProperty."
        }
    }

    $manifestRoot = Get-FullPath -Path $Properties.VcpkgManifestRoot -BasePath $repositoryRoot
    if ($manifestRoot -ne $repositoryRoot) {
        throw "The evaluated vcpkg manifest root does not match this repository: $manifestRoot"
    }

    $resultPath = Join-Path ([IO.Path]::GetTempPath()) ("canary-shared-contract-{0}.txt" -f [guid]::NewGuid())
    $fingerprintInputPath = $null
    try {
        $resolverArguments = [Collections.Generic.List[string]]::new()
        if ($Prepare) {
            $resolverArguments.Add("-DCANARY_SHARED_CACHE_PREPARE_ONLY=ON")
        } else {
            $resolverArguments.Add("-DCANARY_SHARED_CACHE_READ_ONLY=ON")
        }
        foreach ($argument in @(
            "-DCANARY_SHARED_CACHE_RESULT_FILE=$resultPath",
            "-DCANARY_SHARED_CACHE_CONSUMER=msbuild",
            "-DCANARY_SHARED_CACHE_CONSUMER_TOOL=$resolvedMSBuildPath",
            "-DCANARY_SHARED_CACHE_CONSUMER_CONFIGURATION=$BuildConfiguration",
            "-DCANARY_SHARED_CACHE_CONSUMER_PLATFORM=$Platform",
            "-DCANARY_SHARED_CACHE_CONSUMER_LINK_CONFIGURATION=$($Properties.VcpkgConfiguration)",
            "-DCANARY_SHARED_CACHE_CONSUMER_TOOLSET=$($Properties.PlatformToolset)",
            "-DCANARY_SHARED_CACHE_CONSUMER_SDK=$($Properties.WindowsTargetPlatformVersion)",
            "-DCMAKE_TOOLCHAIN_FILE=$resolvedVcpkgRoot/scripts/buildsystems/vcpkg.cmake",
            "-DCMAKE_C_COMPILER=$compilerPath",
            "-DCMAKE_CXX_COMPILER=$compilerPath",
            "-DVCPKG_MANIFEST_DIR=$manifestRoot",
            "-DVCPKG_TARGET_TRIPLET=$($Properties.VcpkgTriplet)",
            "-DVCPKG_HOST_TRIPLET=$($Properties.VcpkgHostTriplet)",
            "-DVCPKG_PLATFORM_TOOLSET=$($Properties.PlatformToolset)",
            "-DVCPKG_FEATURE_FLAGS=$($Properties.CanaryVcpkgFeatureFlags)",
            "-DVCPKG_MANIFEST_FEATURES=$($Properties.CanaryVcpkgManifestFeatures)",
            "-DVCPKG_OVERLAY_PORTS=$($Properties.CanaryVcpkgOverlayPorts)",
            "-DVCPKG_OVERLAY_TRIPLETS=$($Properties.CanaryVcpkgOverlayTriplets)",
            "-DVCPKG_INSTALL_OPTIONS=$($Properties.CanaryVcpkgInstallOptions)"
        )) {
            $resolverArguments.Add($argument)
        }
        if (-not [string]::IsNullOrWhiteSpace($FingerprintInputDirectory)) {
            $resolvedFingerprintInputDirectory = Get-FullPath -Path $FingerprintInputDirectory -BasePath $repositoryRoot
            [IO.Directory]::CreateDirectory($resolvedFingerprintInputDirectory) | Out-Null
            $fingerprintInputPath = Join-Path $resolvedFingerprintInputDirectory ("{0}-{1}.txt" -f $BuildConfiguration.ToLowerInvariant(), $Platform.ToLowerInvariant())
            $resolverArguments.Add("-DCANARY_SHARED_CACHE_FINGERPRINT_INPUT_FILE=$fingerprintInputPath")
        }
        if (-not [string]::IsNullOrWhiteSpace($Properties.CanaryVcpkgBuildType)) {
            $resolverArguments.Add("-DVCPKG_BUILD_TYPE=$($Properties.CanaryVcpkgBuildType)")
        }
        if (-not [string]::IsNullOrWhiteSpace($Properties.CanaryVcpkgManifestNoDefaultFeatures)) {
            $resolverArguments.Add("-DVCPKG_MANIFEST_NO_DEFAULT_FEATURES=$($Properties.CanaryVcpkgManifestNoDefaultFeatures)")
        }
        $resolverArguments.Add("-P")
        $resolverArguments.Add($resolverModule)

        Push-Location $repositoryRoot
        try {
            $resolverOutput = & $resolvedCMakePath @resolverArguments 2>&1
            if ($LASTEXITCODE -ne 0) {
                throw "Shared-cache contract resolution failed for $BuildConfiguration|$Platform.`n$($resolverOutput -join [Environment]::NewLine)"
            }
        } finally {
            Pop-Location
        }

        if (-not (Test-Path -LiteralPath $resultPath -PathType Leaf)) {
            throw "The shared-cache resolver did not produce a result for $BuildConfiguration|$Platform.`n$($resolverOutput -join [Environment]::NewLine)"
        }
        return Convert-ContractResult -Path $resultPath
    } finally {
        if ([IO.File]::Exists($resultPath)) {
            [IO.File]::Delete($resultPath)
        }
    }
}

$repositoryRoot = Get-FullPath -Path (Join-Path $PSScriptRoot "..")
$resolverModule = Join-Path $repositoryRoot "cmake\SharedBuildCache.cmake"
if (-not (Test-Path -LiteralPath $resolverModule -PathType Leaf)) {
    throw "Shared-cache resolver was not found: $resolverModule"
}

if ([string]::IsNullOrWhiteSpace($ProjectFile)) {
    foreach ($relativeProjectPath in @(
        "vcproj\canary.vcxproj",
        "vc18\otclient.vcxproj",
        "vc17\otclient.vcxproj"
    )) {
        $projectCandidate = Join-Path $repositoryRoot $relativeProjectPath
        if (Test-Path -LiteralPath $projectCandidate -PathType Leaf) {
            $ProjectFile = $projectCandidate
            break
        }
    }
}
if ([string]::IsNullOrWhiteSpace($ProjectFile)) {
    throw "No maintained Visual Studio project was found. Pass -ProjectFile explicitly."
}
$ProjectFile = Get-FullPath -Path $ProjectFile -BasePath $repositoryRoot
if (-not (Test-Path -LiteralPath $ProjectFile -PathType Leaf)) {
    throw "Visual Studio project was not found: $ProjectFile"
}

if ([string]::IsNullOrWhiteSpace($OutputProps)) {
    $OutputProps = Join-Path (Split-Path -Parent $ProjectFile) ".canary-shared-cache\SharedVcpkgCache.props"
}
$OutputProps = Get-FullPath -Path $OutputProps -BasePath $repositoryRoot

if ([string]::IsNullOrWhiteSpace($CacheRoot)) {
    $CacheRoot = Get-EnvironmentValue -Name "CANARY_SHARED_CACHE_ROOT"
}
if ([string]::IsNullOrWhiteSpace($CacheRoot)) {
    throw "CANARY_SHARED_CACHE_ROOT is not configured. Run tools/configure_shared_build_cache.ps1 first."
}
$CacheRoot = Get-FullPath -Path $CacheRoot
Assert-LocalFixedVolume -Path $CacheRoot -Description "The shared cache"
[Environment]::SetEnvironmentVariable("CANARY_SHARED_CACHE_ROOT", $CacheRoot, "Process")
[Environment]::SetEnvironmentVariable("CANARY_SHARED_CACHE_LOCAL_FILESYSTEM_VERIFIED", "ON", "Process")
[Environment]::SetEnvironmentVariable("CANARY_SHARED_CACHE_VERIFIED_ROOT", $CacheRoot, "Process")

if ([string]::IsNullOrWhiteSpace($VcpkgRoot)) {
    $VcpkgRoot = Get-EnvironmentValue -Name "VCPKG_ROOT"
}
if ([string]::IsNullOrWhiteSpace($VcpkgRoot)) {
    throw "VCPKG_ROOT is not configured."
}
$resolvedVcpkgRoot = Get-FullPath -Path $VcpkgRoot
if (-not (Test-Path -LiteralPath (Join-Path $resolvedVcpkgRoot "vcpkg.exe") -PathType Leaf)) {
    throw "The active vcpkg executable was not found below: $resolvedVcpkgRoot"
}
[Environment]::SetEnvironmentVariable("VCPKG_ROOT", $resolvedVcpkgRoot, "Process")

if ([string]::IsNullOrWhiteSpace($VisualStudioPath)) {
    $VisualStudioPath = Get-EnvironmentValue -Name "CANARY_VCPKG_VISUAL_STUDIO_PATH"
}
if ([string]::IsNullOrWhiteSpace($VisualStudioPath)) {
    throw "CANARY_VCPKG_VISUAL_STUDIO_PATH is not configured. Run tools/configure_shared_build_cache.ps1 first."
}
$VisualStudioPath = Get-FullPath -Path $VisualStudioPath
[Environment]::SetEnvironmentVariable("CANARY_VCPKG_VISUAL_STUDIO_PATH", $VisualStudioPath, "Process")
Import-VisualStudioEnvironment -Root $VisualStudioPath -PreservedVcpkgRoot $resolvedVcpkgRoot

$resolvedCMakePath = Resolve-Executable -Candidate $CMakePath -Name "cmake.exe"
if ([string]::IsNullOrWhiteSpace($resolvedCMakePath)) {
    $bundledCMake = Join-Path $VisualStudioPath "Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
    if (Test-Path -LiteralPath $bundledCMake -PathType Leaf) {
        $resolvedCMakePath = Get-FullPath -Path $bundledCMake
    }
}
if ([string]::IsNullOrWhiteSpace($resolvedCMakePath)) {
    throw "cmake.exe was not found on PATH or in the selected Visual Studio installation. Pass -CMakePath explicitly."
}
if ([string]::IsNullOrWhiteSpace($MSBuildPath)) {
    $MSBuildPath = Get-EnvironmentValue -Name "CANARY_SOLUTION_MSBUILD_PATH"
}
$resolvedMSBuildPath = Resolve-Executable -Candidate $MSBuildPath -Name "MSBuild.exe"
if ([string]::IsNullOrWhiteSpace($resolvedMSBuildPath)) {
    $bundledMSBuild = Join-Path $VisualStudioPath "MSBuild\Current\Bin\amd64\MSBuild.exe"
    if (Test-Path -LiteralPath $bundledMSBuild -PathType Leaf) {
        $resolvedMSBuildPath = Get-FullPath -Path $bundledMSBuild
    }
}
if ([string]::IsNullOrWhiteSpace($resolvedMSBuildPath)) {
    throw "MSBuild.exe was not found on PATH or in the selected Visual Studio installation. Pass -MSBuildPath explicitly."
}
Assert-MSBuildPropertyQuerySupport -Executable $resolvedMSBuildPath
$compilerCommand = Get-Command cl.exe -ErrorAction SilentlyContinue | Select-Object -First 1
if ($null -eq $compilerCommand) {
    throw "cl.exe was not found after initializing the selected Visual Studio developer environment."
}
$compilerPath = $compilerCommand.Source

$Platform = ([string] $Platform).Trim()
Assert-SafeMSBuildDimension -Value $Platform -Description "Solution platform"

[string[]] $configurations = if ($Configurations.Count -gt 0) {
    @($Configurations)
} elseif ($Configuration -eq "All") {
    try {
        [xml] $projectConfigurationDocument = Get-Content -LiteralPath $ProjectFile -Raw
    } catch {
        throw "The Visual Studio project is malformed and its configurations cannot be discovered: $ProjectFile. $($_.Exception.Message)"
    }
    @(
        $projectConfigurationDocument.SelectNodes("//*[local-name()='ProjectConfiguration']") |
            ForEach-Object { [string] $_.Include } |
            Where-Object { $_.EndsWith("|$Platform", [StringComparison]::OrdinalIgnoreCase) } |
            ForEach-Object { ($_ -split '\|', 2)[0] } |
            Select-Object -Unique
    )
} else {
    @($Configuration)
}
$configurations = @(
    $configurations |
        ForEach-Object { $_ -split '[,;]' } |
        ForEach-Object { $_.Trim() } |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        Select-Object -Unique
)
if ($configurations.Count -eq 0) {
    throw "The Visual Studio project declares no configurations for platform $Platform."
}
foreach ($configurationName in $configurations) {
    Assert-SafeMSBuildDimension -Value $configurationName -Description "Solution configuration"
}

if ($AuditOnly) {
    if (-not (Test-Path -LiteralPath $OutputProps -PathType Leaf)) {
        Write-Output "Solution cache fallback is local; no generated shared-cache props exist."
        return
    }
    try {
        [xml] $existingProps = Get-Content -LiteralPath $OutputProps -Raw
    } catch {
        throw "Generated Solution cache props are malformed: $OutputProps. Regenerate the file and reload the project. $($_.Exception.Message)"
    }
    $activePropertyGroups = @(
        $existingProps.Project.PropertyGroup |
            Where-Object { $_.CanarySharedVcpkgActive -eq "true" }
    )
    foreach ($expectedConfiguration in $configurations) {
        $matchingGroups = @(
            $activePropertyGroups |
                Where-Object { $_.CanarySharedVcpkgConfiguration -eq $expectedConfiguration }
        )
        if ($matchingGroups.Count -ne 1) {
            throw "Generated Solution cache props must contain exactly one current contract for $expectedConfiguration|$Platform. Regenerate the file and reload the project."
        }
    }
    foreach ($propertyGroup in $activePropertyGroups) {
        if ($propertyGroup.CanarySharedVcpkgActive -ne "true") {
            continue
        }
        $configurationName = [string] $propertyGroup.CanarySharedVcpkgConfiguration
        $properties = Get-MSBuildProperties -Executable $resolvedMSBuildPath -Project $ProjectFile -BuildConfiguration $configurationName -BuildPlatform $Platform
        $contract = Invoke-ContractResolver -BuildConfiguration $configurationName -Properties $properties -Prepare $false
        if (
            $contract["dependency-fingerprint"] -ne [string] $propertyGroup.CanarySharedVcpkgDependencyFingerprint -or
            $contract["consumer-fingerprint"] -ne [string] $propertyGroup.CanarySharedVcpkgConsumerFingerprint -or
            (Get-FullPath -Path $contract["installed-root"]) -ne (Get-FullPath -Path ([string] $propertyGroup.VcpkgInstalledDir))
        ) {
            throw "Generated Solution cache props are stale for $configurationName|$Platform. Run this script without -AuditOnly and reload the project."
        }
    }
    Write-Output "Solution cache audit complete: all generated contracts are current."
    return
}

if ($ValidateOnly) {
    foreach ($requiredExpected in @(
        @{ Name = "ExpectedDependencyFingerprint"; Value = $ExpectedDependencyFingerprint },
        @{ Name = "ExpectedConsumerFingerprint"; Value = $ExpectedConsumerFingerprint },
        @{ Name = "ExpectedInstalledRoot"; Value = $ExpectedInstalledRoot }
    )) {
        if ([string]::IsNullOrWhiteSpace($requiredExpected.Value)) {
            throw "$($requiredExpected.Name) is required with -ValidateOnly."
        }
    }
    if (@($configurations).Count -ne 1) {
        throw "-ValidateOnly requires one concrete Configuration."
    }
    $properties = Get-MSBuildProperties -Executable $resolvedMSBuildPath -Project $ProjectFile -BuildConfiguration $configurations[0] -BuildPlatform $Platform
    $contract = Invoke-ContractResolver -BuildConfiguration $configurations[0] -Properties $properties -Prepare $true
    $actualValues = [ordered]@{
        ManifestRoot  = [Environment]::GetEnvironmentVariable("CANARY_SHARED_VCPKG_ACTUAL_MANIFEST_ROOT", "Process")
        TargetTriplet = [Environment]::GetEnvironmentVariable("CANARY_SHARED_VCPKG_ACTUAL_TARGET_TRIPLET", "Process")
        HostTriplet   = [Environment]::GetEnvironmentVariable("CANARY_SHARED_VCPKG_ACTUAL_HOST_TRIPLET", "Process")
        Configuration = [Environment]::GetEnvironmentVariable("CANARY_SHARED_VCPKG_ACTUAL_CONFIGURATION", "Process")
        Toolset       = [Environment]::GetEnvironmentVariable("CANARY_SHARED_VCPKG_ACTUAL_TOOLSET", "Process")
        SDK           = [Environment]::GetEnvironmentVariable("CANARY_SHARED_VCPKG_ACTUAL_SDK", "Process")
        InstallOptions = [Environment]::GetEnvironmentVariable("CANARY_SHARED_VCPKG_ACTUAL_INSTALL_OPTIONS", "Process")
    }
    foreach ($actualValue in $actualValues.GetEnumerator()) {
        if ([string]::IsNullOrWhiteSpace($actualValue.Value)) {
            throw "The evaluated MSBuild value '$($actualValue.Key)' was not supplied to the canonical validator."
        }
    }
    if ((Get-FullPath -Path $actualValues.ManifestRoot) -ne (Get-FullPath -Path $properties.VcpkgManifestRoot -BasePath $repositoryRoot)) {
        throw "The evaluated vcpkg manifest root differs from the canonical Solution contract."
    }
    $canonicalValues = [ordered]@{
        TargetTriplet = [string] $contract["target-triplet"]
        HostTriplet   = [string] $contract["host-triplet"]
        Configuration = [string] $properties.VcpkgConfiguration
        Toolset       = [string] $properties.PlatformToolset
        SDK           = [string] $properties.WindowsTargetPlatformVersion
        InstallOptions = ConvertTo-MSBuildOptionString -Contract $contract -Properties $properties
    }
    foreach ($canonicalValue in $canonicalValues.GetEnumerator()) {
        if ([string] $actualValues[$canonicalValue.Key] -cne [string] $canonicalValue.Value) {
            throw "The evaluated MSBuild value '$($canonicalValue.Key)' differs from the canonical Solution contract."
        }
    }
    if ($contract["dependency-fingerprint"] -ne $ExpectedDependencyFingerprint) {
        throw "The Solution dependency fingerprint changed. Regenerate SharedVcpkgCache.props and reload the project."
    }
    if ($contract["consumer-fingerprint"] -ne $ExpectedConsumerFingerprint) {
        throw "The Solution consumer fingerprint changed. Regenerate SharedVcpkgCache.props and reload the project."
    }
    if ((Get-FullPath -Path $contract["installed-root"]) -ne (Get-FullPath -Path $ExpectedInstalledRoot)) {
        throw "The Solution installed root does not match its validated fingerprint."
    }
    Write-Output "Validated shared Solution dependency contract $($contract['dependency-fingerprint'])."
    return
}

$resolvedContracts = [Collections.Generic.List[object]]::new()
foreach ($buildConfiguration in $configurations) {
    $properties = Get-MSBuildProperties -Executable $resolvedMSBuildPath -Project $ProjectFile -BuildConfiguration $buildConfiguration -BuildPlatform $Platform
    $contract = Invoke-ContractResolver -BuildConfiguration $buildConfiguration -Properties $properties -Prepare (-not $WhatIfPreference)
    $resolvedContracts.Add([pscustomobject]@{
        Configuration = $buildConfiguration
        Properties    = $properties
        Contract      = $contract
        Options       = ConvertTo-MSBuildOptionString -Contract $contract -Properties $properties
    })
}

$propertyGroups = foreach ($entry in $resolvedContracts) {
    $condition = "'`$(Configuration)|`$(Platform)' == '$($entry.Configuration)|$Platform'"
    $escapedCondition = [Security.SecurityElement]::Escape($condition)
    $values = [ordered]@{
        CanarySharedVcpkgActive                = "true"
        CanarySharedCacheRoot                  = $CacheRoot
        CanarySharedVcpkgSchema                = $entry.Contract["schema"]
        CanarySharedVcpkgConfiguration         = $entry.Configuration
        CanarySharedVcpkgDependencyFingerprint = $entry.Contract["dependency-fingerprint"]
        CanarySharedVcpkgConsumerFingerprint   = $entry.Contract["consumer-fingerprint"]
        CanarySharedVcpkgExpectedManifestRoot  = $repositoryRoot
        CanarySharedVcpkgExpectedTargetTriplet = $entry.Contract["target-triplet"]
        CanarySharedVcpkgExpectedHostTriplet   = $entry.Contract["host-triplet"]
        CanarySharedVcpkgExpectedConfiguration = $entry.Properties.VcpkgConfiguration
        CanarySharedVcpkgExpectedToolset       = $entry.Properties.PlatformToolset
        CanarySharedVcpkgExpectedSDK           = $entry.Properties.WindowsTargetPlatformVersion
        CanarySharedVcpkgExpectedInstallOptions = $entry.Options
        CanarySharedVcpkgBuildtreesRoot         = $entry.Contract["buildtrees-root"]
        CanarySharedVcpkgPackagesRoot           = $entry.Contract["packages-root"]
        CanaryVcpkgVisualStudioPath             = $VisualStudioPath
        CanaryVcpkgDependencyCMakeDirectory     = [IO.Path]::GetDirectoryName($resolvedCMakePath)
        VcpkgRoot                               = $resolvedVcpkgRoot
        VcpkgInstalledDir                       = $entry.Contract["installed-root"]
        VcpkgAdditionalInstallOptions           = $entry.Options
    }
    $lines = foreach ($value in $values.GetEnumerator()) {
        $escapedValue = [Security.SecurityElement]::Escape([string] $value.Value)
        "    <$($value.Key)>$escapedValue</$($value.Key)>"
    }
    "  <PropertyGroup Label=`"CanarySharedVcpkgCache`" Condition=`"$escapedCondition`">`n$($lines -join "`n")`n  </PropertyGroup>"
}
$propsContent = @"
<?xml version="1.0" encoding="utf-8"?>
<!-- Generated by tools/configure_shared_solution_cache.ps1. Do not edit. -->
<Project>
$($propertyGroups -join "`n")
</Project>
"@

if ($PSCmdlet.ShouldProcess($OutputProps, "write generated shared Solution cache props")) {
    $propsDirectory = Split-Path -Parent $OutputProps
    [void] (New-Item -ItemType Directory -Path $propsDirectory -Force)
    $temporaryProps = Join-Path $propsDirectory ("SharedVcpkgCache.{0}.tmp" -f [guid]::NewGuid())
    try {
        [IO.File]::WriteAllText($temporaryProps, $propsContent, [Text.UTF8Encoding]::new($false))
        [IO.File]::Move($temporaryProps, $OutputProps, $true)
    } finally {
        if ([IO.File]::Exists($temporaryProps)) {
            [IO.File]::Delete($temporaryProps)
        }
    }
}

$resolvedContracts | ForEach-Object {
    [pscustomobject]@{
        Configuration = "$($_.Configuration)|$Platform"
        Dependency    = $_.Contract["dependency-fingerprint"]
        Consumer      = $_.Contract["consumer-fingerprint"]
        Installed     = $_.Contract["installed-root"]
    }
} | Format-Table -AutoSize -Wrap | Out-String | Write-Output

if ($WhatIfPreference) {
    Write-Output "Preview only: no pool directories or generated props were changed."
} else {
    Write-Output "Shared Solution cache props generated. Reload the Visual Studio project before building."
}
