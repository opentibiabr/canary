/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/game.hpp"
#include "game/movement/position.hpp"
#include "lua/functions/map/position_functions.hpp"
#include "map/spectators.hpp"

int PositionFunctions::luaPositionCreate(lua_State* L) {
	// Position([x = 0[, y = 0[, z = 0[, stackpos = 0]]]])
	// Position([position])
	if (lua_gettop(L) <= 1) {
		pushPosition(L, Position());
		return 1;
	}

	int32_t stackpos;
	if (isTable(L, 2)) {
		const Position &position = getPosition(L, 2, stackpos);
		pushPosition(L, position, stackpos);
	} else {
		uint16_t x = getNumber<uint16_t>(L, 2, 0);
		uint16_t y = getNumber<uint16_t>(L, 3, 0);
		uint8_t z = getNumber<uint8_t>(L, 4, 0);
		stackpos = getNumber<int32_t>(L, 5, 0);

		pushPosition(L, Position(x, y, z), stackpos);
	}
	return 1;
}

int PositionFunctions::luaPositionAdd(lua_State* L) {
	// positionValue = position + positionEx
	int32_t stackpos;
	const Position &position = getPosition(L, 1, stackpos);

	Position positionEx;
	if (stackpos == 0) {
		positionEx = getPosition(L, 2, stackpos);
	} else {
		positionEx = getPosition(L, 2);
	}

	pushPosition(L, position + positionEx, stackpos);
	return 1;
}

int PositionFunctions::luaPositionSub(lua_State* L) {
	// positionValue = position - positionEx
	int32_t stackpos;
	const Position &position = getPosition(L, 1, stackpos);

	Position positionEx;
	if (stackpos == 0) {
		positionEx = getPosition(L, 2, stackpos);
	} else {
		positionEx = getPosition(L, 2);
	}

	pushPosition(L, position - positionEx, stackpos);
	return 1;
}

int PositionFunctions::luaPositionCompare(lua_State* L) {
	// position == positionEx
	const Position &positionEx = getPosition(L, 2);
	const Position &position = getPosition(L, 1);
	pushBoolean(L, position == positionEx);
	return 1;
}

int PositionFunctions::luaPositionGetDistance(lua_State* L) {
	// position:getDistance(positionEx)
	const Position &positionEx = getPosition(L, 2);
	const Position &position = getPosition(L, 1);
	lua_pushnumber(L, std::max<int32_t>(std::max<int32_t>(std::abs(Position::getDistanceX(position, positionEx)), std::abs(Position::getDistanceY(position, positionEx))), std::abs(Position::getDistanceZ(position, positionEx))));
	return 1;
}

int PositionFunctions::luaPositionGetPathTo(lua_State* L) {
	// position:getPathTo(pos[, minTargetDist = 0[, maxTargetDist = 1[, fullPathSearch = true[, clearSight = true[, maxSearchDist = 0]]]]])
	const Position &pos = getPosition(L, 1);
	const Position &position = getPosition(L, 2);

	FindPathParams fpp;
	fpp.minTargetDist = getNumber<int32_t>(L, 3, 0);
	fpp.maxTargetDist = getNumber<int32_t>(L, 4, 1);
	fpp.fullPathSearch = getBoolean(L, 5, fpp.fullPathSearch);
	fpp.clearSight = getBoolean(L, 6, fpp.clearSight);
	fpp.maxSearchDist = getNumber<int32_t>(L, 7, fpp.maxSearchDist);

	stdext::arraylist<Direction> dirList(128);
	if (g_game().map.getPathMatching(pos, dirList, FrozenPathingConditionCall(position), fpp)) {
		lua_newtable(L);

		int index = 0;
		for (Direction dir : dirList) {
			lua_pushnumber(L, dir);
			lua_rawseti(L, -2, ++index);
		}
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int PositionFunctions::luaPositionIsSightClear(lua_State* L) {
	// position:isSightClear(positionEx[, sameFloor = true])
	bool sameFloor = getBoolean(L, 3, true);
	const Position &positionEx = getPosition(L, 2);
	const Position &position = getPosition(L, 1);
	pushBoolean(L, g_game().isSightClear(position, positionEx, sameFloor));
	return 1;
}

int PositionFunctions::luaPositionGetTile(lua_State* L) {
	// position:getTile()
	const Position &position = getPosition(L, 1);
	pushUserdata(L, g_game().map.getTile(position));
	return 1;
}

int PositionFunctions::luaPositionGetZones(lua_State* L) {
	// position:getZones()
	const Position &position = getPosition(L, 1);
	auto tile = g_game().map.getTile(position);
	if (tile == nullptr) {
		lua_pushnil(L);
		return 1;
	}
	int index = 0;
	for (auto zone : tile->getZones()) {
		index++;
		pushUserdata<Zone>(L, zone);
		setMetatable(L, -1, "Zone");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int PositionFunctions::luaPositionSendMagicEffect(lua_State* L) {
	// position:sendMagicEffect(magicEffect[, player = nullptr])
	CreatureVector spectators;
	if (lua_gettop(L) >= 3) {
		if (const auto &player = getPlayer(L, 3)) {
			spectators.emplace_back(player);
		}
	}

	MagicEffectClasses magicEffect = getNumber<MagicEffectClasses>(L, 2);
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && !g_game().isMagicEffectRegistered(magicEffect)) {
		g_logger().warn("[PositionFunctions::luaPositionSendMagicEffect] An unregistered magic effect type with id '{}' was blocked to prevent client crash.", fmt::underlying(magicEffect));
		pushBoolean(L, false);
		return 1;
	}

	const Position &position = getPosition(L, 1);
	if (!spectators.empty()) {
		Game::addMagicEffect(spectators, position, magicEffect);
	} else {
		g_game().addMagicEffect(position, magicEffect);
	}

	pushBoolean(L, true);
	return 1;
}

int PositionFunctions::luaPositionRemoveMagicEffect(lua_State* L) {
	// position:removeMagicEffect(magicEffect[, player = nullptr])
	CreatureVector spectators;
	if (lua_gettop(L) >= 3) {
		if (const auto &player = getPlayer(L, 3)) {
			spectators.emplace_back(player);
		}
	}

	MagicEffectClasses magicEffect = getNumber<MagicEffectClasses>(L, 2);
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && !g_game().isMagicEffectRegistered(magicEffect)) {
		g_logger().warn("[PositionFunctions::luaPositionRemoveMagicEffect] An unregistered magic effect type with id '{}' was blocked to prevent client crash.", fmt::underlying(magicEffect));
		pushBoolean(L, false);
		return 1;
	}

	const Position &position = getPosition(L, 1);
	if (!spectators.empty()) {
		Game::removeMagicEffect(spectators, position, magicEffect);
	} else {
		g_game().removeMagicEffect(position, magicEffect);
	}

	pushBoolean(L, true);
	return 1;
}

int PositionFunctions::luaPositionSendDistanceEffect(lua_State* L) {
	// position:sendDistanceEffect(positionEx, distanceEffect[, player = nullptr])
	CreatureVector spectators;
	if (lua_gettop(L) >= 4) {
		if (const auto &player = getPlayer(L, 4)) {
			spectators.emplace_back(player);
		}
	}

	ShootType_t distanceEffect = getNumber<ShootType_t>(L, 3);
	const Position &positionEx = getPosition(L, 2);
	const Position &position = getPosition(L, 1);
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && !g_game().isDistanceEffectRegistered(distanceEffect)) {
		g_logger().warn("[PositionFunctions::luaPositionSendDistanceEffect] An unregistered distance effect type with id '{}' was blocked to prevent client crash.", fmt::underlying(distanceEffect));
		return 1;
	}

	if (!spectators.empty()) {
		Game::addDistanceEffect(spectators, position, positionEx, distanceEffect);
	} else {
		g_game().addDistanceEffect(position, positionEx, distanceEffect);
	}

	pushBoolean(L, true);
	return 1;
}

int PositionFunctions::luaPositionSendSingleSoundEffect(lua_State* L) {
	// position:sendSingleSoundEffect(soundId[, actor = nullptr])
	const Position &position = getPosition(L, 1);
	SoundEffect_t soundEffect = getNumber<SoundEffect_t>(L, 2);
	std::shared_ptr<Creature> actor = getCreature(L, 3);

	g_game().sendSingleSoundEffect(position, soundEffect, actor);
	pushBoolean(L, true);
	return 1;
}

int PositionFunctions::luaPositionSendDoubleSoundEffect(lua_State* L) {
	// position:sendDoubleSoundEffect(mainSoundId, secondarySoundId[, actor = nullptr])
	const Position &position = getPosition(L, 1);
	SoundEffect_t mainSoundEffect = getNumber<SoundEffect_t>(L, 2);
	SoundEffect_t secondarySoundEffect = getNumber<SoundEffect_t>(L, 3);
	std::shared_ptr<Creature> actor = getCreature(L, 4);

	g_game().sendDoubleSoundEffect(position, mainSoundEffect, secondarySoundEffect, actor);
	pushBoolean(L, true);
	return 1;
}

int PositionFunctions::luaPositionToString(lua_State* L) {
	// position:toString()
	const Position &position = getPosition(L, 1);
	pushString(L, position.toString());
	return 1;
}
