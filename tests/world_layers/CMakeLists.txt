# Compile the file service independently to enable fault injection without
# exposing test hooks in the server runtime.
find_package(
    nlohmann_json
    CONFIG
    REQUIRED
)
add_executable(
    world_file_contract
    file_contract_main.cpp
    file_contract.cpp
    contract_v2.cpp
    ../../src/world/world_layers.cpp
    ../../src/world/world_format.cpp
    ../../src/world/world_selectors.cpp
    ../../src/world/world_validation.cpp
    ../../src/world/world_files.cpp
)
target_include_directories(
    world_file_contract
    PRIVATE ../../src
)
target_compile_features(
    world_file_contract
    PRIVATE cxx_std_20
)
target_compile_definitions(
    world_file_contract
    PRIVATE WORLD_FILES_TEST_HOOKS
)
target_link_libraries(
    world_file_contract
    PRIVATE nlohmann_json::nlohmann_json
)
add_test(
    NAME world_file_contract
    COMMAND world_file_contract "${CMAKE_CURRENT_BINARY_DIR}/scratch"
)

# The root build includes the same helper in release artifacts and tests.
# Running it does not start a server or evaluate gameplay Lua.
find_package(
    Python3 3.12
    COMPONENTS Interpreter
    REQUIRED
)
add_test(
    NAME world_migration_contract
    COMMAND
        "${Python3_EXECUTABLE}" -m unittest discover -s
        tools/world_migrate/tests -t . -p "test_*.py" -v
)
set_tests_properties(
    world_migration_contract
    PROPERTIES WORKING_DIRECTORY
               "${CMAKE_CURRENT_SOURCE_DIR}/../.."
               ENVIRONMENT
               "WORLD_TOOL_PATH=$<TARGET_FILE:world-tool>"
               TIMEOUT
               300
)
