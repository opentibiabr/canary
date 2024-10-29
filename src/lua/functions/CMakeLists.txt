target_sources(${CANARY_TARGET_NAME} PRIVATE
    lua_functions_loader.cpp
)

add_subdirectory(core)
add_subdirectory(creatures)
add_subdirectory(events)
add_subdirectory(items)
add_subdirectory(map)
