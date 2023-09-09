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

# Se não encontrar, crie o alvo para construí-la
if (NOT BEATS_LIB)
    message("Unable to find the beats library. Setting up for build.")

    add_custom_command(
            OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/beats-rust/target/release/beats.lib
            COMMAND cargo build --release --target-dir=${CMAKE_CURRENT_BINARY_DIR}/beats-rust/target
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/beats-rust
            COMMENT "Compiling Rust library"
    )

    add_custom_target(
            BeatsTarget ALL
            DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/beats-rust/target/release/beats.lib
    )

    add_dependencies(${PROJECT_NAME} BeatsTarget)

    set(BEATS_LIB ${CMAKE_CURRENT_BINARY_DIR}/beats-rust/target/release/beats.lib)
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
