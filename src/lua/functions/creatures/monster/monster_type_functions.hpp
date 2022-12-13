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

#ifndef SRC_LUA_FUNCTIONS_CREATURES_MONSTER_MONSTER_TYPE_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_MONSTER_MONSTER_TYPE_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class MonsterTypeFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerClass(L, "MonsterType", "", MonsterTypeFunctions::luaMonsterTypeCreate);
		registerMetaMethod(L, "MonsterType", "__eq", MonsterTypeFunctions::luaUserdataCompare);

		registerMethod(L, "MonsterType", "isAttackable", MonsterTypeFunctions::luaMonsterTypeIsAttackable);
		registerMethod(L, "MonsterType", "isConvinceable", MonsterTypeFunctions::luaMonsterTypeIsConvinceable);
		registerMethod(L, "MonsterType", "isSummonable", MonsterTypeFunctions::luaMonsterTypeIsSummonable);
		registerMethod(L, "MonsterType", "isIllusionable", MonsterTypeFunctions::luaMonsterTypeIsIllusionable);
		registerMethod(L, "MonsterType", "isHostile", MonsterTypeFunctions::luaMonsterTypeIsHostile);
		registerMethod(L, "MonsterType", "isPushable", MonsterTypeFunctions::luaMonsterTypeIsPushable);
		registerMethod(L, "MonsterType", "isHealthHidden", MonsterTypeFunctions::luaMonsterTypeIsHealthHidden);
		registerMethod(L, "MonsterType", "isBlockable", MonsterTypeFunctions::luaMonsterTypeIsBlockable);
		registerMethod(L, "MonsterType", "isForgeCreature", MonsterTypeFunctions::luaMonsterTypeIsForgeCreature);

		registerMethod(L, "MonsterType", "familiar", MonsterTypeFunctions::luaMonsterTypeFamiliar);
		registerMethod(L, "MonsterType", "isRewardBoss", MonsterTypeFunctions::luaMonsterTypeIsRewardBoss);

		registerMethod(L, "MonsterType", "canSpawn", MonsterTypeFunctions::luaMonsterTypeCanSpawn);

		registerMethod(L, "MonsterType", "canPushItems", MonsterTypeFunctions::luaMonsterTypeCanPushItems);
		registerMethod(L, "MonsterType", "canPushCreatures", MonsterTypeFunctions::luaMonsterTypeCanPushCreatures);

		registerMethod(L, "MonsterType", "name", MonsterTypeFunctions::luaMonsterTypeName);

		registerMethod(L, "MonsterType", "nameDescription", MonsterTypeFunctions::luaMonsterTypeNameDescription);

		registerMethod(L, "MonsterType", "getCorpseId", MonsterTypeFunctions::luaMonsterTypegetCorpseId);

		registerMethod(L, "MonsterType", "health", MonsterTypeFunctions::luaMonsterTypeHealth);
		registerMethod(L, "MonsterType", "maxHealth", MonsterTypeFunctions::luaMonsterTypeMaxHealth);
		registerMethod(L, "MonsterType", "runHealth", MonsterTypeFunctions::luaMonsterTypeRunHealth);
		registerMethod(L, "MonsterType", "experience", MonsterTypeFunctions::luaMonsterTypeExperience);

		registerMethod(L, "MonsterType", "faction", MonsterTypeFunctions::luaMonsterTypeFaction);
		registerMethod(L, "MonsterType", "enemyFactions", MonsterTypeFunctions::luaMonsterTypeEnemyFactions);
		registerMethod(L, "MonsterType", "targetPreferPlayer", MonsterTypeFunctions::luaMonsterTypeTargetPreferPlayer);
		registerMethod(L, "MonsterType", "targetPreferMaster", MonsterTypeFunctions::luaMonsterTypeTargetPreferMaster);

		registerMethod(L, "MonsterType", "raceId", MonsterTypeFunctions::luaMonsterTypeRaceid);
		registerMethod(L, "MonsterType", "Bestiaryclass", MonsterTypeFunctions::luaMonsterTypeBestiaryclass);
		registerMethod(L, "MonsterType", "BestiaryOccurrence", MonsterTypeFunctions::luaMonsterTypeBestiaryOccurrence);
		registerMethod(L, "MonsterType", "BestiaryLocations", MonsterTypeFunctions::luaMonsterTypeBestiaryLocations);
		registerMethod(L, "MonsterType", "BestiaryStars", MonsterTypeFunctions::luaMonsterTypeBestiaryStars);
		registerMethod(L, "MonsterType", "BestiaryCharmsPoints", MonsterTypeFunctions::luaMonsterTypeBestiaryCharmsPoints);
		registerMethod(L, "MonsterType", "BestiarySecondUnlock", MonsterTypeFunctions::luaMonsterTypeBestiarySecondUnlock);
		registerMethod(L, "MonsterType", "BestiaryFirstUnlock", MonsterTypeFunctions::luaMonsterTypeBestiaryFirstUnlock);
		registerMethod(L, "MonsterType", "BestiarytoKill", MonsterTypeFunctions::luaMonsterTypeBestiarytoKill);
		registerMethod(L, "MonsterType", "Bestiaryrace", MonsterTypeFunctions::luaMonsterTypeBestiaryrace);

		registerMethod(L, "MonsterType", "combatImmunities", MonsterTypeFunctions::luaMonsterTypeCombatImmunities);
		registerMethod(L, "MonsterType", "conditionImmunities", MonsterTypeFunctions::luaMonsterTypeConditionImmunities);

		registerMethod(L, "MonsterType", "getAttackList", MonsterTypeFunctions::luaMonsterTypeGetAttackList);
		registerMethod(L, "MonsterType", "addAttack", MonsterTypeFunctions::luaMonsterTypeAddAttack);

		registerMethod(L, "MonsterType", "getDefenseList", MonsterTypeFunctions::luaMonsterTypeGetDefenseList);
		registerMethod(L, "MonsterType", "addDefense", MonsterTypeFunctions::luaMonsterTypeAddDefense);

		registerMethod(L, "MonsterType", "getTypeName", MonsterTypeFunctions::luaMonsterTypeGetTypeName);

		registerMethod(L, "MonsterType", "getElementList", MonsterTypeFunctions::luaMonsterTypeGetElementList);
		registerMethod(L, "MonsterType", "addElement", MonsterTypeFunctions::luaMonsterTypeAddElement);

		registerMethod(L, "MonsterType", "addReflect", MonsterTypeFunctions::luaMonsterTypeAddReflect);
		registerMethod(L, "MonsterType", "addHealing", MonsterTypeFunctions::luaMonsterTypeAddHealing);

		registerMethod(L, "MonsterType", "getVoices", MonsterTypeFunctions::luaMonsterTypeGetVoices);
		registerMethod(L, "MonsterType", "addVoice", MonsterTypeFunctions::luaMonsterTypeAddVoice);

		registerMethod(L, "MonsterType", "getLoot", MonsterTypeFunctions::luaMonsterTypeGetLoot);
		registerMethod(L, "MonsterType", "addLoot", MonsterTypeFunctions::luaMonsterTypeAddLoot);

		registerMethod(L, "MonsterType", "getCreatureEvents", MonsterTypeFunctions::luaMonsterTypeGetCreatureEvents);
		registerMethod(L, "MonsterType", "registerEvent", MonsterTypeFunctions::luaMonsterTypeRegisterEvent);

		registerMethod(L, "MonsterType", "eventType", MonsterTypeFunctions::luaMonsterTypeEventType);
		registerMethod(L, "MonsterType", "onThink", MonsterTypeFunctions::luaMonsterTypeEventOnCallback);
		registerMethod(L, "MonsterType", "onAppear", MonsterTypeFunctions::luaMonsterTypeEventOnCallback);
		registerMethod(L, "MonsterType", "onDisappear", MonsterTypeFunctions::luaMonsterTypeEventOnCallback);
		registerMethod(L, "MonsterType", "onMove", MonsterTypeFunctions::luaMonsterTypeEventOnCallback);
		registerMethod(L, "MonsterType", "onSay", MonsterTypeFunctions::luaMonsterTypeEventOnCallback);

		registerMethod(L, "MonsterType", "getSummonList", MonsterTypeFunctions::luaMonsterTypeGetSummonList);
		registerMethod(L, "MonsterType", "addSummon", MonsterTypeFunctions::luaMonsterTypeAddSummon);

		registerMethod(L, "MonsterType", "maxSummons", MonsterTypeFunctions::luaMonsterTypeMaxSummons);

		registerMethod(L, "MonsterType", "armor", MonsterTypeFunctions::luaMonsterTypeArmor);
		registerMethod(L, "MonsterType", "defense", MonsterTypeFunctions::luaMonsterTypeDefense);
		registerMethod(L, "MonsterType", "outfit", MonsterTypeFunctions::luaMonsterTypeOutfit);
		registerMethod(L, "MonsterType", "race", MonsterTypeFunctions::luaMonsterTypeRace);
		registerMethod(L, "MonsterType", "corpseId", MonsterTypeFunctions::luaMonsterTypeCorpseId);
		registerMethod(L, "MonsterType", "manaCost", MonsterTypeFunctions::luaMonsterTypeManaCost);
		registerMethod(L, "MonsterType", "baseSpeed", MonsterTypeFunctions::luaMonsterTypeBaseSpeed);
		registerMethod(L, "MonsterType", "light", MonsterTypeFunctions::luaMonsterTypeLight);

		registerMethod(L, "MonsterType", "staticAttackChance", MonsterTypeFunctions::luaMonsterTypeStaticAttackChance);
		registerMethod(L, "MonsterType", "targetDistance", MonsterTypeFunctions::luaMonsterTypeTargetDistance);
		registerMethod(L, "MonsterType", "yellChance", MonsterTypeFunctions::luaMonsterTypeYellChance);
		registerMethod(L, "MonsterType", "yellSpeedTicks", MonsterTypeFunctions::luaMonsterTypeYellSpeedTicks);
		registerMethod(L, "MonsterType", "changeTargetChance", MonsterTypeFunctions::luaMonsterTypeChangeTargetChance);
		registerMethod(L, "MonsterType", "changeTargetSpeed", MonsterTypeFunctions::luaMonsterTypeChangeTargetSpeed);

		registerMethod(L, "MonsterType", "canWalkOnEnergy",
				  MonsterTypeFunctions::luaMonsterTypeCanWalkOnEnergy);
		registerMethod(L, "MonsterType", "canWalkOnFire",
				  MonsterTypeFunctions::luaMonsterTypeCanWalkOnFire);
		registerMethod(L, "MonsterType", "canWalkOnPoison",
				  MonsterTypeFunctions::luaMonsterTypeCanWalkOnPoison);

		registerMethod(L, "MonsterType", "strategiesTargetNearest",
				  MonsterTypeFunctions::luaMonsterTypeStrategiesTargetNearest);
		registerMethod(L, "MonsterType", "strategiesTargetHealth",
				  MonsterTypeFunctions::luaMonsterTypeStrategiesTargetHealth);
		registerMethod(L, "MonsterType", "strategiesTargetDamage",
				  MonsterTypeFunctions::luaMonsterTypeStrategiesTargetDamage);
		registerMethod(L, "MonsterType", "strategiesTargetRandom",
				  MonsterTypeFunctions::luaMonsterTypeStrategiesTargetRandom);

		registerMethod(L, "MonsterType", "respawnTypePeriod", MonsterTypeFunctions::luaMonsterTypeRespawnTypePeriod);
		registerMethod(L, "MonsterType", "respawnTypeIsUnderground", MonsterTypeFunctions::luaMonsterTypeRespawnTypeIsUnderground);

		registerMethod(L, "MonsterType", "soundChance", MonsterTypeFunctions::luaMonsterTypeSoundChance);
		registerMethod(L, "MonsterType", "soundSpeedTicks", MonsterTypeFunctions::luaMonsterTypeSoundSpeedTicks);
		registerMethod(L, "MonsterType", "addSound", MonsterTypeFunctions::luaMonsterTypeAddSound);
		registerMethod(L, "MonsterType", "getSounds", MonsterTypeFunctions::luaMonsterTypeGetSounds);
		registerMethod(L, "MonsterType", "deathSound", MonsterTypeFunctions::luaMonsterTypedeathSound);
	}

private:
	static void createMonsterTypeLootLuaTable(lua_State* L, const std::vector<LootBlock>& lootList);

	static int luaMonsterTypeCreate(lua_State* L);

	static int luaMonsterTypeIsAttackable(lua_State* L);
	static int luaMonsterTypeIsConvinceable(lua_State* L);
	static int luaMonsterTypeIsSummonable(lua_State* L);
	static int luaMonsterTypeIsIllusionable(lua_State* L);
	static int luaMonsterTypeIsHostile(lua_State* L);
	static int luaMonsterTypeIsPushable(lua_State* L);
	static int luaMonsterTypeIsHealthHidden(lua_State* L);
	static int luaMonsterTypeIsBlockable(lua_State* L);
	static int luaMonsterTypeIsForgeCreature(lua_State* L);

	static int luaMonsterTypeFamiliar(lua_State* L);
	static int luaMonsterTypeIsRewardBoss(lua_State* L);
	static int luaMonsterTypeRespawnType(lua_State* L);
	static int luaMonsterTypeCanSpawn(lua_State* L);

	static int luaMonsterTypeCanPushItems(lua_State* L);
	static int luaMonsterTypeCanPushCreatures(lua_State* L);

	static int luaMonsterTypeName(lua_State* L);
	static int luaMonsterTypeNameDescription(lua_State* L);

	static int luaMonsterTypegetCorpseId(lua_State* L);

	static int luaMonsterTypeHealth(lua_State* L);
	static int luaMonsterTypeMaxHealth(lua_State* L);
	static int luaMonsterTypeRunHealth(lua_State* L);
	static int luaMonsterTypeExperience(lua_State* L);

	static int luaMonsterTypeFaction(lua_State* L);
	static int luaMonsterTypeEnemyFactions(lua_State* L);
	static int luaMonsterTypeTargetPreferPlayer(lua_State* L);
	static int luaMonsterTypeTargetPreferMaster(lua_State* L);

	static int luaMonsterTypeRaceid(lua_State* L);
	static int luaMonsterTypeBestiaryclass(lua_State* L);
	static int luaMonsterTypeBestiaryOccurrence(lua_State* L);
	static int luaMonsterTypeBestiaryLocations(lua_State* L);
	static int luaMonsterTypeBestiaryStars(lua_State* L);
	static int luaMonsterTypeBestiaryCharmsPoints(lua_State* L);
	static int luaMonsterTypeBestiarySecondUnlock(lua_State* L);
	static int luaMonsterTypeBestiaryFirstUnlock(lua_State* L);
	static int luaMonsterTypeBestiarytoKill(lua_State* L);
	static int luaMonsterTypeBestiaryrace(lua_State* L);

	static int luaMonsterTypeCombatImmunities(lua_State* L);
	static int luaMonsterTypeConditionImmunities(lua_State* L);

	static int luaMonsterTypeGetAttackList(lua_State* L);
	static int luaMonsterTypeAddAttack(lua_State* L);

	static int luaMonsterTypeGetDefenseList(lua_State* L);
	static int luaMonsterTypeAddDefense(lua_State* L);

	static int luaMonsterTypeGetTypeName(lua_State* L);

	static int luaMonsterTypeGetElementList(lua_State* L);
	static int luaMonsterTypeAddElement(lua_State* L);

	static int luaMonsterTypeAddReflect(lua_State* L);
	static int luaMonsterTypeAddHealing(lua_State* L);

	static int luaMonsterTypeGetVoices(lua_State* L);
	static int luaMonsterTypeAddVoice(lua_State* L);

	static int luaMonsterTypeGetLoot(lua_State* L);
	static int luaMonsterTypeAddLoot(lua_State* L);

	static int luaMonsterTypeGetCreatureEvents(lua_State* L);
	static int luaMonsterTypeRegisterEvent(lua_State* L);

	static int luaMonsterTypeEventOnCallback(lua_State* L);
	static int luaMonsterTypeEventType(lua_State* L);

	static int luaMonsterTypeGetSummonList(lua_State* L);
	static int luaMonsterTypeAddSummon(lua_State* L);

	static int luaMonsterTypeMaxSummons(lua_State* L);

	static int luaMonsterTypeArmor(lua_State* L);
	static int luaMonsterTypeDefense(lua_State* L);
	static int luaMonsterTypeOutfit(lua_State* L);
	static int luaMonsterTypeRace(lua_State* L);
	static int luaMonsterTypeCorpseId(lua_State* L);
	static int luaMonsterTypeManaCost(lua_State* L);
	static int luaMonsterTypeBaseSpeed(lua_State* L);
	static int luaMonsterTypeLight(lua_State* L);

	static int luaMonsterTypeStaticAttackChance(lua_State* L);
	static int luaMonsterTypeTargetDistance(lua_State* L);
	static int luaMonsterTypeYellChance(lua_State* L);
	static int luaMonsterTypeYellSpeedTicks(lua_State* L);
	static int luaMonsterTypeChangeTargetChance(lua_State* L);
	static int luaMonsterTypeChangeTargetSpeed(lua_State* L);

	static int luaMonsterTypeCanWalkOnEnergy(lua_State* L);
	static int luaMonsterTypeCanWalkOnFire(lua_State* L);
	static int luaMonsterTypeCanWalkOnPoison(lua_State* L);

	static int luaMonsterTypeStrategiesTargetNearest(lua_State* L);
	static int luaMonsterTypeStrategiesTargetHealth(lua_State* L);
	static int luaMonsterTypeStrategiesTargetDamage(lua_State* L);
	static int luaMonsterTypeStrategiesTargetRandom(lua_State* L);

	static int luaMonsterTypeRespawnTypePeriod(lua_State* L);
	static int luaMonsterTypeRespawnTypeIsUnderground(lua_State* L);

	static int luaMonsterTypeSoundChance(lua_State* L);
	static int luaMonsterTypeSoundSpeedTicks(lua_State* L);
	static int luaMonsterTypeAddSound(lua_State* L);
	static int luaMonsterTypeGetSounds(lua_State* L);
	static int luaMonsterTypedeathSound(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CREATURES_MONSTER_MONSTER_TYPE_FUNCTIONS_HPP_
