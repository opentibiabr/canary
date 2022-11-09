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

#include "pch.hpp"

#include "items/cylinder.h"
#include "lua/functions/creatures/combat/variant_functions.hpp"

int VariantFunctions::luaVariantCreate(lua_State* L) {
	// Variant(number or string or position or thing)
	LuaVariant variant;
	if (isUserdata(L, 2)) {
		if (Thing* thing = getThing(L, 2)) {
			variant.type = VARIANT_TARGETPOSITION;
			variant.pos = thing->getPosition();
		}
	} else if (isTable(L, 2)) {
		variant.type = VARIANT_POSITION;
		variant.pos = getPosition(L, 2);
	} else if (isNumber(L, 2)) {
		variant.type = VARIANT_NUMBER;
		variant.number = getNumber<uint32_t>(L, 2);
	} else if (isString(L, 2)) {
		variant.type = VARIANT_STRING;
		variant.text = getString(L, 2);
	}
	pushVariant(L, variant);
	return 1;
}

int VariantFunctions::luaVariantGetNumber(lua_State* L) {
	// Variant:getNumber()
	const LuaVariant& variant = getVariant(L, 1);
	if (variant.type == VARIANT_NUMBER) {
		lua_pushnumber(L, variant.number);
	} else {
		lua_pushnumber(L, 0);
	}
	return 1;
}

int VariantFunctions::luaVariantGetString(lua_State* L) {
	// Variant:getString()
	const LuaVariant& variant = getVariant(L, 1);
	if (variant.type == VARIANT_STRING) {
		pushString(L, variant.text);
	} else {
		pushString(L, std::string());
	}
	return 1;
}

int VariantFunctions::luaVariantGetPosition(lua_State* L) {
	// Variant:getPosition()
	const LuaVariant& variant = getVariant(L, 1);
	if (variant.type == VARIANT_POSITION || variant.type == VARIANT_TARGETPOSITION) {
		pushPosition(L, variant.pos);
	} else {
		pushPosition(L, Position());
	}
	return 1;
}
