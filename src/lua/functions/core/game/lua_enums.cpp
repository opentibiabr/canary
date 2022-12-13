/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "config/configmanager.h"

#include "lua/functions/core/game/lua_enums.hpp"

#include "creatures/players/account/account.hpp"
#include "creatures/creature.h"
#include "lua/creature/creatureevent.h"
#include "declarations.hpp"
#include "game/functions/game_reload.hpp"
#include "game/game.h"

#define registerEnumClass(luaState, enumClassType) { \
	auto number = magic_enum::enum_integer(enumClassType); \
	auto name = magic_enum::enum_name(enumClassType).data(); \
	registerGlobalVariable(luaState, name, number); \
} void(0)

#define registerEnum(L, value) { \
	std::string enumName = #value; \
	registerGlobalVariable(L, enumName.substr(enumName.find_last_of(':') + 1), value); \
} void(0)

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
	initItemIdEnums(L);
	initPlayerFlagEnums(L);
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
	initSoundEnums(L);
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
	registerEnum(L, FLAG_IGNORENOTMOVEABLE);
	registerEnum(L, FLAG_IGNOREAUTOSTACK);

	// Use with house:getAccessList, house:setAccessList
	registerEnum(L, GUEST_LIST);

	registerEnum(L, LIGHT_STATE_DAY);
	registerEnum(L, LIGHT_STATE_NIGHT);
	registerEnum(L, LIGHT_STATE_SUNSET);
	registerEnum(L, LIGHT_STATE_SUNRISE);
	registerEnum(L, STORAGEVALUE_EMOTE);

	registerEnum(L, MAX_LOOTCHANCE);

	registerEnum(L, ORIGIN_NONE);
	registerEnum(L, ORIGIN_CONDITION);
	registerEnum(L, ORIGIN_SPELL);
	registerEnum(L, ORIGIN_MELEE);
	registerEnum(L, ORIGIN_RANGED);
	
	registerEnum(L, PLAYERSEX_FEMALE);
	registerEnum(L, PLAYERSEX_MALE);

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
}

void LuaEnums::initAccountEnums(lua_State* L) {
	registerEnum(L, account::ACCOUNT_TYPE_NORMAL);
	registerEnum(L, account::ACCOUNT_TYPE_TUTOR);
	registerEnum(L, account::ACCOUNT_TYPE_SENIORTUTOR);
	registerEnum(L, account::ACCOUNT_TYPE_GAMEMASTER);
	registerEnum(L, account::ACCOUNT_TYPE_GOD);

	registerEnum(L, account::GROUP_TYPE_NORMAL);
	registerEnum(L, account::GROUP_TYPE_TUTOR);
	registerEnum(L, account::GROUP_TYPE_SENIORTUTOR);
	registerEnum(L, account::GROUP_TYPE_GAMEMASTER);
	registerEnum(L, account::GROUP_TYPE_COMMUNITYMANAGER);
	registerEnum(L, account::GROUP_TYPE_GOD);
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
}

void LuaEnums::initCombatParamEnums(lua_State* L) {
	registerEnum(L, COMBAT_PARAM_TYPE);
	registerEnum(L, COMBAT_PARAM_EFFECT);
	registerEnum(L, COMBAT_PARAM_DISTANCEEFFECT);
	registerEnum(L, COMBAT_PARAM_BLOCKSHIELD);
	registerEnum(L, COMBAT_PARAM_BLOCKARMOR);
	registerEnum(L, COMBAT_PARAM_TARGETCASTERORTOPMOST);
	registerEnum(L, COMBAT_PARAM_CREATEITEM);
	registerEnum(L, COMBAT_PARAM_AGGRESSIVE);
	registerEnum(L, COMBAT_PARAM_DISPEL);
	registerEnum(L, COMBAT_PARAM_USECHARGES);
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
	registerEnum(L, FACTION_LAST);
}

void LuaEnums::initConditionEnums(lua_State* L) {
	registerEnum(L, CONDITION_NONE);
	registerEnum(L, CONDITION_POISON);
	registerEnum(L, CONDITION_FIRE);
	registerEnum(L, CONDITION_ENERGY);
	registerEnum(L, CONDITION_BLEEDING);
	registerEnum(L, CONDITION_HASTE);
	registerEnum(L, CONDITION_PARALYZE);
	registerEnum(L, CONDITION_OUTFIT);
	registerEnum(L, CONDITION_INVISIBLE);
	registerEnum(L, CONDITION_LIGHT);
	registerEnum(L, CONDITION_MANASHIELD);
	registerEnum(L, CONDITION_INFIGHT);
	registerEnum(L, CONDITION_DRUNK);
	registerEnum(L, CONDITION_EXHAUST);
	registerEnum(L, CONDITION_REGENERATION);
	registerEnum(L, CONDITION_SOUL);
	registerEnum(L, CONDITION_DROWN);
	registerEnum(L, CONDITION_MUTED);
	registerEnum(L, CONDITION_CHANNELMUTEDTICKS);
	registerEnum(L, CONDITION_YELLTICKS);
	registerEnum(L, CONDITION_ATTRIBUTES);
	registerEnum(L, CONDITION_FREEZING);
	registerEnum(L, CONDITION_DAZZLED);
	registerEnum(L, CONDITION_CURSED);
	registerEnum(L, CONDITION_EXHAUST_COMBAT);
	registerEnum(L, CONDITION_EXHAUST_HEAL);
	registerEnum(L, CONDITION_PACIFIED);
	registerEnum(L, CONDITION_SPELLCOOLDOWN);
	registerEnum(L, CONDITION_SPELLGROUPCOOLDOWN);
	registerEnum(L, CONDITION_ROOTED);
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
	registerEnum(L, CONST_ME_FERUMBRAS_1);
	registerEnum(L, CONST_ME_GAZHARAGOTH);
	registerEnum(L, CONST_ME_MAD_MAGE);
	registerEnum(L, CONST_ME_HORESTIS);
	registerEnum(L, CONST_ME_DEVOVORGA);
	registerEnum(L, CONST_ME_FERUMBRAS_2);
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
	registerEnum(L, CONST_PROP_MOVEABLE);
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
	registerEnum(L, MESSAGE_ADMINISTRADOR);
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
	registerEnum(L, CLIENTOS_LINUX);
	registerEnum(L, CLIENTOS_WINDOWS);
	registerEnum(L, CLIENTOS_FLASH);
	registerEnum(L, CLIENTOS_NEW_WINDOWS);
	registerEnum(L, CLIENTOS_NEW_MAC);
	registerEnum(L, CLIENTOS_OTCLIENT_LINUX);
	registerEnum(L, CLIENTOS_OTCLIENT_WINDOWS);
	registerEnum(L, CLIENTOS_OTCLIENT_MAC);
}

void LuaEnums::initFightModeEnums(lua_State* L) {
	registerEnum(L, FIGHTMODE_ATTACK);
	registerEnum(L, FIGHTMODE_BALANCED);
	registerEnum(L, FIGHTMODE_DEFENSE);
}

void LuaEnums::initItemAttributeEnums(lua_State* L) {
	registerEnum(L, ITEM_ATTRIBUTE_NONE);
	registerEnum(L, ITEM_ATTRIBUTE_ACTIONID);
	registerEnum(L, ITEM_ATTRIBUTE_UNIQUEID);
	registerEnum(L, ITEM_ATTRIBUTE_DESCRIPTION);
	registerEnum(L, ITEM_ATTRIBUTE_TEXT);
	registerEnum(L, ITEM_ATTRIBUTE_DATE);
	registerEnum(L, ITEM_ATTRIBUTE_WRITER);
	registerEnum(L, ITEM_ATTRIBUTE_NAME);
	registerEnum(L, ITEM_ATTRIBUTE_ARTICLE);
	registerEnum(L, ITEM_ATTRIBUTE_PLURALNAME);
	registerEnum(L, ITEM_ATTRIBUTE_WEIGHT);
	registerEnum(L, ITEM_ATTRIBUTE_ATTACK);
	registerEnum(L, ITEM_ATTRIBUTE_DEFENSE);
	registerEnum(L, ITEM_ATTRIBUTE_EXTRADEFENSE);
	registerEnum(L, ITEM_ATTRIBUTE_ARMOR);
	registerEnum(L, ITEM_ATTRIBUTE_HITCHANCE);
	registerEnum(L, ITEM_ATTRIBUTE_SHOOTRANGE);
	registerEnum(L, ITEM_ATTRIBUTE_OWNER);
	registerEnum(L, ITEM_ATTRIBUTE_DURATION);
	registerEnum(L, ITEM_ATTRIBUTE_DECAYSTATE);
	registerEnum(L, ITEM_ATTRIBUTE_CORPSEOWNER);
	registerEnum(L, ITEM_ATTRIBUTE_CHARGES);
	registerEnum(L, ITEM_ATTRIBUTE_FLUIDTYPE);
	registerEnum(L, ITEM_ATTRIBUTE_DOORID);
	registerEnum(L, ITEM_ATTRIBUTE_SPECIAL);
	registerEnum(L, ITEM_ATTRIBUTE_OPENCONTAINER);
	registerEnum(L, ITEM_ATTRIBUTE_QUICKLOOTCONTAINER);
	registerEnum(L, ITEM_ATTRIBUTE_DURATION_TIMESTAMP);
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

void LuaEnums::initItemIdEnums(lua_State* L) {
	registerEnum(L, ITEM_BAG);
	registerEnum(L, ITEM_SHOPPING_BAG);
	registerEnum(L, ITEM_GOLD_COIN);
	registerEnum(L, ITEM_PLATINUM_COIN);
	registerEnum(L, ITEM_CRYSTAL_COIN);
	registerEnum(L, ITEM_REWARD_CHEST);
	registerEnum(L, ITEM_REWARD_CONTAINER);
	registerEnum(L, ITEM_AMULETOFLOSS);
	registerEnum(L, ITEM_PARCEL);
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

	registerEnum(L, ITEM_FORGE_SLIVER);
	registerEnum(L, ITEM_FORGE_CORE);
}

void LuaEnums::initPlayerFlagEnums(lua_State* L) {
	registerEnum(L, PlayerFlag_CannotUseCombat);
	registerEnum(L, PlayerFlag_CannotAttackPlayer);
	registerEnum(L, PlayerFlag_CannotAttackMonster);
	registerEnum(L, PlayerFlag_CannotBeAttacked);
	registerEnum(L, PlayerFlag_CanConvinceAll);
	registerEnum(L, PlayerFlag_CanSummonAll);
	registerEnum(L, PlayerFlag_CanIllusionAll);
	registerEnum(L, PlayerFlag_CanSenseInvisibility);
	registerEnum(L, PlayerFlag_IgnoredByMonsters);
	registerEnum(L, PlayerFlag_NotGainInFight);
	registerEnum(L, PlayerFlag_HasInfiniteMana);
	registerEnum(L, PlayerFlag_HasInfiniteSoul);
	registerEnum(L, PlayerFlag_HasNoExhaustion);
	registerEnum(L, PlayerFlag_CannotUseSpells);
	registerEnum(L, PlayerFlag_CannotPickupItem);
	registerEnum(L, PlayerFlag_CanAlwaysLogin);
	registerEnum(L, PlayerFlag_CanBroadcast);
	registerEnum(L, PlayerFlag_CanEditHouses);
	registerEnum(L, PlayerFlag_CannotBeBanned);
	registerEnum(L, PlayerFlag_CannotBePushed);
	registerEnum(L, PlayerFlag_HasInfiniteCapacity);
	registerEnum(L, PlayerFlag_CanPushAllCreatures);
	registerEnum(L, PlayerFlag_CanTalkRedPrivate);
	registerEnum(L, PlayerFlag_CanTalkRedChannel);
	registerEnum(L, PlayerFlag_TalkOrangeHelpChannel);
	registerEnum(L, PlayerFlag_NotGainExperience);
	registerEnum(L, PlayerFlag_NotGainMana);
	registerEnum(L, PlayerFlag_NotGainHealth);
	registerEnum(L, PlayerFlag_NotGainSkill);
	registerEnum(L, PlayerFlag_SetMaxSpeed);
	registerEnum(L, PlayerFlag_SpecialVIP);
	registerEnum(L, PlayerFlag_NotGenerateLoot);
	registerEnum(L, PlayerFlag_CanTalkRedChannelAnonymous);
	registerEnum(L, PlayerFlag_IgnoreProtectionZone);
	registerEnum(L, PlayerFlag_IgnoreSpellCheck);
	registerEnum(L, PlayerFlag_IgnoreWeaponCheck);
	registerEnum(L, PlayerFlag_CannotBeMuted);
	registerEnum(L, PlayerFlag_IsAlwaysPremium);

	registerEnum(L, PlayerCustomFlag_CanMapClickTeleport);
	registerEnum(L, PlayerCustomFlag_IgnoredByNpcs);
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
	registerEnum(L, RETURNVALUE_NOTPOSSIBLE);
	registerEnum(L, RETURNVALUE_NOTENOUGHROOM);
	registerEnum(L, RETURNVALUE_PLAYERISPZLOCKED);
	registerEnum(L, RETURNVALUE_PLAYERISNOTINVITED);
	registerEnum(L, RETURNVALUE_CANNOTTHROW);
	registerEnum(L, RETURNVALUE_THEREISNOWAY);
	registerEnum(L, RETURNVALUE_DESTINATIONOUTOFREACH);
	registerEnum(L, RETURNVALUE_CREATUREBLOCK);
	registerEnum(L, RETURNVALUE_NOTMOVEABLE);
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
}

// Reload
void LuaEnums::initReloadTypeEnums(lua_State* L) {
	registerEnumClass(L, Reload_t::RELOAD_TYPE_ALL);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_CHAT);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_CONFIG);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_EVENTS);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_CORE);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_IMBUEMENTS);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_ITEMS);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_MODULES);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_MONSTERS);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_MOUNTS);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_NPCS);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_RAIDS);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_SCRIPTS);
	registerEnumClass(L, Reload_t::RELOAD_TYPE_TALKACTION);
}

void LuaEnums::initCreaturesEventEnums(lua_State* L) {
	// Monsters
	registerEnum(L, MONSTERS_EVENT_THINK);
	registerEnum(L, MONSTERS_EVENT_APPEAR);
	registerEnum(L, MONSTERS_EVENT_DISAPPEAR);
	registerEnum(L, MONSTERS_EVENT_MOVE);
	registerEnum(L, MONSTERS_EVENT_SAY);

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
	registerEnumClass(L, ForgeClassifications_t::FORGE_NORMAL_MONSTER);
	registerEnumClass(L, ForgeClassifications_t::FORGE_INFLUENCED_MONSTER);
	registerEnumClass(L, ForgeClassifications_t::FORGE_FIENDISH_MONSTER);
}

// Webhook default colors
void LuaEnums::initWebhookEnums(lua_State* L) {
	registerEnum(L, WEBHOOK_COLOR_ONLINE);
	registerEnum(L, WEBHOOK_COLOR_OFFLINE);
	registerEnum(L, WEBHOOK_COLOR_WARNING);
	registerEnum(L, WEBHOOK_COLOR_RAID);
}

// Webhook default colors
void LuaEnums::initSoundEnums(lua_State* L) {
	registerEnum(L, SOUND_EFFECT_TYPE_SILENCE);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMAN_CLOSE_ATK_FIST);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_CLOSE_ATK_FIST);
	registerEnum(L, SOUND_EFFECT_TYPE_MELEE_ATK_SWORD);
	registerEnum(L, SOUND_EFFECT_TYPE_MELEE_ATK_CLUB);
	registerEnum(L, SOUND_EFFECT_TYPE_MELEE_ATK_AXE);
	registerEnum(L, SOUND_EFFECT_TYPE_DIST_ATK_BOW);
	registerEnum(L, SOUND_EFFECT_TYPE_DIST_ATK_CROSSBOW);
	registerEnum(L, SOUND_EFFECT_TYPE_DIST_ATK_THROW);
	registerEnum(L, SOUND_EFFECT_TYPE_MAGICAL_RANGE_ATK);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_OR_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_OTHER);
	registerEnum(L, SOUND_EFFECT_TYPE_PHYSICAL_RANGE_MISS);
	registerEnum(L, SOUND_EFFECT_TYPE_DIST_ATK_BOW_SHOT);
	registerEnum(L, SOUND_EFFECT_TYPE_DIST_ATK_CROSSBOW_SHOT);
	registerEnum(L, SOUND_EFFECT_TYPE_DIST_ATK_THROW_SHOT);
	registerEnum(L, SOUND_EFFECT_TYPE_DIST_ATK_ROD_SHOT);
	registerEnum(L, SOUND_EFFECT_TYPE_DIST_ATK_WAND_SHOT);
	registerEnum(L, SOUND_EFFECT_TYPE_BURST_ARROW_EFFECT);
	registerEnum(L, SOUND_EFFECT_TYPE_DIAMOND_ARROW_EFFECT);
	registerEnum(L, SOUND_EFFECT_TYPE_NO_DAMAGE);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_FIST);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_CLAW);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_BITE);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_RIP);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_ACID);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_MAGIC);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_ETHEREAL);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_CONSTRUCT);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_LIGHT_HEALING);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_INTENSE_HEALING);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ULTIMATE_HEALING);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_INTENSE_HEALING_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ULTIMATE_HEALING_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_HASTE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_LIGHT_MAGIC_MISSILE_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_HEAVY_MAGIC_MISSILE_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_SUMMON_CREATURE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_LIGHT);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_GREAT_LIGHT);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CONVINCE_CREATURE_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ENERGY_WAVE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CHAMELEON_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_FIREBALL_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_GREAT_FIREBALL_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_FIRE_BOMB_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_EXPLOSION_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_FIRE_WAVE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_FIND_PERSON);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_SUDDENDEATH_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ENERGY_BEAM);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_GREAT_ENERGY_BEAM);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_HELL_SCORE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_FIRE_FIELD_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_POISON_FIELD_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ENERGY_FIELD_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_FIRE_WALL_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CURE_POISON);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_DESTROY_FIELD_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CURE_POISON_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_POISON_WALL_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ENERGY_WALL_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_SALVATION);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CREATURE_ILLUSION);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_STRONG_HASTE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_FOOD);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_STRONG_ICE_WAVE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_MAGIC_SHIELD);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_INVISIBLE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CONJURE_EXPLOSIVE_ARROW);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_SOUL_FIRE_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CONJURE_ARROW);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_PARALYSE_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ENERGY_BOMB_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_WRATH_OF_NATURE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_STRONG_ETHEREAL_SPEAR);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_FRONT_SWEEP);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_BRUTAL_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ANNIHILATION);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_INVITE_GUESTS);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_INVITE_SUBOWNERS);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_KICK_GUEST);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_EDIT_DOOR);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ULTIMATE_LIGHT);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_MAGIC_ROPE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_STALAGMITE_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_DISINTEGRATE_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_BERSERK);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_LEVITATE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_MASS_HEALING);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ANIMATE_DEAD_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_HEAL_FRIEND);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_UNDEAD_LEGION);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_MAGIC_WALL_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_DEATH_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ENERGY_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_FLAME_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CANCEL_INVISIBILITY);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_POISON_BOMB_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CONJURE_WAND_OF_DARKNESS);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CHALLENGE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_WILD_GROWTH_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_FIERCE_BERSERK);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_GROUNDSHAKER);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_WHIRLWIND_THROW);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ENCHANT_SPEAR);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ETHEREAL_SPEAR);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ICE_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_TERRA_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ICICLE_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_AVALANCHE_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_STONE_SHOWER_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_THUNDERSTORM_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ETERNAL_WINTER);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_RAGE_OF_THE_SKIES);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_TERRA_WAVE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ICE_WAVE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_DIVINE_MISSILE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_WOUND_CLEANSING);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_DIVINE_CALDERA);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_DIVINE_HEALING);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_TRAIN_PARTY);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_PROTECT_PARTY);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_HEAL_PARTY);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ENCHANT_PARTY);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_HOLY_MISSILE_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CHARGE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_PROTECTOR);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_BLOOD_RAGE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_SWIFT_FOOT);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_SHARPSHOOTER);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_IGNITE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CURSE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ELECTRIFY);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_INFLICT_WOUND);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ENVENOM);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_HOLY_FLASH);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CURE_BLEEDING);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CURE_BURNING);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CURE_ELECTRIFICATION);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CURE_CURSE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_PHYSICAL_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_LIGHTNING);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_STRONG_FLAME_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_STRONG_ENERGY_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_STRONG_ICE_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_STRONG_TERRA_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ULTIMATE_FLAME_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ULTIMATE_ENERGY_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ULTIMATE_ICE_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ULTIMATE_TERRA_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_INTENSE_WOUND_CLEANSING);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_RECOVERY);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_INTENSE_RECOVERY);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_PRACTISE_HEALING);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_PRACTISE_FIRE_WAVE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_PRACTISE_MAGIC_MISSILE_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_APPRENT_ICES_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_MUD_ATTACK);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CHILL_OUT);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_MAGIC_PATCH);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_BRUISE_BANE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_ARROW_CALL);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_BUZZ);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_SCORCH);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_LIGHTEST_MISSILE_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_LIGHT_STONE_SHOWER_RUNE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_SUMMON_KNIGHT_FAMILIAR);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_SUMMON_PALADIN_FAMILIAR);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_SUMMON_SORCERER_FAMILIAR);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_SUMMON_DRUID_FAMILIAR);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CHIVALROUS_CHALLENGE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_DIVINE_DAZZLE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_FAIR_WOUND_CLEANSING);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_GREAT_FIRE_WAVE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_RESTORATION);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_NATURES_EMBRACE);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_EXPOSE_WEAKNESS);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_SAP_STRENGTH);
	registerEnum(L, SOUND_EFFECT_TYPE_SPELL_CANCEL_MAGIC_SHIELD);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_FIRE);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_ENERGY);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_EARTH);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_ICE);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_HOLY);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_HIT);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_LIFEDRAIN);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_MANADRAIN);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_DROWNING);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_BLEEDING);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_HEALING);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_FIRE);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_ENERGY);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_EARTH);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_ICE);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_HOLY);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_HIT);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_LIFEDRAIN);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_MANADRAIN);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_DROWNING);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_BLEEDING);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_HEALING);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREA_FIRE);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREA_ENERGY);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREA_EARTH);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREA_ICE);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREA_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREA_HOLY);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREA_HIT);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREA_LIFEDRAIN);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREA_MANADRAIN);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREA_DROWNING);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREA_BLEEDING);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREA_HEALING);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_FIRE);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_ENERGY);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_EARTH);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_ICE);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_HOLY);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_HIT);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_LIFEDRAIN);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_MANADRAIN);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_DROWNING);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_BLEEDING);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_HEALING);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_DELETEFIELD);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_CHALLENGE);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SPEED);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_DRUNKEN);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_STRENGTH);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_OUTFIT);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SUMMON);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_MAGICLEVEL);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_TELEPORT);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_HEX);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_SUPER_DRUNKEN);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_ROOT);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_FEAR);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_HIGHRISK_TELEPORT);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_MINION);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_SPELL_AGONY);
	registerEnum(L, SOUND_EFFECT_TYPE_AMPHIBIC_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_AQUATIC_BEAST_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_AQUATIC_CRITTER_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_AQUATIC_DEEPLING_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_AQUATIC_QUARA_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_BIRD_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_CONSTRUCT_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_DEMON_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_DRAGON_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_ELEMENTAL_EARTH_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_ELEMENTAL_ENERGY_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_ELEMENTAL_FIRE_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_ELEMENTAL_WATER_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_EXTRA_DIMENSIONAL_BEAST_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_EXTRA_DIMENSIONAL_ENERGY_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_EXTRA_DIMENSIONAL_HORROR_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_FEY_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_GIANT_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMAN_FEMALE_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMAN_MALE_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMANOID_GOBLIN_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMANOID_ORC_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_LYCANTHROPE_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_MAGICAL_ENERGY_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_MAGICAL_HORROR_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_BEAR_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_CRITTER_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_DOG_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_ELEPHANT_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_FERAL_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_HORSE_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_MAMMOTH_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_PHANTOM_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_PLANT_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_REPTILE_LARGE_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_REPTILE_SMALL_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_SLIME_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_UNDEAD_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_VERMIN_CRITTER_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_VERMIN_INSECT_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_VERMIN_ROTWORM_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMAN_SAGE_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMAN_CRONE_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_APE_BARK);
	registerEnum(L, SOUND_EFFECT_TYPE_AMPHIBIC_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_AQUATIC_BEAST_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_AQUATIC_CRITTER_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_AQUATIC_DEEPLING_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_AQUATIC_QUARA_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_BIRD_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_CONSTRUCT_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_DEMON_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_DRAGON_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_ELEMENTAL_EARTH_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_ELEMENTAL_ENERGY_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_ELEMENTAL_FIRE_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_ELEMENTAL_WATER_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_EXTRA_DIMENSIONAL_BEAST_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_EXTRA_DIMENSIONAL_ENERGY_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_EXTRA_DIMENSIONAL_HORROR_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_FEY_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_GIANT_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMAN_FEMALE_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMAN_MALE_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMANOID_GOBLIN_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMANOID_ORC_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_LYCANTHROPE_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MAGICAL_ENERGY_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MAGICAL_HORROR_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_BEAR_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_CRITTER_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_DOG_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_ELEPHANT_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_FERAL_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_HORSE_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MAMMAL_MAMMOTH_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_MONSTER_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_PHANTOM_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_PLANT_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_REPTILE_LARGE_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_REPTILE_SMALL_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_SLIME_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_UNDEAD_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_VERMIN_CRITTER_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_VERMIN_INSECT_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_VERMIN_ROTWORM_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMAN_SAGE_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_HUMAN_CRONE_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_APE_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_1);
	registerEnum(L, SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_2);
	registerEnum(L, SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_3);
	registerEnum(L, SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_4);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_HEAVY_METAL_LOUD);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_INSECTS_BIRDS);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WIND_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WIND_CLOSE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WATER_DEPTH_BOAT_SURFACE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_METALIC_SPACE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_FROGS_INSECTS_WOODS);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WATER_DEPTH);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_SEA_WAVE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WIND_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WIND_3);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_MONKEYS);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_STORM_COMING);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_HITTING_WOOD);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WOOD_STICK_SMASH);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_THICK_BLOB_LIQUID_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_LITTLE_BIRTS_FLOREST);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_THICK_BLOCK_LIQUID_CLOSE);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_METAL_CHAINS_MOVING);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CRICKET_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CRICKET_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CRICKET_3);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CICADA_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_STONES_FALLING);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_OPEN_DOOR);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_CLOSE_DOOR);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_OWL);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_ELETRONIC_DEVICE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_REPTILE_NOISE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_FORGE_METAL_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_FROG);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_WOOD_OBJECT_USING);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_METAL_OBJECT_HIT);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_NAIL_HIT);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_BELL_RING);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_HOT_METAL_ON_WATER);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WATER_SMOKE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WOLF_HOWL);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WOOD_CRACKLE_CLOSE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_LAUGHT);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WIND_MOVING_LEAF);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WIND_MOVING_FEW_LEAF);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_PORTAL_CAST);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_FIRE_MAGIC_CAST);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_TRAPDOOR_OPEN);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_NAIL_FALLING);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_LIGHT_BLOB_LIQUID);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_LION_ROAR);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_MOVING_OBJECT_BUTTON_TRIGGER);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_SNAKE_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_HUMAN_SCREEN_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_HUMAN_SCREEN_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_SEAGUL_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_FAST_FOOTSTEPS);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_SLOW_FOOTSTEPS);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_THICK_BLOB_LIQUID_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_MOVING_LEAF);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WOOD_CRACKLE_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_OBJECT_FALLING_DEPTH);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_BUTTON_TRIGGER);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_HEAVEN_DARK_REVERB);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WIND_4);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_INSECT_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_FLUTE_SONG);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_INSECTS_BIRDS_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_INSECT_CREATURE_DEATH);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_LOW_ROAR);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_SINISTER_BURPH);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CROWD_SCREEN);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_BIRDS_FLYING);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CROWD_VOICES_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_BIRD_CUCO);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_RAVINE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_RAVINE_METALIC);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_STICKS_LEAF_STEP);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_DISPEL_MAGIC_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_DISPEL_MAGIC_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CROWD_VOICES_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CROWD_VOICES_3);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CROWD_VOICES_4);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_METAL_OBJECT_FALL);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_HOURSE_STEPS);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_DRUMES_SINISTER_REVERB);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_WOOD_PIECES_FALL);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_KNIFE_CUT_FLESH);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CROWD_VOICES_5);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CICADA_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_FLYES);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_NOISE_WATER);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_PIG_SOUND_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_PIG_SOUND_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_SHEEP_SOUND_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_SHEEP_SOUND_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_FIRE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_NOISE_SNOW);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_FIRE_PLACE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WATERFALL);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WATER_SOURCE);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_HAMMER_HITING_NAILS_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_HAMMER_HITING_NAILS_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_QUICK_STEPS);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_HEAVY_OBJECT_FALL);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_HITING_FORGE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WOOD_CRACKLE_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_WOOD_HIT);
	registerEnum(L, SOUND_EFFECT_TYPE_MUSIC_CUT_BIRDS);
	registerEnum(L, SOUND_EFFECT_TYPE_MUSIC_CUT_LITTLE_BIRDS);
	registerEnum(L, SOUND_EFFECT_TYPE_MUSIC_CUT_INSECTS_1);
	registerEnum(L, SOUND_EFFECT_TYPE_MUSIC_CUT_INSECTS_2);
	registerEnum(L, SOUND_EFFECT_TYPE_MUSIC_CUT_INSECTS_3);
	registerEnum(L, SOUND_EFFECT_TYPE_MUSIC_CUT_FLUTE_WEST);
	registerEnum(L, SOUND_EFFECT_TYPE_MUSIC_CUT_CROWS_VOICES);
	registerEnum(L, SOUND_EFFECT_TYPE_MUSIC_CUT_WIND_WATER);
	registerEnum(L, SOUND_EFFECT_TYPE_MUSIC_CUT_THICK_BLOCK_DEPTH);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CAMEL);
	registerEnum(L, SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_5);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CHICKEN_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CHICKEN_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_THRILLER_METALLIC);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_NOTIFICATION);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_LEVEL_ACHIEVEMENT);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_SCREENSHOT);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_CLICK_ON);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_CLICK_OFF);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_DRUMS);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_XYLOPHONE_SLOW_DRUM);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_HARP_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_HARP_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_MOVING_WOOD);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_CRATE_BREAK_MAGIC_DUST);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_BELL_RING);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_SELECT_OBJECT);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_BACKPACK);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_USE_POTION);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_NECKLACES);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_ARMORS);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_METALIC);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_DISTANCE);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_WOOD);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_STACKABLE);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_DEFAULT);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_LEGS);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_HELMETS);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_QUIVERS);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_RINGS);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_FROG_OR_LIQUID);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_WOOD_OBJECT_HIT_STORE);
	registerEnum(L, SOUND_EFFECT_TYPE_ITEM_MOVE_BOOTS);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_SWORD_DRAWN);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_EAT);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_STORE_BIG_OBJECT);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_STORE_WOOD_OBJECT);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_VIP_LOGOUT);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_VIP_LOGIN);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CAT_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_INSECT_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_SEAGUL_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_LIQUID_SPILL);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_COW_MOO_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_COW_MOO_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_CAT_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_REAWRD_FEY);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_REWARD_GUITAR_1);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_REWARD_GUITAR_2);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WOODS_WATER_SOURCE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_HYENA);
	registerEnum(L, SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_6);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_COW_MOO_3);
	registerEnum(L, SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_7);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_METALIC_SPACE_ALIEN);
	registerEnum(L, SOUND_EFFECT_TYPE_ACTION_AIR_STRIKE);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_WATER);
	registerEnum(L, SOUND_EFFECT_TYPE_ENV_SNAKE_2);
	registerEnum(L, SOUND_EFFECT_TYPE_GOD_SPELL_KILL_ALL_MONSTERS);
}
