/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class LuaEnums {
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
	static void initAttributeConditionSubIdEnums(lua_State* L);
	static void initConcoctionsEnum(lua_State* L);
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
	static void initFluidEnums(lua_State* L);
	static void initItemIdEnums(lua_State* L);
	static void initPlayerFlagEnums(lua_State* L);
	static void initCreatureIconEnums(lua_State* L);
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
	static void initBosstiaryEnums(lua_State* L);
	static void initSoundEnums(lua_State* L);
	static void spelltSoundEnums(lua_State* L);
	static void monsterSoundEnums(lua_State* L);
	static void effectsSoundEnums(lua_State* L);
	static void initWheelEnums(lua_State* L);
	static void initVirtueEnums(lua_State* L);
};
