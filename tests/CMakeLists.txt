find_package(ut CONFIG REQUIRED)

enable_testing()

function(setup_test TARGET_NAME DIR)
    add_executable(${TARGET_NAME} main.cpp)

    target_compile_definitions(${TARGET_NAME} PUBLIC -DDEBUG_LOG -DBUILD_TESTS)
    target_link_libraries(${TARGET_NAME}  PRIVATE Boost::ut ${PROJECT_NAME}_lib)
    target_include_directories(${TARGET_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/tests/fixture PRIVATE ${CMAKE_SOURCE_DIR}/tests/${DIR})

    setup_target(${TARGET_NAME})

    set_target_properties(${TARGET_NAME} PROPERTIES
        UNITY_BUILD OFF
        INTERPROCEDURAL_OPTIMIZATION OFF
    )
    log_option_disabled("Build unity")

    configure_linking(${TARGET_NAME})

    add_test(NAME ${DIR} COMMAND ${TARGET_NAME} --reporter console --success)
    set_tests_properties(${DIR} PROPERTIES
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/tests/${DIR}
        ENVIRONMENT "CATCH_CONFIG_CONSOLE_WIDTH=160"
        TIMEOUT 120
    )

    if(RUN_TESTS_AFTER_BUILD)
        add_custom_command(
                TARGET ${TARGET_NAME} POST_BUILD
                COMMAND ${CMAKE_CTEST_COMMAND} -C $<CONFIG> --output-on-failure --tests-regex "^${DIR}$"
                COMMENT "Running ctest ${DIR} after building ${TARGET_NAME}"
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )
    endif (RUN_TESTS_AFTER_BUILD)
endfunction()

add_subdirectory(unit)
add_subdirectory(integration)