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
#include "lua/scripts/scripts.hpp"
#include "creatures/combat/combat.hpp"
#include "utils/utils_definitions.hpp"
#include "creatures/players/vocations/vocation.hpp"

class Weapon;
class WeaponMelee;
class WeaponDistance;
class WeaponWand;

using WeaponUnique_ptr = std::unique_ptr<Weapon>;
using WeaponShared_ptr = std::shared_ptr<Weapon>;

class Weapons final : public Scripts {
public:
	Weapons();
	~Weapons();

	// non-copyable
	Weapons(const Weapons &) = delete;
	Weapons &operator=(const Weapons &) = delete;

	static Weapons &getInstance() {
		return inject<Weapons>();
	}

	const WeaponShared_ptr getWeapon(std::shared_ptr<Item> item) const;

	static int32_t getMaxMeleeDamage(int32_t attackSkill, int32_t attackValue);
	static int32_t getMaxWeaponDamage(uint32_t level, int32_t attackSkill, int32_t attackValue, float attackFactor, bool isMelee);

	bool registerLuaEvent(WeaponShared_ptr event);
	void clear();

private:
	std::map<uint32_t, WeaponShared_ptr> weapons;
};

constexpr auto g_weapons = Weapons::getInstance;

class Weapon : public Script {
public:
	using Script::Script;

	virtual void configureWeapon(const ItemType &it);
	virtual bool interruptSwing() const {
		return false;
	}

	int32_t playerWeaponCheck(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, uint8_t shootRange) const;
	static bool useFist(std::shared_ptr<Player> player, std::shared_ptr<Creature> target);
	virtual bool useWeapon(std::shared_ptr<Player> player, std::shared_ptr<Item> item, std::shared_ptr<Creature> target) const;

	virtual int32_t getWeaponDamage(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, std::shared_ptr<Item> item, bool maxDamage = false) const = 0;
	virtual int32_t getElementDamage(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, std::shared_ptr<Item> item) const = 0;
	virtual CombatType_t getElementType() const = 0;
	virtual int16_t getElementDamageValue() const = 0;
	virtual CombatDamage getCombatDamage(CombatDamage combat, std::shared_ptr<Player> player, std::shared_ptr<Item> item, int32_t damageModifier) const;
	uint16_t getID() const {
		return id;
	}
	void setID(uint16_t newId) {
		id = newId;
	}

	uint32_t getReqLevel() const {
		return level;
	}
	void setRequiredLevel(uint32_t reqlvl) {
		level = reqlvl;
	}

	uint32_t getReqMagLv() const {
		return magLevel;
	}
	void setRequiredMagLevel(uint32_t reqlvl) {
		magLevel = reqlvl;
	}

	bool isPremium() const {
		return premium;
	}
	void setNeedPremium(bool prem) {
		premium = prem;
	}

	bool isWieldedUnproperly() const {
		return wieldUnproperly;
	}
	void setWieldUnproperly(bool unproperly) {
		wieldUnproperly = unproperly;
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

	int32_t getHealth() const {
		return health;
	}
	void setHealth(int32_t h) {
		health = h;
	}

	uint32_t getHealthPercent() const {
		return healthPercent;
	}
	void setHealthPercent(uint32_t m) {
		healthPercent = m;
	}

	uint32_t getSoul() const {
		return soul;
	}
	void setSoul(uint32_t s) {
		soul = s;
	}

	uint8_t getBreakChance() const {
		return breakChance;
	}
	void setBreakChance(uint8_t b) {
		breakChance = b;
	}

	bool isEnabled() const {
		return enabled;
	}
	void setIsEnabled(bool e) {
		enabled = e;
	}

	uint32_t getWieldInfo() const {
		return wieldInfo;
	}
	void setWieldInfo(uint32_t info) {
		wieldInfo |= info;
	}

	void addVocWeaponMap(std::string vocName) {
		int32_t vocationId = g_vocations().getVocationId(vocName);
		if (vocationId != -1) {
			vocWeaponMap[vocationId] = true;
		}
	}

	const std::string &getVocationString() const {
		return vocationString;
	}
	void setVocationString(const std::string &str) {
		vocationString = str;
	}

protected:
	void internalUseWeapon(std::shared_ptr<Player> player, std::shared_ptr<Item> item, std::shared_ptr<Creature> target, int32_t damageModifier, int32_t cleavePercent = 0) const;
	void internalUseWeapon(std::shared_ptr<Player> player, std::shared_ptr<Item> item, std::shared_ptr<Tile> tile) const;

private:
	virtual bool getSkillType(std::shared_ptr<Player>, std::shared_ptr<Item>, skills_t &, uint32_t &) const {
		return false;
	}

	uint32_t getManaCost(std::shared_ptr<Player> player) const;
	int32_t getHealthCost(std::shared_ptr<Player> player) const;
	bool executeUseWeapon(std::shared_ptr<Player> player, const LuaVariant &var) const;

	uint16_t id = 0;

	uint32_t level = 0;
	uint32_t magLevel = 0;
	uint32_t mana = 0;
	uint32_t manaPercent = 0;
	uint32_t health = 0;
	uint32_t healthPercent = 0;
	uint32_t soul = 0;
	uint32_t wieldInfo = WIELDINFO_NONE;
	uint8_t breakChance = 0;
	bool enabled = true;
	bool premium = false;
	bool wieldUnproperly = false;
	std::string vocationString = "";

	void onUsedWeapon(std::shared_ptr<Player> player, std::shared_ptr<Item> item, std::shared_ptr<Tile> destTile) const;

	static void decrementItemCount(std::shared_ptr<Item> item);

	WeaponAction_t action = WEAPONACTION_NONE;
	CombatParams params;
	WeaponType_t weaponType;
	std::map<uint16_t, bool> vocWeaponMap;

	friend class Combat;
	friend class WeaponWand;
	friend class WeaponMelee;
	friend class WeaponDistance;
	friend class WeaponFunctions;
};

class WeaponMelee final : public Weapon {
public:
	explicit WeaponMelee(LuaScriptInterface* interface);

	std::string getScriptTypeName() const override {
		return "onUseWeapon";
	}

	void configureWeapon(const ItemType &it) override;

	bool useWeapon(std::shared_ptr<Player> player, std::shared_ptr<Item> item, std::shared_ptr<Creature> target) const override;

	int32_t getWeaponDamage(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, std::shared_ptr<Item> item, bool maxDamage = false) const override;
	int32_t getElementDamage(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, std::shared_ptr<Item> item) const override;
	CombatType_t getElementType() const override {
		return elementType;
	}
	virtual int16_t getElementDamageValue() const override;

private:
	bool getSkillType(std::shared_ptr<Player> player, std::shared_ptr<Item> item, skills_t &skill, uint32_t &skillpoint) const override;
	uint16_t elementDamage = 0;
	CombatType_t elementType = COMBAT_NONE;
};

class WeaponDistance final : public Weapon {
public:
	explicit WeaponDistance(LuaScriptInterface* interface);

	std::string getScriptTypeName() const override {
		return "onUseWeapon";
	}

	void configureWeapon(const ItemType &it) override;
	bool interruptSwing() const override {
		return true;
	}

	bool useWeapon(std::shared_ptr<Player> player, std::shared_ptr<Item> item, std::shared_ptr<Creature> target) const override;

	int32_t getWeaponDamage(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, std::shared_ptr<Item> item, bool maxDamage = false) const override;
	int32_t getElementDamage(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, std::shared_ptr<Item> item) const override;
	CombatType_t getElementType() const override {
		return elementType;
	}
	virtual int16_t getElementDamageValue() const override;

private:
	bool getSkillType(std::shared_ptr<Player> player, std::shared_ptr<Item> item, skills_t &skill, uint32_t &skillpoint) const override;

	CombatType_t elementType = COMBAT_NONE;
	uint16_t elementDamage = 0;
};

class WeaponWand final : public Weapon {
public:
	using Weapon::Weapon;

	std::string getScriptTypeName() const override {
		return "onUseWeapon";
	}

	void configureWeapon(const ItemType &it) override;

	int32_t getWeaponDamage(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, std::shared_ptr<Item> item, bool maxDamage = false) const override;
	int32_t getElementDamage(std::shared_ptr<Player>, std::shared_ptr<Creature>, std::shared_ptr<Item>) const override {
		return 0;
	}
	CombatType_t getElementType() const override {
		return COMBAT_NONE;
	}
	virtual int16_t getElementDamageValue() const override;
	void setMinChange(int32_t change) {
		minChange = change;
	}

	void setMaxChange(int32_t change) {
		maxChange = change;
	}

private:
	bool getSkillType(std::shared_ptr<Player>, std::shared_ptr<Item>, skills_t &, uint32_t &) const override {
		return false;
	}

	int32_t minChange = 0;
	int32_t maxChange = 0;
};
