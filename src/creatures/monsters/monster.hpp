/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/monsters/monsters.hpp"
#include "declarations.hpp"
#include "items/tile.hpp"

class Creature;
class Game;

class Monster final : public Creature {
public:
	static std::shared_ptr<Monster> createMonster(const std::string &name);
	static int32_t despawnRange;
	static int32_t despawnRadius;

	explicit Monster(std::shared_ptr<MonsterType> mType);

	// non-copyable
	Monster(const Monster &) = delete;
	Monster &operator=(const Monster &) = delete;

	std::shared_ptr<Monster> getMonster() override {
		return static_self_cast<Monster>();
	}
	std::shared_ptr<const Monster> getMonster() const override {
		return static_self_cast<Monster>();
	}

	void setID() override {
		if (id == 0) {
			id = monsterAutoID++;
		}
	}

	void addList() override;
	void removeList() override;

	const std::string &getName() const override;
	void setName(const std::string &name);

	// Real monster name, set on monster creation "createMonsterType(typeName)"
	const std::string &getTypeName() const override {
		return mType->typeName;
	}
	const std::string &getNameDescription() const override;
	void setNameDescription(const std::string &nameDescription) {
		this->nameDescription = nameDescription;
	};
	std::string getDescription(int32_t) override {
		return nameDescription + '.';
	}

	CreatureType_t getType() const override {
		return CREATURETYPE_MONSTER;
	}

	const Position &getMasterPos() const {
		return masterPos;
	}
	void setMasterPos(Position pos) {
		masterPos = pos;
	}

	RaceType_t getRace() const override {
		return mType->info.race;
	}
	float getMitigation() const override;
	int32_t getArmor() const override {
		return mType->info.armor * getDefenseMultiplier();
	}
	int32_t getDefense() const override {
		return mType->info.defense * getDefenseMultiplier();
	}

	Faction_t getFaction() const override {
		auto master = getMaster();
		if (getMaster()) {
			return getMaster()->getFaction();
		}
		return mType->info.faction;
	}

	bool isEnemyFaction(Faction_t faction) const {
		auto master = getMaster();
		if (master && master->getMonster()) {
			return master->getMonster()->isEnemyFaction(faction);
		}
		return mType->info.enemyFactions.empty() ? false : mType->info.enemyFactions.contains(faction);
	}

	bool isPushable() override {
		return mType->info.pushable && baseSpeed != 0;
	}
	bool isAttackable() const override {
		return mType->info.isAttackable;
	}
	bool canPushItems() const {
		return mType->info.canPushItems;
	}
	bool canPushCreatures() const {
		return mType->info.canPushCreatures;
	}
	bool isRewardBoss() const {
		return mType->info.isRewardBoss;
	}
	bool isHostile() const {
		return mType->info.isHostile;
	}
	bool isFamiliar() const {
		return mType->info.isFamiliar;
	}
	bool canSeeInvisibility() const override {
		return isImmune(CONDITION_INVISIBLE);
	}
	uint16_t critChance() const {
		return mType->info.critChance;
	}
	uint32_t getManaCost() const {
		return mType->info.manaCost;
	}
	RespawnType getRespawnType() const {
		return mType->info.respawnType;
	}
	void setSpawnMonster(SpawnMonster* newSpawnMonster) {
		this->spawnMonster = newSpawnMonster;
	}

	int32_t getReflectPercent(CombatType_t combatType, bool useCharges = false) const override;
	uint32_t getHealingCombatValue(CombatType_t healingType) const;

	bool canWalkOnFieldType(CombatType_t combatType) const;
	void onAttackedCreatureDisappear(bool isLogout) override;

	void onCreatureAppear(std::shared_ptr<Creature> creature, bool isLogin) override;
	void onRemoveCreature(std::shared_ptr<Creature> creature, bool isLogout) override;
	void onCreatureMove(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &newTile, const Position &newPos, const std::shared_ptr<Tile> &oldTile, const Position &oldPos, bool teleport) override;
	void onCreatureSay(std::shared_ptr<Creature> creature, SpeakClasses type, const std::string &text) override;

	void drainHealth(std::shared_ptr<Creature> attacker, int32_t damage) override;
	void changeHealth(int32_t healthChange, bool sendHealthChange = true) override;
	bool getNextStep(Direction &direction, uint32_t &flags) override;
	void onFollowCreatureComplete(const std::shared_ptr<Creature> &creature) override;

	void onThink(uint32_t interval) override;

	bool challengeCreature(std::shared_ptr<Creature> creature, int targetChangeCooldown) override;

	bool changeTargetDistance(int32_t distance, uint32_t duration = 12000);
	bool isChallenged() const {
		return challengeFocusDuration > 0;
	}

	std::vector<CreatureIcon> getIcons() const override {
		auto creatureIcons = Creature::getIcons();
		if (!creatureIcons.empty()) {
			return creatureIcons;
		}
		if (challengeMeleeDuration > 0 && mType->info.targetDistance > targetDistance) {
			return { CreatureIcon(CreatureIconModifications_t::TurnedMelee) };
		} else if (varBuffs[BUFF_DAMAGERECEIVED] > 100) {
			return { CreatureIcon(CreatureIconModifications_t::HigherDamageReceived) };
		} else if (varBuffs[BUFF_DAMAGEDEALT] < 100) {
			return { CreatureIcon(CreatureIconModifications_t::LowerDamageDealt) };
		}
		return {};
	}

	void setNormalCreatureLight() override;
	bool getCombatValues(int32_t &min, int32_t &max) override;

	void doAttacking(uint32_t interval) override;
	bool hasExtraSwing() override {
		return extraMeleeAttack;
	}

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

	bool isTarget(std::shared_ptr<Creature> creature);
	bool isFleeing() const {
		return !isSummon() && getHealth() <= runAwayHealth && challengeFocusDuration <= 0 && challengeMeleeDuration <= 0;
	}

	bool getDistanceStep(const Position &targetPos, Direction &direction, bool flee = false);
	bool isTargetNearby() const {
		return stepDuration >= 1;
	}
	bool isIgnoringFieldDamage() const {
		return ignoreFieldDamage;
	}
	bool israndomStepping() const {
		return randomStepping;
	}
	void setIgnoreFieldDamage(bool ignore) {
		ignoreFieldDamage = ignore;
	}
	bool getIgnoreFieldDamage() const {
		return ignoreFieldDamage;
	}
	uint16_t getRaceId() const {
		return mType->info.raceid;
	}

	// Hazard system
	bool getHazard() const {
		return hazard;
	}
	void setHazard(bool value) {
		hazard = value;
	}

	bool getHazardSystemCrit() const {
		return hazardCrit;
	}
	void setHazardSystemCrit(bool value) {
		hazardCrit = value;
	}

	bool getHazardSystemDodge() const {
		return hazardDodge;
	}
	void setHazardSystemDodge(bool value) {
		hazardDodge = value;
	}

	bool getHazardSystemDamageBoost() const {
		return hazardDamageBoost;
	}
	void setHazardSystemDamageBoost(bool value) {
		hazardDamageBoost = value;
	}
	bool getHazardSystemDefenseBoost() const {
		return hazardDefenseBoost;
	}
	void setHazardSystemDefenseBoost(bool value) {
		hazardDefenseBoost = value;
	}
	// Hazard end

	void updateTargetList();
	void clearTargetList();
	void clearFriendList();

	BlockType_t blockHit(std::shared_ptr<Creature> attacker, CombatType_t combatType, int32_t &damage, bool checkDefense = false, bool checkArmor = false, bool field = false) override;

	static uint32_t monsterAutoID;

	void configureForgeSystem();

	bool canBeForgeMonster() const {
		return getForgeStack() == 0 && !isSummon() && !isRewardBoss() && canDropLoot() && isForgeCreature() && getRaceId() > 0;
	}

	bool isForgeCreature() const {
		return mType->info.isForgeCreature;
	}

	void setForgeMonster(bool forge) const {
		mType->info.isForgeCreature = forge;
	}

	uint16_t getForgeStack() const {
		return forgeStack;
	}

	void setForgeStack(uint16_t stack) {
		forgeStack = stack;
	}

	ForgeClassifications_t getMonsterForgeClassification() const {
		return monsterForgeClassification;
	}

	void setMonsterForgeClassification(ForgeClassifications_t classification) {
		monsterForgeClassification = classification;
	}

	void setTimeToChangeFiendish(time_t time) {
		timeToChangeFiendish = time;
	}

	time_t getTimeToChangeFiendish() const {
		return timeToChangeFiendish;
	}

	std::shared_ptr<MonsterType> getMonsterType() const {
		return mType;
	}

	void clearFiendishStatus();
	bool canDropLoot() const;

	bool isImmune(ConditionType_t conditionType) const override;
	bool isImmune(CombatType_t combatType) const override;

	float getAttackMultiplier() const {
		float multiplier = mType->getAttackMultiplier();
		if (auto stacks = getForgeStack(); stacks > 0) {
			multiplier *= (1.35 + (stacks - 1) * 0.1);
		}
		return multiplier;
	}

	float getDefenseMultiplier() const {
		float multiplier = mType->getDefenseMultiplier();
		return multiplier * std::pow(1.02f, getForgeStack());
	}

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
	SpawnMonster* spawnMonster = nullptr;

	int64_t lastMeleeAttack = 0;

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
	uint16_t totalPlayersOnScreen = 0;
	int32_t runAwayHealth = 0;

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

	void onCreatureEnter(std::shared_ptr<Creature> creature);
	void onCreatureLeave(std::shared_ptr<Creature> creature);
	void onCreatureFound(std::shared_ptr<Creature> creature, bool pushFront = false);

	void updateLookDirection();

	void addFriend(const std::shared_ptr<Creature> &creature);
	void removeFriend(const std::shared_ptr<Creature> &creature);
	bool addTarget(const std::shared_ptr<Creature> &creature, bool pushFront = false);
	bool removeTarget(const std::shared_ptr<Creature> &creature);

	void death(std::shared_ptr<Creature> lastHitCreature) override;
	std::shared_ptr<Item> getCorpse(std::shared_ptr<Creature> lastHitCreature, std::shared_ptr<Creature> mostDamageCreature) override;

	void setIdle(bool idle);
	void updateIdleStatus();
	bool getIdleStatus() const {
		return isIdle;
	}

	void onAddCondition(ConditionType_t type) override;
	void onEndCondition(ConditionType_t type) override;

	bool canUseAttack(const Position &pos, const std::shared_ptr<Creature> &target) const;
	bool canUseSpell(const Position &pos, const Position &targetPos, const spellBlock_t &sb, uint32_t interval, bool &inRange, bool &resetTicks);
	bool getRandomStep(const Position &creaturePos, Direction &direction);
	bool getDanceStep(const Position &creaturePos, Direction &direction, bool keepAttack = true, bool keepDistance = true);
	bool isInSpawnLocation() const;
	bool isInSpawnRange(const Position &pos) const;
	bool canWalkTo(Position pos, Direction direction);

	static bool pushItem(std::shared_ptr<Item> item, const Direction &nextDirection);
	static void pushItems(std::shared_ptr<Tile> tile, const Direction &nextDirection);
	static bool pushCreature(std::shared_ptr<Creature> creature);
	static void pushCreatures(std::shared_ptr<Tile> tile);

	void onThinkTarget(uint32_t interval);
	void onThinkYell(uint32_t interval);
	void onThinkDefense(uint32_t interval);
	void onThinkSound(uint32_t interval);

	bool isFriend(const std::shared_ptr<Creature> &creature) const;
	bool isOpponent(const std::shared_ptr<Creature> &creature) const;

	uint64_t getLostExperience() const override {
		return skillLoss ? mType->info.experience : 0;
	}
	uint16_t getLookCorpse() const override {
		return mType->info.lookcorpse;
	}
	void dropLoot(std::shared_ptr<Container> corpse, std::shared_ptr<Creature> lastHitCreature) override;
	void getPathSearchParams(const std::shared_ptr<Creature> &creature, FindPathParams &fpp) override;
	bool useCacheMap() const override {
		// return !randomStepping;
		//  As the map cache is done synchronously for each movement that a monster makes, it is better to disable it,
		//  as the pathfinder, which is one of the resources that uses this cache the most,
		//  is multithreding and thus the processing cost is divided between the threads.
		return false;
	}

	friend class MonsterFunctions;
	friend class Map;

	static std::vector<std::pair<int8_t, int8_t>> getPushItemLocationOptions(const Direction &direction);

	void doWalkBack(uint32_t &flags, Direction &nextDirection, bool &result);
	void doFollowCreature(uint32_t &flags, Direction &nextDirection, bool &result);
	void doRandomStep(Direction &nextDirection, bool &result);

	void onConditionStatusChange(const ConditionType_t &type);
};
