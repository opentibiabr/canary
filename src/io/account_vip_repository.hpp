/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <string>
	#include <vector>
#endif

struct VIPEntry;
struct VIPGroupEntry;

class IAccountVipRepository {
public:
	virtual ~IAccountVipRepository() = default;

	virtual std::vector<VIPEntry> getEntries(uint32_t accountId) = 0;
	virtual bool addEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) = 0;
	virtual bool editEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) = 0;
	virtual bool removeEntry(uint32_t accountId, uint32_t guid) = 0;

	virtual std::vector<VIPGroupEntry> getGroups(uint32_t accountId) = 0;
	virtual bool addGroup(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable) = 0;
	virtual bool editGroup(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable) = 0;
	virtual bool removeGroup(uint8_t groupId, uint32_t accountId) = 0;

	virtual bool addGuidToGroup(uint8_t groupId, uint32_t accountId, uint32_t guid) = 0;
	virtual bool removeGuidFromGroup(uint32_t accountId, uint32_t guid) = 0;
};

IAccountVipRepository &g_accountVipRepository();
