/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/players/grouping/party.h"
#include "game/game.h"
#include "lua/creature/events.h"

Party::Party(Player* initLeader) :
	leader(initLeader) {
	leader->setParty(this);
}

void Party::disband() {
	if (!g_events().eventPartyOnDisband(this)) {
		return;
	}

	Player* currentLeader = leader;
	leader = nullptr;

	currentLeader->setParty(nullptr);
	currentLeader->sendClosePrivate(CHANNEL_PARTY);
	g_game().updatePlayerShield(currentLeader);
	currentLeader->sendCreatureSkull(currentLeader);
	currentLeader->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, "Your party has been disbanded.");

	for (Player* invitee : inviteList) {
		invitee->removePartyInvitation(this);
		currentLeader->sendCreatureShield(invitee);
	}
	inviteList.clear();

	for (Player* member : memberList) {
		member->setParty(nullptr);
		member->sendClosePrivate(CHANNEL_PARTY);
		member->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, "Your party has been disbanded.");
	}

	for (Player* member : memberList) {
		g_game().updatePlayerShield(member);

		for (Player* otherMember : memberList) {
			otherMember->sendCreatureSkull(member);
		}

		member->sendCreatureSkull(currentLeader);
		currentLeader->sendCreatureSkull(member);
	}
	memberList.clear();

	for (PartyAnalyzer* analyzer : membersData) {
		delete analyzer;
	}
	membersData.clear();
	delete this;
}

bool Party::leaveParty(Player* player) {
	if (!player) {
		return false;
	}

	if (player->getParty() != this && leader != player) {
		return false;
	}

	if (!g_events().eventPartyOnLeave(this, player)) {
		return false;
	}

	bool missingLeader = false;
	if (leader == player) {
		if (!memberList.empty()) {
			if (memberList.size() == 1 && inviteList.empty()) {
				missingLeader = true;
			} else {
				passPartyLeadership(memberList.front());
			}
		} else {
			missingLeader = true;
		}
	}

	// since we already passed the leadership, we remove the player from the list
	auto it = std::find(memberList.begin(), memberList.end(), player);
	if (it != memberList.end()) {
		memberList.erase(it);
	}

	player->setParty(nullptr);
	player->sendClosePrivate(CHANNEL_PARTY);
	g_game().updatePlayerShield(player);

	for (Player* member : memberList) {
		member->sendCreatureSkull(player);
		player->sendPlayerPartyIcons(member);
		member->sendPartyCreatureUpdate(player);
	}

	leader->sendCreatureSkull(player);
	player->sendCreatureSkull(player);
	player->sendPlayerPartyIcons(leader);
	leader->sendPartyCreatureUpdate(player);

	player->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, "You have left the party.");

	updateSharedExperience();

	clearPlayerPoints(player);

	std::ostringstream ss;
	ss << player->getName() << " has left the party.";
	broadcastPartyMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());

	if (missingLeader || empty()) {
		disband();
	}

	return true;
}

bool Party::passPartyLeadership(Player* player) {
	if (!player || leader == player || player->getParty() != this) {
		return false;
	}

	// Remove it before to broadcast the message correctly
	auto it = std::find(memberList.begin(), memberList.end(), player);
	if (it != memberList.end()) {
		memberList.erase(it);
	}

	std::ostringstream ss;
	ss << player->getName() << " is now the leader of the party.";
	broadcastPartyMessage(MESSAGE_PARTY_MANAGEMENT, ss.str(), true);

	Player* oldLeader = leader;
	leader = player;

	memberList.insert(memberList.begin(), oldLeader);

	updateSharedExperience();
	updateTrackerAnalyzer();

	for (Player* member : memberList) {
		member->sendPartyCreatureShield(oldLeader);
		member->sendPartyCreatureShield(leader);
	}

	for (Player* invitee : inviteList) {
		invitee->sendCreatureShield(oldLeader);
		invitee->sendCreatureShield(leader);
	}

	leader->sendPartyCreatureShield(oldLeader);
	leader->sendPartyCreatureShield(leader);

	player->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, "You are now the leader of the party.");
	return true;
}

bool Party::joinParty(Player &player) {
	if (!g_events().eventPartyOnJoin(this, &player)) {
		return false;
	}

	auto it = std::find(inviteList.begin(), inviteList.end(), &player);
	if (it == inviteList.end()) {
		return false;
	}

	inviteList.erase(it);

	std::ostringstream ss;
	ss << player.getName() << " has joined the party.";
	broadcastPartyMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());

	player.setParty(this);

	g_game().updatePlayerShield(&player);

	for (Player* member : memberList) {
		member->sendCreatureSkull(&player);
		player.sendPlayerPartyIcons(member);
	}

	player.sendCreatureSkull(&player);
	leader->sendCreatureSkull(&player);
	player.sendPlayerPartyIcons(leader);

	memberList.push_back(&player);

	updatePlayerStatus(&player);

	player.removePartyInvitation(this);
	updateSharedExperience();

	const std::string &leaderName = leader->getName();
	ss.str(std::string());
	ss << "You have joined " << leaderName << "'" << (leaderName.back() == 's' ? "" : "s") << " party. Open the party channel to communicate with your companions.";
	player.sendTextMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());
	updateTrackerAnalyzer();
	return true;
}

bool Party::removeInvite(Player &player, bool removeFromPlayer /* = true*/) {
	auto it = std::find(inviteList.begin(), inviteList.end(), &player);
	if (it == inviteList.end()) {
		return false;
	}

	inviteList.erase(it);

	leader->sendCreatureShield(&player);
	player.sendCreatureShield(leader);

	if (removeFromPlayer) {
		player.removePartyInvitation(this);
	}

	if (empty()) {
		disband();
	}

	return true;
}

void Party::revokeInvitation(Player &player) {
	std::ostringstream ss;
	ss << leader->getName() << " has revoked " << (leader->getSex() == PLAYERSEX_FEMALE ? "her" : "his") << " invitation.";
	player.sendTextMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());

	ss.str(std::string());
	ss << "Invitation for " << player.getName() << " has been revoked.";
	leader->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());

	removeInvite(player);
}

bool Party::invitePlayer(Player &player) {
	if (isPlayerInvited(&player)) {
		return false;
	}

	std::ostringstream ss;
	ss << player.getName() << " has been invited.";

	if (empty()) {
		ss << " Open the party channel to communicate with your members.";
		g_game().updatePlayerShield(leader);
		leader->sendCreatureSkull(leader);
	}

	leader->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());

	inviteList.push_back(&player);

	leader->sendCreatureShield(&player);
	player.sendCreatureShield(leader);

	player.addPartyInvitation(this);

	ss.str(std::string());
	ss << leader->getName() << " has invited you to " << (leader->getSex() == PLAYERSEX_FEMALE ? "her" : "his") << " party.";
	player.sendTextMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());
	return true;
}

bool Party::isPlayerInvited(const Player* player) const {
	return std::find(inviteList.begin(), inviteList.end(), player) != inviteList.end();
}

void Party::updateAllPartyIcons() {
	for (Player* member : memberList) {
		for (Player* otherMember : memberList) {
			member->sendPartyCreatureShield(otherMember);
		}

		member->sendPartyCreatureShield(leader);
		leader->sendPartyCreatureShield(member);
	}
	leader->sendPartyCreatureShield(leader);
	updateTrackerAnalyzer();
}

void Party::broadcastPartyMessage(MessageClasses msgClass, const std::string &msg, bool sendToInvitations /*= false*/) {
	for (Player* member : memberList) {
		member->sendTextMessage(msgClass, msg);
	}

	leader->sendTextMessage(msgClass, msg);

	if (sendToInvitations) {
		for (Player* invitee : inviteList) {
			invitee->sendTextMessage(msgClass, msg);
		}
	}
}

void Party::updateSharedExperience() {
	if (sharedExpActive) {
		bool result = getSharedExperienceStatus() == SHAREDEXP_OK;
		if (result != sharedExpEnabled) {
			sharedExpEnabled = result;
			updateAllPartyIcons();
		}
	}
}

const char* Party::getSharedExpReturnMessage(SharedExpStatus_t value) {
	switch (value) {
		case SHAREDEXP_OK:
			return "Shared Experience is now active.";
		case SHAREDEXP_TOOFARAWAY:
			return "Shared Experience has been activated, but some members of your party are too far away.";
		case SHAREDEXP_LEVELDIFFTOOLARGE:
			return "Shared Experience has been activated, but the level spread of your party is too wide.";
		case SHAREDEXP_MEMBERINACTIVE:
			return "Shared Experience has been activated, but some members of your party are inactive.";
		case SHAREDEXP_EMPTYPARTY:
			return "Shared Experience has been activated, but you are alone in your party.";
		default:
			return "An error occured. Unable to activate shared experience.";
	}
}

bool Party::setSharedExperience(Player* player, bool newSharedExpActive) {
	if (!player || leader != player) {
		return false;
	}

	if (this->sharedExpActive == newSharedExpActive) {
		return true;
	}

	this->sharedExpActive = newSharedExpActive;

	if (newSharedExpActive) {
		SharedExpStatus_t sharedExpStatus = getSharedExperienceStatus();
		this->sharedExpEnabled = sharedExpStatus == SHAREDEXP_OK;
		leader->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, getSharedExpReturnMessage(sharedExpStatus));
	} else {
		leader->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, "Shared Experience has been deactivated.");
	}

	updateAllPartyIcons();
	return true;
}

void Party::shareExperience(uint64_t experience, Creature* target /* = nullptr*/) {
	uint64_t shareExperience = experience;
	g_events().eventPartyOnShareExperience(this, shareExperience);
	for (Player* member : memberList) {
		member->onGainSharedExperience(shareExperience, target);
	}
	leader->onGainSharedExperience(shareExperience, target);
}

bool Party::canUseSharedExperience(const Player* player) const {
	return getMemberSharedExperienceStatus(player) == SHAREDEXP_OK;
}

SharedExpStatus_t Party::getMemberSharedExperienceStatus(const Player* player) const {
	if (memberList.empty()) {
		return SHAREDEXP_EMPTYPARTY;
	}

	uint32_t highestLevel = leader->getLevel();
	for (Player* member : memberList) {
		if (member->getLevel() > highestLevel) {
			highestLevel = member->getLevel();
		}
	}

	uint32_t minLevel = static_cast<uint32_t>(std::ceil((static_cast<float>(highestLevel) * 2) / 3));
	if (player->getLevel() < minLevel) {
		return SHAREDEXP_LEVELDIFFTOOLARGE;
	}

	if (!Position::areInRange<30, 30, 1>(leader->getPosition(), player->getPosition())) {
		return SHAREDEXP_TOOFARAWAY;
	}

	if (!player->hasFlag(PlayerFlags_t::NotGainInFight)) {
		// check if the player has healed/attacked anything recently
		auto it = ticksMap.find(player->getID());
		if (it == ticksMap.end()) {
			return SHAREDEXP_MEMBERINACTIVE;
		}

		uint64_t timeDiff = OTSYS_TIME() - it->second;
		if (timeDiff > static_cast<uint64_t>(g_configManager().getNumber(PZ_LOCKED))) {
			return SHAREDEXP_MEMBERINACTIVE;
		}
	}
	return SHAREDEXP_OK;
}

SharedExpStatus_t Party::getSharedExperienceStatus() {
	SharedExpStatus_t leaderStatus = getMemberSharedExperienceStatus(leader);
	if (leaderStatus != SHAREDEXP_OK) {
		return leaderStatus;
	}

	for (Player* member : memberList) {
		SharedExpStatus_t memberStatus = getMemberSharedExperienceStatus(member);
		if (memberStatus != SHAREDEXP_OK) {
			return memberStatus;
		}
	}
	return SHAREDEXP_OK;
}

void Party::updatePlayerTicks(Player* player, uint32_t points) {
	if (points != 0 && !player->hasFlag(PlayerFlags_t::NotGainInFight)) {
		ticksMap[player->getID()] = OTSYS_TIME();
		updateSharedExperience();
	}
}

void Party::clearPlayerPoints(Player* player) {
	auto it = ticksMap.find(player->getID());
	if (it != ticksMap.end()) {
		ticksMap.erase(it);
		updateSharedExperience();
	}
}

bool Party::canOpenCorpse(uint32_t ownerId) const {
	if (const Player* player = g_game().getPlayerByID(ownerId)) {
		return leader->getID() == ownerId || player->getParty() == this;
	}
	return false;
}

void Party::showPlayerStatus(Player* player, Player* member, bool showStatus) {
	player->sendPartyCreatureShowStatus(member, showStatus);
	member->sendPartyCreatureShowStatus(player, showStatus);
	if (showStatus) {
		for (Creature* summon : member->getSummons()) {
			player->sendPartyCreatureShowStatus(summon, showStatus);
			player->sendPartyCreatureHealth(summon, std::ceil((static_cast<double>(summon->getHealth()) / std::max<int32_t>(summon->getMaxHealth(), 1)) * 100));
		}
		for (Creature* summon : player->getSummons()) {
			member->sendPartyCreatureShowStatus(summon, showStatus);
			member->sendPartyCreatureHealth(summon, std::ceil((static_cast<double>(summon->getHealth()) / std::max<int32_t>(summon->getMaxHealth(), 1)) * 100));
		}
		player->sendPartyCreatureHealth(member, std::ceil((static_cast<double>(member->getHealth()) / std::max<int32_t>(member->getMaxHealth(), 1)) * 100));
		member->sendPartyCreatureHealth(player, std::ceil((static_cast<double>(player->getHealth()) / std::max<int32_t>(player->getMaxHealth(), 1)) * 100));
		player->sendPartyPlayerMana(member, std::ceil((static_cast<double>(member->getMana()) / std::max<int32_t>(member->getMaxMana(), 1)) * 100));
		member->sendPartyPlayerMana(player, std::ceil((static_cast<double>(player->getMana()) / std::max<int32_t>(player->getMaxMana(), 1)) * 100));
	} else {
		for (Creature* summon : player->getSummons()) {
			member->sendPartyCreatureShowStatus(summon, showStatus);
		}
		for (Creature* summon : member->getSummons()) {
			player->sendPartyCreatureShowStatus(summon, showStatus);
		}
	}
}

void Party::updatePlayerStatus(Player* player) {
	int32_t maxDistance = g_configManager().getNumber(PARTY_LIST_MAX_DISTANCE);
	for (Player* member : memberList) {
		bool condition = (maxDistance == 0 || (Position::getDistanceX(player->getPosition(), member->getPosition()) <= maxDistance && Position::getDistanceY(player->getPosition(), member->getPosition()) <= maxDistance));
		if (condition) {
			showPlayerStatus(player, member, true);
		} else {
			showPlayerStatus(player, member, false);
		}
	}
	bool condition = (maxDistance == 0 || (Position::getDistanceX(player->getPosition(), leader->getPosition()) <= maxDistance && Position::getDistanceY(player->getPosition(), leader->getPosition()) <= maxDistance));
	if (condition) {
		showPlayerStatus(player, leader, true);
	} else {
		showPlayerStatus(player, leader, false);
	}
}

void Party::updatePlayerStatus(Player* player, const Position &oldPos, const Position &newPos) {
	int32_t maxDistance = g_configManager().getNumber(PARTY_LIST_MAX_DISTANCE);
	if (maxDistance != 0) {
		for (Player* member : memberList) {
			bool condition1 = (Position::getDistanceX(oldPos, member->getPosition()) <= maxDistance && Position::getDistanceY(oldPos, member->getPosition()) <= maxDistance);
			bool condition2 = (Position::getDistanceX(newPos, member->getPosition()) <= maxDistance && Position::getDistanceY(newPos, member->getPosition()) <= maxDistance);
			if (condition1 && !condition2) {
				showPlayerStatus(player, member, false);
			} else if (!condition1 && condition2) {
				showPlayerStatus(player, member, true);
			}
		}

		bool condition1 = (Position::getDistanceX(oldPos, leader->getPosition()) <= maxDistance && Position::getDistanceY(oldPos, leader->getPosition()) <= maxDistance);
		bool condition2 = (Position::getDistanceX(newPos, leader->getPosition()) <= maxDistance && Position::getDistanceY(newPos, leader->getPosition()) <= maxDistance);
		if (condition1 && !condition2) {
			showPlayerStatus(player, leader, false);
		} else if (!condition1 && condition2) {
			showPlayerStatus(player, leader, true);
		}
	}
}

void Party::updatePlayerHealth(const Player* player, const Creature* target, uint8_t healthPercent) {
	int32_t maxDistance = g_configManager().getNumber(PARTY_LIST_MAX_DISTANCE);
	for (Player* member : memberList) {
		bool condition = (maxDistance == 0 || (Position::getDistanceX(player->getPosition(), member->getPosition()) <= maxDistance && Position::getDistanceY(player->getPosition(), member->getPosition()) <= maxDistance));
		if (condition) {
			member->sendPartyCreatureHealth(target, healthPercent);
		}
	}
	bool condition = (maxDistance == 0 || (Position::getDistanceX(player->getPosition(), leader->getPosition()) <= maxDistance && Position::getDistanceY(player->getPosition(), leader->getPosition()) <= maxDistance));
	if (condition) {
		leader->sendPartyCreatureHealth(target, healthPercent);
	}
}

void Party::updatePlayerMana(const Player* player, uint8_t manaPercent) {
	int32_t maxDistance = g_configManager().getNumber(PARTY_LIST_MAX_DISTANCE);
	for (Player* member : memberList) {
		bool condition = (maxDistance == 0 || (Position::getDistanceX(player->getPosition(), member->getPosition()) <= maxDistance && Position::getDistanceY(player->getPosition(), member->getPosition()) <= maxDistance));
		if (condition) {
			member->sendPartyPlayerMana(player, manaPercent);
		}
	}
	bool condition = (maxDistance == 0 || (Position::getDistanceX(player->getPosition(), leader->getPosition()) <= maxDistance && Position::getDistanceY(player->getPosition(), leader->getPosition()) <= maxDistance));
	if (condition) {
		leader->sendPartyPlayerMana(player, manaPercent);
	}
}

void Party::updatePlayerVocation(const Player* player) {
	int32_t maxDistance = g_configManager().getNumber(PARTY_LIST_MAX_DISTANCE);
	for (Player* member : memberList) {
		bool condition = (maxDistance == 0 || (Position::getDistanceX(player->getPosition(), member->getPosition()) <= maxDistance && Position::getDistanceY(player->getPosition(), member->getPosition()) <= maxDistance));
		if (condition) {
			member->sendPartyPlayerVocation(player);
		}
	}
	bool condition = (maxDistance == 0 || (Position::getDistanceX(player->getPosition(), leader->getPosition()) <= maxDistance && Position::getDistanceY(player->getPosition(), leader->getPosition()) <= maxDistance));
	if (condition) {
		leader->sendPartyPlayerVocation(player);
	}
}

void Party::updateTrackerAnalyzer() const {
	for (const Player* member : memberList) {
		member->updatePartyTrackerAnalyzer();
	}

	if (leader) {
		leader->updatePartyTrackerAnalyzer();
	}
}

void Party::addPlayerLoot(const Player* player, const Item* item) {
	PartyAnalyzer* playerAnalyzer = getPlayerPartyAnalyzerStruct(player->getID());
	if (!playerAnalyzer) {
		playerAnalyzer = new PartyAnalyzer(player->getID(), player->getName());
		membersData.push_back(playerAnalyzer);
	}

	uint32_t count = std::max<uint32_t>(1, item->getItemCount());
	if (auto it = playerAnalyzer->lootMap.find(item->getID()); it != playerAnalyzer->lootMap.end()) {
		(*it).second += count;
	} else {
		playerAnalyzer->lootMap.insert({ item->getID(), count });
	}

	if (priceType == LEADER_PRICE) {
		playerAnalyzer->lootPrice += leader->getItemCustomPrice(item->getID()) * count;
	} else {
		std::map<uint16_t, uint64_t> itemMap { { item->getID(), count } };
		playerAnalyzer->lootPrice += g_game().getItemMarketPrice(itemMap, false);
	}
	updateTrackerAnalyzer();
}

void Party::addPlayerSupply(const Player* player, const Item* item) {
	PartyAnalyzer* playerAnalyzer = getPlayerPartyAnalyzerStruct(player->getID());
	if (!playerAnalyzer) {
		playerAnalyzer = new PartyAnalyzer(player->getID(), player->getName());
		membersData.push_back(playerAnalyzer);
	}

	if (auto it = playerAnalyzer->supplyMap.find(item->getID()); it != playerAnalyzer->supplyMap.end()) {
		(*it).second += 1;
	} else {
		playerAnalyzer->supplyMap.insert({ item->getID(), 1 });
	}

	if (priceType == LEADER_PRICE) {
		playerAnalyzer->supplyPrice += leader->getItemCustomPrice(item->getID(), true);
	} else {
		std::map<uint16_t, uint64_t> itemMap { { item->getID(), 1 } };
		playerAnalyzer->supplyPrice += g_game().getItemMarketPrice(itemMap, true);
	}
	updateTrackerAnalyzer();
}

void Party::addPlayerDamage(const Player* player, uint64_t amount) {
	PartyAnalyzer* playerAnalyzer = getPlayerPartyAnalyzerStruct(player->getID());
	if (!playerAnalyzer) {
		playerAnalyzer = new PartyAnalyzer(player->getID(), player->getName());
		membersData.push_back(playerAnalyzer);
	}

	playerAnalyzer->damage += amount;
	updateTrackerAnalyzer();
}

void Party::addPlayerHealing(const Player* player, uint64_t amount) {
	PartyAnalyzer* playerAnalyzer = getPlayerPartyAnalyzerStruct(player->getID());
	if (!playerAnalyzer) {
		playerAnalyzer = new PartyAnalyzer(player->getID(), player->getName());
		membersData.push_back(playerAnalyzer);
	}

	playerAnalyzer->healing += amount;
	updateTrackerAnalyzer();
}

void Party::switchAnalyzerPriceType() {
	if (leader == nullptr) {
		return;
	}

	priceType = priceType == LEADER_PRICE ? MARKET_PRICE : LEADER_PRICE;
	reloadPrices();
	updateTrackerAnalyzer();
}

void Party::resetAnalyzer() {
	trackerTime = time(nullptr);
	for (PartyAnalyzer* analyzer : membersData) {
		delete analyzer;
	}

	membersData.clear();
	updateTrackerAnalyzer();
}

void Party::reloadPrices() {
	for (PartyAnalyzer* analyzer : membersData) {
		if (priceType == MARKET_PRICE) {
			analyzer->lootPrice = g_game().getItemMarketPrice(analyzer->lootMap, false);
			analyzer->supplyPrice = g_game().getItemMarketPrice(analyzer->supplyMap, true);
			continue;
		}

		analyzer->lootPrice = 0;
		for (const auto it : analyzer->lootMap) {
			analyzer->lootPrice += leader->getItemCustomPrice(it.first) * it.second;
		}

		analyzer->supplyPrice = 0;
		for (const auto it : analyzer->supplyMap) {
			analyzer->supplyPrice += leader->getItemCustomPrice(it.first, true) * it.second;
		}
	}
}
