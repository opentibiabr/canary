setup_test(canary_it integration)

target_compile_definitions(
    canary_it
    PRIVATE TESTS_ENV_DEFAULT="${PROJECT_SOURCE_DIR}/tests/test.env"
)

add_subdirectory(account)
add_subdirectory(player_storage)
