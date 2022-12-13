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

#include "declarations.hpp"
#include "game/game.h"
#include "io/iobestiary.h"
#include "creatures/monsters/monsters.h"
#include "creatures/players/player.h"


bool IOBestiary::parseCharmCombat(Charm* charm, Player* player, Creature* target, int64_t realDamage)
{
	if (!charm || !player || !target) {
		return false;
	}

	CombatParams charmParams;
	CombatDamage charmDamage;
	if (charm->type == CHARM_OFFENSIVE) {
		if (charm->id == CHARM_CRIPPLE) {
			ConditionSpeed* cripple = static_cast<ConditionSpeed*>(Condition::createCondition(CONDITIONID_COMBAT, CONDITION_PARALYZE, 10000, 0));
			cripple->setFormulaVars(-1, 81, -1, 81);
			target->addCondition(cripple);
			player->sendCancelMessage(charm->cancelMsg);
			return false;
		}
		int64_t maxHealth = target->getMaxHealth();
		charmDamage.primary.type = charm->dmgtype;
		charmDamage.primary.value = ((-maxHealth * (charm->percent)) / 100);
		charmDamage.extension = true;
		charmDamage.exString = charm->logMsg;

		charmParams.impactEffect = charm->effect;
		charmParams.combatType = charmDamage.primary.type;
		charmParams.aggressive = true;

		charmParams.soundImpactEffect = charm->soundImpactEffect; 
		charmParams.soundCastEffect = charm->soundCastEffect;

		player->sendCancelMessage(charm->cancelMsg);
	} else if (charm->type == CHARM_DEFENSIVE) {
		switch (charm->id) {
			case CHARM_PARRY: {
				charmDamage.primary.type = charm->dmgtype;
				charmDamage.primary.value = -realDamage;
				charmDamage.extension = true;
				charmDamage.exString = charm->logMsg;

				charmParams.impactEffect = charm->effect;
				charmParams.combatType = charmDamage.primary.type;
				charmParams.aggressive = true;
				break;
			}
			case CHARM_DODGE: {
				const Position& targetPos = target->getPosition();
				player->sendCancelMessage(charm->cancelMsg);
				g_game().addMagicEffect(targetPos, charm->effect);
				return true;
			}
			case CHARM_ADRENALINE: {
				ConditionSpeed* adrenaline = static_cast<ConditionSpeed*>(Condition::createCondition(CONDITIONID_COMBAT, CONDITION_HASTE, 10000, 0));
				adrenaline->setFormulaVars(1.5, -0, 1.5, -0);
				player->addCondition(adrenaline);
				player->sendCancelMessage(charm->cancelMsg);
				return false;
			}
			case CHARM_NUMB: {
				ConditionSpeed* numb = static_cast<ConditionSpeed*>(Condition::createCondition(CONDITIONID_COMBAT, CONDITION_PARALYZE, 10000, 0));
				numb->setFormulaVars(-1, 81, -1, 81);
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

Charm* IOBestiary::getBestiaryCharm(charmRune_t activeCharm, bool force /*= false*/)
{
	std::vector<Charm*> charmInternal = g_game().getCharmList();
	for (Charm* tmpCharm : charmInternal) {
		if (tmpCharm->id == activeCharm) {
			return tmpCharm;
		}
	}

	if (force) {
		auto charm = new Charm();
		charm->id = activeCharm;
		charm->binary = 1 << activeCharm;
		g_game().addCharmRune(charm);
		return charm;
	}

	return nullptr;
}

std::map<uint16_t, std::string> IOBestiary::findRaceByName(const std::string &race, bool Onlystring /*= true*/, BestiaryType_t raceNumber /*= BESTY_RACE_NONE*/) const
{
	std::map<uint16_t, std::string> best_list = g_game().getBestiaryList();
	std::map<uint16_t, std::string> race_list;

	if (Onlystring) {
		for (auto it : best_list) {
			const MonsterType* tmpType = g_monsters().getMonsterType(it.second);
			if (tmpType && tmpType->info.bestiaryClass == race) {
				race_list.insert({it.first, it.second});
			}
		}
	} else {
		for (auto itn : best_list) {
			const MonsterType* tmpType = g_monsters().getMonsterType(itn.second);
			if (tmpType && tmpType->info.bestiaryRace == raceNumber) {
				race_list.insert({itn.first, itn.second});
			}
		}
	}
	return race_list;
}

uint8_t IOBestiary::getKillStatus(MonsterType* mtype, uint32_t killAmount) const
{
	if (killAmount < mtype->info.bestiaryFirstUnlock) {
		return 1;
	} else if (killAmount < mtype->info.bestiarySecondUnlock) {
		return 2;
	} else if (killAmount < mtype->info.bestiaryToUnlock) {
		return 3;
	}
	return 4;
}

void IOBestiary::resetCharmRuneCreature(Player* player, Charm* charm)
{
	if (!player || !charm) {
		return;
	}

	int32_t value = bitToggle(player->getUsedRunesBit(), charm, false);
	player->setUsedRunesBit(value);
	player->parseRacebyCharm(charm->id, true, 0);
}

void IOBestiary::setCharmRuneCreature(Player* player, Charm* charm, uint16_t raceid)
{
	if (!player || !charm) {
		return;
	}

	player->parseRacebyCharm(charm->id, true, raceid);
	int32_t Toggle = bitToggle(player->getUsedRunesBit(), charm, true);
	player->setUsedRunesBit(Toggle);
}

std::list<charmRune_t> IOBestiary::getCharmUsedRuneBitAll(Player* player)
{
	int32_t input = player->getUsedRunesBit();;
	int8_t i = 0;
	std::list<charmRune_t> rtn;
	while (input != 0) {
		if ((input & 1) == 1) {
			charmRune_t tmpcharm = static_cast<charmRune_t>(i);
			rtn.push_front(tmpcharm);
		}
		input = input >> 1;
		i += 1;
	}
	return rtn;
}

uint16_t IOBestiary::getBestiaryRaceUnlocked(Player* player, BestiaryType_t race) const
{
	if (!player) {
		return 0;
	}

	uint16_t count = 0;
	std::map<uint16_t, std::string> besty_l = g_game().getBestiaryList();

	for (auto it : besty_l) {
		const MonsterType* mtype = g_monsters().getMonsterType(it.second);
		if (mtype && mtype->info.bestiaryRace == race && player->getBestiaryKillCount(mtype->info.raceid) > 0) {
			count++;
		}
	}
	return count;
}

void IOBestiary::addCharmPoints(Player* player, uint16_t amount, bool negative /*= false*/)
{
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

void IOBestiary::addBestiaryKill(Player* player, MonsterType* mtype, uint32_t amount /*= 1*/)
{
	uint16_t raceid = mtype->info.raceid;
	if (raceid == 0 || !player || !mtype) {
		return;
	}
	uint32_t curCount = player->getBestiaryKillCount(raceid);
	std::ostringstream ss;

	player->addBestiaryKillCount(raceid, amount);

	if ((curCount == 0) ||  // Initial kill stage
		(curCount < mtype->info.bestiaryFirstUnlock && (curCount + amount) >= mtype->info.bestiaryFirstUnlock) ||  // First kill stage reached
		(curCount < mtype->info.bestiarySecondUnlock && (curCount + amount) >= mtype->info.bestiarySecondUnlock) ||  // Second kill stage reached
		(curCount < mtype->info.bestiaryToUnlock && (curCount + amount) >= mtype->info.bestiaryToUnlock)) {  // Final kill stage reached

		ss << "You unlocked details for the creature '" << mtype->name << "'";
		player->sendTextMessage(MESSAGE_STATUS, ss.str());
		player->sendBestiaryEntryChanged(raceid);

		if ((curCount + amount) >= mtype->info.bestiaryToUnlock)
			addCharmPoints(player, mtype->info.bestiaryCharmsPoints);
	}

	std::list<MonsterType*> trackerList = player->getBestiaryTrackerList();
	for (MonsterType* mType : trackerList) {
		if (raceid == mType->info.raceid) {
			player->refreshBestiaryTracker(trackerList);
		}
	}
}

charmRune_t IOBestiary::getCharmFromTarget(Player* player, MonsterType* mtype)
{
	if (!player || !mtype) {
		return CHARM_NONE;
	}

	uint16_t bestiaryEntry = mtype->info.raceid;
	std::list<charmRune_t> usedRunes = getCharmUsedRuneBitAll(player);

	for (charmRune_t it : usedRunes) {
		Charm* charm = getBestiaryCharm(it);
		if (bestiaryEntry == player->parseRacebyCharm(charm->id, false, 0)) {
			return charm->id;
		}
	}
	return CHARM_NONE;
}

bool IOBestiary::hasCharmUnlockedRuneBit(Charm* charm, int32_t input) const
{
	if (!charm) {
		return false;
	}

	return ((input & charm->binary) != 0);
}

int32_t IOBestiary::bitToggle(int32_t input, Charm* charm, bool on) const
{
	if (!charm) {
		return CHARM_NONE;
	}

	int32_t returnToggle = 0;
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

void IOBestiary::sendBuyCharmRune(Player* player, charmRune_t runeID, uint8_t action, uint16_t raceid)
{
	Charm* charm = getBestiaryCharm(runeID);
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
		uint16_t limitRunes = 0;

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
			fee = (fee * 75)/100;
		}

		if (g_game().removeMoney(player, fee, 0, true)) {
			resetCharmRuneCreature(player, charm);
			player->sendFYIBox("You successfully removed the creature.");
			player->BestiarysendCharms();
			return;
		}
		player->sendFYIBox("You don't have enough gold.");
	}
	player->BestiarysendCharms();
	return;
}

std::map<uint8_t, int16_t> IOBestiary::getMonsterElements(MonsterType* mtype) const
{
	std::map<uint8_t, int16_t> defaultMap = {};
	for (uint8_t i = 0; i <= 7; i++) {
		defaultMap[i] = 100;
	}
	for (const auto& elementEntry : mtype->info.elementMap) {
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

std::map<uint16_t, uint32_t> IOBestiary::getBestiaryKillCountByMonsterIDs(Player* player, std::map<uint16_t, std::string> mtype_list) const
{
	std::map<uint16_t, uint32_t> raceMonsters = {};
	for (auto it : mtype_list) {
		uint16_t raceid = it.first;
		uint32_t thisKilled = player->getBestiaryKillCount(raceid);
		if (thisKilled > 0) {
			raceMonsters[raceid] = thisKilled;
		}
	}
	return raceMonsters;
}

std::list<uint16_t> IOBestiary::getBestiaryFinished(Player* player) const
{
	std::list<uint16_t> finishedMonsters = {};
	std::map<uint16_t, std::string> besty_l = g_game().getBestiaryList();

	for (auto nt : besty_l) {
		uint16_t raceid = nt.first;
		uint32_t thisKilled = player->getBestiaryKillCount(raceid);
		const MonsterType* mtype = g_monsters().getMonsterType(nt.second);
		if (mtype && thisKilled >= mtype->info.bestiaryToUnlock) {
			finishedMonsters.push_front(raceid);
		}
	}
	return finishedMonsters;
}

int8_t IOBestiary::calculateDifficult(uint32_t chance) const
{
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
