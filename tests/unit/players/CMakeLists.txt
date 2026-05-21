target_sources(
    canary_ut
    PRIVATE player_item_batch_test.cpp reward_iteration_test.cpp
)

add_subdirectory(components)
add_subdirectory(condition)
add_subdirectory(imbuements)

target_sources(
    canary_ut
    PRIVATE forge_test.cpp party_test.cpp
)
