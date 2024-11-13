/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#include "creatures/players/wheel/wheel_gems.hpp"

#include "creatures/creatures_definitions.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "enums/player_wheel.hpp"

void GemModifierResistanceStrategy::execute() {
	m_wheel.addResistance(m_combatType, m_resistance);
}

void GemModifierStatStrategy::execute() {
	m_wheel.addStat(m_stat, m_value);
}

void GemModifierRevelationStrategy::execute() {
	m_wheel.addRevelationBonus(m_affinity, m_value);
}

void GemModifierSpellBonusStrategy::execute() {
	m_wheel.addSpellBonus(m_spellName, m_bonus);
}

void WheelModifierContext::addStrategies(WheelGemBasicModifier_t modifier, uint8_t grade) {
	float gradeMultiplier = 1.0;
	if (grade == 1) {
		gradeMultiplier = 1.1;
	} else if (grade == 2) {
		gradeMultiplier = 1.2;
	} else if (grade == 3) {
		gradeMultiplier = 1.5;
	}

	switch (modifier) {
		case WheelGemBasicModifier_t::General_PhysicalResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_PHYSICALDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_HolyResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_HOLYDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_DeathResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_DEATHDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_FireResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 200 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_EarthResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 200 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_IceResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 200 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_EnergyResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 200 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_HolyResistance_DeathWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_HOLYDAMAGE, 150 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_DEATHDAMAGE, -100));
			break;
		case WheelGemBasicModifier_t::General_DeathResistance_HolyWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_DEATHDAMAGE, 150 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_HOLYDAMAGE, -100));
			break;
		case WheelGemBasicModifier_t::General_FireResistance_EarthResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 100 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_FireResistance_IceResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 100 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_FireResistance_EnergyResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 100 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_EarthResistance_IceResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 100 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_EarthResistance_EnergyResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 100 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_IceResistance_EnergyResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 100 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_FireResistance_EarthWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 300 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_FireResistance_IceWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 300 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_FireResistance_EnergyWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 300 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_EarthResistance_FireWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 300 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_EarthResistance_IceWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 300 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_EarthResistance_EnergyWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 300 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_IceResistance_EarthWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 300 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_IceResistance_FireWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 300 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_IceResistance_EnergyWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 300 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_EnergyResistance_EarthWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 300 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_EnergyResistance_IceWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 300 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_EnergyResistance_FireWeakness:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 300 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_ManaDrainResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_MANADRAIN, 300 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_LifeDrainResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_LIFEDRAIN, 300 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_ManaDrainResistance_LifeDrainResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_MANADRAIN, 150 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_LIFEDRAIN, 150 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::General_MitigationMultiplier:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MITIGATION, 500 * gradeMultiplier));
			break;

		case WheelGemBasicModifier_t::Vocation_Health:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::HEALTH, WheelGemUtils::getHealthValue(m_vocation, modifier) * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Mana_FireResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA, WheelGemUtils::getManaValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Mana_EnergyResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA, WheelGemUtils::getManaValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Mana_Earth_Resistance:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA, WheelGemUtils::getManaValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Mana_Ice_Resistance:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA, WheelGemUtils::getManaValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Mana:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA, WheelGemUtils::getManaValue(m_vocation, modifier) * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Health_FireResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::HEALTH, WheelGemUtils::getHealthValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Health_EnergyResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::HEALTH, WheelGemUtils::getHealthValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Health_EarthResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::HEALTH, WheelGemUtils::getHealthValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Health_IceResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::HEALTH, WheelGemUtils::getHealthValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Mixed:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::HEALTH, WheelGemUtils::getHealthValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA, WheelGemUtils::getManaValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CAPACITY, WheelGemUtils::getCapacityValue(m_vocation, modifier) * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Capacity_FireResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CAPACITY, WheelGemUtils::getCapacityValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Capacity_EnergyResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CAPACITY, WheelGemUtils::getCapacityValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Capacity_EarthResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CAPACITY, WheelGemUtils::getCapacityValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Capacity_IceResistance:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CAPACITY, WheelGemUtils::getCapacityValue(m_vocation, modifier) * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 100 * gradeMultiplier));
			break;
		case WheelGemBasicModifier_t::Vocation_Capacity:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CAPACITY, WheelGemUtils::getCapacityValue(m_vocation, modifier) * gradeMultiplier));
			break;

		default:
			g_logger().error("WheelModifierContext::setStrategy: Invalid basic modifier: {}", static_cast<uint8_t>(modifier));
	}
}

void WheelModifierContext::addStrategies(WheelGemSupremeModifier_t modifier, uint8_t grade) {
	WheelSpells::Bonus bonus;
	auto &wheelBonus = m_wheel.getBonusData();

	float gradeMultiplier = 1.0;
	if (grade == 1) {
		gradeMultiplier = 1.1;
	} else if (grade == 2) {
		gradeMultiplier = 1.2;
	} else if (grade == 3) {
		gradeMultiplier = 1.5;
	}

	switch (modifier) {
		case WheelGemSupremeModifier_t::General_Dodge:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::DODGE, 28 * gradeMultiplier));
			break;
		case WheelGemSupremeModifier_t::General_LifeLeech:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::LIFE_LEECH, 200 * gradeMultiplier));
			break;
		case WheelGemSupremeModifier_t::General_ManaLeech:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA_LEECH, 80 * gradeMultiplier));
			break;
		case WheelGemSupremeModifier_t::General_CriticalDamage:
			m_strategies.emplace_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CRITICAL_DAMAGE, 200 * gradeMultiplier));
			break;
		case WheelGemSupremeModifier_t::General_RevelationMastery_GiftOfLife:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Green, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Green, 150 * gradeMultiplier);
			break;

		case WheelGemSupremeModifier_t::SorcererDruid_UltimateHealing:
			bonus.increase.heal = 5 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Ultimate Healing", bonus));
			break;

		case WheelGemSupremeModifier_t::Knight_RevelationMastery_ExecutionersThrow:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Red, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Red, 150 * gradeMultiplier);
			break;
		case WheelGemSupremeModifier_t::Knight_RevelationMastery_AvatarOfSteel:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Purple, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Purple, 150 * gradeMultiplier);
			break;
		case WheelGemSupremeModifier_t::Knight_RevelationMastery_CombatMastery:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Blue, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Blue, 150 * gradeMultiplier);
			break;

		case WheelGemSupremeModifier_t::Paladin_RevelationMastery_DivineGrenade:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Red, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Red, 150 * gradeMultiplier);
			break;
		case WheelGemSupremeModifier_t::Paladin_RevelationMastery_AvatarOfLight:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Purple, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Purple, 150 * gradeMultiplier);
			break;
		case WheelGemSupremeModifier_t::Paladin_RevelationMastery_DivineEmpowerment:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Blue, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Blue, 150 * gradeMultiplier);
			break;

		case WheelGemSupremeModifier_t::Druid_RevelationMastery_BlessingOfTheGrove:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Red, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Red, 150 * gradeMultiplier);
			break;
		case WheelGemSupremeModifier_t::Druid_RevelationMastery_AvatarOfNature:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Purple, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Purple, 150 * gradeMultiplier);
			break;
		case WheelGemSupremeModifier_t::Druid_RevelationMastery_TwinBursts:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Blue, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Blue, 150 * gradeMultiplier);
			break;

		case WheelGemSupremeModifier_t::Sorcerer_RevelationMastery_BeamMastery:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Red, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Red, 150 * gradeMultiplier);
			break;
		case WheelGemSupremeModifier_t::Sorcerer_RevelationMastery_AvatarOfStorm:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Purple, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Purple, 150 * gradeMultiplier);
			break;
		case WheelGemSupremeModifier_t::Sorcerer_RevelationMastery_DrainBody:
			m_strategies.emplace_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Blue, 150 * gradeMultiplier));
			m_wheel.addRevelationBonus(WheelGemAffinity_t::Blue, 150 * gradeMultiplier);
			break;

		case WheelGemSupremeModifier_t::Knight_AvatarOfSteel_Cooldown:
			bonus.decrease.cooldown = 900 * 1000;
			wheelBonus.momentum += grade < 3 ? 0.33 * grade : 1;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Avatar of Steel", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_ExecutionersThrow_Cooldown:
			bonus.decrease.cooldown = 2 * 1000;
			wheelBonus.momentum += grade < 3 ? 0.33 * grade : 1;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Executioner's Throw", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_ExecutionersThrow_DamageIncrease:
			bonus.increase.damage = 6 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Executioner's Throw", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_ExecutionersThrow_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Executioner's Throw", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Fierce_Berserk_DamageIncrease:
			bonus.increase.damage = 5 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Fierce Berserk", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Fierce_Berserk_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Fierce Berserk", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Berserk_DamageIncrease:
			bonus.increase.damage = 5 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Berserk", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Berserk_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Berserk", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Front_Sweep_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Front Sweep", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Front_Sweep_DamageIncrease:
			bonus.increase.damage = 8 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Front Sweep", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Groundshaker_DamageIncrease:
			bonus.increase.damage = static_cast<int>(std::round(6.5 * gradeMultiplier));
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Groundshaker", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Groundshaker_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Groundshaker", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Annihilation_CriticalExtraDamage:
			bonus.increase.criticalDamage = 15 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Annihilation", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Annihilation_DamageIncrease:
			bonus.increase.damage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Annihilation", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_FairWoundCleansing_HealingIncrease:
			bonus.increase.heal = 10 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Fair Wound Cleansing", bonus));
			break;

		case WheelGemSupremeModifier_t::Paladin_AvatarOfLight_Cooldown:
			bonus.decrease.cooldown = 900 * 1000;
			wheelBonus.momentum += grade < 3 ? 0.33 * grade : 1;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Avatar of Light", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineDazzle_Cooldown:
			bonus.decrease.cooldown = 4 * 1000;
			wheelBonus.momentum += grade < 3 ? 0.33 * grade : 1;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Dazzle", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineGrenade_DamageIncrease:
			bonus.increase.damage = 6 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Grenade", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineGrenade_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Grenade", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineCaldera_DamageIncrease:
			bonus.increase.damage = 5 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Caldera", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineCaldera_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Caldera", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineMissile_DamageIncrease:
			bonus.increase.damage = 8 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Missile", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineMissile_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Missile", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_EtherealSpear_DamageIncrease:
			bonus.increase.damage = 10 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Ethereal Spear", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_EtherealSpear_CriticalExtraDamage:
			bonus.increase.criticalDamage = 15 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Ethereal Spear", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_StrongEtherealSpear_DamageIncrease:
			bonus.increase.damage = 8 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Strong Ethereal Spear", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_StrongEtherealSpear_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Strong Ethereal Spear", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineEmpowerment_Cooldown:
			bonus.decrease.cooldown = 6 * 1000;
			wheelBonus.momentum += grade < 3 ? 0.33 * grade : 1;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Empowerment", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineGrenade_Cooldown:
			bonus.decrease.cooldown = 2 * 1000;
			wheelBonus.momentum += grade < 3 ? 0.33 * grade : 1;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Grenade", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_Salvation_HealingIncrease:
			bonus.increase.heal = 6 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Salvation", bonus));
			break;

		case WheelGemSupremeModifier_t::Sorcerer_AvatarOfStorm_Cooldown:
			bonus.decrease.cooldown = 900 * 1000;
			wheelBonus.momentum += grade < 3 ? 0.33 * grade : 1;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Avatar of Storm", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_EnergyWave_Cooldown:
			bonus.decrease.cooldown = 1 * 1000;
			wheelBonus.momentum += grade < 3 ? 0.33 * grade : 1;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Energy Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_GreatDeathBeam_DamageIncrease:
			bonus.increase.damage = 10 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Great Death Beam", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_GreatDeathBeam_CriticalExtraDamage:
			bonus.increase.criticalDamage = 15 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Great Death Beam", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_HellsCore_DamageIncrease:
			bonus.increase.damage = 8 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Hell's Core", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_HellsCore_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Hell's Core", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_EnergyWave_DamageIncrease:
			bonus.increase.damage = 5 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Energy Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_EnergyWave_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Energy Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_GreatFireWave_DamageIncrease:
			bonus.increase.damage = 5 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Great Fire Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_GreatFireWave_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Great Fire Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_RageOfTheSkies_DamageIncrease:
			bonus.increase.damage = 8 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Rage of the Skies", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_RageOfTheSkies_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Rage of the Skies", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_GreatEnergyBeam_DamageIncrease:
			bonus.increase.damage = 10 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Great Energy Beam", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_GreatEnergyBeam_CriticalExtraDamage:
			bonus.increase.criticalDamage = 15 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Great Energy Beam", bonus));
			break;

		case WheelGemSupremeModifier_t::Druid_AvatarOfNature_Cooldown:
			bonus.decrease.cooldown = 900 * 1000;
			wheelBonus.momentum += grade < 3 ? 0.33 * grade : 1;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Avatar of Nature", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_NaturesEmbrace_Cooldown:
			bonus.decrease.cooldown = 5 * 1000;
			wheelBonus.momentum += grade < 3 ? 0.33 * grade : 1;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Nature's Embrace", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_TerraBurst_DamageIncrease:
			bonus.increase.damage = 7 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Terra Burst", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_TerraBurst_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Terra Burst", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_IceBurst_DamageIncrease:
			bonus.increase.damage = 7 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Ice Burst", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_IceBurst_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Ice Burst", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_EternalWinter_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Eternal Winter", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_EternalWinter_DamageIncrease:
			bonus.increase.damage = 8 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Eternal Winter", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_TerraWave_DamageIncrease:
			bonus.increase.damage = 5 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Terra Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_TerraWave_CriticalExtraDamage:
			bonus.increase.criticalDamage = 12 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Terra Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_StrongIceWave_DamageIncrease:
			bonus.increase.damage = 8 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Strong Ice Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_StrongIceWave_CriticalExtraDamage:
			bonus.increase.criticalDamage = 15 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Strong Ice Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_HealFriend_HealingIncrease:
			bonus.increase.heal = 5 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Heal Friend", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_MassHealing_HealingIncrease:
			bonus.increase.heal = 5 * gradeMultiplier;
			m_strategies.emplace_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Mass Healing", bonus));
			break;
		default:
			g_logger().error("WheelModifierContext::setStrategy: Invalid supreme modifier: {}", static_cast<uint8_t>(modifier));
	}
}

void WheelModifierContext::executeStrategies() const {
	for (const auto &strategy : m_strategies) {
		strategy->execute();
	}
}

int32_t WheelGemUtils::getHealthValue(Vocation_t vocation, WheelGemBasicModifier_t modifier) {
	static const std::unordered_map<WheelGemBasicModifier_t, std::unordered_map<Vocation_t, int32_t>> stats = {
		{
			WheelGemBasicModifier_t::Vocation_Health,
			{
				{ Vocation_t::VOCATION_KNIGHT, 300 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Health_FireResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 150 },
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 50 },
				{ Vocation_t::VOCATION_DRUID, 50 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Health_EnergyResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 150 },
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 50 },
				{ Vocation_t::VOCATION_DRUID, 50 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Health_EarthResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 150 },
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 50 },
				{ Vocation_t::VOCATION_DRUID, 50 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Health_IceResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 150 },
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 50 },
				{ Vocation_t::VOCATION_DRUID, 50 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mixed,
			{
				{ Vocation_t::VOCATION_KNIGHT, 150 },
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 50 },
				{ Vocation_t::VOCATION_DRUID, 50 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mixed2,
			{
				{ Vocation_t::VOCATION_KNIGHT, 150 },
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 50 },
				{ Vocation_t::VOCATION_DRUID, 50 },
			},
		},
	};

	auto modifierIt = stats.find(modifier);
	if (modifierIt != stats.end()) {
		auto vocationIt = modifierIt->second.find(vocation);
		if (vocationIt != modifierIt->second.end()) {
			return vocationIt->second;
		}
	}
	return 0;
}

int32_t WheelGemUtils::getManaValue(Vocation_t vocation, WheelGemBasicModifier_t modifier) {
	static const std::unordered_map<WheelGemBasicModifier_t, std::unordered_map<Vocation_t, int32_t>> stats = {
		{
			WheelGemBasicModifier_t::Vocation_Mana_FireResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 50 },
				{ Vocation_t::VOCATION_PALADIN, 150 },
				{ Vocation_t::VOCATION_SORCERER, 300 },
				{ Vocation_t::VOCATION_DRUID, 300 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mana_EnergyResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 50 },
				{ Vocation_t::VOCATION_PALADIN, 150 },
				{ Vocation_t::VOCATION_SORCERER, 300 },
				{ Vocation_t::VOCATION_DRUID, 300 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mana_Earth_Resistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 50 },
				{ Vocation_t::VOCATION_PALADIN, 150 },
				{ Vocation_t::VOCATION_SORCERER, 300 },
				{ Vocation_t::VOCATION_DRUID, 300 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mana_Ice_Resistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 50 },
				{ Vocation_t::VOCATION_PALADIN, 150 },
				{ Vocation_t::VOCATION_SORCERER, 300 },
				{ Vocation_t::VOCATION_DRUID, 300 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mana,
			{
				{ Vocation_t::VOCATION_KNIGHT, 100 },
				{ Vocation_t::VOCATION_PALADIN, 300 },
				{ Vocation_t::VOCATION_SORCERER, 600 },
				{ Vocation_t::VOCATION_DRUID, 600 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mixed,
			{
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 150 },
				{ Vocation_t::VOCATION_DRUID, 150 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Capacity,
			{
				{ Vocation_t::VOCATION_KNIGHT, 50 },
				{ Vocation_t::VOCATION_PALADIN, 150 },
				{ Vocation_t::VOCATION_SORCERER, 300 },
				{ Vocation_t::VOCATION_DRUID, 300 },
			},
		}
	};

	auto modifierIt = stats.find(modifier);
	if (modifierIt != stats.end()) {
		auto vocationIt = modifierIt->second.find(vocation);
		if (vocationIt != modifierIt->second.end()) {
			return vocationIt->second;
		}
	}
	return 0;
}

int32_t WheelGemUtils::getCapacityValue(Vocation_t vocation, WheelGemBasicModifier_t modifier) {
	static const std::unordered_map<WheelGemBasicModifier_t, std::unordered_map<Vocation_t, int32_t>> stats = {
		{
			WheelGemBasicModifier_t::Vocation_Capacity_FireResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 250 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Capacity_EnergyResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 250 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Capacity_EarthResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 250 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Capacity_IceResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 250 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Capacity,
			{
				{ Vocation_t::VOCATION_KNIGHT, 500 },
				{ Vocation_t::VOCATION_PALADIN, 400 },
				{ Vocation_t::VOCATION_SORCERER, 200 },
				{ Vocation_t::VOCATION_DRUID, 200 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mixed,
			{
				{ Vocation_t::VOCATION_KNIGHT, 125 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mixed2,
			{
				{ Vocation_t::VOCATION_KNIGHT, 250 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		}
	};

	auto modifierIt = stats.find(modifier);
	if (modifierIt != stats.end()) {
		auto vocationIt = modifierIt->second.find(vocation);
		if (vocationIt != modifierIt->second.end()) {
			return vocationIt->second;
		}
	}
	return 0;
}
