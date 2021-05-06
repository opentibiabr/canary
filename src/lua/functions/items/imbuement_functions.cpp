/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include <boost/range/adaptor/reversed.hpp>

#include "items/item.h"
#include "items/weapons/weapons.h"
#include "creatures/players/imbuements/imbuements.h"
#include "lua/functions/items/imbuement_functions.hpp"
#include "lua/scripts/scripts.h"
#include "utils/tools.h"

extern Imbuements* g_imbuements;
extern Scripts* g_scripts;
extern Weapons* g_weapons;

int ImbuementFunctions::luaCreateImbuement(lua_State* L) {
	// Imbuement(id)
	uint32_t imbuementId = getNumber<uint32_t>(L, 2);
	Imbuement* imbuement = g_imbuements->getImbuement(imbuementId);

	if (imbuement) {
		pushUserdata<Imbuement>(L, imbuement);
		setMetatable(L, -1, "Imbuement");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ImbuementFunctions::luaImbuementGetName(lua_State* L) {
	// imbuement:getName()
	Imbuement* imbuement = getUserdata<Imbuement>(L, 1);
	if (imbuement) {
		pushString(L, imbuement->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ImbuementFunctions::luaImbuementGetId(lua_State* L) {
	// imbuement:getId()
	Imbuement* imbuement = getUserdata<Imbuement>(L, 1);
	if (imbuement) {
		lua_pushnumber(L, imbuement->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ImbuementFunctions::luaImbuementGetItems(lua_State* L) {
	// imbuement:getItems()
	Imbuement* imbuement = getUserdata<Imbuement>(L, 1);
	if (!imbuement) {
		lua_pushnil(L);
		return 1;
	}

	const auto& items = imbuement->getItems();

	lua_createtable(L, items.size(), 0);
	for (const auto& itm : items) {
		lua_createtable(L, 0, 2);
		setField(L, "itemid", itm.first);
		setField(L, "count", itm.second);
		lua_rawseti(L, -2, itm.first);
	}

	return 1;
}

int ImbuementFunctions::luaImbuementGetBase(lua_State* L) {
	// imbuement:getBase()
	Imbuement* imbuement = getUserdata<Imbuement>(L, 1);
	if (!imbuement) {
		lua_pushnil(L);
		return 1;
	}
	uint32_t basid = imbuement->getBaseID();
	BaseImbue* base = g_imbuements->getBaseByID(basid);

	if (base) {
		lua_createtable(L, 0, 7);
		setField(L, "id", base->id);
		setField(L, "name", base->name);
		setField(L, "price", base->price);
		setField(L, "protection", base->protection);
		setField(L, "percent", base->percent);
		setField(L, "removecust", base->removecust);
		setField(L, "duration", base->duration);
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int ImbuementFunctions::luaImbuementGetCategory(lua_State* L) {
	// imbuement:getCategory()
	Imbuement* imbuement = getUserdata<Imbuement>(L, 1);
	if (!imbuement) {
		lua_pushnil(L);
		return 1;
	}
	uint32_t catid = imbuement->getCategory();
	Category* category = g_imbuements->getCategoryByID(catid);

	if (category) {
		lua_createtable(L, 0, 2);
		setField(L, "id", category->id);
		setField(L, "name", category->name);
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int ImbuementFunctions::luaImbuementIsPremium(lua_State* L) {
	// imbuement:isPremium()
	Imbuement* imbuement = getUserdata<Imbuement>(L, 1);
	if (!imbuement) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, imbuement->isPremium());
	return 1;
}

int ImbuementFunctions::luaImbuementGetElementDamage(lua_State* L) {
	// imbuement:getElementDamage()
	Imbuement* imbuement = getUserdata<Imbuement>(L, 1);
	if (imbuement) {
		lua_pushnumber(L, imbuement->elementDamage);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ImbuementFunctions::luaImbuementGetCombatType(lua_State* L) {
	// imbuement:getCombatType()
	Imbuement* imbuement = getUserdata<Imbuement>(L, 1);
	if (imbuement) {
		lua_pushnumber(L, imbuement->combatType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
