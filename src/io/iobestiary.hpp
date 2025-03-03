/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lib/di/soft_singleton.hpp"

#include "creatures/creatures_definitions.hpp"

class Player;
class Game;
class SoftSingleton;
class SoftSingletonGuard;
class MonsterType;
class Creature;

struct CombatDamage;
struct CombatParams;

struct PlayerCharmsByMonster {
	charmRune_t major = CHARM_NONE;
	charmRune_t minor = CHARM_NONE;
};

class Charm {
public:
	Charm() = default;
	Charm(std::string initname, charmRune_t initcharmRune_t, std::string initdescription, charmCategory_t initCategory, charm_t inittype, std::vector<uint16_t> initpoints, int32_t initbinary) :
		name(std::move(initname)), id(initcharmRune_t), description(std::move(initdescription)), category(initCategory), type(inittype), points(initpoints), binary(initbinary) { }
	virtual ~Charm() = default;

	std::string name;
	charmRune_t id = CHARM_NONE;
	std::string description;
	charmCategory_t category {};
	charm_t type {};
	std::vector<uint16_t> points;
	int32_t binary = 0;
	std::string cancelMessage;
	bool logMessage;

	CombatType_t damageType = COMBAT_NONE;
	uint16_t effect = 0;

	SoundEffect_t soundImpactEffect = SoundEffect_t::SILENCE;
	SoundEffect_t soundCastEffect = SoundEffect_t::SILENCE;

	float percent = 0;
	std::vector<double_t> chance;
};

class IOBestiary {
public:
	IOBestiary() = default;

	// non-copyable
	IOBestiary(const IOBestiary &) = delete;
	void operator=(const IOBestiary &) = delete;

	static IOBestiary &getInstance();

	std::shared_ptr<Charm> getBestiaryCharm(charmRune_t activeCharm, bool force = false) const;
	void addBestiaryKill(const std::shared_ptr<Player> &player, const std::shared_ptr<MonsterType> &mtype, uint32_t amount = 1);
	void parseOffensiveCharmCombatDamage(const std::shared_ptr<Charm> &charm, int32_t damage, CombatDamage &charmDamage, CombatParams &charmParams);
	void parseCharmCarnage(const std::shared_ptr<Charm> &charm, const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, int32_t damage);
	bool parseOffensiveCharmCombat(const std::shared_ptr<Charm> &charm, const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, CombatDamage &charmDamage, CombatParams &charmParams);
	bool parseDefensiveCharmCombat(const std::shared_ptr<Charm> &charm, const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, int32_t realDamage, bool checkArmor, CombatDamage &charmDamage, CombatParams &charmParams);
	bool parsePassiveCharmCombat(const std::shared_ptr<Charm> &charm, const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, int32_t realDamage, CombatDamage &charmDamage, CombatParams &charmParams);
	bool parseCharmCombat(const std::shared_ptr<Charm> &charm, const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, int32_t realDamage = 0, bool checkArmor = false);
	void addCharmPoints(const std::shared_ptr<Player> &player, uint32_t amount, bool negative = false);
	void addMinorCharmEchoes(const std::shared_ptr<Player> &player, uint32_t amount, bool negative = false);
	void sendBuyCharmRune(const std::shared_ptr<Player> &player, uint8_t action, charmRune_t charmId, uint16_t raceId);
	void setCharmRuneCreature(const std::shared_ptr<Player> &player, const std::shared_ptr<Charm> &charm, uint16_t raceid) const;
	void resetCharmRuneCreature(const std::shared_ptr<Player> &player, const std::shared_ptr<Charm> &charm) const;
	void resetAllCharmRuneCreatures(const std::shared_ptr<Player> &player) const;

	int8_t calculateDifficult(uint32_t chance) const;
	uint8_t getKillStatus(const std::shared_ptr<MonsterType> &mtype, uint32_t killAmount) const;

	uint16_t getBestiaryRaceUnlocked(const std::shared_ptr<Player> &player, BestiaryType_t race) const;

	int32_t bitToggle(int32_t input, const std::shared_ptr<Charm> &charm, bool on) const;

	bool hasCharmUnlockedRuneBit(const std::shared_ptr<Charm> &charm, int32_t input) const;

	std::list<charmRune_t> getCharmUsedRuneBitAll(const std::shared_ptr<Player> &player);
	std::vector<uint16_t> getBestiaryFinished(const std::shared_ptr<Player> &player) const;
	std::vector<uint16_t> getBestiaryStageTwo(const std::shared_ptr<Player> &player) const;

	PlayerCharmsByMonster getCharmFromTarget(const std::shared_ptr<Player> &player, const std::shared_ptr<MonsterType> &mtype, charmCategory_t category = CHARM_ALL);

	std::map<uint16_t, uint32_t> getBestiaryKillCountByMonsterIDs(const std::shared_ptr<Player> &player, const std::map<uint16_t, std::string> &mtype_list) const;
	std::map<uint8_t, int16_t> getMonsterElements(const std::shared_ptr<MonsterType> &mtype) const;
	std::map<uint16_t, std::string> findRaceByName(const std::string &race, bool Onlystring = true, BestiaryType_t raceNumber = BESTY_RACE_NONE) const;

private:
	static SoftSingleton instanceTracker;
	SoftSingletonGuard guard { instanceTracker };
};

constexpr auto g_iobestiary = IOBestiary::getInstance;
