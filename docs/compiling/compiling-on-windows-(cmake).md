# Canary

## Supported OS

- Windows 11

## 1. Install the required software

To compile on Windows, you will need to download and install:
- [Git](https://git-scm.com/download/win)
- [Visual Studio 2026 Community](https://visualstudio.microsoft.com/vs/) (compiler and english language pack)

You must install **Visual Studio 2026** with the "Desktop development with C++" workload selecting the following components:

- MSVC Build Tools for x64/x86 (Latest)
- C++ ATL for x64/x86 (Latest MSVC) 
- C++ Build Insights
- C++ profiling tools
- C++ CMake tools for Windows
- Windows 11 SDK

**Important:** Do not select to install the option "vcpkg package manager" on Visual Studio.

You must also install the **English** language pack.

## 2. Set up vcpkg

To open _Powershell_, navigate to your desired directory e.g. `C:\` and choose `Open PowerShell window here` (shift + right click).

Then you can safely proceed with configuring vcpkg:

```powershell
git clone https://github.com/microsoft/vcpkg
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg integrate install
```

Execute the following command in _Powershell_ with Administrator permission to set vcpkg environment variable:

**Note:** If you cloned vcpkg to a different directory, replace 'C:\vcpkg' in the command below with the correct path.

```powershell
[System.Environment]::SetEnvironmentVariable('VCPKG_ROOT','C:\vcpkg', [System.EnvironmentVariableTarget]::Machine)
```

## 3. Download the source code
```powershell
cd C:\
git clone --depth 1 https://github.com/opentibiabr/canary.git
```

## 4. Build

- Open Visual Studio. In "**Get started**", select "**Open a local folder**" and open the server main folder.

- Wait for the Visual Studio to load. It will automatically install the libraries and generate the cmake cache. (Be patient, the first cache may take a few minutes).

- After the cmake cache is successfully generated, you can compile the server by going to the menu **Build** and choose **Build All**.

---
