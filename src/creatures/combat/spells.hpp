/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/creature/actions.hpp"
#include "creatures/players/components/wheel/wheel_definitions.hpp"

class InstantSpell;
class RuneSpell;
class Spell;
class Combat;
class Player;
class Creature;
class LuaScriptInterface;

struct LuaVariant;
struct Position;

using VocSpellMap = std::map<uint16_t, bool>;

class Spells {
public:
	Spells();
	~Spells();

	// non-copyable
	Spells(const Spells &) = delete;
	Spells &operator=(const Spells &) = delete;

	static Spells &getInstance();

	std::shared_ptr<Spell> getSpellByName(const std::string &name);
	std::shared_ptr<RuneSpell> getRuneSpell(uint16_t id);
	std::shared_ptr<RuneSpell> getRuneSpellByName(const std::string &name);

	std::shared_ptr<InstantSpell> getInstantSpell(const std::string &words);
	std::shared_ptr<InstantSpell> getInstantSpellByName(const std::string &name);

	std::shared_ptr<InstantSpell> getInstantSpellById(uint16_t spellId);

	TalkActionResult_t playerSaySpell(const std::shared_ptr<Player> &player, std::string &words);

	static Position getCasterPosition(const std::shared_ptr<Creature> &creature, Direction dir);

	std::list<uint16_t> getSpellsByVocation(uint16_t vocationId);

	[[nodiscard]] const std::map<std::string, std::shared_ptr<InstantSpell>> &getInstantSpells() const;

	[[nodiscard]] bool hasInstantSpell(const std::string &word) const;

	void setInstantSpell(const std::string &word, const std::shared_ptr<InstantSpell> &instant);

	void clear();
	bool registerInstantLuaEvent(const std::shared_ptr<InstantSpell> &instant);
	bool registerRuneLuaEvent(const std::shared_ptr<RuneSpell> &rune);

private:
	std::map<uint16_t, std::shared_ptr<RuneSpell>> runes;
	std::map<std::string, std::shared_ptr<InstantSpell>> instants;

	friend class CombatSpell;
};

constexpr auto g_spells = Spells::getInstance;

using RuneSpellFunction [[maybe_unused]] = std::function<bool(const std::shared_ptr<RuneSpell> &spell, const std::shared_ptr<Player> &player, const Position &posTo)>;

class BaseSpell {
public:
	constexpr BaseSpell() = default;
	virtual ~BaseSpell() = default;

	virtual bool castSpell(const std::shared_ptr<Creature> &creature) = 0;
	virtual bool castSpell(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) = 0;

	LuaScriptInterface* getScriptInterface() const;
	bool loadScriptId();
	int32_t getScriptId() const;
	void setScriptId(int32_t newScriptId);
	bool isLoadedScriptId() const;

	SoundEffect_t soundImpactEffect = SoundEffect_t::SILENCE;
	SoundEffect_t soundCastEffect = SoundEffect_t::SPELL_OR_RUNE;

protected:
	int32_t m_spellScriptId {};
};

class CombatSpell final : public BaseSpell, public std::enable_shared_from_this<CombatSpell> {
public:
	// Constructor
	CombatSpell(const std::shared_ptr<Combat> &newCombat, bool newNeedTarget, bool newNeedDirection);

	// The copy constructor and the assignment operator have been deleted to prevent accidental copying.
	CombatSpell(const CombatSpell &) = delete;
	CombatSpell &operator=(const CombatSpell &) = delete;

	bool castSpell(const std::shared_ptr<Creature> &creature) override;
	bool castSpell(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) override;

	// Scripting spell
	bool executeCastSpell(const std::shared_ptr<Creature> &creature, const LuaVariant &var) const;

	std::shared_ptr<Combat> getCombat() const;

private:
	std::shared_ptr<Combat> m_combat;

	bool needDirection;
	bool needTarget;
};

class Spell : public BaseSpell {
public:
	Spell();

	[[nodiscard]] const std::string &getName() const;
	void setName(std::string n);
	[[nodiscard]] uint16_t getSpellId() const;
	void setSpellId(uint16_t id);

	void postCastSpell(const std::shared_ptr<Player> &player, bool finishedCast = true, bool payCost = true) const;
	static void postCastSpell(const std::shared_ptr<Player> &player, uint32_t manaCost, uint32_t soulCost, uint8_t harmonyCost);
	[[nodiscard]] virtual bool isInstant() const = 0;
	[[nodiscard]] bool isLearnable() const;

	uint32_t getManaCost(const std::shared_ptr<Player> &player) const;
	[[nodiscard]] uint32_t getSoulCost() const;
	void setSoulCost(uint32_t s);
	[[nodiscard]] uint32_t getLevel() const;
	void setLevel(uint32_t lvl);
	[[nodiscard]] uint32_t getMagicLevel() const;
	void setMagicLevel(uint32_t lvl);
	[[nodiscard]] uint32_t getMana() const;
	void setMana(uint32_t m);
	[[nodiscard]] uint32_t getManaPercent() const;
	void setManaPercent(uint32_t m);
	[[nodiscard]] bool isPremium() const;
	void setPremium(bool p);
	[[nodiscard]] bool isEnabled() const;
	void setEnabled(bool e);

	[[nodiscard]] const VocSpellMap &getVocMap() const;
	void addVocMap(uint16_t vocationId, bool b);

	SpellGroup_t getGroup() const;
	void setGroup(SpellGroup_t g);
	SpellGroup_t getSecondaryGroup();
	void setSecondaryGroup(SpellGroup_t g);

	[[nodiscard]] uint32_t getCooldown() const;
	void setCooldown(uint32_t cd);
	[[nodiscard]] uint32_t getSecondaryCooldown() const;
	void setSecondaryCooldown(uint32_t cd);
	[[nodiscard]] uint32_t getGroupCooldown() const;
	void setGroupCooldown(uint32_t cd);

	[[nodiscard]] int32_t getRange() const;
	void setRange(int32_t r);

	[[nodiscard]] bool getNeedTarget() const;
	void setNeedTarget(bool n);
	[[nodiscard]] bool getNeedWeapon() const;
	void setNeedWeapon(bool n);
	[[nodiscard]] bool getNeedLearn() const;
	void setNeedLearn(bool n);
	[[nodiscard]] bool getSelfTarget() const;
	void setSelfTarget(bool s);
	[[nodiscard]] bool getBlockingSolid() const;
	void setBlockingSolid(bool b);
	[[nodiscard]] bool getBlockingCreature() const;
	void setBlockingCreature(bool b);
	[[nodiscard]] bool getAggressive() const;
	void setAggressive(bool a);
	[[nodiscard]] bool getAllowOnSelf() const;
	void setAllowOnSelf(bool s);
	[[nodiscard]] bool getLockedPZ() const;
	void setLockedPZ(bool b);

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

	[[nodiscard]] const std::string &getWords() const;

	void setWords(std::string_view newWord);

	[[nodiscard]] const std::string &getSeparator() const;

	void setSeparator(std::string_view newSeparator);

	void getCombatDataAugment(const std::shared_ptr<Player> &player, CombatDamage &damage) const;
	int32_t calculateAugmentSpellCooldownReduction(const std::shared_ptr<Player> &player) const;

	[[nodiscard]] bool getHarmonyCost() const;
	void setHarmonyCost(bool h);

protected:
	void applyCooldownConditions(const std::shared_ptr<Player> &player) const;
	bool playerSpellCheck(const std::shared_ptr<Player> &player) const;
	bool playerInstantSpellCheck(const std::shared_ptr<Player> &player, const Position &toPos) const;
	bool playerRuneSpellCheck(const std::shared_ptr<Player> &player, const Position &toPos) const;

	VocSpellMap vocSpellMap;

	SpellGroup_t group = SPELLGROUP_NONE;
	SpellGroup_t secondaryGroup = SPELLGROUP_NONE;
	SpellType_t spellType = SPELL_UNDEFINED;

	uint32_t cooldown = 1000;
	uint32_t groupCooldown = 1000;
	uint32_t secondaryGroupCooldown = 0;
	uint32_t level = 0;
	uint32_t magLevel = 0;
	int32_t range = -1;

	uint16_t m_spellId = 0;

	bool selfTarget = false;
	bool needTarget = false;
	bool allowOnSelf = true;
	bool pzLocked = false;

	bool whellOfDestinyUpgraded = false;
	std::array<int32_t, magic_enum::enum_count<WheelSpellBoost_t>() + 1> wheelOfDestinyRegularBoost = { 0 };
	std::array<int32_t, magic_enum::enum_count<WheelSpellBoost_t>() + 1> wheelOfDestinyUpgradedBoost = { 0 };

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
	bool harmony = false;

	std::string name;
	std::string m_words;
	std::string m_separator;

	friend class SpellFunctions;
};

class InstantSpell final : public Spell {
public:
	InstantSpell();
	bool playerCastInstant(const std::shared_ptr<Player> &player, std::string &param) const;

	bool castSpell(const std::shared_ptr<Creature> &creature) override;
	bool castSpell(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) override;

	// Scripting spell
	bool executeCastSpell(const std::shared_ptr<Creature> &creature, const LuaVariant &var) const;

	[[nodiscard]] bool isInstant() const override;
	[[nodiscard]] bool getHasParam() const;
	void setHasParam(bool p);
	[[nodiscard]] bool getHasPlayerNameParam() const;
	void setHasPlayerNameParam(bool p);
	[[nodiscard]] bool getNeedDirection() const;
	void setNeedDirection(bool n);
	[[nodiscard]] bool getNeedCasterTargetOrDirection() const;
	void setNeedCasterTargetOrDirection(bool d);
	[[nodiscard]] bool getBlockWalls() const;
	void setBlockWalls(bool w);
	bool canCast(const std::shared_ptr<Player> &player) const;
	bool canThrowSpell(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) const;

private:
	bool needDirection = false;
	bool hasParam = false;
	bool hasPlayerNameParam = false;
	bool checkLineOfSight = true;
	bool casterTargetOrDirection = false;
};

class RuneSpell final : public Action, public Spell {
public:
	using Action::Action;

	LuaScriptInterface* getRuneSpellScriptInterface() const;
	bool loadRuneSpellScriptId();
	int32_t getRuneSpellScriptId() const;
	void setRuneSpellScriptId(int32_t newScriptId);
	bool isRuneSpellLoadedScriptId() const;

	ReturnValue canExecuteAction(const std::shared_ptr<Player> &player, const Position &toPos) override;
	bool hasOwnErrorHandler() override;
	std::shared_ptr<Thing> getTarget(const std::shared_ptr<Player> &, const std::shared_ptr<Creature> &targetCreature, const Position &, uint8_t) const override;

	bool executeUse(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const Position &fromPosition, const std::shared_ptr<Thing> &target, const Position &toPosition, bool isHotkey) override;

	bool castSpell(const std::shared_ptr<Creature> &creature) override;
	bool castSpell(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) override;

	// Scripting spell
	bool executeCastSpell(const std::shared_ptr<Creature> &creature, const LuaVariant &var, bool isHotkey) const;

	[[nodiscard]] bool isInstant() const override;
	[[nodiscard]] uint16_t getRuneItemId() const;
	void setRuneItemId(uint16_t i);
	[[nodiscard]] uint32_t getCharges() const;
	void setCharges(uint32_t c);

private:
	bool internalCastSpell(const std::shared_ptr<Creature> &creature, const LuaVariant &var, bool isHotkey) const;

	int32_t m_runeSpellScriptId = 0;

	uint16_t runeId = 0;
	uint32_t charges = 0;
	bool hasCharges = false;
};
