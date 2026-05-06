add_subdirectory(components)
add_subdirectory(imbuements)

target_sources(
    canary_ut
    PRIVATE forge_test.cpp
)
