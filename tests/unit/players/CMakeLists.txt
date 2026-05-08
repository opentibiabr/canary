target_sources(
	canary_ut
	PRIVATE player_ip_test.cpp
)

add_subdirectory(components)
add_subdirectory(condition)
add_subdirectory(imbuements)
