/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lib/thread/thread_pool.hpp"

class KVStore;
class Logger;
class Game;
class Player;
class Guild;

class SaveManager {
public:
	explicit SaveManager(ThreadPool &threadPool, KVStore &kvStore, Logger &logger, Game &game);

	SaveManager(const SaveManager &) = delete;
	void operator=(const SaveManager &) = delete;

	static SaveManager &getInstance();

	void saveAll();
	void scheduleAll();

	bool savePlayer(std::shared_ptr<Player> player);
	void saveGuild(std::shared_ptr<Guild> guild);

private:
	void saveMap();
	void saveKV();

	/**
	 * Schedules saving the current online player object.
	 *
	 * The weak pointer is intentional: GUID or player runtime ID re-resolution
	 * can point at a later session for the same character, while the save must
	 * target the object that requested it or skip if that object is gone.
	 */
	void schedulePlayer(std::weak_ptr<Player> player);
	/**
	 * Saves a pinned player object.
	 *
	 * Keep the strong owner for the duration of serialization. Replacing this
	 * with GUID-only lookup would change which player generation is saved.
	 */
	bool doSavePlayer(std::shared_ptr<Player> player);

	std::atomic<std::chrono::steady_clock::time_point> m_scheduledAt;
	phmap::parallel_flat_hash_map<uint32_t, std::chrono::steady_clock::time_point> m_playerMap;

	ThreadPool &threadPool;
	KVStore &kv;
	Logger &logger;
	Game &game;
};

constexpr auto g_saveManager = SaveManager::getInstance;
