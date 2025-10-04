/**
* Canary - A free and open-source MMORPG server emulator
* Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
* Repository: https://github.com/opentibiabr/canary
* License: https://github.com/opentibiabr/canary/blob/main/LICENSE
* Contributors: https://github.com/opentibiabr/canary/graphs/contributors
* Website: https://docs.opentibiabr.com/
*/
#include "pch.hpp"

#include <boost/ut.hpp>

#include <string>
#include <unordered_map>

#include "io/functions/iologindata_load_player.hpp"
#include "io/functions/iologindata_save_player.hpp"

using namespace boost::ut;

namespace {
	struct StubLoginDataLoadRepository final : ILoginDataLoadRepository {
		bool preLoadResult = true;
		bool basicInfoResult = true;
		std::string lastPreLoadName;
		std::shared_ptr<Player> lastPreLoadPlayer;
		DBResult_ptr lastBasicInfoResult;
		std::unordered_map<std::string, uint32_t> callCount;

		bool preLoadPlayer(const std::shared_ptr<Player> &player, const std::string &name) override {
			++callCount["preLoadPlayer"];
			lastPreLoadPlayer = player;
			lastPreLoadName = name;
			return preLoadResult;
		}

		bool loadPlayerBasicInfo(const std::shared_ptr<Player> &player, const DBResult_ptr &result) override {
			++callCount["loadPlayerBasicInfo"];
			lastPreLoadPlayer = player;
			lastBasicInfoResult = result;
			return basicInfoResult;
		}

		void loadPlayerExperience(const std::shared_ptr<Player> &, const DBResult_ptr &) override {
			++callCount["loadPlayerExperience"];
		}

		void loadPlayerBlessings(const std::shared_ptr<Player> &, const DBResult_ptr &) override {
			++callCount["loadPlayerBlessings"];
		}

		void loadPlayerConditions(const std::shared_ptr<Player> &, const DBResult_ptr &) override {
			++callCount["loadPlayerConditions"];
		}

		void loadPlayerAnimusMastery(const std::shared_ptr<Player> &, const DBResult_ptr &) override {
			++callCount["loadPlayerAnimusMastery"];
		}

		void loadPlayerDefaultOutfit(const std::shared_ptr<Player> &, const DBResult_ptr &) override {
			++callCount["loadPlayerDefaultOutfit"];
		}

		void loadPlayerSkullSystem(const std::shared_ptr<Player> &, const DBResult_ptr &) override {
			++callCount["loadPlayerSkullSystem"];
		}

		void loadPlayerSkill(const std::shared_ptr<Player> &, const DBResult_ptr &) override {
			++callCount["loadPlayerSkill"];
		}

		void loadPlayerKills(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerKills"];
		}

		void loadPlayerGuild(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerGuild"];
		}

		void loadPlayerStashItems(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerStashItems"];
		}

		void loadPlayerBestiaryCharms(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerBestiaryCharms"];
		}

		void loadPlayerInstantSpellList(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerInstantSpellList"];
		}

		void loadPlayerInventoryItems(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerInventoryItems"];
		}

		void loadPlayerStoreInbox(const std::shared_ptr<Player> &) override {
			++callCount["loadPlayerStoreInbox"];
		}

		void loadPlayerDepotItems(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerDepotItems"];
		}

		void loadRewardItems(const std::shared_ptr<Player> &) override {
			++callCount["loadRewardItems"];
		}

		void loadPlayerInboxItems(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerInboxItems"];
		}

		void loadPlayerStorageMap(const std::shared_ptr<Player> &) override {
			++callCount["loadPlayerStorageMap"];
		}

		void loadPlayerVip(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerVip"];
		}

		void loadPlayerPreyClass(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerPreyClass"];
		}

		void loadPlayerTaskHuntingClass(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerTaskHuntingClass"];
		}

		void loadPlayerForgeHistory(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerForgeHistory"];
		}

		void loadPlayerBosstiary(const std::shared_ptr<Player> &, DBResult_ptr) override {
			++callCount["loadPlayerBosstiary"];
		}

		void loadPlayerInitializeSystem(const std::shared_ptr<Player> &) override {
			++callCount["loadPlayerInitializeSystem"];
		}

		void loadPlayerUpdateSystem(const std::shared_ptr<Player> &) override {
			++callCount["loadPlayerUpdateSystem"];
		}
	};

	struct StubLoginDataSaveRepository final : ILoginDataSaveRepository {
		std::unordered_map<std::string, uint32_t> callCount;
		std::unordered_map<std::string, bool> returnValues;

		bool call(const std::string &name) {
			++callCount[name];
			if (const auto it = returnValues.find(name); it != returnValues.end()) {
				return it->second;
			}
			return true;
		}

		bool savePlayerFirst(const std::shared_ptr<Player> &) override {
			return call("savePlayerFirst");
		}

		bool savePlayerStash(const std::shared_ptr<Player> &) override {
			return call("savePlayerStash");
		}

		bool savePlayerSpells(const std::shared_ptr<Player> &) override {
			return call("savePlayerSpells");
		}

		bool savePlayerKills(const std::shared_ptr<Player> &) override {
			return call("savePlayerKills");
		}

		bool savePlayerBestiarySystem(const std::shared_ptr<Player> &) override {
			return call("savePlayerBestiarySystem");
		}

		bool savePlayerItem(const std::shared_ptr<Player> &) override {
			return call("savePlayerItem");
		}

		bool savePlayerDepotItems(const std::shared_ptr<Player> &) override {
			return call("savePlayerDepotItems");
		}

		bool saveRewardItems(const std::shared_ptr<Player> &) override {
			return call("saveRewardItems");
		}

		bool savePlayerInbox(const std::shared_ptr<Player> &) override {
			return call("savePlayerInbox");
		}

		bool savePlayerPreyClass(const std::shared_ptr<Player> &) override {
			return call("savePlayerPreyClass");
		}

		bool savePlayerTaskHuntingClass(const std::shared_ptr<Player> &) override {
			return call("savePlayerTaskHuntingClass");
		}

		bool savePlayerForgeHistory(const std::shared_ptr<Player> &) override {
			return call("savePlayerForgeHistory");
		}

		bool savePlayerBosstiary(const std::shared_ptr<Player> &) override {
			return call("savePlayerBosstiary");
		}

		bool savePlayerStorage(const std::shared_ptr<Player> &) override {
			return call("savePlayerStorage");
		}
	};

	class RepositoryOverrideGuard final {
		public:
		RepositoryOverrideGuard(ILoginDataLoadRepository *loadRepo, ILoginDataSaveRepository *saveRepo) {
			if (loadRepo) {
				setLoginDataLoadRepositoryForTest(loadRepo);
				loadConfigured = true;
			}
			if (saveRepo) {
				setLoginDataSaveRepositoryForTest(saveRepo);
				saveConfigured = true;
			}
		}

		~RepositoryOverrideGuard() {
			if (loadConfigured) {
				resetLoginDataLoadRepositoryForTest();
			}
			if (saveConfigured) {
				resetLoginDataSaveRepositoryForTest();
			}
		}

		private:
		bool loadConfigured = false;
		bool saveConfigured = false;
	};
}

suite<"login_data_repository"> loginDataRepositorySuite = [] {
	test("IOLoginDataLoad forwards to repository") = [] {
		StubLoginDataLoadRepository loadRepository;
		loadRepository.preLoadResult = false;
		loadRepository.basicInfoResult = true;
		RepositoryOverrideGuard guard { &loadRepository, nullptr };

		std::shared_ptr<Player> player;
		DBResult_ptr result;

		expect(!IOLoginDataLoad::preLoadPlayer(player, "test-player"));
		expect(eq(loadRepository.callCount["preLoadPlayer"], 1_u));
		expect(eq(loadRepository.lastPreLoadName, std::string { "test-player" }));

		expect(IOLoginDataLoad::loadPlayerBasicInfo(player, result));
		expect(eq(loadRepository.callCount["loadPlayerBasicInfo"], 1_u));

		IOLoginDataLoad::loadPlayerExperience(player, result);
		expect(eq(loadRepository.callCount["loadPlayerExperience"], 1_u));

		IOLoginDataLoad::loadPlayerBlessings(player, result);
		expect(eq(loadRepository.callCount["loadPlayerBlessings"], 1_u));

		IOLoginDataLoad::loadPlayerConditions(player, result);
		expect(eq(loadRepository.callCount["loadPlayerConditions"], 1_u));

		IOLoginDataLoad::loadPlayerAnimusMastery(player, result);
		expect(eq(loadRepository.callCount["loadPlayerAnimusMastery"], 1_u));

		IOLoginDataLoad::loadPlayerDefaultOutfit(player, result);
		expect(eq(loadRepository.callCount["loadPlayerDefaultOutfit"], 1_u));

		IOLoginDataLoad::loadPlayerSkullSystem(player, result);
		expect(eq(loadRepository.callCount["loadPlayerSkullSystem"], 1_u));

		IOLoginDataLoad::loadPlayerSkill(player, result);
		expect(eq(loadRepository.callCount["loadPlayerSkill"], 1_u));

		IOLoginDataLoad::loadPlayerKills(player, result);
		expect(eq(loadRepository.callCount["loadPlayerKills"], 1_u));

		IOLoginDataLoad::loadPlayerGuild(player, result);
		expect(eq(loadRepository.callCount["loadPlayerGuild"], 1_u));

		IOLoginDataLoad::loadPlayerStashItems(player, result);
		expect(eq(loadRepository.callCount["loadPlayerStashItems"], 1_u));

		IOLoginDataLoad::loadPlayerBestiaryCharms(player, result);
		expect(eq(loadRepository.callCount["loadPlayerBestiaryCharms"], 1_u));

		IOLoginDataLoad::loadPlayerInstantSpellList(player, result);
		expect(eq(loadRepository.callCount["loadPlayerInstantSpellList"], 1_u));

		IOLoginDataLoad::loadPlayerInventoryItems(player, result);
		expect(eq(loadRepository.callCount["loadPlayerInventoryItems"], 1_u));

		IOLoginDataLoad::loadPlayerStoreInbox(player);
		expect(eq(loadRepository.callCount["loadPlayerStoreInbox"], 1_u));

		IOLoginDataLoad::loadPlayerDepotItems(player, result);
		expect(eq(loadRepository.callCount["loadPlayerDepotItems"], 1_u));

		IOLoginDataLoad::loadRewardItems(player);
		expect(eq(loadRepository.callCount["loadRewardItems"], 1_u));

		IOLoginDataLoad::loadPlayerInboxItems(player, result);
		expect(eq(loadRepository.callCount["loadPlayerInboxItems"], 1_u));

		IOLoginDataLoad::loadPlayerStorageMap(player);
		expect(eq(loadRepository.callCount["loadPlayerStorageMap"], 1_u));

		IOLoginDataLoad::loadPlayerVip(player, result);
		expect(eq(loadRepository.callCount["loadPlayerVip"], 1_u));

		IOLoginDataLoad::loadPlayerPreyClass(player, result);
		expect(eq(loadRepository.callCount["loadPlayerPreyClass"], 1_u));

		IOLoginDataLoad::loadPlayerTaskHuntingClass(player, result);
		expect(eq(loadRepository.callCount["loadPlayerTaskHuntingClass"], 1_u));

		IOLoginDataLoad::loadPlayerForgeHistory(player, result);
		expect(eq(loadRepository.callCount["loadPlayerForgeHistory"], 1_u));

		IOLoginDataLoad::loadPlayerBosstiary(player, result);
		expect(eq(loadRepository.callCount["loadPlayerBosstiary"], 1_u));

		IOLoginDataLoad::loadPlayerInitializeSystem(player);
		expect(eq(loadRepository.callCount["loadPlayerInitializeSystem"], 1_u));

		IOLoginDataLoad::loadPlayerUpdateSystem(player);
		expect(eq(loadRepository.callCount["loadPlayerUpdateSystem"], 1_u));
	};

	test("IOLoginDataSave forwards to repository") = [] {
		StubLoginDataSaveRepository saveRepository;
		saveRepository.returnValues["savePlayerFirst"] = false;
		RepositoryOverrideGuard guard { nullptr, &saveRepository };

		std::shared_ptr<Player> player;

		expect(!IOLoginDataSave::savePlayerFirst(player));
		expect(eq(saveRepository.callCount["savePlayerFirst"], 1_u));

		expect(IOLoginDataSave::savePlayerStash(player));
		expect(eq(saveRepository.callCount["savePlayerStash"], 1_u));

		expect(IOLoginDataSave::savePlayerSpells(player));
		expect(eq(saveRepository.callCount["savePlayerSpells"], 1_u));

		expect(IOLoginDataSave::savePlayerKills(player));
		expect(eq(saveRepository.callCount["savePlayerKills"], 1_u));

		expect(IOLoginDataSave::savePlayerBestiarySystem(player));
		expect(eq(saveRepository.callCount["savePlayerBestiarySystem"], 1_u));

		expect(IOLoginDataSave::savePlayerItem(player));
		expect(eq(saveRepository.callCount["savePlayerItem"], 1_u));

		expect(IOLoginDataSave::savePlayerDepotItems(player));
		expect(eq(saveRepository.callCount["savePlayerDepotItems"], 1_u));

		expect(IOLoginDataSave::saveRewardItems(player));
		expect(eq(saveRepository.callCount["saveRewardItems"], 1_u));

		expect(IOLoginDataSave::savePlayerInbox(player));
		expect(eq(saveRepository.callCount["savePlayerInbox"], 1_u));

		expect(IOLoginDataSave::savePlayerPreyClass(player));
		expect(eq(saveRepository.callCount["savePlayerPreyClass"], 1_u));

		expect(IOLoginDataSave::savePlayerTaskHuntingClass(player));
		expect(eq(saveRepository.callCount["savePlayerTaskHuntingClass"], 1_u));

		expect(IOLoginDataSave::savePlayerForgeHistory(player));
		expect(eq(saveRepository.callCount["savePlayerForgeHistory"], 1_u));

		expect(IOLoginDataSave::savePlayerBosstiary(player));
		expect(eq(saveRepository.callCount["savePlayerBosstiary"], 1_u));

		expect(IOLoginDataSave::savePlayerStorage(player));
		expect(eq(saveRepository.callCount["savePlayerStorage"], 1_u));
	};
};
