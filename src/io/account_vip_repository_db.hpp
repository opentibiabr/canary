/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "io/account_vip_repository.hpp"

class DbAccountVipRepository final : public IAccountVipRepository {
public:
	std::vector<VIPEntry> getEntries(uint32_t accountId) override;
	bool addEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) override;
	bool editEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) override;
	bool removeEntry(uint32_t accountId, uint32_t guid) override;

	std::vector<VIPGroupEntry> getGroups(uint32_t accountId) override;
	bool addGroup(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable) override;
	bool editGroup(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable) override;
	bool removeGroup(uint8_t groupId, uint32_t accountId) override;

	bool addGuidToGroup(uint8_t groupId, uint32_t accountId, uint32_t guid) override;
	bool removeGuidFromGroup(uint32_t accountId, uint32_t guid) override;
};
