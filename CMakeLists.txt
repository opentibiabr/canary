cmake_minimum_required(VERSION 3.22 FATAL_ERROR)

# CMAKE
# apt install build-essential git
# git clone https://github.com/Kitware/CMake/; cd CMake
# ./bootstrap && make && sudo make install

# VCPKG
# cmake -DCMAKE_TOOLCHAIN_FILE=/opt/workspace/vcpkg/scripts/buildsystems/vcpkg.cmake ..
# Needed libs is in file vcpkg.json
# Windows required libs: .\vcpkg install --triplet x64-windows asio pugixml spdlog curl protobuf parallel-hashmap magic-enum mio luajit libmariadb mpir abseil bshoshany-thread-pool
if(DEFINED ENV{VCPKG_ROOT} AND NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
      CACHE STRING "")
endif()

if(DEFINED ENV{VCPKG_DEFAULT_TRIPLET} AND NOT DEFINED VCPKG_TARGET_TRIPLET)
  set(VCPKG_TARGET_TRIPLET "$ENV{VCPKG_DEFAULT_TRIPLET}" CACHE STRING "")
endif()

set(VCPKG_FEATURE_FLAGS "versions")
set(VCPKG_BUILD_TYPE "release")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


# *****************************************************************************
# Project canary
# *****************************************************************************
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    project(canary-debug)
else()
    project(canary)
endif()


# *****************************************************************************
# Append cmake search path
# *****************************************************************************
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules)

# *****************************************************************************
# Include cmake tools
# *****************************************************************************
include(MessageColors)
include(LoggingHelper)

# *****************************************************************************
# Options
# *****************************************************************************
option(OPTIONS_ENABLE_CCACHE "Enable ccache" OFF)
option(OPTIONS_ENABLE_SCCACHE "Use sccache to speed up compilation process" OFF)
option(OPTIONS_ENABLE_IPO "Check and Enable interprocedural optimization (IPO/LTO)" ON)
option(FEATURE_METRICS "Enable metrics feature" OFF)

# *****************************************************************************
# Options Code
# *****************************************************************************

if(FEATURE_METRIC)
    log_option_enabled("metrics")
else ()
    log_option_disabled("metrics")
endif ()

# === CCACHE ===
if(OPTIONS_ENABLE_CCACHE)
    find_program(CCACHE ccache)
    if(CCACHE)
        log_option_enabled("ccache")
        set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE})
        else()
        log_option_disabled("ccache")
    endif()
endif()


# === SCCACHE ===
if(OPTIONS_ENABLE_SCCACHE)
  find_program(SCCACHE_PATH sccache)
  if(SCCACHE_PATH)
    log_option_enabled("sccache")
    set(CMAKE_C_COMPILER_LAUNCHER ${SCCACHE_PATH})
    set(CMAKE_CXX_COMPILER_LAUNCHER ${SCCACHE_PATH})
  else()
    log_option_disabled("sccache")
  endif()
endif()


# === IPO ===
if(OPTIONS_ENABLE_IPO)
    if(MSVC)
        log_option_enabled("IPO/LTO")
        set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /GL")
        set(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO} /LTCG")
        set(CMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO} /LTCG")
        set(CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO} /LTCG")
        set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} /LTCG")
    else()
        if(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo" OR CMAKE_BUILD_TYPE STREQUAL "Release")
            log_option_enabled("IPO/LTO")
            include(CheckIPOSupported)
            check_ipo_supported(RESULT result OUTPUT output)
            if(result)
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -flto=auto")
                message(STATUS "IPO/LTO enabled with -flto=auto for non-MSVC compiler.")
                set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
            else()
                log_war("IPO/LTO not supported: ${output}")
            endif()
        else()
            log_option_disabled("IPO/LTO")
        endif ()
    endif()
else()
    log_option_disabled("IPO/LTO")
endif()

option(BUILD_TESTS "Build tests" OFF) # By default, tests will not be built
option(RUN_TESTS_AFTER_BUILD "Run tests when building" OFF) # By default, tests will only run if requested

# *****************************************************************************
# Add project
# *****************************************************************************
add_subdirectory(src)

if(BUILD_TESTS)
    add_subdirectory(tests)
endif()
