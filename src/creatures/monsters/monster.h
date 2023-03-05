/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_CREATURES_MONSTERS_MONSTER_H_
#define SRC_CREATURES_MONSTERS_MONSTER_H_

#include "creatures/monsters/monsters.h"
#include "declarations.hpp"
#include "items/tile.h"

class Creature;
class Game;
class Spawn;

using CreatureHashSet = phmap::flat_hash_set<Creature*>;
using CreatureList = std::list<Creature*>;

class Monster final : public Creature {
	public:
		static Monster* createMonster(const std::string &name);
		static int32_t despawnRange;
		static int32_t despawnRadius;

		explicit Monster(MonsterType* mType);
		~Monster();

		// non-copyable
		Monster(const Monster &) = delete;
		Monster &operator=(const Monster &) = delete;

		Monster* getMonster() override {
			return this;
		}
		const Monster* getMonster() const override {
			return this;
		}

		void setID() override {
			if (id == 0) {
				id = monsterAutoID++;
			}
		}

		void removeList() override;
		void addList() override;

		const std::string &getName() const override {
			return mType->name;
		}
		// Real monster name, set on monster creation "createMonsterType(typeName)"
		const std::string &getTypeName() const override {
			return mType->typeName;
		}
		const std::string &getNameDescription() const override {
			return mType->nameDescription;
		}
		std::string getDescription(int32_t) const override {
			return strDescription + '.';
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
		float getMitigation() const override {
			return mType->info.mitigation;
		}
		int32_t getArmor() const override {
			return mType->info.armor;
		}
		int32_t getDefense() const override {
			return mType->info.defense;
		}

		Faction_t getFaction() const override {
			if (master)
				return master->getFaction();
			return mType->info.faction;
		}

		bool isEnemyFaction(Faction_t faction) const {
			if (master && master->getMonster())
				return master->getMonster()->isEnemyFaction(faction);
			return mType->info.enemyFactions.empty() ? false : mType->info.enemyFactions.find(faction) != mType->info.enemyFactions.end();
		}

		bool isPushable() const override {
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
		uint32_t getManaCost() const {
			return mType->info.manaCost;
		}
		RespawnType getRespawnType() const {
			return mType->info.respawnType;
		}
		void setSpawnMonster(SpawnMonster* newSpawnMonster) {
			this->spawnMonster = newSpawnMonster;
		}

		uint32_t getReflectValue(CombatType_t combatType) const;
		uint32_t getHealingCombatValue(CombatType_t healingType) const;

		bool canWalkOnFieldType(CombatType_t combatType) const;
		void onAttackedCreatureDisappear(bool isLogout) override;

		void onCreatureAppear(Creature* creature, bool isLogin) override;
		void onRemoveCreature(Creature* creature, bool isLogout) override;
		void onCreatureMove(Creature* creature, const Tile* newTile, const Position &newPos, const Tile* oldTile, const Position &oldPos, bool teleport) override;
		void onCreatureSay(Creature* creature, SpeakClasses type, const std::string &text) override;

		void drainHealth(Creature* attacker, int32_t damage) override;
		void changeHealth(int32_t healthChange, bool sendHealthChange = true) override;
		bool getNextStep(Direction &direction, uint32_t &flags) override;
		void onFollowCreatureComplete(const Creature* creature) override;

		void onThink(uint32_t interval) override;

		bool challengeCreature(Creature* creature) override;

		bool changeTargetDistance(int32_t distance, uint32_t duration = 12000);

		CreatureIcon_t getIcon() const override {
			if (challengeMeleeDuration > 0 && mType->info.targetDistance > targetDistance) {
				return CREATUREICON_TURNEDMELEE;
			} else if (varBuffs[BUFF_DAMAGERECEIVED] > 100) {
				return CREATUREICON_HIGHERRECEIVEDDAMAGE;
			} else if (varBuffs[BUFF_DAMAGEDEALT] < 100) {
				return CREATUREICON_LOWERDEALTDAMAGE;
			}
			switch (iconNumber) {
				case 1:
					return CREATUREICON_HIGHERRECEIVEDDAMAGE;
				case 2:
					return CREATUREICON_LOWERDEALTDAMAGE;
				case 3:
					return CREATUREICON_TURNEDMELEE;
				case 4:
					return CREATUREICON_GREENBALL;
				case 5:
					return CREATUREICON_REDBALL;
				case 6:
					return CREATUREICON_GREENSHIELD;
				case 7:
					return CREATUREICON_YELLOWSHIELD;
				case 8:
					return CREATUREICON_BLUESHIELD;
				case 9:
					return CREATUREICON_PURPLESHIELD;
				case 10:
					return CREATUREICON_REDSHIELD;
				case 11:
					return CREATUREICON_PIGEON;
				case 12:
					return CREATUREICON_PURPLESTAR;
				case 13:
					return CREATUREICON_POISONDROP;
				case 14:
					return CREATUREICON_WATERDROP;
				case 15:
					return CREATUREICON_FIREDROP;
				case 16:
					return CREATUREICON_ICEFLOWER;
				case 17:
					return CREATUREICON_ARROWUP;
				case 18:
					return CREATUREICON_ARROWDOWN;
				case 19:
					return CREATUREICON_EXCLAMATIONMARK;
				case 20:
					return CREATUREICON_QUESTIONMARK;
				case 21:
					return CREATUREICON_CANCELMARK;
				default:
					return CREATUREICON_NONE;
			}

			return CREATUREICON_NONE;
		}

		void setMonsterIcon(uint16_t iconcount, uint16_t iconnumber);

		void setNormalCreatureLight() override;
		bool getCombatValues(int32_t &min, int32_t &max) override;

		void doAttacking(uint32_t interval) override;
		bool hasExtraSwing() override {
			return extraMeleeAttack;
		}

		bool searchTarget(TargetSearchType_t searchType = TARGETSEARCH_DEFAULT);
		bool selectTarget(Creature* creature);

		const CreatureList &getTargetList() const {
			return targetList;
		}
		const CreatureHashSet &getFriendList() const {
			return friendList;
		}

		bool isTarget(const Creature* creature) const;
		bool isFleeing() const {
			return !isSummon() && getHealth() <= mType->info.runAwayHealth && challengeFocusDuration <= 0;
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
		bool isMonsterOnHazardSystem() const {
			return mType->info.hazardSystemCritChance != 0 || mType->info.canSpawnPod || mType->info.canDodge || mType->info.canDamageBoost;
		}

		bool getHazardSystemDodge() const {
			return mType->info.canDodge;
		}

		bool getHazardSystemSpawnPod() const {
			return mType->info.canSpawnPod;
		}

		bool getHazardSystemDamageBoost() const {
			return mType->info.canDamageBoost;
		}

		uint16_t getHazardSystemCritChance() const {
			return mType->info.hazardSystemCritChance;
		}

		void updateTargetList();
		void clearTargetList();
		void clearFriendList();

		BlockType_t blockHit(Creature* attacker, CombatType_t combatType, int32_t &damage, bool checkDefense = false, bool checkArmor = false, bool field = false) override;

		static uint32_t monsterAutoID;

		void configureForgeSystem();

		bool canBeForgeMonster() const {
			return getForgeStack() == 0 && !isSummon() && !isRewardBoss() && canDropLoot() && isForgeCreature() && getRaceId() > 0;
		}

		bool isForgeCreature() const {
			return mType->info.isForgeCreature;
		}

		void setForgeMonster(bool forge) {
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

		void clearFiendishStatus();
		bool canDropLoot() const;

	private:
		CreatureHashSet friendList;
		CreatureList targetList;

		uint16_t iconCount = 0;
		uint32_t iconNumber = 0;

		time_t timeToChangeFiendish = 0;

		// Forge System
		uint16_t forgeStack = 0;
		ForgeClassifications_t monsterForgeClassification = ForgeClassifications_t::FORGE_NORMAL_MONSTER;

		std::string strDescription;

		MonsterType* mType;
		SpawnMonster* spawnMonster = nullptr;

		int64_t lastMeleeAttack = 0;

		uint32_t attackTicks = 0;
		uint32_t targetTicks = 0;
		uint32_t targetChangeTicks = 0;
		uint32_t defenseTicks = 0;
		uint32_t yellTicks = 0;
		int32_t minCombatValue = 0;
		int32_t maxCombatValue = 0;
		int32_t targetChangeCooldown = 0;
		int32_t challengeFocusDuration = 0;
		int32_t stepDuration = 0;
		int32_t targetDistance = 1;
		int32_t challengeMeleeDuration = 0;
		uint16_t totalPlayersOnScreen = 0;

		Position masterPos;

		bool isIdle = true;
		bool extraMeleeAttack = false;
		bool randomStepping = false;
		bool ignoreFieldDamage = false;

		void onCreatureEnter(Creature* creature);
		void onCreatureLeave(Creature* creature);
		void onCreatureFound(Creature* creature, bool pushFront = false);

		void updateLookDirection();

		void addFriend(Creature* creature);
		void removeFriend(Creature* creature);
		void addTarget(Creature* creature, bool pushFront = false);
		void removeTarget(Creature* creature);

		void death(Creature* lastHitCreature) override;
		Item* getCorpse(Creature* lastHitCreature, Creature* mostDamageCreature) override;

		void setIdle(bool idle);
		void updateIdleStatus();
		bool getIdleStatus() const {
			return isIdle;
		}

		void onAddCondition(ConditionType_t type) override;
		void onEndCondition(ConditionType_t type) override;

		bool canUseAttack(const Position &pos, const Creature* target) const;
		bool canUseSpell(const Position &pos, const Position &targetPos, const spellBlock_t &sb, uint32_t interval, bool &inRange, bool &resetTicks);
		bool getRandomStep(const Position &creaturePos, Direction &direction) const;
		bool getDanceStep(const Position &creaturePos, Direction &direction, bool keepAttack = true, bool keepDistance = true);
		bool isInSpawnRange(const Position &pos) const;
		bool canWalkTo(Position pos, Direction direction) const;

		static bool pushItem(Item* item, const Direction &nextDirection);
		static void pushItems(Tile* tile, const Direction &nextDirection);
		static bool pushCreature(Creature* creature);
		static void pushCreatures(Tile* tile);

		void onThinkTarget(uint32_t interval);
		void onThinkYell(uint32_t interval);
		void onThinkDefense(uint32_t interval);

		bool isFriend(const Creature* creature) const;
		bool isOpponent(const Creature* creature) const;

		uint64_t getLostExperience() const override {
			return skillLoss ? mType->info.experience : 0;
		}
		uint16_t getLookCorpse() const override {
			return mType->info.lookcorpse;
		}
		void dropLoot(Container* corpse, Creature* lastHitCreature) override;
		uint32_t getDamageImmunities() const override {
			return mType->info.damageImmunities;
		}
		uint32_t getConditionImmunities() const override {
			return mType->info.conditionImmunities;
		}
		void getPathSearchParams(const Creature* creature, FindPathParams &fpp) const override;
		bool useCacheMap() const override {
			return !randomStepping;
		}

		friend class MonsterFunctions;
		friend class Map;

		static std::vector<std::pair<int8_t, int8_t>> getPushItemLocationOptions(const Direction &direction);

		void doFollowCreature(uint32_t &flags, Direction &nextDirection, bool &result);
		void doRandomStep(Direction &nextDirection, bool &result);

		void onConditionStatusChange(const ConditionType_t &type);
};

#endif // SRC_CREATURES_MONSTERS_MONSTER_H_
