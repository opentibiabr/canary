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
	sb.chance = std::min((int) spell->chance, 100);
	sb.range = std::min((int) spell->range, Map::maxViewportX * 2);
	sb.minCombatValue = std::min(spell->minCombatValue, spell->maxCombatValue);
	sb.maxCombatValue = std::max(spell->minCombatValue, spell->maxCombatValue);
	sb.spell = g_spells().getSpellByName(spell->name);

	if (sb.spell) {
		return true;
	}

	CombatSpell* combatSpell = nullptr;

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

	if (tmpName == "melee") {
		sb.isMelee = true;

		if (spell->attack > 0 && spell->skill > 0) {
			sb.minCombatValue = 0;
			sb.maxCombatValue = -Weapons::getMaxMeleeDamage(spell->skill, spell->attack);
		}

		sb.range = 1;
		combat->setParam(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE);
		combat->setParam(COMBAT_PARAM_BLOCKARMOR, 1);
		combat->setParam(COMBAT_PARAM_BLOCKSHIELD, 1);
		combat->setOrigin(ORIGIN_MELEE);
	} else if (tmpName == "combat") {
		if (spell->combatType == COMBAT_PHYSICALDAMAGE) {
			combat->setParam(COMBAT_PARAM_BLOCKARMOR, 1);
			combat->setOrigin(ORIGIN_RANGED);
		} else if (spell->combatType == COMBAT_HEALING) {
			combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
		}
		combat->setParam(COMBAT_PARAM_TYPE, spell->combatType);
	} else if (tmpName == "speed") {
		int32_t speedChange = 0;
		int32_t duration = 10000;

		if (spell->duration != 0) {
			duration = spell->duration;
		}

		if (spell->speedChange != 0) {
			speedChange = spell->speedChange;
			if (speedChange < -1000) {
				//cant be slower than 100%
				speedChange = -1000;
			}
		}

		ConditionType_t conditionType;
		if (speedChange > 0) {
			conditionType = CONDITION_HASTE;
			combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
		} else {
			conditionType = CONDITION_PARALYZE;
		}

		ConditionSpeed* condition = static_cast<ConditionSpeed*>(Condition::createCondition(CONDITIONID_COMBAT, conditionType, duration, 0));
		condition->setFormulaVars(speedChange / 1000.0, 0, speedChange / 1000.0, 0);
		combat->addCondition(condition);
	} else if (tmpName == "outfit") {
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
	} else if (tmpName == "invisible") {
		int32_t duration = 10000;

		if (spell->duration != 0) {
			duration = spell->duration;
		}

		Condition* condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_INVISIBLE, duration, 0);
		combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
		combat->addCondition(condition);
	} else if (tmpName == "drunk") {
		int32_t duration = 10000;

		if (spell->duration != 0) {
			duration = spell->duration;
		}

		Condition* condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_DRUNK, duration, 0);
		combat->addCondition(condition);
	} else if (tmpName == "firefield") {
		combat->setParam(COMBAT_PARAM_CREATEITEM, ITEM_FIREFIELD_PVP_FULL);
	} else if (tmpName == "poisonfield") {
		combat->setParam(COMBAT_PARAM_CREATEITEM, ITEM_POISONFIELD_PVP);
	} else if (tmpName == "energyfield") {
		combat->setParam(COMBAT_PARAM_CREATEITEM, ITEM_ENERGYFIELD_PVP);
	} else if (tmpName == "condition") {
		if (spell->conditionType == CONDITION_NONE) {
			SPDLOG_ERROR("[Monsters::deserializeSpell] - "
						 "{} condition is not set for: {}"
						 , description, spell->name);
		}
	} else if (tmpName == "strength") {
		//
	} else if (tmpName == "effect") {
		//
	} else {
		SPDLOG_ERROR("[Monsters::deserializeSpell] - "
					 "{} unknown or missing parameter on spell with name: {}"
					 , description, spell->name);
	}

	if (spell->shoot != CONST_ANI_NONE) {
		combat->setParam(COMBAT_PARAM_DISTANCEEFFECT, spell->shoot);
	}

	if (spell->effect != CONST_ME_NONE) {
		combat->setParam(COMBAT_PARAM_EFFECT, spell->effect);
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
		combat->addCondition(condition);
	}

	combat->setPlayerCombatValues(COMBAT_FORMULA_DAMAGE, sb.minCombatValue, 0, sb.maxCombatValue, 0);
	combatSpell = new CombatSpell(combat.release(), spell->needTarget, spell->needDirection);

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

bool Monsters::loadLootItem(const pugi::xml_node& node, LootBlock& lootBlock)
{
	pugi::xml_attribute attr;
	if ((attr = node.attribute("id"))) {
		lootBlock.id = static_cast<uint16_t>(attr.as_uint());
	} else if ((attr = node.attribute("name"))) {
		auto name = attr.as_string();
		auto ids = Item::items.nameToItems.equal_range(asLowerCaseString(name));

		if (ids.first == Item::items.nameToItems.cend()) {
			SPDLOG_WARN("[Monsters::loadLootItem] - "
                        "Unknown loot item {}", name);
			return false;
		}

		uint32_t id = ids.first->second;

		if (std::next(ids.first) != ids.second) {
			SPDLOG_WARN("[Monsters::loadLootItem] - "
                        "Non-unique loot item {}", name);
			return false;
		}

		lootBlock.id = id;
	}

	if (lootBlock.id == 0) {
		return false;
	}

	//optional
	if ((attr = node.attribute("subtype"))) {
		lootBlock.subType = attr.as_int();
	} else {
		uint32_t charges = Item::items[lootBlock.id].charges;
		if (charges != 0) {
			lootBlock.subType = charges;
		}
	}

	if ((attr = node.attribute("chance")) || (attr = node.attribute("chance1"))) {
		lootBlock.chance = std::min<int32_t>(MAX_LOOTCHANCE, attr.as_int());
	} else {
		lootBlock.chance = MAX_LOOTCHANCE;
	}

	//optional
	if ((attr = node.attribute("countmin"))) {
		lootBlock.countmin = std::max<int32_t>(1, attr.as_int());
	} else {
		lootBlock.countmin = 1;
	}

	//optional
	if ((attr = node.attribute("countmax"))) {
		lootBlock.countmax = std::max<int32_t>(1, attr.as_int());
	} else {
		lootBlock.countmax = 1;
	}

	if (Item::items[lootBlock.id].isContainer()) {
		loadLootContainer(node, lootBlock);
	}

	if ((attr = node.attribute("actionId"))) {
		lootBlock.actionId = attr.as_int();
	}

	if ((attr = node.attribute("text"))) {
		lootBlock.text = attr.as_string();
	}

	if ((attr = node.attribute("nameItem"))) {
		lootBlock.name = attr.as_string();
	}

	if ((attr = node.attribute("article"))) {
		lootBlock.article = attr.as_string();
	}

	if ((attr = node.attribute("attack"))) {
		lootBlock.attack = attr.as_int();
	}

	if ((attr = node.attribute("defense"))) {
		lootBlock.defense = attr.as_int();
	}

	if ((attr = node.attribute("extradefense"))) {
		lootBlock.extraDefense = attr.as_int();
	}

	if ((attr = node.attribute("armor"))) {
		lootBlock.armor = attr.as_int();
	}

	if ((attr = node.attribute("shootrange"))) {
		lootBlock.shootRange = attr.as_int();
	}

	if ((attr = node.attribute("hitchance"))) {
		lootBlock.hitChance = attr.as_int();
	}

	if ((attr = node.attribute("unique"))) {
		lootBlock.unique = attr.as_bool();
	}
	return true;
}

void Monsters::loadLootContainer(const pugi::xml_node& node, LootBlock& lBlock)
{
	for (auto subNode : node.children()) {
		LootBlock lootBlock;
		if (loadLootItem(subNode, lootBlock)) {
			lBlock.childLoot.emplace_back(std::move(lootBlock));
		}
	}
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
