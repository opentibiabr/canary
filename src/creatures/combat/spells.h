/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_CREATURES_COMBAT_SPELLS_H_
#define SRC_CREATURES_COMBAT_SPELLS_H_

#include "lua/scripts/luascript.h"
#include "creatures/players/player.h"
#include "lua/creature/actions.h"
#include "lua/creature/talkaction.h"
#include "lua/scripts/scripts.h"

class InstantSpell;
class RuneSpell;
class Spell;

using VocSpellMap = std::map<uint16_t, bool>;
using InstantSpell_ptr = std::unique_ptr<InstantSpell>;
using RuneSpell_ptr = std::unique_ptr<RuneSpell>;

class Spells final : public Scripts {
	public:
		Spells();
		~Spells();

		// non-copyable
		Spells(const Spells &) = delete;
		Spells &operator=(const Spells &) = delete;

		static Spells &getInstance() {
			// Guaranteed to be destroyed
			static Spells instance;
			// Instantiated on first use
			return instance;
		}

		Spell* getSpellByName(const std::string &name);
		RuneSpell* getRuneSpell(uint32_t id);
		RuneSpell* getRuneSpellByName(const std::string &name);

		InstantSpell* getInstantSpell(const std::string &words);
		InstantSpell* getInstantSpellByName(const std::string &name);

		InstantSpell* getInstantSpellById(uint32_t spellId);

		TalkActionResult_t playerSaySpell(Player* player, std::string &words);

		static Position getCasterPosition(Creature* creature, Direction dir);

		std::list<uint16_t> getSpellsByVocation(uint16_t vocationId);

		const std::map<std::string, InstantSpell> &getInstantSpells() const {
			return instants;
		};

		bool hasInstantSpell(const std::string &word) const;

		void setInstantSpell(const std::string &word, InstantSpell &instant) {
			instants.try_emplace(word, instant);
		}

		void clear();
		bool registerInstantLuaEvent(InstantSpell* event);
		bool registerRuneLuaEvent(RuneSpell* event);

	private:
		std::map<uint16_t, RuneSpell> runes;
		std::map<std::string, InstantSpell> instants;

		friend class CombatSpell;
};

constexpr auto g_spells = &Spells::getInstance;

using RuneSpellFunction = std::function<bool(const RuneSpell* spell, Player* player, const Position &posTo)>;

class BaseSpell {
	public:
		constexpr BaseSpell() = default;
		virtual ~BaseSpell() = default;

		virtual bool castSpell(Creature* creature) = 0;
		virtual bool castSpell(Creature* creature, Creature* target) = 0;
};

class CombatSpell final : public Script, public BaseSpell {
	public:
		// Constructor
		CombatSpell(Combat* newCombat, bool newNeedTarget, bool newNeedDirection);

		// The copy constructor and the assignment operator have been deleted to prevent accidental copying.
		CombatSpell(const CombatSpell &) = delete;
		CombatSpell &operator=(const CombatSpell &) = delete;

		bool castSpell(Creature* creature) override;
		bool castSpell(Creature* creature, Creature* target) override;

		// Scripting spell
		bool executeCastSpell(Creature* creature, const LuaVariant &var) const;

		bool loadScriptCombat();
		Combat* getCombat() {
			return combat;
		}

	private:
		std::string getScriptTypeName() const override {
			return "onCastSpell";
		}

		Combat* combat;

		bool needDirection;
		bool needTarget;
};

class Spell : public BaseSpell {
	public:
		Spell() = default;

		const std::string &getName() const {
			return name;
		}
		void setName(std::string n) {
			name = n;
		}
		uint16_t getId() const {
			return spellId;
		}
		void setId(uint16_t id) {
			spellId = id;
		}

		void postCastSpell(Player* player, bool finishedCast = true, bool payCost = true) const;
		static void postCastSpell(Player* player, uint32_t manaCost, uint32_t soulCost);
		virtual bool isInstant() const = 0;

		uint32_t getManaCost(const Player* player) const;
		uint32_t getSoulCost() const {
			return soul;
		}
		void setSoulCost(uint32_t s) {
			soul = s;
		}
		uint32_t getLevel() const {
			return level;
		}
		void setLevel(uint32_t lvl) {
			level = lvl;
		}
		uint32_t getMagicLevel() const {
			return magLevel;
		}
		void setMagicLevel(uint32_t lvl) {
			magLevel = lvl;
		}
		uint32_t getMana() const {
			return mana;
		}
		void setMana(uint32_t m) {
			mana = m;
		}
		uint32_t getManaPercent() const {
			return manaPercent;
		}
		void setManaPercent(uint32_t m) {
			manaPercent = m;
		}
		bool isPremium() const {
			return premium;
		}
		void setPremium(bool p) {
			premium = p;
		}
		bool isEnabled() const {
			return enabled;
		}
		void setEnabled(bool e) {
			enabled = e;
		}

		const VocSpellMap &getVocMap() const {
			return vocSpellMap;
		}
		void addVocMap(uint16_t n, bool b) {
			vocSpellMap[n] = b;
		}

		SpellGroup_t getGroup() {
			return group;
		}
		void setGroup(SpellGroup_t g) {
			group = g;
		}
		SpellGroup_t getSecondaryGroup() {
			return secondaryGroup;
		}
		void setSecondaryGroup(SpellGroup_t g) {
			secondaryGroup = g;
		}

		uint32_t getCooldown() const {
			return cooldown;
		}
		void setCooldown(uint32_t cd) {
			cooldown = cd;
		}
		uint32_t getSecondaryCooldown() const {
			return secondaryGroupCooldown;
		}
		void setSecondaryCooldown(uint32_t cd) {
			secondaryGroupCooldown = cd;
		}
		uint32_t getGroupCooldown() const {
			return groupCooldown;
		}
		void setGroupCooldown(uint32_t cd) {
			groupCooldown = cd;
		}

		int32_t getRange() const {
			return range;
		}
		void setRange(int32_t r) {
			range = r;
		}

		bool getNeedTarget() const {
			return needTarget;
		}
		void setNeedTarget(bool n) {
			needTarget = n;
		}
		bool getNeedWeapon() const {
			return needWeapon;
		}
		void setNeedWeapon(bool n) {
			needWeapon = n;
		}
		bool getNeedLearn() const {
			return learnable;
		}
		void setNeedLearn(bool n) {
			learnable = n;
		}
		bool getSelfTarget() const {
			return selfTarget;
		}
		void setSelfTarget(bool s) {
			selfTarget = s;
		}
		bool getBlockingSolid() const {
			return blockingSolid;
		}
		void setBlockingSolid(bool b) {
			blockingSolid = b;
		}
		bool getBlockingCreature() const {
			return blockingCreature;
		}
		void setBlockingCreature(bool b) {
			blockingCreature = b;
		}
		bool getAggressive() const {
			return aggressive;
		}
		void setAggressive(bool a) {
			aggressive = a;
		}
		bool getAllowOnSelf() const {
			return allowOnSelf;
		}
		void setAllowOnSelf(bool s) {
			allowOnSelf = s;
		}
		bool getLockedPZ() const {
			return pzLocked;
		}
		void setLockedPZ(bool b) {
			pzLocked = b;
		}

		// Wheel of destiny - Get:
		bool getWheelOfDestinyUpgraded() const {
			return whellOfDestinyUpgraded;
		}
		int32_t getWheelOfDestinyBoost(WheelOfDestinySpellBoost_t boost, WheelOfDestinySpellGrade_t grade) const {
			int32_t value = 0;
			if (grade >= WHEEL_OF_DESTINY_SPELL_GRADE_REGULAR) {
				value += wheelOfDestinyRegularBoost[boost];
			}
			if (grade >= WHEEL_OF_DESTINY_SPELL_GRADE_UPGRADED) {
				value += wheelOfDestinyUpgradedBoost[boost];
			}
			return value;
		}
		// Wheel of destiny - Set:
		void setWheelOfDestinyUpgraded(bool value) {
			whellOfDestinyUpgraded = value;
		}
		void setWheelOfDestinyBoost(WheelOfDestinySpellBoost_t boost, WheelOfDestinySpellGrade_t grade, int32_t value) {
			if (grade == WHEEL_OF_DESTINY_SPELL_GRADE_REGULAR) {
				wheelOfDestinyRegularBoost[boost] = value;
			} else if (grade == WHEEL_OF_DESTINY_SPELL_GRADE_UPGRADED) {
				wheelOfDestinyUpgradedBoost[boost] = value;
			}
		}

		SpellType_t spellType = SPELL_UNDEFINED;

	protected:
		void applyCooldownConditions(Player* player) const;
		bool playerSpellCheck(Player* player) const;
		bool playerInstantSpellCheck(Player* player, const Position &toPos);
		bool playerRuneSpellCheck(Player* player, const Position &toPos);

		VocSpellMap vocSpellMap;

		SpellGroup_t group = SPELLGROUP_NONE;
		SpellGroup_t secondaryGroup = SPELLGROUP_NONE;

		uint32_t cooldown = 1000;
		uint32_t groupCooldown = 1000;
		uint32_t secondaryGroupCooldown = 0;
		uint32_t level = 0;
		uint32_t magLevel = 0;
		int32_t range = -1;

		uint16_t spellId = 0;

		bool selfTarget = false;
		bool needTarget = false;
		bool allowOnSelf = true;
		bool pzLocked = false;

		bool whellOfDestinyUpgraded = false;
		int32_t wheelOfDestinyRegularBoost[WHEEL_OF_DESTINY_SPELL_BOOST_COUNT] = { 0 };
		int32_t wheelOfDestinyUpgradedBoost[WHEEL_OF_DESTINY_SPELL_BOOST_COUNT] = { 0 };

	private:
		uint32_t mana = 0;
		uint32_t manaPercent = 0;
		uint32_t soul = 0;

		bool needWeapon = false;
		bool blockingSolid = false;
		bool blockingCreature = false;
		bool aggressive = true;
		bool learnable = false;
		bool enabled = true;
		bool premium = false;

	private:
		std::string name;
};

class InstantSpell final : public TalkAction, public Spell {
	public:
		using TalkAction::TalkAction;

		virtual bool playerCastInstant(Player* player, std::string &param);

		bool castSpell(Creature* creature) override;
		bool castSpell(Creature* creature, Creature* target) override;

		// Scripting spell
		bool executeCastSpell(Creature* creature, const LuaVariant &var) const;

		bool isInstant() const override {
			return true;
		}
		bool getHasParam() const {
			return hasParam;
		}
		void setHasParam(bool p) {
			hasParam = p;
		}
		bool getHasPlayerNameParam() const {
			return hasPlayerNameParam;
		}
		void setHasPlayerNameParam(bool p) {
			hasPlayerNameParam = p;
		}
		bool getNeedDirection() const {
			return needDirection;
		}
		void setNeedDirection(bool n) {
			needDirection = n;
		}
		bool getNeedCasterTargetOrDirection() const {
			return casterTargetOrDirection;
		}
		void setNeedCasterTargetOrDirection(bool d) {
			casterTargetOrDirection = d;
		}
		bool getBlockWalls() const {
			return checkLineOfSight;
		}
		void setBlockWalls(bool w) {
			checkLineOfSight = w;
		}
		bool canCast(const Player* player) const;
		bool canThrowSpell(const Creature* creature, const Creature* target) const;

	private:
		std::string getScriptTypeName() const override {
			return "onCastSpell";
		}

		bool needDirection = false;
		bool hasParam = false;
		bool hasPlayerNameParam = false;
		bool checkLineOfSight = true;
		bool casterTargetOrDirection = false;
};

class RuneSpell final : public Action, public Spell {
	public:
		using Action::Action;

		ReturnValue canExecuteAction(const Player* player, const Position &toPos) override;
		bool hasOwnErrorHandler() override {
			return true;
		}
		Thing* getTarget(Player*, Creature* targetCreature, const Position &, uint8_t) const override {
			return targetCreature;
		}

		bool executeUse(Player* player, Item* item, const Position &fromPosition, Thing* target, const Position &toPosition, bool isHotkey) override;

		bool castSpell(Creature* creature) override;
		bool castSpell(Creature* creature, Creature* target) override;

		// Scripting spell
		bool executeCastSpell(Creature* creature, const LuaVariant &var, bool isHotkey) const;

		bool isInstant() const override {
			return false;
		}
		uint16_t getRuneItemId() const {
			return runeId;
		}
		void setRuneItemId(uint16_t i) {
			runeId = i;
		}
		uint32_t getCharges() const {
			return charges;
		}
		void setCharges(uint32_t c) {
			if (c > 0) {
				hasCharges = true;
			}
			charges = c;
		}

	private:
		std::string getScriptTypeName() const override {
			return "onCastSpell";
		}

		bool internalCastSpell(Creature* creature, const LuaVariant &var, bool isHotkey);

		uint16_t runeId = 0;
		uint32_t charges = 0;
		bool hasCharges = false;
};

#endif // SRC_CREATURES_COMBAT_SPELLS_H_
