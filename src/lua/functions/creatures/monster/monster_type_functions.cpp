/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/monster/monster_type_functions.hpp"

#include "config/configmanager.hpp"
#include "creatures/combat/spells.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/monsters/monsters.hpp"
#include "game/game.hpp"
#include "io/io_bosstiary.hpp"
#include "lua/scripts/scripts.hpp"
#include "utils/tools.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void MonsterTypeFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "MonsterType", "", MonsterTypeFunctions::luaMonsterTypeCreate);
	Lua::registerMetaMethod(L, "MonsterType", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "MonsterType", "isAttackable", MonsterTypeFunctions::luaMonsterTypeIsAttackable);
	Lua::registerMethod(L, "MonsterType", "isConvinceable", MonsterTypeFunctions::luaMonsterTypeIsConvinceable);
	Lua::registerMethod(L, "MonsterType", "isSummonable", MonsterTypeFunctions::luaMonsterTypeIsSummonable);
	Lua::registerMethod(L, "MonsterType", "isPreyable", MonsterTypeFunctions::luaMonsterTypeIsPreyable);
	Lua::registerMethod(L, "MonsterType", "isPreyExclusive", MonsterTypeFunctions::luaMonsterTypeIsPreyExclusive);
	Lua::registerMethod(L, "MonsterType", "isIllusionable", MonsterTypeFunctions::luaMonsterTypeIsIllusionable);
	Lua::registerMethod(L, "MonsterType", "isHostile", MonsterTypeFunctions::luaMonsterTypeIsHostile);
	Lua::registerMethod(L, "MonsterType", "isPushable", MonsterTypeFunctions::luaMonsterTypeIsPushable);
	Lua::registerMethod(L, "MonsterType", "isHealthHidden", MonsterTypeFunctions::luaMonsterTypeIsHealthHidden);
	Lua::registerMethod(L, "MonsterType", "isBlockable", MonsterTypeFunctions::luaMonsterTypeIsBlockable);
	Lua::registerMethod(L, "MonsterType", "isForgeCreature", MonsterTypeFunctions::luaMonsterTypeIsForgeCreature);

	Lua::registerMethod(L, "MonsterType", "familiar", MonsterTypeFunctions::luaMonsterTypeFamiliar);
	Lua::registerMethod(L, "MonsterType", "isRewardBoss", MonsterTypeFunctions::luaMonsterTypeIsRewardBoss);

	Lua::registerMethod(L, "MonsterType", "canSpawn", MonsterTypeFunctions::luaMonsterTypeCanSpawn);

	Lua::registerMethod(L, "MonsterType", "canPushItems", MonsterTypeFunctions::luaMonsterTypeCanPushItems);
	Lua::registerMethod(L, "MonsterType", "canPushCreatures", MonsterTypeFunctions::luaMonsterTypeCanPushCreatures);

	Lua::registerMethod(L, "MonsterType", "critChance", MonsterTypeFunctions::luaMonsterTypeCritChance);

	Lua::registerMethod(L, "MonsterType", "name", MonsterTypeFunctions::luaMonsterTypeName);

	Lua::registerMethod(L, "MonsterType", "nameDescription", MonsterTypeFunctions::luaMonsterTypeNameDescription);

	Lua::registerMethod(L, "MonsterType", "getCorpseId", MonsterTypeFunctions::luaMonsterTypegetCorpseId);

	Lua::registerMethod(L, "MonsterType", "health", MonsterTypeFunctions::luaMonsterTypeHealth);
	Lua::registerMethod(L, "MonsterType", "maxHealth", MonsterTypeFunctions::luaMonsterTypeMaxHealth);
	Lua::registerMethod(L, "MonsterType", "runHealth", MonsterTypeFunctions::luaMonsterTypeRunHealth);
	Lua::registerMethod(L, "MonsterType", "experience", MonsterTypeFunctions::luaMonsterTypeExperience);

	Lua::registerMethod(L, "MonsterType", "faction", MonsterTypeFunctions::luaMonsterTypeFaction);
	Lua::registerMethod(L, "MonsterType", "enemyFactions", MonsterTypeFunctions::luaMonsterTypeEnemyFactions);
	Lua::registerMethod(L, "MonsterType", "targetPreferPlayer", MonsterTypeFunctions::luaMonsterTypeTargetPreferPlayer);
	Lua::registerMethod(L, "MonsterType", "targetPreferMaster", MonsterTypeFunctions::luaMonsterTypeTargetPreferMaster);

	Lua::registerMethod(L, "MonsterType", "raceId", MonsterTypeFunctions::luaMonsterTypeRaceid);
	Lua::registerMethod(L, "MonsterType", "Bestiaryclass", MonsterTypeFunctions::luaMonsterTypeBestiaryclass);
	Lua::registerMethod(L, "MonsterType", "BestiaryOccurrence", MonsterTypeFunctions::luaMonsterTypeBestiaryOccurrence);
	Lua::registerMethod(L, "MonsterType", "BestiaryLocations", MonsterTypeFunctions::luaMonsterTypeBestiaryLocations);
	Lua::registerMethod(L, "MonsterType", "BestiaryStars", MonsterTypeFunctions::luaMonsterTypeBestiaryStars);
	Lua::registerMethod(L, "MonsterType", "BestiaryCharmsPoints", MonsterTypeFunctions::luaMonsterTypeBestiaryCharmsPoints);
	Lua::registerMethod(L, "MonsterType", "BestiarySecondUnlock", MonsterTypeFunctions::luaMonsterTypeBestiarySecondUnlock);
	Lua::registerMethod(L, "MonsterType", "BestiaryFirstUnlock", MonsterTypeFunctions::luaMonsterTypeBestiaryFirstUnlock);
	Lua::registerMethod(L, "MonsterType", "BestiarytoKill", MonsterTypeFunctions::luaMonsterTypeBestiarytoKill);
	Lua::registerMethod(L, "MonsterType", "Bestiaryrace", MonsterTypeFunctions::luaMonsterTypeBestiaryrace);

	Lua::registerMethod(L, "MonsterType", "combatImmunities", MonsterTypeFunctions::luaMonsterTypeCombatImmunities);
	Lua::registerMethod(L, "MonsterType", "conditionImmunities", MonsterTypeFunctions::luaMonsterTypeConditionImmunities);

	Lua::registerMethod(L, "MonsterType", "getAttackList", MonsterTypeFunctions::luaMonsterTypeGetAttackList);
	Lua::registerMethod(L, "MonsterType", "addAttack", MonsterTypeFunctions::luaMonsterTypeAddAttack);

	Lua::registerMethod(L, "MonsterType", "getDefenseList", MonsterTypeFunctions::luaMonsterTypeGetDefenseList);
	Lua::registerMethod(L, "MonsterType", "addDefense", MonsterTypeFunctions::luaMonsterTypeAddDefense);

	Lua::registerMethod(L, "MonsterType", "getTypeName", MonsterTypeFunctions::luaMonsterTypeGetTypeName);

	Lua::registerMethod(L, "MonsterType", "getElementList", MonsterTypeFunctions::luaMonsterTypeGetElementList);
	Lua::registerMethod(L, "MonsterType", "addElement", MonsterTypeFunctions::luaMonsterTypeAddElement);

	Lua::registerMethod(L, "MonsterType", "addReflect", MonsterTypeFunctions::luaMonsterTypeAddReflect);
	Lua::registerMethod(L, "MonsterType", "addHealing", MonsterTypeFunctions::luaMonsterTypeAddHealing);

	Lua::registerMethod(L, "MonsterType", "getVoices", MonsterTypeFunctions::luaMonsterTypeGetVoices);
	Lua::registerMethod(L, "MonsterType", "addVoice", MonsterTypeFunctions::luaMonsterTypeAddVoice);

	Lua::registerMethod(L, "MonsterType", "getLoot", MonsterTypeFunctions::luaMonsterTypeGetLoot);
	Lua::registerMethod(L, "MonsterType", "addLoot", MonsterTypeFunctions::luaMonsterTypeAddLoot);

	Lua::registerMethod(L, "MonsterType", "getCreatureEvents", MonsterTypeFunctions::luaMonsterTypeGetCreatureEvents);
	Lua::registerMethod(L, "MonsterType", "registerEvent", MonsterTypeFunctions::luaMonsterTypeRegisterEvent);

	Lua::registerMethod(L, "MonsterType", "eventType", MonsterTypeFunctions::luaMonsterTypeEventType);
	Lua::registerMethod(L, "MonsterType", "onThink", MonsterTypeFunctions::luaMonsterTypeEventOnCallback);
	Lua::registerMethod(L, "MonsterType", "onAppear", MonsterTypeFunctions::luaMonsterTypeEventOnCallback);
	Lua::registerMethod(L, "MonsterType", "onDisappear", MonsterTypeFunctions::luaMonsterTypeEventOnCallback);
	Lua::registerMethod(L, "MonsterType", "onMove", MonsterTypeFunctions::luaMonsterTypeEventOnCallback);
	Lua::registerMethod(L, "MonsterType", "onSay", MonsterTypeFunctions::luaMonsterTypeEventOnCallback);
	Lua::registerMethod(L, "MonsterType", "onPlayerAttack", MonsterTypeFunctions::luaMonsterTypeEventOnCallback);
	Lua::registerMethod(L, "MonsterType", "onSpawn", MonsterTypeFunctions::luaMonsterTypeEventOnCallback);

	Lua::registerMethod(L, "MonsterType", "getSummonList", MonsterTypeFunctions::luaMonsterTypeGetSummonList);
	Lua::registerMethod(L, "MonsterType", "addSummon", MonsterTypeFunctions::luaMonsterTypeAddSummon);

	Lua::registerMethod(L, "MonsterType", "maxSummons", MonsterTypeFunctions::luaMonsterTypeMaxSummons);

	Lua::registerMethod(L, "MonsterType", "armor", MonsterTypeFunctions::luaMonsterTypeArmor);
	Lua::registerMethod(L, "MonsterType", "mitigation", MonsterTypeFunctions::luaMonsterTypeMitigation);
	Lua::registerMethod(L, "MonsterType", "defense", MonsterTypeFunctions::luaMonsterTypeDefense);
	Lua::registerMethod(L, "MonsterType", "outfit", MonsterTypeFunctions::luaMonsterTypeOutfit);
	Lua::registerMethod(L, "MonsterType", "race", MonsterTypeFunctions::luaMonsterTypeRace);
	Lua::registerMethod(L, "MonsterType", "corpseId", MonsterTypeFunctions::luaMonsterTypeCorpseId);
	Lua::registerMethod(L, "MonsterType", "manaCost", MonsterTypeFunctions::luaMonsterTypeManaCost);
	Lua::registerMethod(L, "MonsterType", "baseSpeed", MonsterTypeFunctions::luaMonsterTypeBaseSpeed);
	Lua::registerMethod(L, "MonsterType", "light", MonsterTypeFunctions::luaMonsterTypeLight);

	Lua::registerMethod(L, "MonsterType", "staticAttackChance", MonsterTypeFunctions::luaMonsterTypeStaticAttackChance);
	Lua::registerMethod(L, "MonsterType", "targetDistance", MonsterTypeFunctions::luaMonsterTypeTargetDistance);
	Lua::registerMethod(L, "MonsterType", "yellChance", MonsterTypeFunctions::luaMonsterTypeYellChance);
	Lua::registerMethod(L, "MonsterType", "yellSpeedTicks", MonsterTypeFunctions::luaMonsterTypeYellSpeedTicks);
	Lua::registerMethod(L, "MonsterType", "changeTargetChance", MonsterTypeFunctions::luaMonsterTypeChangeTargetChance);
	Lua::registerMethod(L, "MonsterType", "changeTargetSpeed", MonsterTypeFunctions::luaMonsterTypeChangeTargetSpeed);

	Lua::registerMethod(L, "MonsterType", "canWalkOnEnergy", MonsterTypeFunctions::luaMonsterTypeCanWalkOnEnergy);
	Lua::registerMethod(L, "MonsterType", "canWalkOnFire", MonsterTypeFunctions::luaMonsterTypeCanWalkOnFire);
	Lua::registerMethod(L, "MonsterType", "canWalkOnPoison", MonsterTypeFunctions::luaMonsterTypeCanWalkOnPoison);

	Lua::registerMethod(L, "MonsterType", "strategiesTargetNearest", MonsterTypeFunctions::luaMonsterTypeStrategiesTargetNearest);
	Lua::registerMethod(L, "MonsterType", "strategiesTargetHealth", MonsterTypeFunctions::luaMonsterTypeStrategiesTargetHealth);
	Lua::registerMethod(L, "MonsterType", "strategiesTargetDamage", MonsterTypeFunctions::luaMonsterTypeStrategiesTargetDamage);
	Lua::registerMethod(L, "MonsterType", "strategiesTargetRandom", MonsterTypeFunctions::luaMonsterTypeStrategiesTargetRandom);

	Lua::registerMethod(L, "MonsterType", "respawnTypePeriod", MonsterTypeFunctions::luaMonsterTypeRespawnTypePeriod);
	Lua::registerMethod(L, "MonsterType", "respawnTypeIsUnderground", MonsterTypeFunctions::luaMonsterTypeRespawnTypeIsUnderground);

	Lua::registerMethod(L, "MonsterType", "bossRace", MonsterTypeFunctions::luaMonsterTypeBossRace);
	Lua::registerMethod(L, "MonsterType", "bossRaceId", MonsterTypeFunctions::luaMonsterTypeBossRaceId);

	Lua::registerMethod(L, "MonsterType", "soundChance", MonsterTypeFunctions::luaMonsterTypeSoundChance);
	Lua::registerMethod(L, "MonsterType", "soundSpeedTicks", MonsterTypeFunctions::luaMonsterTypeSoundSpeedTicks);
	Lua::registerMethod(L, "MonsterType", "addSound", MonsterTypeFunctions::luaMonsterTypeAddSound);
	Lua::registerMethod(L, "MonsterType", "getSounds", MonsterTypeFunctions::luaMonsterTypeGetSounds);
	Lua::registerMethod(L, "MonsterType", "deathSound", MonsterTypeFunctions::luaMonsterTypedeathSound);

	Lua::registerMethod(L, "MonsterType", "variant", MonsterTypeFunctions::luaMonsterTypeVariant);
}

void MonsterTypeFunctions::createMonsterTypeLootLuaTable(lua_State* L, const std::vector<LootBlock> &lootList) {
	lua_createtable(L, lootList.size(), 0);

	int index = 0;
	for (const auto &lootBlock : lootList) {
		lua_createtable(L, 0, 8);

		Lua::setField(L, "itemId", lootBlock.id);
		Lua::setField(L, "chance", lootBlock.chance);
		Lua::setField(L, "subType", lootBlock.subType);
		Lua::setField(L, "maxCount", lootBlock.countmax);
		Lua::setField(L, "minCount", lootBlock.countmin);
		Lua::setField(L, "actionId", lootBlock.actionId);
		Lua::setField(L, "text", lootBlock.text);
		Lua::pushBoolean(L, lootBlock.unique);
		lua_setfield(L, -2, "unique");

		createMonsterTypeLootLuaTable(L, lootBlock.childLoot);
		lua_setfield(L, -2, "childLoot");

		lua_rawseti(L, -2, ++index);
	}
}

int MonsterTypeFunctions::luaMonsterTypeCreate(lua_State* L) {
	// MonsterType(name or raceid)
	std::shared_ptr<MonsterType> monsterType;
	if (Lua::isNumber(L, 2)) {
		monsterType = g_monsters().getMonsterTypeByRaceId(Lua::getNumber<uint16_t>(L, 2));
	} else {
		monsterType = g_monsters().getMonsterType(Lua::getString(L, 2));
	}

	if (monsterType) {
		Lua::pushUserdata<MonsterType>(L, monsterType);
		Lua::setMetatable(L, -1, "MonsterType");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsAttackable(lua_State* L) {
	// get: monsterType:isAttackable() set: monsterType:isAttackable(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.isAttackable);
		} else {
			monsterType->info.isAttackable = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsConvinceable(lua_State* L) {
	// get: monsterType:isConvinceable() set: monsterType:isConvinceable(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.isConvinceable);
		} else {
			monsterType->info.isConvinceable = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsSummonable(lua_State* L) {
	// get: monsterType:isSummonable() set: monsterType:isSummonable(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.isSummonable);
		} else {
			monsterType->info.isSummonable = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsPreyExclusive(lua_State* L) {
	// get: monsterType:isPreyExclusive() set: monsterType:isPreyExclusive(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.isPreyExclusive);
		} else {
			monsterType->info.isPreyExclusive = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsPreyable(lua_State* L) {
	// get: monsterType:isPreyable() set: monsterType:isPreyable(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.isPreyable);
		} else {
			monsterType->info.isPreyable = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsIllusionable(lua_State* L) {
	// get: monsterType:isIllusionable() set: monsterType:isIllusionable(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.isIllusionable);
		} else {
			monsterType->info.isIllusionable = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsHostile(lua_State* L) {
	// get: monsterType:isHostile() set: monsterType:isHostile(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.isHostile);
		} else {
			monsterType->info.isHostile = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeFamiliar(lua_State* L) {
	// get: monsterType:familiar() set: monsterType:familiar(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.isFamiliar);
		} else {
			monsterType->info.isFamiliar = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsRewardBoss(lua_State* L) {
	// get: monsterType:isRewardBoss() set: monsterType:isRewardBoss(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.isRewardBoss);
		} else {
			monsterType->info.isRewardBoss = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsPushable(lua_State* L) {
	// get: monsterType:isPushable() set: monsterType:isPushable(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.pushable);
		} else {
			monsterType->info.pushable = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsHealthHidden(lua_State* L) {
	// get: monsterType:isHealthHidden() set: monsterType:isHealthHidden(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.hiddenHealth);
		} else {
			monsterType->info.hiddenHealth = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsBlockable(lua_State* L) {
	// get: monsterType:isBlockable() set: monsterType:isBlockable(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.isBlockable);
		} else {
			monsterType->info.isBlockable = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsForgeCreature(lua_State* L) {
	// get: monsterType:isForgeCreature() set: monsterType:isForgeCreature(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		Lua::pushBoolean(L, false);
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_TYPE_NOT_FOUND));
		return 0;
	}

	if (lua_gettop(L) == 1) {
		Lua::pushBoolean(L, monsterType->info.isForgeCreature);
	} else {
		monsterType->info.isForgeCreature = Lua::getBoolean(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCanSpawn(lua_State* L) {
	// monsterType:canSpawn(pos)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	const Position &position = Lua::getPosition(L, 2);
	if (monsterType) {
		Lua::pushBoolean(L, monsterType->canSpawn(position));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCanPushItems(lua_State* L) {
	// get: monsterType:canPushItems() set: monsterType:canPushItems(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.canPushItems);
		} else {
			monsterType->info.canPushItems = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCanPushCreatures(lua_State* L) {
	// get: monsterType:canPushCreatures() set: monsterType:canPushCreatures(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.canPushCreatures);
		} else {
			monsterType->info.canPushCreatures = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCritChance(lua_State* L) {
	// get: monsterType:critChance() set: monsterType:critChance(int)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 2) {
			monsterType->info.critChance = Lua::getNumber<uint16_t>(L, 2);
		}
		lua_pushnumber(L, monsterType->info.critChance);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int32_t MonsterTypeFunctions::luaMonsterTypeName(lua_State* L) {
	// get: monsterType:name() set: monsterType:name(name)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushString(L, monsterType->name);
		} else {
			monsterType->name = Lua::getString(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeNameDescription(lua_State* L) {
	// get: monsterType:nameDescription() set: monsterType:nameDescription(desc)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushString(L, monsterType->nameDescription);
		} else {
			monsterType->nameDescription = Lua::getString(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypegetCorpseId(lua_State* L) {
	// monsterType:getCorpseId()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		lua_pushnumber(L, monsterType->info.lookcorpse);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeHealth(lua_State* L) {
	// get: monsterType:health() set: monsterType:health(health)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.health);
		} else {
			monsterType->info.health = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeMaxHealth(lua_State* L) {
	// get: monsterType:maxHealth() set: monsterType:maxHealth(health)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.healthMax);
		} else {
			monsterType->info.healthMax = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeRunHealth(lua_State* L) {
	// get: monsterType:runHealth() set: monsterType:runHealth(health)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.runAwayHealth);
		} else {
			monsterType->info.runAwayHealth = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeExperience(lua_State* L) {
	// get: monsterType:experience() set: monsterType:experience(exp)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.experience);
		} else {
			monsterType->info.experience = Lua::getNumber<uint64_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeFaction(lua_State* L) {
	// get: monsterType:faction() set: monsterType:faction(faction)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.faction);
		} else {
			monsterType->info.faction = Lua::getNumber<Faction_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeEnemyFactions(lua_State* L) {
	// get: monsterType:enemyFactions() set: monsterType:enemyFactions(enemyFaction)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_createtable(L, monsterType->info.enemyFactions.size(), 0);
			int index = 0;

			for (const auto &faction : monsterType->info.enemyFactions) {
				lua_pushnumber(L, faction);
				lua_rawseti(L, -2, ++index);
			}
		} else {
			const Faction_t faction = Lua::getNumber<Faction_t>(L, 2);
			monsterType->info.enemyFactions.insert(faction);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeTargetPreferPlayer(lua_State* L) {
	// get: monsterType:targetPreferPlayer() set: monsterType:targetPreferPlayer(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushboolean(L, monsterType->info.targetPreferPlayer);
		} else {
			monsterType->info.targetPreferPlayer = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeTargetPreferMaster(lua_State* L) {
	// get: monsterType:targetPreferMaster() set: monsterType:targetPreferMaster(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.faction);
		} else {
			monsterType->info.targetPreferMaster = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeRaceid(lua_State* L) {
	// get: monsterType:raceId() set: monsterType:raceId(id)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.raceid);
		} else {
			monsterType->info.raceid = Lua::getNumber<uint16_t>(L, 2);
			g_game().addBestiaryList(Lua::getNumber<uint16_t>(L, 2), monsterType->name);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiarytoKill(lua_State* L) {
	// get: monsterType:BestiarytoKill() set: monsterType:BestiarytoKill(value)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiaryToUnlock);
		} else {
			monsterType->info.bestiaryToUnlock = Lua::getNumber<uint16_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryFirstUnlock(lua_State* L) {
	// get: monsterType:BestiaryFirstUnlock() set: monsterType:BestiaryFirstUnlock(value)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiaryFirstUnlock);
		} else {
			monsterType->info.bestiaryFirstUnlock = Lua::getNumber<uint16_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiarySecondUnlock(lua_State* L) {
	// get: monsterType:BestiarySecondUnlock() set: monsterType:BestiarySecondUnlock(value)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiarySecondUnlock);
		} else {
			monsterType->info.bestiarySecondUnlock = Lua::getNumber<uint16_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryCharmsPoints(lua_State* L) {
	// get: monsterType:BestiaryCharmsPoints() set: monsterType:BestiaryCharmsPoints(value)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiaryCharmsPoints);
		} else {
			monsterType->info.bestiaryCharmsPoints = Lua::getNumber<uint16_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryStars(lua_State* L) {
	// get: monsterType:BestiaryStars() set: monsterType:BestiaryStars(value)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiaryStars);
		} else {
			monsterType->info.bestiaryStars = Lua::getNumber<uint8_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryOccurrence(lua_State* L) {
	// get: monsterType:BestiaryOccurrence() set: monsterType:BestiaryOccurrence(value)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiaryOccurrence);
		} else {
			monsterType->info.bestiaryOccurrence = Lua::getNumber<uint8_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryLocations(lua_State* L) {
	// get: monsterType:BestiaryLocations() set: monsterType:BestiaryLocations(string)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushString(L, monsterType->info.bestiaryLocations);
		} else {
			monsterType->info.bestiaryLocations = Lua::getString(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryclass(lua_State* L) {
	// get: monsterType:Bestiaryclass() set: monsterType:Bestiaryclass(string)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushString(L, monsterType->info.bestiaryClass);
		} else {
			monsterType->info.bestiaryClass = Lua::getString(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryrace(lua_State* L) {
	// get: monsterType:Bestiaryrace() set: monsterType:Bestiaryrace(raceid)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiaryRace);
		} else {
			const BestiaryType_t race = Lua::getNumber<BestiaryType_t>(L, 2);
			monsterType->info.bestiaryRace = race;
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCombatImmunities(lua_State* L) {
	// get: monsterType:combatImmunities() set: monsterType:combatImmunities(immunity)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		Lua::pushBoolean(L, false);
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_TYPE_NOT_FOUND));
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_createtable(L, COMBAT_COUNT, 0);
		for (int i = 0; i < COMBAT_COUNT; i++) {
			lua_pushnumber(L, monsterType->info.m_damageImmunities.test(i));
			lua_rawseti(L, -2, i);
		}
		return 1;
	}

	std::string immunity = Lua::getString(L, 2);
	CombatType_t combatType = COMBAT_NONE;
	if (immunity == "physical") {
		combatType = COMBAT_PHYSICALDAMAGE;
	} else if (immunity == "energy") {
		combatType = COMBAT_ENERGYDAMAGE;
	} else if (immunity == "fire") {
		combatType = COMBAT_FIREDAMAGE;
	} else if (immunity == "poison" || immunity == "earth") {
		combatType = COMBAT_EARTHDAMAGE;
	} else if (immunity == "drown") {
		combatType = COMBAT_DROWNDAMAGE;
	} else if (immunity == "ice") {
		combatType = COMBAT_ICEDAMAGE;
	} else if (immunity == "holy") {
		combatType = COMBAT_HOLYDAMAGE;
	} else if (immunity == "death") {
		combatType = COMBAT_DEATHDAMAGE;
	} else if (immunity == "lifedrain") {
		combatType = COMBAT_LIFEDRAIN;
	} else if (immunity == "manadrain") {
		combatType = COMBAT_MANADRAIN;
	} else if (immunity == "agony") {
		combatType = COMBAT_AGONYDAMAGE;
	} else if (immunity == "neutral") {
		combatType = COMBAT_NEUTRALDAMAGE;
	} else {
		g_logger().warn("[MonsterTypeFunctions::luaMonsterTypeCombatImmunities] - "
		                "Unknown immunity name {} for monster: {}",
		                immunity, monsterType->name);
		lua_pushnil(L);
	}

	monsterType->info.m_damageImmunities.set(combatTypeToIndex(combatType), true);
	Lua::pushBoolean(L, true);
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeConditionImmunities(lua_State* L) {
	// get: monsterType:conditionImmunities() set: monsterType:conditionImmunities(immunity)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		Lua::pushBoolean(L, false);
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_TYPE_NOT_FOUND));
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_createtable(L, CONDITION_COUNT, 0);
		for (int i = 0; i < CONDITION_COUNT; i++) {
			lua_pushnumber(L, monsterType->info.m_conditionImmunities.test(i));
			lua_rawseti(L, -2, i);
		}
		return 1;
	}

	std::string immunity = Lua::getString(L, 2);
	ConditionType_t conditionType = CONDITION_NONE;
	if (immunity == "physical") {
		conditionType = CONDITION_BLEEDING;
	} else if (immunity == "energy") {
		conditionType = CONDITION_ENERGY;
	} else if (immunity == "fire") {
		conditionType = CONDITION_FIRE;
	} else if (immunity == "poison" || immunity == "earth") {
		conditionType = CONDITION_POISON;
	} else if (immunity == "drown") {
		conditionType = CONDITION_DROWN;
	} else if (immunity == "ice") {
		conditionType = CONDITION_FREEZING;
	} else if (immunity == "holy") {
		conditionType = CONDITION_DAZZLED;
	} else if (immunity == "death") {
		conditionType = CONDITION_CURSED;
	} else if (immunity == "paralyze") {
		conditionType = CONDITION_PARALYZE;
	} else if (immunity == "outfit") {
		conditionType = CONDITION_OUTFIT;
	} else if (immunity == "drunk") {
		conditionType = CONDITION_DRUNK;
	} else if (immunity == "invisible" || immunity == "invisibility") {
		conditionType = CONDITION_INVISIBLE;
	} else if (immunity == "bleed") {
		conditionType = CONDITION_BLEEDING;
	} else {
		g_logger().warn("[MonsterTypeFunctions::luaMonsterTypeConditionImmunities] - "
		                "Unknown immunity name: {} for monster: {}",
		                immunity, monsterType->name);
		lua_pushnil(L);
	}

	monsterType->info.m_conditionImmunities[static_cast<size_t>(conditionType)] = true;
	Lua::pushBoolean(L, true);
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetAttackList(lua_State* L) {
	// monsterType:getAttackList()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, monsterType->info.attackSpells.size(), 0);

	int index = 0;
	for (const auto &spellBlock : monsterType->info.attackSpells) {
		lua_createtable(L, 0, 8);

		Lua::setField(L, "chance", spellBlock.chance);
		Lua::setField(L, "isCombatSpell", spellBlock.combatSpell ? 1 : 0);
		Lua::setField(L, "isMelee", spellBlock.isMelee ? 1 : 0);
		Lua::setField(L, "minCombatValue", spellBlock.minCombatValue);
		Lua::setField(L, "maxCombatValue", spellBlock.maxCombatValue);
		Lua::setField(L, "range", spellBlock.range);
		Lua::setField(L, "speed", spellBlock.speed);
		const auto combatSpell = std::static_pointer_cast<CombatSpell>(spellBlock.spell);
		Lua::pushUserdata<CombatSpell>(L, combatSpell);
		lua_setfield(L, -2, "spell");

		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddAttack(lua_State* L) {
	// monsterType:addAttack(monsterspell)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 2);
		if (spell) {
			spellBlock_t sb;
			if (g_monsters().deserializeSpell(spell, sb, monsterType->name)) {
				monsterType->info.attackSpells.push_back(std::move(sb));
			} else {
				g_logger().warn("Monster: {}, cant load spell: {}", monsterType->name, spell->name);
			}
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetDefenseList(lua_State* L) {
	// monsterType:getDefenseList()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, monsterType->info.defenseSpells.size(), 0);

	int index = 0;
	for (const auto &spellBlock : monsterType->info.defenseSpells) {
		lua_createtable(L, 0, 8);

		Lua::setField(L, "chance", spellBlock.chance);
		Lua::setField(L, "isCombatSpell", spellBlock.combatSpell ? 1 : 0);
		Lua::setField(L, "isMelee", spellBlock.isMelee ? 1 : 0);
		Lua::setField(L, "minCombatValue", spellBlock.minCombatValue);
		Lua::setField(L, "maxCombatValue", spellBlock.maxCombatValue);
		Lua::setField(L, "range", spellBlock.range);
		Lua::setField(L, "speed", spellBlock.speed);
		const auto combatSpell = std::static_pointer_cast<CombatSpell>(spellBlock.spell);
		Lua::pushUserdata<CombatSpell>(L, combatSpell);
		lua_setfield(L, -2, "spell");

		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetTypeName(lua_State* L) {
	// monsterType:getTypeName()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		return 1;
	}

	Lua::pushString(L, monsterType->typeName);
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddDefense(lua_State* L) {
	// monsterType:addDefense(monsterspell)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 2);
		if (spell) {
			spellBlock_t sb;
			if (g_monsters().deserializeSpell(spell, sb, monsterType->name)) {
				monsterType->info.defenseSpells.push_back(std::move(sb));
			} else {
				g_logger().warn("Monster: {}, Cant load spell: {}", monsterType->name, spell->name);
			}
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddElement(lua_State* L) {
	// monsterType:addElement(type, percent)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		const CombatType_t element = Lua::getNumber<CombatType_t>(L, 2);
		monsterType->info.elementMap[element] = Lua::getNumber<int32_t>(L, 3);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddReflect(lua_State* L) {
	// monsterType:addReflect(type, percent)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		const CombatType_t element = Lua::getNumber<CombatType_t>(L, 2);
		monsterType->info.reflectMap[element] = Lua::getNumber<int32_t>(L, 3);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddHealing(lua_State* L) {
	// monsterType:addHealing(type, percent)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		const CombatType_t element = Lua::getNumber<CombatType_t>(L, 2);
		monsterType->info.healingMap[element] = Lua::getNumber<int32_t>(L, 3);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetElementList(lua_State* L) {
	// monsterType:getElementList()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, monsterType->info.elementMap.size(), 0);
	for (const auto &elementEntry : monsterType->info.elementMap) {
		lua_pushnumber(L, elementEntry.second);
		lua_rawseti(L, -2, elementEntry.first);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddVoice(lua_State* L) {
	// monsterType:addVoice(sentence, interval, chance, yell)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		voiceBlock_t voice;
		voice.text = Lua::getString(L, 2);
		monsterType->info.yellSpeedTicks = Lua::getNumber<uint32_t>(L, 3);
		monsterType->info.yellChance = Lua::getNumber<uint32_t>(L, 4);
		voice.yellText = Lua::getBoolean(L, 5);
		monsterType->info.voiceVector.push_back(voice);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetVoices(lua_State* L) {
	// monsterType:getVoices()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, monsterType->info.voiceVector.size(), 0);
	for (const auto &voiceBlock : monsterType->info.voiceVector) {
		lua_createtable(L, 0, 2);
		Lua::setField(L, "text", voiceBlock.text);
		Lua::setField(L, "yellText", voiceBlock.yellText);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetLoot(lua_State* L) {
	// monsterType:getLoot()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	createMonsterTypeLootLuaTable(L, monsterType->info.lootItems);
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddLoot(lua_State* L) {
	// monsterType:addLoot(loot)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		const auto &loot = Lua::getUserdataShared<Loot>(L, 2);
		if (loot) {
			monsterType->loadLoot(monsterType, loot->lootBlock);
			Lua::pushBoolean(L, true);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetCreatureEvents(lua_State* L) {
	// monsterType:getCreatureEvents()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, monsterType->info.scripts.size(), 0);
	for (const std::string &creatureEvent : monsterType->info.scripts) {
		Lua::pushString(L, creatureEvent);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeRegisterEvent(lua_State* L) {
	// monsterType:registerEvent(name)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		const auto eventName = Lua::getString(L, 2);
		monsterType->info.scripts.insert(eventName);
		for (const auto &[_, monster] : g_game().getMonsters()) {
			if (monster->getMonsterType() == monsterType) {
				monster->registerCreatureEvent(eventName);
			}
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeEventOnCallback(lua_State* L) {
	// monsterType:onThink(callback)
	// monsterType:onAppear(callback)
	// monsterType:onDisappear(callback)
	// monsterType:onMove(callback)
	// monsterType:onSay(callback)
	// monsterType:onPlayerAttack(callback)
	// monsterType:onSpawn(callback)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (monsterType->loadCallback(&g_scripts().getScriptInterface())) {
			Lua::pushBoolean(L, true);
			return 1;
		}
		Lua::pushBoolean(L, false);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeEventType(lua_State* L) {
	// monstertype:eventType(event)
	const auto &mType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (mType) {
		mType->info.eventType = Lua::getNumber<MonstersEvent_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetSummonList(lua_State* L) {
	// monsterType:getSummonList()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, monsterType->info.summons.size(), 0);
	for (const auto &summonBlock : monsterType->info.summons) {
		lua_createtable(L, 0, 3);
		Lua::setField(L, "name", summonBlock.name);
		Lua::setField(L, "speed", summonBlock.speed);
		Lua::setField(L, "chance", summonBlock.chance);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddSummon(lua_State* L) {
	// monsterType:addSummon(name, interval, chance[, count = 1])
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		summonBlock_t summon;
		summon.name = Lua::getString(L, 2);
		summon.speed = Lua::getNumber<int32_t>(L, 3);
		summon.count = Lua::getNumber<int32_t>(L, 5, 1);
		summon.chance = Lua::getNumber<int32_t>(L, 4);
		monsterType->info.summons.push_back(summon);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeMaxSummons(lua_State* L) {
	// get: monsterType:maxSummons() set: monsterType:maxSummons(ammount)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.maxSummons);
		} else {
			monsterType->info.maxSummons = Lua::getNumber<uint32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeArmor(lua_State* L) {
	// get: monsterType:armor() set: monsterType:armor(armor)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.armor);
		} else {
			monsterType->info.armor = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeMitigation(lua_State* L) {
	// get: monsterType:mitigation() set: monsterType:mitigation(mitigation)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		Lua::pushBoolean(L, false);
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_TYPE_NOT_FOUND));
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, monsterType->info.mitigation);
	} else {
		monsterType->info.mitigation = Lua::getNumber<float>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeDefense(lua_State* L) {
	// get: monsterType:defense() set: monsterType:defense(defense)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.defense);
		} else {
			monsterType->info.defense = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeOutfit(lua_State* L) {
	// get: monsterType:outfit() set: monsterType:outfit(outfit)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushOutfit(L, monsterType->info.outfit);
		} else {
			Outfit_t outfit = Lua::getOutfit(L, 2);
			if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && outfit.lookType != 0 && !g_game().isLookTypeRegistered(outfit.lookType)) {
				g_logger().warn("[MonsterTypeFunctions::luaMonsterTypeOutfit] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", outfit.lookType);
				lua_pushnil(L);
			} else {
				monsterType->info.outfit = outfit;
				Lua::pushBoolean(L, true);
			}
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeRace(lua_State* L) {
	// get: monsterType:race() set: monsterType:race(race)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	std::string race = Lua::getString(L, 2);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.race);
		} else {
			if (race == "venom") {
				monsterType->info.race = RACE_VENOM;
			} else if (race == "blood") {
				monsterType->info.race = RACE_BLOOD;
			} else if (race == "undead") {
				monsterType->info.race = RACE_UNDEAD;
			} else if (race == "fire") {
				monsterType->info.race = RACE_FIRE;
			} else if (race == "energy") {
				monsterType->info.race = RACE_ENERGY;
			} else if (race == "ink") {
				monsterType->info.race = RACE_INK;
			} else {
				g_logger().warn("[MonsterTypeFunctions::luaMonsterTypeRace] - "
				                "Unknown race type {}",
				                race);
				lua_pushnil(L);
				return 1;
			}
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCorpseId(lua_State* L) {
	// get: monsterType:corpseId() set: monsterType:corpseId(id)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.lookcorpse);
		} else {
			monsterType->info.lookcorpse = Lua::getNumber<uint16_t>(L, 2);
			lua_pushboolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeManaCost(lua_State* L) {
	// get: monsterType:manaCost() set: monsterType:manaCost(mana)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.manaCost);
		} else {
			monsterType->info.manaCost = Lua::getNumber<uint32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBaseSpeed(lua_State* L) {
	// monsterType:baseSpeed()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->getBaseSpeed());
		} else {
			monsterType->setBaseSpeed(Lua::getNumber<uint16_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}
int MonsterTypeFunctions::luaMonsterTypeLight(lua_State* L) {
	// get: monsterType:light() set: monsterType:light(color, level)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, monsterType->info.light.level);
		lua_pushnumber(L, monsterType->info.light.color);
		return 2;
	} else {
		monsterType->info.light.color = Lua::getNumber<uint8_t>(L, 2);
		monsterType->info.light.level = Lua::getNumber<uint8_t>(L, 3);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeStaticAttackChance(lua_State* L) {
	// get: monsterType:staticAttackChance() set: monsterType:staticAttackChance(chance)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.staticAttackChance);
		} else {
			monsterType->info.staticAttackChance = Lua::getNumber<uint32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeTargetDistance(lua_State* L) {
	// get: monsterType:targetDistance() set: monsterType:targetDistance(distance)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.targetDistance);
		} else {
			monsterType->info.targetDistance = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeYellChance(lua_State* L) {
	// get: monsterType:yellChance() set: monsterType:yellChance(chance)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			if (lua_gettop(L) == 1) {
				lua_pushnumber(L, monsterType->info.yellChance);
			} else {
				monsterType->info.yellChance = Lua::getNumber<uint32_t>(L, 2);
				Lua::pushBoolean(L, true);
			}
		} else {
			monsterType->info.yellChance = Lua::getNumber<uint32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeYellSpeedTicks(lua_State* L) {
	// get: monsterType:yellSpeedTicks() set: monsterType:yellSpeedTicks(rate)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.yellSpeedTicks);
		} else {
			monsterType->info.yellSpeedTicks = Lua::getNumber<uint32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeChangeTargetChance(lua_State* L) {
	// monsterType:getChangeTargetChance()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.changeTargetChance);
		} else {
			monsterType->info.changeTargetChance = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeChangeTargetSpeed(lua_State* L) {
	// get: monsterType:changeTargetSpeed() set: monsterType:changeTargetSpeed(speed)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.changeTargetSpeed);
		} else {
			monsterType->info.changeTargetSpeed = Lua::getNumber<uint32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCanWalkOnEnergy(lua_State* L) {
	// get: monsterType:canWalkOnEnergy() set: monsterType:canWalkOnEnergy(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.canWalkOnEnergy);
		} else {
			monsterType->info.canWalkOnEnergy = Lua::getBoolean(L, 2, true);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCanWalkOnFire(lua_State* L) {
	// get: monsterType:canWalkOnFire() set: monsterType:canWalkOnFire(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.canWalkOnFire);
		} else {
			monsterType->info.canWalkOnFire = Lua::getBoolean(L, 2, true);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCanWalkOnPoison(lua_State* L) {
	// get: monsterType:canWalkOnPoison() set: monsterType:canWalkOnPoison(bool)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monsterType->info.canWalkOnPoison);
		} else {
			monsterType->info.canWalkOnPoison = Lua::getBoolean(L, 2, true);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeStrategiesTargetNearest(lua_State* L) {
	// monsterType:strategiesTargetNearest()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.strategiesTargetNearest);
		} else {
			monsterType->info.strategiesTargetNearest = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeStrategiesTargetHealth(lua_State* L) {
	// monsterType:strategiesTargetHealth()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.strategiesTargetHealth);
		} else {
			monsterType->info.strategiesTargetHealth = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeStrategiesTargetDamage(lua_State* L) {
	// monsterType:strategiesTargetDamage()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.strategiesTargetDamage);
		} else {
			monsterType->info.strategiesTargetDamage = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeStrategiesTargetRandom(lua_State* L) {
	// monsterType:strategiesTargetRandom()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.strategiesTargetRandom);
		} else {
			monsterType->info.strategiesTargetRandom = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

/**
 * Respawn Type
 */

int MonsterTypeFunctions::luaMonsterTypeRespawnTypePeriod(lua_State* L) {
	// monsterType:respawnTypePeriod()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.respawnType.period);
		} else {
			monsterType->info.respawnType.period = Lua::getNumber<RespawnPeriod_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeRespawnTypeIsUnderground(lua_State* L) {
	// monsterType:respawnTypeIsUnderground()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.respawnType.underground);
		} else {
			monsterType->info.respawnType.underground = Lua::getNumber<RespawnPeriod_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBossRace(lua_State* L) {
	// set: monsterType:bosstiaryRace(raceId, class)
	// get: monsterType:bosstiaryRace() = this return only class name
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		Lua::pushBoolean(L, false);
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_TYPE_NOT_FOUND));
		return 0;
	}

	if (lua_gettop(L) == 1) {
		if (monsterType->info.bosstiaryClass.empty()) {
			lua_pushnil(L);
			return 1;
		}
		Lua::pushString(L, monsterType->info.bosstiaryClass);
	} else {
		const auto bossRace = Lua::getNumber<uint8_t>(L, 2, 0);
		const auto bossClass = Lua::getString(L, 3);
		monsterType->info.bosstiaryRace = magic_enum::enum_value<BosstiaryRarity_t>(bossRace);
		monsterType->info.bosstiaryClass = bossClass;
		Lua::pushBoolean(L, true);
	}

	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBossRaceId(lua_State* L) {
	// set: monsterType:bossRaceId(raceId)
	// get: monsterType:bossRaceId()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		Lua::pushBoolean(L, false);
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_TYPE_NOT_FOUND));
		return 0;
	}

	if (lua_gettop(L) == 1) {
		if (monsterType->info.bosstiaryClass.empty()) {
			lua_pushnumber(L, 0);
		} else {
			lua_pushnumber(L, static_cast<lua_Number>(monsterType->info.bosstiaryRace));
		}
	} else {
		const auto raceId = Lua::getNumber<uint16_t>(L, 2, 0);
		monsterType->info.raceid = raceId;
		g_ioBosstiary().addBosstiaryMonster(raceId, monsterType->typeName);
		Lua::pushBoolean(L, true);
	}

	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeSoundChance(lua_State* L) {
	// get: monsterType:soundChance() set: monsterType:soundChance(chance)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, monsterType->info.soundChance);
	} else {
		monsterType->info.soundChance = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeSoundSpeedTicks(lua_State* L) {
	// get: monsterType:soundSpeedTicks() set: monsterType:soundSpeedTicks(ticks)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, monsterType->info.soundSpeedTicks);
	} else {
		monsterType->info.soundSpeedTicks = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddSound(lua_State* L) {
	// monsterType:addSound(soundId)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	monsterType->info.soundVector.push_back(Lua::getNumber<SoundEffect_t>(L, 2));
	Lua::pushBoolean(L, true);
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetSounds(lua_State* L) {
	// monsterType:getSounds()
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, static_cast<int>(monsterType->info.soundVector.size()), 0);
	for (const auto &sound : monsterType->info.soundVector) {
		++index;
		lua_createtable(L, 0, 1);
		lua_pushnumber(L, static_cast<lua_Number>(sound));
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypedeathSound(lua_State* L) {
	// get: monsterType:deathSound() set: monsterType:deathSound(sound)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, static_cast<lua_Number>(monsterType->info.deathSound));
	} else {
		monsterType->info.deathSound = Lua::getNumber<SoundEffect_t>(L, 2);
		Lua::pushBoolean(L, true);
	}

	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeVariant(lua_State* L) {
	// get: monsterType:variant() set: monsterType:variant(variantName)
	const auto &monsterType = Lua::getUserdataShared<MonsterType>(L, 1);
	if (!monsterType) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		Lua::pushString(L, monsterType->variantName);
	} else {
		monsterType->variantName = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	}

	return 1;
}
