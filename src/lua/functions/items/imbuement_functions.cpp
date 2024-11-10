/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/items/imbuement_functions.hpp"

#include "items/weapons/weapons.hpp"
#include "creatures/players/imbuements/imbuements.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void ImbuementFunctions::init(lua_State* L) {
	Lua::registerClass(L, "Imbuement", "", ImbuementFunctions::luaCreateImbuement);
	Lua::registerMetaMethod(L, "Imbuement", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Imbuement", "getName", ImbuementFunctions::luaImbuementGetName);
	Lua::registerMethod(L, "Imbuement", "getId", ImbuementFunctions::luaImbuementGetId);
	Lua::registerMethod(L, "Imbuement", "getItems", ImbuementFunctions::luaImbuementGetItems);
	Lua::registerMethod(L, "Imbuement", "getBase", ImbuementFunctions::luaImbuementGetBase);
	Lua::registerMethod(L, "Imbuement", "getCategory", ImbuementFunctions::luaImbuementGetCategory);
	Lua::registerMethod(L, "Imbuement", "isPremium", ImbuementFunctions::luaImbuementIsPremium);
	Lua::registerMethod(L, "Imbuement", "getElementDamage", ImbuementFunctions::luaImbuementGetElementDamage);
	Lua::registerMethod(L, "Imbuement", "getCombatType", ImbuementFunctions::luaImbuementGetCombatType);
}

int ImbuementFunctions::luaCreateImbuement(lua_State* L) {
	// Imbuement(id)
	const uint16_t imbuementId = Lua::getNumber<uint16_t>(L, 2);
	Imbuement* imbuement = g_imbuements().getImbuement(imbuementId);

	if (imbuement) {
		Lua::pushUserdata<Imbuement>(L, imbuement);
		Lua::setMetatable(L, -1, "Imbuement");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ImbuementFunctions::luaImbuementGetName(lua_State* L) {
	// imbuement:getName()
	const auto* imbuement = Lua::getUserdata<Imbuement>(L, 1);
	if (imbuement) {
		Lua::pushString(L, imbuement->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ImbuementFunctions::luaImbuementGetId(lua_State* L) {
	// imbuement:getId()
	const auto* imbuement = Lua::getUserdata<Imbuement>(L, 1);
	if (imbuement) {
		lua_pushnumber(L, imbuement->getID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ImbuementFunctions::luaImbuementGetItems(lua_State* L) {
	// imbuement:getItems()
	const auto* imbuement = Lua::getUserdata<Imbuement>(L, 1);
	if (!imbuement) {
		lua_pushnil(L);
		return 1;
	}

	const auto items = imbuement->getItems();

	lua_createtable(L, items.size(), 0);
	for (const auto &itm : items) {
		lua_createtable(L, 0, 2);
		Lua::setField(L, "itemid", itm.first);
		Lua::setField(L, "count", itm.second);
		lua_rawseti(L, -2, itm.first);
	}

	return 1;
}

int ImbuementFunctions::luaImbuementGetBase(lua_State* L) {
	// imbuement:getBase()
	const auto* imbuement = Lua::getUserdata<Imbuement>(L, 1);
	if (!imbuement) {
		lua_pushnil(L);
		return 1;
	}

	const BaseImbuement* baseImbuement = g_imbuements().getBaseByID(imbuement->getBaseID());
	if (!baseImbuement) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, 0, 7);
	Lua::setField(L, "id", baseImbuement->id);
	Lua::setField(L, "name", baseImbuement->name);
	Lua::setField(L, "price", baseImbuement->price);
	Lua::setField(L, "protection", baseImbuement->protectionPrice);
	Lua::setField(L, "percent", baseImbuement->percent);
	Lua::setField(L, "removeCost", baseImbuement->removeCost);
	Lua::setField(L, "duration", baseImbuement->duration);
	return 1;
}

int ImbuementFunctions::luaImbuementGetCategory(lua_State* L) {
	// imbuement:getCategory()
	const auto* imbuement = Lua::getUserdata<Imbuement>(L, 1);
	if (!imbuement) {
		lua_pushnil(L);
		return 1;
	}
	const uint16_t categoryId = imbuement->getCategory();
	const CategoryImbuement* categoryImbuement = g_imbuements().getCategoryByID(categoryId);

	if (categoryImbuement) {
		lua_createtable(L, 0, 2);
		Lua::setField(L, "id", categoryImbuement->id);
		Lua::setField(L, "name", categoryImbuement->name);
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int ImbuementFunctions::luaImbuementIsPremium(lua_State* L) {
	// imbuement:isPremium()
	const auto* imbuement = Lua::getUserdata<Imbuement>(L, 1);
	if (!imbuement) {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushBoolean(L, imbuement->isPremium());
	return 1;
}

int ImbuementFunctions::luaImbuementGetElementDamage(lua_State* L) {
	// imbuement:getElementDamage()
	const auto* imbuement = Lua::getUserdata<Imbuement>(L, 1);
	if (imbuement) {
		lua_pushnumber(L, imbuement->elementDamage);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ImbuementFunctions::luaImbuementGetCombatType(lua_State* L) {
	// imbuement:getCombatType()
	const auto* imbuement = Lua::getUserdata<Imbuement>(L, 1);
	if (imbuement) {
		lua_pushnumber(L, imbuement->combatType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
