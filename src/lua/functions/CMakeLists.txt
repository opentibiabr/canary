target_sources(
    ${PROJECT_NAME}_lib
    PRIVATE lua_functions_loader.cpp
)

add_subdirectory(core)
add_subdirectory(creatures)
add_subdirectory(events)
add_subdirectory(items)
add_subdirectory(map)
