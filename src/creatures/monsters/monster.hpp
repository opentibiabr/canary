/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once
#include "creatures/creature.hpp"
#include "creatures/monsters/monster_relevance.hpp"
#include "game/scheduling/dispatcher_policy.hpp"
#include "lua/lua_definitions.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <deque>
	#include <optional>
#endif

struct spellBlock_t;
struct MapCacheFloorCursor;
struct MonsterPathResult;
struct MonsterPathTraits;
struct MonsterCombatIntentionResult;
struct MonsterTargetRankingResult;
class MonsterType;
class NavRegionSnapshot;
class Tile;
class Creature;
class Game;
class SpawnMonster;

using CreatureVector = std::vector<std::shared_ptr<Creature>>;

class Monster final : public Creature {
private:
	/**
	 * Target identity is stored beside the weak owner so hot membership checks
	 * can compare ids before paying for weak_ptr::lock().
	 */
	struct TargetReference {
		uint32_t creatureId = 0;
		std::weak_ptr<Creature> creature;
		bool countsAsPlayerOnScreen = false;
	};

	/**
	 * Movement fanout can notify the same monster many times before its async AI
	 * batch runs. Keep only a re-resolvable snapshot here; no raw creature or
	 * tile borrow may cross the async boundary.
	 */
	struct PendingMovementAiRefresh {
		std::weak_ptr<Creature> creature;
		Position oldPos;
		Position newPos;
		CoalescedTaskState state;
		bool needsFullRefresh = false;
	};

	struct FollowPathComputeRequest {
		Position start;
		Position target;
		FindPathParams params;
		uint32_t targetId = 0;
		bool executeOnFollow = true;

		[[nodiscard]] bool matches(const FollowPathComputeRequest &other) const;
	};

	struct TargetSearchComputeRequest {
		TargetSearchType_t searchType = TARGETSEARCH_DEFAULT;
		uint64_t stateEpoch = 0;
		uint64_t decisionEpoch = 0;
	};

	struct CombatIntentionComputeRequest {
		uint64_t generation = 0;
		uint64_t targetDecisionEpoch = 0;
		uint64_t monsterReloadEpoch = 0;
		uint32_t interval = 0;
		uint32_t targetId = 0;
		uint32_t attackTicksSnapshot = 0;
		Position origin;
		Position target;
		bool fleeing = false;
	};

	bool canWalkTo(Position pos, Direction direction, MapCacheFloorCursor &floorCursor);

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
	Monster* getMonsterRaw() noexcept override {
		return this;
	}
	const Monster* getMonsterRaw() const noexcept override {
		return this;
	}

	/**
	 * Assigns a process-local monotonic monster runtime ID.
	 *
	 * Monster IDs are not reused during normal runtime, so short delayed
	 * dispatcher follow-up work may carry the ID and re-resolve through `Game`
	 * instead of keeping an extra strong reference alive. Long-lived storage
	 * still needs an explicit ownership or handle contract.
	 */
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

	const std::string &getLowerName() const {
		return m_lowerName;
	}

	CreatureType_t getType() const override;

	const Position &getMasterPos() const;
	void setMasterPos(Position pos);

	RaceType_t getRace() const override;
	float getMitigation() const override;
	int32_t getArmor() const override;
	int32_t getDefense(bool = false) const override;

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
	void onSpawn(const Position &position);

	void drainHealth(const std::shared_ptr<Creature> &attacker, int32_t damage) override;
	void changeHealth(int32_t healthChange, bool sendHealthChange = true) override;
	bool getNextStep(Direction &direction, uint32_t &flags) override;
	bool setAttackedCreature(const std::shared_ptr<Creature> &creature) override;
	bool setFollowCreature(const std::shared_ptr<Creature> &creature) override;
	void onFollowCreatureComplete(const std::shared_ptr<Creature> &creature) override;

	void onThink(uint32_t interval) override;
	bool trySchedulePostThink();
	void cancelScheduledPostThink(bool playerVisible);
	void executePostThink(uint32_t interval, bool playerVisible);
	bool requestFollowPathCompute(const std::shared_ptr<Creature> &followCreature, const FindPathParams &params, bool executeOnFollow);
	void supersedeFollowPathCompute();

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

		const auto previousSize = targetList.size();
		std::erase_if(targetList, [this, &list](const TargetReference &ref) {
			if (const auto &creature = ref.creature.lock()) {
				list.emplace_back(creature);
				return false;
			}

			forgetTargetReference(ref);
			return true;
		});
		if (targetList.size() != previousSize) {
			markTargetStateChanged();
		}

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

	void setFatalHoldDuration(int32_t value);
	int32_t getRunAwayHealth() const;
	void setRunAwayHealth(int32_t value);

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

	bool getSoulPit() const;
	void setSoulPit(bool value);
	void setSoulPitStack(uint8_t stack, bool isSummon = false);

	void updateTargetList();
	void clearTargetList();
	void clearFriendList();

	BlockType_t blockHit(const std::shared_ptr<Creature> &attacker, const CombatType_t &combatType, int32_t &damage, bool checkDefense = false, bool checkArmor = false, bool field = false) override;

	static uint32_t monsterAutoID;

	void applyStacks();

	void configureForgeSystem(uint16_t stack = 0);

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

	void setCriticalChance(uint16_t chance);
	uint16_t getCriticalChance() const;

	void setCriticalDamage(uint16_t damage);
	uint16_t getCriticalDamage() const;
	bool checkCanApplyCharm(const std::shared_ptr<Player> &player, charmRune_t charmRune) const;

protected:
	void onExecuteAsyncTasks() override;

private:
	bool onThink_async();
	void queuePostThinkAfterAsync();
	void promotePostThinkToPlayerVisibleQueue();
	void prepareFollowPathCompute(uint64_t generation);
	void completeFollowPathCompute(uint64_t generation, std::shared_ptr<const NavRegionSnapshot> navigation, MonsterPathResult result);
	void rejectFollowPathCompute(uint64_t generation);
	void discardFollowPathCompute(bool requestRefresh);
	[[nodiscard]] MonsterPathTraits capturePathTraits(const NavRegionSnapshot &navigation) const;
	[[nodiscard]] uint64_t nextFollowPathComputeGeneration();
	bool searchTargetImmediate(TargetSearchType_t searchType);
	bool requestTargetSearchCompute(TargetSearchType_t searchType);
	void prepareTargetSearchCompute(uint64_t generation);
	void completeTargetSearchCompute(uint64_t generation, uint64_t stateEpoch, uint64_t decisionEpoch, Position origin, TargetSearchType_t searchType, std::vector<uint32_t> fallbackIds, MonsterTargetRankingResult result);
	void retryTargetSearchCompute(TargetSearchType_t searchType);
	void clearTargetSearchCompute(bool releasePostThink = true);
	void markTargetStateChanged();
	void markTargetDecisionChanged();
	[[nodiscard]] uint64_t nextTargetSearchComputeGeneration();
	void updateSummonTarget();
	void deferTargetSelection(uint32_t creatureId);
	void requestCombatIntention(uint32_t interval, const std::shared_ptr<Creature> &target);
	void startPendingCombatIntention();
	void prepareCombatIntention(uint64_t generation);
	void completeCombatIntention(uint64_t generation, MonsterCombatIntentionResult result);
	void deferPendingCombatIntention();
	void clearCombatIntention();
	void commitCombatIntention(const CombatIntentionComputeRequest &request, const std::shared_ptr<Creature> &target, const std::vector<uint32_t> &geometricallyEligibleSpellIndices, bool requireGeometryHint);
	[[nodiscard]] uint64_t nextCombatIntentionGeneration();
	[[nodiscard]] MonsterRelevanceSnapshot captureComputeRelevance() const;
	bool isComputeRelevant();
	bool isPlayerVisibleForScheduling() override;
	void observeVisiblePlayerForScheduling(const std::shared_ptr<Creature> &creature);
	bool addVisiblePlayerSpectator(const std::shared_ptr<Creature> &creature);
	void removeVisiblePlayerSpectator(const std::shared_ptr<Creature> &creature);

	auto getTargetIterator(const std::shared_ptr<Creature> &creature) {
		return std::ranges::find_if(targetList, [creatureId = creature->getID()](const TargetReference &ref) {
			return ref.creatureId == creatureId;
		});
	}

	bool countsAsPlayerOnScreenTarget(const std::shared_ptr<Creature> &creature) const;
	void forgetTargetReference(const TargetReference &ref);

	std::unordered_map<uint32_t, std::weak_ptr<Creature>> friendList;
	std::deque<TargetReference> targetList;
	PendingMovementAiRefresh pendingMovementAiRefresh;
	CoalescedTaskState pendingPostThink;
	bool postThinkQueued = false;
	bool postThinkPlayerVisible = false;
	bool postThinkWaitingForTargetDecision = false;
	std::optional<FollowPathComputeRequest> pendingFollowPathCompute;
	uint64_t followPathComputeGeneration = 0;
	uint64_t activeFollowPathComputeGeneration = 0;
	bool followPathComputeOutstanding = false;
	bool followPathComputeSuperseded = false;
	std::optional<TargetSearchComputeRequest> pendingTargetSearchCompute;
	uint64_t targetStateEpoch = 1;
	uint64_t targetDecisionEpoch = 1;
	uint64_t targetSearchComputeGeneration = 0;
	uint64_t activeTargetSearchComputeGeneration = 0;
	bool targetSearchComputeOutstanding = false;
	std::optional<CombatIntentionComputeRequest> pendingCombatIntention;
	uint64_t combatIntentionGeneration = 0;
	uint64_t activeCombatIntentionGeneration = 0;
	bool combatIntentionOutstanding = false;
	MonsterRelevanceState computeRelevance;

	time_t timeToChangeFiendish = 0;

	// Forge System
	uint16_t forgeStack = 0;
	ForgeClassifications_t monsterForgeClassification = ForgeClassifications_t::FORGE_NORMAL_MONSTER;

	std::string name;
	std::string m_lowerName;
	std::string nameDescription;

	std::shared_ptr<MonsterType> m_monsterType;
	std::weak_ptr<SpawnMonster> spawnMonster;

	int64_t lastMeleeAttack = 0;

	uint16_t totalPlayersOnScreen = 0;
	std::vector<uint32_t> visiblePlayerSpectatorIds;
	MonsterRelevancePolicy::Clock::time_point playerVisibleUntil {};

	uint16_t criticalChance = 0;
	uint16_t criticalDamage = 0;

	uint32_t attackTicks = 0;
	uint32_t targetChangeTicks = 0;
	uint32_t defenseTicks = 0;
	uint32_t yellTicks = 0;
	uint32_t soundTicks = 0;

	int32_t minCombatValue = 0;
	int32_t maxCombatValue = 0;
	int32_t m_targetChangeCooldown = 0;
	int32_t fatalHoldDuration = 0;
	int32_t challengeFocusDuration = 0;
	int32_t stepDuration = 0;
	int32_t targetDistance = 1;
	int32_t challengeMeleeDuration = 0;
	int32_t runAwayHealth = 0;
	int32_t m_defense = 0;

	std::unordered_map<CombatType_t, int32_t> m_reflectElementMap;

	std::vector<spellBlock_t> attackSpells;
	std::vector<spellBlock_t> defenseSpells;

	Position masterPos;

	bool canFlee = false;
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

	bool soulPit = false;

	bool m_isDead = false;
	bool m_isImmune = false;

	void onCreatureEnter(const std::shared_ptr<Creature> &creature);
	void onCreatureLeave(const std::shared_ptr<Creature> &creature);
	void onCreatureFound(const std::shared_ptr<Creature> &creature, bool pushFront = false);
	void onCreatureFound(const std::shared_ptr<Creature> &creature, bool pushFront, bool monsterPerfTestFriendlyFire);
	void queueMovementAiRefresh(const std::shared_ptr<Creature> &creature, const Position &oldPos, const Position &newPos);
	void executeMovementAiRefresh();
	void processMovementAiRefresh(const std::shared_ptr<Creature> &creature, const Position &oldPos, const Position &newPos);

	void updateLookDirection();

	bool addFriend(const std::shared_ptr<Creature> &creature);
	bool removeFriend(const std::shared_ptr<Creature> &creature);
	bool addTarget(const std::shared_ptr<Creature> &creature, bool pushFront = false);
	bool removeTarget(const std::shared_ptr<Creature> &creature);

	void death(const std::shared_ptr<Creature> &lastHitCreature) override;
	std::shared_ptr<Item> getCorpse(const std::shared_ptr<Creature> &lastHitCreature, const std::shared_ptr<Creature> &mostDamageCreature) override;

	/**
	 * @brief Toggles whether the monster is registered for periodic AI checks.
	 *
	 * Idle monsters clear their target/friend observer lists and are removed from
	 * the creature check list. Non-idle monsters are reinserted into the game
	 * creature check list through a shared owner, not a borrowed pointer. Calling
	 * this with `false` is intentionally idempotent: it revalidates the periodic
	 * check registration even if the local idle state is already active.
	 */
	void setIdle(bool idle);
	/**
	 * @brief Recomputes the idle state from the current AI context.
	 *
	 * The monsterPerfTestForceActive config is a benchmark-only override that
	 * keeps monsters active even when normal gameplay would idle them because no
	 * player or target is nearby.
	 */
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
	/**
	 * @brief Attempts to push or remove movable blocking items stacked on a tile in a given direction.
	 *
	 * Processes the tile's "down" items (bottom-to-top) and, for each movable item that blocks pathing or is solid,
	 * attempts to push it into the adjacent tile in nextDirection or, failing that, removes the item.
	 * Will not operate on house tiles or when the tile has no items. When one or more items are removed, a puff
	 * visual effect is produced at the tile position.
	 *
	 * Behavior specifics:
	 * - Only items that are movable, can be moved, and currently reside on the provided tile are considered.
	 * - Stops after successfully pushing up to 20 items and removing up to 10 items (these counters are independent).
	 *
	 * @param tile Shared pointer to the tile whose items should be processed.
	 * @param nextDirection Direction in which items should be pushed.
	 */
	static void pushItems(const std::shared_ptr<Tile> &tile, const Direction &nextDirection);
	static bool pushCreature(const std::shared_ptr<Creature> &creature);
	static void pushCreatures(const std::shared_ptr<Tile> &tile);

	void onThinkTarget(uint32_t interval);
	void onThinkYell(uint32_t interval);
	void onThinkDefense(uint32_t interval);
	void onThinkSound(uint32_t interval);

	/**
	 * @brief Classifies visible creatures for local friend and target observer lists.
	 *
	 * The monsterPerfTestFriendlyFire config only changes hostile non-summon
	 * monster classification for benchmark scenarios. Passive monsters retain
	 * their normal follow behavior. This must not be used as a persistent ownership
	 * or lifetime shortcut.
	 */
	bool isFriend(const std::shared_ptr<Creature> &creature) const;
	bool isFriend(const std::shared_ptr<Creature> &creature, bool monsterPerfTestFriendlyFire) const;
	bool isOpponent(const std::shared_ptr<Creature> &creature) const;
	bool isOpponent(const std::shared_ptr<Creature> &creature, bool monsterPerfTestFriendlyFire) const;
	bool isTarget(const std::shared_ptr<Creature> &creature, bool monsterPerfTestFriendlyFire);
	bool selectTarget(const std::shared_ptr<Creature> &creature, bool monsterPerfTestFriendlyFire);

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
