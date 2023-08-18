# Base configurations and settings for the project
include(BaseConfig)

# Define project targets
add_library(${PROJECT_NAME}_lib "")
add_executable(${PROJECT_NAME} otserv.cpp)

# Import configurations, source definitions, and linker settings
include(Options)
include(Sources)
include(LinkerSettings)

# Standardize settings and properties across targets
setup_target(${PROJECT_NAME}_lib)
setup_target(${PROJECT_NAME})

# Establish the dependency of the executable on the library
target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_lib)