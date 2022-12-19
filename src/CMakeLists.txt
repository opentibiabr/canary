if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	project(canary-debug)
else()
	project(canary)
endif()

# *****************************************************************************
# CMake Features
# *****************************************************************************
set(CMAKE_CXX_STANDARD 20)
set(GNUCXX_MINIMUM_VERSION 11)
set(MSVC_MINIMUM_VERSION "19.32")
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(Boost_NO_WARN_NEW_VERSIONS ON)


# Global gives error when building spdlog
# Avoid changes by cmake/make on the source tree
# https://gitlab.kitware.com/cmake/cmake/issues/18403
set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

# Make will print more details
set(CMAKE_VERBOSE_MAKEFILE OFF)

# Generate compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# *****************************************************************************
# Sanity Check
# *****************************************************************************

# === GCC Minimum Version ===
if (CMAKE_COMPILER_IS_GNUCXX)
	message("-- Compiler: GCC - Version: ${CMAKE_CXX_COMPILER_VERSION}")
	if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS GNUCXX_MINIMUM_VERSION)
		message(FATAL_ERROR "GCC version must be at least ${GNUCXX_MINIMUM_VERSION}!")
	endif()
endif()

# === Minimum required version for visual studio ===
if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
	message("-- Compiler: Visual Studio - Version: ${CMAKE_CXX_COMPILER_VERSION}")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS MSVC_MINIMUM_VERSION)
		message(FATAL_ERROR "Visual Studio version must be at least ${MSVC_MINIMUM_VERSION}")
	endif()
endif()

# *****************************************************************************
# Options
# *****************************************************************************
option(TOGGLE_BIN_FOLDER "Use build/bin folder for generate compilation files" ON)
option(OPTIONS_ENABLE_OPENMP "Enable Open Multi-Processing support." ON)
option(DEBUG_LOG "Enable Debug Log" OFF)
option(ASAN_ENABLED "Build this target with AddressSanitizer" OFF)
option(BUILD_STATIC_LIBRARY "Build using static libraries" OFF)


# *****************************************************************************
# Project
# *****************************************************************************
if (MSVC)
	add_executable(${PROJECT_NAME} "" ../cmake/canary.rc)
else()
	add_executable(${PROJECT_NAME} "")
endif()

# *****************************************************************************
# Build flags
# *****************************************************************************
if (CMAKE_COMPILER_IS_GNUCXX)
	target_compile_options(${PROJECT_NAME} PRIVATE -Wno-deprecated-declarations)
endif()

# *****************************************************************************
# DEBUG: Print cmake variables
# *****************************************************************************
#get_cmake_property(_variableNames VARIABLES)
#list (SORT _variableNames)
#foreach (_variableName ${_variableNames})
#	message(STATUS "${_variableName}=${${_variableName}}")
#endforeach()


# *****************************************************************************
# Options Code
# *****************************************************************************

# === OpenMP ===
if(OPTIONS_ENABLE_OPENMP)
	log_option_enabled("openmp")
	find_package(OpenMP)
	if(OpenMP_CXX_FOUND)
			target_link_libraries(${PROJECT_NAME} PUBLIC OpenMP::OpenMP_CXX)
	endif()
else()
	log_option_disabled("openmp")
endif()


# === IPO ===
check_ipo_supported(RESULT result OUTPUT output)
if(result)
	set_property(TARGET ${PROJECT_NAME} PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
else()
	message(WARNING "IPO is not supported: ${output}")
endif()


# === ASAN ===
if(ASAN_ENABLED)
	log_option_enabled("asan")

	if(MSVC)
		target_compile_options(${PROJECT_NAME} PUBLIC /fsanitize=address)
	else()
		target_compile_options(${PROJECT_NAME} PUBLIC -fsanitize=address)
		target_link_options(${PROJECT_NAME} PUBLIC -fsanitize=address)
	endif()
else()
	log_option_disabled("asan")
endif()


# === DEBUG LOG ===
# cmake -DDEBUG_LOG=ON ..
if(DEBUG_LOG)
	target_compile_definitions(${PROJECT_NAME} PRIVATE -DDEBUG_LOG=ON )
	log_option_enabled("DEBUG LOG")
	else()
	log_option_disabled("DEBUG LOG")
endif(DEBUG_LOG)

# === PRECOMPILED HEADER ===
target_precompile_headers(${PROJECT_NAME} PRIVATE pch.hpp)

# *****************************************************************************
# Packages / Libs
# *****************************************************************************
find_package(spdlog REQUIRED)
find_package(LuaJIT REQUIRED)
find_package(Threads REQUIRED)
find_package(Protobuf REQUIRED)
find_package(GMP REQUIRED)
find_package(magic_enum CONFIG REQUIRED)

if (MSVC)
	find_package(Boost 1.53.0 COMPONENTS system filesystem iostreams date_time REQUIRED)
	find_package(CURL REQUIRED)
	find_package(jsoncpp REQUIRED)
	find_package(MySQL REQUIRED)
	find_package(PugiXML REQUIRED)
else()
	find_package(Boost REQUIRED COMPONENTS system filesystem iostreams date_time)
	find_package(CURL CONFIG REQUIRED)
	find_package(jsoncpp CONFIG REQUIRED)
	find_package(pugixml CONFIG REQUIRED)
	find_package(unofficial-libmariadb CONFIG REQUIRED)
endif (MSVC)

include(GNUInstallDirs)

# *****************************************************************************
# Projetct configuration
# *****************************************************************************
target_sources(${PROJECT_NAME}
PRIVATE
	config/configmanager.cpp
	creatures/appearance/mounts/mounts.cpp
	creatures/appearance/outfit/outfit.cpp
	creatures/combat/combat.cpp
	creatures/combat/condition.cpp
	creatures/combat/spells.cpp
	creatures/creature.cpp
	creatures/interactions/chat.cpp
	creatures/monsters/monster.cpp
	creatures/monsters/monsters.cpp
	creatures/monsters/spawns/spawn_monster.cpp
	creatures/npcs/npc.cpp
	creatures/npcs/npcs.cpp
	creatures/npcs/spawns/spawn_npc.cpp
	creatures/players/account/account.cpp
	creatures/players/grouping/familiars.cpp
	creatures/players/grouping/groups.cpp
	creatures/players/grouping/guild.cpp
	creatures/players/grouping/party.cpp
	creatures/players/imbuements/imbuements.cpp
	creatures/players/management/ban.cpp
	creatures/players/management/waitlist.cpp
	creatures/players/player.cpp
	creatures/players/vocations/vocation.cpp
	database/database.cpp
	database/databasemanager.cpp
	database/databasetasks.cpp
	game/functions/game_reload.cpp
	game/game.cpp
	game/movement/position.cpp
	game/movement/teleport.cpp
	game/scheduling/scheduler.cpp
	game/scheduling/events_scheduler.cpp
	game/scheduling/tasks.cpp
	io/fileloader.cpp
	io/iobestiary.cpp
	io/ioguild.cpp
	io/iologindata.cpp
	io/functions/iologindata_load_player.cpp
	io/functions/iologindata_save_player.cpp
	io/iomap.cpp
	io/iomapserialize.cpp
	io/iomarket.cpp
	io/ioprey.cpp
	protobuf/appearances.pb.cc
	items/bed.cpp
	items/containers/container.cpp
	items/containers/depot/depotchest.cpp
	items/containers/depot/depotlocker.cpp
	items/containers/inbox/inbox.cpp
	items/containers/mailbox/mailbox.cpp
	items/containers/rewards/reward.cpp
	items/containers/rewards/rewardchest.cpp
	items/cylinder.cpp
	items/decay/decay.cpp
	items/item.cpp
	items/items.cpp
	items/functions/item_parse.cpp
	items/thing.cpp
	items/tile.cpp
	items/trashholder.cpp
	items/weapons/weapons.cpp
	lua/callbacks/creaturecallback.cpp
	lua/creature/actions.cpp
	lua/creature/creatureevent.cpp
	lua/creature/events.cpp
	lua/creature/movement.cpp
	lua/creature/raids.cpp
	lua/creature/talkaction.cpp
	lua/functions/lua_functions_loader.cpp
	lua/functions/core/game/config_functions.cpp
	lua/functions/core/game/game_functions.cpp
	lua/functions/core/game/global_functions.cpp
	lua/functions/core/game/lua_enums.cpp
	lua/functions/core/game/modal_window_functions.cpp
	lua/functions/core/libs/bit_functions.cpp
	lua/functions/core/libs/db_functions.cpp
	lua/functions/core/libs/result_functions.cpp
	lua/functions/core/libs/spdlog_functions.cpp
	lua/functions/core/network/network_message_functions.cpp
	lua/functions/core/network/webhook_functions.cpp
	lua/functions/creatures/combat/combat_functions.cpp
	lua/functions/creatures/combat/condition_functions.cpp
	lua/functions/creatures/combat/spell_functions.cpp
	lua/functions/creatures/combat/variant_functions.cpp
	lua/functions/creatures/creature_functions.cpp
	lua/functions/creatures/monster/charm_functions.cpp
	lua/functions/creatures/monster/loot_functions.cpp
	lua/functions/creatures/monster/monster_functions.cpp
	lua/functions/creatures/monster/monster_spell_functions.cpp
	lua/functions/creatures/monster/monster_type_functions.cpp
	lua/functions/creatures/npc/npc_functions.cpp
	lua/functions/creatures/npc/npc_type_functions.cpp
	lua/functions/creatures/npc/shop_functions.cpp
	lua/functions/creatures/player/group_functions.cpp
	lua/functions/creatures/player/guild_functions.cpp
	lua/functions/creatures/player/mount_functions.cpp
	lua/functions/creatures/player/party_functions.cpp
	lua/functions/creatures/player/player_functions.cpp
	lua/functions/creatures/player/vocation_functions.cpp
	lua/functions/events/action_functions.cpp
	lua/functions/events/creature_event_functions.cpp
	lua/functions/events/events_scheduler_functions.cpp
	lua/functions/events/global_event_functions.cpp
	lua/functions/events/move_event_functions.cpp
	lua/functions/events/talk_action_functions.cpp
	lua/functions/items/container_functions.cpp
	lua/functions/items/imbuement_functions.cpp
	lua/functions/items/item_classification_functions.cpp
	lua/functions/items/item_functions.cpp
	lua/functions/items/item_type_functions.cpp
	lua/functions/items/weapon_functions.cpp
	lua/functions/map/house_functions.cpp
	lua/functions/map/position_functions.cpp
	lua/functions/map/teleport_functions.cpp
	lua/functions/map/tile_functions.cpp
	lua/functions/map/town_functions.cpp
	lua/global/baseevents.cpp
	lua/global/globalevent.cpp
	lua/modules/modules.cpp
	lua/scripts/lua_environment.cpp
	lua/scripts/luascript.cpp
	lua/scripts/script_environment.cpp
	lua/scripts/scripts.cpp
	map/house/house.cpp
	map/house/housetile.cpp
	map/map.cpp
	otserv.cpp
	security/rsa.cpp
	server/network/connection/connection.cpp
	server/network/message/networkmessage.cpp
	server/network/message/outputmessage.cpp
	server/network/protocol/protocol.cpp
	server/network/protocol/protocolgame.cpp
	server/network/protocol/protocollogin.cpp
	server/network/protocol/protocolstatus.cpp
	server/network/webhook/webhook.cpp
	server/server.cpp
	server/signals.cpp
	utils/tools.cpp
	utils/wildcardtree.cpp
)

if (MSVC)

	if(CMAKE_BUILD_TYPE STREQUAL "Debug")
		string(REPLACE "/Zi" "/Z7" CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}")
		string(REPLACE "/Zi" "/Z7" CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}")
	elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
		string(REPLACE "/Zi" "/Z7" CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
		string(REPLACE "/Zi" "/Z7" CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
	elseif(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
		string(REPLACE "/Zi" "/Z7" CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
		string(REPLACE "/Zi" "/Z7" CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO}")
	endif()

	if(BUILD_STATIC_LIBRARY)
		log_option_enabled("STATIC_LIBRARY")
		set(CMAKE_FIND_LIBRARY_SUFFIXES ".lib")
		find_package(unofficial-libmariadb CONFIG REQUIRED)
		set_property(TARGET ${PROJECT_NAME} PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
		target_link_libraries(${PROJECT_NAME}	PRIVATE unofficial::libmariadb unofficial::mariadbclient jsoncpp_static)
	else()
		log_option_disabled("STATIC_LIBRARY")
		target_link_libraries(${PROJECT_NAME}	PRIVATE jsoncpp_lib)
	endif()

  target_compile_options(${PROJECT_NAME} PUBLIC /MP /FS /Zf /EHsc )

	target_include_directories(${PROJECT_NAME}
		PRIVATE
			${Boost_LIBRARY_DIRS}
			${CMAKE_SOURCE_DIR}/src
			${MYSQL_INCLUDE_DIR}
			${LUAJIT_INCLUDE_DIRS}
			${Boost_INCLUDE_DIRS}
			${PUGIXML_INCLUDE_DIR}
			${CURL_INCLUDE_DIRS}
			${PARALLEL_HASHMAP_INCLUDE_DIRS}
			${Protobuf_INCLUDE_DIRS}
			${SPDLOG_INCLUDE_DIR}
			${GMP_INCLUDE_DIR}
	)

	target_link_libraries(${PROJECT_NAME}
		PRIVATE
			${MYSQL_CLIENT_LIBS}
			${LUAJIT_LIBRARIES}
			${Boost_LIBRARIES}
			${PUGIXML_LIBRARIES}
			${CMAKE_THREAD_LIBS_INIT}
			${CURL_LIBRARIES}
			${Protobuf_LIBRARIES}
			${SPDLOG_LIBRARY}
			${GMP_LIBRARIES}
			fmt::fmt
			magic_enum::magic_enum
	)

else()

	target_include_directories(${PROJECT_NAME}
		PRIVATE
			${CMAKE_SOURCE_DIR}/src
			${LUAJIT_INCLUDE_DIRS}
			${PARALLEL_HASHMAP_INCLUDE_DIRS}
			${Protobuf_INCLUDE_DIRS}
			${GMP_INCLUDE_DIRS}
	)

	target_link_libraries(${PROJECT_NAME}
		PRIVATE
			${LUAJIT_LIBRARIES}
			${Protobuf_LIBRARIES}
			${GMP_LIBRARIES}
			Boost::boost
			Boost::date_time
			Boost::filesystem
			Boost::iostreams
			Boost::system
			CURL::libcurl
			jsoncpp_static
			unofficial::libmariadb unofficial::mariadbclient
			pugixml::pugixml
			spdlog::spdlog
			Threads::Threads
			magic_enum::magic_enum
	)

endif (MSVC)

## Link compilation files to build/bin folder, else link to the main dir
if (TOGGLE_BIN_FOLDER)
	set_target_properties(${PROJECT_NAME}
		PROPERTIES
		RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
	)
else()
	set_target_properties(${PROJECT_NAME}
	PROPERTIES
		RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/"
	)
endif()
