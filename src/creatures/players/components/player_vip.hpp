/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/creatures_definitions.hpp"

class Player;

class VIPGroup {
public:
	uint8_t id = 0;
	std::string name;
	bool customizable = false;
	phmap::flat_hash_set<uint32_t> vipGroupGuids;

	VIPGroup() = default;
	VIPGroup(uint8_t id, std::string name, bool customizable) :
		id(id), name(std::move(name)), customizable(customizable) { }
};

class PlayerVIP {
public:
	explicit PlayerVIP(Player &player);

	static const uint8_t firstID;
	static const uint8_t lastID;

	size_t getMaxEntries() const;
	uint8_t getMaxGroupEntries() const;

	VipStatus_t getStatus() const {
		return status;
	}
	void setStatus(VipStatus_t newStatus) {
		status = newStatus;
	}

	void notifyStatusChange(const std::shared_ptr<Player> &loginPlayer, VipStatus_t status, bool message = true) const;
	bool remove(uint32_t vipGuid);
	bool add(uint32_t vipGuid, const std::string &vipName, VipStatus_t status);
	bool addInternal(uint32_t vipGuid);
	bool edit(uint32_t vipGuid, const std::string &description, uint32_t icon, bool notify, const std::vector<uint8_t> &groupsId) const;

	// VIP Group
	std::shared_ptr<VIPGroup> getGroupByID(uint8_t groupId) const;
	std::shared_ptr<VIPGroup> getGroupByName(const std::string &name) const;

	void addGroupInternal(uint8_t groupId, const std::string &name, bool customizable);
	void removeGroup(uint8_t groupId);
	void addGroup(const std::string &name, bool customizable = true);
	void editGroup(uint8_t groupId, const std::string &newName, bool customizable = true) const;

	void addGuidToGroupInternal(uint8_t groupId, uint32_t guid) const;

	uint8_t getFreeId() const;
	std::vector<uint8_t> getGroupsIdGuidBelongs(uint32_t guid) const;

	[[nodiscard]] const std::vector<std::shared_ptr<VIPGroup>> &getGroups() const {
		return vipGroups;
	}

private:
	Player &m_player;

	VipStatus_t status = VipStatus_t::Online;
	std::vector<std::shared_ptr<VIPGroup>> vipGroups;
	phmap::flat_hash_set<uint32_t> vipGuids;
};
