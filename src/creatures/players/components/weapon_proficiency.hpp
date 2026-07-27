/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <optional>
#endif

#include "enums/weapon_proficiency.hpp"
#include "creatures/creatures_definitions.hpp"
#include "utils/hash.hpp"

enum class BosstiaryRarity_t : uint8_t;

class Monster;
class Player;
class ValueWrapper;

struct WeaponProficiencyData;
struct Proficiency;

class WeaponProficiency {
public:
	explicit WeaponProficiency(Player &player);

	[[nodiscard]] static bool loadFromJson(bool reload = false);

	[[nodiscard]] static std::unordered_map<uint16_t, Proficiency> &getProficiencies();

	void load();
	void save(uint16_t weaponId) const;
	bool saveAll() const;
	[[nodiscard]] std::vector<uint16_t> getTrackedWeaponIds() const;

	static WeaponProficiencyData deserialize(const ValueWrapper &val);
	static ProficiencyPerk deserializePerk(const ValueWrapper &val);
	static std::vector<ProficiencyPerk> deserializePerks(const ValueWrapper &val);
	static std::vector<ShapedProficiencyPerk> deserializeShapedPerks(const ValueWrapper &val);
	ValueWrapper serialize(const WeaponProficiencyData &weaponData) const;
	ValueWrapper serializePerk(const ProficiencyPerk &perk) const;
	std::vector<ValueWrapper> serializePerks(const std::vector<ProficiencyPerk> &perks) const;
	ValueWrapper serializeShapedPerk(const ShapedProficiencyPerk &perk) const;
	std::vector<ValueWrapper> serializeShapedPerks(const std::vector<ShapedProficiencyPerk> &perks) const;

	void applyPerks(uint16_t weaponId, bool sendSkillUpdate = true);
	std::vector<ProficiencyPerk> getSelectedPerks(uint16_t itemId) const;
	std::vector<ShapedProficiencyPerk> getShapedPerks(uint16_t weaponId) const;
	void clearSelectedPerks(uint16_t weaponId);
	WeaponProficiencyShapingResult shapePerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId = 0);
	WeaponProficiencyShapingResult refineShapedPerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId = 0);
	WeaponProficiencyShapingResult maximizeShapedPerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId = 0);
	WeaponProficiencyShapingResult reshapeShapedPerk(uint8_t level, uint8_t perkIndex, std::vector<ShapedProficiencyPerk> &offers, uint16_t weaponId = 0);
	WeaponProficiencyShapingResult selectReshapeOption(uint8_t level, uint8_t perkIndex, const std::optional<ShapedProficiencyPerk> &offer, uint16_t weaponId = 0);
	WeaponProficiencyShapingResult clearShapedPerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId = 0);
	void setSelectedPerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId = 0);
	std::unordered_map<std::pair<uint16_t, uint8_t>, double, PairHash, PairEqual> getActiveAugments(uint16_t weaponId = 0);
	const std::vector<uint32_t> &getExperienceArray(uint16_t weaponId) const;
	uint32_t nextLevelExperience(uint16_t weaponId);
	uint32_t getMaxExperience(uint16_t weaponId) const;
	bool addExperience(uint32_t experience, uint16_t weaponId = 0, bool applyMultiplier = true);
	[[nodiscard]] uint32_t getBosstiaryExperience(BosstiaryRarity_t rarity) const;
	[[nodiscard]] uint32_t getBestiaryExperience(uint8_t monsterStar) const;
	[[nodiscard]] uint32_t getExperience(uint16_t weaponId = 0) const;
	[[nodiscard]] bool isUpgradeAvailable(uint16_t weaponId = 0) const;

	void addStat(WeaponProficiencyBonus_t stat, double_t value);
	[[nodiscard]] double_t getStat(WeaponProficiencyBonus_t stat) const;
	void resetStats();

	void addSkillPercentage(skills_t skill, SkillPercentage_t type, double_t value);

	[[nodiscard]] uint16_t getSpecializedMagic(CombatType_t type) const;
	void addSpecializedMagic(CombatType_t type, uint16_t value);
	void resetSpecializedMagic();

	[[nodiscard]] uint32_t getSkillBonus(skills_t type) const;
	void addSkillBonus(skills_t type, uint32_t value);
	void resetSkillBonuses();

	[[nodiscard]] double_t getPowerfulFoeDamage() const;
	void addPowerfulFoeDamage(double_t percent);
	void resetPowerfulFoeDamage();

	[[nodiscard]] const WeaponProficiencyCriticalBonus &getAutoAttackCritical() const;
	void addAutoAttackCritical(const WeaponProficiencyCriticalBonus &bonus);

	[[nodiscard]] const WeaponProficiencyCriticalBonus &getRunesCritical() const;
	void addRunesCritical(const WeaponProficiencyCriticalBonus &bonus);

	[[nodiscard]] const WeaponProficiencyCriticalBonus &getGeneralCritical() const;
	void addGeneralCritical(const WeaponProficiencyCriticalBonus &bonus);

	[[nodiscard]] WeaponProficiencyCriticalBonus getElementCritical(CombatType_t type) const;
	void addElementCritical(CombatType_t type, const WeaponProficiencyCriticalBonus &bonus);

	[[nodiscard]] double_t getElementalPierce(CombatType_t type) const;
	void addElementalPierce(CombatType_t type, double_t value);

	[[nodiscard]] uint32_t getSpellBonus(uint16_t spellId, WeaponProficiencySpellBoost_t boost) const;
	void addSpellBonus(uint16_t spellId, const WeaponProficiencySpells::Bonus &bonus);

	void setPerfectShotBonus(uint8_t range, double_t damage);
	[[nodiscard]] const WeaponProficiencyPerfectShotBonus &getPerfectShotBonus() const;
	void resetPerfectShotBonus();

	[[nodiscard]] double_t getBestiaryDamage(uint8_t raceId) const;
	void addBestiaryDamage(uint8_t raceId, double_t bonus);
	void resetBestiaryDamage();

	[[nodiscard]] uint16_t getSkillValueFromWeapon() const;

	void applyAutoAttackCritical(CombatDamage &damage) const;
	void applyRunesCritical(CombatDamage &damage, bool aggressive) const;
	void applyElementCritical(CombatDamage &damage) const;

	void applyBestiaryDamage(CombatDamage &damage, const std::shared_ptr<Monster> &monster) const;
	void applyPowerfulFoeDamage(CombatDamage &damage, const std::shared_ptr<Monster> &monster) const;

	void applySkillAutoAttackPercentage(CombatDamage &damage) const;
	void applySkillSpellPercentage(CombatDamage &damage, bool healing = false) const;

	void applyOn(WeaponProficiencyHealth_t healthType, WeaponProficiencyGain_t gainType) const;

	void applySpellAugment(CombatDamage &damage, uint16_t spellId) const;

	[[nodiscard]] const SkillPercentage &getSkillPercentage(skills_t skill) const;

	[[nodiscard]] std::vector<std::pair<std::string, double>> getActiveBestiariesDamage() const;
	[[nodiscard]] std::optional<std::pair<uint8_t, double>> getActiveElementalCriticalType(WeaponProficiencyBonus_t criticalType) const;
	[[nodiscard]] std::vector<std::pair<CombatType_t, double_t>> getActiveElementalPierces() const;

	[[nodiscard]] static std::vector<uint16_t> getShapingPerkPool(uint16_t vocationId);
	[[nodiscard]] static std::optional<ProficiencyPerk> getShapedPerkDefinition(uint16_t perkId, uint8_t rank, skills_t highestCombatSkill);
	[[nodiscard]] static uint16_t getShapingSlotCost(size_t currentShapedPerks);
	[[nodiscard]] static uint16_t getShapingRefineCost(uint8_t currentRank);

	void clearAllStats();

private:
	static constexpr uint8_t TRACKED_SKILL_COUNT = static_cast<uint8_t>(SKILL_MAGLEVEL) + 1;
	static constexpr size_t MAX_SHAPED_PERK_SLOTS = 2;
	void applyCriticalBonus(const ProficiencyPerk &perk);
	void applySkillPercentageBonus(const ProficiencyPerk &perk);

	[[nodiscard]] bool isValidWeaponId(uint16_t weaponId) const;
	[[nodiscard]] size_t getUnlockedLevelCount(uint16_t weaponId) const;
	[[nodiscard]] std::vector<ProficiencyPerk> collectValidSelectedPerks(uint16_t weaponId) const;
	[[nodiscard]] std::vector<ShapedProficiencyPerk> collectValidShapedPerks(uint16_t weaponId) const;
	[[nodiscard]] std::vector<ProficiencyPerk> getEffectivePerks(uint16_t weaponId) const;
	[[nodiscard]] skills_t getHighestCombatSkill() const;
	[[nodiscard]] bool isSelectedPerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId) const;
	void refreshEquippedWeapon(uint16_t weaponId);
	void normalizeStoredState(uint16_t weaponId);

	Player &m_player;

	std::unordered_map<uint16_t, WeaponProficiencyData> proficiency;

	static std::unordered_map<uint16_t, Proficiency> proficiencies;

	static std::vector<uint32_t> crossbowExperience;
	static std::vector<uint32_t> standardExperience;
	static std::vector<uint32_t> knightExperience;

	std::array<double_t, magic_enum::enum_count<WeaponProficiencyBonus_t>() + 1> m_stats = { 0 };

	std::unordered_map<skills_t, SkillPercentage> m_skillPercentages;

	std::array<uint16_t, COMBAT_COUNT + 1> m_specializedMagic = { 0 };

	std::array<uint32_t, TRACKED_SKILL_COUNT> m_skills = { 0 };

	double_t m_powerfulFoeDamage = 0;

	WeaponProficiencyCriticalBonus m_autoAttackCritical;
	WeaponProficiencyCriticalBonus m_runesCritical;
	WeaponProficiencyCriticalBonus m_generalCritical;

	std::array<WeaponProficiencyCriticalBonus, COMBAT_COUNT> m_elementCritical = { 0 };
	std::array<double_t, COMBAT_COUNT> m_elementalPierce = { 0 };

	std::unordered_map<uint16_t, WeaponProficiencySpells::Bonus> m_spellsBonuses;

	WeaponProficiencyPerfectShotBonus m_perfectShot;

	std::unordered_map<uint8_t, double_t> m_bestiaryDamage;
};
