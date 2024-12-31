/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

struct LootBlock;

class MonsterTypeFunctions {
public:
	static void init(lua_State* L);

private:
	static void createMonsterTypeLootLuaTable(lua_State* L, const std::vector<LootBlock> &lootList);

	static int luaMonsterTypeCreate(lua_State* L);

	static int luaMonsterTypeIsAttackable(lua_State* L);
	static int luaMonsterTypeIsConvinceable(lua_State* L);
	static int luaMonsterTypeIsSummonable(lua_State* L);
	static int luaMonsterTypeIsPreyable(lua_State* L);
	static int luaMonsterTypeIsPreyExclusive(lua_State* L);
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
	static int luaMonsterTypeMitigation(lua_State* L);
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

	static int luaMonsterTypeBossRace(lua_State* L);
	static int luaMonsterTypeBossRaceId(lua_State* L);

	static int luaMonsterTypeSoundChance(lua_State* L);
	static int luaMonsterTypeSoundSpeedTicks(lua_State* L);
	static int luaMonsterTypeAddSound(lua_State* L);
	static int luaMonsterTypeGetSounds(lua_State* L);
	static int luaMonsterTypedeathSound(lua_State* L);
	static int luaMonsterTypeCritChance(lua_State* L);

	static int luaMonsterTypeVariant(lua_State* L);
};
