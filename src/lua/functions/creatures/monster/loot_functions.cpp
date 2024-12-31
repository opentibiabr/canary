/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
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
	// Loot() will create a new loot item
	auto loot = std::make_shared<Loot>();
	Lua::pushUserdata<Loot>(L, loot);
	Lua::setMetatable(L, -1, "Loot");
	return 1;
}

int LootFunctions::luaLootSetId(lua_State* L) {
	// loot:setId(id)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		if (Lua::isNumber(L, 2)) {
			loot->lootBlock.id = Lua::getNumber<uint16_t>(L, 2);
			Lua::pushBoolean(L, true);
		} else {
			g_logger().warn("[LootFunctions::luaLootSetId] - "
			                "Unknown loot item loot, int value expected");
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetIdFromName(lua_State* L) {
	// loot:setIdFromName(name)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot && Lua::isString(L, 2)) {
		auto name = Lua::getString(L, 2);
		const auto ids = Item::items.nameToItems.equal_range(asLowerCaseString(name));

		if (ids.first == Item::items.nameToItems.cend()) {
			g_logger().warn("[LootFunctions::luaLootSetIdFromName] - "
			                "Unknown loot item {}",
			                name);
			lua_pushnil(L);
			return 1;
		}

		if (std::next(ids.first) != ids.second) {
			g_logger().warn("[LootFunctions::luaLootSetIdFromName] - "
			                "Non-unique loot item {}",
			                name);
			lua_pushnil(L);
			return 1;
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

int LootFunctions::luaLootSetSubType(lua_State* L) {
	// loot:setSubType(type)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.subType = Lua::getNumber<uint16_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetChance(lua_State* L) {
	// loot:setChance(chance)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.chance = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetMinCount(lua_State* L) {
	// loot:setMinCount(min)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.countmin = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetMaxCount(lua_State* L) {
	// loot:setMaxCount(max)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.countmax = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetActionId(lua_State* L) {
	// loot:setActionId(actionid)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.actionId = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetText(lua_State* L) {
	// loot:setText(text)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.text = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetNameItem(lua_State* L) {
	// loot:setNameItem(name)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.name = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetArticle(lua_State* L) {
	// loot:setArticle(article)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.article = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetAttack(lua_State* L) {
	// loot:setAttack(attack)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.attack = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetDefense(lua_State* L) {
	// loot:setDefense(defense)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.defense = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetExtraDefense(lua_State* L) {
	// loot:setExtraDefense(defense)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.extraDefense = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetArmor(lua_State* L) {
	// loot:setArmor(armor)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.armor = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetShootRange(lua_State* L) {
	// loot:setShootRange(range)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.shootRange = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetHitChance(lua_State* L) {
	// loot:setHitChance(chance)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.hitChance = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LootFunctions::luaLootSetUnique(lua_State* L) {
	// loot:setUnique(bool)
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
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
	const auto &loot = Lua::getUserdataShared<Loot>(L, 1);
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
