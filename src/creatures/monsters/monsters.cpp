/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
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

#include "otpch.h"

#include "creatures/monsters/monsters.h"
#include "creatures/monsters/monster.h"
#include "creatures/combat/spells.h"
#include "creatures/combat/combat.h"
#include "items/weapons/weapons.h"
#include "game/game.h"

spellBlock_t::~spellBlock_t()
{
	if (combatSpell) {
		delete spell;
	}
}

void MonsterType::loadLoot(MonsterType* monsterType, LootBlock lootBlock)
{
	if (lootBlock.childLoot.empty()) {
		bool isContainer = Item::items[lootBlock.id].isContainer();
		if (isContainer) {
			for (LootBlock child : lootBlock.childLoot) {
				lootBlock.childLoot.push_back(child);
			}
		}
		monsterType->info.lootItems.push_back(lootBlock);
	} else {
		monsterType->info.lootItems.push_back(lootBlock);
	}
}

bool MonsterType::canSpawn(const Position& pos)
{
	bool canSpawn = true;
	bool isDay = g_game().gameIsDay();

	if ((isDay && info.respawnType.period == RESPAWNPERIOD_NIGHT) ||
		(!isDay && info.respawnType.period == RESPAWNPERIOD_DAY)) {
		// It will ignore day and night if underground
		canSpawn = (pos.z > 7 && info.respawnType.underground);
	}

	return canSpawn;
}

ConditionDamage* Monsters::getDamageCondition(ConditionType_t conditionType,
		int32_t maxDamage, int32_t minDamage, int32_t startDamage, uint32_t tickInterval)
{
	ConditionDamage* condition = static_cast<ConditionDamage*>(Condition::createCondition(CONDITIONID_COMBAT, conditionType, 0, 0));
	condition->setParam(CONDITION_PARAM_TICKINTERVAL, tickInterval);
	condition->setParam(CONDITION_PARAM_MINVALUE, minDamage);
	condition->setParam(CONDITION_PARAM_MAXVALUE, maxDamage);
	condition->setParam(CONDITION_PARAM_STARTVALUE, startDamage);
	condition->setParam(CONDITION_PARAM_DELAYED, 1);
	return condition;
}

bool Monsters::deserializeSpell(MonsterSpell* spell, spellBlock_t& sb, const std::string& description)
{
	if (!spell->scriptName.empty()) {
		spell->isScripted = true;
	} else if (!spell->name.empty()) {
		spell->isScripted = false;
	} else {
		return false;
	}

	sb.speed = spell->interval;

	if (spell->chance > 100) {
		sb.chance = 100;
	} else {
		sb.chance = spell->chance;
	}

	if (spell->range > (Map::maxViewportX * 2)) {
		spell->range = Map::maxViewportX * 2;
	}
	sb.range = spell->range;

	sb.minCombatValue = spell->minCombatValue;
	sb.maxCombatValue = spell->maxCombatValue;
	if (std::abs(sb.minCombatValue) > std::abs(sb.maxCombatValue)) {
		int32_t value = sb.maxCombatValue;
		sb.maxCombatValue = sb.minCombatValue;
		sb.minCombatValue = value;
	}

	sb.spell = g_spells().getSpellByName(spell->name);
	if (sb.spell) {
		return true;
	}

	CombatSpell* combatSpell = nullptr;

	if (spell->isScripted) {
		std::unique_ptr<CombatSpell> combatSpellPtr(new CombatSpell(nullptr, spell->needTarget, spell->needDirection));
		if (!combatSpellPtr->loadScript("data/scripts/" + spell->scriptName)) {
			SPDLOG_ERROR("[Monsters::deserializeSpell] - Cannot find file: {}",
                         spell->scriptName);
			return false;
		}

		if (!combatSpellPtr->loadScriptCombat()) {
			return false;
		}

		combatSpell = combatSpellPtr.release();
		combatSpell->getCombat()->setPlayerCombatValues(COMBAT_FORMULA_DAMAGE, sb.minCombatValue, 0, sb.maxCombatValue, 0);
	} else {
		std::unique_ptr<Combat> combat{ new Combat };
		sb.combatSpell = true;

		if (spell->length > 0) {
			spell->spread = std::max<int32_t>(0, spell->spread);

			AreaCombat* area = new AreaCombat();
			area->setupArea(spell->length, spell->spread);
			combat->setArea(area);

			spell->needDirection = true;
		}

		if (spell->radius > 0) {
			AreaCombat* area = new AreaCombat();
			area->setupArea(spell->radius);
			combat->setArea(area);
		}

		std::string tmpName = asLowerCaseString(spell->name);
		if (!strcasecmp(tmpName.c_str(), "melee")) {
			sb.isMelee = true;

			if (spell->attack > 0 && spell->skill > 0) {
				sb.minCombatValue = 0;
				sb.maxCombatValue = -Weapons::getMaxMeleeDamage(spell->skill, spell->attack);
			}

			ConditionType_t conditionType = CONDITION_NONE;
			int32_t minDamage = 0;
			int32_t maxDamage = 0;
			uint32_t tickInterval = 2000;

			if (spell->conditionType != CONDITION_NONE) {
				conditionType = spell->conditionType;

				minDamage = spell->conditionMinDamage;
				maxDamage = minDamage;
				if (spell->tickInterval != 0) {
					tickInterval = spell->tickInterval;
				}

				Condition* condition = getDamageCondition(conditionType, maxDamage, minDamage, spell->conditionStartDamage, tickInterval);
				combat->addCondition(condition);
			}

			sb.range = 1;
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE);
			combat->setParam(COMBAT_PARAM_BLOCKARMOR, 1);
			combat->setParam(COMBAT_PARAM_BLOCKSHIELD, 1);
			combat->setOrigin(ORIGIN_MELEE);
		} else if (!strcasecmp(tmpName.c_str(), "combat")) {
			if (spell->combatType == COMBAT_PHYSICALDAMAGE) {
				combat->setParam(COMBAT_PARAM_BLOCKARMOR, 1);
				combat->setOrigin(ORIGIN_RANGED);
			} else if (spell->combatType == COMBAT_HEALING) {
				combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
			}
			combat->setParam(COMBAT_PARAM_TYPE, spell->combatType);
		} else if (!strcasecmp(tmpName.c_str(), "speed")) {
			int32_t minSpeedChange = spell->minSpeedChange;
			int32_t maxSpeedChange = spell->maxSpeedChange;
			int32_t duration = 10000;

			if (spell->duration != 0) {
				duration = spell->duration;
			}

			if (maxSpeedChange == 0) {
				maxSpeedChange = minSpeedChange; // static speedchange value
			}

			//cant be slower than 100%
			if (minSpeedChange < -1000) {
				minSpeedChange = -1000;
			}
			if (maxSpeedChange < -1000) {
				maxSpeedChange = -1000;
			}

			ConditionType_t conditionType;
			if ((minSpeedChange < 0) == (maxSpeedChange < 0)) {
				if (minSpeedChange > 0) {
					conditionType = CONDITION_HASTE;
					combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
				} else {
					conditionType = CONDITION_PARALYZE;
				}
			} else {
				std::cout << "[Error - Monsters::deserializeSpell] - " << description << " - can't determine condition type because minSpeedChange/maxSpeedChange sign mismatch" << std::endl;
				delete spell;
				return false;
			}

			ConditionSpeed* condition = static_cast<ConditionSpeed*>(Condition::createCondition(CONDITIONID_COMBAT, conditionType, duration, 0));
			condition->setFormulaVars(minSpeedChange / 1000.0, 0, maxSpeedChange / 1000.0, 0);
			combat->addCondition(condition);
		} else if (!strcasecmp(tmpName.c_str(), "outfit")) {
			int32_t duration = 10000;

			if (spell->duration != 0) {
				duration = spell->duration;
			}

			ConditionOutfit* condition = static_cast<ConditionOutfit*>(Condition::createCondition(CONDITIONID_COMBAT, CONDITION_OUTFIT, duration, 0));

			if (spell->outfitMonster != "") {
				condition->setLazyMonsterOutfit(spell->outfitMonster);
			} else if (spell->outfitItem > 0) {
				Outfit_t outfit;
				outfit.lookTypeEx = spell->outfitItem;
				condition->setOutfit(outfit);
			} else {
				SPDLOG_ERROR("[Monsters::deserializeSpell] - "
                             "Missing outfit monster or item in outfit spell for: {}",
                            description);
				return false;
			}

			combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
			combat->addCondition(condition);
		} else if (!strcasecmp(tmpName.c_str(), "invisible")) {
			int32_t duration = 10000;

			if (spell->duration != 0) {
				duration = spell->duration;
			}

			Condition* condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_INVISIBLE, duration, 0);
			combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
			combat->addCondition(condition);
		} else if (!strcasecmp(tmpName.c_str(), "drunk")) {
			int32_t duration = 10000;

			if (spell->duration != 0) {
				duration = spell->duration;
			}

			Condition* condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_DRUNK, duration, 0);
			combat->addCondition(condition);
		} else if (!strcasecmp(tmpName.c_str(), "firefield")) {
			combat->setParam(COMBAT_PARAM_CREATEITEM, ITEM_FIREFIELD_PVP_FULL);
		} else if (!strcasecmp(tmpName.c_str(), "poisonfield")) {
			combat->setParam(COMBAT_PARAM_CREATEITEM, ITEM_POISONFIELD_PVP);
		} else if (!strcasecmp(tmpName.c_str(), "energyfield")) {
			combat->setParam(COMBAT_PARAM_CREATEITEM, ITEM_ENERGYFIELD_PVP);
		} else if (!strcasecmp(tmpName.c_str(), "condition")) {
			uint32_t tickInterval = 2000;

			if (spell->conditionType == CONDITION_NONE) {
				std::cout << "[Error - Monsters::deserializeSpell] - " << description << " - Condition is not set for: " << spell->name << std::endl;
			}

			if (spell->tickInterval != 0) {
				int32_t value = spell->tickInterval;
				if (value > 0) {
					tickInterval = value;
				}
			}

			int32_t minDamage = std::abs(spell->conditionMinDamage);
			int32_t maxDamage = std::abs(spell->conditionMaxDamage);
			int32_t startDamage = 0;

			if (spell->conditionStartDamage != 0) {
				int32_t value = std::abs(spell->conditionStartDamage);
				if (value <= minDamage) {
					startDamage = value;
				}
			}

			Condition* condition = getDamageCondition(spell->conditionType, maxDamage, minDamage, startDamage, tickInterval);
			combat->addCondition(condition);
		} else if (!strcasecmp(tmpName.c_str(), "strength")) {
			//
		} else if (!strcasecmp(tmpName.c_str(), "effect")) {
			//
		} else {
			std::cout << "[Error - Monsters::deserializeSpell] - " << description << " - Unknown spell name: " << spell->name << std::endl;
		}

		if (spell->needTarget) {
			if (spell->shoot != CONST_ANI_NONE) {
				combat->setParam(COMBAT_PARAM_DISTANCEEFFECT, spell->shoot);
			}
		}

		if (spell->effect != CONST_ME_NONE) {
			combat->setParam(COMBAT_PARAM_EFFECT, spell->effect);
		}

		combat->setPlayerCombatValues(COMBAT_FORMULA_DAMAGE, sb.minCombatValue, 0, sb.maxCombatValue, 0);
		combatSpell = new CombatSpell(combat.release(), spell->needTarget, spell->needDirection);
	}

	sb.spell = combatSpell;
	if (combatSpell) {
		sb.combatSpell = true;
	}
	return true;
}

bool MonsterType::loadCallback(LuaScriptInterface* scriptInterface)
{
	int32_t id = scriptInterface->getEvent();
	if (id == -1) {
		SPDLOG_WARN("[MonsterType::loadCallback] - Event not found");
		return false;
	}

	info.scriptInterface = scriptInterface;
	if (info.eventType == MONSTERS_EVENT_THINK) {
		info.thinkEvent = id;
	} else if (info.eventType == MONSTERS_EVENT_APPEAR) {
		info.creatureAppearEvent = id;
	} else if (info.eventType == MONSTERS_EVENT_DISAPPEAR) {
		info.creatureDisappearEvent = id;
	} else if (info.eventType == MONSTERS_EVENT_MOVE) {
		info.creatureMoveEvent = id;
	} else if (info.eventType == MONSTERS_EVENT_SAY) {
		info.creatureSayEvent = id;
	}
	return true;
}

MonsterType* Monsters::getMonsterType(const std::string& name)
{
	std::string lowerCaseName = asLowerCaseString(name);
	if (auto it = monsters.find(lowerCaseName);
	it != monsters.end())
	{
		return &it->second;
	}
	return nullptr;
}

MonsterType* Monsters::getMonsterTypeByRaceId(uint16_t thisrace) {
	std::map<uint16_t, std::string> raceid_list = g_game().getBestiaryList();
	auto it = raceid_list.find(thisrace);
	if (it == raceid_list.end()) {
		return nullptr;
	}
	MonsterType* mtype = g_monsters().getMonsterType(it->second);
	return (mtype ? mtype : nullptr);
}

void Monsters::addMonsterType(const std::string& name, MonsterType* mType)
{
	// Suppress [-Werror=unused-but-set-parameter]
	// https://stackoverflow.com/questions/1486904/how-do-i-best-silence-a-warning-about-unused-variables
	(void) mType;
	mType = &monsters[asLowerCaseString(name)];
}
