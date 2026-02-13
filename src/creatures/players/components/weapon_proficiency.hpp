/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <nlohmann/json.hpp>
#include "enums/weapon_proficiency.hpp"
#include "creatures/creatures_definitions.hpp"
#include "creatures/monsters/monster.hpp"
#include "io/io_bosstiary.hpp"
#include "utils/hash.hpp"
#include "kv/kv.hpp"

using json = nlohmann::json;

class Player;

class WeaponProficiency {
public:
	WeaponProficiency() = default;
	explicit WeaponProficiency(Player &player);

	static bool loadFromJson(bool reload = false);
	static void registerLevels(const json &levelsJson, Proficiency &proficiency);
	static void registerPerks(const json &perksJson, ProficiencyLevel &proficiencyLevel);

	static std::unordered_map<uint16_t, Proficiency> &getProficiencies();

	void load();
	void save(uint16_t weaponId) const;
	void saveAll() const;

	WeaponProficiencyData deserialize(const ValueWrapper &val);
	ProficiencyPerk deserializePerk(const ValueWrapper &val);
	std::vector<ProficiencyPerk> deserializePerks(const ValueWrapper &val);
	ValueWrapper serialize(WeaponProficiencyData weaponData) const;
	ValueWrapper serializePerk(const ProficiencyPerk &perk) const;
	std::vector<ValueWrapper> serializePerks(const std::vector<ProficiencyPerk> &perks) const;

	void applyPerks(uint16_t weaponId);
	std::vector<ProficiencyPerk> getSelectedPerks(uint16_t itemId) const;
	void clearSelectedPerks(uint16_t weaponId);
	void setSelectedPerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId = 0);
	std::unordered_map<std::pair<uint16_t, uint8_t>, double, PairHash, PairEqual> getActiveAugments(uint16_t weaponId = 0);
	const std::array<uint32_t, 9> &getExperienceArray(uint16_t weaponId) const;
	uint32_t nextLevelExperience(uint16_t weaponId);
	uint32_t getMaxExperience(uint16_t weaponId) const;
	void addExperience(uint32_t experience, uint16_t weaponId = 0);
	uint32_t getBosstiaryExperience(BosstiaryRarity_t rarity) const;
	uint32_t getBestiaryExperience(uint8_t monsterStar) const;
	uint32_t getExperience(uint16_t weaponId = 0) const;
	bool isUpgradeAvailable(uint16_t weaponId = 0) const;

	void addStat(WeaponProficiencyBonus_t stat, double_t value);
	double_t getStat(WeaponProficiencyBonus_t stat) const;
	void resetStats();

	void addSkillPercentage(skills_t skill, SkillPercentage_t type, double_t value);
	const SkillPercentage &getSkillPercentage() const;

	uint16_t getSpecializedMagic(CombatType_t type) const;
	void addSpecializedMagic(CombatType_t type, uint16_t value);
	void resetSpecializedMagic();

	uint32_t getSkillBonus(skills_t type) const;
	void addSkillBonus(skills_t type, uint32_t value);
	void resetSkillBonuses();

	double_t getPowerfulFoeDamage() const;
	void addPowerfulFoeDamage(double_t percent);
	void resetPowerfulFoeDamage();

	const WeaponProficiencyCriticalBonus &getAutoAttackCritical() const;
	void addAutoAttackCritical(const WeaponProficiencyCriticalBonus &bonus);

	const WeaponProficiencyCriticalBonus &getRunesCritical() const;
	void addRunesCritical(const WeaponProficiencyCriticalBonus &bonus);

	const WeaponProficiencyCriticalBonus &getGeneralCritical() const;
	void addGeneralCritical(const WeaponProficiencyCriticalBonus &bonus);

	const WeaponProficiencyCriticalBonus &getElementCritical(CombatType_t type) const;
	void addElementCritical(CombatType_t type, const WeaponProficiencyCriticalBonus &bonus);

	uint32_t getSpellBonus(uint16_t spellId, WeaponProficiencySpellBoost_t boost) const;
	void addSpellBonus(uint16_t spellId, const WeaponProficiencySpells::Bonus &bonus);

	void addPerfectShotBonus(uint8_t range, uint8_t damage);
	const WeaponProficiencyPerfectShotBonus &getPerfectShotBonus() const;
	void resetPerfectShotBonus();

	double_t getBestiaryDamage(uint8_t raceId) const;
	void addBestiaryDamage(uint8_t raceId, double_t bonus);
	void resetBestiaryDamage();

	uint16_t getSkillValueFromWeapon() const;

	void applyAutoAttackCritical(CombatDamage &damage) const;
	void applyRunesCritical(CombatDamage &damage, bool aggressive) const;
	void applyElementCritical(CombatDamage &damage) const;

	void applyBestiaryDamage(CombatDamage &damage, const std::shared_ptr<Monster> &monster) const;
	void applyBossDamage(CombatDamage &damage, const std::shared_ptr<Monster> &monster) const;
	void applyPowerfulFoeDamage(CombatDamage &damage, const std::shared_ptr<Monster> &monster) const;

	void applySkillAutoAttackPercentage(CombatDamage &damage) const;
	void applySkillSpellPercentage(CombatDamage &damage, bool healing = false) const;

	void applyOn(WeaponProficiencyHealth_t healthType, WeaponProficiencyGain_t gainType) const;

	void applySpellAugment(CombatDamage &damage, uint16_t spellId) const;

	std::vector<std::pair<std::string, double>> getActiveBestiariesDamage() const;
	std::optional<std::pair<uint8_t, double>> getActiveElementalCriticalType(WeaponProficiencyBonus_t criticalType) const;

	void clearAllStats();

private:
	Player &m_player;

	std::unordered_map<uint16_t, WeaponProficiencyData> proficiency;

	static std::unordered_map<uint16_t, Proficiency> proficiencies;

	static std::array<uint32_t, 9> crossbowExperience;
	static std::array<uint32_t, 9> standardExperience;
	static std::array<uint32_t, 9> knightExperience;

	std::array<double_t, magic_enum::enum_count<WeaponProficiencyBonus_t>() + 1> m_stats = { 0 };

	SkillPercentage m_skillPercentage;

	std::array<uint16_t, COMBAT_COUNT + 1> m_specializedMagic = { 0 };

	std::array<uint32_t, SKILL_LAST + 1> m_skills = { 0 };

	double_t m_powerfulFoeDamage = 0;

	WeaponProficiencyCriticalBonus m_autoAttackCritical;
	WeaponProficiencyCriticalBonus m_runesCritical;
	WeaponProficiencyCriticalBonus m_generalCritical;

	std::array<WeaponProficiencyCriticalBonus, COMBAT_COUNT> m_elementCritical = { 0 };

	std::unordered_map<uint16_t, WeaponProficiencySpells::Bonus> m_spellsBonuses;

	WeaponProficiencyPerfectShotBonus m_perfectShot;

	std::unordered_map<uint8_t, double_t> m_bestiaryDamage;
};
