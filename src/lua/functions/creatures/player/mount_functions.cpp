/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/player/mount_functions.hpp"

#include "creatures/appearance/mounts/mounts.hpp"
#include "game/game.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void MountFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Mount", "", MountFunctions::luaCreateMount);
	Lua::registerMetaMethod(L, "Mount", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Mount", "getName", MountFunctions::luaMountGetName);
	Lua::registerMethod(L, "Mount", "getId", MountFunctions::luaMountGetId);
	Lua::registerMethod(L, "Mount", "getClientId", MountFunctions::luaMountGetClientId);
	Lua::registerMethod(L, "Mount", "getSpeed", MountFunctions::luaMountGetSpeed);
}

int MountFunctions::luaCreateMount(lua_State* L) {
	// Mount(id or name)
	std::shared_ptr<Mount> mount;
	if (Lua::isNumber(L, 2)) {
		mount = g_game().mounts->getMountByID(Lua::getNumber<uint8_t>(L, 2));
	} else if (Lua::isString(L, 2)) {
		std::string mountName = Lua::getString(L, 2);
		mount = g_game().mounts->getMountByName(mountName);
	} else {
		mount = nullptr;
	}

	if (mount) {
		Lua::pushUserdata<Mount>(L, mount);
		Lua::setMetatable(L, -1, "Mount");
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int MountFunctions::luaMountGetName(lua_State* L) {
	// mount:getName()
	const auto &mount = Lua::getUserdataShared<Mount>(L, 1);
	if (mount) {
		Lua::pushString(L, mount->name);
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int MountFunctions::luaMountGetId(lua_State* L) {
	// mount:getId()
	const auto &mount = Lua::getUserdataShared<Mount>(L, 1);
	if (mount) {
		lua_pushnumber(L, mount->id);
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int MountFunctions::luaMountGetClientId(lua_State* L) {
	// mount:getClientId()
	const auto &mount = Lua::getUserdataShared<Mount>(L, 1);
	if (mount) {
		lua_pushnumber(L, mount->clientId);
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int MountFunctions::luaMountGetSpeed(lua_State* L) {
	// mount:getSpeed()
	const auto &mount = Lua::getUserdataShared<Mount>(L, 1);
	if (mount) {
		lua_pushnumber(L, mount->speed);
	} else {
		lua_pushnil(L);
	}

	return 1;
}
