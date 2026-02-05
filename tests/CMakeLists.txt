if(NOT CANARY_BUILD_TESTS)
    log_option_disabled("tests")
    return()
endif()

log_option_enabled("tests")
enable_testing()

find_package(
    GTest
    CONFIG
    REQUIRED
)

include(GoogleTest)

function(
    setup_test
    TARGET_NAME
    DIR
)
    if(NOT
       TARGET
       canary_core
    )
        if(NOT CANARY_BUILD_TESTS)
            return()
        endif()
        message(
            FATAL_ERROR
                "canary_core is required when building tests. Ensure CANARY_BUILD_TESTS is ON."
        )
    endif()

    add_executable(${TARGET_NAME})

    target_sources(
        ${TARGET_NAME}
        PRIVATE ${CMAKE_SOURCE_DIR}/tests/${DIR}/main.cpp
    )

    target_compile_definitions(
        ${TARGET_NAME}
        PUBLIC -DDEBUG_LOG -DBUILD_TESTS
    )

    target_link_libraries(
        ${TARGET_NAME}
        PRIVATE canary_core GTest::gtest
    )

    target_include_directories(
        ${TARGET_NAME}
        PRIVATE ${CMAKE_SOURCE_DIR}/tests/fixture
                ${CMAKE_SOURCE_DIR}/tests/${DIR}
    )

    target_compile_features(
        ${TARGET_NAME}
        PRIVATE cxx_std_20
    )

    if(USE_PRECOMPILED_HEADER)
        target_precompile_headers(
            ${TARGET_NAME}
            PRIVATE
            ${CMAKE_SOURCE_DIR}/tests/test_pch.hpp
        )
        target_compile_definitions(
            ${TARGET_NAME}
            PRIVATE USE_PRECOMPILED_HEADERS
        )
    endif()

    # Note: setup_target is internal, assume it works for generic targets
    if(COMMAND setup_target)
        setup_target(${TARGET_NAME})
    endif()

    # Note: configure_linking handles global flags
    if(COMMAND configure_linking)
        configure_linking(${TARGET_NAME})
    endif()

    set_target_properties(
        ${TARGET_NAME}
        PROPERTIES UNITY_BUILD OFF
                   INTERPROCEDURAL_OPTIMIZATION OFF
    )
    log_option_disabled("Build unity")

    if(MSVC)
        target_link_options(
            ${TARGET_NAME}
            PRIVATE
            /DEBUG:FASTLINK
        )
        # Ensure correct runtime if static
        if(BUILD_STATIC_LIBRARY)
            set_property(
                TARGET ${TARGET_NAME}
                PROPERTY MSVC_RUNTIME_LIBRARY
                         "MultiThreaded$<$<CONFIG:Debug>:Debug>"
            )
        else()
            set_property(
                TARGET ${TARGET_NAME}
                PROPERTY MSVC_RUNTIME_LIBRARY
                         "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL"
            )
        endif()
    endif()

    # Diagnostics: Force run the executable to ensure it works and environment
    # is correct This will break the build if the executable crashes or misses
    # DLLs/SOs
    add_custom_command(
        TARGET ${TARGET_NAME}
        POST_BUILD
        COMMAND
            ${CMAKE_COMMAND} -E echo
            "Test Executable Path: $<TARGET_FILE:${TARGET_NAME}>"
        COMMAND ${TARGET_NAME} --gtest_list_tests
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/tests/${DIR}
        COMMENT "Verifying test executable ${TARGET_NAME} can run..."
    )

    gtest_discover_tests(
        ${TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/tests/${DIR}
        PROPERTIES
        TIMEOUT 120
                DISCOVERY_MODE PRE_TEST
    )
endfunction()

add_subdirectory(unit)
add_subdirectory(integration)
