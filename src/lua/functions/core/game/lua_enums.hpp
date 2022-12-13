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

#ifndef SRC_LUA_FUNCTIONS_CORE_GAME_LUA_ENUMS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_GAME_LUA_ENUMS_HPP_

#include "pch.hpp"

#include "creatures/players/account/account.hpp"
#include "declarations.hpp"
#include "lua/scripts/luascript.h"

class LuaEnums final : LuaScriptInterface {
public:
	static void init(lua_State* L);
private:
	static void initOthersEnums(lua_State* L);
	static void initAccountEnums(lua_State* L);
	static void initDailyRewardEnums(lua_State* L);
	static void initBugCategoryEnums(lua_State* L);
	static void initReportTypeEnums(lua_State* L);
	static void initCallbackParamEnums(lua_State* L);
	static void initCombatEnums(lua_State* L);
	static void initCombatParamEnums(lua_State* L);
	static void initCombatFormulaEnums(lua_State* L);
	static void initDirectionEnums(lua_State* L);
	static void initFactionEnums(lua_State* L);
	static void initConditionEnums(lua_State* L);
	static void initConditionIdEnums(lua_State* L);
	static void initConditionParamEnums(lua_State* L);
	static void initConstMeEnums(lua_State* L);
	static void initConstAniEnums(lua_State* L);
	static void initConstPropEnums(lua_State* L);
	static void initConstSlotEnums(lua_State* L);
	static void initCreatureEventEnums(lua_State* L);
	static void initGameStateEnums(lua_State* L);
	static void initMessageEnums(lua_State* L);
	static void initCreatureTypeEnums(lua_State* L);
	static void initClientOsEnums(lua_State* L);
	static void initFightModeEnums(lua_State* L);
	static void initItemAttributeEnums(lua_State* L);
	static void initItemTypeEnums(lua_State* L);
	static void initItemIdEnums(lua_State* L);
	static void initPlayerFlagEnums(lua_State* L);
	static void initReportReasonEnums(lua_State* L);
	static void initSkillEnums(lua_State* L);
	static void initSkullEnums(lua_State* L);
	static void initTalkTypeEnums(lua_State* L);
	static void initBestiaryEnums(lua_State* L);
	static void initTextColorEnums(lua_State* L);
	static void initTileStateEnums(lua_State* L);
	static void initSpeechBubbleEnums(lua_State* L);
	static void initMapMarkEnums(lua_State* L);
	static void initReturnValueEnums(lua_State* L);
	static void initReloadTypeEnums(lua_State* L);
	static void initCreaturesEventEnums(lua_State* L);
	static void initForgeEnums(lua_State* L);
	static void initWebhookEnums(lua_State* L);
	static void initSoundEnums(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CORE_GAME_LUA_ENUMS_HPP_
