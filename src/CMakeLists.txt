cmake_minimum_required(VERSION 3.22 FATAL_ERROR)

# Base configurations and settings for the project
include(BaseConfig)
include(GNUInstallDirs)

# Import configurations, source definitions, and linker settings
include(CanaryLib)

# Define main executable target, set it up and link to main library
add_executable(${PROJECT_NAME} main.cpp)

if(MSVC)
    # Add executable icon for Windows
    target_sources(${PROJECT_NAME} PRIVATE ../cmake/canary.rc)
endif()

setup_target(${PROJECT_NAME})
set_output_directory(${PROJECT_NAME})
target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_lib)

# Configurar IPO e Linkagem Incremental para o executável
configure_linking(${PROJECT_NAME})

# Compiler warnings and options
if (UNIX)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        target_compile_options(${PROJECT_NAME}_lib PRIVATE -Wall -Wextra -Wpedantic)
        target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)
    endif()
endif()
