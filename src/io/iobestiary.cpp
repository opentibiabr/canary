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
#include "creatures/monsters/monster.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "lib/metrics/metrics.hpp"

SoftSingleton IOBestiary::instanceTracker("IOBestiary");

void IOBestiary::parseOffensiveCharmCombatDamage(const std::shared_ptr<Charm> &charm, int32_t damage, CombatDamage &charmDamage, CombatParams &charmParams) {
	charmDamage.primary.type = charm->damageType;
	charmDamage.primary.value = damage;
	charmDamage.extension = true;
	if (!charmDamage.exString.empty()) {
		charmDamage.exString += ", ";
	}
	if (charm->logMessage) {
		charmDamage.exString += fmt::format("({} charm)", asLowerCaseString(charm->name));
	}

	charmParams.impactEffect = charm->effect;
	charmParams.combatType = charmDamage.primary.type;
	charmParams.aggressive = true;

	charmParams.soundImpactEffect = charm->soundImpactEffect;
	charmParams.soundCastEffect = charm->soundCastEffect;
}

void IOBestiary::parseCharmCarnage(const std::shared_ptr<Charm> &charm, const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, int32_t damage) {
	CombatDamage charmDamage;
	CombatParams charmParams;

	parseOffensiveCharmCombatDamage(charm, damage, charmDamage, charmParams);

	Combat::doCombatHealth(player, target, charmDamage, charmParams);
}

bool IOBestiary::parseOffensiveCharmCombat(const std::shared_ptr<Charm> &charm, const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, CombatDamage &charmDamage, CombatParams &charmParams) {
	static double_t maxHealthLimit = 0.08; // 8% max health (max damage)
	static uint8_t maxLevelsLimit = 2; // 2x level (max damage)
	static constexpr std::array<std::pair<int8_t, int8_t>, 4> offsets = { { { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 } } };

	int32_t value = 0;
	const auto &targetPosition = target->getPosition();
	const auto &monster = target->getMonster();

	switch (charm->id) {
		case CHARM_WOUND:
		case CHARM_ENFLAME:
		case CHARM_POISON:
		case CHARM_FREEZE:
		case CHARM_ZAP:
		case CHARM_CURSE:
		case CHARM_DIVINE:
			value = std::min<int32_t>(std::ceil(player->getLevel() * maxLevelsLimit), std::ceil(target->getMaxHealth() * (charm->percent / 100.0)));
			break;
		case CHARM_CARNAGE:
			if (!monster || !monster->isDead()) {
				return false;
			}

			maxLevelsLimit = 6;
			value = target->getMaxHealth();

			for (const auto &[dx, dy] : offsets) {
				Position damagePosition(targetPosition.x + dx, targetPosition.y + dy, targetPosition.z);
				const auto &tile = g_game().map.getTile(damagePosition);

				if (!tile) {
					continue;
				}

				g_game().addMagicEffect(damagePosition, CONST_ME_DRAWBLOOD);

				const auto &topCreature = tile->getTopCreature();
				if (topCreature && topCreature->getType() == CREATURETYPE_MONSTER) {
					int32_t damage = std::min<int32_t>(
						std::ceil(value * (charm->percent / 100.0)),
						player->getLevel() * maxLevelsLimit
					);
					parseCharmCarnage(charm, player, topCreature, -damage);
				}
			}
			return false;

		case CHARM_OVERPOWER:
			value = std::min<int32_t>(std::ceil(target->getMaxHealth() * maxHealthLimit), std::ceil(player->getMaxHealth() * (charm->percent / 100.0)));
			break;
		case CHARM_OVERFLUX:
			value = std::min<int32_t>(std::ceil(target->getMaxHealth() * maxHealthLimit), std::ceil(player->getMaxMana() * (charm->percent / 100.0)));
			break;
		case CHARM_CRIPPLE: {
			const auto &cripple = std::static_pointer_cast<ConditionSpeed>(Condition::createCondition(CONDITIONID_COMBAT, CONDITION_PARALYZE, 10000, 0));
			cripple->setFormulaVars(-1, 0, -1, 0);
			target->addCondition(cripple);
			return false;
		}
		default:
			g_logger().warn("[{}] - No handler found for offensive charm id {}.", __FUNCTION__, charm->id);
			return false;
	}

	// This will be handled if any switch statement be break.
	parseOffensiveCharmCombatDamage(charm, -value, charmDamage, charmParams);

	return true;
}

bool IOBestiary::parseDefensiveCharmCombat(const std::shared_ptr<Charm> &charm, const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, int32_t realDamage, bool checkArmor, CombatDamage &charmDamage, CombatParams &charmParams) {
	switch (charm->id) {
		case CHARM_PARRY: {
			charmDamage.primary.type = COMBAT_NEUTRALDAMAGE;
			charmDamage.primary.value = -realDamage;
			charmDamage.extension = true;
			if (!charmDamage.exString.empty()) {
				charmDamage.exString += ", ";
			}
			if (charm->logMessage) {
				charmDamage.exString += fmt::format("({} charm)", asLowerCaseString(charm->name));
			}
			charmParams.aggressive = true;
			charmParams.blockedByArmor = checkArmor;
			return true;
		}
		case CHARM_DODGE: {
			const Position &targetPos = target->getPosition();
			g_game().addMagicEffect(targetPos, charm->effect);
			break;
		}
		case CHARM_ADRENALINE: {
			const auto &adrenaline = std::static_pointer_cast<ConditionSpeed>(Condition::createCondition(CONDITIONID_COMBAT, CONDITION_HASTE, 10000, 0));
			adrenaline->setFormulaVars(2.5, 40, 2.5, 40);
			player->addCondition(adrenaline);
			break;
		}
		case CHARM_NUMB: {
			const auto &numb = std::static_pointer_cast<ConditionSpeed>(Condition::createCondition(CONDITIONID_COMBAT, CONDITION_PARALYZE, 10000, 0));
			numb->setFormulaVars(-1, 0, -1, 0);
			target->addCondition(numb);
			break;
		}

		default:
			g_logger().warn("[{}] - No handler found for defensive charm id {}.", __FUNCTION__, charm->id);
			break;
	}

	return false;
}

bool IOBestiary::parsePassiveCharmCombat(const std::shared_ptr<Charm> &charm, const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, int32_t value, CombatDamage &charmDamage, CombatParams &charmParams) {
	const auto &monster = target->getMonster();
	switch (charm->id) {
		case CHARM_BLESS:
		case CHARM_GUT:
		case CHARM_LOW:
		case CHARM_SAVAGE:
		case CHARM_SCAVENGE:
		case CHARM_VAMP:
		case CHARM_VOID:
		case CHARM_VOIDINVERSION:
			// All the charms above are being handled separately.
			break;
		case CHARM_FATAL:
			if (monster) {
				constexpr int32_t preventFleeDuration = 30000; // Fatal Hold prevents fleeing for 30 seconds.
				monster->setFatalHoldDuration(preventFleeDuration);
			}
			break;
		default:
			g_logger().warn("[{}] - No handler found for passive charm id {}.", __FUNCTION__, charm->id);
			break;
	}

	return false;
}

bool IOBestiary::parseCharmCombat(const std::shared_ptr<Charm> &charm, const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, int32_t realDamage, bool checkArmor) {
	if (!charm || !player || !target) {
		return false;
	}

	CombatDamage charmDamage;
	CombatParams charmParams;

	bool callCombat = false;

	switch (charm->type) {
		case CHARM_OFFENSIVE:
			callCombat = parseOffensiveCharmCombat(charm, player, target, charmDamage, charmParams);
			break;
		case CHARM_DEFENSIVE:
			callCombat = parseDefensiveCharmCombat(charm, player, target, realDamage, checkArmor, charmDamage, charmParams);
			break;
		case CHARM_PASSIVE:
			callCombat = parsePassiveCharmCombat(charm, player, target, realDamage, charmDamage, charmParams);
			break;
		default:
			g_logger().warn("[{}] - No handler found for charm type {}.", __FUNCTION__, static_cast<uint8_t>(charm->type));
			return false;
	}

	if (!charm->cancelMessage.empty()) {
		player->sendCancelMessage(charm->cancelMessage);
	}

	if (callCombat) {
		Combat::doCombatHealth(player, target, charmDamage, charmParams);
	}

	return true;
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

void IOBestiary::resetAllCharmRuneCreatures(const std::shared_ptr<Player> &player) const {
	if (!player) {
		return;
	}

	const auto charmList = g_game().getCharmList();
	for (const auto &charm : charmList) {
		if (!charm) {
			continue;
		}
		player->parseRacebyCharm(charm->id, true, 0);
		player->setCharmTier(charm->id, 0);
	}
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

void IOBestiary::addCharmPoints(const std::shared_ptr<Player> &player, uint32_t amount, bool negative /*= false*/) {
	if (!player) {
		return;
	}

	uint32_t myCharms = player->getCharmPoints();
	if (negative) {
		myCharms -= amount;
	} else {
		myCharms += amount;
		const auto maxCharmPoints = player->getMaxCharmPoints();
		player->setMaxCharmPoints(maxCharmPoints + amount);
	}
	player->setCharmPoints(myCharms);
}

void IOBestiary::addMinorCharmEchoes(const std::shared_ptr<Player> &player, uint32_t amount, bool negative /*= false*/) {
	if (!player) {
		return;
	}

	uint32_t myCharms = player->getMinorCharmEchoes();
	if (negative) {
		myCharms -= amount;
	} else {
		myCharms += amount;
		const auto maxCharmPoints = player->getMaxMinorCharmEchoes();
		player->setMaxMinorCharmEchoes(maxCharmPoints + amount);
	}
	player->setMinorCharmEchoes(myCharms);
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

PlayerCharmsByMonster IOBestiary::getCharmFromTarget(const std::shared_ptr<Player> &player, const std::shared_ptr<MonsterType> &mtype, charmCategory_t category /* = CHARM_ALL */) {
	PlayerCharmsByMonster playerCharmByMonster;
	if (!player || !mtype) {
		return {};
	}

	uint16_t bestiaryEntry = mtype->info.raceid;
	std::list<charmRune_t> usedRunes = getCharmUsedRuneBitAll(player);

	for (charmRune_t it : usedRunes) {
		const auto &charm = getBestiaryCharm(it);
		if (bestiaryEntry == player->parseRacebyCharm(charm->id) && (category == CHARM_ALL || charm->category == category)) {
			if (charm->category == CHARM_MAJOR) {
				playerCharmByMonster.major = charm->id;
			} else if (charm->category == CHARM_MINOR) {
				playerCharmByMonster.minor = charm->id;
			}
		}
	}
	return playerCharmByMonster;
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

void IOBestiary::sendBuyCharmRune(const std::shared_ptr<Player> &player, uint8_t action, charmRune_t charmId, uint16_t raceId) {
	const auto &charm = getBestiaryCharm(charmId);
	if (!player || (action != 3 && !charm)) {
		return;
	}

	if (action == 0) {
		if (charm->category == CHARM_MAJOR) {
			auto charmTier = player->getCharmTier(charm->id);
			if (charmTier > 2) {
				player->sendFYIBox("Charm at max level.");
				return;
			}

			if (player->getCharmPoints() < charm->points[charmTier]) {
				player->sendFYIBox("You don't have enough charm points to unlock this rune.");
				return;
			}

			addCharmPoints(player, charm->points[charmTier], true);
			addMinorCharmEchoes(player, 25 * charmTier * charmTier + 25 * charmTier + 50);
			player->setCharmTier(charm->id, charmTier + 1);
		} else if (charm->category == CHARM_MINOR) {
			auto charmTier = player->getCharmTier(charm->id);
			if (charmTier > 2) {
				player->sendFYIBox("Charm at max level.");
				return;
			}

			if (player->getMinorCharmEchoes() < charm->points[charmTier]) {
				player->sendFYIBox("You don't have enough minor charm echoes to unlock this rune.");
				return;
			}

			addMinorCharmEchoes(player, charm->points[charmTier], true);
			player->setCharmTier(charm->id, charmTier + 1);
		} else {
			return;
		}

		int32_t value = bitToggle(player->getUnlockedRunesBit(), charm, true);
		player->setUnlockedRunesBit(value);
	} else if (action == 1) {
		std::list<charmRune_t> usedRunes = getCharmUsedRuneBitAll(player);
		uint16_t limitRunes = 2;

		if (player->isPremium()) {
			limitRunes = player->hasCharmExpansion() ? 25 : 6;
		}

		if (limitRunes <= usedRunes.size()) {
			player->sendFYIBox("You don't have any charm slots available.");
			return;
		}

		const auto &mType = g_monsters().getMonsterTypeByRaceId(raceId);
		if (mType && charm->category == CHARM_MAJOR) {
			const uint32_t killedAmount = player->getBestiaryKillCount(raceId);
			if (killedAmount < mType->info.bestiaryToUnlock) {
				return;
			}
		}

		auto [major, minor] = getCharmFromTarget(player, mType);
		if ((charm->category == CHARM_MAJOR && major != CHARM_NONE) || (charm->category == CHARM_MINOR && minor != CHARM_NONE)) {
			player->sendFYIBox(fmt::format("You already have this monster set on another {} Charm!", charm->category == CHARM_MAJOR ? "Major" : "Minor"));
			return;
		}

		setCharmRuneCreature(player, charm, raceId);
		if (!player->isPremium()) {
			player->sendFYIBox("Creature has been set! You are a Free player, so you benefit from up to 2 runes! Premium players benefit from 6 and Charm Expansion allow you to set creatures to all runes at once!.");
		} else if (!player->hasCharmExpansion()) {
			player->sendFYIBox("Creature has been set! You are a Premium player, so you benefit from up to 6 runes! Charm Expansion allow you to set creatures to all runes at once!");
		}
	} else if (action == 2) {
		int32_t fee = player->getLevel() * 100;
		if (player->hasCharmExpansion()) {
			fee = (fee * 75) / 100;
		}

		if (!g_game().removeMoney(player, fee, 0, true)) {
			player->sendFYIBox("You don't have enough gold.");
			return;
		}

		resetCharmRuneCreature(player, charm);
		g_metrics().addCounter("balance_decrease", fee, { { "player", player->getName() }, { "context", "charm_removal" } });
	} else if (action == 3) {
		const auto playerLevel = player->getLevel();
		uint64_t resetAllCharmsCost = 100000 + (playerLevel > 100 ? playerLevel * 11000 : 0);
		if (player->hasCharmExpansion()) {
			resetAllCharmsCost = (resetAllCharmsCost * 75) / 100;
		}

		if (!g_game().removeMoney(player, resetAllCharmsCost, 0, true)) {
			player->sendFYIBox("You don't have enough gold.");
			return;
		}

		resetAllCharmRuneCreatures(player);
		const auto maxCharmPoints = player->getMaxCharmPoints();
		player->setCharmPoints(maxCharmPoints);
		uint16_t echoesResetValue = 0;
		const auto isPromoted = player->kv()->get("promoted");
		if (isPromoted) {
			echoesResetValue = 100;
		}
		player->setMinorCharmEchoes(echoesResetValue);
		player->setMaxMinorCharmEchoes(echoesResetValue);
		player->setUsedRunesBit(0);
		player->setUnlockedRunesBit(0);
		g_metrics().addCounter("balance_decrease", resetAllCharmsCost, { { "player", player->getName() }, { "context", "charm_removal" } });
	}
	player->sendBestiaryCharms();
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

std::vector<uint16_t> IOBestiary::getBestiaryStageTwo(const std::shared_ptr<Player> &player) const {
	const auto &bestiaryMap = g_game().getBestiaryList();

	stdext::vector_set<uint16_t> stageTwoMonsters;
	stageTwoMonsters.reserve(bestiaryMap.size());

	for (const auto &[monsterTypeRaceId, monsterTypeName] : bestiaryMap) {
		const auto &mtype = g_monsters().getMonsterType(monsterTypeName);
		const uint32_t thisKilled = player->getBestiaryKillCount(monsterTypeRaceId);

		if (mtype && thisKilled >= mtype->info.bestiarySecondUnlock) {
			stageTwoMonsters.insert(monsterTypeRaceId);
		}
	}
	return stageTwoMonsters.data();
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
