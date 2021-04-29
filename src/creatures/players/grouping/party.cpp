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

#include "creatures/players/grouping/party.h"
#include "game/game.h"
#include "config/configmanager.h"
#include "lua/creature/events.h"

extern Game g_game;
extern ConfigManager g_config;
extern Events* g_events;

Party::Party(Player* initLeader) : leader(initLeader)
{
	leader->setParty(this);
}

void Party::disband()
{
	if (!g_events->eventPartyOnDisband(this)) {
		return;
	}

	Player* currentLeader = leader;
	leader = nullptr;

	currentLeader->setParty(nullptr);
	currentLeader->sendClosePrivate(CHANNEL_PARTY);
	g_game.updatePlayerShield(currentLeader);
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
		g_game.updatePlayerShield(member);

		for (Player* otherMember : memberList) {
			otherMember->sendCreatureSkull(member);
		}

		member->sendCreatureSkull(currentLeader);
		currentLeader->sendCreatureSkull(member);
	}
	memberList.clear();
	delete this;
}

bool Party::leaveParty(Player* player)
{
	if (!player) {
		return false;
	}

	if (player->getParty() != this && leader != player) {
		return false;
	}

	if (!g_events->eventPartyOnLeave(this, player)) {
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

	//since we already passed the leadership, we remove the player from the list
	auto it = std::find(memberList.begin(), memberList.end(), player);
	if (it != memberList.end()) {
		memberList.erase(it);
	}

	player->setParty(nullptr);
	player->sendClosePrivate(CHANNEL_PARTY);
	g_game.updatePlayerShield(player);

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

bool Party::passPartyLeadership(Player* player)
{
	if (!player || leader == player || player->getParty() != this) {
		return false;
	}

	//Remove it before to broadcast the message correctly
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

bool Party::joinParty(Player& player)
{
	if (!g_events->eventPartyOnJoin(this, &player)) {
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

	g_game.updatePlayerShield(&player);

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

	const std::string& leaderName = leader->getName();
	ss.str(std::string());
	ss << "You have joined " << leaderName << "'" << (leaderName.back() == 's' ? "" : "s") <<
	   " party. Open the party channel to communicate with your companions.";
	player.sendTextMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());
	return true;
}

bool Party::removeInvite(Player& player, bool removeFromPlayer/* = true*/)
{
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

void Party::revokeInvitation(Player& player)
{
	std::ostringstream ss;
	ss << leader->getName() << " has revoked " << (leader->getSex() == PLAYERSEX_FEMALE ? "her" : "his") << " invitation.";
	player.sendTextMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());

	ss.str(std::string());
	ss << "Invitation for " << player.getName() << " has been revoked.";
	leader->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());

	removeInvite(player);
}

bool Party::invitePlayer(Player& player)
{
	if (isPlayerInvited(&player)) {
		return false;
	}

	std::ostringstream ss;
	ss << player.getName() << " has been invited.";

	if (empty()) {
		ss << " Open the party channel to communicate with your members.";
		g_game.updatePlayerShield(leader);
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

bool Party::isPlayerInvited(const Player* player) const
{
	return std::find(inviteList.begin(), inviteList.end(), player) != inviteList.end();
}

void Party::updateAllPartyIcons()
{
	for (Player* member : memberList) {
		for (Player* otherMember : memberList) {
			member->sendPartyCreatureShield(otherMember);
		}

		member->sendPartyCreatureShield(leader);
		leader->sendPartyCreatureShield(member);
	}
	leader->sendPartyCreatureShield(leader);
}

void Party::broadcastPartyMessage(MessageClasses msgClass, const std::string& msg, bool sendToInvitations /*= false*/)
{
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

void Party::updateSharedExperience()
{
	if (sharedExpActive) {
		bool result = canEnableSharedExperience();
		if (result != sharedExpEnabled) {
			sharedExpEnabled = result;
			updateAllPartyIcons();
		}
	}
}

bool Party::setSharedExperience(Player* player, bool newSharedExpActive)
{
	if (!player || leader != player) {
		return false;
	}

	if (this->sharedExpActive == newSharedExpActive) {
		return true;
	}

	this->sharedExpActive = newSharedExpActive;

	if (newSharedExpActive) {
		this->sharedExpEnabled = canEnableSharedExperience();

		if (this->sharedExpEnabled) {
			leader->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, "Shared Experience is now active.");
		} else {
			leader->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, "Shared Experience has been activated, but some members of your party are inactive.");
		}
	} else {
		leader->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, "Shared Experience has been deactivated.");
	}

	updateAllPartyIcons();
	return true;
}

void Party::shareExperience(uint64_t experience, Creature* source/* = nullptr*/)
{
	uint64_t shareExperience = experience;
	g_events->eventPartyOnShareExperience(this, shareExperience);
	for (Player* member : memberList) {
		member->onGainSharedExperience(shareExperience, source);
	}
	leader->onGainSharedExperience(shareExperience, source);
}

bool Party::canUseSharedExperience(const Player* player) const
{
	if (memberList.empty()) {
		return false;
	}

	uint32_t highestLevel = leader->getLevel();
	for (Player* member : memberList) {
		if (member->getLevel() > highestLevel) {
			highestLevel = member->getLevel();
		}
	}

	uint32_t minLevel = static_cast<uint32_t>(std::ceil((static_cast<float>(highestLevel) * 2) / 3));
	if (player->getLevel() < minLevel) {
		return false;
	}

	if (!Position::areInRange<30, 30, 1>(leader->getPosition(), player->getPosition())) {
		return false;
	}

	if (!player->hasFlag(PlayerFlag_NotGainInFight)) {
		//check if the player has healed/attacked anything recently
		auto it = ticksMap.find(player->getID());
		if (it == ticksMap.end()) {
			return false;
		}

		uint64_t timeDiff = OTSYS_TIME() - it->second;
		if (timeDiff > static_cast<uint64_t>(g_config.getNumber(ConfigManager::PZ_LOCKED))) {
			return false;
		}
	}
	return true;
}

bool Party::canEnableSharedExperience()
{
	if (!canUseSharedExperience(leader)) {
		return false;
	}

	for (Player* member : memberList) {
		if (!canUseSharedExperience(member)) {
			return false;
		}
	}
	return true;
}

void Party::updatePlayerTicks(Player* player, uint32_t points)
{
	if (points != 0 && !player->hasFlag(PlayerFlag_NotGainInFight)) {
		ticksMap[player->getID()] = OTSYS_TIME();
		updateSharedExperience();
	}
}

void Party::clearPlayerPoints(Player* player)
{
	auto it = ticksMap.find(player->getID());
	if (it != ticksMap.end()) {
		ticksMap.erase(it);
		updateSharedExperience();
	}
}

bool Party::canOpenCorpse(uint32_t ownerId) const
{
	if (Player* player = g_game.getPlayerByID(ownerId)) {
		return leader->getID() == ownerId || player->getParty() == this;
	}
	return false;
}

void Party::showPlayerStatus(Player* player, Player* member, bool showStatus)
{
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

void Party::updatePlayerStatus(Player* player)
{
	int32_t maxDistance = g_config.getNumber(ConfigManager::PARTY_LIST_MAX_DISTANCE);
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

void Party::updatePlayerStatus(Player* player, const Position& oldPos, const Position& newPos)
{
	int32_t maxDistance = g_config.getNumber(ConfigManager::PARTY_LIST_MAX_DISTANCE);
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

void Party::updatePlayerHealth(const Player* player, const Creature* target, uint8_t healthPercent)
{
	int32_t maxDistance = g_config.getNumber(ConfigManager::PARTY_LIST_MAX_DISTANCE);
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

void Party::updatePlayerMana(const Player* player, uint8_t manaPercent)
{
	int32_t maxDistance = g_config.getNumber(ConfigManager::PARTY_LIST_MAX_DISTANCE);
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

void Party::updatePlayerVocation(const Player* player)
{
	int32_t maxDistance = g_config.getNumber(ConfigManager::PARTY_LIST_MAX_DISTANCE);
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