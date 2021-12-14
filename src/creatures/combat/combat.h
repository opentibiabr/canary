/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#ifndef SRC_CREATURES_COMBAT_COMBAT_H_
#define SRC_CREATURES_COMBAT_COMBAT_H_

#include "lua/global/baseevents.h"
#include "creatures/combat/condition.h"
#include "declarations.hpp"
#include "map/map.h"

class Condition;
class Creature;
class Item;

// for luascript callback
class ValueCallback final : public CallBack {
	public:
		explicit ValueCallback(formulaType_t initType) :
			type(initType) { }
		void getMinMaxValues(Player* player, CombatDamage &damage, bool useCharges) const;

	private:
		formulaType_t type;
};

class TileCallback final : public CallBack {
	public:
		void onTileCombat(Creature* creature, Tile* tile) const;

	protected:
		formulaType_t type;
};

class TargetCallback final : public CallBack {
	public:
		void onTargetCombat(Creature* creature, Creature* target) const;

	protected:
		formulaType_t type;
};

struct CombatParams {
		std::vector<std::unique_ptr<const Condition>> conditionList;

		std::unique_ptr<ValueCallback> valueCallback;
		std::unique_ptr<TileCallback> tileCallback;
		std::unique_ptr<TargetCallback> targetCallback;

		uint16_t itemId = 0;

		ConditionType_t dispelType = CONDITION_NONE;
		CombatType_t combatType = COMBAT_NONE;
		CombatOrigin origin = ORIGIN_SPELL;

		uint8_t impactEffect = CONST_ME_NONE;
		uint8_t distanceEffect = CONST_ANI_NONE;

		bool blockedByArmor = false;
		bool blockedByShield = false;
		bool targetCasterOrTopMost = false;
		bool aggressive = true;
		bool useCharges = false;
		bool directionalArea = false;
};

using CombatFunction = std::function<void(Creature*, Creature*, const CombatParams &, CombatDamage*)>;

class MatrixArea {
	public:
		typedef std::conditional<8 < sizeof(size_t), uint32_t, uint64_t>::type _Ty;
		enum : ptrdiff_t {
			_Bitsperword = static_cast<ptrdiff_t>(CHAR_BIT * sizeof(_Ty)),
		};

		MatrixArea() = default;

		// non-copyable
		MatrixArea(const MatrixArea &) = delete;
		MatrixArea &operator=(const MatrixArea &) = delete;

		// non-moveable
		MatrixArea(const MatrixArea &&) = delete;
		MatrixArea &operator=(const MatrixArea &&) = delete;

		~MatrixArea() {
			delete[] data_;
		}

		void setupArea(uint32_t rows, uint32_t cols) {
			delete[] data_;

			this->centerX = 0;
			this->centerY = 0;
			this->rows = rows;
			this->cols = cols;
			data_ = new _Ty[(((rows * cols) - 1) / _Bitsperword) + 1];
			for (uint32_t i = 0; i < (rows * cols); i += _Bitsperword) {
				data_[i / _Bitsperword] = 0;
			}
		}

		void clear() {
			delete[] data_;
			data_ = nullptr;
		}

		void setValue(uint32_t row, uint32_t col, bool value) const {
			uint32_t index = (row * cols) + col;
			if (value) {
				data_[index / _Bitsperword] |= (static_cast<_Ty>(1) << (index % _Bitsperword));
			} else {
				data_[index / _Bitsperword] &= ~(static_cast<_Ty>(1) << (index % _Bitsperword));
			}
		}
		bool getValue(uint32_t row, uint32_t col) const {
			uint32_t index = (row * cols) + col;
			return ((data_[index / _Bitsperword] & (static_cast<_Ty>(1) << (index % _Bitsperword))) != 0);
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

		bool isInitialized() const {
			return data_;
		}

	private:
		_Ty* data_ = nullptr; // It would actually be great if we can have that in-house but we don't know how much data we'll need

		uint32_t centerX;
		uint32_t centerY;

		uint32_t rows;
		uint32_t cols;
};

class AreaCombat {
	public:
		AreaCombat() = default;

		AreaCombat(const AreaCombat &rhs);

		// non-assignable
		AreaCombat &operator=(const AreaCombat &) = delete;

		void getList(const Position &centerPos, const Position &targetPos, const Position &sightLinePos, std::vector<Tile*> &list) const;

		void setupArea(const std::list<uint32_t> &list, uint32_t rows);
		void setupArea(int32_t length, int32_t spread);
		void setupArea(int32_t radius);
		void setupExtArea(const std::list<uint32_t> &list, uint32_t rows);
		void clear();

	private:
		MatrixArea* createArea(Direction dir, const std::list<uint32_t> &list, uint32_t rows);
		void copyArea(const MatrixArea* input, MatrixArea* output, MatrixOperation_t op) const;

		MatrixArea* getArea(const Position &centerPos, const Position &targetPos) const {
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

			const MatrixArea &area = areas[dir];
			if (area.isInitialized()) {
				return const_cast<MatrixArea*>(&area);
			}
			return nullptr;
		}

		MatrixArea areas[DIRECTION_LAST + 1];
		bool hasExtArea = false;
};

class Combat {
	public:
		Combat() = default;

		// non-copyable
		Combat(const Combat &) = delete;
		Combat &operator=(const Combat &) = delete;

		static void doCombatHealth(Creature* caster, Creature* target, CombatDamage &damage, const CombatParams &params);
		static void doCombatHealth(Creature* caster, const Position &position, const AreaCombat* area, CombatDamage &damage, const CombatParams &params);

		static void doCombatMana(Creature* caster, Creature* target, CombatDamage &damage, const CombatParams &params);
		static void doCombatMana(Creature* caster, const Position &position, const AreaCombat* area, CombatDamage &damage, const CombatParams &params);

		static void doCombatCondition(Creature* caster, Creature* target, const CombatParams &params);
		static void doCombatCondition(Creature* caster, const Position &position, const AreaCombat* area, const CombatParams &params);

		static void doCombatDispel(Creature* caster, Creature* target, const CombatParams &params);
		static void doCombatDispel(Creature* caster, const Position &position, const AreaCombat* area, const CombatParams &params);

		static void getCombatArea(const Position &centerPos, const Position &targetPos, const AreaCombat* area, std::vector<Tile*> &list, bool directionalArea);

		static bool isInPvpZone(const Creature* attacker, const Creature* target);
		static bool isProtected(const Player* attacker, const Player* target);
		static bool isPlayerCombat(const Creature* target);
		static CombatType_t ConditionToDamageType(ConditionType_t type);
		static ConditionType_t DamageToConditionType(CombatType_t type);
		static ReturnValue canTargetCreature(Player* attacker, Creature* target);
		static ReturnValue canDoCombat(Creature* caster, Tile* tile, bool aggressive);
		static ReturnValue canDoCombat(Creature* attacker, Creature* target);
		static void postCombatEffects(Creature* caster, const Position &pos, const CombatParams &params);

		static void addDistanceEffect(Creature* caster, const Position &fromPos, const Position &toPos, uint8_t effect);

		void doCombat(Creature* caster, Creature* target) const;
		void doCombat(Creature* caster, const Position &pos) const;

		bool setCallback(CallBackParam_t key);
		CallBack* getCallback(CallBackParam_t key);

		bool setParam(CombatParam_t param, uint32_t value);
		void setArea(AreaCombat* newArea) {
			this->area.reset(newArea);
		}
		bool hasArea() const {
			return area != nullptr;
		}
		void addCondition(const Condition* condition) {
			params.conditionList.emplace_back(condition);
			params.conditionList.shrink_to_fit();
		}
		void setPlayerCombatValues(formulaType_t formulaType, double mina, double minb, double maxa, double maxb);
		void postCombatEffects(Creature* caster, const Position &pos) const {
			postCombatEffects(caster, pos, params);
		}

		void setOrigin(CombatOrigin origin) {
			params.origin = origin;
		}

		void setDirectionArea(bool directionalArea) {
			params.directionalArea = directionalArea;
		}

	private:
		static void doCombatDefault(Creature* caster, Creature* target, const CombatParams &params);

		static void CombatFunc(Creature* caster, const Position &pos, const AreaCombat* area, const CombatParams &params, CombatFunction func, CombatDamage* data);

		static void CombatHealthFunc(Creature* caster, Creature* target, const CombatParams &params, CombatDamage* data);
		static CombatDamage applyImbuementElementalDamage(Item* item, CombatDamage damage);
		static void CombatManaFunc(Creature* caster, Creature* target, const CombatParams &params, CombatDamage* damage);
		static void CombatConditionFunc(Creature* caster, Creature* target, const CombatParams &params, CombatDamage* data);
		static void CombatDispelFunc(Creature* caster, Creature* target, const CombatParams &params, CombatDamage* data);
		static void CombatNullFunc(Creature* caster, Creature* target, const CombatParams &params, CombatDamage* data);

		static void combatTileEffects(const SpectatorVector &spectators, Creature* caster, Tile* tile, const CombatParams &params);
		CombatDamage getCombatDamage(Creature* creature, Creature* target) const;

		// configureable
		CombatParams params;

		// formula variables
		formulaType_t formulaType = COMBAT_FORMULA_UNDEFINED;
		double mina = 0.0;
		double minb = 0.0;
		double maxa = 0.0;
		double maxb = 0.0;

		std::unique_ptr<AreaCombat> area;
};

class MagicField final : public Item {
	public:
		explicit MagicField(uint16_t type) :
			Item(type), createTime(OTSYS_TIME()) { }

		MagicField* getMagicField() override {
			return this;
		}
		const MagicField* getMagicField() const override {
			return this;
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
		void onStepInField(Creature &creature);

	private:
		int64_t createTime;
};

#endif // SRC_CREATURES_COMBAT_COMBAT_H_
