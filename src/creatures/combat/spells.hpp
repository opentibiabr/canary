/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/wheel/wheel_definitions.hpp"
#include "lua/creature/actions.hpp"
#include "lua/creature/talkaction.hpp"
#include "lua/scripts/scripts.hpp"

class InstantSpell;
class RuneSpell;
class Spell;

using VocSpellMap = std::map<uint16_t, bool>;

class Spells final : public Scripts {
public:
	Spells();
	~Spells();

	// non-copyable
	Spells(const Spells &) = delete;
	Spells &operator=(const Spells &) = delete;

	static Spells &getInstance() {
		return inject<Spells>();
	}

	std::shared_ptr<Spell> getSpellByName(const std::string &name);
	std::shared_ptr<RuneSpell> getRuneSpell(uint16_t id);
	std::shared_ptr<RuneSpell> getRuneSpellByName(const std::string &name);

	std::shared_ptr<InstantSpell> getInstantSpell(const std::string &words);
	std::shared_ptr<InstantSpell> getInstantSpellByName(const std::string &name);

	std::shared_ptr<InstantSpell> getInstantSpellById(uint16_t spellId);

	TalkActionResult_t playerSaySpell(std::shared_ptr<Player> player, std::string &words);

	static Position getCasterPosition(std::shared_ptr<Creature> creature, Direction dir);

	std::list<uint16_t> getSpellsByVocation(uint16_t vocationId);

	[[nodiscard]] const std::map<std::string, std::shared_ptr<InstantSpell>> &getInstantSpells() const {
		return instants;
	};

	[[nodiscard]] bool hasInstantSpell(const std::string &word) const;

	void setInstantSpell(const std::string &word, const std::shared_ptr<InstantSpell> instant) {
		instants.try_emplace(word, instant);
	}

	void clear();
	bool registerInstantLuaEvent(const std::shared_ptr<InstantSpell> instant);
	bool registerRuneLuaEvent(const std::shared_ptr<RuneSpell> rune);

private:
	std::map<uint16_t, std::shared_ptr<RuneSpell>> runes;
	std::map<std::string, std::shared_ptr<InstantSpell>> instants;

	friend class CombatSpell;
};

constexpr auto g_spells = Spells::getInstance;

using RuneSpellFunction = std::function<bool(const std::shared_ptr<RuneSpell> spell, std::shared_ptr<Player> player, const Position &posTo)>;

class BaseSpell {
public:
	constexpr BaseSpell() = default;
	virtual ~BaseSpell() = default;

	virtual bool castSpell(std::shared_ptr<Creature> creature) = 0;
	virtual bool castSpell(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) = 0;

	SoundEffect_t soundImpactEffect = SoundEffect_t::SILENCE;
	SoundEffect_t soundCastEffect = SoundEffect_t::SPELL_OR_RUNE;
};

class CombatSpell final : public Script, public BaseSpell, public std::enable_shared_from_this<CombatSpell> {
public:
	// Constructor
	CombatSpell(const std::shared_ptr<Combat> newCombat, bool newNeedTarget, bool newNeedDirection);

	// The copy constructor and the assignment operator have been deleted to prevent accidental copying.
	CombatSpell(const CombatSpell &) = delete;
	CombatSpell &operator=(const CombatSpell &) = delete;

	bool castSpell(std::shared_ptr<Creature> creature) override;
	bool castSpell(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) override;

	// Scripting spell
	bool executeCastSpell(std::shared_ptr<Creature> creature, const LuaVariant &var) const;

	bool loadScriptCombat();
	std::shared_ptr<Combat> getCombat() const {
		return m_combat;
	}

private:
	std::string getScriptTypeName() const override {
		return "onCastSpell";
	}

	std::shared_ptr<Combat> m_combat;

	bool needDirection;
	bool needTarget;
};

class Spell : public BaseSpell {
public:
	Spell() = default;

	[[nodiscard]] const std::string &getName() const {
		return name;
	}
	void setName(std::string n) {
		name = std::move(n);
	}
	[[nodiscard]] uint16_t getId() const {
		return spellId;
	}
	void setId(uint16_t id) {
		spellId = id;
	}

	void postCastSpell(std::shared_ptr<Player> player, bool finishedCast = true, bool payCost = true) const;
	static void postCastSpell(std::shared_ptr<Player> player, uint32_t manaCost, uint32_t soulCost);
	[[nodiscard]] virtual bool isInstant() const = 0;
	[[nodiscard]] bool isLearnable() const {
		return learnable;
	}

	uint32_t getManaCost(std::shared_ptr<Player> player) const;
	[[nodiscard]] uint32_t getSoulCost() const {
		return soul;
	}
	void setSoulCost(uint32_t s) {
		soul = s;
	}
	[[nodiscard]] uint32_t getLevel() const {
		return level;
	}
	void setLevel(uint32_t lvl) {
		level = lvl;
	}
	[[nodiscard]] uint32_t getMagicLevel() const {
		return magLevel;
	}
	void setMagicLevel(uint32_t lvl) {
		magLevel = lvl;
	}
	[[nodiscard]] uint32_t getMana() const {
		return mana;
	}
	void setMana(uint32_t m) {
		mana = m;
	}
	[[nodiscard]] uint32_t getManaPercent() const {
		return manaPercent;
	}
	void setManaPercent(uint32_t m) {
		manaPercent = m;
	}
	[[nodiscard]] bool isPremium() const {
		return premium;
	}
	void setPremium(bool p) {
		premium = p;
	}
	[[nodiscard]] bool isEnabled() const {
		return enabled;
	}
	void setEnabled(bool e) {
		enabled = e;
	}

	[[nodiscard]] const VocSpellMap &getVocMap() const {
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

	[[nodiscard]] uint32_t getCooldown() const {
		return cooldown;
	}
	void setCooldown(uint32_t cd) {
		cooldown = cd;
	}
	[[nodiscard]] uint32_t getSecondaryCooldown() const {
		return secondaryGroupCooldown;
	}
	void setSecondaryCooldown(uint32_t cd) {
		secondaryGroupCooldown = cd;
	}
	[[nodiscard]] uint32_t getGroupCooldown() const {
		return groupCooldown;
	}
	void setGroupCooldown(uint32_t cd) {
		groupCooldown = cd;
	}

	[[nodiscard]] int32_t getRange() const {
		return range;
	}
	void setRange(int32_t r) {
		range = r;
	}

	[[nodiscard]] bool getNeedTarget() const {
		return needTarget;
	}
	void setNeedTarget(bool n) {
		needTarget = n;
	}
	[[nodiscard]] bool getNeedWeapon() const {
		return needWeapon;
	}
	void setNeedWeapon(bool n) {
		needWeapon = n;
	}
	[[nodiscard]] bool getNeedLearn() const {
		return learnable;
	}
	void setNeedLearn(bool n) {
		learnable = n;
	}
	[[nodiscard]] bool getSelfTarget() const {
		return selfTarget;
	}
	void setSelfTarget(bool s) {
		selfTarget = s;
	}
	[[nodiscard]] bool getBlockingSolid() const {
		return blockingSolid;
	}
	void setBlockingSolid(bool b) {
		blockingSolid = b;
	}
	[[nodiscard]] bool getBlockingCreature() const {
		return blockingCreature;
	}
	void setBlockingCreature(bool b) {
		blockingCreature = b;
	}
	[[nodiscard]] bool getAggressive() const {
		return aggressive;
	}
	void setAggressive(bool a) {
		aggressive = a;
	}
	[[nodiscard]] bool getAllowOnSelf() const {
		return allowOnSelf;
	}
	void setAllowOnSelf(bool s) {
		allowOnSelf = s;
	}
	[[nodiscard]] bool getLockedPZ() const {
		return pzLocked;
	}
	void setLockedPZ(bool b) {
		pzLocked = b;
	}

	/**
	 * @brief Get whether the wheel of destiny is upgraded.
	 *
	 * @return True if the wheel of destiny is upgraded, false otherwise.
	 */
	[[nodiscard]] bool getWheelOfDestinyUpgraded() const;

	/**
	 * @brief Get the boost value for the wheel of destiny.
	 *
	 * @param boost The boost type.
	 * @param grade The grade of the wheel of destiny.
	 * @return The boost value for the specified boost and grade.
	 */
	[[nodiscard]] int32_t getWheelOfDestinyBoost(WheelSpellBoost_t boost, WheelSpellGrade_t grade) const;

	/**
	 * @brief Set whether the wheel of destiny is upgraded.
	 *
	 * @param value The value indicating whether the wheel of destiny is upgraded.
	 */
	void setWheelOfDestinyUpgraded(bool value);

	/**
	 * @brief Set the boost value for the wheel of destiny.
	 *
	 * @param boost The boost type.
	 * @param grade The grade of the wheel of destiny.
	 * @param value The boost value to be set.
	 */
	void setWheelOfDestinyBoost(WheelSpellBoost_t boost, WheelSpellGrade_t grade, int32_t value);

	SpellType_t spellType = SPELL_UNDEFINED;

	[[nodiscard]] const std::string &getWords() const {
		return m_words;
	}

	void setWords(const std::string_view &newWord) {
		m_words = newWord.data();
	}

	[[nodiscard]] const std::string &getSeparator() const {
		return m_separator;
	}

	void setSeparator(const std::string_view &newSeparator) {
		m_separator = newSeparator.data();
	}

protected:
	void applyCooldownConditions(std::shared_ptr<Player> player) const;
	bool playerSpellCheck(std::shared_ptr<Player> player) const;
	bool playerInstantSpellCheck(std::shared_ptr<Player> player, const Position &toPos) const;
	bool playerRuneSpellCheck(std::shared_ptr<Player> player, const Position &toPos);

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
	std::array<int32_t, static_cast<uint8_t>(WheelSpellBoost_t::TOTAL_COUNT)> wheelOfDestinyRegularBoost = { 0 };
	std::array<int32_t, static_cast<uint8_t>(WheelSpellBoost_t::TOTAL_COUNT)> wheelOfDestinyUpgradedBoost = { 0 };

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

	std::string name;
	std::string m_words;
	std::string m_separator;
};

class InstantSpell final : public Script, public Spell {
public:
	using Script::Script;

	virtual bool playerCastInstant(std::shared_ptr<Player> player, std::string &param);

	bool castSpell(std::shared_ptr<Creature> creature) override;
	bool castSpell(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) override;

	// Scripting spell
	bool executeCastSpell(std::shared_ptr<Creature> creature, const LuaVariant &var) const;

	[[nodiscard]] bool isInstant() const override {
		return true;
	}
	[[nodiscard]] bool getHasParam() const {
		return hasParam;
	}
	void setHasParam(bool p) {
		hasParam = p;
	}
	[[nodiscard]] bool getHasPlayerNameParam() const {
		return hasPlayerNameParam;
	}
	void setHasPlayerNameParam(bool p) {
		hasPlayerNameParam = p;
	}
	[[nodiscard]] bool getNeedDirection() const {
		return needDirection;
	}
	void setNeedDirection(bool n) {
		needDirection = n;
	}
	[[nodiscard]] bool getNeedCasterTargetOrDirection() const {
		return casterTargetOrDirection;
	}
	void setNeedCasterTargetOrDirection(bool d) {
		casterTargetOrDirection = d;
	}
	[[nodiscard]] bool getBlockWalls() const {
		return checkLineOfSight;
	}
	void setBlockWalls(bool w) {
		checkLineOfSight = w;
	}
	bool canCast(std::shared_ptr<Player> player) const;
	bool canThrowSpell(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) const;

private:
	[[nodiscard]] std::string getScriptTypeName() const override {
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

	ReturnValue canExecuteAction(std::shared_ptr<Player> player, const Position &toPos) override;
	bool hasOwnErrorHandler() override {
		return true;
	}
	std::shared_ptr<Thing> getTarget(std::shared_ptr<Player>, std::shared_ptr<Creature> targetCreature, const Position &, uint8_t) const override {
		return targetCreature;
	}

	bool executeUse(std::shared_ptr<Player> player, std::shared_ptr<Item> item, const Position &fromPosition, std::shared_ptr<Thing> target, const Position &toPosition, bool isHotkey) override;

	bool castSpell(std::shared_ptr<Creature> creature) override;
	bool castSpell(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) override;

	// Scripting spell
	bool executeCastSpell(std::shared_ptr<Creature> creature, const LuaVariant &var, bool isHotkey) const;

	[[nodiscard]] bool isInstant() const override {
		return false;
	}
	[[nodiscard]] uint16_t getRuneItemId() const {
		return runeId;
	}
	void setRuneItemId(uint16_t i) {
		runeId = i;
	}
	[[nodiscard]] uint32_t getCharges() const {
		return charges;
	}
	void setCharges(uint32_t c) {
		if (c > 0) {
			hasCharges = true;
		}
		charges = c;
	}

private:
	[[nodiscard]] std::string getScriptTypeName() const override {
		return "onCastSpell";
	}

	bool internalCastSpell(std::shared_ptr<Creature> creature, const LuaVariant &var, bool isHotkey);

	uint16_t runeId = 0;
	uint32_t charges = 0;
	bool hasCharges = false;
};
