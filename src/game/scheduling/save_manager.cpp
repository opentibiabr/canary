/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/save_manager.hpp"

#include "config/configmanager.hpp"
#include "creatures/players/grouping/guild.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "io/ioguild.hpp"
#include "io/iologindata.hpp"
#include "kv/kv.hpp"
#include "lib/di/container.hpp"
#include "creatures/players/player.hpp"

SaveManager::SaveManager(ThreadPool &threadPool, KVStore &kvStore, Logger &logger, Game &game) :
	threadPool(threadPool), kv(kvStore), logger(logger), game(game) { }

SaveManager &SaveManager::getInstance() {
	return inject<SaveManager>();
}

SaveManager::PlayerSaveBatch SaveManager::buildAllPlayers() {
	// Dispatcher thread: read (and adjust) live player state and serialize each
	// player to SQL. CPU-only — no DB round-trips (the save build is captured).
	const auto &players = game.getPlayers();
	PlayerSaveBatch built;
	built.reserve(players.size());
	for (const auto &[_, player] : players) {
		if (player->isDead()) {
			player->loginPosition = player->getTemplePosition();
		} else if (player->loginPosition != player->getTemplePosition()) {
			player->loginPosition = player->getPosition();
		}

		auto queries = IOLoginData::buildPlayerSave(player);
		if (!queries) {
			logger.error("Failed to build save for player {}.", player->getName());
			continue;
		}
		built.emplace_back(player->getName(), std::move(*queries));
	}
	return built;
}

void SaveManager::flushBuiltPlayers(PlayerSaveBatch &built) {
	// Pool-safe: only executes the captured SQL, never touches a player.
	Benchmark bm_players;
	logger.info("Saving {} players...", built.size());
	const bool flushInParallel = threadPool.get_thread_count() > 1 && built.size() > 1;

	if (flushInParallel) {
		std::vector<std::pair<std::future<void>, std::string>> pending;
		pending.reserve(built.size());
		for (auto &[name, queries] : built) {
			auto fut = threadPool.submit_task([this, q = std::move(queries), name]() {
				if (!IOLoginData::flushPlayerSave(q)) {
					logger.error("Failed to save player {}.", name);
				}
			});
			pending.emplace_back(std::move(fut), name);
		}
		for (auto &[future, name] : pending) {
			try {
				future.get();
			} catch (const std::exception &e) {
				logger.error("Failed to save player {}: {}", name, e.what());
			}
		}
	} else {
		for (auto &[name, queries] : built) {
			if (!IOLoginData::flushPlayerSave(queries)) {
				logger.error("Failed to save player {}.", name);
			}
		}
	}

	double duration_players = bm_players.duration();
	if (duration_players > 1000.0) {
		logger.info("Players saved in {:.2f} seconds.", duration_players / 1000.0);
	} else {
		logger.info("Players saved in {} milliseconds.", duration_players);
	}
}

void SaveManager::saveGuildsMapAndKV() {
	Benchmark bm_guilds;
	const auto &guilds = game.getGuilds();
	for (const auto &[_, guild] : guilds) {
		saveGuild(guild);
	}
	double duration_guilds = bm_guilds.duration();
	if (duration_guilds > 1000.0) {
		logger.info("Guilds saved in {:.2f} seconds.", duration_guilds / 1000.0);
	} else {
		logger.info("Guilds saved in {} milliseconds.", duration_guilds);
	}

	saveMap();
	saveKV();
}

void SaveManager::saveAll() {
	// Synchronous full save (non-async path / shutdown): build then flush on the
	// calling thread. Safe when run on the dispatcher.
	Benchmark bm_saveAll;
	logger.info("Saving server...");
	auto built = buildAllPlayers();
	flushBuiltPlayers(built);
	saveGuildsMapAndKV();

	double duration_saveAll = bm_saveAll.duration();
	if (duration_saveAll > 1000.0) {
		logger.info("Server saved in {:.2f} seconds.", duration_saveAll / 1000.0);
	} else {
		logger.info("Server saved in {} milliseconds.", duration_saveAll);
	}
}

void SaveManager::scheduleAll() {
	auto scheduledAt = std::chrono::steady_clock::now();
	m_scheduledAt = scheduledAt;

	// Disable save async if the config is set to false
	if (!g_configManager().getBoolean(TOGGLE_SAVE_ASYNC)) {
		saveAll();
		return;
	}

	// Build every player's save on the dispatcher (consistent, CPU-only read),
	// then flush them plus guilds/map/kv on a pool thread so the save I/O does
	// not block the game loop.
	auto built = buildAllPlayers();

	threadPool.detach_task([this, scheduledAt, built = std::move(built)]() mutable {
		if (m_scheduledAt.load() != scheduledAt) {
			logger.warn("Skipping save for server because another save has been scheduled.");
			return;
		}
		Benchmark bm_saveAll;
		logger.info("Saving server...");
		flushBuiltPlayers(built);
		saveGuildsMapAndKV();

		double duration_saveAll = bm_saveAll.duration();
		if (duration_saveAll > 1000.0) {
			logger.info("Server saved in {:.2f} seconds.", duration_saveAll / 1000.0);
		} else {
			logger.info("Server saved in {} milliseconds.", duration_saveAll);
		}
	});
}

void SaveManager::schedulePlayer(std::weak_ptr<Player> playerPtr) {
	// Runs on the dispatcher thread (called from game logic via savePlayer).
	auto playerToSave = playerPtr.lock();
	if (!playerToSave) {
		logger.debug("Skipping save for player because player is no longer online.");
		return;
	}

	// Disable save async if the config is set to false
	if (!g_configManager().getBoolean(TOGGLE_SAVE_ASYNC)) {
		if (g_game().getGameState() == GAME_STATE_NORMAL) {
			logger.debug("Saving player {}.", playerToSave->getName());
		}
		doSavePlayer(playerToSave);
		return;
	}

	const uint32_t guid = playerToSave->getGUID();

	// Build the save here, on the dispatcher — the owner of the player state — so
	// the read is consistent. No PlayerLock needed: the dispatcher is serial, so
	// nothing mutates the player during the build. This produces only SQL strings
	// (no DB round-trips, since the `save` flag is cached on the player).
	auto queries = IOLoginData::buildPlayerSave(playerToSave);
	if (!queries) {
		logger.error("Failed to build save for player {}.", playerToSave->getName());
		return;
	}

	// If a flush for this player is already running on a pool thread, queue the
	// freshly-built save to run after it finishes — running two concurrently
	// could let an older one overwrite newer data. We store the built SQL (not
	// just the guid) so the queued save survives even if the player object is
	// destroyed before the in-flight flush completes (e.g. logout). Overwriting a
	// previous pending entry is correct: only the latest state matters.
	if (m_flushInFlight.contains(guid)) {
		m_pendingFlushes[guid] = std::make_pair(playerToSave->getName(), std::move(*queries));
		return;
	}

	m_flushInFlight.insert(guid);
	logger.debug("Scheduling player {} for saving.", playerToSave->getName());
	threadPool.detach_task([this, guid, name = playerToSave->getName(), q = std::move(*queries)]() {
		// Pool thread: replay the captured SQL. Touches no player state.
		if (!IOLoginData::flushPlayerSave(q)) {
			logger.error("Failed to save player {}.", name);
		}
		g_dispatcher().addEvent([this, guid]() { onPlayerFlushed(guid); }, "SaveManager::onPlayerFlushed");
	});
}

void SaveManager::onPlayerFlushed(uint32_t guid) {
	// Dispatcher thread. If a save was queued while this flush ran, dispatch the
	// already-built queries directly — no player lookup, so the final save is
	// never dropped. The guid stays in m_flushInFlight until nothing is pending.
	auto it = m_pendingFlushes.find(guid);
	if (it == m_pendingFlushes.end()) {
		m_flushInFlight.erase(guid);
		return;
	}

	auto [name, queries] = std::move(it->second);
	m_pendingFlushes.erase(it);
	threadPool.detach_task([this, guid, name, q = std::move(queries)]() {
		if (!IOLoginData::flushPlayerSave(q)) {
			logger.error("Failed to save player {}.", name);
		}
		g_dispatcher().addEvent([this, guid]() { onPlayerFlushed(guid); }, "SaveManager::onPlayerFlushed");
	});
}

bool SaveManager::doSavePlayer(std::shared_ptr<Player> player) {
	// Synchronous build+flush on the calling thread. Used for the non-async path
	// and for offline/shutdown saves, where there is no concurrent mutation.
	if (!player) {
		logger.debug("Failed to save player because player is null.");
		return false;
	}

	Benchmark bm_savePlayer;
	Player::PlayerLock lock(player);
	if (g_game().getGameState() == GAME_STATE_NORMAL) {
		logger.debug("Saving player {}.", player->getName());
	}

	bool saveSuccess = IOLoginData::savePlayer(player);
	if (!saveSuccess) {
		logger.error("Failed to save player {}.", player->getName());
	}

	auto duration = bm_savePlayer.duration();
	logger.debug("Saving player {} took {} milliseconds.", player->getName(), duration);
	return saveSuccess;
}

bool SaveManager::savePlayer(std::shared_ptr<Player> player) {
	if (player->isOnline() && g_game().getGameState() != GAME_STATE_SHUTDOWN) {
		schedulePlayer(player);
		return true;
	}
	return doSavePlayer(player);
}

void SaveManager::saveGuild(std::shared_ptr<Guild> guild) {
	if (!guild) {
		logger.debug("Failed to save guild because guild is null.");
		return;
	}

	Benchmark bm_saveGuild;
	logger.debug("Saving guild {}...", guild->getName());
	IOGuild::saveGuild(guild);

	auto duration = bm_saveGuild.duration();
	logger.debug("Saving guild {} took {} milliseconds.", guild->getName(), duration);
}

void SaveManager::saveMap() {
	Benchmark bm_saveMap;
	logger.debug("Saving map...");
	bool saveSuccess = Map::save();
	if (!saveSuccess) {
		logger.error("Failed to save map.");
	}

	auto duration = bm_saveMap.duration();
	logger.debug("Map saved in {} milliseconds.", duration);
}

void SaveManager::saveKV() {
	Benchmark bm_saveKV;
	logger.debug("Saving key-value store...");
	bool saveSuccess = kv.saveAll();
	if (!saveSuccess) {
		logger.error("Failed to save key-value store.");
	}

	auto duration = bm_saveKV.duration();
	logger.debug("Key-value store saved in {} milliseconds.", duration);
}
