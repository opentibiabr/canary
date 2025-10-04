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

class Player;
class DBResult;
using DBResult_ptr = std::shared_ptr<DBResult>;

class ILoginDataLoadRepository {
public:
	virtual ~ILoginDataLoadRepository() = default;

	virtual bool preLoadPlayer(const std::shared_ptr<Player> &player, const std::string &name) = 0;
	virtual bool loadPlayerBasicInfo(const std::shared_ptr<Player> &player, const DBResult_ptr &result) = 0;
	virtual void loadPlayerExperience(const std::shared_ptr<Player> &player, const DBResult_ptr &result) = 0;
	virtual void loadPlayerBlessings(const std::shared_ptr<Player> &player, const DBResult_ptr &result) = 0;
	virtual void loadPlayerConditions(const std::shared_ptr<Player> &player, const DBResult_ptr &result) = 0;
	virtual void loadPlayerAnimusMastery(const std::shared_ptr<Player> &player, const DBResult_ptr &result) = 0;
	virtual void loadPlayerDefaultOutfit(const std::shared_ptr<Player> &player, const DBResult_ptr &result) = 0;
	virtual void loadPlayerSkullSystem(const std::shared_ptr<Player> &player, const DBResult_ptr &result) = 0;
	virtual void loadPlayerSkill(const std::shared_ptr<Player> &player, const DBResult_ptr &result) = 0;
	virtual void loadPlayerKills(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadPlayerGuild(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadPlayerStashItems(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadPlayerBestiaryCharms(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadPlayerInstantSpellList(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadPlayerInventoryItems(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadPlayerStoreInbox(const std::shared_ptr<Player> &player) = 0;
	virtual void loadPlayerDepotItems(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadRewardItems(const std::shared_ptr<Player> &player) = 0;
	virtual void loadPlayerInboxItems(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadPlayerStorageMap(const std::shared_ptr<Player> &player) = 0;
	virtual void loadPlayerVip(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadPlayerPreyClass(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadPlayerTaskHuntingClass(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadPlayerForgeHistory(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadPlayerBosstiary(const std::shared_ptr<Player> &player, DBResult_ptr result) = 0;
	virtual void loadPlayerInitializeSystem(const std::shared_ptr<Player> &player) = 0;
	virtual void loadPlayerUpdateSystem(const std::shared_ptr<Player> &player) = 0;
};

ILoginDataLoadRepository &g_loginDataLoadRepository();
void setLoginDataLoadRepositoryForTest(ILoginDataLoadRepository *repository);
void resetLoginDataLoadRepositoryForTest();

class IOLoginDataLoad : public IOLoginData {
public:
	static bool preLoadPlayer(const std::shared_ptr<Player> &player, const std::string &name);
	static bool loadPlayerBasicInfo(const std::shared_ptr<Player> &player, const DBResult_ptr &result);
	static void loadPlayerExperience(const std::shared_ptr<Player> &player, const DBResult_ptr &result);
	static void loadPlayerBlessings(const std::shared_ptr<Player> &player, const DBResult_ptr &result);
	static void loadPlayerConditions(const std::shared_ptr<Player> &player, const DBResult_ptr &result);
	static void loadPlayerAnimusMastery(const std::shared_ptr<Player> &player, const DBResult_ptr &result);
	static void loadPlayerDefaultOutfit(const std::shared_ptr<Player> &player, const DBResult_ptr &result);
	static void loadPlayerSkullSystem(const std::shared_ptr<Player> &player, const DBResult_ptr &result);
	static void loadPlayerSkill(const std::shared_ptr<Player> &player, const DBResult_ptr &result);
	static void loadPlayerKills(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadPlayerGuild(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadPlayerStashItems(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadPlayerBestiaryCharms(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadPlayerInstantSpellList(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadPlayerInventoryItems(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadPlayerStoreInbox(const std::shared_ptr<Player> &player);
	static void loadPlayerDepotItems(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadRewardItems(const std::shared_ptr<Player> &player);
	static void loadPlayerInboxItems(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadPlayerStorageMap(const std::shared_ptr<Player> &player);
	static void loadPlayerVip(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadPlayerPreyClass(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadPlayerTaskHuntingClass(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadPlayerForgeHistory(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadPlayerBosstiary(const std::shared_ptr<Player> &player, DBResult_ptr result);
	static void loadPlayerInitializeSystem(const std::shared_ptr<Player> &player);
	static void loadPlayerUpdateSystem(const std::shared_ptr<Player> &player);
};
