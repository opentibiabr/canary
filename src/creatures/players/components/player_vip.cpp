/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

// Player.hpp already includes the vip
#include "creatures/players/player.hpp"

#include "account/account.hpp"
#include "creatures/players/grouping/groups.hpp"
#include "io/iologindata.hpp"
#include "server/network/protocol/protocolgame.hpp"

const uint8_t PlayerVIP::firstID = 1;
const uint8_t PlayerVIP::lastID = 8;

PlayerVIP::PlayerVIP(Player &player) :
	m_player(player) { }

size_t PlayerVIP::getMaxEntries() const {
	if (m_player.group && m_player.group->maxVipEntries != 0) {
		return m_player.group->maxVipEntries;
	}
	if (m_player.isPremium()) {
		return 100;
	}
	return 20;
}

uint8_t PlayerVIP::getMaxGroupEntries() const {
	if (m_player.isPremium()) {
		return 8; // max number of groups is 8 (5 custom and 3 default)
	}
	return 0;
}

void PlayerVIP::notifyStatusChange(const std::shared_ptr<Player> &loginPlayer, VipStatus_t vipStatus, bool message) const {
	if (!m_player.client) {
		return;
	}

	if (!vipGuids.contains(loginPlayer->getGUID())) {
		return;
	}

	m_player.client->sendUpdatedVIPStatus(loginPlayer->getGUID(), vipStatus);

	if (message) {
		if (vipStatus == VipStatus_t::Online) {
			m_player.sendTextMessage(TextMessage(MESSAGE_FAILURE, fmt::format("{} has logged in.", loginPlayer->getName())));
		} else if (vipStatus == VipStatus_t::Offline) {
			m_player.sendTextMessage(TextMessage(MESSAGE_FAILURE, fmt::format("{} has logged out.", loginPlayer->getName())));
		}
	}
}

bool PlayerVIP::remove(uint32_t vipGuid) {
	if (!vipGuids.erase(vipGuid)) {
		return false;
	}

	vipGuids.erase(vipGuid);
	if (m_player.account) {
		IOLoginData::removeVIPEntry(m_player.account->getID(), vipGuid);
	}

	return true;
}

bool PlayerVIP::add(uint32_t vipGuid, const std::string &vipName, VipStatus_t vipStatus) {
	if (vipGuids.size() >= getMaxEntries() || vipGuids.size() == 200) { // max number of buddies is 200 in 9.53
		m_player.sendTextMessage(MESSAGE_FAILURE, "You cannot add more buddies.");
		return false;
	}

	if (!vipGuids.insert(vipGuid).second) {
		m_player.sendTextMessage(MESSAGE_FAILURE, "This player is already in your list.");
		return false;
	}

	if (m_player.account) {
		IOLoginData::addVIPEntry(m_player.account->getID(), vipGuid, "", 0, false);
	}

	if (m_player.client) {
		m_player.client->sendVIP(vipGuid, vipName, "", 0, false, vipStatus);
	}

	return true;
}

bool PlayerVIP::addInternal(uint32_t vipGuid) {
	if (vipGuids.size() >= getMaxEntries() || vipGuids.size() == 200) { // max number of buddies is 200 in 9.53
		return false;
	}

	return vipGuids.insert(vipGuid).second;
}

bool PlayerVIP::edit(uint32_t vipGuid, const std::string &description, uint32_t icon, bool notify, const std::vector<uint8_t> &groupsId) const {
	auto it = vipGuids.find(vipGuid);
	if (it == vipGuids.end()) {
		return false; // player is not in VIP
	}

	if (m_player.account) {
		IOLoginData::editVIPEntry(m_player.account->getID(), vipGuid, description, icon, notify);
	}

	IOLoginData::removeGuidVIPGroupEntry(m_player.account->getID(), vipGuid);

	for (const auto &groupId : groupsId) {
		const auto &group = getGroupByID(groupId);
		if (group) {
			group->vipGroupGuids.insert(vipGuid);
			IOLoginData::addGuidVIPGroupEntry(group->id, m_player.account->getID(), vipGuid);
		}
	}

	return true;
}

std::shared_ptr<VIPGroup> PlayerVIP::getGroupByID(uint8_t groupId) const {
	auto it = std::ranges::find_if(vipGroups, [groupId](const auto &vipGroup) {
		return vipGroup->id == groupId;
	});

	return it != vipGroups.end() ? *it : nullptr;
}

std::shared_ptr<VIPGroup> PlayerVIP::getGroupByName(const std::string &name) const {
	const auto groupName = name.c_str();
	auto it = std::ranges::find_if(vipGroups, [groupName](const auto &vipGroup) {
		return strcmp(groupName, vipGroup->name.c_str()) == 0;
	});

	return it != vipGroups.end() ? *it : nullptr;
}

void PlayerVIP::addGroupInternal(uint8_t groupId, const std::string &name, bool customizable) {
	if (getGroupByName(name) != nullptr) {
		g_logger().debug("{} - Group name already exists.", __FUNCTION__);
		return;
	}

	const auto freeId = getFreeId();
	if (freeId == 0) {
		g_logger().debug("{} - No id available.", __FUNCTION__);
		return;
	}

	vipGroups.emplace_back(std::make_shared<VIPGroup>(freeId, name, customizable));
}

void PlayerVIP::removeGroup(uint8_t groupId) {
	auto it = std::ranges::find_if(vipGroups, [groupId](const auto &vipGroup) {
		return vipGroup->id == groupId;
	});

	if (it == vipGroups.end()) {
		return;
	}

	vipGroups.erase(it);

	if (m_player.account) {
		IOLoginData::removeVIPGroupEntry(groupId, m_player.account->getID());
	}

	if (m_player.client) {
		m_player.client->sendVIPGroups();
	}
}

void PlayerVIP::addGroup(const std::string &name, bool customizable /*= true */) {
	if (getGroupByName(name) != nullptr) {
		m_player.sendCancelMessage("A group with this name already exists. Please choose another name.");
		return;
	}

	const auto freeId = getFreeId();
	if (freeId == 0) {
		g_logger().warn("{} - No id available.", __FUNCTION__);
		return;
	}

	auto vipGroup = std::make_shared<VIPGroup>(freeId, name, customizable);
	vipGroups.emplace_back(vipGroup);

	if (m_player.account) {
		IOLoginData::addVIPGroupEntry(vipGroup->id, m_player.account->getID(), vipGroup->name, vipGroup->customizable);
	}

	if (m_player.client) {
		m_player.client->sendVIPGroups();
	}
}

void PlayerVIP::editGroup(uint8_t groupId, const std::string &newName, bool customizable /*= true*/) const {
	if (getGroupByName(newName) != nullptr) {
		m_player.sendCancelMessage("A group with this name already exists. Please choose another name.");
		return;
	}

	const auto &vipGroup = getGroupByID(groupId);
	vipGroup->name = newName;
	vipGroup->customizable = customizable;

	if (m_player.account) {
		IOLoginData::editVIPGroupEntry(vipGroup->id, m_player.account->getID(), vipGroup->name, vipGroup->customizable);
	}

	if (m_player.client) {
		m_player.client->sendVIPGroups();
	}
}

uint8_t PlayerVIP::getFreeId() const {
	for (uint8_t i = firstID; i <= lastID; ++i) {
		if (getGroupByID(i) == nullptr) {
			return i;
		}
	}

	return 0;
}

std::vector<uint8_t> PlayerVIP::getGroupsIdGuidBelongs(uint32_t guid) const {
	std::vector<uint8_t> guidBelongs;
	for (const auto &vipGroup : vipGroups) {
		if (vipGroup->vipGroupGuids.contains(guid)) {
			guidBelongs.emplace_back(vipGroup->id);
		}
	}
	return guidBelongs;
}

void PlayerVIP::addGuidToGroupInternal(uint8_t groupId, uint32_t guid) const {
	const auto &group = getGroupByID(groupId);
	if (group) {
		group->vipGroupGuids.insert(guid);
	}
}
