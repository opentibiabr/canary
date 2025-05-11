/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/instances/instance_functions.hpp"
#include "game/instances/instance_manager.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void InstanceFunctions::init(lua_State* L) {
	// Instance functions
	lua_register(L, "createPlayerInstance", InstanceFunctions::luaCreatePlayerInstance);
	lua_register(L, "teleportToPlayerInstance", InstanceFunctions::luaTeleportToPlayerInstance);
	lua_register(L, "teleportFromPlayerInstance", InstanceFunctions::luaTeleportFromPlayerInstance);
	lua_register(L, "isPlayerInInstance", InstanceFunctions::luaIsPlayerInInstance);
	lua_register(L, "getPlayerInstanceId", InstanceFunctions::luaGetPlayerInstanceId);
	lua_register(L, "removePlayerInstance", InstanceFunctions::luaRemovePlayerInstance);
	lua_register(L, "cleanupPlayerInstances", InstanceFunctions::luaCleanupPlayerInstances);
	lua_register(L, "teleportToPartyMemberInstance", InstanceFunctions::luaTeleportToPartyMemberInstance);
	lua_register(L, "consumePortal", InstanceFunctions::luaConsumePortal);
	lua_register(L, "getRemainingPortals", InstanceFunctions::luaGetRemainingPortals);
	lua_register(L, "addPortalPosition", InstanceFunctions::luaAddPortalPosition);
	lua_register(L, "getInstanceById", InstanceFunctions::luaGetInstanceById);
}

int InstanceFunctions::luaCreatePlayerInstance(lua_State* L) {
	// createPlayerInstance(player, mapName, entryPosition, exitPosition, isPartyInstance)
	const auto &player = Lua::getPlayer(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const std::string &mapName = Lua::getString(L, 2);
	const Position &entryPosition = Lua::getPosition(L, 3);
	const Position &exitPosition = Lua::getPosition(L, 4);
	bool isPartyInstance = false;
	
	// Check if isPartyInstance parameter was provided
	if (lua_gettop(L) >= 5) {
		isPartyInstance = Lua::getBoolean(L, 5);
	}

	uint32_t instanceId = g_instances().createInstance(player, mapName, entryPosition, exitPosition, isPartyInstance);
	if (instanceId == 0) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, instanceId);
	return 1;
}

int InstanceFunctions::luaTeleportToPlayerInstance(lua_State* L) {
	// teleportToPlayerInstance(player, instanceId)
	const auto &player = Lua::getPlayer(L, 1);
	if (!player) {
		lua_pushboolean(L, false);
		return 1;
	}

	uint32_t instanceId = Lua::getNumber<uint32_t>(L, 2);
	bool success = g_instances().teleportToInstance(player, instanceId);
	lua_pushboolean(L, success);
	return 1;
}

int InstanceFunctions::luaTeleportFromPlayerInstance(lua_State* L) {
	// teleportFromPlayerInstance(player)
	const auto &player = Lua::getPlayer(L, 1);
	if (!player) {
		lua_pushboolean(L, false);
		return 1;
	}

	bool success = g_instances().teleportFromInstance(player);
	lua_pushboolean(L, success);
	return 1;
}

int InstanceFunctions::luaIsPlayerInInstance(lua_State* L) {
	// isPlayerInInstance(player)
	const auto &player = Lua::getPlayer(L, 1);
	if (!player) {
		lua_pushboolean(L, false);
		return 1;
	}

	bool inInstance = g_instances().isPlayerInInstance(player);
	lua_pushboolean(L, inInstance);
	return 1;
}

int InstanceFunctions::luaGetPlayerInstanceId(lua_State* L) {
	// getPlayerInstanceId(player)
	const auto &player = Lua::getPlayer(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t instanceId = g_instances().getPlayerInstanceId(player);
	if (instanceId == 0) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, instanceId);
	return 1;
}

int InstanceFunctions::luaRemovePlayerInstance(lua_State* L) {
	// removePlayerInstance(instanceId)
	uint32_t instanceId = Lua::getNumber<uint32_t>(L, 1);
	bool success = g_instances().removeInstance(instanceId);
	lua_pushboolean(L, success);
	return 1;
}

int InstanceFunctions::luaCleanupPlayerInstances(lua_State* L) {
	// cleanupPlayerInstances(maxAge)
	uint32_t maxAge = Lua::getNumber<uint32_t>(L, 1);
	g_instances().cleanupInstances(maxAge);
	lua_pushboolean(L, true);
	return 1;
}

int InstanceFunctions::luaTeleportToPartyMemberInstance(lua_State* L) {
	// teleportToPartyMemberInstance(player, partyMember)
	const auto &player = Lua::getPlayer(L, 1);
	if (!player) {
		lua_pushboolean(L, false);
		return 1;
	}
	
	const auto &partyMember = Lua::getPlayer(L, 2);
	if (!partyMember) {
		lua_pushboolean(L, false);
		return 1;
	}
	
	bool success = g_instances().teleportToPartyMemberInstance(player, partyMember);
	lua_pushboolean(L, success);
	return 1;
}

int InstanceFunctions::luaConsumePortal(lua_State* L) {
	// consumePortal(instanceId)
	uint32_t instanceId = Lua::getNumber<uint32_t>(L, 1);
	
	bool result = g_instances().consumePortal(instanceId);
	lua_pushboolean(L, result);
	return 1;
}

int InstanceFunctions::luaGetRemainingPortals(lua_State* L) {
	// getRemainingPortals(instanceId)
	uint32_t instanceId = Lua::getNumber<uint32_t>(L, 1);
	
	uint8_t remainingPortals = g_instances().getRemainingPortals(instanceId);
	lua_pushnumber(L, remainingPortals);
	return 1;
}

int InstanceFunctions::luaAddPortalPosition(lua_State* L) {
	// addPortalPosition(instanceId, position)
	uint32_t instanceId = Lua::getNumber<uint32_t>(L, 1);
	
	const Position &position = Lua::getPosition(L, 2);
	
	bool result = g_instances().addPortalPosition(instanceId, position);
	lua_pushboolean(L, result);
	return 1;
}

int InstanceFunctions::luaGetInstanceById(lua_State* L) {
	// getInstanceById(instanceId)
	uint32_t instanceId = Lua::getNumber<uint32_t>(L, 1);
	
	// Create a new table to hold the instance data
	lua_newtable(L);
	
	// Get the remaining portals
	uint8_t remainingPortals = g_instances().getRemainingPortals(instanceId);
	lua_pushstring(L, "remainingPortals");
	lua_pushnumber(L, remainingPortals);
	lua_settable(L, -3);
	
	// Get if the instance is active
	bool isActive = (remainingPortals > 0); // Simplified check
	lua_pushstring(L, "active");
	lua_pushboolean(L, isActive);
	lua_settable(L, -3);
	
	return 1;
}