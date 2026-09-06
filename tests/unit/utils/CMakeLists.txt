target_sources(
    canary_ut
    PRIVATE numeric_functions_test.cpp
            position_functions_test.cpp
            string_functions_test.cpp
            map_download_test.cpp
            test_batch_update.cpp
)
