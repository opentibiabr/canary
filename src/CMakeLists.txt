# Base configurations and settings for the project
include(BaseConfig)

# Define project targets
add_library(${PROJECT_NAME}_lib "")
add_executable(${PROJECT_NAME} otserv.cpp)

# Define compiler options
include(Options)

# Add public pre compiler header to lib, to pass down to related targets
target_precompile_headers(${PROJECT_NAME}_lib PUBLIC pch.hpp)

# Standardize settings and properties across targets
setup_target(${PROJECT_NAME})
setup_target(${PROJECT_NAME}_lib)

# Import configurations, source definitions, and linker settings
include(Sources)
include(LinkerSettings)

# Establish the dependency of the executable on the library
target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_lib)