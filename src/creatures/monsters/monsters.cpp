/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monsters.hpp"

#include "config/configmanager.hpp"
#include "creatures/combat/combat.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/combat/spells.hpp"
#include "game/game.hpp"
#include "items/weapons/weapons.hpp"
#include "lua/scripts/luascript.hpp"
#include "lib/di/container.hpp"

void MonsterType::loadLoot(const std::shared_ptr<MonsterType> &monsterType, LootBlock lootBlock) const {
	if (lootBlock.childLoot.empty()) {
		const bool isContainer = Item::items[lootBlock.id].isContainer();
		if (isContainer) {
			for (const LootBlock &child : lootBlock.childLoot) {
				lootBlock.childLoot.emplace_back(child);
			}
		}
		monsterType->info.lootItems.emplace_back(lootBlock);
	} else {
		monsterType->info.lootItems.emplace_back(lootBlock);
	}
}

bool MonsterType::canSpawn(const Position &pos) const {
	bool canSpawn = true;
	const bool isDay = g_game().gameIsDay();

	if ((isDay && info.respawnType.period == RESPAWNPERIOD_NIGHT) || (!isDay && info.respawnType.period == RESPAWNPERIOD_DAY)) {
		// It will ignore day and night if underground
		canSpawn = (pos.z > MAP_INIT_SURFACE_LAYER && info.respawnType.underground);
	}

	return canSpawn;
}

std::shared_ptr<ConditionDamage> Monsters::getDamageCondition(ConditionType_t conditionType, int32_t maxDamage, int32_t minDamage, int32_t startDamage, uint32_t tickInterval) const {
	const auto &condition = Condition::createCondition(CONDITIONID_COMBAT, conditionType, 0, 0)->static_self_cast<ConditionDamage>();
	condition->setParam(CONDITION_PARAM_TICKINTERVAL, tickInterval);
	condition->setParam(CONDITION_PARAM_MINVALUE, minDamage);
	condition->setParam(CONDITION_PARAM_MAXVALUE, maxDamage);
	condition->setParam(CONDITION_PARAM_STARTVALUE, startDamage);
	condition->setParam(CONDITION_PARAM_DELAYED, 1);
	return condition;
}

bool Monsters::deserializeSpell(const std::shared_ptr<MonsterSpell> &spell, spellBlock_t &sb, const std::string &description) const {
	if (!spell->scriptName.empty()) {
		spell->isScripted = true;
	} else if (!spell->name.empty()) {
		spell->isScripted = false;
	} else {
		return false;
	}

	sb.speed = spell->interval;
	sb.chance = std::min(static_cast<int>(spell->chance), 100);
	sb.range = std::min(static_cast<int>(spell->range), MAP_MAX_VIEW_PORT_X * 2);
	sb.minCombatValue = std::min(spell->minCombatValue, spell->maxCombatValue);
	sb.maxCombatValue = std::max(spell->minCombatValue, spell->maxCombatValue);
	sb.soundCastEffect = spell->soundCastEffect;
	sb.soundImpactEffect = spell->soundImpactEffect;
	sb.spell = g_spells().getSpellByName(spell->name);

	if (sb.spell) {
		return true;
	}

	std::shared_ptr<CombatSpell> combatSpell;

	auto combatPtr = std::make_shared<Combat>();

	sb.combatSpell = true;

	if (spell->length > 0) {
		spell->spread = std::max<int32_t>(0, spell->spread);

		auto area = std::make_unique<AreaCombat>();
		area->setupArea(spell->length, spell->spread);
		combatPtr->setArea(area);

		spell->needDirection = true;
	}

	if (spell->radius > 0) {
		auto area = std::make_unique<AreaCombat>();
		area->setupArea(spell->radius);
		combatPtr->setArea(area);
	}

	if (const std::string spellName = asLowerCaseString(spell->name);
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
				// Cant be slower than 100%
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

		const auto &condition = Condition::createCondition(CONDITIONID_COMBAT, conditionType, duration, 0)->static_self_cast<ConditionSpeed>();
		const float multiplier = 1.0f + static_cast<float>(speedChange) / 1000.0f;
		condition->setFormulaVars(multiplier / 2, 40, multiplier, 40);
		combatPtr->addCondition(condition);
	} else if (spellName == "outfit") {
		int32_t duration = 10000;

		if (spell->duration != 0) {
			duration = spell->duration;
		}

		const auto &condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_OUTFIT, duration, 0)->static_self_cast<ConditionOutfit>();

		if (!spell->outfitMonster.empty()) {
			condition->setLazyMonsterOutfit(spell->outfitMonster);
		} else if (spell->outfitItem > 0) {
			Outfit_t outfit;
			outfit.lookTypeEx = spell->outfitItem;
			condition->setOutfit(outfit);
		} else {
			g_logger().error("[Monsters::deserializeSpell] - "
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

		const auto &condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_INVISIBLE, duration, 0);
		combatPtr->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
		combatPtr->addCondition(condition);
	} else if (spellName == "drunk") {
		int32_t duration = 10000;

		if (spell->duration != 0) {
			duration = spell->duration;
		}

		const auto &condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_DRUNK, duration, 0);
		combatPtr->addCondition(condition);
	} else if (spellName == "soulwars fear" || spellName == "fear") {
		int32_t duration = 6000;

		if (spell->duration != 0) {
			duration = spell->duration;
		}

		const auto &condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_FEARED, duration, 0);
		combatPtr->addCondition(condition);
	} else if (spellName == "firefield") {
		combatPtr->setParam(COMBAT_PARAM_CREATEITEM, ITEM_FIREFIELD_PVP_FULL);
	} else if (spellName == "poisonfield") {
		combatPtr->setParam(COMBAT_PARAM_CREATEITEM, ITEM_POISONFIELD_PVP);
	} else if (spellName == "energyfield") {
		combatPtr->setParam(COMBAT_PARAM_CREATEITEM, ITEM_ENERGYFIELD_PVP);
	} else if (spellName == "condition") {
		if (spell->conditionType == CONDITION_NONE) {
			g_logger().error("[Monsters::deserializeSpell] - "
			                 "{} condition is not set for: {}",
			                 description, spell->name);
		}
	} else if (spellName == "strength") {
		//
	} else if (spellName == "effect") {
		//
	} else {
		g_logger().error("[Monsters::deserializeSpell] - "
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
		const int32_t minDamage = std::abs(spell->conditionMinDamage);
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

		const auto &condition = getDamageCondition(spell->conditionType, maxDamage, minDamage, startDamage, tickInterval);
		combatPtr->addCondition(condition);
	}

	combatPtr->setPlayerCombatValues(COMBAT_FORMULA_DAMAGE, sb.minCombatValue, 0, sb.maxCombatValue, 0);
	combatSpell = std::make_shared<CombatSpell>(combatPtr, spell->needTarget, spell->needDirection);
	// Sanity check
	if (!combatSpell) {
		return false;
	}

	combatSpell->soundCastEffect = sb.soundCastEffect;
	combatSpell->soundImpactEffect = sb.soundImpactEffect;

	sb.spell = combatSpell;
	if (combatSpell) {
		sb.combatSpell = true;
	}

	return true;
}

bool MonsterType::loadCallback(LuaScriptInterface* scriptInterface) {
	const int32_t id = scriptInterface->getEvent();
	if (id == -1) {
		g_logger().warn("[MonsterType::loadCallback] - Event not found");
		return false;
	}

	info.scriptInterface = scriptInterface;

	switch (info.eventType) {
		case MONSTERS_EVENT_THINK:
			info.thinkEvent = id;
			break;
		case MONSTERS_EVENT_APPEAR:
			info.creatureAppearEvent = id;
			break;
		case MONSTERS_EVENT_DISAPPEAR:
			info.creatureDisappearEvent = id;
			break;
		case MONSTERS_EVENT_MOVE:
			info.creatureMoveEvent = id;
			break;
		case MONSTERS_EVENT_SAY:
			info.creatureSayEvent = id;
			break;
		case MONSTERS_EVENT_ATTACKED_BY_PLAYER:
			info.monsterAttackedByPlayerEvent = id;
			break;
		case MONSTERS_EVENT_ON_SPAWN:
			info.spawnEvent = id;
			break;
		default:
			g_logger().error("[MonsterType::loadCallback] - Unknown event type");
			return false;
	}

	return true;
}

uint16_t MonsterType::getBaseSpeed() const {
	return info.baseSpeed;
}

void MonsterType::setBaseSpeed(const uint16_t initBaseSpeed) {
	info.baseSpeed = initBaseSpeed;
}

float MonsterType::getHealthMultiplier() const {
	return isBoss() ? g_configManager().getFloat(RATE_BOSS_HEALTH) : g_configManager().getFloat(RATE_MONSTER_HEALTH);
}

float MonsterType::getAttackMultiplier() const {
	return isBoss() ? g_configManager().getFloat(RATE_BOSS_ATTACK) : g_configManager().getFloat(RATE_MONSTER_ATTACK);
}

float MonsterType::getDefenseMultiplier() const {
	return isBoss() ? g_configManager().getFloat(RATE_BOSS_DEFENSE) : g_configManager().getFloat(RATE_MONSTER_DEFENSE);
}

bool MonsterType::isBoss() const {
	return !info.bosstiaryClass.empty();
}

Monsters &Monsters::getInstance() {
	return inject<Monsters>();
}

void Monsters::clear() {
	monsters.clear();
}

std::shared_ptr<MonsterType> Monsters::getMonsterType(const std::string &name, bool silent /* = false*/) const {
	std::string lowerCaseName = asLowerCaseString(name);
	if (auto it = monsters.find(lowerCaseName);
	    it != monsters.end()
	    // We will only return the MonsterType if it match the exact name of the monster
	    && it->first.find(lowerCaseName) != std::basic_string<char>::npos) {
		return it->second;
	}
	if (!silent) {
		g_logger().error("[Monsters::getMonsterType] - Monster with name {} not exist", lowerCaseName);
	}
	return nullptr;
}

std::shared_ptr<MonsterType> Monsters::getMonsterTypeByRaceId(uint16_t raceId, bool isBoss /* = false*/) const {
	const auto &bossType = g_ioBosstiary().getMonsterTypeByBossRaceId(raceId);
	if (isBoss && bossType) {
		return bossType;
	}

	const auto &monster_race_map = g_game().getBestiaryList();
	auto it = monster_race_map.find(raceId);
	if (it == monster_race_map.end()) {
		return nullptr;
	}

	return g_monsters().getMonsterType(it->second);
}

bool Monsters::tryAddMonsterType(const std::string &name, const std::shared_ptr<MonsterType> &mType) {
	const std::string lowerName = asLowerCaseString(name);
	if (monsters.contains(lowerName)) {
		g_logger().debug("[{}] the monster with name '{}' already exist", __FUNCTION__, name);
		return false;
	}

	monsters[lowerName] = mType;
	return true;
}
