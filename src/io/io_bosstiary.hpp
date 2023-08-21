/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_IO_IO_BOSSTIARY_HPP_
#define SRC_IO_IO_BOSSTIARY_HPP_

#include <map>
#include <string>
#include <vector>

enum class BosstiaryRarity_t : uint8_t {
	RARITY_BANE = 0,
	RARITY_ARCHFOE = 1,
	RARITY_NEMESIS = 2,

	// Only for server reading, not send to the client
	BOSS_INVALID = 10,
};

struct LevelInfo {
		uint32_t kills;
		uint16_t points;
};

class MonsterType;
class Player;

class IOBosstiary {
	public:
		IOBosstiary() = default;

		// Non copyable
		IOBosstiary(const IOBosstiary &) = delete;
		void operator=(const IOBosstiary &) = delete;

		static IOBosstiary &getInstance() {
			return inject<IOBosstiary>();
		}

		void loadBoostedBoss();

		void addBosstiaryMonster(uint16_t raceId, const std::string &name);
		const phmap::btree_map<uint16_t, std::string> &getBosstiaryMap() const;

		const phmap::btree_map<BosstiaryRarity_t, std::vector<LevelInfo>> levelInfos = {
			{ BosstiaryRarity_t::RARITY_BANE, { { 25, 5 }, { 100, 15 }, { 300, 30 } } },
			{ BosstiaryRarity_t::RARITY_ARCHFOE, { { 5, 10 }, { 20, 30 }, { 60, 60 } } },
			{ BosstiaryRarity_t::RARITY_NEMESIS, { { 1, 10 }, { 3, 30 }, { 5, 60 } } }
		};

		void setBossBoostedName(const std::string_view &name);
		std::string getBoostedBossName() const;
		void setBossBoostedId(uint16_t raceId);
		uint16_t getBoostedBossId() const;
		std::shared_ptr<MonsterType> getMonsterTypeByBossRaceId(uint16_t raceId) const;

		void addBosstiaryKill(Player* player, const std::shared_ptr<MonsterType> &mtype, uint32_t amount = 1) const;
		uint16_t calculateLootBonus(uint32_t bossPoints) const;
		uint32_t calculateBossPoints(uint16_t lootBonus) const;
		phmap::parallel_flat_hash_set<uint16_t> getBosstiaryFinished(const Player* player, uint8_t level = 1) const;
		uint8_t getBossCurrentLevel(const Player* player, uint16_t bossId) const;
		uint32_t calculteRemoveBoss(uint8_t removeTimes) const;
		std::vector<uint16_t> getBosstiaryCooldownRaceId(const Player* player) const;
		const std::vector<LevelInfo> &getBossRaceKillStages(BosstiaryRarity_t race) const;

	private:
		phmap::btree_map<uint16_t, std::string> bosstiaryMap;
		std::string boostedBoss;
		uint16_t boostedBossId = 0;
};

constexpr auto g_ioBosstiary = IOBosstiary::getInstance;

#endif // SRC_IO_IO_BOSSTIARY_HPP_
