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

/**
 * @brief Obtain the singleton GameFreeQuests instance managed by the dependency injector.
 *
 * @return GameFreeQuests& Reference to the singleton GameFreeQuests instance.
 */
GameFreeQuests &GameFreeQuests::getInstance() {
	return inject<GameFreeQuests>();
}

/**
 * @brief Initiates application of free quests for the given player when eligible.
 *
 * If the player has not already received the current free-quest stage and the
 * feature is enabled, the function notifies the player, grants citizen outfits,
 * and schedules a background task to apply per-quest storage values.
 *
 * @param player Shared pointer to the target player; must be non-null.
 * @return true if the process was started (or the player already had the current stage), false otherwise.
 */
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

/**
 * @brief Apply configured free-quest storage values to the player identified by the given GUID.
 *
 * Marks each configured quest storage on the player, updates the player's FreeQuests stage to the current stage,
 * sends the player a confirmation message, and logs the operation. If no player is found for the GUID, the function does nothing.
 *
 * @param playerId GUID of the player to apply free quests to.
 */
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

/**
 * @brief Indicates if the free quests feature is enabled in configuration.
 *
 * @return `true` if free quests are enabled via the `TOGGLE_FREE_QUEST` configuration toggle, `false` otherwise.
 */
bool GameFreeQuests::isEnabled() const {
	return g_configManager().getBoolean(TOGGLE_FREE_QUEST);
}

/**
 * @brief Gets the current free-quest stage.
 *
 * @return uint32_t The current free-quest stage number; 0 indicates no stage configured.
 */
uint32_t GameFreeQuests::getCurrentStage() const {
	return m_currentStage;
}

/**
 * @brief Retrieve the number of configured free quests.
 *
 * @return size_t The count of quest entries stored in the free-quests list.
 */
size_t GameFreeQuests::getQuestCount() const {
	return m_questData.size();
}

/**
 * @brief Reset the free-quest internal state.
 *
 * Clears all configured quest entries and sets the current free-quest stage to 0.
 */
void GameFreeQuests::clear() {
	m_questData.clear();
	m_currentStage = 0;
}

/**
 * @brief Validate a QuestData entry for use by the free-quests system.
 *
 * Checks that the entry has a non-empty storageName and a non-zero storage identifier.
 *
 * @param questData The quest data entry to validate.
 * @return `true` if `questData.storageName` is not empty and `questData.storage` is not zero, `false` otherwise.
 */
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

/**
 * @brief Adds a free-quest storage entry to the system.
 *
 * Initializes the free-quest system on first use (reads enabled toggle and current stage).
 *
 * @param storageName Human-readable identifier for the quest storage; must not be empty.
 * @param storage Numeric storage key used to persist the quest state; must be greater than 0.
 * @param storageValue Value to write into the player's storage to mark the quest as granted.
 * @return true if the quest entry was appended to the internal list; `false` if validation failed,
 *         the entry is a duplicate, or the free-quest system is disabled or configured with an invalid stage.
 */
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