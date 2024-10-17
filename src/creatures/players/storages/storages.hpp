/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#pragma once

class Storages {
public:
	Storages() = default;

	// Singleton - ensures we don't accidentally copy it
	Storages(const Storages &) = delete;
	void operator=(const Storages &) = delete;

	static Storages &getInstance();

	bool loadFromXML();

	const std::map<std::string, uint32_t> &getStorageMap() const;

private:
	std::map<std::string, uint32_t> m_storageMap;
};

constexpr auto g_storages = Storages::getInstance;
