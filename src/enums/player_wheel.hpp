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
	#include <cstdint>
#endif

enum class WheelGemAction_t : uint8_t {
	Destroy,
	Reveal,
	SwitchDomain,
	ToggleLock,
	ImproveGrade
};

enum class WheelImproveGemGrade_t : uint8_t {
	Grade1,
	Grade2,
	Grade3,
	Grade4,
};

enum class WheelFragmentType_t : uint8_t {
	Greater,
	Lesser,
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
	// Vocation_Mana_Capacity = 32, INVALID MODIFIER, WILL BE DISPLAYED AS (UNKNOWN)
	Vocation_Mana_FireResistance = 33,
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
	Vocation_Capacity,
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
	Knight_Front_Sweep_DamageIncrease,
	Knight_Front_Sweep_CriticalExtraDamage,
	Knight_Groundshaker_DamageIncrease,
	Knight_Groundshaker_CriticalExtraDamage,
	Knight_Annihilation_DamageIncrease,
	Knight_Annihilation_CriticalExtraDamage,
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
	Druid_EternalWinter_DamageIncrease,
	Druid_EternalWinter_CriticalExtraDamage,
	Druid_TerraWave_DamageIncrease,
	Druid_TerraWave_CriticalExtraDamage,
	Druid_StrongIceWave_DamageIncrease,
	Druid_StrongIceWave_CriticalExtraDamage,
	Druid_HealFriend_HealingIncrease,
	Druid_MassHealing_HealingIncrease,
	Druid_RevelationMastery_AvatarOfNature,
	Druid_RevelationMastery_BlessingOfTheGrove,
	Druid_RevelationMastery_TwinBursts,

	Monk_AvatarOfBalance_Cooldown,
	Monk_SpiritMend_HealingIncrease,
	Monk_SpiritualOutburst_DamageIncrease,
	Monk_SpiritualOutburst_CriticalExtraDamage,
	Monk_ForcefulUppercut_DamageIncrease,
	Monk_ForcefulUppercut_CriticalExtraDamage,
	Monk_FurryofBlows_DamageIncrease,
	Monk_FurryofBlows_CriticalExtraDamage,
	Monk_GreaterFurryofBlows_DamageIncrease,
	Monk_GreaterFurryofBlows_CriticalExtraDamage,
	Monk_SweepingTakedown_DamageIncrease,
	Monk_SweepingTakedown_CriticalExtraDamage,
	Monk_FocusSerenety,
	Monk_FocusHarmony,
	Monk_MassSpiritMand_HealingIncrease,
	Monk_RevelationMastery_AvatarOfBalance,
	Monk_RevelationMastery_SpiritualOutburst,
	Monk_RevelationMastery_Ascetic,
};
