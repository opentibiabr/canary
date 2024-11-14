/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#include "creatures/players/wheel/wheel_gems.hpp"

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

void WheelModifierContext::addStrategies(WheelGemBasicModifier_t modifier) {
	switch (modifier) {
		case WheelGemBasicModifier_t::General_PhysicalResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_PHYSICALDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::General_HolyResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_HOLYDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::General_DeathResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_DEATHDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::General_FireResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 200));
			break;
		case WheelGemBasicModifier_t::General_EarthResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 200));
			break;
		case WheelGemBasicModifier_t::General_IceResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 200));
			break;
		case WheelGemBasicModifier_t::General_EnergyResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 200));
			break;
		case WheelGemBasicModifier_t::General_HolyResistance_DeathWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_HOLYDAMAGE, 150));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_DEATHDAMAGE, -100));
			break;
		case WheelGemBasicModifier_t::General_DeathResistance_HolyWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_DEATHDAMAGE, 150));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_HOLYDAMAGE, -100));
			break;
		case WheelGemBasicModifier_t::General_FireResistance_EarthResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 100));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::General_FireResistance_IceResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 100));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::General_FireResistance_EnergyResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 100));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::General_EarthResistance_IceResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 100));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::General_EarthResistance_EnergyResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 100));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::General_IceResistance_EnergyResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 100));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::General_FireResistance_EarthWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 300));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_FireResistance_IceWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 300));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_FireResistance_EnergyWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 300));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_EarthResistance_FireWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 300));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_EarthResistance_IceWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 300));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_EarthResistance_EnergyWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 300));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_IceResistance_EarthWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 300));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_IceResistance_FireWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 300));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_IceResistance_EnergyWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 300));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_EnergyResistance_EarthWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 300));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_EnergyResistance_IceWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 300));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_EnergyResistance_FireWeakness:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 300));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, -200));
			break;
		case WheelGemBasicModifier_t::General_ManaDrainResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_MANADRAIN, 300));
			break;
		case WheelGemBasicModifier_t::General_LifeDrainResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_LIFEDRAIN, 300));
			break;
		case WheelGemBasicModifier_t::General_ManaDrainResistance_LifeDrainResistance:
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_MANADRAIN, 150));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_LIFEDRAIN, 150));
			break;
		case WheelGemBasicModifier_t::General_MitigationMultiplier:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MITIGATION, 500));
			break;

		case WheelGemBasicModifier_t::Vocation_Health:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::HEALTH, getHealthValue(m_vocation, modifier)));
			break;
		case WheelGemBasicModifier_t::Vocation_Mana_FireResistance:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA, getManaValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::Vocation_Mana_EnergyResistance:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA, getManaValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::Vocation_Mana_Earth_Resistance:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA, getManaValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::Vocation_Mana_Ice_Resistance:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA, getManaValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::Vocation_Mana:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA, getManaValue(m_vocation, modifier)));
			break;
		case WheelGemBasicModifier_t::Vocation_Health_FireResistance:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::HEALTH, getHealthValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::Vocation_Health_EnergyResistance:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::HEALTH, getHealthValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::Vocation_Health_EarthResistance:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::HEALTH, getHealthValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::Vocation_Health_IceResistance:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::HEALTH, getHealthValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::Vocation_Mixed:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::HEALTH, getHealthValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA, getManaValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CAPACITY, getCapacityValue(m_vocation, modifier)));
			break;
		case WheelGemBasicModifier_t::Vocation_Capacity_FireResistance:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CAPACITY, getCapacityValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_FIREDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::Vocation_Capacity_EnergyResistance:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CAPACITY, getCapacityValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ENERGYDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::Vocation_Capacity_EarthResistance:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CAPACITY, getCapacityValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_EARTHDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::Vocation_Capacity_IceResistance:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CAPACITY, getCapacityValue(m_vocation, modifier)));
			m_strategies.push_back(std::make_unique<GemModifierResistanceStrategy>(m_wheel, CombatType_t::COMBAT_ICEDAMAGE, 100));
			break;
		case WheelGemBasicModifier_t::Vocation_Capacity:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CAPACITY, getCapacityValue(m_vocation, modifier)));
			break;

		default:
			g_logger().error("WheelModifierContext::setStrategy: Invalid basic modifier: {}", static_cast<uint8_t>(modifier));
	}
}

void WheelModifierContext::addStrategies(WheelGemSupremeModifier_t modifier) {
	WheelSpells::Bonus bonus;

	switch (modifier) {
		case WheelGemSupremeModifier_t::General_Dodge:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::DODGE, 25));
			break;
		case WheelGemSupremeModifier_t::General_LifeLeech:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::LIFE_LEECH, 120));
			break;
		case WheelGemSupremeModifier_t::General_ManaLeech:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::MANA_LEECH, 40));
			break;
		case WheelGemSupremeModifier_t::General_CriticalDamage:
			m_strategies.push_back(std::make_unique<GemModifierStatStrategy>(m_wheel, WheelStat_t::CRITICAL_DAMAGE, 150));
			break;
		case WheelGemSupremeModifier_t::General_RevelationMastery_GiftOfLife:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Green, 150));
			break;

		case WheelGemSupremeModifier_t::SorcererDruid_UltimateHealing:
			bonus.increase.heal = 10;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Ultimate Healing", bonus));
			break;

		case WheelGemSupremeModifier_t::Knight_RevelationMastery_ExecutionersThrow:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Red, 150));
			break;
		case WheelGemSupremeModifier_t::Knight_RevelationMastery_AvatarOfSteel:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Purple, 150));
			break;
		case WheelGemSupremeModifier_t::Knight_RevelationMastery_CombatMastery:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Blue, 150));
			break;

		case WheelGemSupremeModifier_t::Paladin_RevelationMastery_DivineGrenade:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Red, 150));
			break;
		case WheelGemSupremeModifier_t::Paladin_RevelationMastery_AvatarOfLight:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Purple, 150));
			break;
		case WheelGemSupremeModifier_t::Paladin_RevelationMastery_DivineEmpowerment:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Blue, 150));
			break;

		case WheelGemSupremeModifier_t::Druid_RevelationMastery_BlessingOfTheGrove:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Red, 150));
			break;
		case WheelGemSupremeModifier_t::Druid_RevelationMastery_AvatarOfNature:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Purple, 150));
			break;
		case WheelGemSupremeModifier_t::Druid_RevelationMastery_TwinBursts:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Blue, 150));
			break;

		case WheelGemSupremeModifier_t::Sorcerer_RevelationMastery_BeamMastery:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Red, 150));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_RevelationMastery_AvatarOfStorm:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Purple, 150));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_RevelationMastery_DrainBody:
			m_strategies.push_back(std::make_unique<GemModifierRevelationStrategy>(m_wheel, WheelGemAffinity_t::Blue, 150));
			break;

		case WheelGemSupremeModifier_t::Knight_AvatarOfSteel_Cooldown:
			bonus.decrease.cooldown = 300 * 1000;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Avatar of Steel", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_ExecutionersThrow_Cooldown:
			bonus.decrease.cooldown = 1 * 1000;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Executioner's Throw", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_ExecutionersThrow_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Executioner's Throw", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_ExecutionersThrow_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Executioner's Throw", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Fierce_Berserk_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Fierce Berserk", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Fierce_Berserk_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Fierce Berserk", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Berserk_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Berserk", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Berserk_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Berserk", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Front_Sweep_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Front Sweep", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Front_Sweep_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Front Sweep", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Groundshaker_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Groundshaker", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Groundshaker_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Groundshaker", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Annihilation_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Annihilation", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_Annihilation_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Annihilation", bonus));
			break;
		case WheelGemSupremeModifier_t::Knight_FairWoundCleansing_HealingIncrease:
			bonus.increase.heal = 10;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Fair Wound Cleansing", bonus));
			break;

		case WheelGemSupremeModifier_t::Paladin_AvatarOfLight_Cooldown:
			bonus.decrease.cooldown = 300 * 1000;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Avatar of Light", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineDazzle_Cooldown:
			bonus.decrease.cooldown = 2 * 1000;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Dazzle", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineGrenade_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Grenade", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineGrenade_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Grenade", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineCaldera_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Caldera", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineCaldera_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Caldera", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineMissile_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Missile", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineMissile_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Missile", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_EtherealSpear_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Ethereal Spear", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_EtherealSpear_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Ethereal Spear", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_StrongEtherealSpear_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Strong Ethereal Spear", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_StrongEtherealSpear_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Strong Ethereal Spear", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineEmpowerment_Cooldown:
			bonus.decrease.cooldown = 3 * 1000;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Empowerment", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_DivineGrenade_Cooldown:
			bonus.decrease.cooldown = 1 * 1000;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Divine Grenade", bonus));
			break;
		case WheelGemSupremeModifier_t::Paladin_Salvation_HealingIncrease:
			bonus.increase.heal = 10;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Salvation", bonus));
			break;

		case WheelGemSupremeModifier_t::Sorcerer_AvatarOfStorm_Cooldown:
			bonus.decrease.cooldown = 300 * 1000;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Avatar of Storm", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_EnergyWave_Cooldown:
			bonus.decrease.cooldown = 1 * 1000;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Energy Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_GreatDeathBeam_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Great Death Beam", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_GreatDeathBeam_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Great Death Beam", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_HellsCore_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Hell's Core", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_HellsCore_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Hell's Core", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_EnergyWave_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Energy Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_EnergyWave_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Energy Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_GreatFireWave_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Great Fire Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_GreatFireWave_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Great Fire Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_RageOfTheSkies_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Rage of the Skies", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_RageOfTheSkies_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Rage of the Skies", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_GreatEnergyBeam_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Great Energy Beam", bonus));
			break;
		case WheelGemSupremeModifier_t::Sorcerer_GreatEnergyBeam_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Great Energy Beam", bonus));
			break;

		case WheelGemSupremeModifier_t::Druid_AvatarOfNature_Cooldown:
			bonus.decrease.cooldown = 300 * 1000;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Avatar of Nature", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_NaturesEmbrace_Cooldown:
			bonus.decrease.cooldown = 5 * 1000;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Nature's Embrace", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_TerraBurst_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Terra Burst", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_TerraBurst_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Terra Burst", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_IceBurst_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Ice Burst", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_IceBurst_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Ice Burst", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_EternalWinter_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Eternal Winter", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_EternalWinter_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Eternal Winter", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_TerraWave_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Terra Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_TerraWave_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Terra Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_StrongIceWave_DamageIncrease:
			bonus.increase.damage = 25;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Strong Ice Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_StrongIceWave_CriticalExtraDamage:
			bonus.increase.criticalDamage = 8;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Strong Ice Wave", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_HealFriend_HealingIncrease:
			bonus.increase.heal = 10;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Heal Friend", bonus));
			break;
		case WheelGemSupremeModifier_t::Druid_MassHealing_HealingIncrease:
			bonus.increase.heal = 10;
			m_strategies.push_back(std::make_unique<GemModifierSpellBonusStrategy>(m_wheel, "Mass Healing", bonus));
			break;
		default:
			g_logger().error("WheelModifierContext::setStrategy: Invalid supreme modifier: {}", static_cast<uint8_t>(modifier));
	}
}

void WheelModifierContext::executeStrategies() {
	for (auto &strategy : m_strategies) {
		strategy->execute();
	}
}
