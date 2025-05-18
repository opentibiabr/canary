/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "io/iobestiary.hpp"

#include "creatures/combat/combat.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "lib/metrics/metrics.hpp"

SoftSingleton IOBestiary::instanceTracker("IOBestiary");

bool IOBestiary::parseCharmCombat(const std::shared_ptr<Charm> &charm, const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, int32_t realDamage, bool dueToPotion, bool checkArmor) {
	if (!charm || !player || !target) {
		return false;
	}
	CombatParams charmParams;
	CombatDamage charmDamage;
	if (charm->type == CHARM_OFFENSIVE) {
		if (charm->id == CHARM_CRIPPLE) {
			std::shared_ptr<ConditionSpeed> cripple = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_PARALYZE, 10000, 0)->static_self_cast<ConditionSpeed>();
			cripple->setFormulaVars(-1, 0, -1, 0);
			target->addCondition(cripple);
			player->sendCancelMessage(charm->cancelMsg);
			return false;
		}
		int32_t maxHealth = target->getMaxHealth();
		charmDamage.primary.type = charm->dmgtype;
		charmDamage.primary.value = ((-maxHealth * (charm->percent)) / 100);
		charmDamage.extension = true;
		if (!charmDamage.exString.empty()) {
			charmDamage.exString += ", ";
		}
		charmDamage.exString += charm->logMsg + (dueToPotion ? " due to active charm upgrade" : "");

		charmParams.impactEffect = charm->effect;
		charmParams.combatType = charmDamage.primary.type;
		charmParams.aggressive = true;

		charmParams.soundImpactEffect = charm->soundImpactEffect;
		charmParams.soundCastEffect = charm->soundCastEffect;

		player->sendCancelMessage(charm->cancelMsg);
	} else if (charm->type == CHARM_DEFENSIVE) {
		switch (charm->id) {
			case CHARM_PARRY: {
				charmDamage.primary.type = COMBAT_NEUTRALDAMAGE;
				charmDamage.primary.value = -realDamage;
				charmDamage.extension = true;
				if (!charmDamage.exString.empty()) {
					charmDamage.exString += ", ";
				}
				charmDamage.exString += charm->logMsg + (dueToPotion ? " due to active charm upgrade" : "");
				charmParams.aggressive = true;
				charmParams.blockedByArmor = checkArmor;
				break;
			}
			case CHARM_DODGE: {
				const Position &targetPos = target->getPosition();
				player->sendCancelMessage(charm->cancelMsg);
				g_game().addMagicEffect(targetPos, charm->effect);
				return true;
			}
			case CHARM_ADRENALINE: {
				std::shared_ptr<ConditionSpeed> adrenaline = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_HASTE, 10000, 0)->static_self_cast<ConditionSpeed>();
				adrenaline->setFormulaVars(2.5, 40, 2.5, 40);
				player->addCondition(adrenaline);
				player->sendCancelMessage(charm->cancelMsg);
				return false;
			}
			case CHARM_NUMB: {
				std::shared_ptr<ConditionSpeed> numb = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_PARALYZE, 10000, 0)->static_self_cast<ConditionSpeed>();
				numb->setFormulaVars(-1, 0, -1, 0);
				target->addCondition(numb);
				player->sendCancelMessage(charm->cancelMsg);
				return false;
			}

			default:
				return false;
		}
		player->sendCancelMessage(charm->cancelMsg);
	} else {
		return false;
	}
	Combat::doCombatHealth(player, target, charmDamage, charmParams);
	return false;
}

IOBestiary &IOBestiary::getInstance() {
	return inject<IOBestiary>();
}

std::shared_ptr<Charm> IOBestiary::getBestiaryCharm(charmRune_t activeCharm, bool force /*= false*/) const {
	const auto charmInternal = g_game().getCharmList();
	for (const auto &tmpCharm : charmInternal) {
		if (tmpCharm->id == activeCharm) {
			return tmpCharm;
		}
	}

	if (force) {
		auto charm = std::make_shared<Charm>();
		charm->id = activeCharm;
		charm->binary = 1 << activeCharm;
		g_game().addCharmRune(charm);
		return charm;
	}

	return nullptr;
}

std::map<uint16_t, std::string> IOBestiary::findRaceByName(const std::string &race, bool Onlystring /*= true*/, BestiaryType_t raceNumber /*= BESTY_RACE_NONE*/) const {
	const std::map<uint16_t, std::string> &best_list = g_game().getBestiaryList();
	std::map<uint16_t, std::string> race_list;

	if (Onlystring) {
		for (const auto &it : best_list) {
			const auto tmpType = g_monsters().getMonsterType(it.second);
			if (tmpType && tmpType->info.bestiaryClass == race) {
				race_list.insert({ it.first, it.second });
			}
		}
	} else {
		for (const auto &itn : best_list) {
			const auto tmpType = g_monsters().getMonsterType(itn.second);
			if (tmpType && tmpType->info.bestiaryRace == raceNumber) {
				race_list.insert({ itn.first, itn.second });
			}
		}
	}
	return race_list;
}

uint8_t IOBestiary::getKillStatus(const std::shared_ptr<MonsterType> &mtype, uint32_t killAmount) const {
	if (killAmount < mtype->info.bestiaryFirstUnlock) {
		return 1;
	} else if (killAmount < mtype->info.bestiarySecondUnlock) {
		return 2;
	} else if (killAmount < mtype->info.bestiaryToUnlock) {
		return 3;
	}
	return 4;
}

void IOBestiary::resetCharmRuneCreature(const std::shared_ptr<Player> &player, const std::shared_ptr<Charm> &charm) const {
	if (!player || !charm) {
		return;
	}

	int32_t value = bitToggle(player->getUsedRunesBit(), charm, false);
	player->setUsedRunesBit(value);
	player->parseRacebyCharm(charm->id, true, 0);
}

void IOBestiary::setCharmRuneCreature(const std::shared_ptr<Player> &player, const std::shared_ptr<Charm> &charm, uint16_t raceid) const {
	if (!player || !charm) {
		return;
	}

	player->parseRacebyCharm(charm->id, true, raceid);
	int32_t Toggle = bitToggle(player->getUsedRunesBit(), charm, true);
	player->setUsedRunesBit(Toggle);
}

std::list<charmRune_t> IOBestiary::getCharmUsedRuneBitAll(const std::shared_ptr<Player> &player) {
	int32_t input = player->getUsedRunesBit();

	int8_t i = 0;
	std::list<charmRune_t> rtn;
	while (input != 0) {
		if ((input & 1) == 1) {
			auto tmpcharm = static_cast<charmRune_t>(i);
			rtn.push_front(tmpcharm);
		}
		input = input >> 1;
		i += 1;
	}
	return rtn;
}

uint16_t IOBestiary::getBestiaryRaceUnlocked(const std::shared_ptr<Player> &player, BestiaryType_t race) const {
	if (!player) {
		return 0;
	}

	uint16_t count = 0;
	std::map<uint16_t, std::string> besty_l = g_game().getBestiaryList();

	for (const auto &it : besty_l) {
		const auto mtype = g_monsters().getMonsterType(it.second);
		if (mtype && mtype->info.bestiaryRace == race && player->getBestiaryKillCount(mtype->info.raceid) > 0) {
			count++;
		}
	}
	return count;
}

void IOBestiary::addCharmPoints(const std::shared_ptr<Player> &player, uint16_t amount, bool negative /*= false*/) {
	if (!player) {
		return;
	}

	uint32_t myCharms = player->getCharmPoints();
	if (negative) {
		myCharms -= amount;
	} else {
		myCharms += amount;
	}
	player->setCharmPoints(myCharms);
}

void IOBestiary::addBestiaryKill(const std::shared_ptr<Player> &player, const std::shared_ptr<MonsterType> &mtype, uint32_t amount /*= 1*/) {
	uint16_t raceid = mtype->info.raceid;
	if (raceid == 0 || !player || !mtype) {
		return;
	}
	uint32_t curCount = player->getBestiaryKillCount(raceid);
	std::ostringstream ss;

	player->addBestiaryKillCount(raceid, amount);

	if ((curCount == 0) || // Initial kill stage
	    (curCount < mtype->info.bestiaryFirstUnlock && (curCount + amount) >= mtype->info.bestiaryFirstUnlock) || // First kill stage reached
	    (curCount < mtype->info.bestiarySecondUnlock && (curCount + amount) >= mtype->info.bestiarySecondUnlock) || // Second kill stage reached
	    (curCount < mtype->info.bestiaryToUnlock && (curCount + amount) >= mtype->info.bestiaryToUnlock)) { // Final kill stage reached
		ss << "You unlocked details for the creature '" << mtype->name << "'";
		player->sendTextMessage(MESSAGE_STATUS, ss.str());
		player->sendBestiaryEntryChanged(raceid);

		if ((curCount + amount) >= mtype->info.bestiaryToUnlock) {
			addCharmPoints(player, mtype->info.bestiaryCharmsPoints);
		}
	}

	// Reload bestiary tracker
	player->refreshCyclopediaMonsterTracker();
}

charmRune_t IOBestiary::getCharmFromTarget(const std::shared_ptr<Player> &player, const std::shared_ptr<MonsterType> &mtype) {
	if (!player || !mtype) {
		return CHARM_NONE;
	}

	uint16_t bestiaryEntry = mtype->info.raceid;
	std::list<charmRune_t> usedRunes = getCharmUsedRuneBitAll(player);

	for (charmRune_t it : usedRunes) {
		const auto charm = getBestiaryCharm(it);
		if (bestiaryEntry == player->parseRacebyCharm(charm->id, false, 0)) {
			return charm->id;
		}
	}
	return CHARM_NONE;
}

bool IOBestiary::hasCharmUnlockedRuneBit(const std::shared_ptr<Charm> &charm, int32_t input) const {
	if (!charm) {
		return false;
	}

	return ((input & charm->binary) != 0);
}

int32_t IOBestiary::bitToggle(int32_t input, const std::shared_ptr<Charm> &charm, bool on) const {
	if (!charm) {
		return CHARM_NONE;
	}

	int32_t returnToggle;
	int32_t binary = charm->binary;
	if (on) {
		returnToggle = input | binary;
		return returnToggle;
	} else {
		binary = ~binary;
		returnToggle = input & binary;
		return returnToggle;
	}
}

void IOBestiary::sendBuyCharmRune(const std::shared_ptr<Player> &player, charmRune_t runeID, uint8_t action, uint16_t raceid) {
	const auto charm = getBestiaryCharm(runeID);
	if (!player || !charm) {
		return;
	}

	if (action == 0) {
		std::ostringstream ss;

		if (player->getCharmPoints() < charm->points) {
			ss << "You don't have enough charm points to unlock this rune.";
			player->sendFYIBox(ss.str());
			player->BestiarysendCharms();
			return;
		}

		ss << "You successfully unlocked '" << charm->name << "' for " << charm->points << " charm points.";
		player->sendFYIBox(ss.str());
		addCharmPoints(player, charm->points, true);

		int32_t value = bitToggle(player->getUnlockedRunesBit(), charm, true);
		player->setUnlockedRunesBit(value);
	} else if (action == 1) {
		std::list<charmRune_t> usedRunes = getCharmUsedRuneBitAll(player);
		uint16_t limitRunes;

		if (player->isPremium()) {
			if (player->hasCharmExpansion()) {
				limitRunes = 100;
			} else {
				limitRunes = 6;
			}
		} else {
			limitRunes = 3;
		}

		if (limitRunes <= usedRunes.size()) {
			player->sendFYIBox("You don't have any charm slots available.");
			player->BestiarysendCharms();
			return;
		}

		setCharmRuneCreature(player, charm, raceid);
		player->sendFYIBox("Creature has been set! You are Premium player, so you benefit from up to 6 runes! Charm Expansion allow you to set creatures to all runes at once!");
	} else if (action == 2) {
		int32_t fee = player->getLevel() * 100;
		if (player->hasCharmExpansion()) {
			fee = (fee * 75) / 100;
		}

		if (g_game().removeMoney(player, fee, 0, true)) {
			resetCharmRuneCreature(player, charm);
			player->sendFYIBox("You successfully removed the creature.");
			player->BestiarysendCharms();
			g_metrics().addCounter("balance_decrease", fee, { { "player", player->getName() }, { "context", "charm_removal" } });
			return;
		}
		player->sendFYIBox("You don't have enough gold.");
	}
	player->BestiarysendCharms();
}

std::map<uint8_t, int16_t> IOBestiary::getMonsterElements(const std::shared_ptr<MonsterType> &mtype) const {
	std::map<uint8_t, int16_t> defaultMap = {};
	for (uint8_t i = 0; i <= 7; i++) {
		defaultMap[i] = 100;
	}
	for (const auto &elementEntry : mtype->info.elementMap) {
		switch (elementEntry.first) {
			case COMBAT_PHYSICALDAMAGE:
				defaultMap[0] -= static_cast<int16_t>(elementEntry.second);
				break;
			case COMBAT_FIREDAMAGE:
				defaultMap[1] -= static_cast<int16_t>(elementEntry.second);
				break;
			case COMBAT_EARTHDAMAGE:
				defaultMap[2] -= static_cast<int16_t>(elementEntry.second);
				break;
			case COMBAT_ENERGYDAMAGE:
				defaultMap[3] -= static_cast<int16_t>(elementEntry.second);
				break;
			case COMBAT_ICEDAMAGE:
				defaultMap[4] -= static_cast<int16_t>(elementEntry.second);
				break;
			case COMBAT_HOLYDAMAGE:
				defaultMap[5] -= static_cast<int16_t>(elementEntry.second);
				break;
			case COMBAT_DEATHDAMAGE:
				defaultMap[6] -= static_cast<int16_t>(elementEntry.second);
				break;
			case COMBAT_HEALING:
				defaultMap[7] -= static_cast<int16_t>(elementEntry.second);
				break;
			default:
				break;
		}
	}
	return defaultMap;
}

std::map<uint16_t, uint32_t> IOBestiary::getBestiaryKillCountByMonsterIDs(const std::shared_ptr<Player> &player, const std::map<uint16_t, std::string> &mtype_list) const {
	std::map<uint16_t, uint32_t> raceMonsters = {};
	for (const auto &it : mtype_list) {
		uint16_t raceid = it.first;
		uint32_t thisKilled = player->getBestiaryKillCount(raceid);
		if (thisKilled > 0) {
			raceMonsters[raceid] = thisKilled;
		}
	}
	return raceMonsters;
}

std::vector<uint16_t> IOBestiary::getBestiaryFinished(const std::shared_ptr<Player> &player) const {
	const auto &bestiaryMap = g_game().getBestiaryList();

	stdext::vector_set<uint16_t> finishedMonsters;
	finishedMonsters.reserve(bestiaryMap.size());

	for (const auto &[monsterTypeRaceId, monsterTypeName] : bestiaryMap) {
		const auto &mtype = g_monsters().getMonsterType(monsterTypeName);
		const uint32_t thisKilled = player->getBestiaryKillCount(monsterTypeRaceId);

		if (mtype && thisKilled >= mtype->info.bestiaryToUnlock) {
			finishedMonsters.insert(monsterTypeRaceId);
		}
	}
	return finishedMonsters.data();
}

int8_t IOBestiary::calculateDifficult(uint32_t chance) const {
	float chanceInPercent = chance / 1000;

	if (chanceInPercent < 0.2) {
		return 4;
	} else if (chanceInPercent < 1) {
		return 3;
	} else if (chanceInPercent < 5) {
		return 2;
	} else if (chanceInPercent < 25) {
		return 1;
	}
	return 0;
}
