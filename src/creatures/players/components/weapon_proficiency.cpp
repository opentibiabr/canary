/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <algorithm>
#include <cmath>
#include <limits>

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <optional>
	#include <string_view>
	#include <variant>
#endif

// Player.hpp already includes the weapon
#include "creatures/players/player.hpp"
#include "creatures/monsters/monster.hpp"
#include "items/weapons/weapons.hpp"
#include "creatures/monsters/monsters.hpp"
#include "canary_server.hpp"

#include "config/configmanager.hpp"
#include "io/fileloader.hpp"
#include "io/io_bosstiary.hpp"
#include "utils/tools.hpp"
#include "utils/hash.hpp"
#include "utils/transparent_string_hash.hpp"
#include "kv/value_wrapper.hpp"

#include "kv/kv.hpp"

namespace {
	enum class WeaponProficiencyAugmentType : uint8_t {
		DAMAGE = 2,
		HEAL = 3,
		COOLDOWN = 6,
		LIFE_LEECH = 14,
		MANA_LEECH = 15,
		CRITICAL_DAMAGE = 16,
		CRITICAL_CHANCE = 17,
	};

	enum class KnightHealingSpell : uint16_t {
		WOUND_CLEANSING = 123,
		INTENSE_WOUND_CLEANSING = 158,
	};

	constexpr int32_t MIN_TRACKED_SKILL = static_cast<int32_t>(SKILL_FIRST);
	constexpr int32_t MAX_TRACKED_SKILL = static_cast<int32_t>(SKILL_MAGLEVEL);
	constexpr size_t MASTERY_EXPERIENCE_OFFSET = 2;
	constexpr uint8_t MAX_SHAPED_PERK_RANK = 10;
	constexpr uint16_t LUNAR_ASCENSION_ORB_ID = 53695;
	constexpr uint16_t RESHAPE_DUST_COST = 250;
	constexpr uint8_t RESHAPE_OFFER_COUNT = 3;
	// CipSoft only documents this as a "small chance"; keep the server policy explicit until exact odds are published.
	constexpr uint8_t HIGHER_INITIAL_RANK_CHANCE_PERCENT = 5;

	constexpr std::array<uint16_t, 34> COMMON_SHAPING_PERK_IDS = {
		251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261,
		262, 263, 264, 265, 266, 267, 268, 269, 270, 271,
		281, 282, 283, 284, 285, 286, 287,
		291, 292, 293,
		321, 322, 323,
	};

	constexpr std::array<std::string_view, 21> BESTIARY_SHAPING_NAMES = {
		"Amphibic", "Aquatic", "Bird", "Construct", "Demon", "Dragon", "Elemental",
		"Fey", "Giant", "Human", "Humanoid", "Lycanthrope", "Magical", "Mammal",
		"Plant", "Reptile", "Slime", "Undead", "Vermin", "Extra Dimensional", "Inkborn",
	};

	constexpr std::array<std::array<uint16_t, 6>, 5> VOCATION_SHAPING_SPELL_IDS = { {
		{ 80, 105, 106, 59, 316, 261 },
		{ 124, 302, 303, 258, 57, 122 },
		{ 13, 24, 240, 260, 310, 23 },
		{ 43, 120, 263, 262, 317, 318 },
		{ 289, 288, 294, 287, 301, 290 },
	} };

	[[nodiscard]] double_t interpolateShapedPerkValue(double_t minimum, double_t maximum, uint8_t rank) {
		return minimum + (maximum - minimum) * static_cast<double_t>(rank) / MAX_SHAPED_PERK_RANK;
	}

	[[nodiscard]] std::optional<std::pair<size_t, uint8_t>> getVocationAugmentCoordinates(uint16_t perkId) {
		for (size_t vocationIndex = 0; vocationIndex < VOCATION_SHAPING_SPELL_IDS.size(); ++vocationIndex) {
			const auto baseId = static_cast<uint16_t>(1 + vocationIndex * 50);
			if (perkId < baseId || perkId > baseId + 45) {
				continue;
			}

			const auto localId = static_cast<uint16_t>(perkId - baseId);
			const auto spellIndex = static_cast<uint8_t>(localId % 10);
			const auto augmentGroup = static_cast<uint8_t>(localId / 10);
			if (spellIndex >= VOCATION_SHAPING_SPELL_IDS[vocationIndex].size() || augmentGroup > 4) {
				return std::nullopt;
			}

			return std::make_pair(vocationIndex, static_cast<uint8_t>(augmentGroup * 10 + spellIndex));
		}

		return std::nullopt;
	}

	[[nodiscard]] uint8_t rollReshapeInitialRank() {
		return uniform_random(1, 100) <= HIGHER_INITIAL_RANK_CHANCE_PERCENT ? 1 : 0;
	}

	// The 15.30 client asset still carries the pre-adjustment values for these server-side vocation changes.
	[[nodiscard]] double_t getServerAdjustedSpellAugmentValue(const ProficiencyPerk &perk, WeaponProficiencyAugmentType augmentType) {
		const auto spellId = static_cast<KnightHealingSpell>(perk.spellId);

		if (augmentType == WeaponProficiencyAugmentType::COOLDOWN && spellId == KnightHealingSpell::INTENSE_WOUND_CLEANSING) {
			return perk.value * 0.2;
		}

		if (augmentType != WeaponProficiencyAugmentType::HEAL) {
			return perk.value;
		}

		switch (spellId) {
			case KnightHealingSpell::WOUND_CLEANSING:
			case KnightHealingSpell::INTENSE_WOUND_CLEANSING:
				return perk.value * 2.0;
			default:
				return perk.value;
		}
	}

	[[nodiscard]] bool isTrackedWeaponProficiencySkill(skills_t skill) {
		const auto enumValue = static_cast<int32_t>(skill);
		return enumValue >= MIN_TRACKED_SKILL && enumValue <= MAX_TRACKED_SKILL;
	}

	uint32_t scaleWeaponProficiencyExperienceGain(uint32_t experience) {
		auto multiplier = g_configManager().getFloat(WEAPON_PROFICIENCY_GAIN_MULTIPLIER);
		if (multiplier < 0.0f) {
			multiplier = 0.0f;
		}

		const auto scaledExperience = static_cast<uint64_t>(std::llround(static_cast<double>(experience) * multiplier));
		return static_cast<uint32_t>(std::min<uint64_t>(scaledExperience, std::numeric_limits<uint32_t>::max()));
	}

	bool usesKnightProficiencyTable(const ItemType &itemType) {
		if (itemType.weaponType != WEAPON_SWORD && itemType.weaponType != WEAPON_AXE && itemType.weaponType != WEAPON_CLUB) {
			return false;
		}

		return asLowerCaseString(itemType.vocationString).find("knight") != std::string::npos;
	}

	size_t getMasteryExperienceTierCount(const Proficiency &proficiencyInfo, const std::vector<uint32_t> &experienceArray) {
		if (proficiencyInfo.maxLevel == 0 || experienceArray.empty()) {
			return 0;
		}

		const auto masteryLevels = static_cast<size_t>(proficiencyInfo.maxLevel) + MASTERY_EXPERIENCE_OFFSET;
		return std::min(experienceArray.size(), masteryLevels);
	}
}

std::unordered_map<uint16_t, Proficiency> WeaponProficiency::proficiencies;

std::vector<uint32_t> WeaponProficiency::crossbowExperience = {
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

std::vector<uint32_t> WeaponProficiency::knightExperience = {
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

std::vector<uint32_t> WeaponProficiency::standardExperience = {
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

bool WeaponProficiency::isValidWeaponId(uint16_t weaponId) const {
	return weaponId > 0 && weaponId < Item::items.size();
}

std::vector<uint16_t> WeaponProficiency::getShapingPerkPool(uint16_t vocationId) {
	if (vocationId < VOCATION_KNIGHT_CIP || vocationId > VOCATION_MONK_CIP) {
		return {};
	}

	std::vector<uint16_t> perkIds;
	perkIds.reserve(64);
	const auto vocationBaseId = static_cast<uint16_t>(1 + (vocationId - VOCATION_KNIGHT_CIP) * 50);
	for (uint16_t augmentGroup = 0; augmentGroup < 5; ++augmentGroup) {
		for (uint16_t spellIndex = 0; spellIndex < 6; ++spellIndex) {
			perkIds.push_back(static_cast<uint16_t>(vocationBaseId + augmentGroup * 10 + spellIndex));
		}
	}
	perkIds.insert(perkIds.end(), COMMON_SHAPING_PERK_IDS.begin(), COMMON_SHAPING_PERK_IDS.end());
	return perkIds;
}

std::optional<ProficiencyPerk> WeaponProficiency::getShapedPerkDefinition(uint16_t perkId, uint8_t rank, skills_t highestCombatSkill) {
	using enum WeaponProficiencyBonus_t;

	if (rank > MAX_SHAPED_PERK_RANK) {
		return std::nullopt;
	}

	ProficiencyPerk perk;
	const auto setValue = [&perk, rank](WeaponProficiencyBonus_t type, double_t minimum, double_t maximum) {
		perk.type = type;
		perk.value = interpolateShapedPerkValue(minimum, maximum, rank);
	};

	if (perkId >= 251 && perkId <= 271) {
		const auto bestiaryIndex = static_cast<size_t>(perkId - 251);
		setValue(WEAPON_PROFICIENCY_BESTIARY, 0.005, 0.025);
		perk.bestiaryId = static_cast<uint16_t>(bestiaryIndex + 1);
		perk.bestiaryName = BESTIARY_SHAPING_NAMES[bestiaryIndex];
		return perk;
	}

	switch (perkId) {
		case 281:
			setValue(RUNE_CRITICAL_HIT_CHANCE, 0.005, 0.015);
			return perk;
		case 282:
			setValue(AUTO_ATTACK_CRITICAL_HIT_CHANCE, 0.005, 0.025);
			return perk;
		case 283:
			setValue(RUNE_CRITICAL_EXTRA_DAMAGE, 0.02, 0.15);
			return perk;
		case 284:
			setValue(AUTO_ATTACK_CRITICAL_EXTRA_DAMAGE, 0.03, 0.20);
			return perk;
		case 285:
			setValue(LIFE_GAIN_ON_HIT, 2.0, 12.0);
			return perk;
		case 286:
			setValue(MANA_GAIN_ON_KILL, 4.0, 24.0);
			return perk;
		case 287:
			setValue(LIFE_GAIN_ON_KILL, 10.0, 50.0);
			return perk;
		case 291:
			setValue(SKILL_PERCENTAGE_AUTO_ATTACK, 0.02, 0.10);
			perk.skillId = highestCombatSkill;
			return perk;
		case 292:
			setValue(SKILL_PERCENTAGE_SPELL_DAMAGE, 0.01, 0.08);
			perk.skillId = highestCombatSkill;
			return perk;
		case 293:
			setValue(SKILL_PERCENTAGE_SPELL_HEALING, 0.02, 0.10);
			perk.skillId = highestCombatSkill;
			return perk;
		case 321:
			setValue(ALPHA_STRIKE_EXTRA_DAMAGE, 0.02, 0.10);
			return perk;
		case 322:
			setValue(OMEGA_STRIKE_EXTRA_DAMAGE, 0.005, 0.025);
			return perk;
		case 323:
			setValue(ARMOR_PENETRATION, 0.04, 0.10);
			return perk;
		default:
			break;
	}

	const auto augmentCoordinates = getVocationAugmentCoordinates(perkId);
	if (!augmentCoordinates) {
		return std::nullopt;
	}

	const auto [vocationIndex, encodedAugment] = *augmentCoordinates;
	const auto augmentGroup = static_cast<uint8_t>(encodedAugment / 10);
	const auto spellIndex = static_cast<uint8_t>(encodedAugment % 10);
	perk.type = SPELL_AUGMENT;
	perk.spellId = VOCATION_SHAPING_SPELL_IDS[vocationIndex][spellIndex];
	switch (augmentGroup) {
		case 0:
			perk.augmentType = static_cast<uint8_t>(WeaponProficiencyAugmentType::CRITICAL_CHANCE);
			perk.value = interpolateShapedPerkValue(0.01, 0.03, rank);
			break;
		case 1:
			perk.augmentType = static_cast<uint8_t>(WeaponProficiencyAugmentType::CRITICAL_DAMAGE);
			perk.value = interpolateShapedPerkValue(0.05, 0.20, rank);
			break;
		case 2:
			perk.augmentType = static_cast<uint8_t>(WeaponProficiencyAugmentType::DAMAGE);
			perk.value = interpolateShapedPerkValue(0.01, 0.03, rank);
			break;
		case 3:
			perk.augmentType = static_cast<uint8_t>(WeaponProficiencyAugmentType::MANA_LEECH);
			perk.value = interpolateShapedPerkValue(0.01, 0.06, rank);
			break;
		case 4:
			perk.augmentType = static_cast<uint8_t>(WeaponProficiencyAugmentType::LIFE_LEECH);
			perk.value = interpolateShapedPerkValue(0.01, 0.12, rank);
			break;
		default:
			return std::nullopt;
	}

	return perk;
}

uint16_t WeaponProficiency::getShapingSlotCost(size_t currentShapedPerks) {
	if (currentShapedPerks == 0) {
		return 250;
	}
	if (currentShapedPerks == 1) {
		return 1000;
	}
	return 0;
}

uint16_t WeaponProficiency::getShapingRefineCost(uint8_t currentRank) {
	if (currentRank >= MAX_SHAPED_PERK_RANK) {
		return 0;
	}
	return static_cast<uint16_t>(125 + 75 * currentRank);
}

static void registerPerks(const nlohmann::json &perksJson, ProficiencyLevel &proficiencyLevel) {
	using enum WeaponProficiencyBonus_t;

	uint8_t perkIndex = 0;
	const uint8_t maxPerks = g_configManager().getNumber(WEAPON_PROFICIENCY_MAX_PERKS_PER_LEVEL);
	for (const auto &perkJson : perksJson) {
		if (perkIndex >= maxPerks) {
			g_logger().error("{} - Proficiency level exceeded the maximum perks, skipping perk index above {}", __FUNCTION__, perkIndex + 1);
			break;
		}

		ProficiencyPerk proficiencyPerk;
		proficiencyPerk.type = perkJson["Type"].get<WeaponProficiencyBonus_t>();
		if (proficiencyPerk.type != HOMING_MISSILE) {
			proficiencyPerk.value = perkJson["Value"].get<double_t>();
		}

		uint64_t shiftedValue = 0;
		if (proficiencyPerk.type == SPECIALIZED_MAGIC_LEVEL) {
			shiftedValue = perkJson["DamageType"].get<uint64_t>();
		} else if (proficiencyPerk.type == ELEMENTAL_HIT_CHANCE || proficiencyPerk.type == ELEMENTAL_CRITICAL_EXTRA_DAMAGE || proficiencyPerk.type == ELEMENTAL_PIERCE || proficiencyPerk.type == HOMING_MISSILE) {
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
		if (proficiencyPerk.type == HOMING_MISSILE) {
			proficiencyPerk.missileId = perkJson["MissileId"].get<uint16_t>();
			proficiencyPerk.multiplier = perkJson["Multiplier"].get<double_t>();
			proficiencyPerk.probability = perkJson["Probability"].get<double_t>();
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

		proficiencyLevel.perks.push_back(std::move(proficiencyPerk));
		perkIndex++;
	}
}

static void registerLevels(const nlohmann::json &levelsJson, Proficiency &proficiency) {
	uint8_t levelIndex = 0;
	const uint8_t maxLevels = g_configManager().getNumber(WEAPON_PROFICIENCY_MAX_LEVELS);
	for (const auto &levelJson : levelsJson) {
		if (levelIndex >= maxLevels) {
			g_logger().error("{} - Proficiency '{}' exceeded the maximum level, skipping levels above {}", __FUNCTION__, proficiency.id, levelIndex + 1);
			break;
		}

		ProficiencyLevel proficiencyLevel;
		registerPerks(levelJson["Perks"], proficiencyLevel);

		for (auto &perk : proficiencyLevel.perks) {
			perk.level = levelIndex;
		}

		proficiency.level.push_back(std::move(proficiencyLevel));
		levelIndex++;
	}

	proficiency.maxLevel = levelIndex;
}

[[nodiscard]] std::unordered_map<uint16_t, Proficiency> &WeaponProficiency::getProficiencies() {
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
		throw FailedToInitializeCanary(fmt::format("{} - Unable to open file '{}'", __FUNCTION__, folder));
	}

	nlohmann::json proficienciesJson;
	try {
		file >> proficienciesJson;
	} catch (const nlohmann::json::parse_error &e) {
		throw FailedToInitializeCanary(fmt::format("{} - JSON parsing error in file '{}': {}", __FUNCTION__, folder, e.what()));
	}

	try {
		for (const auto &proficiencyJson : proficienciesJson) {
			Proficiency proficiency;
			proficiency.id = proficiencyJson["ProficiencyId"].get<uint16_t>();

			registerLevels(proficiencyJson["Levels"], proficiency);

			proficiencies[proficiency.id] = std::move(proficiency);
		}
	} catch (const nlohmann::json::exception &e) {
		throw FailedToInitializeCanary(fmt::format("{} - JSON exception in file '{}': {}", __FUNCTION__, folder, e.what()));
	}

	g_logger().info("Weapon proficiencies loaded!");

	return true;
}

void WeaponProficiency::load() {
	proficiency.clear();

	auto wp_kv = m_player.kv()->scoped("weapon-proficiency");
	for (const auto &key : wp_kv->keys()) {
		int parsedId = 0;
		const auto* begin = key.data();
		const auto* end = key.data() + key.size();
		const auto [ptr, ec] = std::from_chars(begin, end, parsedId);
		if (ec == std::errc::result_out_of_range) {
			g_logger().error("{} - Out of range key '{}' in weapon-proficiency KV: parse overflow (player: {})", __FUNCTION__, key, m_player.getName());
			continue;
		}
		if (ec == std::errc::invalid_argument || ptr != end) {
			g_logger().error("{} - Invalid key '{}' in weapon-proficiency KV: parse failure (player: {})", __FUNCTION__, key, m_player.getName());
			continue;
		}
		if (parsedId <= 0 || parsedId > std::numeric_limits<uint16_t>::max()) {
			g_logger().warn("{} - Skipping out of range weapon proficiency key '{}' (player: {})", __FUNCTION__, key, m_player.getName());
			continue;
		}

		const auto weaponId = static_cast<uint16_t>(parsedId);
		if (!isValidWeaponId(weaponId) || Item::items[weaponId].proficiencyId == 0) {
			g_logger().warn("{} - Skipping invalid weapon proficiency data for weapon ID '{}' (player: {})", __FUNCTION__, parsedId, m_player.getName());
			continue;
		}

		auto kv_it = wp_kv->get(key);
		if (!kv_it.has_value()) {
			continue;
		}

		proficiency[weaponId] = deserialize(kv_it.value());
		normalizeStoredState(weaponId);
	}
}

void WeaponProficiency::save(uint16_t weaponId) const {
	if (auto it = proficiency.find(weaponId); it != proficiency.end()) {
		m_player.kv()->scoped("weapon-proficiency")->set(std::to_string(weaponId), serialize(it->second));
	}
}

bool WeaponProficiency::saveAll() const {
	auto wp_kv = m_player.kv()->scoped("weapon-proficiency");

	for (const auto &storedKey : wp_kv->keys()) {
		int parsedId = 0;
		const auto* begin = storedKey.data();
		const auto* end = storedKey.data() + storedKey.size();
		const auto [ptr, ec] = std::from_chars(begin, end, parsedId);
		if (ec == std::errc::invalid_argument || ec == std::errc::result_out_of_range || ptr != end || parsedId <= 0 || parsedId > std::numeric_limits<uint16_t>::max()) {
			wp_kv->remove(storedKey);
			continue;
		}

		const auto weaponId = static_cast<uint16_t>(parsedId);
		if (!proficiency.contains(weaponId)) {
			wp_kv->remove(storedKey);
		}
	}

	for (const auto &[weaponId, weaponData] : proficiency) {
		wp_kv->set(std::to_string(weaponId), serialize(weaponData));
	}

	return true;
}

std::vector<uint16_t> WeaponProficiency::getTrackedWeaponIds() const {
	std::vector<uint16_t> weaponIds;
	weaponIds.reserve(proficiency.size());

	for (const auto &[weaponId, _] : proficiency) {
		weaponIds.push_back(weaponId);
	}

	(void)std::ranges::sort(weaponIds);
	return weaponIds;
}

WeaponProficiencyData WeaponProficiency::deserialize(const ValueWrapper &val) {
	auto map = val.get<MapType>();
	if (map.empty()) {
		return {};
	}

	WeaponProficiencyData weaponData;
	if (auto expIt = map.find("experience"); expIt != map.end()) {
		const auto storedExperience = expIt->second->get<IntType>();
		if (storedExperience <= 0) {
			weaponData.experience = 0;
		} else if (storedExperience > std::numeric_limits<uint32_t>::max()) {
			weaponData.experience = std::numeric_limits<uint32_t>::max();
		} else {
			weaponData.experience = static_cast<uint32_t>(storedExperience);
		}
	}
	if (auto masteredIt = map.find("mastered"); masteredIt != map.end()) {
		weaponData.mastered = masteredIt->second->get<BooleanType>();
	}
	if (auto perksIt = map.find("perks"); perksIt != map.end()) {
		weaponData.perks = deserializePerks(perksIt->second->getVariant());
	}
	if (auto shapedPerksIt = map.find("shapedPerks"); shapedPerksIt != map.end()) {
		weaponData.shapedPerks = deserializeShapedPerks(shapedPerksIt->second->getVariant());
	}

	return weaponData;
}

std::vector<ProficiencyPerk> WeaponProficiency::deserializePerks(const ValueWrapper &val) {
	auto array = val.get<ArrayType>();
	if (array.empty()) {
		return {};
	}

	std::vector<ProficiencyPerk> perks;

	for (const auto &item : array) {
		(void)perks.emplace_back(deserializePerk(item));
	}

	return perks;
}

std::vector<ShapedProficiencyPerk> WeaponProficiency::deserializeShapedPerks(const ValueWrapper &val) {
	const auto array = val.get<ArrayType>();
	if (array.empty()) {
		return {};
	}

	std::vector<ShapedProficiencyPerk> shapedPerks;
	shapedPerks.reserve(std::min(array.size(), MAX_SHAPED_PERK_SLOTS));
	for (const auto &item : array) {
		if (shapedPerks.size() >= MAX_SHAPED_PERK_SLOTS) {
			break;
		}

		const auto map = item.get<MapType>();
		if (map.empty()) {
			continue;
		}

		const auto readUnsigned = [&map](const std::string &key, uint32_t maximum) -> std::optional<uint32_t> {
			const auto it = map.find(key);
			if (it == map.end()) {
				return std::nullopt;
			}

			const auto* value = std::get_if<IntType>(&it->second->getVariant());
			if (!value || *value < 0 || static_cast<uint32_t>(*value) > maximum) {
				return std::nullopt;
			}

			return static_cast<uint32_t>(*value);
		};

		const auto level = readUnsigned("level", std::numeric_limits<uint8_t>::max());
		const auto index = readUnsigned("index", std::numeric_limits<uint8_t>::max());
		const auto perkId = readUnsigned("perkId", std::numeric_limits<uint16_t>::max());
		const auto rank = readUnsigned("rank", std::numeric_limits<uint8_t>::max());
		if (!level || !index || !perkId || !rank) {
			continue;
		}

		shapedPerks.emplace_back(
			static_cast<uint8_t>(*level),
			static_cast<uint8_t>(*index),
			static_cast<uint16_t>(*perkId),
			static_cast<uint8_t>(*rank)
		);
	}

	return shapedPerks;
}

ProficiencyPerk WeaponProficiency::deserializePerk(const ValueWrapper &val) {
	auto map = val.get<MapType>();
	if (map.empty()) {
		return {};
	}

	ProficiencyPerk perk;

	auto getInt = [&](const std::string &key) -> int64_t {
		if (auto it = map.find(key); it != map.end()) {
			return it->second->get<IntType>();
		}
		return 0;
	};

	perk.index = static_cast<uint8_t>(getInt("index"));
	perk.type = static_cast<WeaponProficiencyBonus_t>(getInt("type"));
	if (auto it = map.find("value"); it != map.end()) {
		perk.value = it->second->get<DoubleType>();
	}
	perk.level = static_cast<uint8_t>(getInt("level"));
	perk.augmentType = static_cast<uint8_t>(getInt("augmentType"));
	perk.bestiaryId = static_cast<uint16_t>(getInt("bestiaryId"));
	if (auto it = map.find("bestiaryName"); it != map.end()) {
		perk.bestiaryName = it->second->get<StringType>();
	}
	perk.element = static_cast<CombatType_t>(getInt("element"));
	perk.range = static_cast<uint8_t>(getInt("range"));
	perk.skillId = static_cast<skills_t>(getInt("skillId"));
	perk.spellId = static_cast<uint16_t>(getInt("spellId"));
	perk.missileId = static_cast<uint16_t>(getInt("missileId"));
	if (auto it = map.find("multiplier"); it != map.end()) {
		perk.multiplier = it->second->get<DoubleType>();
	}
	if (auto it = map.find("probability"); it != map.end()) {
		perk.probability = it->second->get<DoubleType>();
	}

	return perk;
}

ValueWrapper WeaponProficiency::serialize(const WeaponProficiencyData &weaponData) const {
	return {
		std::pair<const std::string, ValueWrapper> { "experience", ValueWrapper(static_cast<IntType>(weaponData.experience)) },
		std::pair<const std::string, ValueWrapper> { "mastered", ValueWrapper(weaponData.mastered) },
		std::pair<const std::string, ValueWrapper> { "perks", serializePerks(weaponData.perks) },
		std::pair<const std::string, ValueWrapper> { "shapedPerks", serializeShapedPerks(weaponData.shapedPerks) },
	};
}

ValueWrapper WeaponProficiency::serializePerk(const ProficiencyPerk &perk) const {
	return {
		{ "index", static_cast<IntType>(perk.index) },
		{ "type", static_cast<IntType>(perk.type) },
		{ "value", perk.value },
		{ "level", static_cast<IntType>(perk.level) },
		{ "augmentType", static_cast<IntType>(perk.augmentType) },
		{ "bestiaryId", static_cast<IntType>(perk.bestiaryId) },
		{ "bestiaryName", static_cast<StringType>(perk.bestiaryName) },
		{ "element", static_cast<IntType>(perk.element) },
		{ "range", static_cast<IntType>(perk.range) },
		{ "skillId", static_cast<IntType>(perk.skillId) },
		{ "spellId", static_cast<IntType>(perk.spellId) },
		{ "missileId", static_cast<IntType>(perk.missileId) },
		{ "multiplier", perk.multiplier },
		{ "probability", perk.probability },
	};
}

std::vector<ValueWrapper> WeaponProficiency::serializePerks(const std::vector<ProficiencyPerk> &perks) const {
	std::vector<ValueWrapper> arrayWrapper;
	for (const auto &perk : perks) {
		(void)arrayWrapper.emplace_back(serializePerk(perk));
	}

	return arrayWrapper;
}

ValueWrapper WeaponProficiency::serializeShapedPerk(const ShapedProficiencyPerk &perk) const {
	return {
		{ "level", static_cast<IntType>(perk.level) },
		{ "index", static_cast<IntType>(perk.index) },
		{ "perkId", static_cast<IntType>(perk.perkId) },
		{ "rank", static_cast<IntType>(perk.rank) },
	};
}

std::vector<ValueWrapper> WeaponProficiency::serializeShapedPerks(const std::vector<ShapedProficiencyPerk> &perks) const {
	std::vector<ValueWrapper> arrayWrapper;
	arrayWrapper.reserve(std::min(perks.size(), MAX_SHAPED_PERK_SLOTS));
	for (const auto &perk : perks) {
		if (arrayWrapper.size() >= MAX_SHAPED_PERK_SLOTS) {
			break;
		}

		arrayWrapper.emplace_back(serializeShapedPerk(perk));
	}

	return arrayWrapper;
}

void WeaponProficiency::applyPerks(uint16_t weaponId, bool sendSkillUpdate /* = true */) {
	using enum WeaponProficiencyBonus_t;

	const auto &perks = getEffectivePerks(weaponId);
	for (const auto &selectedPerk : perks) {
		switch (selectedPerk.type) {
			case SPELL_AUGMENT: {
				WeaponProficiencySpells::Bonus augmentBonus;
				const auto augmentType = static_cast<WeaponProficiencyAugmentType>(selectedPerk.augmentType);
				const auto augmentValue = getServerAdjustedSpellAugmentValue(selectedPerk, augmentType);
				switch (augmentType) {
					case WeaponProficiencyAugmentType::DAMAGE:
						augmentBonus.increase.damage = augmentValue;
						break;
					case WeaponProficiencyAugmentType::HEAL:
						augmentBonus.increase.heal = augmentValue;
						break;
					case WeaponProficiencyAugmentType::COOLDOWN:
						augmentBonus.decrease.cooldown = static_cast<int32_t>(std::lround(std::abs(augmentValue) * 1000.0));
						break;
					case WeaponProficiencyAugmentType::LIFE_LEECH:
						augmentBonus.leech.life = augmentValue;
						break;
					case WeaponProficiencyAugmentType::MANA_LEECH:
						augmentBonus.leech.mana = augmentValue;
						break;
					case WeaponProficiencyAugmentType::CRITICAL_DAMAGE:
						augmentBonus.increase.criticalDamage = augmentValue;
						break;
					case WeaponProficiencyAugmentType::CRITICAL_CHANCE:
						augmentBonus.increase.criticalChance = augmentValue;
						break;
					default:
						g_logger().error("[{}] - Unknown augment type {}", __FUNCTION__, selectedPerk.augmentType);
						continue;
				}
				addSpellBonus(selectedPerk.spellId, augmentBonus);
				break;
			}
			case SPECIALIZED_MAGIC_LEVEL:
				addSpecializedMagic(selectedPerk.element, selectedPerk.value);
				break;
			case AUTO_ATTACK_CRITICAL_EXTRA_DAMAGE:
			case AUTO_ATTACK_CRITICAL_HIT_CHANCE:
			case ELEMENTAL_HIT_CHANCE:
			case ELEMENTAL_CRITICAL_EXTRA_DAMAGE:
			case RUNE_CRITICAL_HIT_CHANCE:
			case RUNE_CRITICAL_EXTRA_DAMAGE:
			case CRITICAL_HIT_CHANCE:
			case CRITICAL_EXTRA_DAMAGE:
				applyCriticalBonus(selectedPerk);
				break;
			case ELEMENTAL_PIERCE:
				addElementalPierce(selectedPerk.element, selectedPerk.value);
				break;
			case WEAPON_PROFICIENCY_BESTIARY:
				addBestiaryDamage(selectedPerk.bestiaryId, selectedPerk.value);
				break;
			case POWERFUL_FOE_BONUS:
				addPowerfulFoeDamage(selectedPerk.value);
				break;
			case SKILL_BONUS:
				addSkillBonus(selectedPerk.skillId, selectedPerk.value);
				break;
			case LIFE_LEECH:
			case MANA_LEECH:
				addSkillBonus(selectedPerk.type == LIFE_LEECH ? SKILL_LIFE_LEECH_AMOUNT : SKILL_MANA_LEECH_AMOUNT, selectedPerk.value * 10000);
				break;
			case PERFECT_SHOT_DAMAGE:
				setPerfectShotBonus(selectedPerk.range, selectedPerk.value);
				break;
			case SKILL_PERCENTAGE_AUTO_ATTACK:
			case SKILL_PERCENTAGE_SPELL_DAMAGE:
			case SKILL_PERCENTAGE_SPELL_HEALING:
				applySkillPercentageBonus(selectedPerk);
				break;
			case HOMING_MISSILE:
				// Runtime target selection for area spells requires a gameplay capture.
				break;
			default:
				addStat(selectedPerk.type, selectedPerk.value);
				break;
		}
	}

	if (sendSkillUpdate) {
		m_player.sendSkills();
	}
}

void WeaponProficiency::applyCriticalBonus(const ProficiencyPerk &perk) {
	using enum WeaponProficiencyBonus_t;
	WeaponProficiencyCriticalBonus criticalBonus;
	criticalBonus.chance = (perk.type == AUTO_ATTACK_CRITICAL_HIT_CHANCE || perk.type == ELEMENTAL_HIT_CHANCE || perk.type == RUNE_CRITICAL_HIT_CHANCE || perk.type == CRITICAL_HIT_CHANCE) ? perk.value : 0;
	criticalBonus.damage = (perk.type == AUTO_ATTACK_CRITICAL_EXTRA_DAMAGE || perk.type == ELEMENTAL_CRITICAL_EXTRA_DAMAGE || perk.type == RUNE_CRITICAL_EXTRA_DAMAGE || perk.type == CRITICAL_EXTRA_DAMAGE) ? perk.value : 0;

	switch (perk.type) {
		case AUTO_ATTACK_CRITICAL_EXTRA_DAMAGE:
		case AUTO_ATTACK_CRITICAL_HIT_CHANCE:
			addAutoAttackCritical(criticalBonus);
			break;
		case ELEMENTAL_HIT_CHANCE:
		case ELEMENTAL_CRITICAL_EXTRA_DAMAGE:
			addElementCritical(perk.element, criticalBonus);
			break;
		case RUNE_CRITICAL_HIT_CHANCE:
		case RUNE_CRITICAL_EXTRA_DAMAGE:
			addRunesCritical(criticalBonus);
			break;
		case CRITICAL_HIT_CHANCE:
		case CRITICAL_EXTRA_DAMAGE:
			addGeneralCritical(criticalBonus);
			break;
		default:
			break;
	}
}

void WeaponProficiency::applySkillPercentageBonus(const ProficiencyPerk &perk) {
	using enum WeaponProficiencyBonus_t;
	using enum SkillPercentage_t;
	SkillPercentage_t type;
	switch (perk.type) {
		case SKILL_PERCENTAGE_AUTO_ATTACK:
			type = AutoAttack;
			break;
		case SKILL_PERCENTAGE_SPELL_DAMAGE:
			type = SpellDamage;
			break;
		case SKILL_PERCENTAGE_SPELL_HEALING:
			type = SpellHealing;
			break;
		default:
			return;
	}
	addSkillPercentage(perk.skillId, type, perk.value);
}

std::vector<ProficiencyPerk> WeaponProficiency::getSelectedPerks(uint16_t weaponId) const {
	return collectValidSelectedPerks(weaponId);
}

std::vector<ShapedProficiencyPerk> WeaponProficiency::getShapedPerks(uint16_t weaponId) const {
	return collectValidShapedPerks(weaponId);
}

std::vector<ProficiencyPerk> WeaponProficiency::getEffectivePerks(uint16_t weaponId) const {
	auto selectedPerks = collectValidSelectedPerks(weaponId);
	const auto shapedPerks = collectValidShapedPerks(weaponId);
	const auto highestCombatSkill = getHighestCombatSkill();
	for (auto &selectedPerk : selectedPerks) {
		const auto shapedIt = std::ranges::find_if(shapedPerks, [&selectedPerk](const auto &shapedPerk) {
			return shapedPerk.level == selectedPerk.level && shapedPerk.index == selectedPerk.index;
		});
		if (shapedIt == shapedPerks.end()) {
			continue;
		}

		auto shapedDefinition = getShapedPerkDefinition(shapedIt->perkId, shapedIt->rank, highestCombatSkill);
		if (!shapedDefinition) {
			continue;
		}

		shapedDefinition->level = selectedPerk.level;
		shapedDefinition->index = selectedPerk.index;
		selectedPerk = std::move(*shapedDefinition);
	}

	return selectedPerks;
}

skills_t WeaponProficiency::getHighestCombatSkill() const {
	constexpr std::array<skills_t, 6> combatSkills = {
		SKILL_FIST,
		SKILL_CLUB,
		SKILL_SWORD,
		SKILL_AXE,
		SKILL_DISTANCE,
		SKILL_MAGLEVEL,
	};

	return *std::ranges::max_element(combatSkills, [this](skills_t lhs, skills_t rhs) {
		return m_player.getSkillLevel(lhs) < m_player.getSkillLevel(rhs);
	});
}

bool WeaponProficiency::isSelectedPerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId) const {
	const auto selectedPerks = collectValidSelectedPerks(weaponId);
	return std::ranges::any_of(selectedPerks, [level, perkIndex](const auto &perk) {
		return perk.level == level && perk.index == perkIndex;
	});
}

void WeaponProficiency::refreshEquippedWeapon(uint16_t weaponId) {
	if (m_player.getWeaponId(true) != weaponId) {
		return;
	}

	clearAllStats();
	applyPerks(weaponId);
}

void WeaponProficiency::clearSelectedPerks(uint16_t weaponId) {
	if (weaponId == 0) {
		return;
	}

	if (auto it = proficiency.find(weaponId); it != proficiency.end()) {
		it->second.perks.clear();
	}
}

WeaponProficiencyShapingResult WeaponProficiency::shapePerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId /* = 0 */) {
	using enum WeaponProficiencyShapingResult;

	if (m_player.getZoneType() != ZONE_PROTECTION) {
		return NotInProtectionZone;
	}

	if (weaponId == 0) {
		weaponId = m_player.getWeaponId(true);
	}

	const auto playerProficiencyIt = proficiency.find(weaponId);
	if (!isValidWeaponId(weaponId) || playerProficiencyIt == proficiency.end()) {
		return InvalidTarget;
	}

	playerProficiencyIt->second.shapedPerks = collectValidShapedPerks(weaponId);
	if (!isSelectedPerk(level, perkIndex, weaponId)) {
		return InvalidTarget;
	}

	if (std::ranges::any_of(playerProficiencyIt->second.shapedPerks, [level, perkIndex](const auto &perk) {
		return perk.level == level && perk.index == perkIndex;
	})) {
		return AlreadyShaped;
	}

	const auto shapedPerkCount = playerProficiencyIt->second.shapedPerks.size();
	if (shapedPerkCount >= MAX_SHAPED_PERK_SLOTS) {
		return MaximumSlotsReached;
	}
	if (shapedPerkCount == 0 && getUnlockedLevelCount(weaponId) < 3) {
		return RequirementNotMet;
	}
	if (shapedPerkCount == 1 && !playerProficiencyIt->second.mastered) {
		return RequirementNotMet;
	}

	const auto dustCost = getShapingSlotCost(shapedPerkCount);
	if (dustCost == 0 || m_player.getForgeDusts() < dustCost) {
		return NotEnoughDust;
	}

	const auto perkPool = getShapingPerkPool(m_player.getPlayerVocationEnum());
	if (perkPool.empty()) {
		return InvalidTarget;
	}

	const auto perkId = perkPool[uniform_random(0, static_cast<int32_t>(perkPool.size() - 1))];
	m_player.removeForgeDusts(dustCost);
	playerProficiencyIt->second.shapedPerks.emplace_back(level, perkIndex, perkId, 0);
	save(weaponId);
	refreshEquippedWeapon(weaponId);
	return Success;
}

WeaponProficiencyShapingResult WeaponProficiency::refineShapedPerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId /* = 0 */) {
	using enum WeaponProficiencyShapingResult;

	if (m_player.getZoneType() != ZONE_PROTECTION) {
		return NotInProtectionZone;
	}
	if (weaponId == 0) {
		weaponId = m_player.getWeaponId(true);
	}

	auto playerProficiencyIt = proficiency.find(weaponId);
	if (!isValidWeaponId(weaponId) || playerProficiencyIt == proficiency.end()) {
		return InvalidTarget;
	}
	playerProficiencyIt->second.shapedPerks = collectValidShapedPerks(weaponId);
	auto shapedIt = std::ranges::find_if(playerProficiencyIt->second.shapedPerks, [level, perkIndex](const auto &perk) {
		return perk.level == level && perk.index == perkIndex;
	});
	if (shapedIt == playerProficiencyIt->second.shapedPerks.end()) {
		return NotShaped;
	}

	const auto dustCost = getShapingRefineCost(shapedIt->rank);
	if (dustCost == 0) {
		return MaximumRankReached;
	}
	if (m_player.getForgeDusts() < dustCost) {
		return NotEnoughDust;
	}

	m_player.removeForgeDusts(dustCost);
	++shapedIt->rank;
	save(weaponId);
	refreshEquippedWeapon(weaponId);
	return Success;
}

WeaponProficiencyShapingResult WeaponProficiency::maximizeShapedPerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId /* = 0 */) {
	using enum WeaponProficiencyShapingResult;

	if (m_player.getZoneType() != ZONE_PROTECTION) {
		return NotInProtectionZone;
	}
	if (weaponId == 0) {
		weaponId = m_player.getWeaponId(true);
	}

	auto playerProficiencyIt = proficiency.find(weaponId);
	if (!isValidWeaponId(weaponId) || playerProficiencyIt == proficiency.end()) {
		return InvalidTarget;
	}
	playerProficiencyIt->second.shapedPerks = collectValidShapedPerks(weaponId);
	auto shapedIt = std::ranges::find_if(playerProficiencyIt->second.shapedPerks, [level, perkIndex](const auto &perk) {
		return perk.level == level && perk.index == perkIndex;
	});
	if (shapedIt == playerProficiencyIt->second.shapedPerks.end()) {
		return NotShaped;
	}
	if (shapedIt->rank >= MAX_SHAPED_PERK_RANK) {
		return MaximumRankReached;
	}
	if (!m_player.removeItemCountById(LUNAR_ASCENSION_ORB_ID, 1, true)) {
		return MissingLunarAscensionOrb;
	}

	shapedIt->rank = MAX_SHAPED_PERK_RANK;
	save(weaponId);
	refreshEquippedWeapon(weaponId);
	return Success;
}

WeaponProficiencyShapingResult WeaponProficiency::reshapeShapedPerk(uint8_t level, uint8_t perkIndex, std::vector<ShapedProficiencyPerk> &offers, uint16_t weaponId /* = 0 */) {
	using enum WeaponProficiencyShapingResult;

	offers.clear();
	if (m_player.getZoneType() != ZONE_PROTECTION) {
		return NotInProtectionZone;
	}
	if (weaponId == 0) {
		weaponId = m_player.getWeaponId(true);
	}

	auto playerProficiencyIt = proficiency.find(weaponId);
	if (!isValidWeaponId(weaponId) || playerProficiencyIt == proficiency.end()) {
		return InvalidTarget;
	}
	playerProficiencyIt->second.shapedPerks = collectValidShapedPerks(weaponId);
	const auto shapedIt = std::ranges::find_if(playerProficiencyIt->second.shapedPerks, [level, perkIndex](const auto &perk) {
		return perk.level == level && perk.index == perkIndex;
	});
	if (shapedIt == playerProficiencyIt->second.shapedPerks.end()) {
		return NotShaped;
	}
	if (m_player.getForgeDusts() < RESHAPE_DUST_COST) {
		return NotEnoughDust;
	}

	auto perkPool = getShapingPerkPool(m_player.getPlayerVocationEnum());
	std::erase(perkPool, shapedIt->perkId);
	if (perkPool.size() < RESHAPE_OFFER_COUNT) {
		return InvalidTarget;
	}

	offers.reserve(RESHAPE_OFFER_COUNT);
	for (uint8_t i = 0; i < RESHAPE_OFFER_COUNT; ++i) {
		const auto randomIndex = static_cast<size_t>(uniform_random(0, static_cast<int32_t>(perkPool.size() - 1)));
		offers.emplace_back(level, perkIndex, perkPool[randomIndex], rollReshapeInitialRank());
		perkPool.erase(perkPool.begin() + static_cast<std::ptrdiff_t>(randomIndex));
	}

	m_player.removeForgeDusts(RESHAPE_DUST_COST);
	return Success;
}

WeaponProficiencyShapingResult WeaponProficiency::selectReshapeOption(uint8_t level, uint8_t perkIndex, const std::optional<ShapedProficiencyPerk> &offer, uint16_t weaponId /* = 0 */) {
	using enum WeaponProficiencyShapingResult;

	if (m_player.getZoneType() != ZONE_PROTECTION) {
		return NotInProtectionZone;
	}
	if (weaponId == 0) {
		weaponId = m_player.getWeaponId(true);
	}

	auto playerProficiencyIt = proficiency.find(weaponId);
	if (!isValidWeaponId(weaponId) || playerProficiencyIt == proficiency.end()) {
		return InvalidTarget;
	}
	playerProficiencyIt->second.shapedPerks = collectValidShapedPerks(weaponId);
	auto shapedIt = std::ranges::find_if(playerProficiencyIt->second.shapedPerks, [level, perkIndex](const auto &perk) {
		return perk.level == level && perk.index == perkIndex;
	});
	if (shapedIt == playerProficiencyIt->second.shapedPerks.end()) {
		return NotShaped;
	}
	if (!offer) {
		return Success;
	}

	const auto perkPool = getShapingPerkPool(m_player.getPlayerVocationEnum());
	if (offer->level != level || offer->index != perkIndex || offer->rank > MAX_SHAPED_PERK_RANK
	    || std::ranges::find(perkPool, offer->perkId) == perkPool.end()) {
		return InvalidReshapeOption;
	}

	shapedIt->perkId = offer->perkId;
	shapedIt->rank = offer->rank;
	save(weaponId);
	refreshEquippedWeapon(weaponId);
	return Success;
}

WeaponProficiencyShapingResult WeaponProficiency::clearShapedPerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId /* = 0 */) {
	using enum WeaponProficiencyShapingResult;

	if (m_player.getZoneType() != ZONE_PROTECTION) {
		return NotInProtectionZone;
	}
	if (weaponId == 0) {
		weaponId = m_player.getWeaponId(true);
	}

	const auto playerProficiencyIt = proficiency.find(weaponId);
	if (!isValidWeaponId(weaponId) || playerProficiencyIt == proficiency.end()) {
		return InvalidTarget;
	}

	playerProficiencyIt->second.shapedPerks = collectValidShapedPerks(weaponId);
	const auto removedCount = std::erase_if(playerProficiencyIt->second.shapedPerks, [level, perkIndex](const auto &perk) {
		return perk.level == level && perk.index == perkIndex;
	});
	if (removedCount == 0) {
		return NotShaped;
	}

	save(weaponId);
	refreshEquippedWeapon(weaponId);
	return Success;
}

void WeaponProficiency::setSelectedPerk(uint8_t level, uint8_t perkIndex, uint16_t weaponId /* = 0 */) {
	if (weaponId == 0) {
		weaponId = m_player.getWeaponId(true);
	}

	if (weaponId == 0) {
		g_logger().error("{} - Invalid weapon ID: {}", __FUNCTION__, weaponId);
		return;
	}

	if (!isValidWeaponId(weaponId)) {
		g_logger().error("{} - Weapon ID out of range: {}", __FUNCTION__, weaponId);
		return;
	}

	auto playerProficiencyIt = proficiency.find(weaponId);
	if (playerProficiencyIt == proficiency.end()) {
		g_logger().error("{} - No stored proficiency data for weapon ID: {}", __FUNCTION__, weaponId);
		return;
	}

	auto proficiencyId = Item::items[weaponId].proficiencyId;
	if (!proficiencies.contains(proficiencyId)) {
		g_logger().error("{} - Proficiency not found for weapon ID: {}", __FUNCTION__, weaponId);
		return;
	}

	const auto unlockedLevelCount = getUnlockedLevelCount(weaponId);
	if (level >= unlockedLevelCount) {
		g_logger().warn("{} - Attempt to select locked proficiency level {} for weapon ID: {}", __FUNCTION__, level, weaponId);
		return;
	}

	const auto &info = proficiencies.at(proficiencyId);
	if (level >= info.level.size()) {
		g_logger().error("{} - Proficiency level exceeds maximum size for weapon ID: {}", __FUNCTION__, weaponId);
		return;
	}
	const auto &selectedLevel = info.level.at(level);

	if (perkIndex >= selectedLevel.perks.size()) {
		g_logger().error("{} - Proficiency level {} exceeds maximum perks size for weapon ID: {}", __FUNCTION__, level, weaponId);
		return;
	}
	const auto &selectedPerk = selectedLevel.perks.at(perkIndex);

	const auto hasLevelSelected = std::ranges::any_of(playerProficiencyIt->second.perks, [level](const auto &perk) {
		return perk.level == level;
	});
	if (hasLevelSelected) {
		g_logger().warn("{} - Duplicate proficiency level {} selection ignored for weapon ID: {}", __FUNCTION__, level, weaponId);
		return;
	}

	playerProficiencyIt->second.perks.push_back(selectedPerk);
}

std::unordered_map<std::pair<uint16_t, uint8_t>, double, PairHash, PairEqual> WeaponProficiency::getActiveAugments(uint16_t weaponId) {
	std::unordered_map<std::pair<uint16_t, uint8_t>, double, PairHash, PairEqual> augments;

	weaponId = weaponId == 0 ? m_player.getWeaponId(true) : weaponId;

	if (weaponId == 0) {
		return augments;
	}

	const auto &perks = getEffectivePerks(weaponId);

	for (const auto &perk : perks) {
		if (perk.spellId && perk.augmentType) {
			const auto key = std::make_pair(perk.spellId, perk.augmentType);
			const auto augmentType = static_cast<WeaponProficiencyAugmentType>(perk.augmentType);
			augments[key] += getServerAdjustedSpellAugmentValue(perk, augmentType);
		}
	}

	return augments;
}

const std::vector<uint32_t> &WeaponProficiency::getExperienceArray(uint16_t weaponId) const {
	if (!isValidWeaponId(weaponId)) {
		g_logger().error("{} - Invalid weapon ID: {}", __FUNCTION__, weaponId);
		return standardExperience;
	}

	const auto &itemType = Item::items[weaponId];
	if (itemType.ammoType == AMMO_BOLT) {
		return crossbowExperience;
	}

	if (usesKnightProficiencyTable(itemType)) {
		return knightExperience;
	}

	return standardExperience;
}

uint32_t WeaponProficiency::nextLevelExperience(uint16_t weaponId) {
	if (!isValidWeaponId(weaponId)) {
		g_logger().error("{} - Invalid weapon ID: {}", __FUNCTION__, weaponId);
		return 0;
	}

	const auto &experienceArray = getExperienceArray(weaponId);
	if (experienceArray.empty()) {
		return 0;
	}

	auto prof_it = proficiencies.find(Item::items[weaponId].proficiencyId);
	if (prof_it == proficiencies.end()) {
		g_logger().error("{} - Proficiency not found for weapon ID: {}", __FUNCTION__, weaponId);
		return 0;
	}

	const auto &proficiencyInfo = prof_it->second;
	if (!proficiency.contains(weaponId)) {
		return experienceArray[0];
	}

	const auto &playerProficiency = proficiency.at(weaponId);
	const auto maxExpLevels = getMasteryExperienceTierCount(proficiencyInfo, experienceArray);
	for (size_t i = 0; i < maxExpLevels; ++i) {
		if (playerProficiency.experience >= experienceArray[i]) {
			continue;
		}

		return experienceArray[i] - playerProficiency.experience;
	}

	return 0;
}

uint32_t WeaponProficiency::getMaxExperience(uint16_t weaponId) const {
	if (!isValidWeaponId(weaponId)) {
		g_logger().error("{} - Invalid weapon ID: {}", __FUNCTION__, weaponId);
		return 0;
	}

	const auto &experienceArray = getExperienceArray(weaponId);
	auto prof_it = proficiencies.find(Item::items[weaponId].proficiencyId);
	if (prof_it == proficiencies.end()) {
		g_logger().error("{} - Proficiency not found for weapon ID: {}", __FUNCTION__, weaponId);
		return 0;
	}

	const auto &proficiencyInfo = prof_it->second;
	const auto masteryTierCount = getMasteryExperienceTierCount(proficiencyInfo, experienceArray);
	if (masteryTierCount > 0) {
		return experienceArray[masteryTierCount - 1];
	}
	return 0;
}

bool WeaponProficiency::addExperience(uint32_t experience, uint16_t weaponId /* = 0 */, bool applyMultiplier /* = true */) {
	weaponId = weaponId > 0 ? weaponId : m_player.getWeaponId(true);

	if (weaponId == 0) {
		return false;
	}

	if (applyMultiplier) {
		experience = scaleWeaponProficiencyExperienceGain(experience);
	}
	if (experience == 0) {
		return false;
	}

	// Validate that the item has a valid proficiency
	if (!isValidWeaponId(weaponId) || Item::items[weaponId].proficiencyId == 0) {
		g_logger().debug("{} - Weapon ID '{}' has no proficiency assigned", __FUNCTION__, weaponId);
		return false;
	}

	if (nextLevelExperience(weaponId) <= 0) {
		return false;
	}

	const uint32_t maxExperience = getMaxExperience(weaponId);
	if (maxExperience == 0) {
		return false;
	}

	if (!proficiency.contains(weaponId)) {
		const auto gainedExperience = std::min(experience, maxExperience);
		const auto [it, inserted] = proficiency.try_emplace(weaponId, gainedExperience);
		if (!inserted) {
			g_logger().warn("{} - Failed to create proficiency state for weapon ID '{}'", __FUNCTION__, weaponId);
			return false;
		}
		it->second.mastered = gainedExperience >= maxExperience;
		m_player.sendWeaponProficiency(weaponId);

		return true;
	}

	auto &weaponData = proficiency.at(weaponId);
	const uint64_t newExperience = std::min<uint64_t>(static_cast<uint64_t>(weaponData.experience) + experience, maxExperience);
	if (newExperience <= weaponData.experience) {
		return false;
	}

	weaponData.experience = static_cast<uint32_t>(newExperience);
	weaponData.mastered = weaponData.experience >= maxExperience;
	m_player.sendWeaponProficiency(weaponId);
	return true;
}

uint32_t WeaponProficiency::getBosstiaryExperience(BosstiaryRarity_t rarity) const {
	using enum BosstiaryRarity_t;
	switch (rarity) {
		case RARITY_BANE:
			return 500;
		case RARITY_ARCHFOE:
			return 5000;
		case RARITY_NEMESIS:
			return 15000;
		default:
			return 0;
	}
}

uint32_t WeaponProficiency::getBestiaryExperience(uint8_t monsterStar) const {
	if (monsterStar > 5) { // Assuming 5 is max star
		monsterStar = 5;
	}
	double poly = -1.133 * std::pow(monsterStar, 5) + 14.083 * std::pow(monsterStar, 4) + -59.666 * std::pow(monsterStar, 3) + 102.916 * std::pow(monsterStar, 2) + -27.2 * monsterStar + 1.0;
	return static_cast<uint32_t>(std::max(0.0, poly));
}

uint32_t WeaponProficiency::getExperience(uint16_t weaponId /* = 0 */) const {
	weaponId = weaponId > 0 ? weaponId : m_player.getWeaponId(true);
	if (weaponId == 0) {
		return 0;
	}

	if (!proficiency.contains(weaponId)) {
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

	if (!isValidWeaponId(weaponId)) {
		g_logger().error("{} - Weapon ID out of range: {}", __FUNCTION__, weaponId);
		return false;
	}

	const auto &experienceArray = getExperienceArray(weaponId);

	auto proficiencyId = Item::items[weaponId].proficiencyId;

	if (!proficiency.contains(weaponId)) {
		return false;
	}

	if (!proficiencies.contains(proficiencyId)) {
		return false;
	}

	const auto &proficiencyInfo = proficiencies.at(proficiencyId);

	const auto &selectedPerks = getSelectedPerks(weaponId);
	const auto &playerProficiency = proficiency.at(weaponId);

	size_t limit = std::min(experienceArray.size(), static_cast<size_t>(proficiencyInfo.maxLevel));
	for (size_t i = 0; i < limit; ++i) {
		if (playerProficiency.experience < experienceArray[i]) {
			break;
		}

		if (selectedPerks.size() < i + 1) {
			return true;
		}
	}

	return false;
}

size_t WeaponProficiency::getUnlockedLevelCount(uint16_t weaponId) const {
	if (!isValidWeaponId(weaponId)) {
		return 0;
	}

	const auto playerProficiencyIt = proficiency.find(weaponId);
	if (playerProficiencyIt == proficiency.end()) {
		return 0;
	}

	const auto profIt = proficiencies.find(Item::items[weaponId].proficiencyId);
	if (profIt == proficiencies.end()) {
		return 0;
	}

	const auto &experienceArray = getExperienceArray(weaponId);
	const auto &proficiencyInfo = profIt->second;
	if (proficiencyInfo.maxLevel == 0) {
		return 0;
	}

	const size_t limit = std::min(experienceArray.size(), static_cast<size_t>(proficiencyInfo.maxLevel));
	size_t unlockedLevels = 0;
	for (size_t i = 0; i < limit; ++i) {
		if (playerProficiencyIt->second.experience < experienceArray[i]) {
			break;
		}

		++unlockedLevels;
	}

	return unlockedLevels;
}

std::vector<ProficiencyPerk> WeaponProficiency::collectValidSelectedPerks(uint16_t weaponId) const {
	if (!isValidWeaponId(weaponId)) {
		return {};
	}

	const auto playerProficiencyIt = proficiency.find(weaponId);
	if (playerProficiencyIt == proficiency.end()) {
		return {};
	}

	const auto profIt = proficiencies.find(Item::items[weaponId].proficiencyId);
	if (profIt == proficiencies.end()) {
		return {};
	}

	const auto unlockedLevelCount = getUnlockedLevelCount(weaponId);
	if (unlockedLevelCount == 0) {
		return {};
	}

	const auto &storedPerks = playerProficiencyIt->second.perks;
	const auto &proficiencyInfo = profIt->second;
	std::vector<ProficiencyPerk> validPerks;
	validPerks.reserve(std::min(storedPerks.size(), unlockedLevelCount));
	std::vector<bool> usedLevels(proficiencyInfo.level.size(), false);

	for (const auto &storedPerk : storedPerks) {
		const auto level = static_cast<size_t>(storedPerk.level);
		const auto index = static_cast<size_t>(storedPerk.index);

		if (level >= unlockedLevelCount || level >= proficiencyInfo.level.size() || usedLevels[level]) {
			continue;
		}

		const auto &levelPerks = proficiencyInfo.level[level].perks;
		if (index >= levelPerks.size()) {
			continue;
		}

		validPerks.push_back(levelPerks[index]);
		usedLevels[level] = true;
	}

	(void)std::ranges::sort(validPerks, [](const auto &lhs, const auto &rhs) {
		if (lhs.level != rhs.level) {
			return lhs.level < rhs.level;
		}

		return lhs.index < rhs.index;
	});

	return validPerks;
}

std::vector<ShapedProficiencyPerk> WeaponProficiency::collectValidShapedPerks(uint16_t weaponId) const {
	if (!isValidWeaponId(weaponId)) {
		return {};
	}

	const auto playerProficiencyIt = proficiency.find(weaponId);
	if (playerProficiencyIt == proficiency.end()) {
		return {};
	}

	const auto profIt = proficiencies.find(Item::items[weaponId].proficiencyId);
	if (profIt == proficiencies.end()) {
		return {};
	}

	const auto &storedPerks = playerProficiencyIt->second.shapedPerks;
	const auto &proficiencyInfo = profIt->second;
	const auto perkPool = getShapingPerkPool(m_player.getPlayerVocationEnum());
	if (perkPool.empty()) {
		return {};
	}
	std::vector<ShapedProficiencyPerk> validPerks;
	validPerks.reserve(std::min(storedPerks.size(), MAX_SHAPED_PERK_SLOTS));
	for (const auto &storedPerk : storedPerks) {
		if (validPerks.size() >= MAX_SHAPED_PERK_SLOTS) {
			break;
		}

		const auto level = static_cast<size_t>(storedPerk.level);
		const auto index = static_cast<size_t>(storedPerk.index);
		if (level >= proficiencyInfo.level.size() || index >= proficiencyInfo.level[level].perks.size()
		    || storedPerk.rank > MAX_SHAPED_PERK_RANK
		    || std::ranges::find(perkPool, storedPerk.perkId) == perkPool.end()) {
			continue;
		}

		const bool duplicateSlot = std::ranges::any_of(validPerks, [&storedPerk](const auto &perk) {
			return perk.level == storedPerk.level && perk.index == storedPerk.index;
		});
		if (duplicateSlot) {
			continue;
		}

		validPerks.push_back(storedPerk);
	}

	(void)std::ranges::sort(validPerks, [](const auto &lhs, const auto &rhs) {
		if (lhs.level != rhs.level) {
			return lhs.level < rhs.level;
		}

		return lhs.index < rhs.index;
	});

	return validPerks;
}

void WeaponProficiency::normalizeStoredState(uint16_t weaponId) {
	if (!isValidWeaponId(weaponId)) {
		return;
	}

	const auto playerProficiencyIt = proficiency.find(weaponId);
	if (playerProficiencyIt == proficiency.end()) {
		return;
	}

	const auto maxExperience = getMaxExperience(weaponId);
	if (maxExperience > 0 && playerProficiencyIt->second.experience > maxExperience) {
		playerProficiencyIt->second.experience = maxExperience;
	}

	if (maxExperience > 0) {
		playerProficiencyIt->second.mastered = playerProficiencyIt->second.experience >= maxExperience;
	}

	playerProficiencyIt->second.perks = collectValidSelectedPerks(weaponId);
	playerProficiencyIt->second.shapedPerks = collectValidShapedPerks(weaponId);
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
	using enum SkillPercentage_t;
	auto &skillPercentage = m_skillPercentages[skill];
	skillPercentage.skill = skill;

	switch (type) {
		case AutoAttack:
			skillPercentage.autoAttack += value;
			break;
		case SpellDamage:
			skillPercentage.spellDamage += value;
			break;
		case SpellHealing:
			skillPercentage.spellHealing += value;
			break;
		default:
			break;
	}
}

const SkillPercentage &WeaponProficiency::getSkillPercentage(skills_t skill) const {
	static const SkillPercentage defaultSkillPercentage;
	if (auto it = m_skillPercentages.find(skill); it != m_skillPercentages.end()) {
		return it->second;
	}
	return defaultSkillPercentage;
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
	const auto enumValue = static_cast<int32_t>(type);
	if (!isTrackedWeaponProficiencySkill(type)) {
		g_logger().error("[{}]. Skill type {} is out of range.", __FUNCTION__, enumValue);
		return 0;
	}

	return m_skills[static_cast<size_t>(enumValue)];
}

void WeaponProficiency::addSkillBonus(skills_t type, uint32_t value) {
	const auto enumValue = static_cast<int32_t>(type);
	if (!isTrackedWeaponProficiencySkill(type)) {
		g_logger().error("[{}]. Type {} is out of range, value {}.", __FUNCTION__, enumValue, value);
		return;
	}

	m_skills[static_cast<size_t>(enumValue)] += value;
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

void WeaponProficiency::addRunesCritical(const WeaponProficiencyCriticalBonus &bonus) {
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

WeaponProficiencyCriticalBonus WeaponProficiency::getElementCritical(CombatType_t type) const {
	if (type == COMBAT_NONE) {
		return {};
	}
	const auto enumValue = static_cast<uint8_t>(type);
	if (enumValue < m_elementCritical.size()) {
		return m_elementCritical[enumValue];
	}
	g_logger().error("[{}]. Element type {} is out of range.", __FUNCTION__, enumValue);
	return {};
}

void WeaponProficiency::addElementCritical(CombatType_t type, const WeaponProficiencyCriticalBonus &bonus) {
	if (type == COMBAT_NONE) {
		return;
	}

	const auto enumValue = static_cast<uint8_t>(type);
	if (enumValue >= m_elementCritical.size()) {
		g_logger().error("[{}]. Type {} is out of range.", __FUNCTION__, enumValue);
		return;
	}

	m_elementCritical[enumValue].chance += bonus.chance;
	m_elementCritical[enumValue].damage += bonus.damage;
}

double_t WeaponProficiency::getElementalPierce(CombatType_t type) const {
	if (type == COMBAT_NONE) {
		return 0;
	}

	const auto enumValue = static_cast<uint8_t>(type);
	if (enumValue < m_elementalPierce.size()) {
		return m_elementalPierce[enumValue];
	}
	g_logger().error("[{}]. Element type {} is out of range.", __FUNCTION__, enumValue);
	return 0;
}

void WeaponProficiency::addElementalPierce(CombatType_t type, double_t value) {
	if (type == COMBAT_NONE) {
		return;
	}

	const auto enumValue = static_cast<uint8_t>(type);
	if (enumValue >= m_elementalPierce.size()) {
		g_logger().error("[{}]. Element type {} is out of range.", __FUNCTION__, enumValue);
		return;
	}

	m_elementalPierce[enumValue] += value;
}

uint32_t WeaponProficiency::getSpellBonus(uint16_t spellId, WeaponProficiencySpellBoost_t boost) const {
	using enum WeaponProficiencySpellBoost_t;

	auto it = m_spellsBonuses.find(spellId);
	if (it == m_spellsBonuses.end()) {
		return 0;
	}

	const auto &[leech, increase, decrease] = it->second;
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
	if (auto it = m_spellsBonuses.find(spellId); it != m_spellsBonuses.end()) {
		it->second.decrease.cooldown += bonus.decrease.cooldown;
		it->second.decrease.manaCost += bonus.decrease.manaCost;
		it->second.decrease.secondaryGroupCooldown += bonus.decrease.secondaryGroupCooldown;
		it->second.increase.additionalTarget += bonus.increase.additionalTarget;
		it->second.increase.area = it->second.increase.area || bonus.increase.area;
		it->second.increase.criticalChance += bonus.increase.criticalChance;
		it->second.increase.criticalDamage += bonus.increase.criticalDamage;
		it->second.increase.damage += bonus.increase.damage;
		it->second.increase.damageReduction += bonus.increase.damageReduction;
		it->second.increase.duration += bonus.increase.duration;
		it->second.increase.heal += bonus.increase.heal;
		it->second.leech.life += bonus.leech.life;
		it->second.leech.mana += bonus.leech.mana;
		return;
	}
	m_spellsBonuses[spellId] = bonus;
}

void WeaponProficiency::setPerfectShotBonus(uint8_t range, double_t damage) {
	m_perfectShot.range = range;
	m_perfectShot.damage += damage;
}

const WeaponProficiencyPerfectShotBonus &WeaponProficiency::getPerfectShotBonus() const {
	return m_perfectShot;
}

void WeaponProficiency::resetPerfectShotBonus() {
	m_perfectShot = {};
}

double_t WeaponProficiency::getBestiaryDamage(uint8_t race) const {
	if (auto it = m_bestiaryDamage.find(race); it != m_bestiaryDamage.end()) {
		return it->second;
	}

	return 0;
}

void WeaponProficiency::addBestiaryDamage(uint8_t race, double_t bonus) {
	if (auto it = m_bestiaryDamage.find(race); it != m_bestiaryDamage.end()) {
		it->second += bonus;
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

	const auto weaponId = weapon->getID();
	if (!isValidWeaponId(weaponId)) {
		g_logger().error("{} - Invalid weapon ID: {}", __FUNCTION__, weaponId);
		return 0;
	}

	switch (Item::items[weaponId].type) {
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
	if (damage.primary.type == COMBAT_NONE || damage.primary.type >= COMBAT_COUNT) {
		return;
	}

	const auto elementCritical = getElementCritical(damage.primary.type);
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

void WeaponProficiency::applyPowerfulFoeDamage(CombatDamage &damage, const std::shared_ptr<Monster> &monster) const {
	using enum WeaponProficiencyBonus_t;
	if (!monster) {
		return;
	}

	const auto forgeStack = monster->getForgeStack();
	const auto mt = monster->getMonsterType();
	if (forgeStack > 0 || (mt && mt->isBoss())) {
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

	for (const auto &[skill, skillPercentage] : m_skillPercentages) {
		if (skillPercentage.autoAttack <= 0) {
			continue;
		}

		const auto bonusDamage = m_player.getSkillLevel(skill) * skillPercentage.autoAttack;

		if (damage.primary.type != COMBAT_NONE) {
			damage.primary.value -= std::ceil(bonusDamage);
		}
		if (damage.secondary.type != COMBAT_NONE) {
			damage.secondary.value -= std::ceil(bonusDamage);
		}
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
	if (!healing && damage.primary.type == COMBAT_HEALING) {
		return;
	}

	const auto &weapon = m_player.getWeapon(true);
	if (!weapon) {
		return;
	}

	for (const auto &[skill, skillPercentage] : m_skillPercentages) {
		const auto skillPercentageValue = healing ? skillPercentage.spellHealing : skillPercentage.spellDamage;
		if (skillPercentageValue <= 0) {
			continue;
		}

		const auto bonusDamage = std::ceil(m_player.getSkillLevel(skill) * skillPercentageValue);

		if (damage.primary.type != COMBAT_NONE) {
			damage.primary.value += (damage.primary.value < 0 ? -bonusDamage : bonusDamage);
		}
		if (damage.secondary.type != COMBAT_NONE) {
			damage.secondary.value += (damage.secondary.value < 0 ? -bonusDamage : bonusDamage);
		}
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
	if (auto it = m_spellsBonuses.find(spellId); it != m_spellsBonuses.end()) {
		damage.damageMultiplier += static_cast<int32_t>(std::lround(it->second.increase.damage * 100));
		damage.healingMultiplier += static_cast<int32_t>(std::lround(it->second.increase.heal * 100));
		damage.criticalChance += it->second.increase.criticalChance * 10000;
		damage.criticalDamage += it->second.increase.criticalDamage * 10000;
		damage.lifeLeech += it->second.leech.life * 10000;
		damage.manaLeech += it->second.leech.mana * 10000;
	}
}

std::vector<std::pair<std::string, double>> WeaponProficiency::getActiveBestiariesDamage() const {
	using enum WeaponProficiencyBonus_t;
	std::unordered_map<std::string, double, TransparentStringHasher, std::equal_to<>> aggregatedBestiaries;

	const auto weaponId = m_player.getWeaponId(true);

	const auto &perks = getEffectivePerks(weaponId);
	for (const auto &perk : perks) {
		if (perk.type == WEAPON_PROFICIENCY_BESTIARY && !perk.bestiaryName.empty()) {
			aggregatedBestiaries[perk.bestiaryName] += perk.value;
		}
	}

	std::vector<std::pair<std::string, double>> bestiariesDamage;
	bestiariesDamage.reserve(aggregatedBestiaries.size());
	for (const auto &[name, value] : aggregatedBestiaries) {
		(void)bestiariesDamage.emplace_back(name, value);
	}

	(void)std::ranges::sort(bestiariesDamage, [](const auto &lhs, const auto &rhs) {
		return lhs.first < rhs.first;
	});

	return bestiariesDamage;
}

std::optional<std::pair<uint8_t, double>> WeaponProficiency::getActiveElementalCriticalType(WeaponProficiencyBonus_t criticalType) const {
	using enum WeaponProficiencyBonus_t;

	if (criticalType != ELEMENTAL_HIT_CHANCE && criticalType != ELEMENTAL_CRITICAL_EXTRA_DAMAGE) {
		return std::nullopt;
	}

	const auto weaponId = m_player.getWeaponId(true);

	const auto &perks = getEffectivePerks(weaponId);
	std::unordered_map<uint8_t, double> aggregatedByElement;
	std::vector<uint8_t> displayOrder;
	for (const auto &perk : perks) {
		if (perk.type != criticalType || perk.element == COMBAT_NONE) {
			continue;
		}

		const auto elementId = getCipbiaElement(perk.element);
		if (!aggregatedByElement.contains(elementId)) {
			displayOrder.push_back(elementId);
		}
		aggregatedByElement[elementId] += perk.value;
	}

	if (!displayOrder.empty()) {
		auto bestElementId = displayOrder.front();
		auto bestValue = aggregatedByElement[bestElementId];
		for (const auto elementId : displayOrder) {
			const auto value = aggregatedByElement[elementId];
			if (value > bestValue) {
				bestElementId = elementId;
				bestValue = value;
			}
		}
		return std::make_pair(bestElementId, bestValue);
	}

	return std::nullopt;
}

std::vector<std::pair<CombatType_t, double_t>> WeaponProficiency::getActiveElementalPierces() const {
	std::vector<std::pair<CombatType_t, double_t>> elementalPierces;
	for (uint8_t index = 0; index < m_elementalPierce.size(); ++index) {
		const auto value = m_elementalPierce[index];
		if (value > 0) {
			elementalPierces.emplace_back(static_cast<CombatType_t>(index), value);
		}
	}

	return elementalPierces;
}

void WeaponProficiency::clearAllStats() {
	resetStats();
	resetSpecializedMagic();
	resetSkillBonuses();
	resetPowerfulFoeDamage();
	resetBestiaryDamage();

	m_skillPercentages.clear();
	m_autoAttackCritical.clear();
	m_runesCritical.clear();
	m_generalCritical.clear();
	m_elementCritical.fill({});
	m_elementalPierce.fill(0);
	m_spellsBonuses.clear();
	resetPerfectShotBonus();
}
