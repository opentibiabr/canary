cmake_minimum_required(
    VERSION 3.22
    FATAL_ERROR
)

# Base configurations and settings for the project
include(BaseConfig)
include(GNUInstallDirs)

# Import configurations, source definitions, and linker settings Note: CanaryLib
# now expects CORE_TARGET_NAME to be defined and CANARY_CORE_TARGETS to be
# populated.

set(CANARY_CORE_TARGETS
    ""
)

if(CANARY_BUILD_TESTS)
    # Split Mode: Core is a Static Lib
    add_library(canary_core STATIC)
    set(CORE_TARGET_NAME
        canary_core
    )
    list(
        APPEND
        CANARY_CORE_TARGETS
        canary_core
    )
    setup_target(canary_core)

    if(CANARY_BUILD_SERVER)
        add_executable(
            ${PROJECT_NAME}
            main.cpp
        )
        target_link_libraries(
            ${PROJECT_NAME}
            PRIVATE canary_core
        )

        # MSVC Icon
        if(MSVC)
            target_sources(
                ${PROJECT_NAME}
                PRIVATE ../cmake/canary.rc
            )
        endif()

        setup_target(${PROJECT_NAME})
        set_output_directory(${PROJECT_NAME})
        configure_linking(${PROJECT_NAME})
    endif()
else()
    # Fold Mode: Core sources go directly into Exe In this mode we ALWAYS build
    # the server, otherwise there is no target
    add_executable(
        ${PROJECT_NAME}
        main.cpp
    )
    set(CORE_TARGET_NAME
        ${PROJECT_NAME}
    )
    list(
        APPEND
        CANARY_CORE_TARGETS
        ${PROJECT_NAME}
    )

    # MSVC Icon
    if(MSVC)
        target_sources(
            ${PROJECT_NAME}
            PRIVATE ../cmake/canary.rc
        )
    endif()

    setup_target(${PROJECT_NAME})
    set_output_directory(${PROJECT_NAME})
    configure_linking(${PROJECT_NAME})

    # Exclude from all if server build is disabled (but we just created it
    # above) This mimics OTClient logic where main target defines existence
    if(NOT CANARY_BUILD_SERVER)
        set_target_properties(
            ${PROJECT_NAME}
            PROPERTIES EXCLUDE_FROM_ALL ON
        )
        if(MSVC)
            set_target_properties(
                ${PROJECT_NAME}
                PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD ON
            )
        endif()
    endif()
endif()

# Include CanaryLib which populates sources/settings on CORE_TARGET_NAME
include(CanaryLib)

# Compiler warnings and options
if(UNIX)
    if(CMAKE_BUILD_TYPE
       STREQUAL
       "Debug"
    )
        foreach(
            core_target IN
            LISTS CANARY_CORE_TARGETS
        )
            target_compile_options(
                ${core_target}
                PRIVATE -Wall
                        -Wextra
                        -Wpedantic
            )
        endforeach()
    endif()
endif()
