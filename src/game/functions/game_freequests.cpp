/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "config/configmanager.hpp"
#include "creatures/players/player.hpp"
#include "game/functions/game_freequests.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "lib/di/container.hpp"

GameFreeQuests &GameFreeQuests::getInstance() {
	return inject<GameFreeQuests>();
}

bool GameFreeQuests::applyFreeQuestsToPlayer(std::shared_ptr<Player> player) {
	if (!player || !isEnabled()) {
		return false;
	}

	if (player->getStorageValue(FreeQuests) == m_currentStage) {
		return true;
	}

	player->sendTextMessage(MESSAGE_LOOK, "Adding free access quests to your character.");

	player->addOutfit(251, 0); // Male citizen
	player->addOutfit(252, 0); // Female citizen

	g_dispatcher().addEvent([this, playerId = player->getGUID()]() { applyQuestStoragesAsync(playerId); }, "GameFreeQuests::applyQuestStoragesAsync");

	return true;
}

void GameFreeQuests::applyQuestStoragesAsync(uint32_t playerId) {
	auto player = g_game().getPlayerByGUID(playerId);
	if (!player) {
		return;
	}

	for (const auto &quest : m_questData) {
		player->addStorageValue(quest.storage, quest.storageValue, true);
	}

	player->addStorageValue(FreeQuests, m_currentStage);
	player->sendTextMessage(MESSAGE_LOOK, "Free quests have been applied to your character!");

	g_logger().info("[{}] Applied {} free quests to player: {}", __FUNCTION__, m_questData.size(), player->getName());
}

bool GameFreeQuests::isEnabled() const {
	return g_configManager().getBoolean(TOGGLE_FREE_QUEST);
}

uint32_t GameFreeQuests::getCurrentStage() const {
	return m_currentStage;
}

size_t GameFreeQuests::getQuestCount() const {
	return m_questData.size();
}

void GameFreeQuests::clear() {
	m_questData.clear();
	m_currentStage = 0;
}

bool GameFreeQuests::isValidQuestData(const QuestData &questData) const {
	if (questData.storageName.empty()) {
		g_logger().warn("[{}] Invalid quest data: empty storageName, storage={}, storageValue={}", __FUNCTION__, questData.storage, questData.storageValue);
		return false;
	}

	if (questData.storage == 0) {
		g_logger().warn("[{}] Invalid quest data: storageName='{}', storage=0, storageValue={}", __FUNCTION__, questData.storageName, questData.storageValue);
		return false;
	}

	return true;
}

bool GameFreeQuests::addQuestData(const std::string &storageName, uint32_t storage, int32_t storageValue) {
	static bool systemInitialized = false;
	if (!systemInitialized) {
		if (!g_configManager().getBoolean(TOGGLE_FREE_QUEST)) {
			g_logger().info("[{}] Free quest system is disabled", __FUNCTION__);
			return false;
		}

		m_currentStage = g_configManager().getNumber(FREE_QUEST_STAGE);
		if (m_currentStage <= 0) {
			g_logger().warn("[{}] Invalid free quest stage: {}", __FUNCTION__, m_currentStage);
			return false;
		}

		systemInitialized = true;
	}

	// Validate parameters
	if (storageName.empty()) {
		g_logger().warn("[GameFreeQuests::addQuestData] - Storage name is empty");
		return false;
	}

	if (storage == 0) {
		g_logger().warn("[GameFreeQuests::addQuestData] - Storage ID cannot be 0 for quest: {}", storageName);
		return false;
	}

	for (const auto &existingQuest : m_questData) {
		if (existingQuest.storage == storage && existingQuest.storageValue == storageValue) {
			g_logger().warn("[GameFreeQuests::addQuestData] - Duplicate quest entry: {} (storage: {}, value: {}) already exists", storageName, storage, storageValue);
			return false;
		}
	}

	m_questData.emplace_back(storageName, storage, storageValue);
	g_logger().debug("[GameFreeQuests::addQuestData] - Added quest: {} (storage: {}, value: {})", storageName, storage, storageValue);

	return true;
}
