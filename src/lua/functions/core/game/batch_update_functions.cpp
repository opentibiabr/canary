/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/game/batch_update_functions.hpp"

#include "lua/functions/lua_functions_loader.hpp"
#include "utils/batch_update.hpp"
#include "creatures/players/player.hpp"

void BatchUpdateFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "BatchUpdate", "", luaBatchUpdateCreate);
	Lua::registerMethod(L, "BatchUpdate", "delete", Lua::luaGarbageCollection);
	Lua::registerMetaMethod(L, "BatchUpdate", "__gc", Lua::luaGarbageCollection);
	Lua::registerMethod(L, "BatchUpdate", "add", luaBatchUpdateAdd);
}

int BatchUpdateFunctions::luaBatchUpdateCreate(lua_State* L) {
	// BatchUpdate(playerActor)
	const auto &playerActor = Lua::getPlayer(L, 2);
	if (!playerActor) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	Lua::pushUserdata<BatchUpdate>(L, std::make_shared<BatchUpdate>(playerActor.get()));
	Lua::setMetatable(L, -1, "BatchUpdate");
	return 1;
}

int BatchUpdateFunctions::luaBatchUpdateAdd(lua_State* L) {
	// BatchUpdate:add(container)
	const auto &batchUpdate = Lua::getUserdataShared<BatchUpdate>(L, 1, "BatchUpdate");
	if (!batchUpdate) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_BATCHUPDATE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &container = Lua::getUserdataShared<Container>(L, 2, "Container");
	if (!container) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CONTAINER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	Lua::pushBoolean(L, batchUpdate->add(container.get()));
	return 1;
}
