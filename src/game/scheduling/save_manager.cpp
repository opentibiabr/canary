#include "pch.hpp"

#include "game/game.hpp"
#include "game/scheduling/save_manager.hpp"
#include "io/iologindata.hpp"

SaveManager::SaveManager(ThreadPool &threadPool, KVStore &kvStore, Logger &logger, Game &game) :
	threadPool(threadPool), kv(kvStore), logger(logger), game(game) { }

SaveManager &SaveManager::getInstance() {
	return inject<SaveManager>();
}

void SaveManager::saveAll() {
	Benchmark bm_saveAll;
	logger.info("Saving server...");
	const auto players = game.getPlayers();

	for (const auto &[_, player] : players) {
		player->loginPosition = player->getPosition();
		doSavePlayer(player);
	}

	auto guilds = game.getGuilds();
	for (const auto &[_, guild] : guilds) {
		saveGuild(guild);
	}

	saveMap();
	saveKV();
	logger.info("Server saved in {} milliseconds.", bm_saveAll.duration());
}

void SaveManager::scheduleAll() {
	auto scheduledAt = std::chrono::steady_clock::now();
	m_scheduledAt = scheduledAt;

	threadPool.addLoad([this, scheduledAt]() {
		if (m_scheduledAt.load() != scheduledAt) {
			logger.warn("Skipping save for server because another save has been scheduled.");
			return;
		}
		saveAll();
	});
}

void SaveManager::schedulePlayer(std::weak_ptr<Player> playerPtr) {
	auto playerToSave = playerPtr.lock();
	if (!playerToSave) {
		logger.debug("Skipping save for player because player is no longer online.");
		return;
	}
	logger.debug("Scheduling player {} for saving.", playerToSave->getName());
	auto scheduledAt = std::chrono::steady_clock::now();
	m_playerMap[playerToSave->getGUID()] = scheduledAt;
	threadPool.addLoad([this, playerPtr, scheduledAt]() {
		auto player = playerPtr.lock();
		if (!player) {
			logger.debug("Skipping save for player because player is no longer online.");
			return;
		}
		if (m_playerMap[player->getGUID()] != scheduledAt) {
			logger.warn("Skipping save for player because another save has been scheduled.");
			return;
		}
		doSavePlayer(player);
	});
}

bool SaveManager::doSavePlayer(std::shared_ptr<Player> player) {
	if (!player) {
		logger.debug("Failed to save player because player is null.");
		return false;
	}
	Benchmark bm_savePlayer;
	Player::PlayerLock lock(player);
	m_playerMap.erase(player->getGUID());
	logger.debug("Saving player {}...", player->getName());
	bool saveSuccess = IOLoginData::savePlayer(player);
	if (!saveSuccess) {
		logger.error("Failed to save player {}.", player->getName());
	}
	auto duration = bm_savePlayer.duration();
	if (duration > 100) {
		logger.warn("Saving player {} took {} milliseconds.", player->getName(), duration);
	} else {
		logger.debug("Saving player {} took {} milliseconds.", player->getName(), duration);
	}
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
	logger.debug("Saving map...");
	bool saveSuccess = Map::save();
	if (!saveSuccess) {
		logger.error("Failed to save map.");
	}
	auto duration = bm_saveMap.duration();
	if (duration > 100) {
		logger.warn("Map saved in {} milliseconds.", bm_saveMap.duration());
	} else {
		logger.debug("Map saved in {} milliseconds.", bm_saveMap.duration());
	}
}

void SaveManager::saveKV() {
	Benchmark bm_saveKV;
	logger.debug("Saving key-value store...");
	bool saveSuccess = kv.saveAll();
	if (!saveSuccess) {
		logger.error("Failed to save key-value store.");
	}
	auto duration = bm_saveKV.duration();
	if (duration > 100) {
		logger.warn("Key-value store saved in {} milliseconds.", bm_saveKV.duration());
	} else {
		logger.debug("Key-value store saved in {} milliseconds.", bm_saveKV.duration());
	}
}
