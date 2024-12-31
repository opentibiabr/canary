/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/map/position_functions.hpp"

#include "config/configmanager.hpp"
#include "creatures/creature.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "game/movement/position.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void PositionFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Position", "", PositionFunctions::luaPositionCreate);
	Lua::registerMetaMethod(L, "Position", "__add", PositionFunctions::luaPositionAdd);
	Lua::registerMetaMethod(L, "Position", "__sub", PositionFunctions::luaPositionSub);
	Lua::registerMetaMethod(L, "Position", "__eq", PositionFunctions::luaPositionCompare);

	Lua::registerMethod(L, "Position", "getDistance", PositionFunctions::luaPositionGetDistance);
	Lua::registerMethod(L, "Position", "getPathTo", PositionFunctions::luaPositionGetPathTo);
	Lua::registerMethod(L, "Position", "isSightClear", PositionFunctions::luaPositionIsSightClear);

	Lua::registerMethod(L, "Position", "getTile", PositionFunctions::luaPositionGetTile);
	Lua::registerMethod(L, "Position", "getZones", PositionFunctions::luaPositionGetZones);

	Lua::registerMethod(L, "Position", "sendMagicEffect", PositionFunctions::luaPositionSendMagicEffect);
	Lua::registerMethod(L, "Position", "removeMagicEffect", PositionFunctions::luaPositionRemoveMagicEffect);
	Lua::registerMethod(L, "Position", "sendDistanceEffect", PositionFunctions::luaPositionSendDistanceEffect);

	Lua::registerMethod(L, "Position", "sendSingleSoundEffect", PositionFunctions::luaPositionSendSingleSoundEffect);
	Lua::registerMethod(L, "Position", "sendDoubleSoundEffect", PositionFunctions::luaPositionSendDoubleSoundEffect);

	Lua::registerMethod(L, "Position", "toString", PositionFunctions::luaPositionToString);
}

int PositionFunctions::luaPositionCreate(lua_State* L) {
	// Position([x = 0[, y = 0[, z = 0[, stackpos = 0]]]])
	// Position([position])
	if (lua_gettop(L) <= 1) {
		Lua::pushPosition(L, Position());
		return 1;
	}

	int32_t stackpos;
	if (Lua::isTable(L, 2)) {
		const Position &position = Lua::getPosition(L, 2, stackpos);
		Lua::pushPosition(L, position, stackpos);
	} else {
		const auto x = Lua::getNumber<uint16_t>(L, 2, 0);
		const auto y = Lua::getNumber<uint16_t>(L, 3, 0);
		const auto z = Lua::getNumber<uint8_t>(L, 4, 0);
		stackpos = Lua::getNumber<int32_t>(L, 5, 0);

		Lua::pushPosition(L, Position(x, y, z), stackpos);
	}
	return 1;
}

int PositionFunctions::luaPositionAdd(lua_State* L) {
	// positionValue = position + positionEx
	int32_t stackpos;
	const Position &position = Lua::getPosition(L, 1, stackpos);

	Position positionEx;
	if (stackpos == 0) {
		positionEx = Lua::getPosition(L, 2, stackpos);
	} else {
		positionEx = Lua::getPosition(L, 2);
	}

	Lua::pushPosition(L, position + positionEx, stackpos);
	return 1;
}

int PositionFunctions::luaPositionSub(lua_State* L) {
	// positionValue = position - positionEx
	int32_t stackpos;
	const Position &position = Lua::getPosition(L, 1, stackpos);

	Position positionEx;
	if (stackpos == 0) {
		positionEx = Lua::getPosition(L, 2, stackpos);
	} else {
		positionEx = Lua::getPosition(L, 2);
	}

	Lua::pushPosition(L, position - positionEx, stackpos);
	return 1;
}

int PositionFunctions::luaPositionCompare(lua_State* L) {
	// position == positionEx
	const Position &positionEx = Lua::getPosition(L, 2);
	const Position &position = Lua::getPosition(L, 1);
	Lua::pushBoolean(L, position == positionEx);
	return 1;
}

int PositionFunctions::luaPositionGetDistance(lua_State* L) {
	// position:getDistance(positionEx)
	const Position &positionEx = Lua::getPosition(L, 2);
	const Position &position = Lua::getPosition(L, 1);
	lua_pushnumber(L, std::max<int32_t>(std::max<int32_t>(std::abs(Position::getDistanceX(position, positionEx)), std::abs(Position::getDistanceY(position, positionEx))), std::abs(Position::getDistanceZ(position, positionEx))));
	return 1;
}

int PositionFunctions::luaPositionGetPathTo(lua_State* L) {
	// position:getPathTo(pos[, minTargetDist = 0[, maxTargetDist = 1[, fullPathSearch = true[, clearSight = true[, maxSearchDist = 0]]]]])
	const Position &pos = Lua::getPosition(L, 1);
	const Position &position = Lua::getPosition(L, 2);

	FindPathParams fpp;
	fpp.minTargetDist = Lua::getNumber<int32_t>(L, 3, 0);
	fpp.maxTargetDist = Lua::getNumber<int32_t>(L, 4, 1);
	fpp.fullPathSearch = Lua::getBoolean(L, 5, fpp.fullPathSearch);
	fpp.clearSight = Lua::getBoolean(L, 6, fpp.clearSight);
	fpp.maxSearchDist = Lua::getNumber<int32_t>(L, 7, fpp.maxSearchDist);

	std::vector<Direction> dirList;
	if (g_game().map.getPathMatching(pos, dirList, FrozenPathingConditionCall(position), fpp)) {
		lua_newtable(L);

		int index = 0;
		for (const Direction dir : dirList) {
			lua_pushnumber(L, dir);
			lua_rawseti(L, -2, ++index);
		}
	} else {
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int PositionFunctions::luaPositionIsSightClear(lua_State* L) {
	// position:isSightClear(positionEx[, sameFloor = true])
	const bool sameFloor = Lua::getBoolean(L, 3, true);
	const Position &positionEx = Lua::getPosition(L, 2);
	const Position &position = Lua::getPosition(L, 1);
	Lua::pushBoolean(L, g_game().isSightClear(position, positionEx, sameFloor));
	return 1;
}

int PositionFunctions::luaPositionGetTile(lua_State* L) {
	// position:getTile()
	const Position &position = Lua::getPosition(L, 1);
	Lua::pushUserdata(L, g_game().map.getTile(position));
	return 1;
}

int PositionFunctions::luaPositionGetZones(lua_State* L) {
	// position:getZones()
	const Position &position = Lua::getPosition(L, 1);
	const auto &tile = g_game().map.getTile(position);
	if (tile == nullptr) {
		lua_pushnil(L);
		return 1;
	}
	int index = 0;
	for (const auto &zone : tile->getZones()) {
		index++;
		Lua::pushUserdata<Zone>(L, zone);
		Lua::setMetatable(L, -1, "Zone");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int PositionFunctions::luaPositionSendMagicEffect(lua_State* L) {
	// position:sendMagicEffect(magicEffect[, player = nullptr])
	CreatureVector spectators;
	if (lua_gettop(L) >= 3) {
		const auto &player = Lua::getPlayer(L, 3);
		if (!player) {
			Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
			return 1;
		}

		spectators.emplace_back(player);
	}

	MagicEffectClasses magicEffect = Lua::getNumber<MagicEffectClasses>(L, 2);
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && !g_game().isMagicEffectRegistered(magicEffect)) {
		g_logger().warn("[PositionFunctions::luaPositionSendMagicEffect] An unregistered magic effect type with id '{}' was blocked to prevent client crash.", fmt::underlying(magicEffect));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const Position &position = Lua::getPosition(L, 1);
	if (!spectators.empty()) {
		Game::addMagicEffect(spectators, position, magicEffect);
	} else {
		g_game().addMagicEffect(position, magicEffect);
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int PositionFunctions::luaPositionRemoveMagicEffect(lua_State* L) {
	// position:removeMagicEffect(magicEffect[, player = nullptr])
	CreatureVector spectators;
	if (lua_gettop(L) >= 3) {
		const auto &player = Lua::getPlayer(L, 3);
		if (!player) {
			Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
			return 1;
		}

		spectators.emplace_back(player);
	}

	MagicEffectClasses magicEffect = Lua::getNumber<MagicEffectClasses>(L, 2);
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && !g_game().isMagicEffectRegistered(magicEffect)) {
		g_logger().warn("[PositionFunctions::luaPositionRemoveMagicEffect] An unregistered magic effect type with id '{}' was blocked to prevent client crash.", fmt::underlying(magicEffect));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const Position &position = Lua::getPosition(L, 1);
	if (!spectators.empty()) {
		Game::removeMagicEffect(spectators, position, magicEffect);
	} else {
		g_game().removeMagicEffect(position, magicEffect);
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int PositionFunctions::luaPositionSendDistanceEffect(lua_State* L) {
	// position:sendDistanceEffect(positionEx, distanceEffect[, player = nullptr])
	CreatureVector spectators;
	if (lua_gettop(L) >= 4) {
		const auto &player = Lua::getPlayer(L, 4);
		if (!player) {
			Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
			return 1;
		}

		spectators.emplace_back(player);
	}

	const ShootType_t distanceEffect = Lua::getNumber<ShootType_t>(L, 3);
	const Position &positionEx = Lua::getPosition(L, 2);
	const Position &position = Lua::getPosition(L, 1);
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && !g_game().isDistanceEffectRegistered(distanceEffect)) {
		g_logger().warn("[PositionFunctions::luaPositionSendDistanceEffect] An unregistered distance effect type with id '{}' was blocked to prevent client crash.", fmt::underlying(distanceEffect));
		return 1;
	}

	if (!spectators.empty()) {
		Game::addDistanceEffect(spectators, position, positionEx, distanceEffect);
	} else {
		g_game().addDistanceEffect(position, positionEx, distanceEffect);
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int PositionFunctions::luaPositionSendSingleSoundEffect(lua_State* L) {
	// position:sendSingleSoundEffect(soundId[, actor = nullptr])
	const Position &position = Lua::getPosition(L, 1);
	const SoundEffect_t soundEffect = Lua::getNumber<SoundEffect_t>(L, 2);
	const auto actor = Lua::getCreature(L, 3);

	g_game().sendSingleSoundEffect(position, soundEffect, actor);
	Lua::pushBoolean(L, true);
	return 1;
}

int PositionFunctions::luaPositionSendDoubleSoundEffect(lua_State* L) {
	// position:sendDoubleSoundEffect(mainSoundId, secondarySoundId[, actor = nullptr])
	const Position &position = Lua::getPosition(L, 1);
	const SoundEffect_t mainSoundEffect = Lua::getNumber<SoundEffect_t>(L, 2);
	const SoundEffect_t secondarySoundEffect = Lua::getNumber<SoundEffect_t>(L, 3);
	const auto &actor = Lua::getCreature(L, 4);

	g_game().sendDoubleSoundEffect(position, mainSoundEffect, secondarySoundEffect, actor);
	Lua::pushBoolean(L, true);
	return 1;
}

int PositionFunctions::luaPositionToString(lua_State* L) {
	// position:toString()
	const Position &position = Lua::getPosition(L, 1);
	Lua::pushString(L, position.toString());
	return 1;
}
