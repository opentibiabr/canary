/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/global/baseevents.hpp"
#include "creatures/combat/condition.hpp"
#include "declarations.hpp"
#include "map/map.hpp"

class Condition;
class Creature;
class Item;
class Spell;
class Player;
class MatrixArea;
class Weapon;

// for luascript callback
class ValueCallback final : public CallBack {
public:
	explicit ValueCallback(formulaType_t initType) :
		type(initType) { }

	/**
	 * @brief Get the magic level skill for the player.
	 *
	 * @param player The player for which to calculate the magic level skill.
	 * @param damage The combat damage information.
	 * @return The magic level skill of the player.
	 */
	uint32_t getMagicLevelSkill(std::shared_ptr<Player> player, const CombatDamage &damage) const;
	void getMinMaxValues(std::shared_ptr<Player> player, CombatDamage &damage, bool useCharges) const;

private:
	formulaType_t type;
};

class TileCallback final : public CallBack {
public:
	void onTileCombat(std::shared_ptr<Creature> creature, std::shared_ptr<Tile> tile) const;

protected:
	formulaType_t type;
};

class TargetCallback final : public CallBack {
public:
	void onTargetCombat(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) const;

protected:
	formulaType_t type;
};

class ChainCallback final : public CallBack {
public:
	ChainCallback() = default;
	ChainCallback(uint8_t &chainTargets, uint8_t &chainDistance, bool &backtracking) :
		m_chainDistance(chainDistance), m_chainTargets(chainTargets), m_backtracking(backtracking) { }

	void getChainValues(const std::shared_ptr<Creature> &creature, uint8_t &maxTargets, uint8_t &chainDistance, bool &backtracking);
	void setFromLua(bool fromLua) {
		m_fromLua = fromLua;
	}

private:
	void onChainCombat(std::shared_ptr<Creature> creature, uint8_t &chainTargets, uint8_t &chainDistance, bool &backtracking);

	uint8_t m_chainDistance = 0;
	uint8_t m_chainTargets = 0;
	bool m_backtracking = false;
	bool m_fromLua = false;
};

class ChainPickerCallback final : public CallBack {
public:
	bool onChainCombat(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) const;
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
	MatrixArea(uint32_t initRows, uint32_t initCols) :
		centerX(0), centerY(0), rows(initRows), cols(initCols) {
		data_ = new bool*[rows];

		for (uint32_t row = 0; row < rows; ++row) {
			data_[row] = new bool[cols];

			for (uint32_t col = 0; col < cols; ++col) {
				data_[row][col] = false;
			}
		}
	}

	MatrixArea(const MatrixArea &rhs) {
		centerX = rhs.centerX;
		centerY = rhs.centerY;
		rows = rhs.rows;
		cols = rhs.cols;

		data_ = new bool*[rows];

		for (uint32_t row = 0; row < rows; ++row) {
			data_[row] = new bool[cols];

			for (uint32_t col = 0; col < cols; ++col) {
				data_[row][col] = rhs.data_[row][col];
			}
		}
	}

	~MatrixArea() {
		for (uint32_t row = 0; row < rows; ++row) {
			delete[] data_[row];
		}

		delete[] data_;
	}

	std::unique_ptr<MatrixArea> clone() const {
		return std::make_unique<MatrixArea>(*this);
	}

	// non-assignable
	MatrixArea &operator=(const MatrixArea &) = delete;

	void setValue(uint32_t row, uint32_t col, bool value) {
		if (row < rows && col < cols) {
			data_[row][col] = value;
		} else {
			g_logger().error("[{}] Access exceeds the upper limit of memory block");
			throw std::out_of_range("Access exceeds the upper limit of memory block");
		}
	}
	bool getValue(uint32_t row, uint32_t col) const {
		return data_[row][col];
	}

	void setCenter(uint32_t y, uint32_t x) {
		centerX = x;
		centerY = y;
	}
	void getCenter(uint32_t &y, uint32_t &x) const {
		x = centerX;
		y = centerY;
	}

	uint32_t getRows() const {
		return rows;
	}
	uint32_t getCols() const {
		return cols;
	}

	const bool* operator[](uint32_t i) const {
		return data_[i];
	}
	bool* operator[](uint32_t i) {
		return data_[i];
	}

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
	~AreaCombat() {
		clear();
	}

	// non-assignable
	AreaCombat &operator=(const AreaCombat &) = delete;

	void getList(const Position &centerPos, const Position &targetPos, std::vector<std::shared_ptr<Tile>> &list) const;

	void setupArea(const std::list<uint32_t> &list, uint32_t rows);
	void setupArea(int32_t length, int32_t spread);
	void setupArea(int32_t radius);
	void setupExtArea(const std::list<uint32_t> &list, uint32_t rows);
	void clear();

	std::unique_ptr<AreaCombat> clone() const {
		return std::make_unique<AreaCombat>(*this);
	}

private:
	std::unique_ptr<MatrixArea> createArea(const std::list<uint32_t> &list, uint32_t rows);
	void copyArea(const std::unique_ptr<MatrixArea> &input, const std::unique_ptr<MatrixArea> &output, MatrixOperation_t op) const;

	const std::unique_ptr<MatrixArea> &getArea(const Position &centerPos, const Position &targetPos) const {
		int32_t dx = Position::getOffsetX(targetPos, centerPos);
		int32_t dy = Position::getOffsetY(targetPos, centerPos);

		Direction dir;
		if (dx < 0) {
			dir = DIRECTION_WEST;
		} else if (dx > 0) {
			dir = DIRECTION_EAST;
		} else if (dy < 0) {
			dir = DIRECTION_NORTH;
		} else {
			dir = DIRECTION_SOUTH;
		}

		if (hasExtArea) {
			if (dx < 0 && dy < 0) {
				dir = DIRECTION_NORTHWEST;
			} else if (dx > 0 && dy < 0) {
				dir = DIRECTION_NORTHEAST;
			} else if (dx < 0 && dy > 0) {
				dir = DIRECTION_SOUTHWEST;
			} else if (dx > 0 && dy > 0) {
				dir = DIRECTION_SOUTHEAST;
			}
		}

		return areas[dir];
	}

	std::array<std::unique_ptr<MatrixArea>, Direction::DIRECTION_LAST + 1> areas {};
	bool hasExtArea = false;
};

class Combat {
public:
	Combat() = default;

	// non-copyable
	Combat(const Combat &) = delete;
	Combat &operator=(const Combat &) = delete;

	static void applyExtensions(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, CombatDamage &damage, const CombatParams &params);

	static void doCombatHealth(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, CombatDamage &damage, const CombatParams &params);
	static void doCombatHealth(std::shared_ptr<Creature> caster, const Position &position, const std::unique_ptr<AreaCombat> &area, CombatDamage &damage, const CombatParams &params);

	static void doCombatMana(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, CombatDamage &damage, const CombatParams &params);
	static void doCombatMana(std::shared_ptr<Creature> caster, const Position &position, const std::unique_ptr<AreaCombat> &area, CombatDamage &damage, const CombatParams &params);

	static void doCombatCondition(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params);
	static void doCombatCondition(std::shared_ptr<Creature> caster, const Position &position, const std::unique_ptr<AreaCombat> &area, const CombatParams &params);

	static void doCombatDispel(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params);
	static void doCombatDispel(std::shared_ptr<Creature> caster, const Position &position, const std::unique_ptr<AreaCombat> &area, const CombatParams &params);

	static void getCombatArea(const Position &centerPos, const Position &targetPos, const std::unique_ptr<AreaCombat> &area, std::vector<std::shared_ptr<Tile>> &list);

	static bool isInPvpZone(std::shared_ptr<Creature> attacker, std::shared_ptr<Creature> target);
	static bool isProtected(std::shared_ptr<Player> attacker, std::shared_ptr<Player> target);
	static bool isPlayerCombat(std::shared_ptr<Creature> target);
	static CombatType_t ConditionToDamageType(ConditionType_t type);
	static ConditionType_t DamageToConditionType(CombatType_t type);
	static ReturnValue canTargetCreature(std::shared_ptr<Player> attacker, std::shared_ptr<Creature> target);
	static ReturnValue canDoCombat(std::shared_ptr<Creature> caster, std::shared_ptr<Tile> tile, bool aggressive);
	static ReturnValue canDoCombat(std::shared_ptr<Creature> attacker, std::shared_ptr<Creature> target, bool aggressive);
	static void postCombatEffects(std::shared_ptr<Creature> caster, const Position &origin, const Position &pos, const CombatParams &params);

	static void addDistanceEffect(std::shared_ptr<Creature> caster, const Position &fromPos, const Position &toPos, uint16_t effect);

	bool doCombat(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target) const;
	bool doCombat(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const Position &origin, int affected = 1) const;
	bool doCombat(std::shared_ptr<Creature> caster, const Position &pos) const;

	bool setCallback(CallBackParam_t key);
	void setChainCallback(uint8_t chainTargets, uint8_t chainDistance, bool backtracking);
	CallBack* getCallback(CallBackParam_t key);

	bool setParam(CombatParam_t param, uint32_t value);
	void setArea(std::unique_ptr<AreaCombat> &newArea) {
		this->area = std::move(newArea);
	}
	bool hasArea() const {
		return area != nullptr;
	}
	void addCondition(const std::shared_ptr<Condition> condition) {
		params.conditionList.emplace_back(condition);
	}
	void setPlayerCombatValues(formulaType_t formulaType, double mina, double minb, double maxa, double maxb);
	void postCombatEffects(std::shared_ptr<Creature> caster, const Position &origin, const Position &pos) const {
		postCombatEffects(std::move(caster), origin, pos, params);
	}

	void setOrigin(CombatOrigin origin) {
		params.origin = origin;
	}

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
	bool doCombatChain(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, bool aggressive) const;

private:
	static void doChainEffect(const Position &origin, const Position &pos, uint8_t effect);
	static std::vector<std::pair<Position, std::vector<uint32_t>>> pickChainTargets(std::shared_ptr<Creature> caster, const CombatParams &params, uint8_t chainDistance, uint8_t maxTargets, bool aggressive, bool backtracking, std::shared_ptr<Creature> initialTarget = nullptr);
	static bool isValidChainTarget(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> currentTarget, std::shared_ptr<Creature> potentialTarget, const CombatParams &params, bool aggressive);

	static void doCombatDefault(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params);

	static void doCombatHealth(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const Position &origin, CombatDamage &damage, const CombatParams &params);
	static void doCombatMana(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const Position &origin, CombatDamage &damage, const CombatParams &params);
	static void doCombatDefault(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const Position &origin, const CombatParams &params);

	static void CombatFunc(std::shared_ptr<Creature> caster, const Position &origin, const Position &pos, const std::unique_ptr<AreaCombat> &area, const CombatParams &params, CombatFunction func, CombatDamage* data);

	static void CombatHealthFunc(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params, CombatDamage* data);
	static CombatDamage applyImbuementElementalDamage(std::shared_ptr<Player> attackerPlayer, std::shared_ptr<Item> item, CombatDamage damage);
	static void CombatManaFunc(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params, CombatDamage* damage);
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
	static bool checkFearConditionAffected(std::shared_ptr<Player> player);
	static void CombatConditionFunc(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params, CombatDamage* data);
	static void CombatDispelFunc(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params, CombatDamage* data);
	static void CombatNullFunc(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params, CombatDamage* data);

	static void combatTileEffects(const CreatureVector &spectators, std::shared_ptr<Creature> caster, std::shared_ptr<Tile> tile, const CombatParams &params);

	/**
	 * @brief Calculate the level formula for combat.
	 *
	 * @param player The player involved in combat.
	 * @param wheelSpell The wheel spell being used.
	 * @param damage The combat damage.
	 * @return The calculated level formula.
	 */
	int32_t getLevelFormula(std::shared_ptr<Player> player, std::shared_ptr<Spell> wheelSpell, const CombatDamage &damage) const;
	CombatDamage getCombatDamage(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) const;

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
	explicit MagicField(uint16_t type) :
		Item(type), createTime(OTSYS_TIME()) { }

	std::shared_ptr<MagicField> getMagicField() override {
		return static_self_cast<MagicField>();
	}

	bool isReplaceable() const {
		return Item::items[getID()].replaceable;
	}
	CombatType_t getCombatType() const {
		const ItemType &it = items[getID()];
		return it.combatType;
	}
	int32_t getDamage() const {
		const ItemType &it = items[getID()];
		if (it.conditionDamage) {
			return it.conditionDamage->getTotalDamage();
		}
		return 0;
	}
	void onStepInField(const std::shared_ptr<Creature> &creature);

private:
	int64_t createTime;
};
