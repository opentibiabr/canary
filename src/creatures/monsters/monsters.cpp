/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/monsters/monsters.h"

#include "creatures/combat/spells.h"
#include "creatures/combat/combat.h"
#include "game/game.h"
#include "items/weapons/weapons.h"

spellBlock_t::~spellBlock_t() {
	if (combatSpell) {
		delete spell;
	}
}

void MonsterType::loadLoot(MonsterType* monsterType, LootBlock lootBlock) {
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

bool MonsterType::canSpawn(const Position &pos) {
	bool canSpawn = true;
	bool isDay = g_game().gameIsDay();

	if ((isDay && info.respawnType.period == RESPAWNPERIOD_NIGHT) || (!isDay && info.respawnType.period == RESPAWNPERIOD_DAY)) {
		// It will ignore day and night if underground
		canSpawn = (pos.z > MAP_INIT_SURFACE_LAYER && info.respawnType.underground);
	}

	return canSpawn;
}

ConditionDamage* Monsters::getDamageCondition(ConditionType_t conditionType, int32_t maxDamage, int32_t minDamage, int32_t startDamage, uint32_t tickInterval) {
	ConditionDamage* condition = static_cast<ConditionDamage*>(Condition::createCondition(CONDITIONID_COMBAT, conditionType, 0, 0));
	condition->setParam(CONDITION_PARAM_TICKINTERVAL, tickInterval);
	condition->setParam(CONDITION_PARAM_MINVALUE, minDamage);
	condition->setParam(CONDITION_PARAM_MAXVALUE, maxDamage);
	condition->setParam(CONDITION_PARAM_STARTVALUE, startDamage);
	condition->setParam(CONDITION_PARAM_DELAYED, 1);
	return condition;
}

bool Monsters::deserializeSpell(MonsterSpell* spell, spellBlock_t &sb, const std::string &description) {
	if (!spell->scriptName.empty()) {
		spell->isScripted = true;
	} else if (!spell->name.empty()) {
		spell->isScripted = false;
	} else {
		return false;
	}

	sb.speed = spell->interval;
	sb.chance = std::min((int)spell->chance, 100);
	sb.range = std::min((int)spell->range, Map::maxViewportX * 2);
	sb.minCombatValue = std::min(spell->minCombatValue, spell->maxCombatValue);
	sb.maxCombatValue = std::max(spell->minCombatValue, spell->maxCombatValue);
	sb.spell = g_spells().getSpellByName(spell->name);

	if (sb.spell) {
		return true;
	}

	CombatSpell* combatSpell = nullptr;

	auto combatPtr = std::make_unique<Combat>();

	sb.combatSpell = true;

	if (spell->length > 0) {
		spell->spread = std::max<int32_t>(0, spell->spread);

		AreaCombat* area = new AreaCombat();
		area->setupArea(spell->length, spell->spread);
		combatPtr->setArea(area);

		spell->needDirection = true;
	}

	if (spell->radius > 0) {
		AreaCombat* area = new AreaCombat();
		area->setupArea(spell->radius);
		combatPtr->setArea(area);
	}

	if (std::string spellName = asLowerCaseString(spell->name);
		spellName == "melee") {
		sb.isMelee = true;

		if (spell->attack > 0 && spell->skill > 0) {
			sb.minCombatValue = 0;
			sb.maxCombatValue = -Weapons::getMaxMeleeDamage(spell->skill, spell->attack);
		}

		sb.range = 1;
		combatPtr->setParam(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE);
		combatPtr->setParam(COMBAT_PARAM_BLOCKARMOR, 1);
		combatPtr->setParam(COMBAT_PARAM_BLOCKSHIELD, 1);
		combatPtr->setOrigin(ORIGIN_MELEE);
	} else if (spellName == "combat") {
		if (spell->combatType == COMBAT_PHYSICALDAMAGE) {
			combatPtr->setParam(COMBAT_PARAM_BLOCKARMOR, 1);
			combatPtr->setOrigin(ORIGIN_RANGED);
		} else if (spell->combatType == COMBAT_HEALING) {
			combatPtr->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
		}

		combatPtr->setParam(COMBAT_PARAM_TYPE, spell->combatType);
	} else if (spellName == "speed") {
		int32_t speedChange = 0;
		int32_t duration = 10000;

		if (spell->duration != 0) {
			duration = spell->duration;
		}

		if (spell->speedChange != 0) {
			speedChange = spell->speedChange;
			if (speedChange < -1000) {
				// cant be slower than 100%
				speedChange = -1000;
			}
		}

		ConditionType_t conditionType;
		if (speedChange > 0) {
			conditionType = CONDITION_HASTE;
			combatPtr->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
		} else {
			conditionType = CONDITION_PARALYZE;
		}

		ConditionSpeed* condition = static_cast<ConditionSpeed*>(Condition::createCondition(CONDITIONID_COMBAT, conditionType, duration, 0));
		condition->setFormulaVars(speedChange / 1000.0, 0, speedChange / 1000.0, 0);
		combatPtr->addCondition(condition);
	} else if (spellName == "outfit") {
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

		combatPtr->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
		combatPtr->addCondition(condition);
	} else if (spellName == "invisible") {
		int32_t duration = 10000;

		if (spell->duration != 0) {
			duration = spell->duration;
		}

		Condition* condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_INVISIBLE, duration, 0);
		combatPtr->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
		combatPtr->addCondition(condition);
	} else if (spellName == "drunk") {
		int32_t duration = 10000;

		if (spell->duration != 0) {
			duration = spell->duration;
		}

		Condition* condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_DRUNK, duration, 0);
		combatPtr->addCondition(condition);
	} else if (spellName == "firefield") {
		combatPtr->setParam(COMBAT_PARAM_CREATEITEM, ITEM_FIREFIELD_PVP_FULL);
	} else if (spellName == "poisonfield") {
		combatPtr->setParam(COMBAT_PARAM_CREATEITEM, ITEM_POISONFIELD_PVP);
	} else if (spellName == "energyfield") {
		combatPtr->setParam(COMBAT_PARAM_CREATEITEM, ITEM_ENERGYFIELD_PVP);
	} else if (spellName == "condition") {
		if (spell->conditionType == CONDITION_NONE) {
			SPDLOG_ERROR("[Monsters::deserializeSpell] - "
						 "{} condition is not set for: {}",
						 description, spell->name);
		}
	} else if (spellName == "strength") {
		//
	} else if (spellName == "effect") {
		//
	} else {
		SPDLOG_ERROR("[Monsters::deserializeSpell] - "
					 "{} unknown or missing parameter on spell with name: {}",
					 description, spell->name);
	}

	if (spell->shoot != CONST_ANI_NONE) {
		combatPtr->setParam(COMBAT_PARAM_DISTANCEEFFECT, spell->shoot);
	}

	if (spell->effect != CONST_ME_NONE) {
		combatPtr->setParam(COMBAT_PARAM_EFFECT, spell->effect);
	}

	// If a spell has a condition, it always applies, no matter what kind of spell it is
	if (spell->conditionType != CONDITION_NONE) {
		int32_t minDamage = std::abs(spell->conditionMinDamage);
		int32_t maxDamage = std::abs(spell->conditionMaxDamage);
		int32_t startDamage = std::abs(spell->conditionStartDamage);
		uint32_t tickInterval = 2000;

		if (spell->tickInterval > 0) {
			tickInterval = spell->tickInterval;
		}

		if (startDamage > minDamage) {
			startDamage = 0;
		}

		if (maxDamage == 0) {
			maxDamage = minDamage;
		}

		Condition* condition = getDamageCondition(spell->conditionType, maxDamage, minDamage, startDamage, tickInterval);
		combatPtr->addCondition(condition);
	}

	combatPtr->setPlayerCombatValues(COMBAT_FORMULA_DAMAGE, sb.minCombatValue, 0, sb.maxCombatValue, 0);
	combatSpell = new CombatSpell(combatPtr.release(), spell->needTarget, spell->needDirection);

	sb.spell = combatSpell;
	if (combatSpell) {
		sb.combatSpell = true;
	}

	return true;
}

bool MonsterType::loadCallback(LuaScriptInterface* scriptInterface) {
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

MonsterType* Monsters::getMonsterType(const std::string &name) {
	std::string lowerCaseName = asLowerCaseString(name);
	if (auto it = monsters.find(lowerCaseName);
		it != monsters.end()
		// We will only return the MonsterType if it match the exact name of the monster
		&& it->first.find(lowerCaseName) != it->first.npos) {
		return it->second;
	}
	SPDLOG_ERROR("[Monsters::getMonsterType] - Monster with name {} not exist", lowerCaseName);
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

void Monsters::addMonsterType(const std::string &name, MonsterType* mType) {
	std::string lowerName = asLowerCaseString(name);
	monsters[lowerName] = mType;
}