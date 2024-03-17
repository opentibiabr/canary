/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/monsters/monsters.hpp"
#include "lua/functions/creatures/monster/loot_functions.hpp"

#define CHECK_NULL(loot, L)                      \
	if (!loot) {                                 \
		g_logger().error("Invalid loot object"); \
		lua_pushnil(L);                          \
		return 1;                                \
	}

#define CHECK_ARGS(expectedArgs)                                                                                                            \
	if (lua_gettop(L) != expectedArgs) {                                                                                                    \
		g_logger().error("Wrong number of arguments. Expected " + std::to_string(expectedArgs) + ", got " + std::to_string(lua_gettop(L))); \
		lua_pushnil(L);                                                                                                                     \
		return 1;                                                                                                                           \
	}

#define SET_BOOL_RESULT(L, result) \
	lua_pushboolean(L, result);    \
	return 1;

#define SET_ATTRIBUTE(loot, attribute, value) \
	loot->lootBlock.attribute = value;        \
	SET_BOOL_RESULT(L, true)

#define SET_STRING_ATTRIBUTE(loot, attribute, value) \
	loot->lootBlock.attribute = value;               \
	SET_BOOL_RESULT(L, true)

#define SET_NUMERIC_ATTRIBUTE(loot, attribute, type)             \
	type attribute = static_cast<type>(luaL_checkinteger(L, 2)); \
	SET_ATTRIBUTE(loot, attribute, attribute)

#define SET_UNIQUE_ATTRIBUTE(loot, attribute)                        \
	if (lua_gettop(L) == 1) {                                        \
		pushBoolean(L, loot->lootBlock.attribute);                   \
		return 1;                                                    \
	} else if (!lua_isboolean(L, 2)) {                               \
		g_logger().error("Invalid argument type. Boolean expected"); \
		lua_pushnil(L);                                              \
		return 1;                                                    \
	}                                                                \
	loot->lootBlock.attribute = lua_toboolean(L, 2);                 \
	SET_BOOL_RESULT(L, true)

int LootFunctions::luaCreateLoot(lua_State* L) {
	try {
		auto newLoot = std::make_shared<Loot>();
		pushUserdata<Loot>(L, newLoot);
		setMetatable(L, -1, "Loot");
		return 1;
	} catch (const std::exception &e) {
		g_logger().error("Error creating loot: " + std::string(e.what()));
		lua_pushnil(L);
		return 1;
	}
}

int LootFunctions::luaLootSetId(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_NUMERIC_ATTRIBUTE(loot, id, uint16_t);
}

int LootFunctions::luaLootSetIdFromName(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);

	if (!isString(L, 2)) {
		g_logger().error("Unknown loot item or invalid argument type");
		lua_pushnil(L);
		return 1;
	}

	auto name = getString(L, 2);
	auto ids = Item::items.nameToItems.equal_range(asLowerCaseString(name));
	if (ids.first == Item::items.nameToItems.cend() || std::next(ids.first) != ids.second) {
		g_logger().error("Unknown or non-unique loot item " + name);
		lua_pushnil(L);
		return 1;
	}

	loot->lootBlock.id = ids.first->second;
	SET_BOOL_RESULT(L, true);
}

int LootFunctions::luaLootSetSubType(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_NUMERIC_ATTRIBUTE(loot, subType, uint16_t);
}

int LootFunctions::luaLootSetChance(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_NUMERIC_ATTRIBUTE(loot, chance, uint32_t);
}

int LootFunctions::luaLootSetMinCount(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_NUMERIC_ATTRIBUTE(loot, countmin, uint32_t);
}

int LootFunctions::luaLootSetMaxCount(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_NUMERIC_ATTRIBUTE(loot, countmax, uint32_t);
}

int LootFunctions::luaLootSetActionId(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_NUMERIC_ATTRIBUTE(loot, actionId, uint32_t);
}

int LootFunctions::luaLootSetText(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_STRING_ATTRIBUTE(loot, text, luaL_checkstring(L, 2));
}

int LootFunctions::luaLootSetNameItem(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_STRING_ATTRIBUTE(loot, name, luaL_checkstring(L, 2));
}

int LootFunctions::luaLootSetArticle(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_STRING_ATTRIBUTE(loot, article, luaL_checkstring(L, 2));
}

int LootFunctions::luaLootSetAttack(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_NUMERIC_ATTRIBUTE(loot, attack, uint32_t);
}

int LootFunctions::luaLootSetDefense(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_NUMERIC_ATTRIBUTE(loot, defense, uint32_t);
}

int LootFunctions::luaLootSetExtraDefense(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_NUMERIC_ATTRIBUTE(loot, extraDefense, uint32_t);
}

int LootFunctions::luaLootSetArmor(lua_State* L) {
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	uint32_t armor = 0;
	if (!getNumber(L, 2, armor)) {
		g_logger().error("Invalid armor value");
		lua_pushnil(L);
		return 1;
	}
	loot->lootBlock.armor = armor;
	SET_BOOL_RESULT(L, true);
}

int LootFunctions::luaLootSetShootRange(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_NUMERIC_ATTRIBUTE(loot, shootRange, uint32_t);
}

int LootFunctions::luaLootSetHitChance(lua_State* L) {
	CHECK_ARGS(2);
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	SET_NUMERIC_ATTRIBUTE(loot, hitChance, uint32_t);
}

int LootFunctions::luaLootSetUnique(lua_State* L) {
	// loot:setUnique(bool)
	const auto loot = getUserdataShared<Loot>(L, 1);
	if (loot) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, loot->lootBlock.unique);
		} else if (lua_isboolean(L, 2)) {
			loot->lootBlock.unique = lua_toboolean(L, 2);
			pushBoolean(L, true);
		} else {
			g_logger().error("[LootFunctions::luaLootSetUnique] - Invalid argument type. Boolean expected");
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootAddChildLoot(lua_State* L) {
	const auto loot = getUserdataShared<Loot>(L, 1);
	CHECK_NULL(loot, L);
	const auto childLoot = getUserdata<Loot>(L, 2);
	CHECK_NULL(childLoot, L);
	loot->lootBlock.childLoot.push_back(childLoot->lootBlock);
	SET_BOOL_RESULT(L, true);
}
