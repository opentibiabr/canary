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

#include "creatures/combat/spells.h"
#include "creatures/monsters/monsters.h"
#include "game/game.h"
#include "lua/functions/creatures/monster/monster_type_functions.hpp"
#include "lua/scripts/scripts.h"

void MonsterTypeFunctions::createMonsterTypeLootLuaTable(lua_State* L, const std::vector<LootBlock>& lootList) {
	lua_createtable(L, lootList.size(), 0);

	int index = 0;
	for (const auto& lootBlock : lootList) {
		lua_createtable(L, 0, 8);

		setField(L, "itemId", lootBlock.id);
		setField(L, "chance", lootBlock.chance);
		setField(L, "subType", lootBlock.subType);
		setField(L, "maxCount", lootBlock.countmax);
		setField(L, "minCount", lootBlock.countmin);
		setField(L, "actionId", lootBlock.actionId);
		setField(L, "text", lootBlock.text);
		pushBoolean(L, lootBlock.unique);
		lua_setfield(L, -2, "unique");

		createMonsterTypeLootLuaTable(L, lootBlock.childLoot);
		lua_setfield(L, -2, "childLoot");

		lua_rawseti(L, -2, ++index);
	}
}

int MonsterTypeFunctions::luaMonsterTypeCreate(lua_State* L) {
	// MonsterType(name or raceid)
	MonsterType* monsterType = nullptr;
	if (isNumber(L, 2)) {
		monsterType = g_monsters().getMonsterTypeByRaceId(getNumber<uint16_t>(L, 2));
	} else {
		monsterType = g_monsters().getMonsterType(getString(L, 2));
	}

	if (monsterType) {
		pushUserdata<MonsterType>(L, monsterType);
		setMetatable(L, -1, "MonsterType");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsAttackable(lua_State* L) {
	// get: monsterType:isAttackable() set: monsterType:isAttackable(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isAttackable);
		} else {
			monsterType->info.isAttackable = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsConvinceable(lua_State* L) {
	// get: monsterType:isConvinceable() set: monsterType:isConvinceable(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isConvinceable);
		} else {
			monsterType->info.isConvinceable = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsSummonable(lua_State* L) {
	// get: monsterType:isSummonable() set: monsterType:isSummonable(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isSummonable);
		} else {
			monsterType->info.isSummonable = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsIllusionable(lua_State* L) {
	// get: monsterType:isIllusionable() set: monsterType:isIllusionable(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isIllusionable);
		} else {
			monsterType->info.isIllusionable = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsHostile(lua_State* L) {
	// get: monsterType:isHostile() set: monsterType:isHostile(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isHostile);
		} else {
			monsterType->info.isHostile = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeFamiliar(lua_State* L) {
	// get: monsterType:familiar() set: monsterType:familiar(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isFamiliar);
		} else {
			monsterType->info.isFamiliar = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsRewardBoss(lua_State* L) {
	// get: monsterType:isRewardBoss() set: monsterType:isRewardBoss(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isRewardBoss);
		} else {
			monsterType->info.isRewardBoss = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsPushable(lua_State* L) {
	// get: monsterType:isPushable() set: monsterType:isPushable(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.pushable);
		} else {
			monsterType->info.pushable = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsHealthHidden(lua_State* L) {
	// get: monsterType:isHealthHidden() set: monsterType:isHealthHidden(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.hiddenHealth);
		} else {
			monsterType->info.hiddenHealth = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsBlockable(lua_State* L) {
	// get: monsterType:isBlockable() set: monsterType:isBlockable(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isBlockable);
		} else {
			monsterType->info.isBlockable = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeIsForgeCreature(lua_State* L) {
	// get: monsterType:isForgeCreature() set: monsterType:isForgeCreature(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		pushBoolean(L, false);
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_TYPE_NOT_FOUND));
		return 0;
	}

	if (lua_gettop(L) == 1) {
		pushBoolean(L, monsterType->info.isForgeCreature);
	} else {
		monsterType->info.isForgeCreature = getBoolean(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCanSpawn(lua_State* L) {
	// monsterType:canSpawn(pos)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	const Position& position = getPosition(L, 2);
	if (monsterType) {
		pushBoolean(L, monsterType->canSpawn(position));
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCanPushItems(lua_State* L) {
	// get: monsterType:canPushItems() set: monsterType:canPushItems(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.canPushItems);
		} else {
			monsterType->info.canPushItems = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCanPushCreatures(lua_State* L) {
	// get: monsterType:canPushCreatures() set: monsterType:canPushCreatures(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.canPushCreatures);
		} else {
			monsterType->info.canPushCreatures = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int32_t MonsterTypeFunctions::luaMonsterTypeName(lua_State* L) {
	// get: monsterType:name() set: monsterType:name(name)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushString(L, monsterType->name);
		} else {
			monsterType->name = getString(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeNameDescription(lua_State* L) {
	// get: monsterType:nameDescription() set: monsterType:nameDescription(desc)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushString(L, monsterType->nameDescription);
		} else {
			monsterType->nameDescription = getString(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypegetCorpseId(lua_State* L) {
	// monsterType:getCorpseId()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		lua_pushnumber(L, monsterType->info.lookcorpse);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeHealth(lua_State* L) {
	// get: monsterType:health() set: monsterType:health(health)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.health);
		} else {
			monsterType->info.health = getNumber<int64_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeMaxHealth(lua_State* L) {
	// get: monsterType:maxHealth() set: monsterType:maxHealth(health)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.healthMax);
		} else {
			monsterType->info.healthMax = getNumber<int64_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeRunHealth(lua_State* L) {
	// get: monsterType:runHealth() set: monsterType:runHealth(health)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.runAwayHealth);
		} else {
			monsterType->info.runAwayHealth = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeExperience(lua_State* L) {
	// get: monsterType:experience() set: monsterType:experience(exp)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.experience);
		} else {
			monsterType->info.experience = getNumber<uint64_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeFaction(lua_State* L)
{
	// get: monsterType:faction() set: monsterType:faction(faction)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.faction);
		}
		else {
			monsterType->info.faction = getNumber<Faction_t>(L, 2);
			pushBoolean(L, true);
		}
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeEnemyFactions(lua_State* L)
{
	// get: monsterType:enemyFactions() set: monsterType:enemyFactions(enemyFaction)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_createtable(L, monsterType->info.enemyFactions.size(), 0);
			int index = 0;

			for (auto faction : monsterType->info.enemyFactions) {
				lua_pushnumber(L, faction);
				lua_rawseti(L, -2, ++index);
			}
		}
		else {
			Faction_t faction = getNumber<Faction_t>(L, 2);
			monsterType->info.enemyFactions.emplace(faction);
			pushBoolean(L, true);
		}
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeTargetPreferPlayer(lua_State* L)
{
	// get: monsterType:targetPreferPlayer() set: monsterType:targetPreferPlayer(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushboolean(L, monsterType->info.targetPreferPlayer);
		}
		else {
			monsterType->info.targetPreferPlayer = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeTargetPreferMaster(lua_State* L)
{
	// get: monsterType:targetPreferMaster() set: monsterType:targetPreferMaster(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.faction);
		}
		else {
			monsterType->info.targetPreferMaster = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeRaceid(lua_State* L) {
	// get: monsterType:raceId() set: monsterType:raceId(id)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.raceid);
		} else {
			monsterType->info.raceid = getNumber<uint16_t>(L, 2);
			g_game().addBestiaryList(getNumber<uint16_t>(L, 2), monsterType->name);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiarytoKill(lua_State* L) {
	// get: monsterType:BestiarytoKill() set: monsterType:BestiarytoKill(value)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiaryToUnlock);
		} else {
			monsterType->info.bestiaryToUnlock = getNumber<uint16_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryFirstUnlock(lua_State* L) {
	// get: monsterType:BestiaryFirstUnlock() set: monsterType:BestiaryFirstUnlock(value)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiaryFirstUnlock);
		} else {
			monsterType->info.bestiaryFirstUnlock = getNumber<uint16_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiarySecondUnlock(lua_State* L) {
	// get: monsterType:BestiarySecondUnlock() set: monsterType:BestiarySecondUnlock(value)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiarySecondUnlock);
		} else {
			monsterType->info.bestiarySecondUnlock = getNumber<uint16_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryCharmsPoints(lua_State* L) {
	// get: monsterType:BestiaryCharmsPoints() set: monsterType:BestiaryCharmsPoints(value)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiaryCharmsPoints);
		} else {
			monsterType->info.bestiaryCharmsPoints = getNumber<uint16_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryStars(lua_State* L) {
	// get: monsterType:BestiaryStars() set: monsterType:BestiaryStars(value)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiaryStars);
		} else {
			monsterType->info.bestiaryStars = getNumber<uint8_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryOccurrence(lua_State* L) {
	// get: monsterType:BestiaryOccurrence() set: monsterType:BestiaryOccurrence(value)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiaryOccurrence);
		} else {
			monsterType->info.bestiaryOccurrence = getNumber<uint8_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryLocations(lua_State* L) {
	// get: monsterType:BestiaryLocations() set: monsterType:BestiaryLocations(string)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushString(L, monsterType->info.bestiaryLocations);
		} else {
			monsterType->info.bestiaryLocations = getString(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryclass(lua_State* L) {
	// get: monsterType:Bestiaryclass() set: monsterType:Bestiaryclass(string)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushString(L, monsterType->info.bestiaryClass);
		} else {
			monsterType->info.bestiaryClass = getString(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBestiaryrace(lua_State* L) {
	// get: monsterType:Bestiaryrace() set: monsterType:Bestiaryrace(raceid)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.bestiaryRace);
		} else {
			BestiaryType_t race = getNumber<BestiaryType_t>(L, 2);
			monsterType->info.bestiaryRace = race;
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCombatImmunities(lua_State* L) {
	// get: monsterType:combatImmunities() set: monsterType:combatImmunities(immunity)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.damageImmunities);
		} else {
			std::string immunity = getString(L, 2);
			if (immunity == "physical") {
				monsterType->info.damageImmunities |= COMBAT_PHYSICALDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "energy") {
				monsterType->info.damageImmunities |= COMBAT_ENERGYDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "fire") {
				monsterType->info.damageImmunities |= COMBAT_FIREDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "poison" || immunity == "earth") {
				monsterType->info.damageImmunities |= COMBAT_EARTHDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "drown") {
				monsterType->info.damageImmunities |= COMBAT_DROWNDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "ice") {
				monsterType->info.damageImmunities |= COMBAT_ICEDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "holy") {
				monsterType->info.damageImmunities |= COMBAT_HOLYDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "death") {
				monsterType->info.damageImmunities |= COMBAT_DEATHDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "lifedrain") {
				monsterType->info.damageImmunities |= COMBAT_LIFEDRAIN;
				pushBoolean(L, true);
			} else if (immunity == "manadrain") {
				monsterType->info.damageImmunities |= COMBAT_MANADRAIN;
				pushBoolean(L, true);
			} else {
				SPDLOG_WARN("[MonsterTypeFunctions::luaMonsterTypeCombatImmunities] - "
							"Unknown immunity name {} for monster: {}",
							immunity, monsterType->name);
				lua_pushnil(L);
			}
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeConditionImmunities(lua_State* L) {
	// get: monsterType:conditionImmunities() set: monsterType:conditionImmunities(immunity)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.conditionImmunities);
		} else {
			std::string immunity = getString(L, 2);
			if (immunity == "physical") {
				monsterType->info.conditionImmunities |= CONDITION_BLEEDING;
				pushBoolean(L, true);
			} else if (immunity == "energy") {
				monsterType->info.conditionImmunities |= CONDITION_ENERGY;
				pushBoolean(L, true);
			} else if (immunity == "fire") {
				monsterType->info.conditionImmunities |= CONDITION_FIRE;
				pushBoolean(L, true);
			} else if (immunity == "poison" || immunity == "earth") {
				monsterType->info.conditionImmunities |= CONDITION_POISON;
				pushBoolean(L, true);
			} else if (immunity == "drown") {
				monsterType->info.conditionImmunities |= CONDITION_DROWN;
				pushBoolean(L, true);
			} else if (immunity == "ice") {
				monsterType->info.conditionImmunities |= CONDITION_FREEZING;
				pushBoolean(L, true);
			} else if (immunity == "holy") {
				monsterType->info.conditionImmunities |= CONDITION_DAZZLED;
				pushBoolean(L, true);
			} else if (immunity == "death") {
				monsterType->info.conditionImmunities |= CONDITION_CURSED;
				pushBoolean(L, true);
			} else if (immunity == "paralyze") {
				monsterType->info.conditionImmunities |= CONDITION_PARALYZE;
				pushBoolean(L, true);
			} else if (immunity == "outfit") {
				monsterType->info.conditionImmunities |= CONDITION_OUTFIT;
				pushBoolean(L, true);
			} else if (immunity == "drunk") {
				monsterType->info.conditionImmunities |= CONDITION_DRUNK;
				pushBoolean(L, true);
			} else if (immunity == "invisible" || immunity == "invisibility") {
				monsterType->info.conditionImmunities |= CONDITION_INVISIBLE;
				pushBoolean(L, true);
			} else if (immunity == "bleed") {
				monsterType->info.conditionImmunities |= CONDITION_BLEEDING;
				pushBoolean(L, true);
			} else {
				SPDLOG_WARN("[MonsterTypeFunctions::luaMonsterTypeConditionImmunities] - "
							"Unknown immunity name: {} for monster: {}",
							immunity, monsterType->name);
				lua_pushnil(L);
			}
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetAttackList(lua_State* L) {
	// monsterType:getAttackList()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, monsterType->info.attackSpells.size(), 0);

	int index = 0;
	for (const auto& spellBlock : monsterType->info.attackSpells) {
		lua_createtable(L, 0, 8);

		setField(L, "chance", spellBlock.chance);
		setField(L, "isCombatSpell", spellBlock.combatSpell ? 1 : 0);
		setField(L, "isMelee", spellBlock.isMelee ? 1 : 0);
		setField(L, "minCombatValue", spellBlock.minCombatValue);
		setField(L, "maxCombatValue", spellBlock.maxCombatValue);
		setField(L, "range", spellBlock.range);
		setField(L, "speed", spellBlock.speed);
		pushUserdata<CombatSpell>(L, static_cast<CombatSpell*>(spellBlock.spell));
		lua_setfield(L, -2, "spell");

		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddAttack(lua_State* L) {
	// monsterType:addAttack(monsterspell)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		MonsterSpell* spell = getUserdata<MonsterSpell>(L, 2);
		if (spell) {
			spellBlock_t sb;
			if (g_monsters().deserializeSpell(spell, sb, monsterType->name)) {
				monsterType->info.attackSpells.push_back(std::move(sb));
			} else {
				SPDLOG_WARN("Monster: {}, cant load spell: {}", monsterType->name,
					spell->name);
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
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, monsterType->info.defenseSpells.size(), 0);


	int index = 0;
	for (const auto& spellBlock : monsterType->info.defenseSpells) {
		lua_createtable(L, 0, 8);

		setField(L, "chance", spellBlock.chance);
		setField(L, "isCombatSpell", spellBlock.combatSpell ? 1 : 0);
		setField(L, "isMelee", spellBlock.isMelee ? 1 : 0);
		setField(L, "minCombatValue", spellBlock.minCombatValue);
		setField(L, "maxCombatValue", spellBlock.maxCombatValue);
		setField(L, "range", spellBlock.range);
		setField(L, "speed", spellBlock.speed);
		pushUserdata<CombatSpell>(L, static_cast<CombatSpell*>(spellBlock.spell));
		lua_setfield(L, -2, "spell");

		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetTypeName(lua_State* L) {
	// monsterType:getTypeName()
	const MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		return 1;
	}

	pushString(L, monsterType->typeName);
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddDefense(lua_State* L) {
	// monsterType:addDefense(monsterspell)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		MonsterSpell* spell = getUserdata<MonsterSpell>(L, 2);
		if (spell) {
			spellBlock_t sb;
			if (g_monsters().deserializeSpell(spell, sb, monsterType->name)) {
				monsterType->info.defenseSpells.push_back(std::move(sb));
			} else {
				SPDLOG_WARN("Monster: {}, Cant load spell: {}", monsterType->name,
					spell->name);
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
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		CombatType_t element = getNumber<CombatType_t>(L, 2);
		monsterType->info.elementMap[element] = getNumber<int32_t>(L, 3);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddReflect(lua_State* L) {
	// monsterType:addReflect(type, percent)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		CombatType_t element = getNumber<CombatType_t>(L, 2);
		monsterType->info.reflectMap[element] = getNumber<int32_t>(L, 3);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddHealing(lua_State* L) {
	// monsterType:addHealing(type, percent)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		CombatType_t element = getNumber<CombatType_t>(L, 2);
		monsterType->info.healingMap[element] = getNumber<int32_t>(L, 3);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetElementList(lua_State* L) {
	// monsterType:getElementList()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, monsterType->info.elementMap.size(), 0);
	for (const auto& elementEntry : monsterType->info.elementMap) {
		lua_pushnumber(L, elementEntry.second);
		lua_rawseti(L, -2, elementEntry.first);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddVoice(lua_State* L) {
	// monsterType:addVoice(sentence, interval, chance, yell)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		voiceBlock_t voice;
		voice.text = getString(L, 2);
		monsterType->info.yellSpeedTicks = getNumber<uint32_t>(L, 3);
		monsterType->info.yellChance = getNumber<uint32_t>(L, 4);
		voice.yellText = getBoolean(L, 5);
		monsterType->info.voiceVector.push_back(voice);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetVoices(lua_State* L) {
	// monsterType:getVoices()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, monsterType->info.voiceVector.size(), 0);
	for (const auto& voiceBlock : monsterType->info.voiceVector) {
		lua_createtable(L, 0, 2);
		setField(L, "text", voiceBlock.text);
		setField(L, "yellText", voiceBlock.yellText);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetLoot(lua_State* L) {
	// monsterType:getLoot()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	createMonsterTypeLootLuaTable(L, monsterType->info.lootItems);
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddLoot(lua_State* L) {
	// monsterType:addLoot(loot)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		Loot* loot = getUserdata<Loot>(L, 2);
		if (loot) {
			monsterType->loadLoot(monsterType, loot->lootBlock);
			pushBoolean(L, true);
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
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, monsterType->info.scripts.size(), 0);
	for (const std::string& creatureEvent : monsterType->info.scripts) {
		pushString(L, creatureEvent);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeRegisterEvent(lua_State* L) {
	// monsterType:registerEvent(name)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		monsterType->info.scripts.push_back(getString(L, 2));
		pushBoolean(L, true);
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
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (monsterType->loadCallback(&g_scripts().getScriptInterface())) {
			pushBoolean(L, true);
			return 1;
		 }
		pushBoolean(L, false);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeEventType(lua_State* L) {
	// monstertype:eventType(event)
	MonsterType* mType = getUserdata<MonsterType>(L, 1);
	if (mType) {
		mType->info.eventType = getNumber<MonstersEvent_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetSummonList(lua_State* L) {
	// monsterType:getSummonList()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, monsterType->info.summons.size(), 0);
	for (const auto& summonBlock : monsterType->info.summons) {
		lua_createtable(L, 0, 3);
		setField(L, "name", summonBlock.name);
		setField(L, "speed", summonBlock.speed);
		setField(L, "chance", summonBlock.chance);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddSummon(lua_State* L) {
	// monsterType:addSummon(name, interval, chance[, count = 1])
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		summonBlock_t summon;
		summon.name = getString(L, 2);
		summon.speed = getNumber<int32_t>(L, 3);
		summon.count = getNumber<int32_t>(L, 5, 1);
		summon.chance = getNumber<int32_t>(L, 4);
		monsterType->info.summons.push_back(summon);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeMaxSummons(lua_State* L) {
	// get: monsterType:maxSummons() set: monsterType:maxSummons(ammount)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.maxSummons);
		} else {
			monsterType->info.maxSummons = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeArmor(lua_State* L) {
	// get: monsterType:armor() set: monsterType:armor(armor)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.armor);
		} else {
			monsterType->info.armor = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeDefense(lua_State* L) {
	// get: monsterType:defense() set: monsterType:defense(defense)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.defense);
		} else {
			monsterType->info.defense = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeOutfit(lua_State* L) {
	// get: monsterType:outfit() set: monsterType:outfit(outfit)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushOutfit(L, monsterType->info.outfit);
		} else {
			Outfit_t outfit = getOutfit(L, 2);
			if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && outfit.lookType != 0 && !g_game().isLookTypeRegistered(outfit.lookType)) {
				SPDLOG_WARN("[MonsterTypeFunctions::luaMonsterTypeOutfit] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", outfit.lookType);
				lua_pushnil(L);
			} else {
				monsterType->info.outfit = outfit;
				pushBoolean(L, true);
			}
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeRace(lua_State* L) {
	// get: monsterType:race() set: monsterType:race(race)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	std::string race = getString(L, 2);
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
				SPDLOG_WARN("[MonsterTypeFunctions::luaMonsterTypeRace] - "
							"Unknown race type {}", race);
				lua_pushnil(L);
				return 1;
			}
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCorpseId(lua_State* L) {
	// get: monsterType:corpseId() set: monsterType:corpseId(id)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.lookcorpse);
		} else {
			monsterType->info.lookcorpse = getNumber<uint16_t>(L, 2);
			lua_pushboolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeManaCost(lua_State* L) {
	// get: monsterType:manaCost() set: monsterType:manaCost(mana)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.manaCost);
		} else {
			monsterType->info.manaCost = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeBaseSpeed(lua_State* L) {
	// monsterType:baseSpeed()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->getBaseSpeed());
		} else {
			monsterType->setBaseSpeed(getNumber<uint16_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}
int MonsterTypeFunctions::luaMonsterTypeLight(lua_State* L) {
	// get: monsterType:light() set: monsterType:light(color, level)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, monsterType->info.light.level);
		lua_pushnumber(L, monsterType->info.light.color);
		return 2;
	} else {
		monsterType->info.light.color = getNumber<uint8_t>(L, 2);
		monsterType->info.light.level = getNumber<uint8_t>(L, 3);
		pushBoolean(L, true);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeStaticAttackChance(lua_State* L) {
	// get: monsterType:staticAttackChance() set: monsterType:staticAttackChance(chance)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.staticAttackChance);
		} else {
			monsterType->info.staticAttackChance = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeTargetDistance(lua_State* L) {
	// get: monsterType:targetDistance() set: monsterType:targetDistance(distance)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.targetDistance);
		} else {
			monsterType->info.targetDistance = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeYellChance(lua_State* L) {
	// get: monsterType:yellChance() set: monsterType:yellChance(chance)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.yellChance);
		} else {
			monsterType->info.yellChance = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
		} else {
			monsterType->info.yellChance = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeYellSpeedTicks(lua_State* L) {
	// get: monsterType:yellSpeedTicks() set: monsterType:yellSpeedTicks(rate)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.yellSpeedTicks);
		} else {
			monsterType->info.yellSpeedTicks = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeChangeTargetChance(lua_State* L) {
	// monsterType:getChangeTargetChance()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.changeTargetChance);
		} else {
			monsterType->info.changeTargetChance = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeChangeTargetSpeed(lua_State* L) {
	// get: monsterType:changeTargetSpeed() set: monsterType:changeTargetSpeed(speed)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.changeTargetSpeed);
		} else {
			monsterType->info.changeTargetSpeed = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCanWalkOnEnergy(lua_State* L) {
	// get: monsterType:canWalkOnEnergy() set: monsterType:canWalkOnEnergy(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.canWalkOnEnergy);
		} else {
			monsterType->info.canWalkOnEnergy = getBoolean(L, 2, true);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCanWalkOnFire(lua_State* L) {
	// get: monsterType:canWalkOnFire() set: monsterType:canWalkOnFire(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.canWalkOnFire);
		} else {
			monsterType->info.canWalkOnFire = getBoolean(L, 2, true);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeCanWalkOnPoison(lua_State* L) {
	// get: monsterType:canWalkOnPoison() set: monsterType:canWalkOnPoison(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.canWalkOnPoison);
		} else {
			monsterType->info.canWalkOnPoison = getBoolean(L, 2, true);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeStrategiesTargetNearest(lua_State* L) {
	// monsterType:strategiesTargetNearest()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.strategiesTargetNearest);
		} else {
			monsterType->info.strategiesTargetNearest = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeStrategiesTargetHealth(lua_State* L) {
	// monsterType:strategiesTargetHealth()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.strategiesTargetHealth);
		} else {
			monsterType->info.strategiesTargetHealth = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeStrategiesTargetDamage(lua_State* L) {
	// monsterType:strategiesTargetDamage()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.strategiesTargetDamage);
		} else {
			monsterType->info.strategiesTargetDamage = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeStrategiesTargetRandom(lua_State* L) {
	// monsterType:strategiesTargetRandom()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.strategiesTargetRandom);
		} else {
			monsterType->info.strategiesTargetRandom = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
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
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.respawnType.period);
		} else {
			monsterType->info.respawnType.period = getNumber<RespawnPeriod_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeRespawnTypeIsUnderground(lua_State* L) {
	// monsterType:respawnTypeIsUnderground()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.respawnType.underground);
		} else {
			monsterType->info.respawnType.underground = getNumber<RespawnPeriod_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeSoundChance(lua_State* L) {
	// get: monsterType:soundChance() set: monsterType:soundChance(chance)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, monsterType->info.soundChance);
	} else {
		monsterType->info.soundChance = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeSoundSpeedTicks(lua_State* L) {
	// get: monsterType:soundSpeedTicks() set: monsterType:soundSpeedTicks(ticks)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, monsterType->info.soundSpeedTicks);
	} else {
		monsterType->info.soundSpeedTicks = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeAddSound(lua_State* L) {
	// monsterType:addSound(soundId)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	monsterType->info.soundVector.push_back(getNumber<SoundEffect_t>(L, 2));
	pushBoolean(L, true);
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypeGetSounds(lua_State* L) {
	// monsterType:getSounds()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, monsterType->info.soundVector.size(), 0);
	for (const auto& sound : monsterType->info.soundVector) {
		lua_createtable(L, 0, 1);
		lua_pushnumber(L, sound);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterTypeFunctions::luaMonsterTypedeathSound(lua_State* L) {
	// get: monsterType:deathSound() set: monsterType:deathSound(sound)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, monsterType->info.deathSound);
	} else {
		monsterType->info.deathSound = getNumber<SoundEffect_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}
