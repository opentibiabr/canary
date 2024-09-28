# Base configurations and settings for the project
include(BaseConfig)
include(GNUInstallDirs)

# Import configurations, source definitions, and linker settings
include(CanaryLib)

if(MSVC)
    add_compile_options(/experimental:module)
    set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "TRUE") # Habilita suporte experimental a módulos no CMake para MSVC
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    add_compile_options(-std=c++23 -fmodules-ts)
endif()

add_executable(${PROJECT_NAME} main.cpp)

if(MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /experimental:module)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    target_compile_options(${PROJECT_NAME} PRIVATE -fmodules-ts)
endif()


if(MSVC)
    # Add executable icon for Windows
    target_sources(${PROJECT_NAME} PRIVATE ../cmake/canary.rc)
endif()

if (UNIX)

  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
      target_compile_options(${PROJECT_NAME}_lib
        PRIVATE
          -Wall -Wextra -Wpedantic
      )
  endif()

  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_options(${PROJECT_NAME}
      PRIVATE
        -Wall -Wextra -Wpedantic
    )
  endif()

endif (UNIX)

setup_target(${PROJECT_NAME})
set_output_directory(${PROJECT_NAME})
target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_lib)
