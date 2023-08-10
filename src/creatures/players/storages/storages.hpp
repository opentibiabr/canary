/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#ifndef SRC_CREATURES_PLAYERS_STORAGES_STORAGES_HPP_
#define SRC_CREATURES_PLAYERS_STORAGES_STORAGES_HPP_

class Storages {
	public:
		// Singleton - ensures we don't accidentally copy it
		Storages(const Storages &) = delete;
		void operator=(const Storages &) = delete;

		static Storages &getInstance() {
			// Guaranteed to be destroyed
			static Storages instance;
			// Instantiated on first use
			return instance;
		}

		bool loadFromXML();

		const phmap::btree_map<std::string, uint32_t> &getStorageMap() const;

	private:
		Storages() = default;

		phmap::btree_map<std::string, uint32_t> m_storageMap;
};

constexpr auto g_storages = &Storages::getInstance;

#endif // SRC_CREATURES_PLAYERS_STORAGES_STORAGES_HPP_
