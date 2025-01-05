/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/save_manager.hpp"

#include "config/configmanager.hpp"
#include "creatures/players/grouping/guild.hpp"
#include "game/game.hpp"
#include "io/ioguild.hpp"
#include "io/iologindata.hpp"
#include "kv/kv.hpp"
#include "lib/di/container.hpp"
#include "game/scheduling/task.hpp"

SaveManager::SaveManager(ThreadPool &threadPool, KVStore &kvStore, Logger &logger, Game &game) :
	threadPool(threadPool), kv(kvStore), logger(logger), game(game) {
}

SaveManager &SaveManager::getInstance() {
	return inject<SaveManager>();
}

void SaveManager::saveAll() {
	Benchmark bm_saveAll;
	logger.info("Saving server...");
	Benchmark bm_players;
	const auto &players = game.getPlayers();
	std::vector<std::future<void>> futures;
	const auto asyncSave = g_configManager().getBoolean(TOGGLE_SAVE_ASYNC);
	logger.info("Saving {} players... (Async: {})", players.size(), asyncSave ? "Enabled" : "Disabled");
	for (const auto &[_, player] : players) {
		player->loginPosition = player->getPosition();

		auto promise = std::make_shared<std::promise<void>>();
		futures.push_back(promise->get_future());

		threadPool.detach_task([this, player, promise]() {
			try {
				doSavePlayer(player);
				promise->set_value();
			} catch (const std::exception &e) {
				logger.error("Exception occurred while saving player {}: {}", player->getName(), e.what());
				promise->set_exception(std::current_exception());
			} catch (...) {
				logger.error("Unknown error occurred while saving player {}.", player->getName());
				promise->set_exception(std::current_exception());
			}
		});
	}

	for (auto &future : futures) {
		try {
			future.get();
		} catch (const std::exception &e) {
			logger.error("Failed to save player due to exception: {}", e.what());
		}
	}

	double duration_players = bm_players.duration();
	if (duration_players > 1000.0) {
		logger.info("Players saved in {:.2f} seconds.", duration_players / 1000.0);
	} else {
		logger.info("Players saved in {} milliseconds.", duration_players);
	}

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
	saveAll();
}

void SaveManager::schedulePlayer(std::weak_ptr<Player> playerPtr) {
	auto playerToSave = playerPtr.lock();
	if (!playerToSave) {
		logger.debug("Skipping save for player because player is no longer online.");
		return;
	}

	doSavePlayer(playerToSave);
}

bool SaveManager::doSavePlayer(std::shared_ptr<Player> player) {
	if (!player) {
		logger.debug("Failed to save player because player is null.");
		return false;
	}

	Benchmark bm_savePlayer;
	Player::PlayerLock lock(player);
	m_playerMap.erase(player->getGUID());

	bool saveSuccess = IOLoginData::savePlayer(player);
	if (!saveSuccess) {
		logger.error("Failed to save player {}.", player->getName());
	}

	auto duration = bm_savePlayer.duration();
	logger.debug("Saving player {} took {} milliseconds.", player->getName(), duration);
	return saveSuccess;
}

bool SaveManager::savePlayer(std::shared_ptr<Player> player) {
	if (player->isOnline()) {
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
	if (duration > 100) {
		logger.warn("Saving guild {} took {} milliseconds.", guild->getName(), duration);
	} else {
		logger.debug("Saving guild {} took {} milliseconds.", guild->getName(), duration);
	}
}

void SaveManager::saveMap() {
	Benchmark bm_saveMap;
	logger.info("Saving map...");
	bool saveSuccess = Map::save();
	if (!saveSuccess) {
		logger.error("Failed to save map.");
	}

	double duration_map = bm_saveMap.duration();
	if (duration_map > 1000.0) {
		logger.info("Map saved in {:.2f} seconds.", duration_map / 1000.0);
	} else {
		logger.info("Map saved in {} milliseconds.", duration_map);
	}
}

void SaveManager::saveKV() {
	Benchmark bm_saveKV;
	logger.info("Saving key-value store...");
	bool saveSuccess = kv.saveAll();
	if (!saveSuccess) {
		logger.error("Failed to save key-value store.");
	}

	double duration_kv = bm_saveKV.duration();
	if (duration_kv > 1000.0) {
		logger.info("KV store saved in {:.2f} seconds.", duration_kv / 1000.0);
	} else {
		logger.info("KV store saved in {} milliseconds.", duration_kv);
	}
}
