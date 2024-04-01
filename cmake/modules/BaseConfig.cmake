cmake_minimum_required(VERSION 3.22 FATAL_ERROR)

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
find_package(magic_enum CONFIG REQUIRED)
if(FEATURE_METRICS)
    find_package(opentelemetry-cpp CONFIG REQUIRED)
    find_package(prometheus-cpp CONFIG REQUIRED)
endif()
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

# *****************************************************************************
# Sanity Checks
# *****************************************************************************
option(TOGGLE_BIN_FOLDER "Use build/bin folder for generate compilation files" ON)
option(OPTIONS_ENABLE_OPENMP "Enable Open Multi-Processing support." ON)
option(DEBUG_LOG "Enable Debug Log" OFF)
option(ASAN_ENABLED "Build this target with AddressSanitizer" OFF)
option(BUILD_STATIC_LIBRARY "Build using static libraries" OFF)
option(SPEED_UP_BUILD_UNITY "Compile using build unity for speed up build" ON)
option(USE_PRECOMPILED_HEADER "Compile using precompiled header" ON)

# === ASAN ===
if(ASAN_ENABLED)
    log_option_enabled("asan")
    if(MSVC)
        add_compile_options(/fsanitize=address)
    else()
        add_compile_options(-fsanitize=address)
        link_libraries(-fsanitize=address)
    endif()
else()
    log_option_disabled("asan")
endif()

# Build static libs
if(BUILD_STATIC_LIBRARY)
    log_option_enabled("STATIC_LIBRARY")

    if(MSVC)
        set(CMAKE_FIND_LIBRARY_SUFFIXES ".lib")
    elseif(UNIX AND NOT APPLE)
        set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
    elseif(APPLE)
        set(CMAKE_FIND_LIBRARY_SUFFIXES ".a" ".dylib")
    endif()
else()
    log_option_disabled("STATIC_LIBRARY")
endif()

# === DEBUG LOG ===
# cmake -DDEBUG_LOG=ON ..
if(DEBUG_LOG)
    add_definitions(-DDEBUG_LOG=ON)
    log_option_enabled("DEBUG LOG")
else()
    log_option_disabled("DEBUG LOG")
endif(DEBUG_LOG)

# *****************************************************************************
# Compiler Options
# *****************************************************************************
if (MSVC)
    foreach(type RELEASE DEBUG RELWITHDEBINFO MINSIZEREL)
        string(REPLACE "/Zi" "/Z7" CMAKE_CXX_FLAGS_${type} "${CMAKE_CXX_FLAGS_${type}}")
        string(REPLACE "/Zi" "/Z7" CMAKE_C_FLAGS_${type} "${CMAKE_C_FLAGS_${type}}")
    endforeach(type)

    add_compile_options(/MP /FS /Zf /EHsc)
endif (MSVC)

## Link compilation files to build/bin folder, else link to the main dir
function(set_output_directory target_name)
    if (TOGGLE_BIN_FOLDER)
        set_target_properties(${target_name}
                PROPERTIES
                RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
                )
    else()
        set_target_properties(${target_name}
                PROPERTIES
                RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/"
                )
    endif()
endfunction()

## Setup shared target basic configurations
function(setup_target TARGET_NAME)
    if (MSVC AND BUILD_STATIC_LIBRARY)
        set_property(TARGET ${TARGET_NAME} PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    endif()
endfunction()

# *****************************************************************************
# DEBUG: Print cmake variables
# *****************************************************************************
#get_cmake_property(_variableNames VARIABLES)
#list (SORT _variableNames)
#foreach (_variableName ${_variableNames})
#	message(STATUS "${_variableName}=${${_variableName}}")
#endforeach()
