/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/item.hpp"
#include "lua/global/baseevents.hpp"

class Condition;
class Creature;
class Spell;
class Player;
class MatrixArea;
class Weapon;
class Tile;

using CreatureVector = std::vector<std::shared_ptr<Creature>>;

// for luascript callback
class ValueCallback final : public CallBack {
public:
	explicit ValueCallback(formulaType_t initType);

	/**
	 * @brief Get the magic level skill for the player.
	 *
	 * @param player The player for which to calculate the magic level skill.
	 * @param damage The combat damage information.
	 * @return The magic level skill of the player.
	 */
	uint32_t getMagicLevelSkill(const std::shared_ptr<Player> &player, const CombatDamage &damage) const;
	void getMinMaxValues(const std::shared_ptr<Player> &player, CombatDamage &damage, bool useCharges) const;

private:
	formulaType_t type {};
};

class TileCallback final : public CallBack {
public:
	void onTileCombat(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &tile) const;

protected:
	formulaType_t type {};
};

class TargetCallback final : public CallBack {
public:
	void onTargetCombat(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) const;

protected:
	formulaType_t type {};
};

class ChainCallback final : public CallBack {
public:
	ChainCallback() = default;
	ChainCallback(const uint8_t &chainTargets, const uint8_t &chainDistance, const bool &backtracking);

	void getChainValues(const std::shared_ptr<Creature> &creature, uint8_t &maxTargets, uint8_t &chainDistance, bool &backtracking);
	void setFromLua(bool fromLua);

private:
	void onChainCombat(const std::shared_ptr<Creature> &creature, uint8_t &chainTargets, uint8_t &chainDistance, bool &backtracking) const;

	uint8_t m_chainDistance = 0;
	uint8_t m_chainTargets = 0;
	bool m_backtracking = false;
	bool m_fromLua = false;
};

class ChainPickerCallback final : public CallBack {
public:
	bool onChainCombat(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) const;
};

struct CombatParams {
	std::vector<std::shared_ptr<Condition>> conditionList;

	std::unique_ptr<ValueCallback> valueCallback;
	std::unique_ptr<TileCallback> tileCallback;
	std::unique_ptr<TargetCallback> targetCallback;
	std::unique_ptr<ChainCallback> chainCallback;
	std::unique_ptr<ChainPickerCallback> chainPickerCallback;

	uint16_t itemId = 0;

	ConditionType_t dispelType = CONDITION_NONE;
	CombatType_t combatType = COMBAT_NONE;
	CombatOrigin origin = ORIGIN_SPELL;

	uint16_t impactEffect = CONST_ME_NONE;
	SoundEffect_t soundImpactEffect = SoundEffect_t::SILENCE;

	uint16_t distanceEffect = CONST_ANI_NONE;
	SoundEffect_t soundCastEffect = SoundEffect_t::SILENCE;

	bool blockedByArmor = false;
	bool blockedByShield = false;
	bool targetCasterOrTopMost = false;
	bool aggressive = true;
	bool useCharges = false;

	uint8_t chainEffect = CONST_ME_NONE;
};

using CombatFunction = std::function<void(std::shared_ptr<Creature>, std::shared_ptr<Creature>, const CombatParams &, CombatDamage*)>;

class MatrixArea {
public:
	MatrixArea(uint32_t initRows, uint32_t initCols);

	MatrixArea(const MatrixArea &rhs);

	~MatrixArea();

	std::unique_ptr<MatrixArea> clone() const;

	// non-assignable
	MatrixArea &operator=(const MatrixArea &) = delete;

	void setValue(uint32_t row, uint32_t col, bool value) const;
	bool getValue(uint32_t row, uint32_t col) const;

	void setCenter(uint32_t y, uint32_t x);
	void getCenter(uint32_t &y, uint32_t &x) const;

	uint32_t getRows() const;
	uint32_t getCols() const;

	const bool* operator[](uint32_t i) const;
	bool* operator[](uint32_t i);

private:
	uint32_t centerX;
	uint32_t centerY;

	uint32_t rows;
	uint32_t cols;
	bool** data_;
};

class AreaCombat {
public:
	AreaCombat() = default;

	AreaCombat(const AreaCombat &rhs);
	~AreaCombat();

	// non-assignable
	AreaCombat &operator=(const AreaCombat &) = delete;

	void getList(const Position &centerPos, const Position &targetPos, std::vector<std::shared_ptr<Tile>> &list, const Direction dir) const;

	void setupArea(const std::list<uint32_t> &list, uint32_t rows);
	void setupArea(int32_t length, int32_t spread);
	void setupArea(int32_t radius);
	void setupExtArea(const std::list<uint32_t> &list, uint32_t rows);
	void clear();

	std::unique_ptr<AreaCombat> clone() const;

private:
	std::unique_ptr<MatrixArea> createArea(const std::list<uint32_t> &list, uint32_t rows);
	void copyArea(const std::unique_ptr<MatrixArea> &input, const std::unique_ptr<MatrixArea> &output, MatrixOperation_t op) const;

	const std::unique_ptr<MatrixArea> &getArea(const Position &centerPos, const Position &targetPos) const;

	std::array<std::unique_ptr<MatrixArea>, Direction::DIRECTION_LAST + 1> areas {};
	bool hasExtArea = false;
};

class Combat {
public:
	Combat() = default;

	// non-copyable
	Combat(const Combat &) = delete;
	Combat &operator=(const Combat &) = delete;

	static void applyExtensions(const std::shared_ptr<Creature> &caster, const std::vector<std::shared_ptr<Creature>> targets, CombatDamage &damage, const CombatParams &params);

	static void doCombatHealth(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, CombatDamage &damage, const CombatParams &params);
	static void doCombatHealth(const std::shared_ptr<Creature> &caster, const Position &position, const std::unique_ptr<AreaCombat> &area, CombatDamage &damage, const CombatParams &params);

	static void doCombatMana(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, CombatDamage &damage, const CombatParams &params);
	static void doCombatMana(const std::shared_ptr<Creature> &caster, const Position &position, const std::unique_ptr<AreaCombat> &area, CombatDamage &damage, const CombatParams &params);

	static void doCombatCondition(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, const CombatParams &params);
	static void doCombatCondition(const std::shared_ptr<Creature> &caster, const Position &position, const std::unique_ptr<AreaCombat> &area, const CombatParams &params);

	static void doCombatDispel(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, const CombatParams &params);
	static void doCombatDispel(const std::shared_ptr<Creature> &caster, const Position &position, const std::unique_ptr<AreaCombat> &area, const CombatParams &params);

	static void getCombatArea(const Position &centerPos, const Position &targetPos, const std::unique_ptr<AreaCombat> &area, std::vector<std::shared_ptr<Tile>> &list);

	static bool isInPvpZone(const std::shared_ptr<Creature> &attacker, const std::shared_ptr<Creature> &target);
	static bool isProtected(const std::shared_ptr<Player> &attacker, const std::shared_ptr<Player> &target);
	static bool isPlayerCombat(const std::shared_ptr<Creature> &target);
	static CombatType_t ConditionToDamageType(ConditionType_t type);
	static ConditionType_t DamageToConditionType(CombatType_t type);
	static ReturnValue canTargetCreature(const std::shared_ptr<Player> &attacker, const std::shared_ptr<Creature> &target);
	static ReturnValue canDoCombat(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Tile> &tile, bool aggressive);
	static ReturnValue canDoCombat(const std::shared_ptr<Creature> &attacker, const std::shared_ptr<Creature> &target, bool aggressive);
	static void postCombatEffects(const std::shared_ptr<Creature> &caster, const Position &origin, const Position &pos, const CombatParams &params);

	static void addDistanceEffect(const std::shared_ptr<Creature> &caster, const Position &fromPos, const Position &toPos, uint16_t effect);

	bool doCombat(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target) const;
	bool doCombat(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, const Position &origin, int affected = 1) const;
	bool doCombat(const std::shared_ptr<Creature> &caster, const Position &pos) const;

	bool setCallback(CallBackParam_t key);
	void setChainCallback(uint8_t chainTargets, uint8_t chainDistance, bool backtracking);
	CallBack* getCallback(CallBackParam_t key) const;

	bool setParam(CombatParam_t param, uint32_t value);
	void setArea(std::unique_ptr<AreaCombat> &newArea);
	bool hasArea() const;
	void addCondition(const std::shared_ptr<Condition> &condition);
	void setPlayerCombatValues(formulaType_t formulaType, double mina, double minb, double maxa, double maxb);
	void postCombatEffects(const std::shared_ptr<Creature> &caster, const Position &origin, const Position &pos) const;

	void setOrigin(CombatOrigin origin);

	/**
	 * @brief Sets the name of the instant spell.
	 *
	 * @param value The name of the instant spell to be set.
	 */
	void setInstantSpellName(const std::string &value);

	/**
	 * @brief Sets the name of the rune spell.
	 *
	 * @param value The name of the rune spell to be set.
	 */
	void setRuneSpellName(const std::string &value);

	void setupChain(const std::shared_ptr<Weapon> &weapon);
	bool doCombatChain(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, bool aggressive) const;

private:
	static void doChainEffect(const Position &origin, const Position &pos, uint8_t effect);
	static std::vector<std::pair<Position, std::vector<uint32_t>>> pickChainTargets(const std::shared_ptr<Creature> &caster, const CombatParams &params, uint8_t chainDistance, uint8_t maxTargets, bool aggressive, bool backtracking, const std::shared_ptr<Creature> &initialTarget = nullptr);
	static bool isValidChainTarget(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &currentTarget, const std::shared_ptr<Creature> &potentialTarget, const CombatParams &params, bool aggressive);

	static void doCombatDefault(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, const CombatParams &params);

	static void doCombatHealth(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, const Position &origin, CombatDamage &damage, const CombatParams &params);
	static void doCombatMana(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, const Position &origin, CombatDamage &damage, const CombatParams &params);
	static void doCombatDefault(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, const Position &origin, const CombatParams &params);

	static void CombatFunc(const std::shared_ptr<Creature> &caster, const Position &origin, const Position &pos, const std::unique_ptr<AreaCombat> &area, const CombatParams &params, const CombatFunction &func, CombatDamage* data);

	static void CombatHealthFunc(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, const CombatParams &params, CombatDamage* data);
	static CombatDamage applyImbuementElementalDamage(const std::shared_ptr<Player> &attackerPlayer, std::shared_ptr<Item> item, CombatDamage damage);
	static void CombatManaFunc(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, const CombatParams &params, CombatDamage* damage);
	/**
	 * @brief Checks if a fear condition can be applied to a player.
	 *
	 * This function performs several checks to determine if a fear condition
	 * can be applied to a player. It considers the following scenarios:
	 *
	 * - The player is currently immune to fear.
	 * - The player already has a fear condition.
	 * - The player is part of a party, and there are already enough party members
	 *   with a fear condition according to the party size.
	 *
	 * @param player Pointer to the Player object to be checked.
	 * @return true if the fear condition can be applied, false otherwise.
	 */
	static bool checkFearConditionAffected(const std::shared_ptr<Player> &player);
	static void CombatConditionFunc(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, const CombatParams &params, CombatDamage* data);
	static void CombatDispelFunc(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, const CombatParams &params, CombatDamage* data);
	static void CombatNullFunc(const std::shared_ptr<Creature> &caster, const std::shared_ptr<Creature> &target, const CombatParams &params, CombatDamage* data);

	static void combatTileEffects(const CreatureVector &spectators, const std::shared_ptr<Creature> &caster, const std::shared_ptr<Tile> &tile, const CombatParams &params);

	/**
	 * @brief Calculate the level formula for combat.
	 *
	 * @param player The player involved in combat.
	 * @param wheelSpell The wheel spell being used.
	 * @param damage The combat damage.
	 * @return The calculated level formula.
	 */
	int32_t getLevelFormula(const std::shared_ptr<Player> &player, const std::shared_ptr<Spell> &wheelSpell, const CombatDamage &damage) const;
	CombatDamage getCombatDamage(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) const;

	// configureable
	CombatParams params;

	// formula variables
	formulaType_t formulaType = COMBAT_FORMULA_UNDEFINED;
	double mina = 0.0;
	double minb = 0.0;
	double maxa = 0.0;
	double maxb = 0.0;

	std::unique_ptr<AreaCombat> area;

	std::string runeSpellName;
	std::string instantSpellName;
};

class MagicField final : public Item {
public:
	explicit MagicField(uint16_t type);

	std::shared_ptr<MagicField> getMagicField() override;

	bool isReplaceable() const;
	CombatType_t getCombatType() const;
	int32_t getDamage() const;
	void onStepInField(const std::shared_ptr<Creature> &creature);

private:
	int64_t createTime;
};
