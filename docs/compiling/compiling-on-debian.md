# Canary

## Supported OS

- Debian

## 1. Install the required software

The following command will install Git, CMake, a compiler and the libraries used by Canary. 

Git will be used to download the source code, and CMake will be used to generate the build files.

```bash
sudo apt update
sudo apt install git cmake build-essential autoconf libtool ca-certificates curl zip unzip tar pkg-config ninja-build ccache linux-headers-$(uname -r) -y
```

## 2. Set up vcpkg

```bash
git clone https://github.com/microsoft/vcpkg
cd vcpkg
./bootstrap-vcpkg.sh
cd ..
```

### Configure environment for vcpkg (important)

To ensure **CMake presets and CLion detect vcpkg automatically without modifying the preset**, export `VCPKG_ROOT` globally for the user:

```bash
echo "VCPKG_ROOT=/home/$USER/vcpkg" | sudo tee -a /etc/environment && source /etc/environment
```
Now **log out and log in again** (or reboot), then verify:

```bash
echo $VCPKG_ROOT
# Expected output:
# /home/<user>/vcpkg
```
Also validate the toolchain file exists:

```bash
test -f "$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" && echo "vcpkg OK" || echo "vcpkg not found"
```

## 3. Download the source code

```bash
git clone --depth 1 https://github.com/opentibiabr/canary.git
cd canary
```

## 4. Folder structure

```bash
.
├── canary
└── vcpkg
```

## 5. Configure and build

```bash
cmake --preset linux-release -DTOGGLE_BIN_FOLDER=ON
cmake --build --preset linux-release -j4
```

> -- Running vcpkg install 

**This step will take a long time on the first run, as it needs to download and install all the dependencies, so be patient!**

---
