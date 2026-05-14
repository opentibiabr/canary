target_sources(
    ${CORE_TARGET_NAME}
    PRIVATE lua_functions_loader.cpp
)

# Note: No target_sources here, just subdirectories
add_subdirectory(core)
add_subdirectory(creatures)
add_subdirectory(events)
add_subdirectory(items)
add_subdirectory(map)
