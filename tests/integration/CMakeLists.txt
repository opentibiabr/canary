setup_test(canary_it integration)

target_compile_definitions(
    canary_it
    PRIVATE TESTS_ENV_DEFAULT="${PROJECT_SOURCE_DIR}/tests/test.env"
            TESTS_SCHEMA_DEFAULT="${PROJECT_SOURCE_DIR}/schema.sql"
)

add_subdirectory(account)
add_subdirectory(player_storage)
add_subdirectory(event_callbacks)
add_subdirectory(game)
add_subdirectory(security)
