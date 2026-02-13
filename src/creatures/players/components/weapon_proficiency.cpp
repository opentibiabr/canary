/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

// Player.hpp already includes the weapon proficiency
#include "creatures/players/player.hpp"
#include "items/weapons/weapons.hpp"
#include "creatures/monsters/monsters.hpp"

#include "config/configmanager.hpp"
#include "io/fileloader.hpp"
#include "utils/tools.hpp"
#include "utils/hash.hpp"

std::unordered_map<uint16_t, Proficiency> WeaponProficiency::proficiencies;

std::array<uint32_t, 9> WeaponProficiency::crossbowExperience = {
	600,
	8000,
	30000,
	150000,
	650000,
	2500000,
	10000000,
	20000000,
	30000000
};

std::array<uint32_t, 9> WeaponProficiency::knightExperience = {
	1250,
	20000,
	80000,
	300000,
	1500000,
	6000000,
	20000000,
	40000000,
	60000000
};

std::array<uint32_t, 9> WeaponProficiency::standardExperience = {
	1750,
	25000,
	100000,
	400000,
	2000000,
	8000000,
	30000000,
	60000000,
	90000000
};

WeaponProficiency::WeaponProficiency(Player &player) :
	m_player(player) { }

void WeaponProficiency::registerPerks(const json &perksJson, ProficiencyLevel &proficiencyLevel) {
	using enum WeaponProficiencyBonus_t;

	uint8_t perkIndex = 0;
	for (const auto &perkJson : perksJson) {
		if (perkIndex > proficiencyLevel.perks.max_size()) {
			g_logger().error("{} - Proficiency level exceeded the maximum perks, skipping perk index above {}", __FUNCTION__, perkIndex + 1);
			break;
		}

		ProficiencyPerk proficiencyPerk;
		proficiencyPerk.type = perkJson["Type"].get<WeaponProficiencyBonus_t>();
		proficiencyPerk.value = perkJson["Value"].get<double_t>();

		uint64_t shiftedValue = 0;
		if (proficiencyPerk.type == SPECIALIZED_MAGIC_LEVEL) {
			shiftedValue = perkJson["DamageType"].get<uint64_t>();
		} else if (proficiencyPerk.type == ELEMENTAL_HIT_CHANCE || proficiencyPerk.type == ELEMENTAL_CRITICAL_EXTRA_DAMAGE) {
			shiftedValue = perkJson["ElementId"].get<uint64_t>();
		}

		if (shiftedValue > 0) {
			const auto unshiftedValue = undoShift(shiftedValue);
			proficiencyPerk.element = getCombatFromCipbiaElement(static_cast<Cipbia_Elementals_t>(unshiftedValue));
		}

		if (perkJson.contains("Range")) {
			proficiencyPerk.range = perkJson["Range"].get<uint8_t>();
		}
		if (perkJson.contains("AugmentType")) {
			proficiencyPerk.augmentType = perkJson["AugmentType"].get<uint8_t>();
		}
		if (perkJson.contains("SpellId")) {
			proficiencyPerk.spellId = perkJson["SpellId"].get<uint16_t>();
		}
		if (perkJson.contains("SkillId")) {
			const auto skill = perkJson["SkillId"].get<uint8_t>();
			
			const auto skillOpt = magic_enum::enum_cast<CipbiaSkills_t>(skill);
			if (skillOpt.has_value()) {
				proficiencyPerk.skillId = getSkillsFromCipbiaSkill(skillOpt.value());
			} else {
				g_logger().error("{} - Invalid skill id {}, skipping skill register", __FUNCTION__, skill);
			}
		}
		if (perkJson.contains("BestiaryId")) {
			proficiencyPerk.bestiaryId = perkJson["BestiaryId"].get<uint16_t>();
		}
		if (perkJson.contains("BestiaryName")) {
			proficiencyPerk.bestiaryName = perkJson["BestiaryName"].get<std::string>();
		}

		proficiencyPerk.index = perkIndex;

		proficiencyLevel.perks[perkIndex] = proficiencyPerk;
		perkIndex++;
	}
}

void WeaponProficiency::registerLevels(const json &levelsJson, Proficiency &proficiency) {
	uint8_t levelIndex = 0;
	for (const auto &levelJson : levelsJson) {
		ProficiencyLevel proficiencyLevel;
		WeaponProficiency::registerPerks(levelJson["Perks"], proficiencyLevel);

		if (levelIndex > proficiency.level.max_size()) {
			g_logger().error("{} - Proficiency '{}' exceeded the maximum level, skipping levels above {}", __FUNCTION__, proficiency.id, levelIndex + 1);
			break;
		}

		for (auto &perk : proficiencyLevel.perks) {
			perk.level = levelIndex;
		}

		proficiency.level[levelIndex] = proficiencyLevel;
		levelIndex++;
	}

	proficiency.maxLevel = levelIndex + 1;
}

std::unordered_map<uint16_t, Proficiency> &WeaponProficiency::getProficiencies() {
	return proficiencies;
}

bool WeaponProficiency::loadFromJson(bool reload /* = false */) {
	g_logger().info("{}oading weapon proficiencies...", reload ? "Rel" : "L");

	if (reload) {
		proficiencies.clear();
	}

	auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
	auto folder = fmt::format("{}/items/proficiencies.json", coreFolder);
	std::ifstream file(folder);
	if (!file.is_open()) {
		g_logger().error("{} - Unable to open file '{}'", __FUNCTION__, folder);
		consoleHandlerExit();
		return false;
	}

	json proficienciesJson;
	try {
		file >> proficienciesJson;
	} catch (const json::parse_error &e) {
		g_logger().error("{} - JSON parsing error in file '{}': {}", __FUNCTION__, folder, e.what());
		consoleHandlerExit();
		return false;
	}

	try {
		for (const auto &proficiencyJson : proficienciesJson) {
			Proficiency proficiency;
			proficiency.id = proficiencyJson["ProficiencyId"].get<uint16_t>();

			WeaponProficiency::registerLevels(proficiencyJson["Levels"], proficiency);

			proficiencies[proficiency.id] = proficiency;
		}
	} catch (const json::exception &e) {
		g_logger().error("{} - JSON exception in file '{}': {}", __FUNCTION__, folder, e.what());
		consoleHandlerExit();
		return false;
	}

	g_logger().info("Weapon proficiencies loaded!");

	return true;
}

void WeaponProficiency::load() {
	proficiency.clear();

	for (const auto &key : m_player.kv()->scoped("weapon-proficiency")->keys()) {
		const auto &kv = m_player.kv()->scoped("weapon-proficiency")->get(key);
		if (!kv.has_value()) {
			continue;
		}
		proficiency[std::stoi(key)] = (deserialize(kv.value()));
	}
}

void WeaponProficiency::save(uint16_t weaponId) const {
	if (!proficiency.contains(weaponId)) {
		return;
	}

	m_player.kv()->scoped("weapon-proficiency")->set(std::to_string(weaponId), serialize(proficiency.at(weaponId)));
}

void WeaponProficiency::saveAll() const {
	for (const auto &[weaponId, weaponData] : proficiency) {
		m_player.kv()->scoped("weapon-proficiency")->set(std::to_string(weaponId), serialize(weaponData));
	}
}

WeaponProficiencyData WeaponProficiency::deserialize(const ValueWrapper &val) {
	auto map = val.get<MapType>();
	if (map.empty()) {
		return {};
	}

	WeaponProficiencyData weaponData;
	weaponData.experience = static_cast<uint32_t>(map["experience"]->get<IntType>());
	weaponData.mastered = map["mastered"]->get<BooleanType>();
	weaponData.perks = deserializePerks(map["perks"]->getVariant());

	return weaponData;
}

std::vector<ProficiencyPerk> WeaponProficiency::deserializePerks(const ValueWrapper &val) {
	auto array = val.get<ArrayType>();
	if (array.empty()) {
		return {};
	}

	std::vector<ProficiencyPerk> perks;

	for (const auto &item : array) {
		perks.emplace_back(deserializePerk(item));
	}

	return perks;
}

ProficiencyPerk WeaponProficiency::deserializePerk(const ValueWrapper &val) {
	auto map = val.get<MapType>();
	if (map.empty()) {
		return {};
	}

	ProficiencyPerk perk;

	perk.index = static_cast<uint8_t>(map["index"]->get<IntType>());
	perk.type = static_cast<WeaponProficiencyBonus_t>(map["type"]->get<IntType>());
	perk.value = map["value"]->get<DoubleType>();
	perk.level = static_cast<uint8_t>(map["level"]->get<IntType>());
	perk.augmentType = static_cast<uint8_t>(map["augmentType"]->get<IntType>());
	perk.bestiaryId = static_cast<uint16_t>(map["bestiaryId"]->get<IntType>());
	perk.bestiaryName = map["bestiaryName"]->get<StringType>();
	perk.element = static_cast<CombatType_t>(map["element"]->get<IntType>());
	perk.range = static_cast<uint8_t>(map["range"]->get<IntType>());
	perk.skillId = static_cast<skills_t>(map["skillId"]->get<IntType>());
	perk.spellId = static_cast<uint16_t>(map["spellId"]->get<IntType>());

	return perk;
}

ValueWrapper WeaponProficiency::serialize(WeaponProficiencyData weaponData) const {
	return {
		std::pair<const std::string, ValueWrapper> { "experience", ValueWrapper(static_cast<IntType>(weaponData.experience)) },
		std::pair<const std::string, ValueWrapper> { "mastered", ValueWrapper(weaponData.mastered) },
		std::pair<const std::string, ValueWrapper> { "perks", serializePerks(weaponData.perks) },
	};
}

ValueWrapper WeaponProficiency::serializePerk(const ProficiencyPerk &perk) const {
	return {
		{ "index", static_cast<IntType>(perk.index) },
		{ "type", static_cast<IntType>(perk.type) },
		{ "value", static_cast<DoubleType>(perk.value) },
		{ "level", static_cast<IntType>(perk.level) },
		{ "augmentType", static_cast<IntType>(perk.augmentType) },
		{ "bestiaryId", static_cast<IntType>(perk.bestiaryId) },
		{ "bestiaryName", static_cast<StringType>(perk.bestiaryName) },
		{ "element", static_cast<IntType>(perk.element) },
		{ "range", static_cast<IntType>(perk.range) },
		{ "skillId", static_cast<IntType>(perk.skillId) },
		{ "spellId", static_cast<IntType>(perk.spellId) },
	};
}

std::vector<ValueWrapper> WeaponProficiency::serializePerks(const std::vector<ProficiencyPerk> &perks) const {
	std::vector<ValueWrapper> arrayWrapper;
	for (const auto &perk : perks) {
		arrayWrapper.emplace_back(serializePerk(perk));
	}

	return arrayWrapper;
}

void WeaponProficiency::applyPerks(uint16_t weaponId) {
	using enum WeaponProficiencyBonus_t;

	const auto &perks = getSelectedPerks(weaponId);
	for (const auto &selectedPerk : perks) {
		WeaponProficiencyCriticalBonus criticalBonus;
		WeaponProficiencySpells::Bonus augmentBonus;
		if (selectedPerk.type == SPELL_AUGMENT) {
			switch (selectedPerk.augmentType) {
				case 2:
					augmentBonus.increase.damage = selectedPerk.value;
					break;
				case 3:
					augmentBonus.increase.heal = selectedPerk.value;
					break;
				case 6:
					augmentBonus.decrease.cooldown = std::abs(selectedPerk.value);
					break;
				case 14:
					augmentBonus.leech.life = selectedPerk.value;
					break;
				case 15:
					augmentBonus.leech.mana = selectedPerk.value;
					break;
				case 16:
					augmentBonus.increase.criticalDamage = selectedPerk.value;
					break;
				case 17:
					augmentBonus.increase.criticalChance = selectedPerk.value;
					break;
				default:
					g_logger().error("[{}] - Unknown augment type {}", __FUNCTION__, selectedPerk.augmentType);
			}
			addSpellBonus(selectedPerk.spellId, augmentBonus);
		} else if (selectedPerk.type == SPECIALIZED_MAGIC_LEVEL) {
			addSpecializedMagic(selectedPerk.element, selectedPerk.value);
		} else if (selectedPerk.type == AUTO_ATTACK_CRITICAL_EXTRA_DAMAGE || selectedPerk.type == AUTO_ATTACK_CRITICAL_HIT_CHANCE) {
			criticalBonus.chance = selectedPerk.type == AUTO_ATTACK_CRITICAL_HIT_CHANCE ? selectedPerk.value : 0;
			criticalBonus.damage = selectedPerk.type == AUTO_ATTACK_CRITICAL_EXTRA_DAMAGE ? selectedPerk.value : 0;
			addAutoAttackCritical(criticalBonus);
		} else if (selectedPerk.type == ELEMENTAL_HIT_CHANCE || selectedPerk.type == ELEMENTAL_CRITICAL_EXTRA_DAMAGE) {
			criticalBonus.chance = selectedPerk.type == ELEMENTAL_HIT_CHANCE ? selectedPerk.value : 0;
			criticalBonus.damage = selectedPerk.type == ELEMENTAL_CRITICAL_EXTRA_DAMAGE ? selectedPerk.value : 0;
			addElementCritical(selectedPerk.element, criticalBonus);
		} else if (selectedPerk.type == RUNE_CRITICAL_HIT_CHANCE || selectedPerk.type == RUNE_CRITICAL_EXTRA_DAMAGE) {
			criticalBonus.chance = selectedPerk.type == RUNE_CRITICAL_HIT_CHANCE ? selectedPerk.value : 0;
			criticalBonus.damage = selectedPerk.type == RUNE_CRITICAL_EXTRA_DAMAGE ? selectedPerk.value : 0;
			addRunesCritical(criticalBonus);
		} else if (selectedPerk.type == CRITICAL_HIT_CHANCE || selectedPerk.type == CRITICAL_EXTRA_DAMAGE) {
			criticalBonus.chance = selectedPerk.type == CRITICAL_HIT_CHANCE ? selectedPerk.value : 0;
			criticalBonus.damage = selectedPerk.type == CRITICAL_EXTRA_DAMAGE ? selectedPerk.value : 0;
			addGeneralCritical(criticalBonus);
		} else if (selectedPerk.type == BESTIARY) {
			addBestiaryDamage(selectedPerk.bestiaryId, selectedPerk.value);
		} else if (selectedPerk.type == POWERFUL_FOE_BONUS) {
			addPowerfulFoeDamage(selectedPerk.value);
		} else if (selectedPerk.type == SKILL_BONUS) {
			addSkillBonus(selectedPerk.skillId, selectedPerk.value);
		} else if (selectedPerk.type == LIFE_LEECH || selectedPerk.type == MANA_LEECH) {
			addSkillBonus(selectedPerk.type == LIFE_LEECH ? SKILL_LIFE_LEECH_AMOUNT : SKILL_MANA_LEECH_AMOUNT, selectedPerk.value * 10000);
		} else if (selectedPerk.type == PERFECT_SHOT_DAMAGE) {
			addPerfectShotBonus(selectedPerk.range, selectedPerk.value);
		} else if (selectedPerk.type == SKILL_PERCENTAGE_AUTO_ATTACK) {
			addSkillPercentage(selectedPerk.skillId, SkillPercentage_t::AutoAttack, selectedPerk.value);
		} else if (selectedPerk.type == SKILL_PERCENTAGE_SPELL_DAMAGE) {
			addSkillPercentage(selectedPerk.skillId, SkillPercentage_t::SpellDamage, selectedPerk.value);
		} else if (selectedPerk.type == SKILL_PERCENTAGE_SPELL_HEALING) {
			addSkillPercentage(selectedPerk.skillId, SkillPercentage_t::SpellHealing, selectedPerk.value);
		} else {
			addStat(selectedPerk.type, selectedPerk.value);
		}
	}

	m_player.sendSkills();
}

std::vector<ProficiencyPerk> WeaponProficiency::getSelectedPerks(uint16_t weaponId) const {
	if (proficiency.find(weaponId) == proficiency.end()) {
		return {};
	}

	return proficiency.at(weaponId).perks;
}

void WeaponProficiency::clearSelectedPerks(uint16_t weaponId) {
	if (proficiency.find(weaponId) != proficiency.end()) {
		proficiency.at(weaponId).perks.clear();
	}
}

void WeaponProficiency::setSelectedPerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId /* = 0 */) {
	using enum WeaponProficiencyBonus_t;

	if (weaponId == 0) {
		weaponId = m_player.getWeaponId(true);
	}

	if (weaponId == 0) {
		g_logger().error("{} - Invalid weapon ID: {}", __FUNCTION__, weaponId);
		return;
	}

	auto proficiencyId = Item::items[weaponId].proficiencyId;
	if (proficiencies.find(proficiencyId) == proficiencies.end()) {
		g_logger().error("{} - Proficiency not found for weapon ID: {}", __FUNCTION__, weaponId);
		return;
	}

	const auto &allProficiencies = proficiencies.at(proficiencyId);
	if (level > allProficiencies.level.max_size()) {
		g_logger().error("{} - Proficiency level exceeds maximum size for weapon ID: {}", __FUNCTION__, weaponId);
		return;
	}
	const auto &selectedLevel = allProficiencies.level.at(level);

	if (perkIndex > selectedLevel.perks.max_size()) {
		g_logger().error("{} - Proficiency level {} exceeds maximum perks size for weapon ID: {}", __FUNCTION__, level, weaponId);
		return;
	}
	const auto &selectedPerk = selectedLevel.perks.at(perkIndex);

	if (proficiency.find(weaponId) != proficiency.end()) {
		proficiency.at(weaponId).perks.emplace_back(selectedPerk);
	}
}

std::unordered_map<std::pair<uint16_t, uint8_t>, double, PairHash, PairEqual> WeaponProficiency::getActiveAugments(uint16_t weaponId) {
	std::unordered_map<std::pair<uint16_t, uint8_t>, double, PairHash, PairEqual> augments;

	weaponId = weaponId == 0 ? m_player.getWeaponId(true) : weaponId;

	if (weaponId == 0) {
		g_logger().error("{} - Invalid weapon ID: {}", __FUNCTION__, weaponId);
		return augments;
	}

	const auto &perks = getSelectedPerks(weaponId);

	for (const auto &perk : perks) {
		if (perk.spellId && perk.augmentType) {
			const auto key = std::make_pair(perk.spellId, perk.augmentType);
			augments[key] += perk.value;
		}
	}

	return augments;
}

const std::array<uint32_t, 9>& WeaponProficiency::getExperienceArray(uint16_t weaponId) const {
	auto &experienceArray = standardExperience;

	if (weaponId == 0) {
		g_logger().error("{} - Invalid weapon ID: {}", __FUNCTION__, weaponId);
		return experienceArray;
	}

	if (!Item::items[weaponId].vocationString.empty()) {
		experienceArray = knightExperience;
	} else if (Item::items[weaponId].ammoType == AMMO_BOLT) {
		experienceArray = crossbowExperience;
	}

	return experienceArray;
}

uint32_t WeaponProficiency::nextLevelExperience(uint16_t weaponId) {
	const auto &experienceArray = getExperienceArray(weaponId);

	if (proficiencies.find(Item::items[weaponId].proficiencyId) == proficiencies.end()) {
		g_logger().error("{} - Proficiency not found for weapon ID: {}", __FUNCTION__, weaponId);
		return 0;
	}

	const auto &proficiencyInfo = proficiencies.at(Item::items[weaponId].proficiencyId);
	if (proficiency.find(weaponId) == proficiency.end()) {
		return experienceArray[0];
	}

	const auto &playerProficiency = proficiency.at(weaponId);
	for (uint8_t i = 0; i < (proficiencyInfo.maxLevel - 1) + 2; ++i) {
		if (playerProficiency.experience >= experienceArray[i]) {
			continue;
		}

		return experienceArray[i] - playerProficiency.experience;
	}

	return 0;
}

uint32_t WeaponProficiency::getMaxExperience(uint16_t weaponId) const {
	const auto &experienceArray = getExperienceArray(weaponId);
	if (proficiencies.find(Item::items[weaponId].proficiencyId) == proficiencies.end()) {
		g_logger().error("{} - Proficiency not found for weapon ID: {}", __FUNCTION__, weaponId);
		return 0;
	}
	const auto &proficiencyInfo = proficiencies.at(Item::items[weaponId].proficiencyId);
	uint8_t masteryLevel = (proficiencyInfo.maxLevel - 1) + 2;

	if (proficiency.find(weaponId) == proficiency.end() || masteryLevel > experienceArray.size() - 1) {
		return experienceArray[experienceArray.size() - 1];
	}

	return experienceArray[masteryLevel];
}

void WeaponProficiency::addExperience(uint32_t experience, uint16_t weaponId /* = 0 */) {
	weaponId = weaponId > 0 ? weaponId : m_player.getWeaponId(true);

	if (weaponId == 0) {
		g_logger().error("{} - Invalid weapon ID: {}", __FUNCTION__, weaponId);
		return;
	}

	if (nextLevelExperience(weaponId) <= 0) {
		return;
	}

	uint32_t maxExperience = getMaxExperience(weaponId);

	if (!proficiency.contains(weaponId)) {
		proficiency.emplace(weaponId, experience > maxExperience ? maxExperience : experience);
		m_player.sendWeaponProficiency(weaponId);

		return;
	}

	uint32_t newExperience = proficiency[weaponId].experience + experience;

	if (newExperience >= maxExperience) {
		proficiency[weaponId].mastered = true;
		proficiency[weaponId].experience = maxExperience;
		m_player.sendWeaponProficiency(weaponId);

		return;
	}

	proficiency[weaponId].experience = newExperience;

	m_player.sendWeaponProficiency(weaponId);
}

uint32_t WeaponProficiency::getBosstiaryExperience(BosstiaryRarity_t rarity) const {
	switch (rarity) {
		case BosstiaryRarity_t::RARITY_BANE:
			return 500;
		case BosstiaryRarity_t::RARITY_ARCHFOE:
			return 5000;
		case BosstiaryRarity_t::RARITY_NEMESIS:
			return 15000;
		default:
			return 0;
	}
}

uint32_t WeaponProficiency::getBestiaryExperience(uint8_t monsterStar) const {
	return -1.133 * std::pow(monsterStar, 5) + 14.083 * std::pow(monsterStar, 4) + -59.666 * std::pow(monsterStar, 3) + 102.916 * std::pow(monsterStar, 2) + -27.2 * monsterStar + 1.0;
}

uint32_t WeaponProficiency::getExperience(uint16_t weaponId /* = 0 */) const {
	if (proficiency.find(weaponId) == proficiency.end()) {
		return 0;
	}

	return proficiency.at(weaponId).experience;
}

bool WeaponProficiency::isUpgradeAvailable(uint16_t weaponId /* = 0 */) const {
	weaponId = weaponId > 0 ? weaponId : m_player.getWeaponId(true);

	if (weaponId == 0) {
		g_logger().error("{} - Invalid weapon ID: {}", __FUNCTION__, weaponId);
		return false;
	}

	const auto &experienceArray = getExperienceArray(weaponId);

	auto proficiencyId = Item::items[weaponId].proficiencyId;

	if (proficiency.find(weaponId) == proficiency.end()) {
		return false;
	}

	if (proficiencies.find(proficiencyId) == proficiencies.end()) {
		return false;
	}

	const auto &proficiencyInfo = proficiencies.at(proficiencyId);

	const auto &playerProficiency = proficiency.at(weaponId);

	for (uint8_t i = 0; i < proficiencyInfo.maxLevel; ++i) {
		if (playerProficiency.experience < experienceArray[i]) {
			break;
		}

		if (playerProficiency.perks.size() < i + 1) {
			return true;
		}
	}

	return false;
}

void WeaponProficiency::addStat(WeaponProficiencyBonus_t type, double_t value) {
	auto enumValue = static_cast<uint8_t>(type);
	if (enumValue >= magic_enum::enum_count<WeaponProficiencyBonus_t>()) {
		g_logger().error("[{}]. Type {} is out of range, value {}. Error message: {}", __FUNCTION__, enumValue, value, "Enum value is out of range");
		return;
	}
	m_stats[enumValue] += value;
}

double_t WeaponProficiency::getStat(WeaponProficiencyBonus_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_stats.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return 0;
}

void WeaponProficiency::resetStats() {
	m_stats.fill(0);
}

void WeaponProficiency::addSkillPercentage(skills_t skill, SkillPercentage_t type, double_t value) {
	m_skillPercentage.skill = skill;

	switch (type) {
		case SkillPercentage_t::AutoAttack:
			m_skillPercentage.autoAttack += value;
			break;
		case SkillPercentage_t::SpellDamage:
			m_skillPercentage.spellDamage += value;
			break;
		case SkillPercentage_t::SpellHealing:
			m_skillPercentage.spellHealing += value;
			break;
		default:
			break;
	}
}

const SkillPercentage &WeaponProficiency::getSkillPercentage() const {
	return m_skillPercentage;
}

void WeaponProficiency::addSpecializedMagic(CombatType_t type, uint16_t value) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_specializedMagic.at(enumValue) += value;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range, value {}. Error message: {}", __FUNCTION__, enumValue, value, e.what());
	}
}

uint16_t WeaponProficiency::getSpecializedMagic(CombatType_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_specializedMagic.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return 0;
}

void WeaponProficiency::resetSpecializedMagic() {
	m_specializedMagic.fill(0);
}

uint32_t WeaponProficiency::getSkillBonus(skills_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_skills.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Skill type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return 0;
}

void WeaponProficiency::addSkillBonus(skills_t type, uint32_t value) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_skills.at(enumValue) += value;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range, value {}. Error message: {}", __FUNCTION__, enumValue, value, e.what());
	}
}

void WeaponProficiency::resetSkillBonuses() {
	m_skills.fill(0);
}

double_t WeaponProficiency::getPowerfulFoeDamage() const {
	return m_powerfulFoeDamage;
}

void WeaponProficiency::addPowerfulFoeDamage(double_t percent) {
	m_powerfulFoeDamage += percent;
}

void WeaponProficiency::resetPowerfulFoeDamage() {
	m_powerfulFoeDamage = 0;
}

const WeaponProficiencyCriticalBonus &WeaponProficiency::getAutoAttackCritical() const {
	return m_autoAttackCritical;
}

void WeaponProficiency::addAutoAttackCritical(const WeaponProficiencyCriticalBonus &bonus) {
	m_autoAttackCritical.chance += bonus.chance;
	m_autoAttackCritical.damage += bonus.damage;
}

const WeaponProficiencyCriticalBonus &WeaponProficiency::getRunesCritical() const {
	return m_runesCritical;
}

void WeaponProficiency::addRunesCritical(const WeaponProficiencyCriticalBonus& bonus) {
	m_runesCritical.chance += bonus.chance;
	m_runesCritical.damage += bonus.damage;
}

const WeaponProficiencyCriticalBonus &WeaponProficiency::getGeneralCritical() const {
	return m_generalCritical;
}

void WeaponProficiency::addGeneralCritical(const WeaponProficiencyCriticalBonus &bonus) {
	m_generalCritical.chance += bonus.chance;
	m_generalCritical.damage += bonus.damage;
}

const WeaponProficiencyCriticalBonus &WeaponProficiency::getElementCritical(CombatType_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_elementCritical.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return {};
}

void WeaponProficiency::addElementCritical(CombatType_t type, const WeaponProficiencyCriticalBonus &bonus) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_elementCritical.at(enumValue).chance += bonus.chance;
		m_elementCritical.at(enumValue).damage += bonus.damage;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
}

uint32_t WeaponProficiency::getSpellBonus(uint16_t spellId, WeaponProficiencySpellBoost_t boost) const {
	using enum WeaponProficiencySpellBoost_t;

	if (!m_spellsBonuses.contains(spellId)) {
		return 0;
	}

	const auto &[leech, increase, decrease] = m_spellsBonuses.at(spellId);
	switch (boost) {
		case COOLDOWN:
			return decrease.cooldown;
		case MANA:
			return decrease.manaCost;
		case SECONDARY_GROUP_COOLDOWN:
			return decrease.secondaryGroupCooldown;
		case CRITICAL_CHANCE:
			return increase.criticalChance;
		case CRITICAL_DAMAGE:
			return increase.criticalDamage;
		case DAMAGE:
			return increase.damage;
		case DAMAGE_REDUCTION:
			return increase.damageReduction;
		case HEAL:
			return increase.heal;
		case LIFE_LEECH:
			return leech.life;
		case MANA_LEECH:
			return leech.mana;
		default:
			return 0;
	}
}

void WeaponProficiency::addSpellBonus(uint16_t spellId, const WeaponProficiencySpells::Bonus &bonus) {
	if (m_spellsBonuses.contains(spellId)) {
		m_spellsBonuses[spellId].decrease.cooldown += bonus.decrease.cooldown;
		m_spellsBonuses[spellId].decrease.manaCost += bonus.decrease.manaCost;
		m_spellsBonuses[spellId].decrease.secondaryGroupCooldown += bonus.decrease.secondaryGroupCooldown;
		m_spellsBonuses[spellId].increase.aditionalTarget += bonus.increase.aditionalTarget;
		m_spellsBonuses[spellId].increase.area = bonus.increase.area;
		m_spellsBonuses[spellId].increase.criticalChance += bonus.increase.criticalChance;
		m_spellsBonuses[spellId].increase.criticalDamage += bonus.increase.criticalDamage;
		m_spellsBonuses[spellId].increase.damage += bonus.increase.damage;
		m_spellsBonuses[spellId].increase.damageReduction += bonus.increase.damageReduction;
		m_spellsBonuses[spellId].increase.duration += bonus.increase.duration;
		m_spellsBonuses[spellId].increase.heal += bonus.increase.heal;
		m_spellsBonuses[spellId].leech.life += bonus.leech.life;
		m_spellsBonuses[spellId].leech.mana += bonus.leech.mana;
		return;
	}
	m_spellsBonuses[spellId] = bonus;
}

void WeaponProficiency::addPerfectShotBonus(uint8_t range, uint8_t damage) {
	m_perfectShot.range = range;
	m_perfectShot.damage = damage;
}

const WeaponProficiencyPerfectShotBonus &WeaponProficiency::getPerfectShotBonus() const {
	return m_perfectShot;
}

void WeaponProficiency::resetPerfectShotBonus() {
	m_perfectShot = {};
}

double_t WeaponProficiency::getBestiaryDamage(uint8_t race) const {
	if (!m_bestiaryDamage.contains(race)) {
		return 0;
	}

	return m_bestiaryDamage.at(race);
}

void WeaponProficiency::addBestiaryDamage(uint8_t race, double_t bonus) {
	if (m_bestiaryDamage.contains(race)) {
		m_bestiaryDamage[race] += bonus;
		return;
	}
	m_bestiaryDamage[race] = bonus;
}

void WeaponProficiency::resetBestiaryDamage() {
	m_bestiaryDamage.clear();
}

uint16_t WeaponProficiency::getSkillValueFromWeapon() const {
	const auto &weapon = m_player.getWeapon(true);
	if (!weapon) {
		return 0;
	}

	uint16_t skill = 0;

	switch (Item::items[weapon->getID()].type) {
		case ITEM_TYPE_SWORD:
			return m_player.getSkillLevel(SKILL_SWORD);
		case ITEM_TYPE_AXE:
			return m_player.getSkillLevel(SKILL_AXE);
		case ITEM_TYPE_CLUB:
			return m_player.getSkillLevel(SKILL_CLUB);
		case ITEM_TYPE_WAND:
			return m_player.getMagicLevel();
		case ITEM_TYPE_DISTANCE:
			return m_player.getSkillLevel(SKILL_DISTANCE);
		default:
			return 0;
	}
}

void WeaponProficiency::applyAutoAttackCritical(CombatDamage &damage) const {
	if (damage.origin == ORIGIN_FIST || damage.origin == ORIGIN_MELEE || damage.origin == ORIGIN_RANGED) {
		const auto &autoAttackCritical = getAutoAttackCritical();
		damage.criticalChance += autoAttackCritical.chance * 10000;
		damage.criticalDamage += autoAttackCritical.damage * 10000;
	}
}

void WeaponProficiency::applyRunesCritical(CombatDamage &damage, bool aggressive) const {
	if (!damage.runeSpellName.empty() && aggressive) {
		const auto &runesCritical = getRunesCritical();
		damage.criticalChance += runesCritical.chance * 10000;
		damage.criticalDamage += runesCritical.damage * 10000;
	}
}

void WeaponProficiency::applyElementCritical(CombatDamage &damage) const {
	const auto &elementCritical = getElementCritical(damage.primary.type);
	if (elementCritical.chance > 0 || elementCritical.damage > 0) {
		damage.criticalChance += elementCritical.chance * 10000;
		damage.criticalDamage += elementCritical.damage * 10000;
	}
}

void WeaponProficiency::applyBestiaryDamage(CombatDamage &damage, const std::shared_ptr<Monster> &monster) const {
	if (!monster) {
		return;
	}
	const auto &monsterType = monster->getMonsterType();
	if (!monsterType) {
		return;
	}

	const auto race = magic_enum::enum_integer(monsterType->info.bestiaryRace);
	if (race > 0) {
		const auto bestiaryDamage = getBestiaryDamage(race);
		damage.primary.value *= 1 + bestiaryDamage;
		damage.secondary.value *= 1 + bestiaryDamage;
	}
}

void WeaponProficiency::applyBossDamage(CombatDamage &damage, const std::shared_ptr<Monster> &monster) const {
	using enum WeaponProficiencyBonus_t;
	if (!monster) {
		return;
	}

	const auto isBoss = monster->getMonsterType()->isBoss();
	if (isBoss) {
		const auto bonusDamage = getStat(POWERFUL_FOE_BONUS);
		damage.primary.value *= 1 + bonusDamage;
		damage.secondary.value *= 1 + bonusDamage;
	}
}

void WeaponProficiency::applyPowerfulFoeDamage(CombatDamage &damage, const std::shared_ptr<Monster> &monster) const {
	using enum WeaponProficiencyBonus_t;
	if (!monster) {
		return;
	}

	const auto forgeStack = monster->getForgeStack();
	if (forgeStack > 0 || monster->getMonsterType()->isBoss()) {
		const auto bonusDamage = getPowerfulFoeDamage();
		damage.primary.value *= 1 + bonusDamage;
		damage.secondary.value *= 1 + bonusDamage;
	}
}

void WeaponProficiency::applySkillAutoAttackPercentage(CombatDamage &damage) const {
	using enum WeaponProficiencyBonus_t;

	if (damage.origin != ORIGIN_FIST && damage.origin != ORIGIN_MELEE && damage.origin != ORIGIN_RANGED) {
		return;
	}

	const auto &weapon = m_player.getWeapon(true);
	if (!weapon) {
		return;
	}

	const auto &skillPercentage = getSkillPercentage();
	if (skillPercentage.autoAttack <= 0) {
		return;
	}

	const auto bonusDamage = m_player.getSkillLevel(skillPercentage.skill) * skillPercentage.autoAttack;

	if (damage.primary.type != COMBAT_NONE) {
		damage.primary.value -= std::ceil(bonusDamage);
	}
	if (damage.secondary.type != COMBAT_NONE) {
		damage.secondary.value -= std::ceil(bonusDamage);
	}
}

void WeaponProficiency::applySkillSpellPercentage(CombatDamage &damage, bool healing) const {
	using enum WeaponProficiencyBonus_t;

	if (damage.instantSpellName.empty()) {
		return;
	}

	if (healing && damage.primary.type != COMBAT_HEALING) {
		return;
	}

	const auto &weapon = m_player.getWeapon(true);
	if (!weapon) {
		return;
	}

	const auto &skillPercentage = getSkillPercentage();
	const auto skillPercentageValue = healing ? skillPercentage.spellHealing : skillPercentage.spellDamage;
	if (skillPercentageValue <= 0) {
		return;
	}

	const auto bonusDamage = m_player.getSkillLevel(skillPercentage.skill) * skillPercentageValue;

	if (damage.primary.type != COMBAT_NONE) {
		damage.primary.value = std::abs(damage.primary.value) + std::ceil(bonusDamage);
	}
	if (damage.secondary.type != COMBAT_NONE) {
		damage.secondary.value = std::abs(damage.secondary.value) + std::ceil(bonusDamage);
	}

	if (!healing) {
		damage.primary.value = -damage.primary.value;
		damage.secondary.value = -damage.secondary.value;
	}
}

void WeaponProficiency::applyOn(WeaponProficiencyHealth_t healthType, WeaponProficiencyGain_t gainType) const {
	using enum WeaponProficiencyBonus_t;

	WeaponProficiencyBonus_t statsType;
	if (healthType == WeaponProficiencyHealth_t::LIFE) {
		statsType = gainType == WeaponProficiencyGain_t::KILL ? LIFE_GAIN_ON_KILL : LIFE_GAIN_ON_HIT;
	} else {
		statsType = gainType == WeaponProficiencyGain_t::KILL ? MANA_GAIN_ON_KILL : MANA_GAIN_ON_HIT;
	}

	CombatParams params;
	params.combatType = COMBAT_HEALING;
	params.soundImpactEffect = SoundEffect_t::SPELL_LIGHT_HEALING;

	CombatDamage damage;

	damage.origin = ORIGIN_WEAPON_PROFICIENCY;

	damage.primary.type = params.combatType;
	damage.primary.value = getStat(statsType);

	const auto &playerCreature = m_player.getCreature();
	if (healthType == WeaponProficiencyHealth_t::LIFE) {
		Combat::doCombatHealth(nullptr, playerCreature, damage, params);
	} else {
		Combat::doCombatMana(nullptr, playerCreature, damage, params);
	}
}

void WeaponProficiency::applySpellAugment(CombatDamage &damage, uint16_t spellId) const {
	if (m_spellsBonuses.contains(spellId)) {
		damage.damageMultiplier += m_spellsBonuses.at(spellId).increase.damage * 10000;
		damage.healingMultiplier += m_spellsBonuses.at(spellId).increase.heal * 10000;
		damage.criticalChance += m_spellsBonuses.at(spellId).increase.criticalChance * 10000;
		damage.criticalDamage += m_spellsBonuses.at(spellId).increase.criticalDamage * 10000;
		damage.lifeLeech += m_spellsBonuses.at(spellId).leech.life * 10000;
		damage.manaLeech += m_spellsBonuses.at(spellId).leech.mana * 10000;
	}
}

std::vector<std::pair<std::string, double>> WeaponProficiency::getActiveBestiariesDamage() const {
	using enum WeaponProficiencyBonus_t;
	std::vector<std::pair<std::string, double>> bestiariesDamage;

	const auto weaponId = m_player.getWeaponId(true);

	const auto &perks = getSelectedPerks(weaponId);
	for (const auto &perk : perks) {
		if (perk.type == BESTIARY && !perk.bestiaryName.empty()) {
			bestiariesDamage.emplace_back(perk.bestiaryName, perk.value);
		}
	}

	return bestiariesDamage;
}

std::optional<std::pair<uint8_t, double>> WeaponProficiency::getActiveElementalCriticalType(WeaponProficiencyBonus_t criticalType) const {
	using enum WeaponProficiencyBonus_t;

	if (criticalType != ELEMENTAL_HIT_CHANCE && criticalType != ELEMENTAL_CRITICAL_EXTRA_DAMAGE) {
		return std::nullopt;
	}

	const auto weaponId = m_player.getWeaponId(true);

	const auto &perks = getSelectedPerks(weaponId);
	for (const auto &perk : perks) {
		if (perk.type == criticalType && perk.element != COMBAT_NONE) {
			const auto cipElement = getCipbiaElement(perk.element);
			return std::make_pair(cipElement, perk.value);
		}
	}

	return std::nullopt;
}

void WeaponProficiency::clearAllStats() {
	resetStats();
	resetSpecializedMagic();
	resetSkillBonuses();
	resetPowerfulFoeDamage();
	resetBestiaryDamage();

	m_skillPercentage.clear();
	m_autoAttackCritical.clear();
	m_runesCritical.clear();
	m_generalCritical.clear();
	m_elementCritical.fill({});
	m_spellsBonuses.clear();
}
	
