# Check if Rust's package manager, Cargo, is installed
find_program(CARGO cargo)
if (NOT CARGO)
    message(FATAL_ERROR "Cargo (Rust package manager) not found. Please install Rust and Cargo to continue.")
endif ()

# Determine the correct library extension based on the operating system
if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(RUST_LIB_EXT "beats.lib")
else ()
    set(RUST_LIB_EXT "libbeats.a")
endif ()

# Determine the build mode (Release, Debug, or RelWithDebInfo) for Rust compilation
if (CMAKE_BUILD_TYPE MATCHES Debug)
    set(RUST_BUILD_FLAG "")
elseif (CMAKE_BUILD_TYPE MATCHES RelWithDebInfo)
    set(RUST_BUILD_FLAG "--profile=relwithdebinfo")
elseif (CMAKE_BUILD_TYPE MATCHES Release)
    set(RUST_BUILD_FLAG " --release ")
endif ()

# Set base paths for the Rust target directory and full library path
set(RUST_LIB_FULL_PATH ${CMAKE_CURRENT_BINARY_DIR}/rust/${CMAKE_BUILD_TYPE}/${RUST_LIB_EXT})

# Define Rust source files that the compilation depends on
file(GLOB RUST_SOURCE_FILES "${CMAKE_SOURCE_DIR}/rust/src/*.rs")

# Always compile the Rust library when any .rs file is modified
add_custom_command(
        OUTPUT ${RUST_LIB_FULL_PATH}
        COMMAND cargo build ${RUST_BUILD_FLAG} --target-dir=${CMAKE_CURRENT_BINARY_DIR}/rust
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/rust
        DEPENDS ${RUST_SOURCE_FILES}
        COMMENT " Compiling the Rust library "
)

# Add a custom target that depends on the Rust library
add_custom_target(
        RustLibTarget ALL
        DEPENDS ${RUST_LIB_FULL_PATH}
)

# Make the main project depend on the custom Rust target
add_dependencies(${PROJECT_NAME} RustLibTarget)
