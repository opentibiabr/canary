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

	QuestData(const std::string &name, uint32_t storageId, int32_t value) :
		storageName(name), storage(storageId), storageValue(value) { }
};

class GameFreeQuests {
public:
	static GameFreeQuests &getInstance();

	GameFreeQuests() = default;
	~GameFreeQuests() = default;

	// Non-copyable
	GameFreeQuests(const GameFreeQuests &) = delete;
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
