/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "io/iologindata.hpp"

class PropWriteStream;
class DBInsert;

class ILoginDataSaveRepository {
public:
	virtual ~ILoginDataSaveRepository() = default;

	virtual bool savePlayerFirst(const std::shared_ptr<Player> &player) = 0;
	virtual bool savePlayerStash(const std::shared_ptr<Player> &player) = 0;
	virtual bool savePlayerSpells(const std::shared_ptr<Player> &player) = 0;
	virtual bool savePlayerKills(const std::shared_ptr<Player> &player) = 0;
	virtual bool savePlayerBestiarySystem(const std::shared_ptr<Player> &player) = 0;
	virtual bool savePlayerItem(const std::shared_ptr<Player> &player) = 0;
	virtual bool savePlayerDepotItems(const std::shared_ptr<Player> &player) = 0;
	virtual bool saveRewardItems(const std::shared_ptr<Player> &player) = 0;
	virtual bool savePlayerInbox(const std::shared_ptr<Player> &player) = 0;
	virtual bool savePlayerPreyClass(const std::shared_ptr<Player> &player) = 0;
	virtual bool savePlayerTaskHuntingClass(const std::shared_ptr<Player> &player) = 0;
	virtual bool savePlayerForgeHistory(const std::shared_ptr<Player> &player) = 0;
	virtual bool savePlayerBosstiary(const std::shared_ptr<Player> &player) = 0;
	virtual bool savePlayerStorage(const std::shared_ptr<Player> &player) = 0;
};

ILoginDataSaveRepository &g_loginDataSaveRepository();
void setLoginDataSaveRepositoryForTest(ILoginDataSaveRepository *repository);
void resetLoginDataSaveRepositoryForTest();

class IOLoginDataSave : public IOLoginData {
public:
	static bool savePlayerFirst(const std::shared_ptr<Player> &player);
	static bool savePlayerStash(const std::shared_ptr<Player> &player);
	static bool savePlayerSpells(const std::shared_ptr<Player> &player);
	static bool savePlayerKills(const std::shared_ptr<Player> &player);
	static bool savePlayerBestiarySystem(const std::shared_ptr<Player> &player);
	static bool savePlayerItem(const std::shared_ptr<Player> &player);
	static bool savePlayerDepotItems(const std::shared_ptr<Player> &player);
	static bool saveRewardItems(const std::shared_ptr<Player> &player);
	static bool savePlayerInbox(const std::shared_ptr<Player> &player);
	static bool savePlayerPreyClass(const std::shared_ptr<Player> &player);
	static bool savePlayerTaskHuntingClass(const std::shared_ptr<Player> &player);
	static bool savePlayerForgeHistory(const std::shared_ptr<Player> &player);
	static bool savePlayerBosstiary(const std::shared_ptr<Player> &player);
	static bool savePlayerStorage(const std::shared_ptr<Player> &player);
};
