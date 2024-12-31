/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#include "io/io_wheel.hpp"

#include "enums/player_wheel.hpp"
#include "kv/kv.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "creatures/players/player.hpp"
#include "creatures/combat/spells.hpp"
#include "utils/tools.hpp"

#define MITIGATION_INCREASE 0.03
#define MANA_LEECH_INCREASE 0.25
#define HEALTH_LEECH_INCREASE 0.75

/**
 * @brief This namespace groups together variables, functions, and class definitions within a specific scope.
 * @brief Utilizing namespaces in C++ is a strategic approach to mitigate the need for file inclusions in header files (.hpp).
 * @details This practice helps to prevent a variety of issues and reduces compilation complexity. Moreover, it aids in keeping the executable size minimal.
 * @details Using this namespace helps prevent naming conflicts between different sections of the code.
 * @details It enhances code organization and readability, and provides a clear context for the elements defined within it.
 */
namespace InternalPlayerWheel {
	// Spells vector
	std::vector<std::string> m_focusSpells {
		"Eternal Winter",
		"Hell's Core",
		"Rage of the Skies",
		"Wrath of Nature"
	};

	/**
	 * @brief Registers spell data in the Wheel of Destiny for a given spell name and grade type.
	 *
	 * This function registers the specified spell's data in the Wheel of Destiny, applying various boosts and upgrades
	 * based on the provided spell data and grade type. It supports instant spells and a special "Any_Focus_Mage_Spell"
	 * case which registers multiple focus spells.
	 *
	 * @tparam T The type of spell data.
	 * @param spellData The spell data to register.
	 * @param name The name of the spell to register.
	 * @param gradeType The grade type of the spell.
	 */
	template <typename T>
	void registerWheelSpellTable(const T &spellData, const std::string &name, WheelSpellGrade_t gradeType) {
		if (name == "Any_Focus_Mage_Spell") {
			for (const std::string &focusSpellName : m_focusSpells) {
				g_logger().trace("[{}] registered any spell: {}", __FUNCTION__, focusSpellName);
				registerWheelSpellTable(spellData, focusSpellName, gradeType);
			}
			return;
		}

		const auto &spell = g_spells().getInstantSpellByName(name);
		if (spell) {
			g_logger().trace("[{}] registering instant spell with name {}", __FUNCTION__, spell->getName());
			// Increase data
			const auto increaseData = spellData.increase;
			if (increaseData.damage > 0) {
				spell->setWheelOfDestinyBoost(WheelSpellBoost_t::DAMAGE, gradeType, increaseData.damage);
			}
			if (increaseData.heal > 0) {
				spell->setWheelOfDestinyBoost(WheelSpellBoost_t::HEAL, gradeType, increaseData.heal);
			}
			if (increaseData.criticalDamage > 0) {
				spell->setWheelOfDestinyBoost(WheelSpellBoost_t::CRITICAL_DAMAGE, gradeType, increaseData.criticalDamage);
			}
			if (increaseData.criticalChance > 0) {
				spell->setWheelOfDestinyBoost(WheelSpellBoost_t::CRITICAL_CHANCE, gradeType, increaseData.criticalChance);
			}

			// Decrease data
			const auto decreaseData = spellData.decrease;
			if (decreaseData.cooldown > 0) {
				spell->setWheelOfDestinyBoost(WheelSpellBoost_t::COOLDOWN, gradeType, decreaseData.cooldown * 1000);
			}
			if (decreaseData.manaCost > 0) {
				spell->setWheelOfDestinyBoost(WheelSpellBoost_t::MANA, gradeType, decreaseData.manaCost);
			}
			if (decreaseData.secondaryGroupCooldown > 0) {
				spell->setWheelOfDestinyBoost(WheelSpellBoost_t::SECONDARY_GROUP_COOLDOWN, gradeType, decreaseData.secondaryGroupCooldown * 1000);
			}
			// Leech data
			const auto leechData = spellData.leech;
			if (leechData.mana > 0) {
				spell->setWheelOfDestinyBoost(WheelSpellBoost_t::MANA_LEECH, gradeType, leechData.mana * 100);
			}
			if (leechData.life > 0) {
				spell->setWheelOfDestinyBoost(WheelSpellBoost_t::LIFE_LEECH, gradeType, leechData.life * 100);
			}
			spell->setWheelOfDestinyUpgraded(true);
		} else {
			g_logger().warn("[{}] Spell with name {} could not be found and was ignored", __FUNCTION__, name);
		}
	}

	/**
	 * @brief Helper function to bind member functions with placeholders.
	 *
	 * This function takes an object and a member function and returns a callable object
	 * that binds the member function to the object, allowing placeholders for additional arguments.
	 *
	 * @tparam Object Type of the object to bind.
	 * @tparam Function Type of the member function to bind.
	 * @param object The object to bind the member function to.
	 * @param function The member function to bind.
	 * @return A callable object that represents the bound member function.
	 */
	template <typename Object, typename Function>
	auto bindMapFunction(Object object, Function function) {
		return std::bind(function, object, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4);
	}

} // End namespace

bool IOWheel::initializeGlobalData(bool reload /* = false*/) {
	// Initialize map data from each vocation for wheel
	initializeMapData();

	// Register spells for druid
	for (const auto &data : getWheelBonusData().spells.druid) {
		for (size_t i = 1; i < 3; ++i) {
			const auto &grade = data.grade[i];
			InternalPlayerWheel::registerWheelSpellTable(grade, data.name, static_cast<WheelSpellGrade_t>(i));
		}
	}

	// Register spells for knight
	for (const auto &data : getWheelBonusData().spells.knight) {
		for (size_t i = 1; i < 3; ++i) {
			const auto &grade = data.grade[i];
			InternalPlayerWheel::registerWheelSpellTable(grade, data.name, static_cast<WheelSpellGrade_t>(i));
		}
	}

	// Register spells for paladin
	for (const auto &data : getWheelBonusData().spells.paladin) {
		for (size_t i = 1; i < 3; ++i) {
			const auto &grade = data.grade[i];
			InternalPlayerWheel::registerWheelSpellTable(grade, data.name, static_cast<WheelSpellGrade_t>(i));
		}
	}

	// Register spells for sorcerer
	for (const auto &data : getWheelBonusData().spells.sorcerer) {
		for (size_t i = 1; i < 3; ++i) {
			const auto &grade = data.grade[i];
			InternalPlayerWheel::registerWheelSpellTable(grade, data.name, static_cast<WheelSpellGrade_t>(i));
		}
	}

	// Register enum with default values for each vocation
	if (!reload) {
		g_logger().debug("Loading wheel of destiny... [Success]");
	} else {
		g_logger().debug("Reloading wheel of destiny... [Success]");
	}
	return true;
}

const IOWheelBonusData::DataArray &IOWheel::getWheelBonusData() const {
	return m_wheelBonusData;
}

const std::vector<std::string> &IOWheel::getFocusSpells() const {
	return InternalPlayerWheel::m_focusSpells;
}

using VocationBonusFunction = std::function<void(const std::shared_ptr<Player> &, uint16_t, uint8_t, PlayerWheelMethodsBonusData &)>;
using VocationBonusMap = std::map<WheelSlots_t, VocationBonusFunction>;
const VocationBonusMap &IOWheel::getWheelMapFunctions() const {
	return m_vocationBonusMap;
}

std::pair<int, int> IOWheel::getRevelationStatByStage(WheelStageEnum_t stageType) const {
	// Let's remove one, because the std::array starts with 0 and the stages with 1
	const auto &array = m_wheelBonusData.revelation.stats[static_cast<uint8_t>(stageType) - 1];
	return std::make_pair(array.damage, array.healing);
}

int8_t IOWheel::getSlotPrioritaryOrder(WheelSlots_t slot) const {
	if (slot == WheelSlots_t::SLOT_BLUE_50 || slot == WheelSlots_t::SLOT_RED_50 || slot == WheelSlots_t::SLOT_PURPLE_50 || slot == WheelSlots_t::SLOT_GREEN_50) {
		return 0;
	}

	if (slot == WheelSlots_t::SLOT_GREEN_TOP_75 || slot == WheelSlots_t::SLOT_GREEN_BOTTOM_75 || slot == WheelSlots_t::SLOT_RED_TOP_75 || slot == WheelSlots_t::SLOT_RED_BOTTOM_75 || slot == WheelSlots_t::SLOT_PURPLE_TOP_75 || slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_75 || slot == WheelSlots_t::SLOT_BLUE_TOP_75 || slot == WheelSlots_t::SLOT_BLUE_BOTTOM_75) {
		return 1;
	}

	if (slot == WheelSlots_t::SLOT_GREEN_BOTTOM_100 || slot == WheelSlots_t::SLOT_GREEN_MIDDLE_100 || slot == WheelSlots_t::SLOT_GREEN_TOP_100 || slot == WheelSlots_t::SLOT_RED_BOTTOM_100 || slot == WheelSlots_t::SLOT_RED_MIDDLE_100 || slot == WheelSlots_t::SLOT_RED_TOP_100 || slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_100 || slot == WheelSlots_t::SLOT_PURPLE_MIDDLE_100 || slot == WheelSlots_t::SLOT_PURPLE_TOP_100 || slot == WheelSlots_t::SLOT_BLUE_BOTTOM_100 || slot == WheelSlots_t::SLOT_BLUE_MIDDLE_100 || slot == WheelSlots_t::SLOT_BLUE_TOP_100) {
		return 2;
	}

	if (slot == WheelSlots_t::SLOT_GREEN_TOP_150 || slot == WheelSlots_t::SLOT_GREEN_BOTTOM_150 || slot == WheelSlots_t::SLOT_RED_TOP_150 || slot == WheelSlots_t::SLOT_RED_BOTTOM_150 || slot == WheelSlots_t::SLOT_PURPLE_TOP_150 || slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_150 || slot == WheelSlots_t::SLOT_BLUE_TOP_150 || slot == WheelSlots_t::SLOT_BLUE_BOTTOM_150) {
		return 3;
	}

	if (slot == WheelSlots_t::SLOT_GREEN_200 || slot == WheelSlots_t::SLOT_RED_200 || slot == WheelSlots_t::SLOT_PURPLE_200 || slot == WheelSlots_t::SLOT_BLUE_200) {
		return 4;
	}

	g_logger().error("[{}] unknown whell slot type': {}", __FUNCTION__, std::to_string(slot));
	return -1;
}

void IOWheel::initializeMapData() {
	initializeWheelMapFunctions();

	initializeDruidSpells();
	initializeKnightSpells();
	initializePaladinSpells();
	initializeSorcererSpells();
}

void IOWheel::initializeDruidSpells() {
	m_wheelBonusData.spells.druid[0].name = "Strong Ice Wave";
	m_wheelBonusData.spells.druid[0].grade[1].leech.mana = 3;
	m_wheelBonusData.spells.druid[0].grade[2].increase.damage = 10;

	m_wheelBonusData.spells.druid[1].name = "Mass Healing";
	m_wheelBonusData.spells.druid[1].grade[1].increase.heal = 4;
	m_wheelBonusData.spells.druid[1].grade[2].increase.area = true;

	m_wheelBonusData.spells.druid[2].name = "Nature's Embrace";
	m_wheelBonusData.spells.druid[2].grade[1].increase.heal = 11;
	m_wheelBonusData.spells.druid[2].grade[2].decrease.cooldown = 10;

	m_wheelBonusData.spells.druid[3].name = "Terra Wave";
	m_wheelBonusData.spells.druid[3].grade[1].increase.damage = static_cast<int>(std::round(6.5));
	m_wheelBonusData.spells.druid[3].grade[2].leech.life = 5;

	m_wheelBonusData.spells.druid[4].name = "Heal Friend";
	m_wheelBonusData.spells.druid[4].grade[1].decrease.manaCost = 10;
	m_wheelBonusData.spells.druid[4].grade[2].increase.heal = static_cast<int>(std::round(5.5));
}

void IOWheel::initializeKnightSpells() {
	m_wheelBonusData.spells.knight[0].name = "Front Sweep";
	m_wheelBonusData.spells.knight[0].grade[1].leech.life = 5;
	m_wheelBonusData.spells.knight[0].grade[2].increase.damage = 14;

	m_wheelBonusData.spells.knight[1].name = "Groundshaker";
	m_wheelBonusData.spells.knight[1].grade[1].increase.damage = static_cast<int>(std::round(12.5));
	m_wheelBonusData.spells.knight[1].grade[2].decrease.cooldown = 2;

	m_wheelBonusData.spells.knight[2].name = "Chivalrous Challenge";
	m_wheelBonusData.spells.knight[2].grade[1].decrease.manaCost = 20;
	m_wheelBonusData.spells.knight[2].grade[2].increase.aditionalTarget = 1;

	m_wheelBonusData.spells.knight[3].name = "Intense Wound Cleansing";
	m_wheelBonusData.spells.knight[3].grade[1].increase.heal = 125;
	m_wheelBonusData.spells.knight[3].grade[2].decrease.cooldown = 300;

	m_wheelBonusData.spells.knight[4].name = "Fierce Berserk";
	m_wheelBonusData.spells.knight[4].grade[1].decrease.manaCost = 30;
	m_wheelBonusData.spells.knight[4].grade[2].increase.damage = 10;
}

void IOWheel::initializePaladinSpells() {
	m_wheelBonusData.spells.paladin[0].name = "Sharpshooter";
	m_wheelBonusData.spells.paladin[0].grade[1].decrease.secondaryGroupCooldown = 8;
	m_wheelBonusData.spells.paladin[0].grade[2].decrease.cooldown = 6;

	m_wheelBonusData.spells.paladin[1].name = "Strong Ethereal Spear";
	m_wheelBonusData.spells.paladin[1].grade[1].decrease.cooldown = 2;
	m_wheelBonusData.spells.paladin[1].grade[2].increase.damage = 380;

	m_wheelBonusData.spells.paladin[2].name = "Divine Dazzle";
	m_wheelBonusData.spells.paladin[2].grade[1].increase.aditionalTarget = 1;
	m_wheelBonusData.spells.paladin[2].grade[2].increase.duration = 4;
	m_wheelBonusData.spells.paladin[2].grade[2].decrease.cooldown = 4;

	m_wheelBonusData.spells.paladin[3].name = "Swift Foot";
	m_wheelBonusData.spells.paladin[3].grade[1].decrease.secondaryGroupCooldown = 8;
	m_wheelBonusData.spells.paladin[3].grade[2].decrease.cooldown = 6;

	m_wheelBonusData.spells.paladin[4].name = "Divine Caldera";
	m_wheelBonusData.spells.paladin[4].grade[1].decrease.manaCost = 20;
	m_wheelBonusData.spells.paladin[4].grade[2].increase.damage = static_cast<int>(std::round(8.5));
}

void IOWheel::initializeSorcererSpells() {
	m_wheelBonusData.spells.sorcerer[0].name = "Magic Shield";
	m_wheelBonusData.spells.sorcerer[0].grade[2].decrease.cooldown = 6;

	m_wheelBonusData.spells.sorcerer[1].name = "Sap Strength";
	m_wheelBonusData.spells.sorcerer[1].grade[1].increase.area = true;
	m_wheelBonusData.spells.sorcerer[1].grade[2].increase.damageReduction = 1;

	m_wheelBonusData.spells.sorcerer[2].name = "Energy Wave";
	m_wheelBonusData.spells.sorcerer[2].grade[1].increase.damage = 5;
	m_wheelBonusData.spells.sorcerer[2].grade[2].increase.area = true;

	m_wheelBonusData.spells.sorcerer[3].name = "Great Fire Wave";
	m_wheelBonusData.spells.sorcerer[3].grade[1].increase.criticalDamage = 15;
	m_wheelBonusData.spells.sorcerer[3].grade[1].increase.criticalChance = 10;
	m_wheelBonusData.spells.sorcerer[3].grade[2].increase.damage = 5;

	m_wheelBonusData.spells.sorcerer[4].name = "Any_Focus_Mage_Spell";
	m_wheelBonusData.spells.sorcerer[4].grade[1].increase.damage = 5;
	m_wheelBonusData.spells.sorcerer[4].grade[2].decrease.cooldown = 4;
	m_wheelBonusData.spells.sorcerer[4].grade[2].decrease.secondaryGroupCooldown = 4;
}

bool IOWheel::isMaxPointAddedToSlot(const std::shared_ptr<Player> &player, uint16_t points, WheelSlots_t slotType) const {
	return points == player->wheel()->getPointsBySlotType(slotType) && points == player->wheel()->getMaxPointsPerSlot(slotType);
}

bool IOWheel::isKnight(uint8_t vocationId) const {
	return vocationId == Vocation_t::VOCATION_KNIGHT_CIP;
}

bool IOWheel::isPaladin(uint8_t vocationId) const {
	return vocationId == Vocation_t::VOCATION_PALADIN_CIP;
}

bool IOWheel::isSorcerer(uint8_t vocationId) const {
	return vocationId == Vocation_t::VOCATION_SORCERER_CIP;
}

bool IOWheel::isDruid(uint8_t vocationId) const {
	return vocationId == Vocation_t::VOCATION_DRUID_CIP;
}

void IOWheel::addSpell(const std::shared_ptr<Player> &player, PlayerWheelMethodsBonusData &bonusData, WheelSlots_t slotType, uint16_t points, const std::string &spellName) const {
	if (isMaxPointAddedToSlot(player, points, slotType)) {
		bonusData.spells.push_back(spellName);
	}
}

void IOWheel::addVesselResonance(const std::shared_ptr<Player> &player, PlayerWheelMethodsBonusData &bonusData, WheelSlots_t slotType, WheelGemAffinity_t affinity, uint16_t points) const {
	if (isMaxPointAddedToSlot(player, points, slotType)) {
		bonusData.unlockedVesselResonances[static_cast<uint8_t>(affinity)]++;
	}
}

void IOWheel::initializeWheelMapFunctions() {
	VocationBonusMap vocationBonusMap;
	vocationBonusMap = {
		{}, // Index 0 is empty, the wheel enum init at index 1 (WheelSlots_t::SLOT_GREEN_200)
		{ WheelSlots_t::SLOT_GREEN_200, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotGreen200) },
		{ WheelSlots_t::SLOT_GREEN_TOP_150, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotGreenTop150) },
		{ WheelSlots_t::SLOT_GREEN_TOP_100, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotGreenTop100) },
		{ WheelSlots_t::SLOT_RED_TOP_100, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotRedTop100) },
		{ WheelSlots_t::SLOT_RED_TOP_150, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotRedTop150) },
		{ WheelSlots_t::SLOT_RED_200, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotRed200) },
		{ WheelSlots_t::SLOT_GREEN_BOTTOM_150, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotGreenBottom150) },
		{ WheelSlots_t::SLOT_GREEN_MIDDLE_100, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotGreenMiddle100) },
		{ WheelSlots_t::SLOT_GREEN_TOP_75, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotGreenTop75) },
		{ WheelSlots_t::SLOT_RED_TOP_75, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotRedTop75) },
		{ WheelSlots_t::SLOT_RED_MIDDLE_100, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotRedMiddle100) },
		{ WheelSlots_t::SLOT_RED_BOTTOM_150, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotRedBottom150) },
		{ WheelSlots_t::SLOT_GREEN_BOTTOM_100, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotGreenBottom100) },
		{ WheelSlots_t::SLOT_GREEN_BOTTOM_75, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotGreenBottom75) },
		{ WheelSlots_t::SLOT_GREEN_50, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotGreen50) },
		{ WheelSlots_t::SLOT_RED_50, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotRed50) },
		{ WheelSlots_t::SLOT_RED_BOTTOM_75, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotRedBottom75) },
		{ WheelSlots_t::SLOT_RED_BOTTOM_100, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotRedBottom100) },
		{ WheelSlots_t::SLOT_BLUE_TOP_100, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotBlueTop100) },
		{ WheelSlots_t::SLOT_BLUE_TOP_75, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotBlueTop75) },
		{ WheelSlots_t::SLOT_BLUE_50, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotBlue50) },
		{ WheelSlots_t::SLOT_PURPLE_50, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotPurple50) },
		{ WheelSlots_t::SLOT_PURPLE_TOP_75, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotPurpleTop75) },
		{ WheelSlots_t::SLOT_PURPLE_TOP_100, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotPurpleTop100) },
		{ WheelSlots_t::SLOT_BLUE_TOP_150, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotBlueTop150) },
		{ WheelSlots_t::SLOT_BLUE_MIDDLE_100, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotBlueMiddle100) },
		{ WheelSlots_t::SLOT_BLUE_BOTTOM_75, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotBlueBottom75) },
		{ WheelSlots_t::SLOT_PURPLE_BOTTOM_75, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotPurpleBottom75) },
		{ WheelSlots_t::SLOT_PURPLE_MIDDLE_100, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotPurpleMiddle100) },
		{ WheelSlots_t::SLOT_PURPLE_TOP_150, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotPurpleTop150) },
		{ WheelSlots_t::SLOT_BLUE_200, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotBlue200) },
		{ WheelSlots_t::SLOT_BLUE_BOTTOM_150, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotBlueBottom150) },
		{ WheelSlots_t::SLOT_BLUE_BOTTOM_100, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotBlueBottom100) },
		{ WheelSlots_t::SLOT_PURPLE_BOTTOM_100, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotPurpleBottom100) },
		{ WheelSlots_t::SLOT_PURPLE_BOTTOM_150, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotPurpleBottom150) },
		{ WheelSlots_t::SLOT_PURPLE_200, InternalPlayerWheel::bindMapFunction(this, &IOWheel::slotPurple200) }
	};

	m_vocationBonusMap = vocationBonusMap;
}

// SLOT_GREEN_200 = 1
void IOWheel::slotGreen200(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	auto pointsInSlot = isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_GREEN_200);
	if (isKnight(vocationCipId)) {
		bonusData.stats.health += 3 * points;
		bonusData.stats.mana += 1 * points;
		if (pointsInSlot) {
			bonusData.instant.battleInstinct = true;
		}
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.health += 2 * points;
		bonusData.stats.mana += 3 * points;
		if (pointsInSlot) {
			bonusData.instant.positionalTactics = true;
		}
	} else {
		bonusData.stats.health += 1 * points;
		bonusData.stats.mana += 6 * points;
		if (pointsInSlot && isSorcerer(vocationCipId)) {
			bonusData.instant.runicMastery = true;
		} else if (pointsInSlot && isDruid(vocationCipId)) {
			bonusData.instant.healingLink = true;
		}
	}
}

// SLOT_GREEN_TOP_150 = 2
void IOWheel::slotGreenTop150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t, PlayerWheelMethodsBonusData &bonusData) const {
	bonusData.mitigation += MITIGATION_INCREASE * points;
	if (isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_GREEN_TOP_150)) {
		bonusData.leech.manaLeech += MANA_LEECH_INCREASE;
	}
}

// SLOT_GREEN_TOP_100 = 3
void IOWheel::slotGreenTop100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.health += 3 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.health += 2 * points;
	} else {
		bonusData.stats.health += 1 * points;
	}
	addVesselResonance(player, bonusData, WheelSlots_t::SLOT_GREEN_TOP_100, WheelGemAffinity_t::Green, points);
}

// SLOT_RED_TOP_100 = 4
void IOWheel::slotRedTop100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	auto pointsInSlot = isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_RED_TOP_100);
	if (isKnight(vocationCipId)) {
		bonusData.stats.mana += 1 * points;
		if (pointsInSlot) {
			bonusData.skills.melee += 1;
		}
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.mana += 3 * points;
		if (pointsInSlot) {
			bonusData.skills.distance += 1;
		}
	} else {
		bonusData.stats.mana += 6 * points;
		if (pointsInSlot) {
			bonusData.skills.magic += 1;
		}
	}
}

// SLOT_RED_TOP_150 = 5
void IOWheel::slotRedTop150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.health += 3 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.health += 2 * points;
	} else {
		bonusData.stats.health += 1 * points;
	}
	addVesselResonance(player, bonusData, WheelSlots_t::SLOT_RED_TOP_150, WheelGemAffinity_t::Red, points);
}

// SLOT_RED_200 = 6
void IOWheel::slotRed200(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_RED_200, points, "Front Sweep");
		bonusData.stats.health += 3 * points;
		bonusData.stats.mana += 1 * points;
	} else if (isPaladin(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_RED_200, points, "Sharpshooter");
		bonusData.stats.health += 2 * points;
		bonusData.stats.mana += 3 * points;
	} else {
		if (isSorcerer(vocationCipId)) {
			for (const std::string &focusSpellName : getFocusSpells()) {
				addSpell(player, bonusData, WheelSlots_t::SLOT_RED_200, points, focusSpellName);
			}
		} else {
			addSpell(player, bonusData, WheelSlots_t::SLOT_RED_200, points, "Strong Ice Wave");
		}
		bonusData.stats.health += 1 * points;
		bonusData.stats.mana += 6 * points;
	}
}

// SLOT_GREEN_BOTTOM_150 = 7
void IOWheel::slotGreenBottom150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t, PlayerWheelMethodsBonusData &bonusData) const {
	bonusData.mitigation += MITIGATION_INCREASE * points;
	addVesselResonance(player, bonusData, WheelSlots_t::SLOT_GREEN_BOTTOM_150, WheelGemAffinity_t::Green, points);
}

// SLOT_GREEN_MIDDLE_100 = 8
void IOWheel::slotGreenMiddle100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_GREEN_MIDDLE_100, points, "Groundshaker");
		bonusData.stats.health += 3 * points;
	} else if (isPaladin(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_GREEN_MIDDLE_100, points, "Strong Ethereal Spear");
		bonusData.stats.health += 2 * points;
	} else {
		if (isSorcerer(vocationCipId)) {
			addSpell(player, bonusData, WheelSlots_t::SLOT_GREEN_MIDDLE_100, points, "Magic Shield");
		} else {
			addSpell(player, bonusData, WheelSlots_t::SLOT_GREEN_MIDDLE_100, points, "Mass Healing");
		}
		bonusData.stats.health += 1 * points;
	}
}

// SLOT_GREEN_TOP_75 = 9
void IOWheel::slotGreenTop75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.mana += 1 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.mana += 3 * points;
	} else {
		bonusData.stats.mana += 6 * points;
	}
	if (isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_GREEN_TOP_75)) {
		bonusData.leech.lifeLeech += HEALTH_LEECH_INCREASE;
	}
}

// SLOT_RED_TOP_75 = 10
void IOWheel::slotRedTop75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.capacity += 5 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.capacity += 4 * points;
	} else {
		bonusData.stats.capacity += 2 * points;
	}
	addVesselResonance(player, bonusData, WheelSlots_t::SLOT_RED_TOP_75, WheelGemAffinity_t::Red, points);
}

// SLOT_RED_MIDDLE_100 = 11
void IOWheel::slotRedMiddle100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_RED_MIDDLE_100, points, "Chivalrous Challenge");
		bonusData.stats.mana += 1 * points;
	} else if (isPaladin(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_RED_MIDDLE_100, points, "Divine Dazzle");
		bonusData.stats.mana += 3 * points;
	} else {
		if (isSorcerer(vocationCipId)) {
			addSpell(player, bonusData, WheelSlots_t::SLOT_RED_MIDDLE_100, points, "Sap Strength");
		} else {
			addSpell(player, bonusData, WheelSlots_t::SLOT_RED_MIDDLE_100, points, "Nature's Embrace");
		}
		bonusData.stats.mana += 6 * points;
	}
}

// SLOT_RED_BOTTOM_150 = 12
void IOWheel::slotRedBottom150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.health += 3 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.health += 2 * points;
	} else {
		bonusData.stats.health += 1 * points;
	}
	if (isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_RED_BOTTOM_150)) {
		bonusData.leech.manaLeech += MANA_LEECH_INCREASE;
	}
}

// SLOT_GREEN_BOTTOM_100 = 13
void IOWheel::slotGreenBottom100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_GREEN_BOTTOM_100, points, "Intense Wound Cleansing");
		bonusData.stats.health += 3 * points;
	} else if (isPaladin(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_GREEN_BOTTOM_100, points, "Swift Foot");
		bonusData.stats.health += 2 * points;
	} else {
		if (isSorcerer(vocationCipId)) {
			addSpell(player, bonusData, WheelSlots_t::SLOT_GREEN_BOTTOM_100, points, "Energy Wave");
		} else {
			addSpell(player, bonusData, WheelSlots_t::SLOT_GREEN_BOTTOM_100, points, "Terra Wave");
		}
		bonusData.stats.health += 1 * points;
	}
}

// SLOT_GREEN_BOTTOM_75 = 14
void IOWheel::slotGreenBottom75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	auto pointsInSlot = isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_GREEN_BOTTOM_75);
	if (isKnight(vocationCipId)) {
		bonusData.stats.mana += 1 * points;
		if (pointsInSlot) {
			bonusData.skills.melee += 1;
		}
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.mana += 3 * points;
		if (pointsInSlot) {
			bonusData.skills.distance += 1;
		}
	} else {
		bonusData.stats.mana += 6 * points;
		if (pointsInSlot) {
			bonusData.skills.magic += 1;
		}
	}
}

// SLOT_GREEN_50 = 15
void IOWheel::slotGreen50(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.capacity += 5 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.capacity += 4 * points;
	} else {
		bonusData.stats.capacity += 2 * points;
	}
	addVesselResonance(player, bonusData, WheelSlots_t::SLOT_GREEN_50, WheelGemAffinity_t::Green, points);
}

// SLOT_RED_50 = 16
void IOWheel::slotRed50(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	bonusData.mitigation += MITIGATION_INCREASE * points;
	if (isKnight(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_RED_50, points, "Fierce Berserk");
	} else if (isPaladin(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_RED_50, points, "Divine Caldera");
	} else if (isSorcerer(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_RED_50, points, "Great Fire Wave");
	} else {
		addSpell(player, bonusData, WheelSlots_t::SLOT_RED_50, points, "Heal Friend");
	}
}

// SLOT_RED_BOTTOM_75 = 17
void IOWheel::slotRedBottom75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.capacity += 5 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.capacity += 4 * points;
	} else {
		bonusData.stats.capacity += 2 * points;
	}
	if (isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_RED_BOTTOM_75)) {
		bonusData.leech.lifeLeech += HEALTH_LEECH_INCREASE;
	}
}

// SLOT_RED_BOTTOM_100 = 18
void IOWheel::slotRedBottom100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.mana += 1 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.mana += 3 * points;
	} else {
		bonusData.stats.mana += 6 * points;
	}
	addVesselResonance(player, bonusData, WheelSlots_t::SLOT_RED_BOTTOM_100, WheelGemAffinity_t::Red, points);
}

// SLOT_BLUE_TOP_100 = 19
void IOWheel::slotBlueTop100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t, PlayerWheelMethodsBonusData &bonusData) const {
	bonusData.mitigation += MITIGATION_INCREASE * points;
	addVesselResonance(player, bonusData, WheelSlots_t::SLOT_BLUE_TOP_100, WheelGemAffinity_t::Blue, points);
}

// SLOT_BLUE_TOP_75 = 20
void IOWheel::slotBlueTop75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.health += 3 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.health += 2 * points;
	} else {
		bonusData.stats.health += 1 * points;
	}
	if (isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_BLUE_TOP_75)) {
		bonusData.leech.manaLeech += MANA_LEECH_INCREASE;
	}
}

// SLOT_BLUE_50 = 21
void IOWheel::slotBlue50(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_BLUE_50, points, "Front Sweep");
		bonusData.stats.mana += 1 * points;
	} else if (isPaladin(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_BLUE_50, points, "Sharpshooter");
		bonusData.stats.mana += 3 * points;
	} else {
		if (isSorcerer(vocationCipId)) {
			for (const std::string &focusSpellName : getFocusSpells()) {
				addSpell(player, bonusData, WheelSlots_t::SLOT_BLUE_50, points, focusSpellName);
			}
		} else {
			addSpell(player, bonusData, WheelSlots_t::SLOT_BLUE_50, points, "Strong Ice Wave");
		}
		bonusData.stats.mana += 6 * points;
	}
}

// SLOT_PURPLE_50 = 22
void IOWheel::slotPurple50(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.health += 3 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.health += 2 * points;
	} else {
		bonusData.stats.health += 1 * points;
	}
	addVesselResonance(player, bonusData, WheelSlots_t::SLOT_PURPLE_50, WheelGemAffinity_t::Purple, points);
}

// SLOT_PURPLE_TOP_75 = 23
void IOWheel::slotPurpleTop75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	bonusData.mitigation += MITIGATION_INCREASE * points;
	auto pointsInSlot = isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_PURPLE_TOP_75);
	if (isKnight(vocationCipId)) {
		if (pointsInSlot) {
			bonusData.skills.melee += 1;
		}
	} else if (isPaladin(vocationCipId)) {
		if (pointsInSlot) {
			bonusData.skills.distance += 1;
		}
	} else {
		if (pointsInSlot) {
			bonusData.skills.magic += 1;
		}
	}
}

// SLOT_PURPLE_TOP_100 = 24
void IOWheel::slotPurpleTop100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_PURPLE_TOP_100, points, "Groundshaker");
		bonusData.stats.capacity += 5 * points;
	} else if (isPaladin(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_PURPLE_TOP_100, points, "Strong Ethereal Spear");
		bonusData.stats.capacity += 4 * points;
	} else {
		if (isSorcerer(vocationCipId)) {
			addSpell(player, bonusData, WheelSlots_t::SLOT_PURPLE_TOP_100, points, "Magic Shield");
		} else {
			addSpell(player, bonusData, WheelSlots_t::SLOT_PURPLE_TOP_100, points, "Mass Healing");
		}
		bonusData.stats.capacity += 2 * points;
	}
}

// SLOT_BLUE_TOP_150 = 25
void IOWheel::slotBlueTop150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.capacity += 5 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.capacity += 4 * points;
	} else {
		bonusData.stats.capacity += 2 * points;
	}
	if (isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_BLUE_TOP_150)) {
		bonusData.leech.lifeLeech += HEALTH_LEECH_INCREASE;
	}
}

// SLOT_BLUE_MIDDLE_100 = 26
void IOWheel::slotBlueMiddle100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	bonusData.mitigation += MITIGATION_INCREASE * points;
	if (isKnight(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_BLUE_MIDDLE_100, points, "Chivalrous Challenge");
	} else if (isPaladin(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_BLUE_MIDDLE_100, points, "Divine Dazzle");
	} else {
		if (isSorcerer(vocationCipId)) {
			addSpell(player, bonusData, WheelSlots_t::SLOT_BLUE_MIDDLE_100, points, "Sap Strength");
		} else {
			addSpell(player, bonusData, WheelSlots_t::SLOT_BLUE_MIDDLE_100, points, "Nature's Embrace");
		}
	}
}

// SLOT_BLUE_BOTTOM_75 = 27
void IOWheel::slotBlueBottom75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.health += 3 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.health += 2 * points;
	} else {
		bonusData.stats.health += 1 * points;
	}
	addVesselResonance(player, bonusData, WheelSlots_t::SLOT_BLUE_BOTTOM_75, WheelGemAffinity_t::Blue, points);
}

// SLOT_PURPLE_BOTTOM_75 = 28
void IOWheel::slotPurpleBottom75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t, PlayerWheelMethodsBonusData &bonusData) const {
	bonusData.mitigation += MITIGATION_INCREASE * points;
	if (isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_PURPLE_BOTTOM_75)) {
		bonusData.leech.manaLeech += MANA_LEECH_INCREASE;
	}
}

// SLOT_PURPLE_MIDDLE_100 = 29
void IOWheel::slotPurpleMiddle100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_PURPLE_MIDDLE_100, points, "Intense Wound Cleansing");
		bonusData.stats.capacity += 5 * points;
	} else if (isPaladin(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_PURPLE_MIDDLE_100, points, "Swift Foot");
		bonusData.stats.capacity += 4 * points;
	} else {
		if (isSorcerer(vocationCipId)) {
			addSpell(player, bonusData, WheelSlots_t::SLOT_PURPLE_MIDDLE_100, points, "Energy Wave");
		} else {
			addSpell(player, bonusData, WheelSlots_t::SLOT_PURPLE_MIDDLE_100, points, "Terra Wave");
		}
		bonusData.stats.capacity += 2 * points;
	}
}

// SLOT_PURPLE_TOP_150 = 30
void IOWheel::slotPurpleTop150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.mana += 1 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.mana += 3 * points;
	} else {
		bonusData.stats.mana += 6 * points;
	}
	addVesselResonance(player, bonusData, WheelSlots_t::SLOT_PURPLE_TOP_150, WheelGemAffinity_t::Purple, points);
}

// SLOT_BLUE_200 = 31
void IOWheel::slotBlue200(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_BLUE_200, points, "Fierce Berserk");
		bonusData.stats.health += 3 * points;
		bonusData.stats.mana += 1 * points;
	} else if (isPaladin(vocationCipId)) {
		addSpell(player, bonusData, WheelSlots_t::SLOT_BLUE_200, points, "Divine Caldera");
		bonusData.stats.health += 2 * points;
		bonusData.stats.mana += 3 * points;
	} else {
		if (isSorcerer(vocationCipId)) {
			addSpell(player, bonusData, WheelSlots_t::SLOT_BLUE_200, points, "Great Fire Wave");
		} else {
			addSpell(player, bonusData, WheelSlots_t::SLOT_BLUE_200, points, "Heal Friend");
		}
		bonusData.stats.health += 1 * points;
		bonusData.stats.mana += 6 * points;
	}
}

// SLOT_BLUE_BOTTOM_150 = 32
void IOWheel::slotBlueBottom150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.capacity += 5 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.capacity += 4 * points;
	} else {
		bonusData.stats.capacity += 2 * points;
	}
	addVesselResonance(player, bonusData, WheelSlots_t::SLOT_BLUE_BOTTOM_150, WheelGemAffinity_t::Blue, points);
}

// SLOT_BLUE_BOTTOM_100 = 33
void IOWheel::slotBlueBottom100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	bonusData.mitigation += MITIGATION_INCREASE * points;
	bool onSlot = isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_BLUE_BOTTOM_100);
	if (isKnight(vocationCipId) && onSlot) {
		bonusData.skills.melee += 1;
	} else if (isPaladin(vocationCipId) && onSlot) {
		bonusData.skills.distance += 1;
	} else if (onSlot && (isSorcerer(vocationCipId) || isDruid(vocationCipId))) {
		bonusData.skills.magic += 1;
	}
}

// SLOT_PURPLE_BOTTOM_100 = 34
void IOWheel::slotPurpleBottom100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.capacity += 5 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.capacity += 4 * points;
	} else {
		bonusData.stats.capacity += 2 * points;
	}
	addVesselResonance(player, bonusData, WheelSlots_t::SLOT_PURPLE_BOTTOM_100, WheelGemAffinity_t::Purple, points);
}

// SLOT_PURPLE_BOTTOM_150 = 35
void IOWheel::slotPurpleBottom150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	if (isKnight(vocationCipId)) {
		bonusData.stats.mana += 1 * points;
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.mana += 3 * points;
	} else {
		bonusData.stats.mana += 6 * points;
	}
	if (isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_PURPLE_BOTTOM_150)) {
		bonusData.leech.lifeLeech += HEALTH_LEECH_INCREASE;
	}
}

// SLOT_PURPLE_200 = 36
void IOWheel::slotPurple200(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const {
	bool isPointsAtSlot = isMaxPointAddedToSlot(player, points, WheelSlots_t::SLOT_PURPLE_200);
	if (isKnight(vocationCipId)) {
		bonusData.stats.health += 3 * points;
		bonusData.stats.mana += 1 * points;
		if (isPointsAtSlot) {
			bonusData.instant.battleHealing = true;
		}
	} else if (isPaladin(vocationCipId)) {
		bonusData.stats.health += 2 * points;
		bonusData.stats.mana += 3 * points;
		if (isPointsAtSlot) {
			bonusData.instant.ballisticMastery = true;
		}
	} else {
		bonusData.stats.health += 1 * points;
		bonusData.stats.mana += 6 * points;
		if (isPointsAtSlot) {
			if (isSorcerer(vocationCipId)) {
				bonusData.instant.focusMastery = true;
			} else {
				bonusData.instant.runicMastery = true;
			}
		}
	}
}
