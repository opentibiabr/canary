/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/cylinder.hpp"
#include "lua/functions/creatures/combat/variant_functions.hpp"

int VariantFunctions::luaVariantCreate(lua_State* L) {
	// Variant(number or string or position or thing)
	LuaVariant variant;
	if (isUserdata(L, 2)) {
		if (std::shared_ptr<Thing> thing = getThing(L, 2)) {
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
	const LuaVariant &variant = getVariant(L, 1);
	if (variant.type == VARIANT_NUMBER) {
		lua_pushnumber(L, variant.number);
	} else {
		lua_pushnumber(L, 0);
	}
	return 1;
}

int VariantFunctions::luaVariantGetString(lua_State* L) {
	// Variant:getString()
	const LuaVariant &variant = getVariant(L, 1);
	if (variant.type == VARIANT_STRING) {
		pushString(L, variant.text);
	} else {
		pushString(L, std::string());
	}
	return 1;
}

int VariantFunctions::luaVariantGetPosition(lua_State* L) {
	// Variant:getPosition()
	const LuaVariant &variant = getVariant(L, 1);
	if (variant.type == VARIANT_POSITION || variant.type == VARIANT_TARGETPOSITION) {
		pushPosition(L, variant.pos);
	} else {
		pushPosition(L, Position());
	}
	return 1;
}
