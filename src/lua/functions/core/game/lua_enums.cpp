/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/game/lua_enums.hpp"

#include "creatures/players/wheel/wheel_definitions.hpp"
#include "enums/account_group_type.hpp"
#include "enums/account_type.hpp"
#include "enums/item_attribute.hpp"
#include "game/functions/game_reload.hpp"
#include "io/io_bosstiary.hpp"
#include "lua/functions/lua_functions_loader.hpp"

constexpr const char* soundNamespace = "SOUND_EFFECT_TYPE_";

#define registerMagicEnum(luaState, enumClassType)               \
	{                                                            \
		auto number = magic_enum::enum_integer(enumClassType);   \
		auto name = magic_enum::enum_name(enumClassType).data(); \
		Lua::registerGlobalVariable(luaState, name, number);     \
	}                                                            \
	void(0)

#define registerMagicEnumNamespace(luaState, luaNamespace, enumClassType)                    \
	{                                                                                        \
		auto number = magic_enum::enum_integer(enumClassType);                               \
		auto name = std::string(luaNamespace) + magic_enum::enum_name(enumClassType).data(); \
		Lua::registerGlobalVariable(luaState, name, number);                                 \
	}                                                                                        \
	void(0)

#define registerEnum(L, value)                                                                  \
	{                                                                                           \
		std::string enumName = #value;                                                          \
		Lua::registerGlobalVariable(L, enumName.substr(enumName.find_last_of(':') + 1), value); \
	}                                                                                           \
	void(0)

/**
* Registers an enumeration value globally in a specified Lua namespace.
* @param L The Lua state.
* @param luaNamespace The Lua namespace where the enumeration will be registered.
* @param enumValue The enumeration value to be registered.
* @note This macro adds the specified enumeration value globally in a Lua namespace.
* The full name of the registered enumeration value will be the Lua namespace name followed by the enumeration name,
with the prefix "luaNamespace" added. For example, if the Lua namespace is "SOUND_EFFECT_TYPE_" and the enumeration value
is "SILENCE", the registered full name will be "SOUND_EFFECT_TYPE_SILENCE".
*/
#define registerEnumNamespace(L, luaNamespace, enumValue)                                                                             \
	{                                                                                                                                 \
		std::string enumName = #enumValue;                                                                                            \
		std::string enumNameWithNamespace = std::string(luaNamespace) + std::string(enumName.substr(enumName.find_last_of(':') + 1)); \
		Lua::registerGlobalVariable(L, enumNameWithNamespace, enumValue);                                                             \
	}                                                                                                                                 \
	void(0)

void LuaEnums::init(lua_State* L) {
	initOthersEnums(L);
	initAccountEnums(L);
	initDailyRewardEnums(L);
	initBugCategoryEnums(L);
	initReportTypeEnums(L);
	initCallbackParamEnums(L);
	initCombatEnums(L);
	initCombatParamEnums(L);
	initCombatFormulaEnums(L);
	initDirectionEnums(L);
	initFactionEnums(L);
	initConditionEnums(L);
	initConditionIdEnums(L);
	initConditionParamEnums(L);
	initConstMeEnums(L);
	initConstAniEnums(L);
	initConstPropEnums(L);
	initConstSlotEnums(L);
	initCreatureEventEnums(L);
	initGameStateEnums(L);
	initMessageEnums(L);
	initCreatureTypeEnums(L);
	initClientOsEnums(L);
	initFightModeEnums(L);
	initItemAttributeEnums(L);
	initItemTypeEnums(L);
	initFluidEnums(L);
	initItemIdEnums(L);
	initPlayerFlagEnums(L);
	initCreatureIconEnums(L);
	initReportReasonEnums(L);
	initSkillEnums(L);
	initSkullEnums(L);
	initTalkTypeEnums(L);
	initBestiaryEnums(L);
	initTextColorEnums(L);
	initTileStateEnums(L);
	initSpeechBubbleEnums(L);
	initMapMarkEnums(L);
	initReturnValueEnums(L);
	initReloadTypeEnums(L);
	initCreaturesEventEnums(L);
	initForgeEnums(L);
	initWebhookEnums(L);
	initBosstiaryEnums(L);
	initSoundEnums(L);
	spelltSoundEnums(L);
	monsterSoundEnums(L);
	effectsSoundEnums(L);
	initWheelEnums(L);
	initAttributeConditionSubIdEnums(L);
	initConcoctionsEnum(L);
}

void LuaEnums::initOthersEnums(lua_State* L) {
	registerEnum(L, WORLD_TYPE_NO_PVP);
	registerEnum(L, WORLD_TYPE_PVP);
	registerEnum(L, WORLD_TYPE_PVP_ENFORCED);
	registerEnum(L, AMMO_NONE);
	registerEnum(L, AMMO_BOLT);
	registerEnum(L, AMMO_ARROW);
	registerEnum(L, AMMO_SPEAR);
	registerEnum(L, AMMO_THROWINGSTAR);
	registerEnum(L, AMMO_THROWINGKNIFE);
	registerEnum(L, AMMO_STONE);
	registerEnum(L, AMMO_SNOWBALL);

	registerEnum(L, CHARM_OFFENSIVE);
	registerEnum(L, CHARM_DEFENSIVE);
	registerEnum(L, CHARM_PASSIVE);
	registerEnum(L, CHARM_GUT);
	registerEnum(L, CHARM_SCAVENGE);

	// Use with container:addItem, container:addItemEx and possibly other functions.
	registerEnum(L, FLAG_NOLIMIT);
	registerEnum(L, FLAG_IGNOREBLOCKITEM);
	registerEnum(L, FLAG_IGNOREBLOCKCREATURE);
	registerEnum(L, FLAG_CHILDISOWNER);
	registerEnum(L, FLAG_PATHFINDING);
	registerEnum(L, FLAG_IGNOREFIELDDAMAGE);
	registerEnum(L, FLAG_IGNORENOTMOVABLE);
	registerEnum(L, FLAG_IGNOREAUTOSTACK);

	// Use with house:getAccessList, house:setAccessList
	registerEnum(L, GUEST_LIST);

	registerEnum(L, LIGHT_STATE_DAY);
	registerEnum(L, LIGHT_STATE_NIGHT);
	registerEnum(L, LIGHT_STATE_SUNSET);
	registerEnum(L, LIGHT_STATE_SUNRISE);
	registerEnum(L, STORAGEVALUE_EMOTE);

	registerEnum(L, IMMOVABLE_ACTION_ID);

	registerEnum(L, MAX_LOOTCHANCE);

	registerEnum(L, ORIGIN_NONE);
	registerEnum(L, ORIGIN_CONDITION);
	registerEnum(L, ORIGIN_SPELL);
	registerEnum(L, ORIGIN_MELEE);
	registerEnum(L, ORIGIN_RANGED);

	registerEnum(L, PLAYERSEX_FEMALE);
	registerEnum(L, PLAYERSEX_MALE);

	registerEnum(L, PLAYERPRONOUN_UNSET);
	registerEnum(L, PLAYERPRONOUN_THEY);
	registerEnum(L, PLAYERPRONOUN_SHE);
	registerEnum(L, PLAYERPRONOUN_HE);
	registerEnum(L, PLAYERPRONOUN_ZE);
	registerEnum(L, PLAYERPRONOUN_NAME);

	registerEnum(L, RESPAWNPERIOD_ALL);
	registerEnum(L, RESPAWNPERIOD_DAY);
	registerEnum(L, RESPAWNPERIOD_NIGHT);

	// Use with itemType:getSlotPosition
	registerEnum(L, SLOTP_WHEREEVER);
	registerEnum(L, SLOTP_HEAD);
	registerEnum(L, SLOTP_NECKLACE);
	registerEnum(L, SLOTP_BACKPACK);
	registerEnum(L, SLOTP_ARMOR);
	registerEnum(L, SLOTP_RIGHT);
	registerEnum(L, SLOTP_LEFT);
	registerEnum(L, SLOTP_LEGS);
	registerEnum(L, SLOTP_FEET);
	registerEnum(L, SLOTP_RING);
	registerEnum(L, SLOTP_AMMO);
	registerEnum(L, SLOTP_DEPOT);
	registerEnum(L, SLOTP_TWO_HAND);

	// Spells
	registerEnum(L, SPELL_INSTANT);
	registerEnum(L, SPELL_RUNE);

	registerEnum(L, SUBOWNER_LIST);

	registerEnum(L, VOCATION_NONE);

	registerEnum(L, ZONE_PROTECTION);
	registerEnum(L, ZONE_NOPVP);
	registerEnum(L, ZONE_PVP);
	registerEnum(L, ZONE_NOLOGOUT);
	registerEnum(L, ZONE_NORMAL);

	registerEnum(L, WEAPON_NONE);
	registerEnum(L, WEAPON_SWORD);
	registerEnum(L, WEAPON_CLUB);
	registerEnum(L, WEAPON_AXE);
	registerEnum(L, WEAPON_SHIELD);
	registerEnum(L, WEAPON_DISTANCE);
	registerEnum(L, WEAPON_WAND);
	registerEnum(L, WEAPON_AMMO);
	registerEnum(L, WEAPON_MISSILE);

	registerEnum(L, SCREENSHOT_TYPE_NONE);
	registerEnum(L, SCREENSHOT_TYPE_ACHIEVEMENT);
	registerEnum(L, SCREENSHOT_TYPE_BESTIARYENTRYCOMPLETED);
	registerEnum(L, SCREENSHOT_TYPE_BESTIARYENTRYUNLOCKED);
	registerEnum(L, SCREENSHOT_TYPE_BOSSDEFEATED);
	registerEnum(L, SCREENSHOT_TYPE_DEATHPVE);
	registerEnum(L, SCREENSHOT_TYPE_DEATHPVP);
	registerEnum(L, SCREENSHOT_TYPE_LEVELUP);
	registerEnum(L, SCREENSHOT_TYPE_PLAYERKILLASSIST);
	registerEnum(L, SCREENSHOT_TYPE_PLAYERKILL);
	registerEnum(L, SCREENSHOT_TYPE_PLAYERATTACKING);
	registerEnum(L, SCREENSHOT_TYPE_TREASUREFOUND);
	registerEnum(L, SCREENSHOT_TYPE_SKILLUP);
	registerEnum(L, SCREENSHOT_TYPE_GIFTOFLIFE);
}

void LuaEnums::initAccountEnums(lua_State* L) {
	registerEnum(L, ACCOUNT_TYPE_NORMAL);
	registerEnum(L, ACCOUNT_TYPE_TUTOR);
	registerEnum(L, ACCOUNT_TYPE_SENIORTUTOR);
	registerEnum(L, ACCOUNT_TYPE_GAMEMASTER);
	registerEnum(L, ACCOUNT_TYPE_GOD);

	registerEnum(L, GROUP_TYPE_NORMAL);
	registerEnum(L, GROUP_TYPE_TUTOR);
	registerEnum(L, GROUP_TYPE_SENIORTUTOR);
	registerEnum(L, GROUP_TYPE_GAMEMASTER);
	registerEnum(L, GROUP_TYPE_COMMUNITYMANAGER);
	registerEnum(L, GROUP_TYPE_GOD);
}

void LuaEnums::initDailyRewardEnums(lua_State* L) {
	registerEnum(L, DAILY_REWARD_COLLECTED);
	registerEnum(L, DAILY_REWARD_NOTCOLLECTED);
	registerEnum(L, DAILY_REWARD_NOTAVAILABLE);
}

void LuaEnums::initBugCategoryEnums(lua_State* L) {
	registerEnum(L, BUG_CATEGORY_MAP);
	registerEnum(L, BUG_CATEGORY_TYPO);
	registerEnum(L, BUG_CATEGORY_TECHNICAL);
	registerEnum(L, BUG_CATEGORY_OTHER);
}

void LuaEnums::initReportTypeEnums(lua_State* L) {
	registerEnum(L, REPORT_TYPE_NAME);
	registerEnum(L, REPORT_TYPE_STATEMENT);
	registerEnum(L, REPORT_TYPE_BOT);
}

void LuaEnums::initCallbackParamEnums(lua_State* L) {
	registerEnum(L, CALLBACK_PARAM_LEVELMAGICVALUE);
	registerEnum(L, CALLBACK_PARAM_SKILLVALUE);
	registerEnum(L, CALLBACK_PARAM_TARGETTILE);
	registerEnum(L, CALLBACK_PARAM_TARGETCREATURE);
	registerEnum(L, CALLBACK_PARAM_CHAINVALUE);
	registerEnum(L, CALLBACK_PARAM_CHAINPICKER);
}

void LuaEnums::initCombatEnums(lua_State* L) {
	registerEnum(L, COMBAT_NONE);
	registerEnum(L, COMBAT_PHYSICALDAMAGE);
	registerEnum(L, COMBAT_ENERGYDAMAGE);
	registerEnum(L, COMBAT_EARTHDAMAGE);
	registerEnum(L, COMBAT_FIREDAMAGE);
	registerEnum(L, COMBAT_UNDEFINEDDAMAGE);
	registerEnum(L, COMBAT_LIFEDRAIN);
	registerEnum(L, COMBAT_MANADRAIN);
	registerEnum(L, COMBAT_HEALING);
	registerEnum(L, COMBAT_DROWNDAMAGE);
	registerEnum(L, COMBAT_ICEDAMAGE);
	registerEnum(L, COMBAT_HOLYDAMAGE);
	registerEnum(L, COMBAT_DEATHDAMAGE);
	registerEnum(L, COMBAT_AGONYDAMAGE);
	registerEnum(L, COMBAT_NEUTRALDAMAGE);
}

void LuaEnums::initCombatParamEnums(lua_State* L) {
	for (auto value : magic_enum::enum_values<CombatParam_t>()) {
		registerMagicEnum(L, value);
	}
}

void LuaEnums::initCombatFormulaEnums(lua_State* L) {
	registerEnum(L, COMBAT_FORMULA_UNDEFINED);
	registerEnum(L, COMBAT_FORMULA_LEVELMAGIC);
	registerEnum(L, COMBAT_FORMULA_SKILL);
	registerEnum(L, COMBAT_FORMULA_DAMAGE);
}

void LuaEnums::initDirectionEnums(lua_State* L) {
	registerEnum(L, DIRECTION_NORTH);
	registerEnum(L, DIRECTION_EAST);
	registerEnum(L, DIRECTION_SOUTH);
	registerEnum(L, DIRECTION_WEST);
	registerEnum(L, DIRECTION_SOUTHWEST);
	registerEnum(L, DIRECTION_SOUTHEAST);
	registerEnum(L, DIRECTION_NORTHWEST);
	registerEnum(L, DIRECTION_NORTHEAST);
}

void LuaEnums::initFactionEnums(lua_State* L) {
	registerEnum(L, FACTION_DEFAULT);
	registerEnum(L, FACTION_PLAYER);
	registerEnum(L, FACTION_LION);
	registerEnum(L, FACTION_LIONUSURPERS);
	registerEnum(L, FACTION_MARID);
	registerEnum(L, FACTION_EFREET);
	registerEnum(L, FACTION_DEEPLING);
	registerEnum(L, FACTION_DEATHLING);
	registerEnum(L, FACTION_ANUMA);
	registerEnum(L, FACTION_FAFNAR);
	registerEnum(L, FACTION_LAST);
}

void LuaEnums::initConditionEnums(lua_State* L) {
	for (const auto value : magic_enum::enum_values<ConditionType_t>()) {
		registerMagicEnum(L, value);
	}
}

void LuaEnums::initConditionIdEnums(lua_State* L) {
	registerEnum(L, CONDITIONID_DEFAULT);
	registerEnum(L, CONDITIONID_COMBAT);
	registerEnum(L, CONDITIONID_HEAD);
	registerEnum(L, CONDITIONID_NECKLACE);
	registerEnum(L, CONDITIONID_BACKPACK);
	registerEnum(L, CONDITIONID_ARMOR);
	registerEnum(L, CONDITIONID_RIGHT);
	registerEnum(L, CONDITIONID_LEFT);
	registerEnum(L, CONDITIONID_LEGS);
	registerEnum(L, CONDITIONID_FEET);
	registerEnum(L, CONDITIONID_RING);
	registerEnum(L, CONDITIONID_AMMO);
}

void LuaEnums::initConditionParamEnums(lua_State* L) {
	registerEnum(L, CONDITION_PARAM_OWNER);
	registerEnum(L, CONDITION_PARAM_TICKS);
	registerEnum(L, CONDITION_PARAM_HEALTHGAIN);
	registerEnum(L, CONDITION_PARAM_HEALTHTICKS);
	registerEnum(L, CONDITION_PARAM_MANAGAIN);
	registerEnum(L, CONDITION_PARAM_MANATICKS);
	registerEnum(L, CONDITION_PARAM_DELAYED);
	registerEnum(L, CONDITION_PARAM_SPEED);
	registerEnum(L, CONDITION_PARAM_LIGHT_LEVEL);
	registerEnum(L, CONDITION_PARAM_LIGHT_COLOR);
	registerEnum(L, CONDITION_PARAM_SOULGAIN);
	registerEnum(L, CONDITION_PARAM_SOULTICKS);
	registerEnum(L, CONDITION_PARAM_MINVALUE);
	registerEnum(L, CONDITION_PARAM_MAXVALUE);
	registerEnum(L, CONDITION_PARAM_STARTVALUE);
	registerEnum(L, CONDITION_PARAM_TICKINTERVAL);
	registerEnum(L, CONDITION_PARAM_FORCEUPDATE);
	registerEnum(L, CONDITION_PARAM_SKILL_MELEE);
	registerEnum(L, CONDITION_PARAM_SKILL_FIST);
	registerEnum(L, CONDITION_PARAM_SKILL_CLUB);
	registerEnum(L, CONDITION_PARAM_SKILL_SWORD);
	registerEnum(L, CONDITION_PARAM_SKILL_AXE);
	registerEnum(L, CONDITION_PARAM_SKILL_DISTANCE);
	registerEnum(L, CONDITION_PARAM_SKILL_SHIELD);
	registerEnum(L, CONDITION_PARAM_SKILL_FISHING);
	registerEnum(L, CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE);
	registerEnum(L, CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE);
	registerEnum(L, CONDITION_PARAM_SKILL_LIFE_LEECH_CHANCE);
	registerEnum(L, CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT);
	registerEnum(L, CONDITION_PARAM_SKILL_MANA_LEECH_CHANCE);
	registerEnum(L, CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT);
	registerEnum(L, CONDITION_PARAM_STAT_MAXHITPOINTS);
	registerEnum(L, CONDITION_PARAM_STAT_MAXMANAPOINTS);
	registerEnum(L, CONDITION_PARAM_STAT_MAGICPOINTS);
	registerEnum(L, CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT);
	registerEnum(L, CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT);
	registerEnum(L, CONDITION_PARAM_STAT_MAGICPOINTSPERCENT);
	registerEnum(L, CONDITION_PARAM_PERIODICDAMAGE);
	registerEnum(L, CONDITION_PARAM_SKILL_MELEEPERCENT);
	registerEnum(L, CONDITION_PARAM_SKILL_FISTPERCENT);
	registerEnum(L, CONDITION_PARAM_SKILL_CLUBPERCENT);
	registerEnum(L, CONDITION_PARAM_SKILL_SWORDPERCENT);
	registerEnum(L, CONDITION_PARAM_SKILL_AXEPERCENT);
	registerEnum(L, CONDITION_PARAM_SKILL_DISTANCEPERCENT);
	registerEnum(L, CONDITION_PARAM_SKILL_SHIELDPERCENT);
	registerEnum(L, CONDITION_PARAM_SKILL_FISHINGPERCENT);
	registerEnum(L, CONDITION_PARAM_BUFF_SPELL);
	registerEnum(L, CONDITION_PARAM_SUBID);
	registerEnum(L, CONDITION_PARAM_FIELD);
	registerEnum(L, CONDITION_PARAM_DISABLE_DEFENSE);
	registerEnum(L, CONDITION_PARAM_MANASHIELD);
	registerEnum(L, CONDITION_PARAM_BUFF_DAMAGEDEALT);
	registerEnum(L, CONDITION_PARAM_BUFF_DAMAGERECEIVED);
	registerEnum(L, CONDITION_PARAM_DRAIN_BODY);
	registerEnum(L, CONDITION_PARAM_ABSORB_PHYSICALPERCENT);
	registerEnum(L, CONDITION_PARAM_ABSORB_FIREPERCENT);
	registerEnum(L, CONDITION_PARAM_ABSORB_ENERGYPERCENT);
	registerEnum(L, CONDITION_PARAM_ABSORB_ICEPERCENT);
	registerEnum(L, CONDITION_PARAM_ABSORB_EARTHPERCENT);
	registerEnum(L, CONDITION_PARAM_ABSORB_DEATHPERCENT);
	registerEnum(L, CONDITION_PARAM_ABSORB_HOLYPERCENT);
	registerEnum(L, CONDITION_PARAM_ABSORB_LIFEDRAINPERCENT);
	registerEnum(L, CONDITION_PARAM_ABSORB_MANADRAINPERCENT);
	registerEnum(L, CONDITION_PARAM_ABSORB_DROWNPERCENT);
	registerEnum(L, CONDITION_PARAM_INCREASE_PHYSICALPERCENT);
	registerEnum(L, CONDITION_PARAM_INCREASE_FIREPERCENT);
	registerEnum(L, CONDITION_PARAM_INCREASE_ENERGYPERCENT);
	registerEnum(L, CONDITION_PARAM_INCREASE_ICEPERCENT);
	registerEnum(L, CONDITION_PARAM_INCREASE_EARTHPERCENT);
	registerEnum(L, CONDITION_PARAM_INCREASE_DEATHPERCENT);
	registerEnum(L, CONDITION_PARAM_INCREASE_HOLYPERCENT);
	registerEnum(L, CONDITION_PARAM_INCREASE_LIFEDRAINPERCENT);
	registerEnum(L, CONDITION_PARAM_INCREASE_MANADRAINPERCENT);
	registerEnum(L, CONDITION_PARAM_INCREASE_DROWNPERCENT);
	registerEnum(L, CONDITION_PARAM_CHARM_CHANCE_MODIFIER);
}

void LuaEnums::initAttributeConditionSubIdEnums(lua_State* L) {
	std::string luaNamespace = "AttrSubId_";
	for (auto value : magic_enum::enum_values<AttrSubId_t>()) {
		registerMagicEnumNamespace(L, luaNamespace, value);
	}
}

void LuaEnums::initConcoctionsEnum(lua_State* L) {
	std::string luaNamespace = "Concoction_";
	registerEnumNamespace(L, luaNamespace, Concoction_t::KooldownAid);
	registerEnumNamespace(L, luaNamespace, Concoction_t::StaminaExtension);
	registerEnumNamespace(L, luaNamespace, Concoction_t::StrikeEnhancement);
	registerEnumNamespace(L, luaNamespace, Concoction_t::CharmUpgrade);
	registerEnumNamespace(L, luaNamespace, Concoction_t::WealthDuplex);
	registerEnumNamespace(L, luaNamespace, Concoction_t::BestiaryBetterment);
	registerEnumNamespace(L, luaNamespace, Concoction_t::FireResilience);
	registerEnumNamespace(L, luaNamespace, Concoction_t::IceResilience);
	registerEnumNamespace(L, luaNamespace, Concoction_t::EarthResilience);
	registerEnumNamespace(L, luaNamespace, Concoction_t::EnergyResilience);
	registerEnumNamespace(L, luaNamespace, Concoction_t::HolyResilience);
	registerEnumNamespace(L, luaNamespace, Concoction_t::DeathResilience);
	registerEnumNamespace(L, luaNamespace, Concoction_t::PhysicalResilience);
	registerEnumNamespace(L, luaNamespace, Concoction_t::FireAmplification);
	registerEnumNamespace(L, luaNamespace, Concoction_t::IceAmplification);
	registerEnumNamespace(L, luaNamespace, Concoction_t::EarthAmplification);
	registerEnumNamespace(L, luaNamespace, Concoction_t::EnergyAmplification);
	registerEnumNamespace(L, luaNamespace, Concoction_t::HolyAmplification);
	registerEnumNamespace(L, luaNamespace, Concoction_t::DeathAmplification);
	registerEnumNamespace(L, luaNamespace, Concoction_t::PhysicalAmplification);
}

void LuaEnums::initConstMeEnums(lua_State* L) {
	registerEnum(L, CONST_ME_NONE);
	registerEnum(L, CONST_ME_DRAWBLOOD);
	registerEnum(L, CONST_ME_LOSEENERGY);
	registerEnum(L, CONST_ME_POFF);
	registerEnum(L, CONST_ME_BLOCKHIT);
	registerEnum(L, CONST_ME_EXPLOSIONAREA);
	registerEnum(L, CONST_ME_EXPLOSIONHIT);
	registerEnum(L, CONST_ME_FIREAREA);
	registerEnum(L, CONST_ME_YELLOW_RINGS);
	registerEnum(L, CONST_ME_GREEN_RINGS);
	registerEnum(L, CONST_ME_HITAREA);
	registerEnum(L, CONST_ME_TELEPORT);
	registerEnum(L, CONST_ME_ENERGYHIT);
	registerEnum(L, CONST_ME_MAGIC_BLUE);
	registerEnum(L, CONST_ME_MAGIC_RED);
	registerEnum(L, CONST_ME_MAGIC_GREEN);
	registerEnum(L, CONST_ME_HITBYFIRE);
	registerEnum(L, CONST_ME_HITBYPOISON);
	registerEnum(L, CONST_ME_MORTAREA);
	registerEnum(L, CONST_ME_SOUND_GREEN);
	registerEnum(L, CONST_ME_SOUND_RED);
	registerEnum(L, CONST_ME_POISONAREA);
	registerEnum(L, CONST_ME_SOUND_YELLOW);
	registerEnum(L, CONST_ME_SOUND_PURPLE);
	registerEnum(L, CONST_ME_SOUND_BLUE);
	registerEnum(L, CONST_ME_SOUND_WHITE);
	registerEnum(L, CONST_ME_BUBBLES);
	registerEnum(L, CONST_ME_CRAPS);
	registerEnum(L, CONST_ME_GIFT_WRAPS);
	registerEnum(L, CONST_ME_FIREWORK_YELLOW);
	registerEnum(L, CONST_ME_FIREWORK_RED);
	registerEnum(L, CONST_ME_FIREWORK_BLUE);
	registerEnum(L, CONST_ME_STUN);
	registerEnum(L, CONST_ME_SLEEP);
	registerEnum(L, CONST_ME_WATERCREATURE);
	registerEnum(L, CONST_ME_GROUNDSHAKER);
	registerEnum(L, CONST_ME_HEARTS);
	registerEnum(L, CONST_ME_FIREATTACK);
	registerEnum(L, CONST_ME_ENERGYAREA);
	registerEnum(L, CONST_ME_SMALLCLOUDS);
	registerEnum(L, CONST_ME_HOLYDAMAGE);
	registerEnum(L, CONST_ME_BIGCLOUDS);
	registerEnum(L, CONST_ME_ICEAREA);
	registerEnum(L, CONST_ME_ICETORNADO);
	registerEnum(L, CONST_ME_ICEATTACK);
	registerEnum(L, CONST_ME_STONES);
	registerEnum(L, CONST_ME_SMALLPLANTS);
	registerEnum(L, CONST_ME_CARNIPHILA);
	registerEnum(L, CONST_ME_PURPLEENERGY);
	registerEnum(L, CONST_ME_YELLOWENERGY);
	registerEnum(L, CONST_ME_HOLYAREA);
	registerEnum(L, CONST_ME_BIGPLANTS);
	registerEnum(L, CONST_ME_CAKE);
	registerEnum(L, CONST_ME_GIANTICE);
	registerEnum(L, CONST_ME_WATERSPLASH);
	registerEnum(L, CONST_ME_PLANTATTACK);
	registerEnum(L, CONST_ME_TUTORIALARROW);
	registerEnum(L, CONST_ME_TUTORIALSQUARE);
	registerEnum(L, CONST_ME_MIRRORHORIZONTAL);
	registerEnum(L, CONST_ME_MIRRORVERTICAL);
	registerEnum(L, CONST_ME_SKULLHORIZONTAL);
	registerEnum(L, CONST_ME_SKULLVERTICAL);
	registerEnum(L, CONST_ME_ASSASSIN);
	registerEnum(L, CONST_ME_STEPSHORIZONTAL);
	registerEnum(L, CONST_ME_BLOODYSTEPS);
	registerEnum(L, CONST_ME_STEPSVERTICAL);
	registerEnum(L, CONST_ME_YALAHARIGHOST);
	registerEnum(L, CONST_ME_BATS);
	registerEnum(L, CONST_ME_SMOKE);
	registerEnum(L, CONST_ME_INSECTS);
	registerEnum(L, CONST_ME_DRAGONHEAD);
	registerEnum(L, CONST_ME_ORCSHAMAN);
	registerEnum(L, CONST_ME_ORCSHAMAN_FIRE);
	registerEnum(L, CONST_ME_THUNDER);
	registerEnum(L, CONST_ME_FERUMBRAS);
	registerEnum(L, CONST_ME_CONFETTI_HORIZONTAL);
	registerEnum(L, CONST_ME_CONFETTI_VERTICAL);
	registerEnum(L, CONST_ME_BLACKSMOKE);
	registerEnum(L, CONST_ME_REDSMOKE);
	registerEnum(L, CONST_ME_YELLOWSMOKE);
	registerEnum(L, CONST_ME_GREENSMOKE);
	registerEnum(L, CONST_ME_PURPLESMOKE);
	registerEnum(L, CONST_ME_EARLY_THUNDER);
	registerEnum(L, CONST_ME_RAGIAZ_BONECAPSULE);
	registerEnum(L, CONST_ME_CRITICAL_DAMAGE);
	registerEnum(L, CONST_ME_PLUNGING_FISH);
	registerEnum(L, CONST_ME_BLUE_ENERGY_SPARK);
	registerEnum(L, CONST_ME_ORANGE_ENERGY_SPARK);
	registerEnum(L, CONST_ME_GREEN_ENERGY_SPARK);
	registerEnum(L, CONST_ME_PINK_ENERGY_SPARK);
	registerEnum(L, CONST_ME_WHITE_ENERGY_SPARK);
	registerEnum(L, CONST_ME_YELLOW_ENERGY_SPARK);
	registerEnum(L, CONST_ME_MAGIC_POWDER);
	registerEnum(L, CONST_ME_PIXIE_EXPLOSION);
	registerEnum(L, CONST_ME_PIXIE_COMING);
	registerEnum(L, CONST_ME_PIXIE_GOING);
	registerEnum(L, CONST_ME_STORM);
	registerEnum(L, CONST_ME_STONE_STORM);
	registerEnum(L, CONST_ME_BLUE_GHOST);
	registerEnum(L, CONST_ME_PINK_VORTEX);
	registerEnum(L, CONST_ME_TREASURE_MAP);
	registerEnum(L, CONST_ME_PINK_BEAM);
	registerEnum(L, CONST_ME_GREEN_FIREWORKS);
	registerEnum(L, CONST_ME_ORANGE_FIREWORKS);
	registerEnum(L, CONST_ME_PINK_FIREWORKS);
	registerEnum(L, CONST_ME_BLUE_FIREWORKS);
	registerEnum(L, CONST_ME_SUPREME_CUBE);
	registerEnum(L, CONST_ME_BLACK_BLOOD);
	registerEnum(L, CONST_ME_PRISMATIC_SPARK);
	registerEnum(L, CONST_ME_THAIAN);
	registerEnum(L, CONST_ME_THAIAN_GHOST);
	registerEnum(L, CONST_ME_GHOST_SMOKE);
	registerEnum(L, CONST_ME_WATER_BLOCK_FLOATING);
	registerEnum(L, CONST_ME_WATER_BLOCK);
	registerEnum(L, CONST_ME_ROOTS);
	registerEnum(L, CONST_ME_GHOSTLY_SCRATCH);
	registerEnum(L, CONST_ME_GHOSTLY_BITE);
	registerEnum(L, CONST_ME_BIG_SCRATCH);
	registerEnum(L, CONST_ME_SLASH);
	registerEnum(L, CONST_ME_BITE);
	registerEnum(L, CONST_ME_CHIVALRIOUS_CHALLENGE);
	registerEnum(L, CONST_ME_DIVINE_DAZZLE);
	registerEnum(L, CONST_ME_ELECTRICALSPARK);
	registerEnum(L, CONST_ME_PURPLETELEPORT);
	registerEnum(L, CONST_ME_REDTELEPORT);
	registerEnum(L, CONST_ME_ORANGETELEPORT);
	registerEnum(L, CONST_ME_GREYTELEPORT);
	registerEnum(L, CONST_ME_LIGHTBLUETELEPORT);
	registerEnum(L, CONST_ME_FATAL);
	registerEnum(L, CONST_ME_DODGE);
	registerEnum(L, CONST_ME_HOURGLASS);
	registerEnum(L, CONST_ME_DAZZLING);
	registerEnum(L, CONST_ME_SPARKLING);
	registerEnum(L, CONST_ME_FERUMBRAS_1);
	registerEnum(L, CONST_ME_GAZHARAGOTH);
	registerEnum(L, CONST_ME_MAD_MAGE);
	registerEnum(L, CONST_ME_HORESTIS);
	registerEnum(L, CONST_ME_DEVOVORGA);
	registerEnum(L, CONST_ME_FERUMBRAS_2);
	registerEnum(L, CONST_ME_WHITE_SMOKE);
	registerEnum(L, CONST_ME_WHITE_SMOKES);
	registerEnum(L, CONST_ME_WATER_DROP);
	registerEnum(L, CONST_ME_AVATAR_APPEAR);
	registerEnum(L, CONST_ME_DIVINE_GRENADE);
	registerEnum(L, CONST_ME_DIVINE_EMPOWERMENT);
	registerEnum(L, CONST_ME_WATER_FLOATING_THRASH);
	registerEnum(L, CONST_ME_AGONY);
}

void LuaEnums::initConstAniEnums(lua_State* L) {
	registerEnum(L, CONST_ANI_NONE);
	registerEnum(L, CONST_ANI_SPEAR);
	registerEnum(L, CONST_ANI_BOLT);
	registerEnum(L, CONST_ANI_ARROW);
	registerEnum(L, CONST_ANI_FIRE);
	registerEnum(L, CONST_ANI_ENERGY);
	registerEnum(L, CONST_ANI_POISONARROW);
	registerEnum(L, CONST_ANI_BURSTARROW);
	registerEnum(L, CONST_ANI_THROWINGSTAR);
	registerEnum(L, CONST_ANI_THROWINGKNIFE);
	registerEnum(L, CONST_ANI_SMALLSTONE);
	registerEnum(L, CONST_ANI_DEATH);
	registerEnum(L, CONST_ANI_LARGEROCK);
	registerEnum(L, CONST_ANI_SNOWBALL);
	registerEnum(L, CONST_ANI_POWERBOLT);
	registerEnum(L, CONST_ANI_POISON);
	registerEnum(L, CONST_ANI_INFERNALBOLT);
	registerEnum(L, CONST_ANI_HUNTINGSPEAR);
	registerEnum(L, CONST_ANI_ENCHANTEDSPEAR);
	registerEnum(L, CONST_ANI_REDSTAR);
	registerEnum(L, CONST_ANI_GREENSTAR);
	registerEnum(L, CONST_ANI_ROYALSPEAR);
	registerEnum(L, CONST_ANI_SNIPERARROW);
	registerEnum(L, CONST_ANI_ONYXARROW);
	registerEnum(L, CONST_ANI_PIERCINGBOLT);
	registerEnum(L, CONST_ANI_WHIRLWINDSWORD);
	registerEnum(L, CONST_ANI_WHIRLWINDAXE);
	registerEnum(L, CONST_ANI_WHIRLWINDCLUB);
	registerEnum(L, CONST_ANI_ETHEREALSPEAR);
	registerEnum(L, CONST_ANI_ICE);
	registerEnum(L, CONST_ANI_EARTH);
	registerEnum(L, CONST_ANI_HOLY);
	registerEnum(L, CONST_ANI_SUDDENDEATH);
	registerEnum(L, CONST_ANI_FLASHARROW);
	registerEnum(L, CONST_ANI_FLAMMINGARROW);
	registerEnum(L, CONST_ANI_SHIVERARROW);
	registerEnum(L, CONST_ANI_ENERGYBALL);
	registerEnum(L, CONST_ANI_SMALLICE);
	registerEnum(L, CONST_ANI_SMALLHOLY);
	registerEnum(L, CONST_ANI_SMALLEARTH);
	registerEnum(L, CONST_ANI_EARTHARROW);
	registerEnum(L, CONST_ANI_EXPLOSION);
	registerEnum(L, CONST_ANI_CAKE);
	registerEnum(L, CONST_ANI_TARSALARROW);
	registerEnum(L, CONST_ANI_VORTEXBOLT);
	registerEnum(L, CONST_ANI_PRISMATICBOLT);
	registerEnum(L, CONST_ANI_CRYSTALLINEARROW);
	registerEnum(L, CONST_ANI_DRILLBOLT);
	registerEnum(L, CONST_ANI_ENVENOMEDARROW);
	registerEnum(L, CONST_ANI_GLOOTHSPEAR);
	registerEnum(L, CONST_ANI_SIMPLEARROW);
	registerEnum(L, CONST_ANI_LEAFSTAR);
	registerEnum(L, CONST_ANI_DIAMONDARROW);
	registerEnum(L, CONST_ANI_SPECTRALBOLT);
	registerEnum(L, CONST_ANI_ROYALSTAR);
	registerEnum(L, CONST_ANI_WEAPONTYPE);
}

void LuaEnums::initConstPropEnums(lua_State* L) {
	registerEnum(L, CONST_PROP_BLOCKSOLID);
	registerEnum(L, CONST_PROP_HASHEIGHT);
	registerEnum(L, CONST_PROP_BLOCKPROJECTILE);
	registerEnum(L, CONST_PROP_BLOCKPATH);
	registerEnum(L, CONST_PROP_ISVERTICAL);
	registerEnum(L, CONST_PROP_ISHORIZONTAL);
	registerEnum(L, CONST_PROP_MOVABLE);
	registerEnum(L, CONST_PROP_IMMOVABLEBLOCKSOLID);
	registerEnum(L, CONST_PROP_IMMOVABLEBLOCKPATH);
	registerEnum(L, CONST_PROP_IMMOVABLENOFIELDBLOCKPATH);
	registerEnum(L, CONST_PROP_NOFIELDBLOCKPATH);
	registerEnum(L, CONST_PROP_SUPPORTHANGABLE);
}

void LuaEnums::initConstSlotEnums(lua_State* L) {
	registerEnum(L, CONST_SLOT_FIRST);
	registerEnum(L, CONST_SLOT_HEAD);
	registerEnum(L, CONST_SLOT_NECKLACE);
	registerEnum(L, CONST_SLOT_BACKPACK);
	registerEnum(L, CONST_SLOT_ARMOR);
	registerEnum(L, CONST_SLOT_RIGHT);
	registerEnum(L, CONST_SLOT_LEFT);
	registerEnum(L, CONST_SLOT_LEGS);
	registerEnum(L, CONST_SLOT_FEET);
	registerEnum(L, CONST_SLOT_RING);
	registerEnum(L, CONST_SLOT_AMMO);
	registerEnum(L, CONST_SLOT_STORE_INBOX);
	registerEnum(L, CONST_SLOT_LAST);
}

void LuaEnums::initCreatureEventEnums(lua_State* L) {
	registerEnum(L, CREATURE_EVENT_NONE);
	registerEnum(L, CREATURE_EVENT_LOGIN);
	registerEnum(L, CREATURE_EVENT_LOGOUT);
	registerEnum(L, CREATURE_EVENT_THINK);
	registerEnum(L, CREATURE_EVENT_PREPAREDEATH);
	registerEnum(L, CREATURE_EVENT_DEATH);
	registerEnum(L, CREATURE_EVENT_KILL);
	registerEnum(L, CREATURE_EVENT_ADVANCE);
	registerEnum(L, CREATURE_EVENT_MODALWINDOW);
	registerEnum(L, CREATURE_EVENT_TEXTEDIT);
	registerEnum(L, CREATURE_EVENT_HEALTHCHANGE);
	registerEnum(L, CREATURE_EVENT_MANACHANGE);
	registerEnum(L, CREATURE_EVENT_EXTENDED_OPCODE);
}

void LuaEnums::initGameStateEnums(lua_State* L) {
	registerEnum(L, GAME_STATE_STARTUP);
	registerEnum(L, GAME_STATE_INIT);
	registerEnum(L, GAME_STATE_NORMAL);
	registerEnum(L, GAME_STATE_CLOSED);
	registerEnum(L, GAME_STATE_SHUTDOWN);
	registerEnum(L, GAME_STATE_CLOSING);
	registerEnum(L, GAME_STATE_MAINTAIN);
}

void LuaEnums::initMessageEnums(lua_State* L) {
	registerEnum(L, MESSAGE_GAMEMASTER_CONSOLE);
	registerEnum(L, MESSAGE_LOGIN);
	registerEnum(L, MESSAGE_ADMINISTRATOR);
	registerEnum(L, MESSAGE_EVENT_ADVANCE);
	registerEnum(L, MESSAGE_GAME_HIGHLIGHT);
	registerEnum(L, MESSAGE_FAILURE);
	registerEnum(L, MESSAGE_LOOK);
	registerEnum(L, MESSAGE_DAMAGE_DEALT);
	registerEnum(L, MESSAGE_DAMAGE_RECEIVED);
	registerEnum(L, MESSAGE_HEALED);
	registerEnum(L, MESSAGE_EXPERIENCE);
	registerEnum(L, MESSAGE_DAMAGE_OTHERS);
	registerEnum(L, MESSAGE_HEALED_OTHERS);
	registerEnum(L, MESSAGE_EXPERIENCE_OTHERS);
	registerEnum(L, MESSAGE_STATUS);
	registerEnum(L, MESSAGE_LOOT);
	registerEnum(L, MESSAGE_TRADE);
	registerEnum(L, MESSAGE_GUILD);
	registerEnum(L, MESSAGE_PARTY_MANAGEMENT);
	registerEnum(L, MESSAGE_PARTY);
	registerEnum(L, MESSAGE_REPORT);
	registerEnum(L, MESSAGE_HOTKEY_PRESSED);
	registerEnum(L, MESSAGE_TUTORIAL_HINT);
	registerEnum(L, MESSAGE_THANK_YOU);
	registerEnum(L, MESSAGE_MARKET);
	registerEnum(L, MESSAGE_MANA);
	registerEnum(L, MESSAGE_BEYOND_LAST);
	registerEnum(L, MESSAGE_ATTENTION);
	registerEnum(L, MESSAGE_BOOSTED_CREATURE);
	registerEnum(L, MESSAGE_OFFLINE_TRAINING);
	registerEnum(L, MESSAGE_TRANSACTION);
	registerEnum(L, MESSAGE_POTION);
}

void LuaEnums::initCreatureTypeEnums(lua_State* L) {
	registerEnum(L, CREATURETYPE_PLAYER);
	registerEnum(L, CREATURETYPE_MONSTER);
	registerEnum(L, CREATURETYPE_NPC);
	registerEnum(L, CREATURETYPE_SUMMON_PLAYER);
	registerEnum(L, CREATURETYPE_SUMMON_OTHERS);
	registerEnum(L, CREATURETYPE_HIDDEN);
}

void LuaEnums::initClientOsEnums(lua_State* L) {
	registerEnum(L, CLIENTOS_NONE);
	registerEnum(L, CLIENTOS_LINUX);
	registerEnum(L, CLIENTOS_WINDOWS);
	registerEnum(L, CLIENTOS_FLASH);
	registerEnum(L, CLIENTOS_NEW_LINUX);
	registerEnum(L, CLIENTOS_NEW_WINDOWS);
	registerEnum(L, CLIENTOS_NEW_MAC);
	registerEnum(L, CLIENTOS_OTCLIENT_LINUX);
	registerEnum(L, CLIENTOS_OTCLIENT_WINDOWS);
	registerEnum(L, CLIENTOS_OTCLIENT_MAC);
	registerEnum(L, CLIENTOS_OTCLIENTV8_LINUX);
	registerEnum(L, CLIENTOS_OTCLIENTV8_WINDOWS);
	registerEnum(L, CLIENTOS_OTCLIENTV8_MAC);
	registerEnum(L, CLIENTOS_OTCLIENTV8_ANDROID);
	registerEnum(L, CLIENTOS_OTCLIENTV8_IOS);
	registerEnum(L, CLIENTOS_OTCLIENTV8_WEB);
}

void LuaEnums::initFightModeEnums(lua_State* L) {
	registerEnum(L, FIGHTMODE_ATTACK);
	registerEnum(L, FIGHTMODE_BALANCED);
	registerEnum(L, FIGHTMODE_DEFENSE);
}

void LuaEnums::initItemAttributeEnums(lua_State* L) {
	for (auto value : magic_enum::enum_values<ItemAttribute_t>()) {
		auto number = magic_enum::enum_integer(value);
		// Creation of the "ITEM_ATTRIBUTE_" namespace for lua scripts
		std::string enumName = "ITEM_ATTRIBUTE_" + std::string(magic_enum::enum_name(value));
		Lua::registerGlobalVariable(L, enumName, static_cast<lua_Number>(number));
	}
}

void LuaEnums::initItemTypeEnums(lua_State* L) {
	registerEnum(L, ITEM_TYPE_DEPOT);
	registerEnum(L, ITEM_TYPE_REWARDCHEST);
	registerEnum(L, ITEM_TYPE_MAILBOX);
	registerEnum(L, ITEM_TYPE_TRASHHOLDER);
	registerEnum(L, ITEM_TYPE_DOOR);
	registerEnum(L, ITEM_TYPE_MAGICFIELD);
	registerEnum(L, ITEM_TYPE_TELEPORT);
	registerEnum(L, ITEM_TYPE_BED);
	registerEnum(L, ITEM_TYPE_KEY);
	registerEnum(L, ITEM_TYPE_SUPPLY);

	// Quickloot
	registerEnum(L, ITEM_TYPE_ARMOR);
	registerEnum(L, ITEM_TYPE_AMULET);
	registerEnum(L, ITEM_TYPE_BOOTS);
	registerEnum(L, ITEM_TYPE_DECORATION);
	registerEnum(L, ITEM_TYPE_CONTAINER);
	registerEnum(L, ITEM_TYPE_FOOD);
	registerEnum(L, ITEM_TYPE_HELMET);
	registerEnum(L, ITEM_TYPE_LEGS);
	registerEnum(L, ITEM_TYPE_OTHER);
	registerEnum(L, ITEM_TYPE_POTION);
	registerEnum(L, ITEM_TYPE_RING);
	registerEnum(L, ITEM_TYPE_RUNE);
	registerEnum(L, ITEM_TYPE_SHIELD);
	registerEnum(L, ITEM_TYPE_TOOLS);
	registerEnum(L, ITEM_TYPE_VALUABLE);
	registerEnum(L, ITEM_TYPE_AMMO);
	registerEnum(L, ITEM_TYPE_AXE);
	registerEnum(L, ITEM_TYPE_CLUB);
	registerEnum(L, ITEM_TYPE_DISTANCE);
	registerEnum(L, ITEM_TYPE_SWORD);
	registerEnum(L, ITEM_TYPE_WAND);
	registerEnum(L, ITEM_TYPE_CREATUREPRODUCT);
	registerEnum(L, ITEM_TYPE_RETRIEVE);
	registerEnum(L, ITEM_TYPE_GOLD);
	registerEnum(L, ITEM_TYPE_UNASSIGNED);
}

void LuaEnums::initFluidEnums(lua_State* L) {
	for (const auto value : magic_enum::enum_values<Fluids_t>()) {
		registerMagicEnum(L, value);
	}
}

void LuaEnums::initItemIdEnums(lua_State* L) {
	registerEnum(L, ITEM_BAG);
	registerEnum(L, ITEM_SHOPPING_BAG);
	registerEnum(L, ITEM_GOLD_COIN);
	registerEnum(L, ITEM_PLATINUM_COIN);
	registerEnum(L, ITEM_CRYSTAL_COIN);
	registerEnum(L, ITEM_STORE_COIN);
	registerEnum(L, ITEM_REWARD_CHEST);
	registerEnum(L, ITEM_REWARD_CONTAINER);
	registerEnum(L, ITEM_AMULETOFLOSS);
	registerEnum(L, ITEM_PARCEL);
	registerEnum(L, ITEM_PARCEL_STAMPED);
	registerEnum(L, ITEM_LABEL);
	registerEnum(L, ITEM_FIREFIELD_PVP_FULL);
	registerEnum(L, ITEM_FIREFIELD_PVP_MEDIUM);
	registerEnum(L, ITEM_FIREFIELD_PVP_SMALL);
	registerEnum(L, ITEM_FIREFIELD_PERSISTENT_FULL);
	registerEnum(L, ITEM_FIREFIELD_PERSISTENT_MEDIUM);
	registerEnum(L, ITEM_FIREFIELD_PERSISTENT_SMALL);
	registerEnum(L, ITEM_FIREFIELD_NOPVP);
	registerEnum(L, ITEM_POISONFIELD_PVP);
	registerEnum(L, ITEM_POISONFIELD_PERSISTENT);
	registerEnum(L, ITEM_POISONFIELD_NOPVP);
	registerEnum(L, ITEM_ENERGYFIELD_PVP);
	registerEnum(L, ITEM_ENERGYFIELD_PERSISTENT);
	registerEnum(L, ITEM_ENERGYFIELD_NOPVP);
	registerEnum(L, ITEM_MAGICWALL);
	registerEnum(L, ITEM_MAGICWALL_PERSISTENT);
	registerEnum(L, ITEM_MAGICWALL_SAFE);
	registerEnum(L, ITEM_WILDGROWTH);
	registerEnum(L, ITEM_WILDGROWTH_PERSISTENT);
	registerEnum(L, ITEM_WILDGROWTH_SAFE);

	registerEnum(L, ITEM_EXERCISE_START);
	registerEnum(L, ITEM_EXERCISE_END);

	registerEnum(L, ITEM_HEALTH_CASK_START);
	registerEnum(L, ITEM_HEALTH_CASK_END);

	registerEnum(L, ITEM_MANA_CASK_START);
	registerEnum(L, ITEM_MANA_CASK_END);

	registerEnum(L, ITEM_SPIRIT_CASK_START);
	registerEnum(L, ITEM_SPIRIT_CASK_END);

	registerEnum(L, ITEM_KEG_START);
	registerEnum(L, ITEM_KEG_END);

	registerEnum(L, ITEM_STONE_SKIN_AMULET);

	registerEnum(L, ITEM_OLD_DIAMOND_ARROW);
	registerEnum(L, ITEM_DIAMOND_ARROW);

	registerEnum(L, ITEM_GOLD_POUCH);
	registerEnum(L, ITEM_STORE_INBOX);

	registerEnum(L, ITEM_DIVINE_EMPOWERMENT);

	registerEnum(L, ITEM_FORGE_SLIVER);
	registerEnum(L, ITEM_FORGE_CORE);
	registerEnum(L, ITEM_PRIMAL_POD);
	registerEnum(L, ITEM_DECORATION_KIT);

	registerEnum(L, ItemID_t::HIRELING_LAMP);
}

void LuaEnums::initPlayerFlagEnums(lua_State* L) {
	for (const auto value : magic_enum::enum_values<PlayerFlags_t>()) {
		registerMagicEnum(L, value);
	}
}

void LuaEnums::initCreatureIconEnums(lua_State* L) {
	std::string luaNamespace = "CreatureIconCategory_";
	for (auto value : magic_enum::enum_values<CreatureIconCategory_t>()) {
		registerMagicEnumNamespace(L, luaNamespace, value);
	}
	luaNamespace = "CreatureIconModifications_";
	for (auto value : magic_enum::enum_values<CreatureIconModifications_t>()) {
		registerMagicEnumNamespace(L, luaNamespace, value);
	}
	luaNamespace = "CreatureIconQuests_";
	for (auto value : magic_enum::enum_values<CreatureIconQuests_t>()) {
		registerMagicEnumNamespace(L, luaNamespace, value);
	}
}

void LuaEnums::initReportReasonEnums(lua_State* L) {
	registerEnum(L, REPORT_REASON_NAMEINAPPROPRIATE);
	registerEnum(L, REPORT_REASON_NAMEPOORFORMATTED);
	registerEnum(L, REPORT_REASON_NAMEADVERTISING);
	registerEnum(L, REPORT_REASON_NAMEUNFITTING);
	registerEnum(L, REPORT_REASON_NAMERULEVIOLATION);
	registerEnum(L, REPORT_REASON_INSULTINGSTATEMENT);
	registerEnum(L, REPORT_REASON_SPAMMING);
	registerEnum(L, REPORT_REASON_ADVERTISINGSTATEMENT);
	registerEnum(L, REPORT_REASON_UNFITTINGSTATEMENT);
	registerEnum(L, REPORT_REASON_LANGUAGESTATEMENT);
	registerEnum(L, REPORT_REASON_DISCLOSURE);
	registerEnum(L, REPORT_REASON_RULEVIOLATION);
	registerEnum(L, REPORT_REASON_STATEMENT_BUGABUSE);
	registerEnum(L, REPORT_REASON_UNOFFICIALSOFTWARE);
	registerEnum(L, REPORT_REASON_PRETENDING);
	registerEnum(L, REPORT_REASON_HARASSINGOWNERS);
	registerEnum(L, REPORT_REASON_FALSEINFO);
	registerEnum(L, REPORT_REASON_ACCOUNTSHARING);
	registerEnum(L, REPORT_REASON_STEALINGDATA);
	registerEnum(L, REPORT_REASON_SERVICEATTACKING);
	registerEnum(L, REPORT_REASON_SERVICEAGREEMENT);
}

void LuaEnums::initSkillEnums(lua_State* L) {
	registerEnum(L, SKILL_NONE);
	registerEnum(L, SKILL_FIST);
	registerEnum(L, SKILL_CLUB);
	registerEnum(L, SKILL_SWORD);
	registerEnum(L, SKILL_AXE);
	registerEnum(L, SKILL_DISTANCE);
	registerEnum(L, SKILL_SHIELD);
	registerEnum(L, SKILL_FISHING);
	registerEnum(L, SKILL_CRITICAL_HIT_CHANCE);
	registerEnum(L, SKILL_CRITICAL_HIT_DAMAGE);
	registerEnum(L, SKILL_LIFE_LEECH_CHANCE);
	registerEnum(L, SKILL_LIFE_LEECH_AMOUNT);
	registerEnum(L, SKILL_MANA_LEECH_CHANCE);
	registerEnum(L, SKILL_MANA_LEECH_AMOUNT);
	registerEnum(L, SKILL_MAGLEVEL);
	registerEnum(L, SKILL_LEVEL);
}

void LuaEnums::initSkullEnums(lua_State* L) {
	registerEnum(L, SKULL_NONE);
	registerEnum(L, SKULL_YELLOW);
	registerEnum(L, SKULL_GREEN);
	registerEnum(L, SKULL_WHITE);
	registerEnum(L, SKULL_RED);
	registerEnum(L, SKULL_BLACK);
	registerEnum(L, SKULL_ORANGE);
}

void LuaEnums::initTalkTypeEnums(lua_State* L) {
	registerEnum(L, TALKTYPE_SAY);
	registerEnum(L, TALKTYPE_WHISPER);
	registerEnum(L, TALKTYPE_YELL);
	registerEnum(L, TALKTYPE_PRIVATE_FROM);
	registerEnum(L, TALKTYPE_PRIVATE_TO);
	registerEnum(L, TALKTYPE_CHANNEL_Y);
	registerEnum(L, TALKTYPE_CHANNEL_O);
	registerEnum(L, TALKTYPE_PRIVATE_NP);
	registerEnum(L, TALKTYPE_PRIVATE_PN);
	registerEnum(L, TALKTYPE_BROADCAST);
	registerEnum(L, TALKTYPE_CHANNEL_R1);
	registerEnum(L, TALKTYPE_PRIVATE_RED_FROM);
	registerEnum(L, TALKTYPE_PRIVATE_RED_TO);
	registerEnum(L, TALKTYPE_MONSTER_SAY);
	registerEnum(L, TALKTYPE_MONSTER_YELL);
	registerEnum(L, TALKTYPE_CHANNEL_R2);
}

void LuaEnums::initBestiaryEnums(lua_State* L) {
	registerEnum(L, BESTY_RACE_NONE);
	registerEnum(L, BESTY_RACE_FIRST);
	registerEnum(L, BESTY_RACE_AMPHIBIC);
	registerEnum(L, BESTY_RACE_AQUATIC);
	registerEnum(L, BESTY_RACE_BIRD);
	registerEnum(L, BESTY_RACE_CONSTRUCT);
	registerEnum(L, BESTY_RACE_DEMON);
	registerEnum(L, BESTY_RACE_DRAGON);
	registerEnum(L, BESTY_RACE_ELEMENTAL);
	registerEnum(L, BESTY_RACE_EXTRA_DIMENSIONAL);
	registerEnum(L, BESTY_RACE_FEY);
	registerEnum(L, BESTY_RACE_GIANT);
	registerEnum(L, BESTY_RACE_HUMAN);
	registerEnum(L, BESTY_RACE_HUMANOID);
	registerEnum(L, BESTY_RACE_LYCANTHROPE);
	registerEnum(L, BESTY_RACE_MAGICAL);
	registerEnum(L, BESTY_RACE_MAMMAL);
	registerEnum(L, BESTY_RACE_PLANT);
	registerEnum(L, BESTY_RACE_REPTILE);
	registerEnum(L, BESTY_RACE_SLIME);
	registerEnum(L, BESTY_RACE_UNDEAD);
	registerEnum(L, BESTY_RACE_VERMIN);
	registerEnum(L, BESTY_RACE_LAST);
}

void LuaEnums::initTextColorEnums(lua_State* L) {
	registerEnum(L, TEXTCOLOR_BLUE);
	registerEnum(L, TEXTCOLOR_LIGHTGREEN);
	registerEnum(L, TEXTCOLOR_LIGHTBLUE);
	registerEnum(L, TEXTCOLOR_DARKBROWN);
	registerEnum(L, TEXTCOLOR_MAYABLUE);
	registerEnum(L, TEXTCOLOR_DARKRED);
	registerEnum(L, TEXTCOLOR_LIGHTGREY);
	registerEnum(L, TEXTCOLOR_SKYBLUE);
	registerEnum(L, TEXTCOLOR_PURPLE);
	registerEnum(L, TEXTCOLOR_ELECTRICPURPLE);
	registerEnum(L, TEXTCOLOR_RED);
	registerEnum(L, TEXTCOLOR_PASTELRED);
	registerEnum(L, TEXTCOLOR_ORANGE);
	registerEnum(L, TEXTCOLOR_YELLOW);
	registerEnum(L, TEXTCOLOR_WHITE_EXP);
	registerEnum(L, TEXTCOLOR_NONE);
}

void LuaEnums::initTileStateEnums(lua_State* L) {
	registerEnum(L, TILESTATE_NONE);
	registerEnum(L, TILESTATE_PROTECTIONZONE);
	registerEnum(L, TILESTATE_NOPVPZONE);
	registerEnum(L, TILESTATE_NOLOGOUT);
	registerEnum(L, TILESTATE_PVPZONE);
	registerEnum(L, TILESTATE_FLOORCHANGE);
	registerEnum(L, TILESTATE_FLOORCHANGE_DOWN);
	registerEnum(L, TILESTATE_FLOORCHANGE_NORTH);
	registerEnum(L, TILESTATE_FLOORCHANGE_SOUTH);
	registerEnum(L, TILESTATE_FLOORCHANGE_EAST);
	registerEnum(L, TILESTATE_FLOORCHANGE_WEST);
	registerEnum(L, TILESTATE_TELEPORT);
	registerEnum(L, TILESTATE_MAGICFIELD);
	registerEnum(L, TILESTATE_MAILBOX);
	registerEnum(L, TILESTATE_TRASHHOLDER);
	registerEnum(L, TILESTATE_BED);
	registerEnum(L, TILESTATE_DEPOT);
	registerEnum(L, TILESTATE_BLOCKSOLID);
	registerEnum(L, TILESTATE_BLOCKPATH);
	registerEnum(L, TILESTATE_IMMOVABLEBLOCKSOLID);
	registerEnum(L, TILESTATE_IMMOVABLEBLOCKPATH);
	registerEnum(L, TILESTATE_IMMOVABLENOFIELDBLOCKPATH);
	registerEnum(L, TILESTATE_NOFIELDBLOCKPATH);
	registerEnum(L, TILESTATE_FLOORCHANGE_SOUTH_ALT);
	registerEnum(L, TILESTATE_FLOORCHANGE_EAST_ALT);
	registerEnum(L, TILESTATE_SUPPORTS_HANGABLE);
}

// Use with npc:setSpeechBubble
void LuaEnums::initSpeechBubbleEnums(lua_State* L) {
	registerEnum(L, SPEECHBUBBLE_NONE);
	registerEnum(L, SPEECHBUBBLE_NORMAL);
	registerEnum(L, SPEECHBUBBLE_TRADE);
	registerEnum(L, SPEECHBUBBLE_QUEST);
	registerEnum(L, SPEECHBUBBLE_QUESTTRADER);
	registerEnum(L, SPEECHBUBBLE_HIRELING);
}

// Use with player:addMapMark
void LuaEnums::initMapMarkEnums(lua_State* L) {
	registerEnum(L, MAPMARK_TICK);
	registerEnum(L, MAPMARK_QUESTION);
	registerEnum(L, MAPMARK_EXCLAMATION);
	registerEnum(L, MAPMARK_STAR);
	registerEnum(L, MAPMARK_CROSS);
	registerEnum(L, MAPMARK_TEMPLE);
	registerEnum(L, MAPMARK_KISS);
	registerEnum(L, MAPMARK_SHOVEL);
	registerEnum(L, MAPMARK_SWORD);
	registerEnum(L, MAPMARK_FLAG);
	registerEnum(L, MAPMARK_LOCK);
	registerEnum(L, MAPMARK_BAG);
	registerEnum(L, MAPMARK_SKULL);
	registerEnum(L, MAPMARK_DOLLAR);
	registerEnum(L, MAPMARK_REDNORTH);
	registerEnum(L, MAPMARK_REDSOUTH);
	registerEnum(L, MAPMARK_REDEAST);
	registerEnum(L, MAPMARK_REDWEST);
	registerEnum(L, MAPMARK_GREENNORTH);
	registerEnum(L, MAPMARK_GREENSOUTH);
}

// Use with Game.getReturnMessage
void LuaEnums::initReturnValueEnums(lua_State* L) {
	registerEnum(L, RETURNVALUE_NOERROR);
	registerEnum(L, RETURNVALUE_NOTBOUGHTINSTORE);
	registerEnum(L, RETURNVALUE_ITEMCANNOTBEMOVEDTHERE);
	registerEnum(L, RETURNVALUE_ITEMCANNOTBEMOVEDPOUCH);
	registerEnum(L, RETURNVALUE_NOTPOSSIBLE);
	registerEnum(L, RETURNVALUE_NOTENOUGHROOM);
	registerEnum(L, RETURNVALUE_PLAYERISPZLOCKED);
	registerEnum(L, RETURNVALUE_PLAYERISNOTINVITED);
	registerEnum(L, RETURNVALUE_CANNOTTHROW);
	registerEnum(L, RETURNVALUE_THEREISNOWAY);
	registerEnum(L, RETURNVALUE_DESTINATIONOUTOFREACH);
	registerEnum(L, RETURNVALUE_CREATUREBLOCK);
	registerEnum(L, RETURNVALUE_NOTMOVABLE);
	registerEnum(L, RETURNVALUE_DROPTWOHANDEDITEM);
	registerEnum(L, RETURNVALUE_BOTHHANDSNEEDTOBEFREE);
	registerEnum(L, RETURNVALUE_CANONLYUSEONEWEAPON);
	registerEnum(L, RETURNVALUE_NEEDEXCHANGE);
	registerEnum(L, RETURNVALUE_CANNOTBEDRESSED);
	registerEnum(L, RETURNVALUE_PUTTHISOBJECTINYOURHAND);
	registerEnum(L, RETURNVALUE_PUTTHISOBJECTINBOTHHANDS);
	registerEnum(L, RETURNVALUE_TOOFARAWAY);
	registerEnum(L, RETURNVALUE_FIRSTGODOWNSTAIRS);
	registerEnum(L, RETURNVALUE_FIRSTGOUPSTAIRS);
	registerEnum(L, RETURNVALUE_CONTAINERNOTENOUGHROOM);
	registerEnum(L, RETURNVALUE_NOTENOUGHCAPACITY);
	registerEnum(L, RETURNVALUE_CANNOTPICKUP);
	registerEnum(L, RETURNVALUE_THISISIMPOSSIBLE);
	registerEnum(L, RETURNVALUE_DEPOTISFULL);
	registerEnum(L, RETURNVALUE_CREATUREDOESNOTEXIST);
	registerEnum(L, RETURNVALUE_CANNOTUSETHISOBJECT);
	registerEnum(L, RETURNVALUE_PLAYERWITHTHISNAMEISNOTONLINE);
	registerEnum(L, RETURNVALUE_NOTREQUIREDLEVELTOUSERUNE);
	registerEnum(L, RETURNVALUE_YOUAREALREADYTRADING);
	registerEnum(L, RETURNVALUE_THISPLAYERISALREADYTRADING);
	registerEnum(L, RETURNVALUE_YOUMAYNOTLOGOUTDURINGAFIGHT);
	registerEnum(L, RETURNVALUE_DIRECTPLAYERSHOOT);
	registerEnum(L, RETURNVALUE_NOTENOUGHLEVEL);
	registerEnum(L, RETURNVALUE_NOTENOUGHMAGICLEVEL);
	registerEnum(L, RETURNVALUE_NOTENOUGHMANA);
	registerEnum(L, RETURNVALUE_NOTENOUGHSOUL);
	registerEnum(L, RETURNVALUE_YOUAREEXHAUSTED);
	registerEnum(L, RETURNVALUE_YOUCANNOTUSEOBJECTSTHATFAST);
	registerEnum(L, RETURNVALUE_PLAYERISNOTREACHABLE);
	registerEnum(L, RETURNVALUE_CANONLYUSETHISRUNEONCREATURES);
	registerEnum(L, RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE);
	registerEnum(L, RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER);
	registerEnum(L, RETURNVALUE_YOUMAYNOTATTACKAPERSONINPROTECTIONZONE);
	registerEnum(L, RETURNVALUE_YOUMAYNOTATTACKAPERSONWHILEINPROTECTIONZONE);
	registerEnum(L, RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE);
	registerEnum(L, RETURNVALUE_YOUCANONLYUSEITONCREATURES);
	registerEnum(L, RETURNVALUE_CREATUREISNOTREACHABLE);
	registerEnum(L, RETURNVALUE_TURNSECUREMODETOATTACKUNMARKEDPLAYERS);
	registerEnum(L, RETURNVALUE_YOUNEEDPREMIUMACCOUNT);
	registerEnum(L, RETURNVALUE_YOUNEEDTOLEARNTHISSPELL);
	registerEnum(L, RETURNVALUE_YOURVOCATIONCANNOTUSETHISSPELL);
	registerEnum(L, RETURNVALUE_YOUNEEDAWEAPONTOUSETHISSPELL);
	registerEnum(L, RETURNVALUE_PLAYERISPZLOCKEDLEAVEPVPZONE);
	registerEnum(L, RETURNVALUE_PLAYERISPZLOCKEDENTERPVPZONE);
	registerEnum(L, RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE);
	registerEnum(L, RETURNVALUE_YOUCANNOTLOGOUTHERE);
	registerEnum(L, RETURNVALUE_YOUNEEDAMAGICITEMTOCASTSPELL);
	registerEnum(L, RETURNVALUE_CANNOTCONJUREITEMHERE);
	registerEnum(L, RETURNVALUE_YOUNEEDTOSPLITYOURSPEARS);
	registerEnum(L, RETURNVALUE_NAMEISTOOAMBIGUOUS);
	registerEnum(L, RETURNVALUE_CANONLYUSEONESHIELD);
	registerEnum(L, RETURNVALUE_NOPARTYMEMBERSINRANGE);
	registerEnum(L, RETURNVALUE_YOUARENOTTHEOWNER);
	registerEnum(L, RETURNVALUE_TRADEPLAYERFARAWAY);
	registerEnum(L, RETURNVALUE_YOUDONTOWNTHISHOUSE);
	registerEnum(L, RETURNVALUE_TRADEPLAYERALREADYOWNSAHOUSE);
	registerEnum(L, RETURNVALUE_TRADEPLAYERHIGHESTBIDDER);
	registerEnum(L, RETURNVALUE_YOUCANNOTTRADETHISHOUSE);
	registerEnum(L, RETURNVALUE_YOUDONTHAVEREQUIREDPROFESSION);
	registerEnum(L, RETURNVALUE_NOTENOUGHFISTLEVEL);
	registerEnum(L, RETURNVALUE_NOTENOUGHCLUBLEVEL);
	registerEnum(L, RETURNVALUE_NOTENOUGHSWORDLEVEL);
	registerEnum(L, RETURNVALUE_NOTENOUGHAXELEVEL);
	registerEnum(L, RETURNVALUE_NOTENOUGHDISTANCELEVEL);
	registerEnum(L, RETURNVALUE_NOTENOUGHSHIELDLEVEL);
	registerEnum(L, RETURNVALUE_NOTENOUGHFISHLEVEL);
	registerEnum(L, RETURNVALUE_REWARDCHESTISEMPTY);
	registerEnum(L, RETURNVALUE_CONTACTADMINISTRATOR);
	registerEnum(L, RETURNVALUE_ITEMISNOTYOURS);
	registerEnum(L, RETURNVALUE_ITEMUNTRADEABLE);
}

// Reload
void LuaEnums::initReloadTypeEnums(lua_State* L) {
	for (const auto value : magic_enum::enum_values<Reload_t>()) {
		registerMagicEnum(L, value);
	}
}

void LuaEnums::initCreaturesEventEnums(lua_State* L) {
	// Monsters
	for (auto value : magic_enum::enum_values<MonstersEvent_t>()) {
		registerMagicEnum(L, value);
	}

	// Npcs
	registerEnum(L, NPCS_EVENT_THINK);
	registerEnum(L, NPCS_EVENT_APPEAR);
	registerEnum(L, NPCS_EVENT_DISAPPEAR);
	registerEnum(L, NPCS_EVENT_MOVE);
	registerEnum(L, NPCS_EVENT_SAY);
	registerEnum(L, NPCS_EVENT_PLAYER_BUY);
	registerEnum(L, NPCS_EVENT_PLAYER_SELL);
	registerEnum(L, NPCS_EVENT_PLAYER_CHECK_ITEM);
	registerEnum(L, NPCS_EVENT_PLAYER_CLOSE_CHANNEL);
}

void LuaEnums::initForgeEnums(lua_State* L) {
	for (const auto value : magic_enum::enum_values<ForgeClassifications_t>()) {
		registerMagicEnum(L, value);
	}
}

// Webhook default colors
void LuaEnums::initWebhookEnums(lua_State* L) {
	registerEnum(L, WEBHOOK_COLOR_GREEN);
	registerEnum(L, WEBHOOK_COLOR_RED);
	registerEnum(L, WEBHOOK_COLOR_YELLOW);
	registerEnum(L, WEBHOOK_COLOR_BLUE);
}

void LuaEnums::initBosstiaryEnums(lua_State* L) {
	for (const auto value : magic_enum::enum_values<BosstiaryRarity_t>()) {
		registerMagicEnum(L, value);
	}
}

// "SOUND_EFFECT_TYPE_" is the sound lua namespace
void LuaEnums::initSoundEnums(lua_State* L) {
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SILENCE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMAN_CLOSE_ATK_FIST);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_CLOSE_ATK_FIST);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MELEE_ATK_SWORD);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MELEE_ATK_CLUB);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MELEE_ATK_AXE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DIST_ATK_BOW);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DIST_ATK_CROSSBOW);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DIST_ATK_THROW);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAGICAL_RANGE_ATK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_OR_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::OTHER);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::PHYSICAL_RANGE_MISS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DIST_ATK_BOW_SHOT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DIST_ATK_CROSSBOW_SHOT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DIST_ATK_THROW_SHOT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DIST_ATK_ROD_SHOT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DIST_ATK_WAND_SHOT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::BURST_ARROW_EFFECT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DIAMOND_ARROW_EFFECT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::NO_DAMAGE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_MELEE_ATK_FIST);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_MELEE_ATK_CLAW);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_MELEE_ATK_BITE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_MELEE_ATK_RIP);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_MELEE_ATK_ACID);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_MELEE_ATK_MAGIC);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_MELEE_ATK_ETHEREAL);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_MELEE_ATK_CONSTRUCT);
}

void LuaEnums::spelltSoundEnums(lua_State* L) {
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_LIGHT_HEALING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_INTENSE_HEALING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ULTIMATE_HEALING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_INTENSE_HEALING_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ULTIMATE_HEALING_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_HASTE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_LIGHT_MAGIC_MISSILE_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_HEAVY_MAGIC_MISSILE_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_SUMMON_CREATURE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_LIGHT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_GREAT_LIGHT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CONVINCE_CREATURE_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ENERGY_WAVE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CHAMELEON_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_FIREBALL_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_GREAT_FIREBALL_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_FIRE_BOMB_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_EXPLOSION_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_FIRE_WAVE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_FIND_PERSON);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_SUDDENDEATH_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ENERGY_BEAM);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_GREAT_ENERGY_BEAM);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_HELL_SCORE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_FIRE_FIELD_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_POISON_FIELD_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ENERGY_FIELD_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_FIRE_WALL_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CURE_POISON);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_DESTROY_FIELD_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CURE_POISON_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_POISON_WALL_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ENERGY_WALL_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_SALVATION);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CREATURE_ILLUSION);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_STRONG_HASTE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_FOOD);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_STRONG_ICE_WAVE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_MAGIC_SHIELD);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_INVISIBLE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CONJURE_EXPLOSIVE_ARROW);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_SOUL_FIRE_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CONJURE_ARROW);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_PARALYSE_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ENERGY_BOMB_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_WRATH_OF_NATURE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_STRONG_ETHEREAL_SPEAR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_FRONT_SWEEP);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_BRUTAL_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ANNIHILATION);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_INVITE_GUESTS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_INVITE_SUBOWNERS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_KICK_GUEST);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_EDIT_DOOR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ULTIMATE_LIGHT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_MAGIC_ROPE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_STALAGMITE_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_DISINTEGRATE_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_BERSERK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_LEVITATE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_MASS_HEALING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ANIMATE_DEAD_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_HEAL_FRIEND);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_UNDEAD_LEGION);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_MAGIC_WALL_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_DEATH_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ENERGY_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_FLAME_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CANCEL_INVISIBILITY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_POISON_BOMB_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CONJURE_WAND_OF_DARKNESS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CHALLENGE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_WILD_GROWTH_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_FIERCE_BERSERK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_GROUNDSHAKER);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_WHIRLWIND_THROW);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ENCHANT_SPEAR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ETHEREAL_SPEAR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ICE_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_TERRA_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ICICLE_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_AVALANCHE_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_STONE_SHOWER_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_THUNDERSTORM_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ETERNAL_WINTER);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_RAGE_OF_THE_SKIES);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_TERRA_WAVE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ICE_WAVE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_DIVINE_MISSILE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_WOUND_CLEANSING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_DIVINE_CALDERA);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_DIVINE_HEALING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_TRAIN_PARTY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_PROTECT_PARTY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_HEAL_PARTY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ENCHANT_PARTY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_HOLY_MISSILE_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CHARGE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_PROTECTOR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_BLOOD_RAGE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_SWIFT_FOOT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_SHARPSHOOTER);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_IGNITE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CURSE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ELECTRIFY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_INFLICT_WOUND);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ENVENOM);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_HOLY_FLASH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CURE_BLEEDING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CURE_BURNING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CURE_ELECTRIFICATION);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CURE_CURSE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_PHYSICAL_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_LIGHTNING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_STRONG_FLAME_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_STRONG_ENERGY_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_STRONG_ICE_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_STRONG_TERRA_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ULTIMATE_FLAME_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ULTIMATE_ENERGY_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ULTIMATE_ICE_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ULTIMATE_TERRA_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_INTENSE_WOUND_CLEANSING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_RECOVERY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_INTENSE_RECOVERY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_PRACTISE_HEALING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_PRACTISE_FIRE_WAVE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_PRACTISE_MAGIC_MISSILE_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_APPRENT_ICES_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_MUD_ATTACK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CHILL_OUT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_MAGIC_PATCH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_BRUISE_BANE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_ARROW_CALL);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_BUZZ);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_SCORCH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_LIGHTEST_MISSILE_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_LIGHT_STONE_SHOWER_RUNE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_SUMMON_KNIGHT_FAMILIAR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_SUMMON_PALADIN_FAMILIAR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_SUMMON_SORCERER_FAMILIAR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_SUMMON_DRUID_FAMILIAR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CHIVALROUS_CHALLENGE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_DIVINE_DAZZLE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_FAIR_WOUND_CLEANSING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_GREAT_FIRE_WAVE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_RESTORATION);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_NATURES_EMBRACE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_EXPOSE_WEAKNESS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_SAP_STRENGTH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SPELL_CANCEL_MAGIC_SHIELD);
}

void LuaEnums::monsterSoundEnums(lua_State* L) {
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SINGLE_TARGET_FIRE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SINGLE_TARGET_ENERGY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SINGLE_TARGET_EARTH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SINGLE_TARGET_ICE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SINGLE_TARGET_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SINGLE_TARGET_HOLY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SINGLE_TARGET_HIT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SINGLE_TARGET_LIFEDRAIN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SINGLE_TARGET_MANADRAIN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SINGLE_TARGET_DROWNING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SINGLE_TARGET_BLEEDING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SINGLE_TARGET_HEALING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SMALL_AREA_FIRE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SMALL_AREA_ENERGY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SMALL_AREA_EARTH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SMALL_AREA_ICE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SMALL_AREA_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SMALL_AREA_HOLY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SMALL_AREA_HIT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SMALL_AREA_LIFEDRAIN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SMALL_AREA_MANADRAIN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SMALL_AREA_DROWNING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SMALL_AREA_BLEEDING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SMALL_AREA_HEALING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_LARGE_AREA_FIRE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_LARGE_AREA_ENERGY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_LARGE_AREA_EARTH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_LARGE_AREA_ICE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_LARGE_AREA_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_LARGE_AREA_HOLY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_LARGE_AREA_HIT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_LARGE_AREA_LIFEDRAIN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_LARGE_AREA_MANADRAIN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_LARGE_AREA_DROWNING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_LARGE_AREA_BLEEDING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_LARGE_AREA_HEALING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_WAVE_FIRE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_WAVE_ENERGY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_WAVE_EARTH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_WAVE_ICE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_WAVE_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_WAVE_HOLY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_WAVE_HIT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_WAVE_LIFEDRAIN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_WAVE_MANADRAIN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_WAVE_DROWNING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_WAVE_BLEEDING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_WAVE_HEALING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_DELETEFIELD);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_CHALLENGE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SPEED);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_DRUNKEN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_STRENGTH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_OUTFIT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SUMMON);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_MAGICLEVEL);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_TELEPORT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_HEX);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_SUPER_DRUNKEN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_ROOT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_FEAR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_HIGHRISK_TELEPORT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_MINION);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_SPELL_AGONY);
}

void LuaEnums::effectsSoundEnums(lua_State* L) {
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::AMPHIBIC_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::AQUATIC_BEAST_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::AQUATIC_CRITTER_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::AQUATIC_DEEPLING_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::AQUATIC_QUARA_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::BIRD_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::CONSTRUCT_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DEMON_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DRAGON_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ELEMENTAL_EARTH_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ELEMENTAL_ENERGY_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ELEMENTAL_FIRE_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ELEMENTAL_WATER_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::EXTRA_DIMENSIONAL_BEAST_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::EXTRA_DIMENSIONAL_ENERGY_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::EXTRA_DIMENSIONAL_HORROR_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::FEY_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::GIANT_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMAN_FEMALE_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMAN_MALE_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMANOID_GOBLIN_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMANOID_ORC_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::LYCANTHROPE_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAGICAL_ENERGY_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAGICAL_HORROR_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_BEAR_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_CRITTER_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_DOG_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_ELEPHANT_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_FERAL_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_HORSE_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_MAMMOTH_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::PHANTOM_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::PLANT_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::REPTILE_LARGE_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::REPTILE_SMALL_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SLIME_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::UNDEAD_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::VERMIN_CRITTER_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::VERMIN_INSECT_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::VERMIN_ROTWORM_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMAN_SAGE_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMAN_CRONE_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::APE_BARK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::AMPHIBIC_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::AQUATIC_BEAST_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::AQUATIC_CRITTER_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::AQUATIC_DEEPLING_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::AQUATIC_QUARA_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::BIRD_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::CONSTRUCT_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DEMON_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::DRAGON_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ELEMENTAL_EARTH_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ELEMENTAL_ENERGY_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ELEMENTAL_FIRE_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ELEMENTAL_WATER_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::EXTRA_DIMENSIONAL_BEAST_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::EXTRA_DIMENSIONAL_ENERGY_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::EXTRA_DIMENSIONAL_HORROR_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::FEY_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::GIANT_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMAN_FEMALE_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMAN_MALE_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMANOID_GOBLIN_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMANOID_ORC_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::LYCANTHROPE_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAGICAL_ENERGY_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAGICAL_HORROR_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_BEAR_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_CRITTER_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_DOG_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_ELEPHANT_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_FERAL_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_HORSE_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MAMMAL_MAMMOTH_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MONSTER_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::PHANTOM_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::PLANT_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::REPTILE_LARGE_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::REPTILE_SMALL_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::SLIME_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::UNDEAD_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::VERMIN_CRITTER_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::VERMIN_INSECT_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::VERMIN_ROTWORM_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMAN_SAGE_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::HUMAN_CRONE_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::APE_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::UNKNOWN_CREATURE_DEATH_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::UNKNOWN_CREATURE_DEATH_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::UNKNOWN_CREATURE_DEATH_3);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::UNKNOWN_CREATURE_DEATH_4);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_HEAVY_METAL_LOUD);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_INSECTS_BIRDS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WIND_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WIND_CLOSE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WATER_DEPTH_BOAT_SURFACE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_METALIC_SPACE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_FROGS_INSECTS_WOODS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WATER_DEPTH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_SEA_WAVE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WIND_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WIND_3);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_MONKEYS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_STORM_COMING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_HITTING_WOOD);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WOOD_STICK_SMASH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_THICK_BLOB_LIQUID_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_LITTLE_BIRTS_FLOREST);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_THICK_BLOCK_LIQUID_CLOSE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_METAL_CHAINS_MOVING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CRICKET_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CRICKET_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CRICKET_3);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CICADA_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_STONES_FALLING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_OPEN_DOOR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_CLOSE_DOOR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_OWL);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_ELETRONIC_DEVICE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_REPTILE_NOISE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_FORGE_METAL_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_FROG);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_WOOD_OBJECT_USING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_METAL_OBJECT_HIT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_NAIL_HIT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_BELL_RING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_HOT_METAL_ON_WATER);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WATER_SMOKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WOLF_HOWL);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WOOD_CRACKLE_CLOSE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_LAUGHT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WIND_MOVING_LEAF);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WIND_MOVING_FEW_LEAF);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_PORTAL_CAST);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_FIRE_MAGIC_CAST);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_TRAPDOOR_OPEN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_NAIL_FALLING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_LIGHT_BLOB_LIQUID);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_LION_ROAR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_MOVING_OBJECT_BUTTON_TRIGGER);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_SNAKE_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_HUMAN_SCREEN_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_HUMAN_SCREEN_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_SEAGUL_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_FAST_FOOTSTEPS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_SLOW_FOOTSTEPS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_THICK_BLOB_LIQUID_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_MOVING_LEAF);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WOOD_CRACKLE_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_OBJECT_FALLING_DEPTH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_BUTTON_TRIGGER);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_HEAVEN_DARK_REVERB);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WIND_4);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_INSECT_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_FLUTE_SONG);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_INSECTS_BIRDS_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_INSECT_CREATURE_DEATH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_LOW_ROAR);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_SINISTER_BURPH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CROWD_SCREEN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_BIRDS_FLYING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CROWD_VOICES_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_BIRD_CUCO);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_RAVINE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_RAVINE_METALIC);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_STICKS_LEAF_STEP);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_DISPEL_MAGIC_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_DISPEL_MAGIC_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CROWD_VOICES_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CROWD_VOICES_3);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CROWD_VOICES_4);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_METAL_OBJECT_FALL);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_HOURSE_STEPS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_DRUMES_SINISTER_REVERB);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_WOOD_PIECES_FALL);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_KNIFE_CUT_FLESH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CROWD_VOICES_5);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CICADA_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_FLYES);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_NOISE_WATER);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_PIG_SOUND_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_PIG_SOUND_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_SHEEP_SOUND_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_SHEEP_SOUND_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_FIRE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_NOISE_SNOW);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_FIRE_PLACE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WATERFALL);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WATER_SOURCE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_HAMMER_HITING_NAILS_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_HAMMER_HITING_NAILS_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_QUICK_STEPS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_HEAVY_OBJECT_FALL);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_HITING_FORGE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WOOD_CRACKLE_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_WOOD_HIT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MUSIC_CUT_BIRDS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MUSIC_CUT_LITTLE_BIRDS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MUSIC_CUT_INSECTS_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MUSIC_CUT_INSECTS_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MUSIC_CUT_INSECTS_3);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MUSIC_CUT_FLUTE_WEST);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MUSIC_CUT_CROWS_VOICES);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MUSIC_CUT_WIND_WATER);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::MUSIC_CUT_THICK_BLOCK_DEPTH);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CAMEL);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::UNKNOWN_CREATURE_DEATH_5);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CHICKEN_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CHICKEN_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_THRILLER_METALLIC);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_NOTIFICATION);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_LEVEL_ACHIEVEMENT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_SCREENSHOT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_CLICK_ON);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_CLICK_OFF);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_DRUMS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_XYLOPHONE_SLOW_DRUM);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_HARP_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_HARP_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_MOVING_WOOD);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_CRATE_BREAK_MAGIC_DUST);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_BELL_RING);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_SELECT_OBJECT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_BACKPACK);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_USE_POTION);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_NECKLACES);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_ARMORS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_METALIC);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_DISTANCE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_WOOD);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_STACKABLE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_DEFAULT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_LEGS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_HELMETS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_QUIVERS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_RINGS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_FROG_OR_LIQUID);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_WOOD_OBJECT_HIT_STORE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ITEM_MOVE_BOOTS);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_SWORD_DRAWN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_EAT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_STORE_BIG_OBJECT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_STORE_WOOD_OBJECT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_VIP_LOGOUT);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_VIP_LOGIN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CAT_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_INSECT_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_SEAGUL_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_LIQUID_SPILL);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_COW_MOO_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_COW_MOO_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_CAT_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_REAWRD_FEY);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_REWARD_GUITAR_1);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_REWARD_GUITAR_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WOODS_WATER_SOURCE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_HYENA);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::UNKNOWN_CREATURE_DEATH_6);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_COW_MOO_3);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::UNKNOWN_CREATURE_DEATH_7);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_METALIC_SPACE_ALIEN);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ACTION_AIR_STRIKE);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_WATER);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::ENV_SNAKE_2);
	registerEnumNamespace(L, soundNamespace, SoundEffect_t::GOD_SPELL_KILL_ALL_MONSTERS);
}

void LuaEnums::initWheelEnums(lua_State* L) {
	std::string wheelNamespace = "WHEEL_INSTANT_";
	for (const auto value : magic_enum::enum_values<WheelInstant_t>()) {
		registerMagicEnumNamespace(L, wheelNamespace, value);
	}

	wheelNamespace = "WHEEL_STAGE_";
	for (const auto value : magic_enum::enum_values<WheelStage_t>()) {
		registerMagicEnumNamespace(L, wheelNamespace, value);
	}
	wheelNamespace = "WHEEL_GRADE_";
	for (const auto value : magic_enum::enum_values<WheelSpellGrade_t>()) {
		registerMagicEnumNamespace(L, wheelNamespace, value);
	}

	wheelNamespace = "WHEEL_AVATAR_SKILL_";
	for (const auto value : magic_enum::enum_values<WheelAvatarSkill_t>()) {
		registerMagicEnumNamespace(L, wheelNamespace, value);
	}

	wheelNamespace = "WHEEL_STAT_";
	for (const auto value : magic_enum::enum_values<WheelStat_t>()) {
		registerMagicEnumNamespace(L, wheelNamespace, value);
	}

	wheelNamespace = "WHEEL_BOOST_";
	for (const auto value : magic_enum::enum_values<WheelSpellBoost_t>()) {
		registerMagicEnumNamespace(L, wheelNamespace, value);
	}
}
