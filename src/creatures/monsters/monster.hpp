/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once
#include "creatures/creature.hpp"
#include "lua/lua_definitions.hpp"

struct spellBlock_t;
class MonsterType;
class Tile;
class Creature;
class Game;
class SpawnMonster;

using CreatureVector = std::vector<std::shared_ptr<Creature>>;

class Monster final : public Creature {
public:
	static std::shared_ptr<Monster> createMonster(const std::string &name);
	static int32_t despawnRange;
	static int32_t despawnRadius;

	explicit Monster(const std::shared_ptr<MonsterType> &mType);

	// non-copyable
	Monster(const Monster &) = delete;
	Monster &operator=(const Monster &) = delete;

	std::shared_ptr<Monster> getMonster() override;
	std::shared_ptr<const Monster> getMonster() const override;

	void setID() override;

	void addList() override;
	void removeList() override;

	const std::string &getName() const override;
	void setName(const std::string &name);

	// Real monster name, set on monster creation "createMonsterType(typeName)"
	const std::string &getTypeName() const override;
	const std::string &getNameDescription() const override;
	void setNameDescription(std::string_view nameDescription);
	std::string getDescription(int32_t) override;

	CreatureType_t getType() const override;

	const Position &getMasterPos() const;
	void setMasterPos(Position pos);

	RaceType_t getRace() const override;
	float getMitigation() const override;
	int32_t getArmor() const override;
	int32_t getDefense() const override;

	void addDefense(int32_t defense);

	Faction_t getFaction() const override;

	bool isEnemyFaction(Faction_t faction) const;

	bool isPushable() override;
	bool isAttackable() const override;
	bool canPushItems() const;
	bool canPushCreatures() const;
	bool isRewardBoss() const;
	bool isHostile() const;
	bool isFamiliar() const;
	bool canSeeInvisibility() const override;
	uint16_t critChance() const;
	uint32_t getManaCost() const;
	RespawnType getRespawnType() const;
	void setSpawnMonster(const std::shared_ptr<SpawnMonster> &newSpawnMonster);

	double_t getReflectPercent(CombatType_t combatType, bool useCharges = false) const override;
	uint32_t getHealingCombatValue(CombatType_t healingType) const;

	void addReflectElement(CombatType_t combatType, int32_t percent);

	bool canWalkOnFieldType(CombatType_t combatType) const;
	void onAttackedCreatureDisappear(bool isLogout) override;

	void onCreatureAppear(const std::shared_ptr<Creature> &creature, bool isLogin) override;
	void onRemoveCreature(const std::shared_ptr<Creature> &creature, bool isLogout) override;
	void onCreatureMove(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &newTile, const Position &newPos, const std::shared_ptr<Tile> &oldTile, const Position &oldPos, bool teleport) override;
	void onCreatureSay(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text) override;
	void onAttackedByPlayer(const std::shared_ptr<Player> &attackerPlayer);
	void onSpawn();

	void drainHealth(const std::shared_ptr<Creature> &attacker, int32_t damage) override;
	void changeHealth(int32_t healthChange, bool sendHealthChange = true) override;
	bool getNextStep(Direction &direction, uint32_t &flags) override;
	void onFollowCreatureComplete(const std::shared_ptr<Creature> &creature) override;

	void onThink(uint32_t interval) override;

	bool challengeCreature(const std::shared_ptr<Creature> &creature, int targetChangeCooldown) override;

	bool changeTargetDistance(int32_t distance, uint32_t duration = 12000);
	bool isChallenged() const;

	std::vector<CreatureIcon> getIcons() const override;

	void setNormalCreatureLight() override;
	bool getCombatValues(int32_t &min, int32_t &max) override;

	void doAttacking(uint32_t interval) override;
	bool hasExtraSwing() override;

	bool searchTarget(TargetSearchType_t searchType = TARGETSEARCH_DEFAULT);
	bool selectTarget(const std::shared_ptr<Creature> &creature);

	auto getTargetList() {
		CreatureVector list;
		list.reserve(targetList.size());

		std::erase_if(targetList, [&list](const std::weak_ptr<Creature> &ref) {
			if (const auto &creature = ref.lock()) {
				list.emplace_back(creature);
				return false;
			}

			return true;
		});

		return list;
	}

	auto getFriendList() {
		CreatureVector list;
		list.reserve(friendList.size());

		std::erase_if(friendList, [&list](const auto &it) {
			if (const auto &creature = it.second.lock()) {
				list.emplace_back(creature);
				return false;
			}

			return true;
		});

		return list;
	}

	bool isTarget(const std::shared_ptr<Creature> &creature);
	bool isFleeing() const;

	bool getDistanceStep(const Position &targetPos, Direction &direction, bool flee = false);
	bool isTargetNearby() const;
	bool isIgnoringFieldDamage() const;
	bool israndomStepping() const;
	void setIgnoreFieldDamage(bool ignore);
	bool getIgnoreFieldDamage() const;
	uint16_t getRaceId() const;

	// Hazard system
	bool getHazard() const;
	void setHazard(bool value);

	bool getHazardSystemCrit() const;
	void setHazardSystemCrit(bool value);

	bool getHazardSystemDodge() const;
	void setHazardSystemDodge(bool value);

	bool getHazardSystemDamageBoost() const;
	void setHazardSystemDamageBoost(bool value);
	bool getHazardSystemDefenseBoost() const;
	void setHazardSystemDefenseBoost(bool value);
	// Hazard end

	void updateTargetList();
	void clearTargetList();
	void clearFriendList();

	BlockType_t blockHit(const std::shared_ptr<Creature> &attacker, const CombatType_t &combatType, int32_t &damage, bool checkDefense = false, bool checkArmor = false, bool field = false) override;

	static uint32_t monsterAutoID;

	void configureForgeSystem();

	bool canBeForgeMonster() const;

	bool isForgeCreature() const;

	void setForgeMonster(bool forge) const;

	uint16_t getForgeStack() const;

	void setForgeStack(uint16_t stack);

	ForgeClassifications_t getMonsterForgeClassification() const;

	void setMonsterForgeClassification(ForgeClassifications_t classification);

	void setTimeToChangeFiendish(time_t time);

	time_t getTimeToChangeFiendish() const;

	std::shared_ptr<MonsterType> getMonsterType() const;

	void clearFiendishStatus();
	bool canDropLoot() const;

	bool isImmune(ConditionType_t conditionType) const override;
	bool isImmune(CombatType_t combatType) const override;
	void setImmune(bool immune);
	bool isImmune() const;

	float getAttackMultiplier() const;

	float getDefenseMultiplier() const;

	bool isDead() const override;

	void setDead(bool isDead);

protected:
	void onExecuteAsyncTasks() override;

private:
	auto getTargetIterator(const std::shared_ptr<Creature> &creature) {
		return std::ranges::find_if(targetList.begin(), targetList.end(), [id = creature->getID()](const std::weak_ptr<Creature> &ref) {
			const auto &target = ref.lock();
			return target && target->getID() == id;
		});
	}

	std::unordered_map<uint32_t, std::weak_ptr<Creature>> friendList;
	std::deque<std::weak_ptr<Creature>> targetList;

	time_t timeToChangeFiendish = 0;

	// Forge System
	uint16_t forgeStack = 0;
	ForgeClassifications_t monsterForgeClassification = ForgeClassifications_t::FORGE_NORMAL_MONSTER;

	std::string name;
	std::string nameDescription;

	std::shared_ptr<MonsterType> mType;
	std::shared_ptr<SpawnMonster> spawnMonster = nullptr;

	int64_t lastMeleeAttack = 0;

	uint16_t totalPlayersOnScreen = 0;

	uint32_t attackTicks = 0;
	uint32_t targetChangeTicks = 0;
	uint32_t defenseTicks = 0;
	uint32_t yellTicks = 0;
	uint32_t soundTicks = 0;

	int32_t minCombatValue = 0;
	int32_t maxCombatValue = 0;
	int32_t m_targetChangeCooldown = 0;
	int32_t challengeFocusDuration = 0;
	int32_t stepDuration = 0;
	int32_t targetDistance = 1;
	int32_t challengeMeleeDuration = 0;
	int32_t runAwayHealth = 0;
	int32_t m_defense = 0;

	std::unordered_map<CombatType_t, int32_t> m_reflectElementMap;

	Position masterPos;

	bool isWalkingBack = false;
	bool isIdle = true;
	bool extraMeleeAttack = false;
	bool randomStepping = false;
	bool ignoreFieldDamage = false;

	bool hazard = false;
	bool hazardCrit = false;
	bool hazardDodge = false;
	bool hazardDamageBoost = false;
	bool hazardDefenseBoost = false;

	bool m_isDead = false;
	bool m_isImmune = false;

	void onCreatureEnter(const std::shared_ptr<Creature> &creature);
	void onCreatureLeave(const std::shared_ptr<Creature> &creature);
	void onCreatureFound(const std::shared_ptr<Creature> &creature, bool pushFront = false);

	void updateLookDirection();

	void addFriend(const std::shared_ptr<Creature> &creature);
	void removeFriend(const std::shared_ptr<Creature> &creature);
	bool addTarget(const std::shared_ptr<Creature> &creature, bool pushFront = false);
	bool removeTarget(const std::shared_ptr<Creature> &creature);

	void death(const std::shared_ptr<Creature> &lastHitCreature) override;
	std::shared_ptr<Item> getCorpse(const std::shared_ptr<Creature> &lastHitCreature, const std::shared_ptr<Creature> &mostDamageCreature) override;

	void setIdle(bool idle);
	void updateIdleStatus();
	bool getIdleStatus() const;

	void onAddCondition(ConditionType_t type) override;
	void onEndCondition(ConditionType_t type) override;

	bool canUseAttack(const Position &pos, const std::shared_ptr<Creature> &target) const;
	bool canUseSpell(const Position &pos, const Position &targetPos, const spellBlock_t &sb, uint32_t interval, bool &inRange, bool &resetTicks);
	bool getRandomStep(const Position &creaturePos, Direction &direction);
	bool getDanceStep(const Position &creaturePos, Direction &direction, bool keepAttack = true, bool keepDistance = true);
	bool isInSpawnLocation() const;
	bool isInSpawnRange(const Position &pos) const;
	bool canWalkTo(Position pos, Direction direction);

	static bool pushItem(const std::shared_ptr<Item> &item, const Direction &nextDirection);
	static void pushItems(const std::shared_ptr<Tile> &tile, const Direction &nextDirection);
	static bool pushCreature(const std::shared_ptr<Creature> &creature);
	static void pushCreatures(const std::shared_ptr<Tile> &tile);

	void onThinkTarget(uint32_t interval);
	void onThinkYell(uint32_t interval);
	void onThinkDefense(uint32_t interval);
	void onThinkSound(uint32_t interval);

	bool isFriend(const std::shared_ptr<Creature> &creature) const;
	bool isOpponent(const std::shared_ptr<Creature> &creature) const;

	uint64_t getLostExperience() const override;
	uint16_t getLookCorpse() const override;
	void dropLoot(const std::shared_ptr<Container> &corpse, const std::shared_ptr<Creature> &lastHitCreature) override;
	void getPathSearchParams(const std::shared_ptr<Creature> &creature, FindPathParams &fpp) override;

	friend class MonsterFunctions;
	friend class Map;

	static std::vector<std::pair<int8_t, int8_t>> getPushItemLocationOptions(const Direction &direction);

	void doWalkBack(uint32_t &flags, Direction &nextDirection, bool &result);
	void doFollowCreature(uint32_t &flags, Direction &nextDirection, bool &result);
	void doRandomStep(Direction &nextDirection, bool &result);

	void onConditionStatusChange(ConditionType_t type);
};
