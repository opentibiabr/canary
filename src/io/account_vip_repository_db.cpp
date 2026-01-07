/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "io/account_vip_repository_db.hpp"

#include "database/database.hpp"
#include "lib/di/container.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <fmt/format.h>
#endif

std::vector<VIPEntry> DbAccountVipRepository::getEntries(uint32_t accountId) {
	std::vector<VIPEntry> entries;

	const auto query = fmt::format(
		"SELECT `player_id`, (SELECT `name` FROM `players` WHERE `id` = `player_id`) AS `name`, `description`, `icon`, `notify` "
		"FROM `account_viplist` WHERE `account_id` = {}",
		accountId
	);

	if (const auto &result = g_database().storeQuery(query)) {
		entries.reserve(result->countResults());
		do {
			entries.emplace_back(
				result->getNumber<uint32_t>("player_id"),
				result->getString("name"),
				result->getString("description"),
				result->getNumber<uint32_t>("icon"),
				result->getNumber<uint16_t>("notify") != 0
			);
		} while (result->next());
	}

	return entries;
}

bool DbAccountVipRepository::addEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) {
	const auto query = fmt::format(
		"INSERT INTO `account_viplist` (`account_id`, `player_id`, `description`, `icon`, `notify`) VALUES ({}, {}, {}, {}, {})",
		accountId,
		guid,
		g_database().escapeString(description),
		icon,
		notify
	);
	return g_database().executeQuery(query);
}

bool DbAccountVipRepository::editEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) {
	const auto query = fmt::format(
		"UPDATE `account_viplist` SET `description` = {}, `icon` = {}, `notify` = {} WHERE `account_id` = {} AND `player_id` = {}",
		g_database().escapeString(description),
		icon,
		notify,
		accountId,
		guid
	);
	return g_database().executeQuery(query);
}

bool DbAccountVipRepository::removeEntry(uint32_t accountId, uint32_t guid) {
	const auto query = fmt::format(
		"DELETE FROM `account_viplist` WHERE `account_id` = {} AND `player_id` = {}",
		accountId,
		guid
	);
	return g_database().executeQuery(query);
}

std::vector<VIPGroupEntry> DbAccountVipRepository::getGroups(uint32_t accountId) {
	std::vector<VIPGroupEntry> entries;

	const auto query = fmt::format(
		"SELECT `id`, `name`, `customizable` FROM `account_vipgroups` WHERE `account_id` = {}",
		accountId
	);

	if (const auto &result = g_database().storeQuery(query)) {
		entries.reserve(result->countResults());
		do {
			entries.emplace_back(
				result->getNumber<uint8_t>("id"),
				result->getString("name"),
				result->getNumber<uint8_t>("customizable") != 0
			);
		} while (result->next());
	}

	return entries;
}

bool DbAccountVipRepository::addGroup(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable) {
	const auto query = fmt::format(
		"INSERT INTO `account_vipgroups` (`id`, `account_id`, `name`, `customizable`) VALUES ({}, {}, {}, {})",
		groupId,
		accountId,
		g_database().escapeString(groupName),
		customizable
	);
	return g_database().executeQuery(query);
}

bool DbAccountVipRepository::editGroup(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable) {
	const auto query = fmt::format(
		"UPDATE `account_vipgroups` SET `name` = {}, `customizable` = {} WHERE `id` = {} AND `account_id` = {}",
		g_database().escapeString(groupName),
		customizable,
		groupId,
		accountId
	);
	return g_database().executeQuery(query);
}

bool DbAccountVipRepository::removeGroup(uint8_t groupId, uint32_t accountId) {
	const auto query = fmt::format(
		"DELETE FROM `account_vipgroups` WHERE `id` = {} AND `account_id` = {}",
		groupId,
		accountId
	);
	return g_database().executeQuery(query);
}

bool DbAccountVipRepository::addGuidToGroup(uint8_t groupId, uint32_t accountId, uint32_t guid) {
	const auto query = fmt::format(
		"INSERT INTO `account_vipgrouplist` (`account_id`, `player_id`, `vipgroup_id`) VALUES ({}, {}, {})",
		accountId,
		guid,
		groupId
	);
	return g_database().executeQuery(query);
}

bool DbAccountVipRepository::removeGuidFromGroup(uint32_t accountId, uint32_t guid) {
	const auto query = fmt::format(
		"DELETE FROM `account_vipgrouplist` WHERE `account_id` = {} AND `player_id` = {}",
		accountId,
		guid
	);
	return g_database().executeQuery(query);
}

IAccountVipRepository &g_accountVipRepository() {
	return inject<DbAccountVipRepository>();
}
