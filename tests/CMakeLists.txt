if(NOT BUILD_TESTING)
    return()
endif()

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
        PRIVATE ${PROJECT_NAME}_lib GTest::gtest
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

    setup_target(${TARGET_NAME})
    configure_linking(${TARGET_NAME})

    set_target_properties(
        ${TARGET_NAME}
        PROPERTIES UNITY_BUILD OFF
                   INTERPROCEDURAL_OPTIMIZATION OFF
    )
    log_option_disabled("Build unity")

    gtest_discover_tests(
        ${TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/tests/${DIR}
        PROPERTIES
        TIMEOUT 120
    )
endfunction()

add_subdirectory(unit)
add_subdirectory(integration)
