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
#include "game/movement/position.hpp"

enum class PlayerIcon : uint8_t;

class Creature;
class Player;
class PropStream;
class PropWriteStream;

class Condition : public SharedObject {
public:
	Condition() = default;
	Condition(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff = false, uint32_t initSubId = 0, bool isPersistent = false);
	virtual ~Condition() = default;

	virtual bool startCondition(std::shared_ptr<Creature> creature);
	virtual bool executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval);
	virtual void endCondition(std::shared_ptr<Creature> creature) = 0;
	virtual void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> condition) = 0;
	virtual std::unordered_set<PlayerIcon> getIcons() const;
	ConditionId_t getId() const;
	uint32_t getSubId() const;

	virtual std::shared_ptr<Condition> clone() const = 0;

	ConditionType_t getType() const;
	int64_t getEndTime() const;
	int32_t getTicks() const;
	void setTicks(int32_t newTicks);

	static std::shared_ptr<Condition> createCondition(ConditionId_t id, ConditionType_t type, int32_t ticks, int32_t param = 0, bool buff = false, uint32_t subId = 0, bool isPersistent = false);
	static std::shared_ptr<Condition> createCondition(PropStream &propStream);

	virtual bool setParam(ConditionParam_t param, int32_t value);
	virtual bool setPositionParam(ConditionParam_t param, const Position &pos);

	// serialization
	bool unserialize(PropStream &propStream);
	virtual void serialize(PropWriteStream &propWriteStream);
	virtual bool unserializeProp(ConditionAttr_t attr, PropStream &propStream);

	bool isPersistent() const;
	bool isRemovableOnDeath() const;

protected:
	uint8_t drainBodyStage = 0;
	int64_t endTime {};
	uint32_t subId {};
	int32_t ticks {};
	ConditionType_t conditionType {};
	ConditionId_t id {};
	bool isBuff {};
	bool m_isPersistent {};

	virtual bool updateCondition(const std::shared_ptr<Condition> &addCondition);

private:
	SoundEffect_t tickSound = SoundEffect_t::SILENCE;
	SoundEffect_t addSound = SoundEffect_t::SILENCE;

	friend class ConditionDamage;
	friend class ConditionGeneric;
};

class ConditionGeneric : public Condition {
public:
	ConditionGeneric(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff = false, uint32_t initSubId = 0, bool isPersistent = false);

	bool startCondition(std::shared_ptr<Creature> creature) override;
	bool executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) override;
	void endCondition(std::shared_ptr<Creature> creature) override;
	void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> condition) override;
	std::unordered_set<PlayerIcon> getIcons() const override;

	std::shared_ptr<Condition> clone() const override;
};

class ConditionAttributes final : public ConditionGeneric {
public:
	ConditionAttributes(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff = false, uint32_t initSubId = 0);

	bool startCondition(std::shared_ptr<Creature> creature) final;
	bool executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) final;
	void endCondition(std::shared_ptr<Creature> creature) final;
	void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> condition) final;

	bool setParam(ConditionParam_t param, int32_t value) final;

	std::shared_ptr<Condition> clone() const override;

	// serialization
	void serialize(PropWriteStream &propWriteStream) final;
	bool unserializeProp(ConditionAttr_t attr, PropStream &propStream) final;

private:
	// Helpers
	int32_t getAbsorbByIndex(uint8_t index) const;
	void setAbsorb(uint8_t index, int32_t value);
	int32_t getAbsorbPercentByIndex(uint8_t index) const;
	void setAbsorbPercent(uint8_t index, int32_t value);
	int32_t getIncreaseByIndex(uint8_t index) const;
	void setIncrease(uint8_t index, int32_t value);
	int32_t getIncreasePercentById(uint8_t index) const;
	void setIncreasePercent(uint8_t index, int32_t value);

	int32_t skills[SKILL_LAST + 1] = {};
	int32_t skillsPercent[SKILL_LAST + 1] = {};
	int32_t stats[STAT_LAST + 1] = {};
	int32_t statsPercent[STAT_LAST + 1] = {};
	int32_t buffsPercent[BUFF_LAST + 1] = {};
	int32_t buffs[BUFF_LAST + 1] = {};

	int32_t currentSkill = 0;
	int32_t currentStat = 0;
	int32_t currentBuff = 0;

	int8_t charmChanceModifier = 0;

	// 12.72 mechanics
	std::array<int32_t, COMBAT_COUNT> absorbs = {};
	std::array<int32_t, COMBAT_COUNT> absorbsPercent = {};
	std::array<int32_t, COMBAT_COUNT> increases = {};
	std::array<int32_t, COMBAT_COUNT> increasesPercent = {};

	bool disableDefense = false;

	void updatePercentStats(const std::shared_ptr<Player> &player);
	void updateStats(const std::shared_ptr<Player> &player) const;
	void updatePercentSkills(const std::shared_ptr<Player> &player);
	void updateSkills(const std::shared_ptr<Player> &player) const;
	void updateBuffs(const std::shared_ptr<Creature> &creature) const;

	// 12.72 mechanics
	void updatePercentAbsorbs(const std::shared_ptr<Creature> &creature);
	void updateAbsorbs(const std::shared_ptr<Creature> &creature) const;
	void updatePercentIncreases(const std::shared_ptr<Creature> &creature);
	void updateIncreases(const std::shared_ptr<Creature> &creature) const;
	void updateCharmChanceModifier(const std::shared_ptr<Creature> &creature) const;
	void updatePercentBuffs(const std::shared_ptr<Creature> &creature);
};

class ConditionRegeneration final : public ConditionGeneric {
public:
	ConditionRegeneration(ConditionId_t initId, ConditionType_t initType, int32_t iniTicks, bool initBuff = false, uint32_t initSubId = 0);

	bool startCondition(std::shared_ptr<Creature> creature) override;
	void endCondition(std::shared_ptr<Creature> creature) override;
	void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> addCondition) override;
	bool executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) override;

	bool setParam(ConditionParam_t param, int32_t value) override;

	uint32_t getHealthTicks(const std::shared_ptr<Creature> &creature) const;
	uint32_t getManaTicks(const std::shared_ptr<Creature> &creature) const;

	std::shared_ptr<Condition> clone() const override;

	// serialization
	void serialize(PropWriteStream &propWriteStream) override;
	bool unserializeProp(ConditionAttr_t attr, PropStream &propStream) override;

private:
	uint32_t internalHealthTicks = 0;
	uint32_t internalManaTicks = 0;

	uint32_t healthTicks = 1000;
	uint32_t manaTicks = 1000;
	uint32_t healthGain = 0;
	uint32_t manaGain = 0;
};

class ConditionManaShield final : public Condition {
public:
	ConditionManaShield(ConditionId_t initId, ConditionType_t initType, int32_t iniTicks, bool initBuff = false, uint32_t initSubId = 0);

	bool startCondition(std::shared_ptr<Creature> creature) override;
	void endCondition(std::shared_ptr<Creature> creature) override;
	void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> addCondition) override;
	std::unordered_set<PlayerIcon> getIcons() const override;

	bool setParam(ConditionParam_t param, int32_t value) override;

	std::shared_ptr<Condition> clone() const override;

	// serialization
	void serialize(PropWriteStream &propWriteStream) override;
	bool unserializeProp(ConditionAttr_t attr, PropStream &propStream) override;

private:
	uint32_t manaShield = 0;
};

class ConditionSoul final : public ConditionGeneric {
public:
	ConditionSoul(ConditionId_t initId, ConditionType_t initType, int32_t iniTicks, bool initBuff = false, uint32_t initSubId = 0);

	void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> addCondition) override;
	bool executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) override;

	bool setParam(ConditionParam_t param, int32_t value) override;

	std::shared_ptr<Condition> clone() const override;

	// serialization
	void serialize(PropWriteStream &propWriteStream) override;
	bool unserializeProp(ConditionAttr_t attr, PropStream &propStream) override;

private:
	uint32_t internalSoulTicks = 0;
	uint32_t soulTicks = 0;
	uint32_t soulGain = 0;
};

class ConditionInvisible final : public ConditionGeneric {
public:
	ConditionInvisible(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff = false, uint32_t initSubId = 0);

	bool startCondition(std::shared_ptr<Creature> creature) override;
	void endCondition(std::shared_ptr<Creature> creature) override;

	std::shared_ptr<Condition> clone() const override;
};

class ConditionDamage final : public Condition {
public:
	ConditionDamage() = default;
	ConditionDamage(ConditionId_t intiId, ConditionType_t initType, bool initBuff = false, uint32_t initSubId = 0);

	static void generateDamageList(int32_t amount, int32_t start, std::list<int32_t> &list);

	bool startCondition(std::shared_ptr<Creature> creature) override;
	bool executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) override;
	void endCondition(std::shared_ptr<Creature> creature) override;
	void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> condition) override;
	std::unordered_set<PlayerIcon> getIcons() const override;

	std::shared_ptr<Condition> clone() const override;

	bool setParam(ConditionParam_t param, int32_t value) override;

	bool addDamage(int32_t rounds, int32_t time, int32_t value);
	bool doForceUpdate() const;
	int32_t getTotalDamage() const;

	// serialization
	void serialize(PropWriteStream &propWriteStream) override;
	bool unserializeProp(ConditionAttr_t attr, PropStream &propStream) override;

private:
	int32_t maxDamage = 0;
	int32_t minDamage = 0;
	int32_t startDamage = 0;
	int32_t periodDamage = 0;
	int32_t periodDamageTick = 0;
	int32_t tickInterval = 2000;

	bool forceUpdate = false;
	bool delayed = false;
	bool field = false;
	uint32_t owner = 0;

	bool init();

	std::list<IntervalInfo> damageList;

	bool getNextDamage(int32_t &damage);
	bool doDamage(const std::shared_ptr<Creature> &creature, int32_t healthChange) const;

	bool updateCondition(const std::shared_ptr<Condition> &addCondition) override;
};

class ConditionFeared final : public Condition {
public:
	ConditionFeared() = default;
	ConditionFeared(ConditionId_t intiId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId);

	bool startCondition(std::shared_ptr<Creature> creature) override;
	bool executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) override;
	void endCondition(std::shared_ptr<Creature> creature) override;
	void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> condition) override;
	std::unordered_set<PlayerIcon> getIcons() const override;

	std::shared_ptr<Condition> clone() const override;

	bool setPositionParam(ConditionParam_t param, const Position &pos) override;

private:
	bool canWalkTo(const std::shared_ptr<Creature> &creature, Position pos, Direction moveDirection) const;
	bool getFleeDirection(const std::shared_ptr<Creature> &creature);
	bool getFleePath(const std::shared_ptr<Creature> &creature, const Position &pos, std::vector<Direction> &dirList);
	bool getRandomDirection(const std::shared_ptr<Creature> &creature, Position pos);
	bool isStuck(const std::shared_ptr<Creature> &creature, Position pos) const;

	std::vector<Direction> m_directionsVector {
		DIRECTION_NORTH,
		DIRECTION_NORTHEAST,
		DIRECTION_EAST,
		DIRECTION_SOUTHEAST,
		DIRECTION_SOUTH,
		DIRECTION_SOUTHWEST,
		DIRECTION_WEST,
		DIRECTION_NORTHWEST
	};

	Position fleeingFromPos; // Caster Position
	uint8_t fleeIndx = 99;
};

class ConditionSpeed final : public Condition {
public:
	ConditionSpeed(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId, int32_t initChangeSpeed);

	bool startCondition(std::shared_ptr<Creature> creature) override;
	bool executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) override;
	void endCondition(std::shared_ptr<Creature> creature) override;
	void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> condition) override;
	std::unordered_set<PlayerIcon> getIcons() const override;

	std::shared_ptr<Condition> clone() const override;

	bool setParam(ConditionParam_t param, int32_t value) override;

	void setFormulaVars(float mina, float minb, float maxa, float maxb);

	// serialization
	void serialize(PropWriteStream &propWriteStream) override;
	bool unserializeProp(ConditionAttr_t attr, PropStream &propStream) override;

private:
	void getFormulaValues(int32_t var, int32_t &min, int32_t &max) const;

	int32_t speedDelta;

	// formula variables
	float mina = 0.0f;
	float minb = 0.0f;
	float maxa = 0.0f;
	float maxb = 0.0f;
};

class ConditionOutfit final : public Condition {
public:
	ConditionOutfit(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff = false, uint32_t initSubId = 0);

	bool startCondition(std::shared_ptr<Creature> creature) override;
	bool executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) override;
	void endCondition(std::shared_ptr<Creature> creature) override;
	void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> condition) override;

	std::shared_ptr<Condition> clone() const override;

	void setOutfit(const Outfit_t &outfit);
	void setLazyMonsterOutfit(const std::string &monsterName);

	// serialization
	void serialize(PropWriteStream &propWriteStream) override;
	bool unserializeProp(ConditionAttr_t attr, PropStream &propStream) override;

private:
	Outfit_t outfit;
	std::string monsterName;
};

class ConditionLight final : public Condition {
public:
	ConditionLight(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId, uint8_t initLightlevel, uint8_t initLightcolor);

	bool startCondition(std::shared_ptr<Creature> creature) override;
	bool executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) override;
	void endCondition(std::shared_ptr<Creature> creature) override;
	void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> addCondition) override;

	std::shared_ptr<Condition> clone() const override;

	bool setParam(ConditionParam_t param, int32_t value) override;

	// serialization
	void serialize(PropWriteStream &propWriteStream) override;
	bool unserializeProp(ConditionAttr_t attr, PropStream &propStream) override;

private:
	LightInfo lightInfo { 1, 215 };
	uint32_t internalLightTicks = 0;
	uint32_t lightChangeInterval = 0;
};

class ConditionSpellCooldown final : public ConditionGeneric {
public:
	ConditionSpellCooldown(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff = false, uint32_t initSubId = 0);

	bool startCondition(std::shared_ptr<Creature> creature) override;
	void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> condition) override;

	std::shared_ptr<Condition> clone() const override;
};

class ConditionSpellGroupCooldown final : public ConditionGeneric {
public:
	ConditionSpellGroupCooldown(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff = false, uint32_t initSubId = 0);

	bool startCondition(std::shared_ptr<Creature> creature) override;
	void addCondition(std::shared_ptr<Creature> creature, std::shared_ptr<Condition> condition) override;

	std::shared_ptr<Condition> clone() const override;
};
