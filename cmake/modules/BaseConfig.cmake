# *****************************************************************************
# CMake Features
# *****************************************************************************
set(CMAKE_CXX_STANDARD 20)
set(GNUCXX_MINIMUM_VERSION 11)
set(MSVC_MINIMUM_VERSION "19.32")
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
set(Boost_NO_WARN_NEW_VERSIONS ON)

# Make will print more details
set(CMAKE_VERBOSE_MAKEFILE OFF)

# Generate compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# *****************************************************************************
# Packages / Libs
# *****************************************************************************
find_package(CURL CONFIG REQUIRED)
find_package(GMP REQUIRED)
find_package(LuaJIT REQUIRED)
find_package(MySQL REQUIRED)
find_package(Protobuf REQUIRED)
find_package(Threads REQUIRED)
find_package(ZLIB REQUIRED)
find_package(absl CONFIG REQUIRED)
find_package(asio CONFIG REQUIRED)
find_package(eventpp CONFIG REQUIRED)
find_package(jsoncpp CONFIG REQUIRED)
find_package(magic_enum CONFIG REQUIRED)
find_package(mio REQUIRED)
find_package(pugixml CONFIG REQUIRED)
find_package(spdlog REQUIRED)
find_package(unofficial-argon2 CONFIG REQUIRED)
find_package(unofficial-libmariadb CONFIG REQUIRED)

find_path(BOOST_DI_INCLUDE_DIRS "boost/di.hpp")

# *****************************************************************************
# Sanity Checks
# *****************************************************************************
# === GCC Minimum Version ===
if (CMAKE_COMPILER_IS_GNUCXX)
    message("-- Compiler: GCC - Version: ${CMAKE_CXX_COMPILER_VERSION}")
    if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS GNUCXX_MINIMUM_VERSION)
        message(FATAL_ERROR "GCC version must be at least ${GNUCXX_MINIMUM_VERSION}!")
    endif()
endif()

# === Minimum required version for visual studio ===
if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    message("-- Compiler: Visual Studio - Version: ${CMAKE_CXX_COMPILER_VERSION}")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS MSVC_MINIMUM_VERSION)
        message(FATAL_ERROR "Visual Studio version must be at least ${MSVC_MINIMUM_VERSION}")
    endif()
endif()