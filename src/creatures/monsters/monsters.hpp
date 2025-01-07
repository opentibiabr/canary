/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/creatures_definitions.hpp"
#include "game/game_definitions.hpp"
#include "io/io_bosstiary.hpp"
#include "utils/utils_definitions.hpp"

class LuaScriptInterface;
class ConditionDamage;

class Loot {
public:
	Loot() = default;

	// non-copyable
	Loot(const Loot &) = delete;
	Loot &operator=(const Loot &) = delete;

	LootBlock lootBlock;
};

class BaseSpell;
struct spellBlock_t {
	std::shared_ptr<BaseSpell> spell = nullptr;
	uint32_t chance = 100;
	uint32_t speed = 2000;
	uint32_t range = 0;
	int32_t minCombatValue = 0;
	int32_t maxCombatValue = 0;
	bool combatSpell = false;
	bool isMelee = false;

	SoundEffect_t soundImpactEffect = SoundEffect_t::SILENCE;
	SoundEffect_t soundCastEffect = SoundEffect_t::SILENCE;
};

class MonsterType {
	struct MonsterInfo {
		LuaScriptInterface* scriptInterface {};

		std::map<CombatType_t, int32_t> elementMap;
		std::map<CombatType_t, int32_t> reflectMap;
		std::map<CombatType_t, int32_t> healingMap;

		std::vector<voiceBlock_t> voiceVector;

		std::vector<LootBlock> lootItems;
		// We need to keep the order of scripts, so we use a set isntead of an unordered_set
		std::set<std::string> scripts;
		std::vector<spellBlock_t> attackSpells;
		std::vector<spellBlock_t> defenseSpells;
		std::vector<summonBlock_t> summons;

		Skulls_t skull = SKULL_NONE;
		Outfit_t outfit = {};
		RaceType_t race = RACE_BLOOD;
		RespawnType respawnType = {};

		LightInfo light = {};
		uint16_t lookcorpse = 0;
		uint16_t baseSpeed = 110;

		uint64_t experience = 0;

		uint32_t manaCost = 0;
		uint32_t yellChance = 0;
		uint32_t yellSpeedTicks = 0;
		uint32_t staticAttackChance = 95;
		uint32_t maxSummons = 0;
		uint32_t changeTargetSpeed = 0;

		uint32_t soulCore = 0;

		std::bitset<ConditionType_t::CONDITION_COUNT> m_conditionImmunities;
		std::bitset<CombatType_t::COMBAT_COUNT> m_damageImmunities;

		// Bestiary
		uint8_t bestiaryOccurrence = 0;
		uint8_t bestiaryStars = 0;
		uint16_t bestiaryToUnlock = 0;
		uint16_t bestiaryFirstUnlock = 0;
		uint16_t bestiarySecondUnlock = 0;
		uint16_t bestiaryCharmsPoints = 0;
		uint16_t raceid = 0;
		std::string bestiaryLocations;
		std::string bestiaryClass; // String (addString)
		BestiaryType_t bestiaryRace = BESTY_RACE_NONE; // Number (addByte)

		// Bosstiary
		BosstiaryRarity_t bosstiaryRace = BosstiaryRarity_t::BOSS_INVALID;
		std::string bosstiaryClass;

		float mitigation = 0;

		uint32_t soundChance = 0;
		uint32_t soundSpeedTicks = 0;
		std::vector<SoundEffect_t> soundVector;
		SoundEffect_t deathSound = SoundEffect_t::SILENCE;

		int32_t creatureAppearEvent = -1;
		int32_t creatureDisappearEvent = -1;
		int32_t creatureMoveEvent = -1;
		int32_t creatureSayEvent = -1;
		int32_t monsterAttackedByPlayerEvent = -1;
		int32_t thinkEvent = -1;
		int32_t spawnEvent = -1;
		int32_t targetDistance = 1;
		int32_t runAwayHealth = 0;
		int32_t health = 100;
		int32_t healthMax = 100;
		int32_t changeTargetChance = 0;
		int32_t defense = 0;
		int32_t armor = 0;
		uint16_t critChance = 0;
		int32_t strategiesTargetNearest = 0;
		int32_t strategiesTargetHealth = 0;
		int32_t strategiesTargetDamage = 0;
		int32_t strategiesTargetRandom = 0;
		bool targetPreferPlayer = false;
		bool targetPreferMaster = false;

		Faction_t faction = FACTION_DEFAULT;
		stdext::vector_set<Faction_t> enemyFactions;

		bool canPushItems = false;
		bool canPushCreatures = false;
		bool pushable = true;
		bool isSummonable = false;
		bool isIllusionable = false;
		bool isConvinceable = false;
		bool isAttackable = true;
		bool isHostile = true;
		bool hiddenHealth = false;
		bool isBlockable = false;
		bool isFamiliar = false;
		bool isRewardBoss = false;
		bool canWalkOnEnergy = true;
		bool canWalkOnFire = true;
		bool canWalkOnPoison = true;
		bool isForgeCreature = true;
		bool isPreyable = true;
		bool isPreyExclusive = false;

		MonstersEvent_t eventType = MONSTERS_EVENT_NONE;
	};

public:
	MonsterType() = default;
	explicit MonsterType(const std::string &initName) :
		name(initName), typeName(initName), nameDescription(initName) { }

	// non-copyable
	MonsterType(const MonsterType &) = delete;
	MonsterType &operator=(const MonsterType &) = delete;

	bool loadCallback(LuaScriptInterface* scriptInterface);

	std::string name;
	std::string typeName;
	std::string nameDescription;
	std::string variantName;

	MonsterInfo info;

	uint16_t getBaseSpeed() const;

	void setBaseSpeed(const uint16_t initBaseSpeed);

	float getHealthMultiplier() const;

	float getAttackMultiplier() const;

	float getDefenseMultiplier() const;

	bool isBoss() const;

	void loadLoot(const std::shared_ptr<MonsterType> &monsterType, LootBlock lootblock) const;

	bool canSpawn(const Position &pos) const;
};

class MonsterSpell {
public:
	MonsterSpell() = default;

	MonsterSpell(const MonsterSpell &) = delete;
	MonsterSpell &operator=(const MonsterSpell &) = delete;

	std::string name;
	std::string scriptName;

	uint8_t chance = 100;
	uint8_t range = 0;

	uint16_t interval = 2000;

	int32_t minCombatValue = 0;
	int32_t maxCombatValue = 0;
	int32_t attack = 0;
	int32_t skill = 0;
	int32_t length = 0;
	int32_t spread = 0;
	int32_t radius = 0;
	int32_t conditionMinDamage = 0;
	int32_t conditionMaxDamage = 0;
	int32_t conditionStartDamage = 0;
	int32_t tickInterval = 0;
	int32_t speedChange = 0;
	int32_t duration = 0;

	bool isScripted = false;
	bool needTarget = false;
	bool needDirection = false;
	bool combatSpell = false;
	bool isMelee = false;

	Outfit_t outfit = {};
	std::string outfitMonster;
	uint16_t outfitItem = 0;

	ShootType_t shoot = CONST_ANI_NONE;
	MagicEffectClasses effect = CONST_ME_NONE;
	ConditionType_t conditionType = CONDITION_NONE;
	CombatType_t combatType = COMBAT_UNDEFINEDDAMAGE;

	SoundEffect_t soundImpactEffect = SoundEffect_t::SILENCE;
	SoundEffect_t soundCastEffect = SoundEffect_t::SILENCE;
};

class Monsters {
public:
	Monsters() = default;
	// non-copyable
	Monsters(const Monsters &) = delete;
	Monsters &operator=(const Monsters &) = delete;

	static Monsters &getInstance();

	void clear();

	std::shared_ptr<MonsterType> getMonsterType(const std::string &name, bool silent = false) const;
	std::shared_ptr<MonsterType> getMonsterTypeByRaceId(uint16_t raceId, bool isBoss = false) const;
	bool tryAddMonsterType(const std::string &name, const std::shared_ptr<MonsterType> &mType);
	bool deserializeSpell(const std::shared_ptr<MonsterSpell> &spell, spellBlock_t &sb, const std::string &description = "") const;
	std::vector<std::shared_ptr<MonsterType>> getMonstersByRace(BestiaryType_t race) const;
	std::vector<std::shared_ptr<MonsterType>> getMonstersByBestiaryStars(uint8_t stars) const;

	std::unique_ptr<LuaScriptInterface> scriptInterface;
	std::map<std::string, std::shared_ptr<MonsterType>> monsters;

private:
	std::shared_ptr<ConditionDamage> getDamageCondition(ConditionType_t conditionType, int32_t maxDamage, int32_t minDamage, int32_t startDamage, uint32_t tickInterval) const;
};

constexpr auto g_monsters = Monsters::getInstance;
