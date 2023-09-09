# Base configurations and settings for the project
include(BaseConfig)
include(GNUInstallDirs)

# Import configurations, source definitions, and linker settings
include(CanaryLib)

# Define main executable target, set it up and link to main library
add_executable(${PROJECT_NAME} main.cpp)

# Tente encontrar a biblioteca
find_library(BEATS_LIB beats
        PATHS
        "${CMAKE_CURRENT_BINARY_DIR}/beats-rust/target/release"
        "${CMAKE_CURRENT_BINARY_DIR}/beats-rust"
        NO_DEFAULT_PATH
)

# Determine the correct library extension based on the operating system
if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(BEATS_LIB_EXT "beats.lib")
else ()
    set(BEATS_LIB_EXT "libbeats.a")
endif ()

# Full path to the library
set(BEATS_LIB_FULL_PATH ${CMAKE_CURRENT_BINARY_DIR}/beats-rust/target/release/${BEATS_LIB_EXT})

# Try to find the library
find_library(BEATS_LIB ${BEATS_LIB_EXT}
        PATHS
        "${CMAKE_CURRENT_BINARY_DIR}/beats-rust/target/release"
        "${CMAKE_CURRENT_BINARY_DIR}/beats-rust"
        NO_DEFAULT_PATH
)

# If the library is not found, set up for build
if (NOT BEATS_LIB)
    message("-- Unable to find the beats library. Setting up for build.")

    add_custom_command(
            OUTPUT ${BEATS_LIB_FULL_PATH}
            COMMAND cargo build --release --target-dir=${CMAKE_CURRENT_BINARY_DIR}/beats-rust/target
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/beats-rust
            COMMENT "Compiling Rust library"
    )

    add_custom_target(
            BeatsTarget ALL
            DEPENDS ${BEATS_LIB_FULL_PATH}
    )

    add_dependencies(${PROJECT_NAME} BeatsTarget)

    set(BEATS_LIB ${BEATS_LIB_FULL_PATH})
else ()
    message("lib beats found at ${BEATS_LIB}.")
endif ()

if (MSVC)
    # Add executable icon for Windows
    target_sources(${PROJECT_NAME} PRIVATE ../cmake/canary.rc)
endif ()

setup_target(${PROJECT_NAME})
set_output_directory(${PROJECT_NAME})
target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_lib)
target_link_libraries(${PROJECT_NAME} PRIVATE ${BEATS_LIB})
