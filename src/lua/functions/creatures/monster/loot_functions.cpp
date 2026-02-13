/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/monster/loot_functions.hpp"

#include "creatures/monsters/monsters.hpp"
#include "items/item.hpp"
#include "utils/tools.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void LootFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Loot", "", LootFunctions::luaCreateLoot);

	Lua::registerMethod(L, "Loot", "setId", LootFunctions::luaLootSetId);
	Lua::registerMethod(L, "Loot", "setIdFromName", LootFunctions::luaLootSetIdFromName);
	Lua::registerMethod(L, "Loot", "setMinCount", LootFunctions::luaLootSetMinCount);
	Lua::registerMethod(L, "Loot", "setMaxCount", LootFunctions::luaLootSetMaxCount);
	Lua::registerMethod(L, "Loot", "setSubType", LootFunctions::luaLootSetSubType);
	Lua::registerMethod(L, "Loot", "setChance", LootFunctions::luaLootSetChance);
	Lua::registerMethod(L, "Loot", "setActionId", LootFunctions::luaLootSetActionId);
	Lua::registerMethod(L, "Loot", "setText", LootFunctions::luaLootSetText);
	Lua::registerMethod(L, "Loot", "setNameItem", LootFunctions::luaLootSetNameItem);
	Lua::registerMethod(L, "Loot", "setArticle", LootFunctions::luaLootSetArticle);
	Lua::registerMethod(L, "Loot", "setAttack", LootFunctions::luaLootSetAttack);
	Lua::registerMethod(L, "Loot", "setDefense", LootFunctions::luaLootSetDefense);
	Lua::registerMethod(L, "Loot", "setExtraDefense", LootFunctions::luaLootSetExtraDefense);
	Lua::registerMethod(L, "Loot", "setArmor", LootFunctions::luaLootSetArmor);
	Lua::registerMethod(L, "Loot", "setShootRange", LootFunctions::luaLootSetShootRange);
	Lua::registerMethod(L, "Loot", "setHitChance", LootFunctions::luaLootSetHitChance);
	Lua::registerMethod(L, "Loot", "setUnique", LootFunctions::luaLootSetUnique);
	Lua::registerMethod(L, "Loot", "addChildLoot", LootFunctions::luaLootAddChildLoot);
}

int LootFunctions::luaCreateLoot(lua_State* L) {
	// Loot(monsterName) will create a new loot item
	const int argc = lua_gettop(L);

	std::shared_ptr<Loot> loot;

	std::string monsterName;
	if (argc >= 1) {
		if (!Lua::isString(L, 2)) {
			luaL_error(L, "Loot([monsterName]) expects argument #1 to be a string");
			return 0;
		}

		monsterName = Lua::getString(L, 2);
		loot = std::make_shared<Loot>(monsterName);
	} else {
		loot = std::make_shared<Loot>();
	}

	Lua::pushUserdata<Loot>(L, loot);
	Lua::setMetatable(L, -1, "Loot");
	return 1;
}

template <typename T, auto member>
static int luaLootSetter(lua_State* L) {
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1, "Loot");
	if (loot) {
		loot->lootBlock.*member = Lua::getNumber<T>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

template <auto member>
static int luaLootStringSetter(lua_State* L) {
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1, "Loot");
	if (loot) {
		loot->lootBlock.*member = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetId(lua_State* L) {
	return luaLootSetter<uint16_t, &LootBlock::id>(L);
}

int LootFunctions::luaLootSetIdFromName(lua_State* L) {
	// loot:setIdFromName(name)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1, "Loot");
	if (loot && Lua::isString(L, 2)) {
		auto name = Lua::getString(L, 2);
		const auto &monsterName = loot->monsterName;
		const auto monsterContext = monsterName.empty() ? "" : " (monster: " + monsterName + ")";
		const auto ids = Item::items.nameToItems.equal_range(asLowerCaseString(name));

		if (ids.first == Item::items.nameToItems.cend()) {
			g_logger().warn("[LootFunctions::luaLootSetIdFromName] - "
			                "Unknown loot item '{}'{}",
			                name, monsterContext);
			lua_pushnil(L);
			return 1;
		}

		if (std::next(ids.first) != ids.second) {
			// Build a list of all conflicting IDs for a useful debug message
			std::string conflictingIds;
			for (auto it = ids.first; it != ids.second; ++it) {
				if (!conflictingIds.empty()) {
					conflictingIds += ", ";
				}
				conflictingIds += std::to_string(it->second);
			}
			g_logger().warn("[LootFunctions::luaLootSetIdFromName] - "
			                "Duplicate item name '{}' found with IDs: [{}]. Using first ID: {}{}",
			                name, conflictingIds, ids.first->second, monsterContext);
		}

		loot->lootBlock.id = ids.first->second;
		Lua::pushBoolean(L, true);
	} else {
		g_logger().warn("[LootFunctions::luaLootSetIdFromName] - "
		                "Unknown loot item loot, string value expected");
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetMinCount(lua_State* L) {
	return luaLootSetter<uint32_t, &LootBlock::countmin>(L);
}

int LootFunctions::luaLootSetMaxCount(lua_State* L) {
	return luaLootSetter<uint32_t, &LootBlock::countmax>(L);
}

int LootFunctions::luaLootSetSubType(lua_State* L) {
	return luaLootSetter<int32_t, &LootBlock::subType>(L);
}

int LootFunctions::luaLootSetChance(lua_State* L) {
	return luaLootSetter<uint32_t, &LootBlock::chance>(L);
}

// luaLootSetMinCount and luaLootSetMaxCount are now using the template above

int LootFunctions::luaLootSetActionId(lua_State* L) {
	return luaLootSetter<int32_t, &LootBlock::actionId>(L);
}

int LootFunctions::luaLootSetText(lua_State* L) {
	return luaLootStringSetter<&LootBlock::text>(L);
}

int LootFunctions::luaLootSetNameItem(lua_State* L) {
	return luaLootStringSetter<&LootBlock::name>(L);
}

int LootFunctions::luaLootSetArticle(lua_State* L) {
	return luaLootStringSetter<&LootBlock::article>(L);
}

int LootFunctions::luaLootSetAttack(lua_State* L) {
	return luaLootSetter<int32_t, &LootBlock::attack>(L);
}

int LootFunctions::luaLootSetDefense(lua_State* L) {
	return luaLootSetter<int32_t, &LootBlock::defense>(L);
}

int LootFunctions::luaLootSetExtraDefense(lua_State* L) {
	return luaLootSetter<int32_t, &LootBlock::extraDefense>(L);
}

int LootFunctions::luaLootSetArmor(lua_State* L) {
	return luaLootSetter<int32_t, &LootBlock::armor>(L);
}

int LootFunctions::luaLootSetShootRange(lua_State* L) {
	return luaLootSetter<int32_t, &LootBlock::shootRange>(L);
}

int LootFunctions::luaLootSetHitChance(lua_State* L) {
	return luaLootSetter<int32_t, &LootBlock::hitChance>(L);
}

int LootFunctions::luaLootSetUnique(lua_State* L) {
	// loot:setUnique(bool)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1, "Loot");
	if (loot) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, loot->lootBlock.unique);
		} else {
			loot->lootBlock.unique = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootAddChildLoot(lua_State* L) {
	// loot:addChildLoot(loot)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1, "Loot");
	if (loot) {
		const auto childLoot = Lua::getUserdata<Loot>(L, 2);
		if (childLoot) {
			loot->lootBlock.childLoot.push_back(childLoot->lootBlock);
			Lua::pushBoolean(L, true);
		} else {
			Lua::pushBoolean(L, false);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}
