/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#pragma once

#include "wheel_definitions.hpp"

class PlayerWheel;

enum class WheelGemAction_t : uint8_t {
	Destroy,
	Reveal,
	SwitchDomain,
	ToggleLock,
};

enum class WheelGemAffinity_t : uint8_t {
	Green,
	Red,
	Blue,
	Purple,
};

enum class WheelGemQuality_t : uint8_t {
	Lesser,
	Regular,
	Greater,
};

enum class WheelGemBasicModifier_t : uint8_t {
	General_PhysicalResistance,
	General_HolyResistance,
	General_DeathResistance,
	General_FireResistance,
	General_EarthResistance,
	General_IceResistance,
	General_EnergyResistance,

	General_HolyResistance_DeathWeakness,
	General_DeathResistance_HolyWeakness,
	General_FireResistance_EarthResistance,
	General_FireResistance_IceResistance,
	General_FireResistance_EnergyResistance,
	General_EarthResistance_IceResistance,
	General_EarthResistance_EnergyResistance,
	General_IceResistance_EnergyResistance,

	General_FireResistance_EarthWeakness,
	General_FireResistance_IceWeakness,
	General_FireResistance_EnergyWeakness,
	General_EarthResistance_FireWeakness,
	General_EarthResistance_IceWeakness,
	General_EarthResistance_EnergyWeakness,
	General_IceResistance_EarthWeakness,
	General_IceResistance_FireWeakness,
	General_IceResistance_EnergyWeakness,
	General_EnergyResistance_EarthWeakness,
	General_EnergyResistance_IceWeakness,
	General_EnergyResistance_FireWeakness,
	General_ManaDrainResistance,
	General_LifeDrainResistance,
	General_ManaDrainResistance_LifeDrainResistance,
	General_MitigationMultiplier,

	Vocation_Health,
	Vocation_Capacity,
	Vocation_Mana_FireResistance,
	Vocation_Mana_EnergyResistance,
	Vocation_Mana_Earth_Resistance,
	Vocation_Mana_Ice_Resistance,
	Vocation_Mana,
	Vocation_Health_FireResistance,
	Vocation_Health_EnergyResistance,
	Vocation_Health_EarthResistance,
	Vocation_Health_IceResistance,
	Vocation_Mixed,
	Vocation_Mixed2,
	Vocation_Capacity_FireResistance,
	Vocation_Capacity_EnergyResistance,
	Vocation_Capacity_EarthResistance,
	Vocation_Capacity_IceResistance,
};

enum class WheelGemSupremeModifier_t : uint8_t {
	General_Dodge,
	General_CriticalDamage,
	General_LifeLeech,
	General_ManaLeech,
	SorcererDruid_UltimateHealing,
	General_RevelationMastery_GiftOfLife,

	Knight_AvatarOfSteel_Cooldown,
	Knight_ExecutionersThrow_Cooldown,
	Knight_ExecutionersThrow_DamageIncrease,
	Knight_ExecutionersThrow_CriticalExtraDamage,
	Knight_Fierce_Berserk_DamageIncrease,
	Knight_Fierce_Berserk_CriticalExtraDamage,
	Knight_Berserk_DamageIncrease,
	Knight_Berserk_CriticalExtraDamage,
	Knight_Front_Sweep_CriticalExtraDamage,
	Knight_Front_Sweep_DamageIncrease,
	Knight_Groundshaker_DamageIncrease,
	Knight_Groundshaker_CriticalExtraDamage,
	Knight_Annihilation_CriticalExtraDamage,
	Knight_Annihilation_DamageIncrease,
	Knight_FairWoundCleansing_HealingIncrease,
	Knight_RevelationMastery_AvatarOfSteel,
	Knight_RevelationMastery_ExecutionersThrow,
	Knight_RevelationMastery_CombatMastery,

	Paladin_AvatarOfLight_Cooldown,
	Paladin_DivineDazzle_Cooldown,
	Paladin_DivineGrenade_DamageIncrease,
	Paladin_DivineGrenade_CriticalExtraDamage,
	Paladin_DivineCaldera_DamageIncrease,
	Paladin_DivineCaldera_CriticalExtraDamage,
	Paladin_DivineMissile_DamageIncrease,
	Paladin_DivineMissile_CriticalExtraDamage,
	Paladin_EtherealSpear_DamageIncrease,
	Paladin_EtherealSpear_CriticalExtraDamage,
	Paladin_StrongEtherealSpear_DamageIncrease,
	Paladin_StrongEtherealSpear_CriticalExtraDamage,
	Paladin_DivineEmpowerment_Cooldown,
	Paladin_DivineGrenade_Cooldown,
	Paladin_Salvation_HealingIncrease,
	Paladin_RevelationMastery_AvatarOfLight,
	Paladin_RevelationMastery_DivineGrenade,
	Paladin_RevelationMastery_DivineEmpowerment,

	Sorcerer_AvatarOfStorm_Cooldown,
	Sorcerer_EnergyWave_Cooldown,
	Sorcerer_GreatDeathBeam_DamageIncrease,
	Sorcerer_GreatDeathBeam_CriticalExtraDamage,
	Sorcerer_HellsCore_DamageIncrease,
	Sorcerer_HellsCore_CriticalExtraDamage,
	Sorcerer_EnergyWave_DamageIncrease,
	Sorcerer_EnergyWave_CriticalExtraDamage,
	Sorcerer_GreatFireWave_DamageIncrease,
	Sorcerer_GreatFireWave_CriticalExtraDamage,
	Sorcerer_RageOfTheSkies_DamageIncrease,
	Sorcerer_RageOfTheSkies_CriticalExtraDamage,
	Sorcerer_GreatEnergyBeam_DamageIncrease,
	Sorcerer_GreatEnergyBeam_CriticalExtraDamage,
	Sorcerer_RevelationMastery_AvatarOfStorm,
	Sorcerer_RevelationMastery_BeamMastery,
	Sorcerer_RevelationMastery_DrainBody,

	Druid_AvatarOfNature_Cooldown,
	Druid_NaturesEmbrace_Cooldown,
	Druid_TerraBurst_DamageIncrease,
	Druid_TerraBurst_CriticalExtraDamage,
	Druid_IceBurst_DamageIncrease,
	Druid_IceBurst_CriticalExtraDamage,
	Druid_EternalWinter_CriticalExtraDamage,
	Druid_EternalWinter_DamageIncrease,
	Druid_TerraWave_DamageIncrease,
	Druid_TerraWave_CriticalExtraDamage,
	Druid_StrongIceWave_DamageIncrease,
	Druid_StrongIceWave_CriticalExtraDamage,
	Druid_HealFriend_HealingIncrease,
	Druid_MassHealing_HealingIncrease,
	Druid_RevelationMastery_AvatarOfNature,
	Druid_RevelationMastery_BlessingOfTheGrove,
	Druid_RevelationMastery_TwinBursts,
};

class GemModifierStrategy {
public:
	explicit GemModifierStrategy(PlayerWheel &wheel) :
		m_wheel(wheel) { }
	virtual ~GemModifierStrategy() = default;
	virtual void execute() = 0;

protected:
	PlayerWheel &m_wheel;
};

class GemModifierResistanceStrategy : public GemModifierStrategy {
public:
	explicit GemModifierResistanceStrategy(PlayerWheel &wheel, CombatType_t combatType, int32_t resistance) :
		GemModifierStrategy(wheel),
		m_combatType(combatType),
		m_resistance(resistance) { }

	void execute() override;

private:
	CombatType_t m_combatType;
	int32_t m_resistance;
};

class GemModifierStatStrategy : public GemModifierStrategy {
public:
	explicit GemModifierStatStrategy(PlayerWheel &wheel, WheelStat_t stat, int32_t value) :
		GemModifierStrategy(wheel),
		m_stat(stat),
		m_value(value) { }

	void execute() override;

private:
	WheelStat_t m_stat;
	int32_t m_value;
};

class GemModifierRevelationStrategy : public GemModifierStrategy {
public:
	explicit GemModifierRevelationStrategy(PlayerWheel &wheel, WheelGemAffinity_t affinity, [[maybe_unused]] uint16_t value) :
		GemModifierStrategy(wheel),
		m_affinity(affinity) { }

	void execute() override;

private:
	WheelGemAffinity_t m_affinity;
	uint16_t m_value;
};

class GemModifierSpellBonusStrategy : public GemModifierStrategy {
public:
	explicit GemModifierSpellBonusStrategy(PlayerWheel &wheel, std::string spellName, WheelSpells::Bonus bonus) :
		GemModifierStrategy(wheel),
		m_spellName(std::move(spellName)),
		m_bonus(bonus) { }

	void execute() override;

private:
	std::string m_spellName;
	WheelSpells::Bonus m_bonus;
};

class WheelModifierContext {
public:
	explicit WheelModifierContext(PlayerWheel &wheel, Vocation_t vocation) :
		m_wheel(wheel), m_vocation(vocation) { }

	void addStrategies(WheelGemBasicModifier_t modifier);
	void addStrategies(WheelGemSupremeModifier_t modifier);

	void resetStrategies() {
		m_strategies.clear();
	}

	void executeStrategies();

private:
	std::vector<std::unique_ptr<GemModifierStrategy>> m_strategies;
	PlayerWheel &m_wheel;
	Vocation_t m_vocation;
};

[[maybe_unused]] static int32_t getHealthValue(Vocation_t vocation, WheelGemBasicModifier_t modifier) {
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

[[maybe_unused]] static int32_t getManaValue(Vocation_t vocation, WheelGemBasicModifier_t modifier) {
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

[[maybe_unused]] static int32_t getCapacityValue(Vocation_t vocation, WheelGemBasicModifier_t modifier) {
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
				{ Vocation_t::VOCATION_KNIGHT, 250 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
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
