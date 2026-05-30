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

	void schedulePlayer(std::weak_ptr<Player> player);
	bool doSavePlayer(std::shared_ptr<Player> player);
	// Dispatcher callback after a player's async flush finishes: clears the
	// in-flight flag and rebuilds if another save was requested meanwhile.
	void onPlayerFlushed(uint32_t guid);

	// (name, captured SQL) pairs produced by the save build phase.
	using PlayerSaveBatch = std::vector<std::pair<std::string, std::vector<std::string>>>;
	// Builds save payloads for every online player. MUST run on the dispatcher —
	// it reads (and adjusts loginPosition of) live player state.
	PlayerSaveBatch buildAllPlayers();
	// Executes the built payloads (in parallel when possible). Touches no player
	// state, so it is safe on a pool thread.
	void flushBuiltPlayers(PlayerSaveBatch &built);
	void saveGuildsMapAndKV();

	std::atomic<std::chrono::steady_clock::time_point> m_scheduledAt;
	// Per-player async-save coordination (dispatcher-only, no lock): guids whose
	// flush is currently running on a pool thread, and guids that were asked to
	// save again while a flush was in flight (rebuilt once the flush completes).
	// This keeps same-player flushes serial and ordered so an older flush can
	// never overwrite a newer one.
	phmap::flat_hash_set<uint32_t> m_flushInFlight;
	phmap::flat_hash_set<uint32_t> m_resavePending;

	ThreadPool &threadPool;
	KVStore &kv;
	Logger &logger;
	Game &game;
};

constexpr auto g_saveManager = SaveManager::getInstance;
