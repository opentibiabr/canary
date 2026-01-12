/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

/**
 * @class GameFreeQuests
 * @brief Manages free quests for players.
 *
 * This class handles the application of free quests to players, including
 * loading quest data, applying quest storages, and managing the current stage
 * of free quests.
 *
 * The class is implemented as a singleton and provides thread-safe
 * asynchronous application of quest storages to players.
 */

#pragma once

struct QuestData {
	std::string storageName;
	uint32_t storage;
	int32_t storageValue;

	/**
		 * @brief Initializes a QuestData entry with the specified storage name, identifier, and value.
		 *
		 * @param name Human-readable name for the quest storage.
		 * @param storageId Numeric identifier for the storage key.
		 * @param value Integer value to apply to the storage.
		 */
		QuestData(const std::string &name, uint32_t storageId, int32_t value) :
		storageName(name), storage(storageId), storageValue(value) { }
};

class GameFreeQuests {
public:
	static GameFreeQuests &getInstance();

	/**
 * @brief Constructs a GameFreeQuests instance.
 *
 * Initializes the object with default internal state suitable for the singleton accessor.
 */
GameFreeQuests() = default;
	/**
 * @brief Destroys the GameFreeQuests singleton and releases any owned resources.
 *
 * Performs cleanup for GameFreeQuests state when the instance is destroyed.
 */
~GameFreeQuests() = default;

	/**
 * @brief Deleted copy constructor to prevent copying of the singleton.
 *
 * Enforces non-copyable semantics for GameFreeQuests so the singleton instance cannot be duplicated.
 */
	GameFreeQuests(const GameFreeQuests &) = delete;
	/**
 * @brief Deleted copy assignment operator to prevent assigning one GameFreeQuests instance to another and enforce non-copyable (singleton) semantics.
 */
GameFreeQuests &operator=(const GameFreeQuests &) = delete;

	bool applyFreeQuestsToPlayer(std::shared_ptr<Player> player);
	bool addQuestData(const std::string &storageName, uint32_t storage, int32_t storageValue);
	bool isEnabled() const;
	uint32_t getCurrentStage() const;
	size_t getQuestCount() const;
	void clear();

private:
	std::vector<QuestData> m_questData;
	uint32_t m_currentStage = 0;
	uint16_t FreeQuests = 30057;

	void applyQuestStoragesAsync(uint32_t playerId);
	bool isValidQuestData(const QuestData &questData) const;
};

constexpr auto g_gameFreeQuests = &GameFreeQuests::getInstance;