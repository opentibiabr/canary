/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

// Player.hpp already includes the wheel
#include "creatures/players/player.hpp"

#include "map/spectators.hpp"
#include "creatures/monsters/monster.hpp"
#include "config/configmanager.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/combat/spells.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "enums/player_wheel.hpp"
#include "game/game.hpp"
#include "io/io_wheel.hpp"
#include "kv/kv.hpp"
#include "kv/kv_definitions.hpp"
#include "server/network/message/networkmessage.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "creatures/players/components/wheel/wheel_definitions.hpp"

static PlayerWheelGem emptyGem = {};

const std::array<int32_t, COMBAT_COUNT> m_resistance = { 0 };

const static std::vector<WheelGemBasicModifier_t> wheelGemBasicSlot1Allowed = {
	WheelGemBasicModifier_t::General_FireResistance,
	WheelGemBasicModifier_t::General_IceResistance,
	WheelGemBasicModifier_t::General_EnergyResistance,
	WheelGemBasicModifier_t::General_EarthResistance,
	WheelGemBasicModifier_t::General_MitigationMultiplier,
	WheelGemBasicModifier_t::Vocation_Health,
	WheelGemBasicModifier_t::Vocation_Mana,
	WheelGemBasicModifier_t::Vocation_Capacity,
	WheelGemBasicModifier_t::Vocation_Health_FireResistance,
	WheelGemBasicModifier_t::Vocation_Health_IceResistance,
	WheelGemBasicModifier_t::Vocation_Health_EnergyResistance,
	WheelGemBasicModifier_t::Vocation_Health_EarthResistance,
	WheelGemBasicModifier_t::Vocation_Mana_FireResistance,
	WheelGemBasicModifier_t::Vocation_Mana_EnergyResistance,
	WheelGemBasicModifier_t::Vocation_Mana_Earth_Resistance,
	WheelGemBasicModifier_t::Vocation_Mana_Ice_Resistance,
	WheelGemBasicModifier_t::Vocation_Capacity_FireResistance,
	WheelGemBasicModifier_t::Vocation_Capacity_EnergyResistance,
	WheelGemBasicModifier_t::Vocation_Capacity_EarthResistance,
	WheelGemBasicModifier_t::Vocation_Capacity_IceResistance,
};

const static std::vector<WheelGemBasicModifier_t> wheelGemBasicSlot2Allowed = {
	WheelGemBasicModifier_t::General_FireResistance,
	WheelGemBasicModifier_t::General_IceResistance,
	WheelGemBasicModifier_t::General_EnergyResistance,
	WheelGemBasicModifier_t::General_EarthResistance,
	WheelGemBasicModifier_t::General_PhysicalResistance,
	WheelGemBasicModifier_t::General_HolyResistance,
	WheelGemBasicModifier_t::General_HolyResistance_DeathWeakness,
	WheelGemBasicModifier_t::General_DeathResistance_HolyWeakness,
	WheelGemBasicModifier_t::General_FireResistance_EarthResistance,
	WheelGemBasicModifier_t::General_FireResistance_IceResistance,
	WheelGemBasicModifier_t::General_FireResistance_EnergyResistance,
	WheelGemBasicModifier_t::General_EarthResistance_IceResistance,
	WheelGemBasicModifier_t::General_EarthResistance_EnergyResistance,
	WheelGemBasicModifier_t::General_IceResistance_EnergyResistance,
	WheelGemBasicModifier_t::General_FireResistance_EarthWeakness,
	WheelGemBasicModifier_t::General_FireResistance_IceWeakness,
	WheelGemBasicModifier_t::General_FireResistance_EnergyWeakness,
	WheelGemBasicModifier_t::General_EarthResistance_FireWeakness,
	WheelGemBasicModifier_t::General_EarthResistance_IceWeakness,
	WheelGemBasicModifier_t::General_EarthResistance_EnergyWeakness,
	WheelGemBasicModifier_t::General_IceResistance_EarthWeakness,
	WheelGemBasicModifier_t::General_IceResistance_FireWeakness,
	WheelGemBasicModifier_t::General_IceResistance_EnergyWeakness,
	WheelGemBasicModifier_t::General_EnergyResistance_EarthWeakness,
	WheelGemBasicModifier_t::General_EnergyResistance_IceWeakness,
	WheelGemBasicModifier_t::General_EnergyResistance_FireWeakness,
	WheelGemBasicModifier_t::General_ManaDrainResistance,
	WheelGemBasicModifier_t::General_LifeDrainResistance,
	WheelGemBasicModifier_t::General_ManaDrainResistance_LifeDrainResistance,
	WheelGemBasicModifier_t::General_MitigationMultiplier,
};

const static std::vector<WheelGemBasicModifier_t> modsBasicPosition = {
	WheelGemBasicModifier_t::General_PhysicalResistance,
	WheelGemBasicModifier_t::General_HolyResistance,
	WheelGemBasicModifier_t::General_DeathResistance,
	WheelGemBasicModifier_t::General_FireResistance,
	WheelGemBasicModifier_t::General_EarthResistance,
	WheelGemBasicModifier_t::General_IceResistance,
	WheelGemBasicModifier_t::General_EnergyResistance,

	WheelGemBasicModifier_t::General_HolyResistance_DeathWeakness,
	WheelGemBasicModifier_t::General_DeathResistance_HolyWeakness,
	WheelGemBasicModifier_t::General_FireResistance_EarthResistance,
	WheelGemBasicModifier_t::General_FireResistance_IceResistance,
	WheelGemBasicModifier_t::General_FireResistance_EnergyResistance,
	WheelGemBasicModifier_t::General_EarthResistance_IceResistance,
	WheelGemBasicModifier_t::General_EarthResistance_EnergyResistance,
	WheelGemBasicModifier_t::General_IceResistance_EnergyResistance,

	WheelGemBasicModifier_t::General_FireResistance_EarthWeakness,
	WheelGemBasicModifier_t::General_FireResistance_IceWeakness,
	WheelGemBasicModifier_t::General_FireResistance_EnergyWeakness,
	WheelGemBasicModifier_t::General_EarthResistance_FireWeakness,
	WheelGemBasicModifier_t::General_EarthResistance_IceWeakness,
	WheelGemBasicModifier_t::General_EarthResistance_EnergyWeakness,
	WheelGemBasicModifier_t::General_IceResistance_EarthWeakness,
	WheelGemBasicModifier_t::General_IceResistance_FireWeakness,
	WheelGemBasicModifier_t::General_IceResistance_EnergyWeakness,
	WheelGemBasicModifier_t::General_EnergyResistance_EarthWeakness,
	WheelGemBasicModifier_t::General_EnergyResistance_IceWeakness,
	WheelGemBasicModifier_t::General_EnergyResistance_FireWeakness,
	WheelGemBasicModifier_t::General_ManaDrainResistance,
	WheelGemBasicModifier_t::General_LifeDrainResistance,
	WheelGemBasicModifier_t::General_ManaDrainResistance_LifeDrainResistance,
	WheelGemBasicModifier_t::General_MitigationMultiplier,

	WheelGemBasicModifier_t::Vocation_Health,
	WheelGemBasicModifier_t::Vocation_Mana_FireResistance,
	WheelGemBasicModifier_t::Vocation_Mana_EnergyResistance,
	WheelGemBasicModifier_t::Vocation_Mana_Earth_Resistance,
	WheelGemBasicModifier_t::Vocation_Mana_Ice_Resistance,
	WheelGemBasicModifier_t::Vocation_Mana,
	WheelGemBasicModifier_t::Vocation_Health_FireResistance,
	WheelGemBasicModifier_t::Vocation_Health_EnergyResistance,
	WheelGemBasicModifier_t::Vocation_Health_EarthResistance,
	WheelGemBasicModifier_t::Vocation_Health_IceResistance,

	WheelGemBasicModifier_t::Vocation_Capacity_FireResistance,
	WheelGemBasicModifier_t::Vocation_Capacity_EnergyResistance,
	WheelGemBasicModifier_t::Vocation_Capacity_EarthResistance,
	WheelGemBasicModifier_t::Vocation_Capacity_IceResistance,
	WheelGemBasicModifier_t::Vocation_Capacity,
};

const static std::vector<WheelGemSupremeModifier_t> modsSupremeKnightPosition = {
	WheelGemSupremeModifier_t::General_Dodge,
	WheelGemSupremeModifier_t::General_CriticalDamage,
	WheelGemSupremeModifier_t::General_LifeLeech,
	WheelGemSupremeModifier_t::General_ManaLeech,
	WheelGemSupremeModifier_t::General_RevelationMastery_GiftOfLife,

	WheelGemSupremeModifier_t::Knight_AvatarOfSteel_Cooldown,
	WheelGemSupremeModifier_t::Knight_ExecutionersThrow_Cooldown,
	WheelGemSupremeModifier_t::Knight_ExecutionersThrow_DamageIncrease,
	WheelGemSupremeModifier_t::Knight_ExecutionersThrow_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Knight_Fierce_Berserk_DamageIncrease,
	WheelGemSupremeModifier_t::Knight_Fierce_Berserk_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Knight_Berserk_DamageIncrease,
	WheelGemSupremeModifier_t::Knight_Berserk_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Knight_Front_Sweep_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Knight_Front_Sweep_DamageIncrease,
	WheelGemSupremeModifier_t::Knight_Groundshaker_DamageIncrease,
	WheelGemSupremeModifier_t::Knight_Groundshaker_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Knight_Annihilation_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Knight_Annihilation_DamageIncrease,
	WheelGemSupremeModifier_t::Knight_FairWoundCleansing_HealingIncrease,
	WheelGemSupremeModifier_t::Knight_RevelationMastery_AvatarOfSteel,
	WheelGemSupremeModifier_t::Knight_RevelationMastery_ExecutionersThrow,
	WheelGemSupremeModifier_t::Knight_RevelationMastery_CombatMastery,
};

const static std::vector<WheelGemSupremeModifier_t> modsSupremePaladinPosition = {
	WheelGemSupremeModifier_t::General_Dodge,
	WheelGemSupremeModifier_t::General_CriticalDamage,
	WheelGemSupremeModifier_t::General_LifeLeech,
	WheelGemSupremeModifier_t::General_ManaLeech,
	WheelGemSupremeModifier_t::General_RevelationMastery_GiftOfLife,

	WheelGemSupremeModifier_t::Paladin_AvatarOfLight_Cooldown,
	WheelGemSupremeModifier_t::Paladin_DivineDazzle_Cooldown,
	WheelGemSupremeModifier_t::Paladin_DivineGrenade_DamageIncrease,
	WheelGemSupremeModifier_t::Paladin_DivineGrenade_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Paladin_DivineCaldera_DamageIncrease,
	WheelGemSupremeModifier_t::Paladin_DivineCaldera_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Paladin_DivineMissile_DamageIncrease,
	WheelGemSupremeModifier_t::Paladin_DivineMissile_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Paladin_EtherealSpear_DamageIncrease,
	WheelGemSupremeModifier_t::Paladin_EtherealSpear_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Paladin_StrongEtherealSpear_DamageIncrease,
	WheelGemSupremeModifier_t::Paladin_StrongEtherealSpear_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Paladin_DivineEmpowerment_Cooldown,
	WheelGemSupremeModifier_t::Paladin_DivineGrenade_Cooldown,
	WheelGemSupremeModifier_t::Paladin_Salvation_HealingIncrease,
	WheelGemSupremeModifier_t::Paladin_RevelationMastery_AvatarOfLight,
	WheelGemSupremeModifier_t::Paladin_RevelationMastery_DivineGrenade,
	WheelGemSupremeModifier_t::Paladin_RevelationMastery_DivineEmpowerment,
};

const static std::vector<WheelGemSupremeModifier_t> modsSupremeSorcererPosition = {
	WheelGemSupremeModifier_t::General_Dodge,
	WheelGemSupremeModifier_t::General_CriticalDamage,
	WheelGemSupremeModifier_t::General_LifeLeech,
	WheelGemSupremeModifier_t::General_ManaLeech,
	WheelGemSupremeModifier_t::SorcererDruid_UltimateHealing,
	WheelGemSupremeModifier_t::General_RevelationMastery_GiftOfLife,

	WheelGemSupremeModifier_t::Sorcerer_AvatarOfStorm_Cooldown,
	WheelGemSupremeModifier_t::Sorcerer_EnergyWave_Cooldown,
	WheelGemSupremeModifier_t::Sorcerer_GreatDeathBeam_DamageIncrease,
	WheelGemSupremeModifier_t::Sorcerer_GreatDeathBeam_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Sorcerer_HellsCore_DamageIncrease,
	WheelGemSupremeModifier_t::Sorcerer_HellsCore_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Sorcerer_EnergyWave_DamageIncrease,
	WheelGemSupremeModifier_t::Sorcerer_EnergyWave_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Sorcerer_GreatFireWave_DamageIncrease,
	WheelGemSupremeModifier_t::Sorcerer_GreatFireWave_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Sorcerer_RageOfTheSkies_DamageIncrease,
	WheelGemSupremeModifier_t::Sorcerer_RageOfTheSkies_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Sorcerer_GreatEnergyBeam_DamageIncrease,
	WheelGemSupremeModifier_t::Sorcerer_GreatEnergyBeam_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Sorcerer_RevelationMastery_AvatarOfStorm,
	WheelGemSupremeModifier_t::Sorcerer_RevelationMastery_BeamMastery,
	WheelGemSupremeModifier_t::Sorcerer_RevelationMastery_DrainBody,
};

const static std::vector<WheelGemSupremeModifier_t> modsSupremeDruidPosition = {
	WheelGemSupremeModifier_t::General_Dodge,
	WheelGemSupremeModifier_t::General_CriticalDamage,
	WheelGemSupremeModifier_t::General_LifeLeech,
	WheelGemSupremeModifier_t::General_ManaLeech,
	WheelGemSupremeModifier_t::SorcererDruid_UltimateHealing,
	WheelGemSupremeModifier_t::General_RevelationMastery_GiftOfLife,

	WheelGemSupremeModifier_t::Druid_AvatarOfNature_Cooldown,
	WheelGemSupremeModifier_t::Druid_NaturesEmbrace_Cooldown,
	WheelGemSupremeModifier_t::Druid_TerraBurst_DamageIncrease,
	WheelGemSupremeModifier_t::Druid_TerraBurst_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Druid_IceBurst_DamageIncrease,
	WheelGemSupremeModifier_t::Druid_IceBurst_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Druid_EternalWinter_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Druid_EternalWinter_DamageIncrease,
	WheelGemSupremeModifier_t::Druid_TerraWave_DamageIncrease,
	WheelGemSupremeModifier_t::Druid_TerraWave_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Druid_StrongIceWave_DamageIncrease,
	WheelGemSupremeModifier_t::Druid_StrongIceWave_CriticalExtraDamage,
	WheelGemSupremeModifier_t::Druid_HealFriend_HealingIncrease,
	WheelGemSupremeModifier_t::Druid_MassHealing_HealingIncrease,
	WheelGemSupremeModifier_t::Druid_RevelationMastery_AvatarOfNature,
	WheelGemSupremeModifier_t::Druid_RevelationMastery_BlessingOfTheGrove,
	WheelGemSupremeModifier_t::Druid_RevelationMastery_TwinBursts,
};

// Using reference wrapper to avoid copying the vector to the map
const static std::unordered_map<uint8_t, std::reference_wrapper<const std::vector<WheelGemSupremeModifier_t>>> modsSupremePositionByVocation = {
	{ 1, std::cref(modsSupremeSorcererPosition) },
	{ 2, std::cref(modsSupremeDruidPosition) },
	{ 3, std::cref(modsSupremePaladinPosition) },
	{ 4, std::cref(modsSupremeKnightPosition) }
};

// To avoid conflict in other files that might use a function with the same name
// Here are built-in helper functions
namespace {
	template <typename SpellType>
	bool checkSpellArea(const std::array<SpellType, 5> &spellsTable, const std::string &spellName, uint8_t stage) {
		for (const auto &spellTable : spellsTable) {
			auto size = std::ssize(spellTable.grade);
			g_logger().debug("spell area stage {}, grade {}", stage, size);
			if (spellTable.name == spellName && stage < static_cast<uint8_t>(size)) {
				const auto &spellData = spellTable.grade[stage];
				if (spellData.increase.area) {
					g_logger().debug("[{}] spell with name {}, and stage {} has increase area", __FUNCTION__, spellName, stage);

					return true;
				}
			}
		}

		return false;
	}

	template <typename SpellType>
	int checkSpellAdditionalTarget(const std::array<SpellType, 5> &spellsTable, std::string_view spellName, uint8_t stage) {
		for (const auto &spellTable : spellsTable) {
			auto size = std::ssize(spellTable.grade);
			g_logger().debug("spell target stage {}, grade {}", stage, size);
			if (spellTable.name == spellName && stage < static_cast<uint8_t>(size)) {
				const auto &spellData = spellTable.grade[stage];
				if (spellData.increase.aditionalTarget) {
					return spellData.increase.aditionalTarget;
				}
			}
		}

		return 0;
	}

	template <typename SpellType>
	int checkSpellAdditionalDuration(const std::array<SpellType, 5> &spellsTable, std::string_view spellName, uint8_t stage) {
		for (const auto &spellTable : spellsTable) {
			auto size = std::ssize(spellTable.grade);
			g_logger().debug("spell duration stage {}, grade {}", stage, size);
			if (spellTable.name == spellName && stage < static_cast<uint8_t>(size)) {
				const auto &spellData = spellTable.grade[stage];
				if (spellData.increase.duration > 0) {
					return spellData.increase.duration;
				}
			}
		}

		return 0;
	}

	const static std::vector<PromotionScroll> WheelOfDestinyPromotionScrolls = {
		{ 43946, "abridged", 3 },
		{ 43947, "basic", 5 },
		{ 43948, "revised", 9 },
		{ 43949, "extended", 13 },
		{ 43950, "advanced", 20 },
	};
} // namespace

PlayerWheel::PlayerWheel(Player &initPlayer) :
	m_pointsPerLevel(g_configManager().getNumber(WHEEL_POINTS_PER_LEVEL)), m_player(initPlayer) {
}

bool PlayerWheel::canPlayerSelectPointOnSlot(WheelSlots_t slot, bool recursive) const {
	const auto playerPoints = getWheelPoints();
	// Green quadrant
	if (slot == WheelSlots_t::SLOT_GREEN_200) {
		if (playerPoints < 375u) {
			g_logger().debug("Player {} trying to manipulate byte on green slot 200 {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_150)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_TOP_150) {
		if (playerPoints < 225u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_TOP_150: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_BOTTOM_150) {
		if (playerPoints < 225u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_BOTTOM_150: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_TOP_100) {
		if (playerPoints < 125u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_TOP_100: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_MIDDLE_100) {
		if (playerPoints < 125u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_MIDDLE_100: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_BOTTOM_100) {
		if (playerPoints < 125u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_BOTTOM_100: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_TOP_75) {
		if (playerPoints < 50u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_TOP_75: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_BOTTOM_75) {
		if (playerPoints < 50u) {
			g_logger().debug("Player {} trying to manipulate byte to SLOT_GREEN_BOTTOM_75: {}", m_player.getName(), fmt::underlying(slot));
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_75)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_GREEN_50) {
		return (recursive && (getPointsBySlotType(slot) == getMaxPointsPerSlot(slot))) || true;
	}

	// Red quadrant
	if (slot == WheelSlots_t::SLOT_RED_200) {
		if (playerPoints < 375u) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_150)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_TOP_150) {
		if (playerPoints < 225) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_BOTTOM_150) {
		if (playerPoints < 225) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_TOP_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_MIDDLE_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_BOTTOM_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_TOP_75) {
		if (playerPoints < 50) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_75)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_BOTTOM_75) {
		if (playerPoints < 50) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_TOP_75)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_RED_50) {
		return (recursive && (getPointsBySlotType(slot) == getMaxPointsPerSlot(slot))) || true;
	}

	// Purple quadrant
	if (slot == WheelSlots_t::SLOT_PURPLE_200) {
		if (playerPoints < 375) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_150)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_TOP_150) {
		if (playerPoints < 225) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_150) {
		if (playerPoints < 225) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_TOP_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_MIDDLE_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_TOP_75) {
		if (playerPoints < 50) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_RED_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_75) {
		if (playerPoints < 50) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_PURPLE_50) {
		return (recursive && (getPointsBySlotType(slot) == getMaxPointsPerSlot(slot))) || true;
	}

	// Blue quadrant
	if (slot == WheelSlots_t::SLOT_BLUE_200) {
		if (playerPoints < 375) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_150)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_TOP_150) {
		if (playerPoints < 225) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_BOTTOM_150) {
		if (playerPoints < 225) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_TOP_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_MIDDLE_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_BOTTOM_100) {
		if (playerPoints < 125) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_150)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_TOP_75) {
		if (playerPoints < 50) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_GREEN_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_BOTTOM_75) {
		if (playerPoints < 50) {
			return false;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_50)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_PURPLE_BOTTOM_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_TOP_75)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_MIDDLE_100)) {
			return true;
		}
		if (canSelectSlotFullOrPartial(WheelSlots_t::SLOT_BLUE_BOTTOM_100)) {
			return true;
		}
	} else if (slot == WheelSlots_t::SLOT_BLUE_50) {
		return (recursive && (getPointsBySlotType(slot) == getMaxPointsPerSlot(slot))) || true;
	}

	return false;
}

uint16_t PlayerWheel::getUnusedPoints() const {
	auto totalPoints = getWheelPoints();

	if (totalPoints == 0) {
		return 0;
	}

	totalPoints += m_modsMaxGrade;

	for (auto slot : magic_enum::enum_values<WheelSlots_t>()) {
		totalPoints -= getPointsBySlotType(slot);
	}

	return totalPoints;
}

bool PlayerWheel::getSpellAdditionalArea(const std::string &spellName) const {
	const auto stage = static_cast<uint8_t>(getSpellUpgrade(spellName));
	if (stage == 0) {
		return false;
	}

	const auto vocationEnum = m_player.getPlayerVocationEnum();
	if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
		return checkSpellArea(g_game().getIOWheel()->getWheelBonusData().spells.knight, spellName, stage);
	}
	if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
		return checkSpellArea(g_game().getIOWheel()->getWheelBonusData().spells.paladin, spellName, stage);
	}
	if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
		return checkSpellArea(g_game().getIOWheel()->getWheelBonusData().spells.druid, spellName, stage);
	}
	if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
		return checkSpellArea(g_game().getIOWheel()->getWheelBonusData().spells.sorcerer, spellName, stage);
	}

	return false;
}

int PlayerWheel::getSpellAdditionalTarget(const std::string &spellName) const {
	const auto stage = static_cast<uint8_t>(getSpellUpgrade(spellName));
	if (stage == 0) {
		return 0;
	}

	const auto vocationEnum = m_player.getPlayerVocationEnum();
	if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
		return checkSpellAdditionalTarget(g_game().getIOWheel()->getWheelBonusData().spells.knight, spellName, stage);
	}
	if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
		return checkSpellAdditionalTarget(g_game().getIOWheel()->getWheelBonusData().spells.paladin, spellName, stage);
	}
	if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
		return checkSpellAdditionalTarget(g_game().getIOWheel()->getWheelBonusData().spells.druid, spellName, stage);
	}
	if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
		return checkSpellAdditionalTarget(g_game().getIOWheel()->getWheelBonusData().spells.sorcerer, spellName, stage);
	}

	return 0;
}

int PlayerWheel::getSpellAdditionalDuration(const std::string &spellName) const {
	const auto stage = static_cast<uint8_t>(getSpellUpgrade(spellName));
	if (stage == 0) {
		return 0;
	}

	const auto vocationEnum = m_player.getPlayerVocationEnum();
	if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
		return checkSpellAdditionalDuration(g_game().getIOWheel()->getWheelBonusData().spells.knight, spellName, stage);
	}
	if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
		return checkSpellAdditionalDuration(g_game().getIOWheel()->getWheelBonusData().spells.paladin, spellName, stage);
	}
	if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
		return checkSpellAdditionalDuration(g_game().getIOWheel()->getWheelBonusData().spells.druid, spellName, stage);
	}
	if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
		return checkSpellAdditionalDuration(g_game().getIOWheel()->getWheelBonusData().spells.sorcerer, spellName, stage);
	}

	return 0;
}

bool PlayerWheel::handleTwinBurstsCooldown(const std::shared_ptr<Player> &player, const std::string &spellName, int spellCooldown, int rateCooldown) const {
	// Map of spell pairs for Twin Bursts
	static const std::unordered_map<std::string, std::string> spellPairs = {
		{ "Terra Burst", "Ice Burst" },
		{ "Ice Burst", "Terra Burst" }
	};

	auto it = spellPairs.find(spellName);
	if (it != spellPairs.end()) {
		const auto &spell = g_spells().getSpellByName(it->second);
		if (spell) {
			const auto spellId = spell->getSpellId();
			const auto &condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_SPELLCOOLDOWN, spellCooldown / rateCooldown, 0, false, spellId);
			return player->addCondition(condition);
		}
	}

	return false;
}

bool PlayerWheel::handleBeamMasteryCooldown(const std::shared_ptr<Player> &player, const std::string &spellName, int spellCooldown, int rateCooldown) const {
	static const std::unordered_map<std::string, std::string> spellPairs = {
		{ "Great Death Beam", "Great Energy Beam" },
		{ "Great Energy Beam", "Great Death Beam" }
	};

	auto it = spellPairs.find(spellName);
	if (it != spellPairs.end()) {
		const auto &spell = g_spells().getSpellByName(it->second);
		if (spell) {
			const auto spellId = spell->getSpellId();
			const auto &condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_SPELLCOOLDOWN, spellCooldown / rateCooldown, 0, false, spellId);
			return player->addCondition(condition);
		}
	}

	return false;
}

void PlayerWheel::addPromotionScrolls(NetworkMessage &msg) const {
	msg.add<uint16_t>(m_unlockedScrolls.size());
	for (const auto &[itemId, name, extraPoints] : m_unlockedScrolls) {
		msg.add<uint16_t>(itemId);
	}
}

std::shared_ptr<KV> PlayerWheel::gemsKV() const {
	return m_player.kv()->scoped("wheel-of-destiny")->scoped("gems");
}

std::shared_ptr<KV> PlayerWheel::gemsGradeKV(WheelFragmentType_t type, uint8_t pos) const {
	return gemsKV()->scoped(std::string(magic_enum::enum_name(type)))->scoped(std::to_string(pos));
}

uint8_t PlayerWheel::getGemGrade(WheelFragmentType_t type, uint8_t pos) const {
	return type == WheelFragmentType_t::Lesser ? m_basicGrades[pos] : m_supremeGrades[pos];
}

std::vector<PlayerWheelGem> PlayerWheel::getRevealedGems() const {
	std::vector<PlayerWheelGem> unlockedGems;
	const auto unlockedGemUUIDs = gemsKV()->scoped("revealed")->keys();
	if (unlockedGemUUIDs.empty()) {
		return unlockedGems;
	}

	std::vector<std::string> sortedUnlockedGemGUIDs;
	for (const auto &uuid : unlockedGemUUIDs) {
		sortedUnlockedGemGUIDs.emplace_back(uuid);
	}

	std::ranges::sort(sortedUnlockedGemGUIDs, [](const std::string &a, const std::string &b) {
		if (std::ranges::all_of(a, ::isdigit) && std::ranges::all_of(b, ::isdigit)) {
			return std::stoull(a) < std::stoull(b);
		} else {
			return a < b;
		}
	});

	for (const auto &uuid : sortedUnlockedGemGUIDs) {
		auto gem = PlayerWheelGem::load(gemsKV(), uuid);
		if (!gem) {
			continue;
		}
		unlockedGems.emplace_back(gem);
	}
	return unlockedGems;
}

std::vector<PlayerWheelGem> PlayerWheel::getActiveGems() const {
	std::vector<PlayerWheelGem> activeGems;
	for (const auto &affinity : magic_enum::enum_values<WheelGemAffinity_t>()) {
		const auto &gem = m_activeGems[static_cast<uint8_t>(affinity)];

		if (!gem) {
			continue;
		}

		activeGems.emplace_back(gem);
	}
	return activeGems;
}

uint64_t PlayerWheel::getGemRotateCost(WheelGemQuality_t quality) {
	ConfigKey_t key;
	switch (quality) {
		case WheelGemQuality_t::Lesser:
			key = WHEEL_ATELIER_ROTATE_LESSER_COST;
			break;
		case WheelGemQuality_t::Regular:
			key = WHEEL_ATELIER_ROTATE_REGULAR_COST;
			break;
		case WheelGemQuality_t::Greater:
			key = WHEEL_ATELIER_ROTATE_GREATER_COST;
			break;
		default:
			return 0;
	}
	return static_cast<uint64_t>(g_configManager().getNumber(key));
}

uint64_t PlayerWheel::getGemRevealCost(WheelGemQuality_t quality) {
	ConfigKey_t key;
	switch (quality) {
		case WheelGemQuality_t::Lesser:
			key = WHEEL_ATELIER_REVEAL_LESSER_COST;
			break;
		case WheelGemQuality_t::Regular:
			key = WHEEL_ATELIER_REVEAL_REGULAR_COST;
			break;
		case WheelGemQuality_t::Greater:
			key = WHEEL_ATELIER_REVEAL_GREATER_COST;
			break;
		default:
			return 0;
	}
	return static_cast<uint64_t>(g_configManager().getNumber(key));
}

void PlayerWheel::revealGem(WheelGemQuality_t quality) {
	uint16_t gemId = m_player.getVocation()->getWheelGemId(quality);
	if (gemId == 0) {
		g_logger().error("[{}] Failed to get gem id for quality {} and vocation {}", __FUNCTION__, fmt::underlying(quality), m_player.getVocation()->getVocName());
		return;
	}
	if (!m_player.hasItemCountById(gemId, 1, false)) {
		g_logger().error("[{}] Player {} does not have gem with id {}", __FUNCTION__, m_player.getName(), gemId);
		return;
	}
	auto goldCost = getGemRevealCost(quality);
	if (!g_game().removeMoney(m_player.getPlayer(), goldCost, 0, true)) {
		g_logger().error("[{}] Failed to remove {} gold from player with name {}", __FUNCTION__, goldCost, m_player.getName());
		return;
	}
	if (!m_player.removeItemCountById(gemId, 1, false)) {
		g_logger().error("[{}] Failed to remove gem with id {} from player with name {}", __FUNCTION__, gemId, m_player.getName());
		return;
	}
	const auto supremeModifiers = m_player.getVocation()->getSupremeGemModifiers();
	PlayerWheelGem gem;
	gem.uuid = KV::generateUUID();
	gem.locked = false;
	gem.affinity = static_cast<WheelGemAffinity_t>(uniform_random(0, 3));
	gem.quality = quality;
	gem.basicModifier1 = wheelGemBasicSlot1Allowed[uniform_random(0, wheelGemBasicSlot1Allowed.size() - 1)];
	gem.basicModifier2 = {};
	gem.supremeModifier = {};
	if (quality >= WheelGemQuality_t::Regular) {
		gem.basicModifier2 = selectBasicModifier2(gem.basicModifier1);
	}
	if (quality >= WheelGemQuality_t::Greater && !supremeModifiers.empty()) {
		gem.supremeModifier = supremeModifiers[uniform_random(0, supremeModifiers.size() - 1)];
	}
	g_logger().debug("[{}] {}", __FUNCTION__, gem.toString());
	m_revealedGems.emplace_back(gem);

	std::ranges::sort(m_revealedGems, [](const auto &gem1, const auto &gem2) {
		if (std::ranges::all_of(gem1.uuid, ::isdigit) && std::ranges::all_of(gem2.uuid, ::isdigit)) {
			return std::stoull(gem1.uuid) < std::stoull(gem2.uuid);
		} else {
			return gem1.uuid < gem2.uuid;
		}
	});

	sendOpenWheelWindow(m_player.getID());
}

PlayerWheelGem &PlayerWheel::getGem(uint16_t index) {
	auto revealedGemsSize = m_revealedGems.size();
	if (revealedGemsSize <= index) {
		g_logger().error("[{}] Player {} trying to get gem with index {} but has only {} gems", __FUNCTION__, m_player.getName(), index, revealedGemsSize);
		return emptyGem;
	}
	return m_revealedGems[index];
}

PlayerWheelGem &PlayerWheel::getGem(const std::string &uuid) {
	auto it = std::ranges::find_if(m_revealedGems, [&uuid](const auto &gem) {
		return gem.uuid == uuid;
	});

	return it != m_revealedGems.end() ? *it : emptyGem;
}

uint16_t PlayerWheel::getGemIndex(const std::string &uuid) const {
	for (uint16_t i = 0; i < m_revealedGems.size(); ++i) {
		if (m_revealedGems[i].uuid == uuid) {
			return i;
		}
	}
	g_logger().error("[{}] Failed to find gem with uuid {}", __FUNCTION__, uuid);
	return 0xFF;
}

void PlayerWheel::destroyGem(uint16_t index) {
	const auto &gem = getGem(index);
	if (!gem) {
		return;
	}

	if (gem.locked) {
		g_logger().error("[{}] Player {} destroyed locked gem with index {}", std::source_location::current().function_name(), m_player.getName(), index);
		return;
	}

	uint8_t lesserFragments = 0;
	uint8_t greaterFragments = 0;

	switch (gem.quality) {
		case WheelGemQuality_t::Lesser:
			lesserFragments = normal_random(1, 5);
			break;
		case WheelGemQuality_t::Regular:
			lesserFragments = normal_random(2, 10);
			break;
		case WheelGemQuality_t::Greater:
			greaterFragments = normal_random(1, 5);
			break;
	}

	if (lesserFragments > 0) {
		const auto &fragmentsItem = Item::CreateItem(ITEM_LESSER_FRAGMENT, lesserFragments);
		auto returnValue = g_game().internalPlayerAddItem(m_player.getPlayer(), fragmentsItem, false, CONST_SLOT_WHEREEVER);
		if (returnValue != RETURNVALUE_NOERROR) {
			g_logger().error("Failed to add {} lesser fragments to player with name {}", lesserFragments, m_player.getName());
			m_player.sendCancelMessage(getReturnMessage(RETURNVALUE_CONTACTADMINISTRATOR));
			return;
		}
		g_logger().debug("[{}] Player {} destroyed a gem and received {} lesser fragments", std::source_location::current().function_name(), m_player.getName(), lesserFragments);
	}

	if (greaterFragments > 0) {
		const auto &fragmentsItem = Item::CreateItem(ITEM_GREATER_FRAGMENT, greaterFragments);
		auto returnValue = g_game().internalPlayerAddItem(m_player.getPlayer(), fragmentsItem, false, CONST_SLOT_WHEREEVER);
		if (returnValue != RETURNVALUE_NOERROR) {
			g_logger().error("Failed to add {} greater fragments to player with name {}", greaterFragments, m_player.getName());
			m_player.sendCancelMessage(getReturnMessage(RETURNVALUE_CONTACTADMINISTRATOR));
			return;
		}
		g_logger().debug("[{}] Player {} destroyed a gem and received {} greater fragments", std::source_location::current().function_name(), m_player.getName(), greaterFragments);
	}

	m_destroyedGems.emplace_back(gem);
	m_revealedGems.erase(m_revealedGems.begin() + index);

	const auto totalLesserFragment = m_player.getItemTypeCount(ITEM_LESSER_FRAGMENT) + m_player.getStashItemCount(ITEM_LESSER_FRAGMENT);
	const auto totalGreaterFragment = m_player.getItemTypeCount(ITEM_GREATER_FRAGMENT) + m_player.getStashItemCount(ITEM_GREATER_FRAGMENT);

	m_player.client->sendResourceBalance(RESOURCE_LESSER_FRAGMENT, totalLesserFragment);
	m_player.client->sendResourceBalance(RESOURCE_GREATER_FRAGMENT, totalGreaterFragment);

	sendOpenWheelWindow(m_player.getID());
}

void PlayerWheel::switchGemDomain(uint16_t index) {
	auto &gem = getGem(index);
	if (!gem) {
		return;
	}

	if (gem.locked) {
		g_logger().error("[{}] Player {} trying to destroy locked gem with index {}", __FUNCTION__, m_player.getName(), index);
		return;
	}
	auto goldCost = getGemRotateCost(gem.quality);
	if (!g_game().removeMoney(m_player.getPlayer(), goldCost, 0, true)) {
		g_logger().error("[{}] Failed to remove {} gold from player with name {}", __FUNCTION__, goldCost, m_player.getName());
		return;
	}

	auto gemAffinity = convertWheelGemAffinityToDomain(static_cast<uint8_t>(gem.affinity));
	gem.affinity = static_cast<WheelGemAffinity_t>(gemAffinity);
	sendOpenWheelWindow(m_player.getID());
}

void PlayerWheel::toggleGemLock(uint16_t index) {
	auto &gem = getGem(index);
	if (!gem) {
		return;
	}
	gem.locked = !gem.locked;
	sendOpenWheelWindow(m_player.getID());
}

void PlayerWheel::setActiveGem(WheelGemAffinity_t affinity, uint16_t index) {
	auto &gem = getGem(index);
	if (!gem) {
		g_logger().error("[{}] Failed to load gem with index {}", __FUNCTION__, index);
		return;
	}
	if (gem.affinity != affinity) {
		g_logger().error("[{}] Gem with index {} has affinity {} but trying to set it to {}", __FUNCTION__, index, fmt::underlying(gem.affinity), fmt::underlying(affinity));
		return;
	}
	m_activeGems[static_cast<uint8_t>(affinity)] = gem;
}

void PlayerWheel::removeActiveGem(WheelGemAffinity_t affinity) {
	m_activeGems[static_cast<uint8_t>(affinity)] = emptyGem;
}

void PlayerWheel::addRevelationBonus(WheelGemAffinity_t affinity, uint16_t points) {
	m_bonusRevelationPoints[static_cast<size_t>(affinity)] += points;
}

void PlayerWheel::resetRevelationBonus() {
	m_bonusRevelationPoints = { 0, 0, 0, 0 };
}

void PlayerWheel::addSpellBonus(const std::string &spellName, const WheelSpells::Bonus &bonus) {
	if (m_spellsBonuses.contains(spellName)) {
		m_spellsBonuses[spellName].decrease.cooldown += bonus.decrease.cooldown;
		m_spellsBonuses[spellName].decrease.manaCost += bonus.decrease.manaCost;
		m_spellsBonuses[spellName].decrease.secondaryGroupCooldown += bonus.decrease.secondaryGroupCooldown;
		m_spellsBonuses[spellName].increase.aditionalTarget += bonus.increase.aditionalTarget;
		m_spellsBonuses[spellName].increase.area = bonus.increase.area;
		m_spellsBonuses[spellName].increase.criticalChance += bonus.increase.criticalChance;
		m_spellsBonuses[spellName].increase.criticalDamage += bonus.increase.criticalDamage;
		m_spellsBonuses[spellName].increase.damage += bonus.increase.damage;
		m_spellsBonuses[spellName].increase.damageReduction += bonus.increase.damageReduction;
		m_spellsBonuses[spellName].increase.duration += bonus.increase.duration;
		m_spellsBonuses[spellName].increase.heal += bonus.increase.heal;
		m_spellsBonuses[spellName].leech.life += bonus.leech.life;
		m_spellsBonuses[spellName].leech.mana += bonus.leech.mana;
		return;
	}
	m_spellsBonuses[spellName] = bonus;
}

int32_t PlayerWheel::getSpellBonus(const std::string &spellName, WheelSpellBoost_t boost) const {
	using enum WheelSpellBoost_t;

	if (!m_spellsBonuses.contains(spellName)) {
		return 0;
	}
	const auto &[leech, increase, decrease] = m_spellsBonuses.at(spellName);
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

void PlayerWheel::addGems(NetworkMessage &msg) const {
	const auto activeGems = getActiveGems();
	msg.addByte(activeGems.size());
	g_logger().debug("[{}] Player {} has {} active gems", __FUNCTION__, m_player.getName(), activeGems.size());
	for (const auto &gem : activeGems) {
		auto index = getGemIndex(gem.uuid);
		g_logger().debug("[{}] Adding active gem: {} with index {}", __FUNCTION__, gem.toString(), index);
		msg.add<uint16_t>(getGemIndex(gem.uuid));
	}

	msg.add<uint16_t>(m_revealedGems.size());
	uint16_t index = 0;
	for (const auto &gem : m_revealedGems) {
		g_logger().debug("[{}] Adding revealed gem: {}", __FUNCTION__, gem.toString());
		msg.add<uint16_t>(index++);
		msg.addByte(gem.locked);
		msg.addByte(static_cast<uint8_t>(gem.affinity));
		msg.addByte(static_cast<uint8_t>(gem.quality));
		msg.addByte(static_cast<uint8_t>(gem.basicModifier1));
		if (gem.quality >= WheelGemQuality_t::Regular) {
			msg.addByte(static_cast<uint8_t>(gem.basicModifier2));
		}
		if (gem.quality >= WheelGemQuality_t::Greater) {
			msg.addByte(static_cast<uint8_t>(gem.supremeModifier));
		}
	}
}

void PlayerWheel::addGradeModifiers(NetworkMessage &msg) const {
	msg.addByte(0x2E); // Modifiers for all Vocations

	for (const auto &modPosition : modsBasicPosition) {
		const auto pos = static_cast<uint8_t>(modPosition);
		msg.addByte(pos);
		msg.addByte(m_basicGrades[pos]);
	}

	msg.addByte(0x17); // Modifiers for specific per Vocations

	const auto vocationBaseId = m_player.getVocation()->getBaseId();
	const auto modsSupremeIt = modsSupremePositionByVocation.find(vocationBaseId);

	if (modsSupremeIt != modsSupremePositionByVocation.end()) {
		for (const auto &modPosition : modsSupremeIt->second.get()) {
			const auto pos = static_cast<uint8_t>(modPosition);
			msg.addByte(pos);
			msg.addByte(m_supremeGrades[pos]);
		}
	} else {
		g_logger().error("[{}] vocation base id: {}", std::source_location::current().function_name(), m_player.getVocation()->getBaseId());
	}
}

void PlayerWheel::improveGemGrade(WheelFragmentType_t fragmentType, uint8_t pos) {
	uint16_t fragmentId = 0;
	uint32_t value = 0;
	uint8_t quantity = 0;
	uint8_t grade = 0;

	if (fragmentType == WheelFragmentType_t::Lesser) {
		grade = m_basicGrades[pos];
	} else {
		grade = m_supremeGrades[pos];
	}

	++grade;

	switch (fragmentType) {
		case WheelFragmentType_t::Lesser:
			fragmentId = ITEM_LESSER_FRAGMENT;
			std::tie(value, quantity) = getLesserGradeCost(grade);
			break;
		case WheelFragmentType_t::Greater:
			fragmentId = ITEM_GREATER_FRAGMENT;
			std::tie(value, quantity) = getGreaterGradeCost(grade);
			break;
		default:
			g_logger().error("[{}] Invalid Fragment Type: {}", std::source_location::current().function_name(), static_cast<uint8_t>(fragmentType));
			return;
	}

	if (value == 0 && quantity == 0) {
		g_logger().error("[{}] Player {} trying to upgrade gem to grade greater than 3", std::source_location::current().function_name(), m_player.getName());
		return;
	}

	if (!m_player.hasItemCountById(fragmentId, quantity, true)) {
		g_logger().error("[{}] Player {} does not have the required {} fragments with id {}", std::source_location::current().function_name(), m_player.getName(), quantity, fragmentId);
		return;
	}

	if (!g_game().removeMoney(m_player.getPlayer(), value, 0, true)) {
		g_logger().error("[{}] Failed to remove {} gold from player {}", std::source_location::current().function_name(), value, m_player.getName());
		return;
	}

	if (!m_player.removeItemCountById(fragmentId, quantity, true)) {
		g_logger().error("[{}] Failed to remove {} fragments with id {} from player {}", std::source_location::current().function_name(), quantity, fragmentId, m_player.getName());
		return;
	}

	if (fragmentType == WheelFragmentType_t::Lesser) {
		m_basicGrades[pos] = grade;
	} else {
		m_supremeGrades[pos] = grade;
	}

	m_modsMaxGrade += grade == 3 ? 1 : 0;

	loadPlayerBonusData();
	sendOpenWheelWindow(m_player.getID());
}

std::tuple<int, int> PlayerWheel::getLesserGradeCost(uint8_t grade) const {
	switch (grade) {
		case 1:
			return std::make_tuple(2000000, 5);
		case 2:
			return std::make_tuple(5000000, 15);
		case 3:
			return std::make_tuple(30000000, 30);
		default:
			return {};
	}
}

std::tuple<int, int> PlayerWheel::getGreaterGradeCost(uint8_t grade) const {
	switch (grade) {
		case 1:
			return std::make_tuple(5000000, 5);
		case 2:
			return std::make_tuple(12000000, 15);
		case 3:
			return std::make_tuple(75000000, 30);
		default:
			return {};
	}
}

void PlayerWheel::sendOpenWheelWindow(NetworkMessage &msg, uint32_t ownerId) {
	if (m_player.client && m_player.client->oldProtocol) {
		return;
	}

	msg.addByte(0x5F);
	const bool canUse = canOpenWheel();
	msg.add<uint32_t>(ownerId); // Player ID
	msg.addByte(canUse ? 1 : 0); // Can Use
	if (!canUse) {
		return;
	}

	addInitialGems();
	msg.addByte(getOptions(ownerId)); // Options
	msg.addByte(m_player.getPlayerVocationEnum()); // Vocation id

	msg.add<uint16_t>(getWheelPoints(false)); // Points (false param for not send extra points)
	msg.add<uint16_t>(getExtraPoints()); // Extra points
	for (auto slot : magic_enum::enum_values<WheelSlots_t>()) {
		msg.add<uint16_t>(getPointsBySlotType(slot));
	}
	addPromotionScrolls(msg);
	addGems(msg);
	addGradeModifiers(msg);

	const auto &voc = m_player.getVocation();
	if (!voc) {
		g_logger().error("[{}] Failed to get vocation for player {}", __FUNCTION__, m_player.getName());
		return;
	}

	const auto totalLesserFragment = m_player.getItemTypeCount(ITEM_LESSER_FRAGMENT) + m_player.getStashItemCount(ITEM_LESSER_FRAGMENT);
	const auto totalGreaterFragment = m_player.getItemTypeCount(ITEM_GREATER_FRAGMENT) + m_player.getStashItemCount(ITEM_GREATER_FRAGMENT);

	m_player.client->sendResourceBalance(RESOURCE_BANK, m_player.getBankBalance());
	m_player.client->sendResourceBalance(RESOURCE_INVENTORY_MONEY, m_player.getMoney());
	m_player.client->sendResourceBalance(RESOURCE_LESSER_GEMS, m_player.getItemTypeCount(voc->getWheelGemId(WheelGemQuality_t::Lesser)));
	m_player.client->sendResourceBalance(RESOURCE_REGULAR_GEMS, m_player.getItemTypeCount(voc->getWheelGemId(WheelGemQuality_t::Regular)));
	m_player.client->sendResourceBalance(RESOURCE_GREATER_GEMS, m_player.getItemTypeCount(voc->getWheelGemId(WheelGemQuality_t::Greater)));
	m_player.client->sendResourceBalance(RESOURCE_LESSER_FRAGMENT, totalLesserFragment);
	m_player.client->sendResourceBalance(RESOURCE_GREATER_FRAGMENT, totalGreaterFragment);
}

void PlayerWheel::sendGiftOfLifeCooldown() const {
	if (!m_player.client || m_player.client->oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x5E);
	msg.addByte(0x01); // Gift of life ID
	msg.addByte(0x00); // Cooldown ENUM
	msg.add<uint32_t>(getGiftOfCooldown());
	msg.add<uint32_t>(getGiftOfLifeTotalCooldown());
	// Checking if the cooldown if decreasing or it's stopped
	if (m_player.getZoneType() != ZONE_PROTECTION && m_player.hasCondition(CONDITION_INFIGHT)) {
		msg.addByte(0x01);
	} else {
		msg.addByte(0x00);
	}

	m_player.client->writeToOutputBuffer(msg);
}

bool PlayerWheel::checkSavePointsBySlotType(WheelSlots_t slotType, uint16_t points) {
	if (points > 0 && !canPlayerSelectPointOnSlot(slotType, false)) {
		g_logger().debug("[{}] Failed to save points: {}, from slot {}", __FUNCTION__, points, fmt::underlying(slotType));
		return false;
	}

	setPointsBySlotType(static_cast<uint8_t>(slotType), 0);

	const auto unusedPoints = getUnusedPoints();
	if (points > unusedPoints) {
		return false;
	}

	setPointsBySlotType(static_cast<uint8_t>(slotType), points);
	return true;
}

void PlayerWheel::saveSlotPointsHandleRetryErrors(std::vector<SlotInfo> &retryTable, int &errors) {
	std::vector<SlotInfo> temporaryTable;
	for (const auto &data : retryTable) {
		const auto saved = checkSavePointsBySlotType(static_cast<WheelSlots_t>(data.slot), data.points);
		if (saved) {
			errors--;
		} else {
			temporaryTable.emplace_back(data);
		}
	}
	retryTable = temporaryTable;
}

void PlayerWheel::saveSlotPointsOnPressSaveButton(NetworkMessage &msg) {
	if (m_player.client && m_player.client->oldProtocol) {
		return;
	}

	Benchmark bm_saveSlot;

	if (!canOpenWheel()) {
		return;
	}

	// Creates a vector to store slot information in order.
	std::vector<SlotInfo> sortedTable;
	// Iterates over all slots, getting the points for each slot from the message. If the slot points exceed
	for (auto slot : magic_enum::enum_values<WheelSlots_t>()) {
		auto slotPoints = msg.get<uint16_t>(); // Points per Slot
		auto maxPointsPerSlot = getMaxPointsPerSlot(static_cast<WheelSlots_t>(slot));
		if (slotPoints > maxPointsPerSlot) {
			m_player.sendTextMessage(MESSAGE_TRADE, "Something went wrong, try relogging and try again or contact and adminstrator");
			g_logger().error("[{}] possible manipulation of client package using unauthorized program", __FUNCTION__);
			g_logger().warn("Player: {}, error on slot: {}, total points: {}, max points: {}", m_player.getName(), slotPoints, slot, maxPointsPerSlot);
			return;
		}

		const auto order = g_game().getIOWheel()->getSlotPrioritaryOrder(static_cast<WheelSlots_t>(slot));
		if (order == -1) {
			continue;
		}

		// The slot information is then added to the vector in order.
		sortedTable.emplace_back(order, enumToValue(slot), slotPoints);
	}

	// After iterating over all slots, the vector is sorted according to the slot order.
	std::ranges::sort(sortedTable, [](const SlotInfo &a, const SlotInfo &b) {
		return a.order < b.order;
	});

	int errors = 0;
	std::vector<SlotInfo> sortedTableRetry;

	// Processes the vector in the correct order. If it is not possible to save points for a slot,
	for (const auto &data : sortedTable) {
		const auto canSave = checkSavePointsBySlotType(static_cast<WheelSlots_t>(data.slot), data.points);
		if (!canSave) {
			sortedTableRetry.emplace_back(data);
			errors++;
		}
	}

	// The slot data is added to a retry vector and the error counter is incremented.
	if (!sortedTableRetry.empty()) {
		int maxLoop = 0;
		// The function then enters an error loop to handle possible errors in the slot tree
		while (maxLoop <= 5) {
			maxLoop++;
			saveSlotPointsHandleRetryErrors(sortedTableRetry, errors);
		}
	}

	// If there is still data in the retry vector after the error loop, an error message is sent to the player.
	if (!sortedTableRetry.empty()) {
		m_player.sendTextMessage(MESSAGE_TRADE, "Something went wrong, try relogging and try again");
		g_logger().error("[parseSaveWheel] Player '{}' tried to select a slot without the valid requirements", m_player.getName());
	}

	// Gem Vessels
	for (const auto &affinity : magic_enum::enum_values<WheelGemAffinity_t>()) {
		const bool hasGem = msg.getByte();
		if (!hasGem) {
			removeActiveGem(affinity);
			continue;
		}
		const auto gemIndex = msg.get<uint16_t>();
		setActiveGem(affinity, gemIndex);
	}

	// Player's bonus data is loaded, initialized, registered, and the function logs
	loadPlayerBonusData();

	sendOpenWheelWindow(m_player.getID());

	g_logger().debug("Player: {} is saved the all slots info in: {} milliseconds", m_player.getName(), bm_saveSlot.duration());
}

void PlayerWheel::loadActiveGems() {
	for (const auto &affinity : magic_enum::enum_values<WheelGemAffinity_t>()) {
		std::string key(magic_enum::enum_name(affinity));
		auto uuidKV = gemsKV()->scoped("active")->get(key);
		if (!uuidKV.has_value()) {
			continue;
		}

		auto uuid = uuidKV->get<StringType>();
		if (uuid.empty()) {
			continue;
		}

		auto it = std::ranges::find_if(m_revealedGems, [&uuid](const auto &gem) {
			return gem.uuid == uuid;
		});

		if (it == m_revealedGems.end()) {
			continue;
		}

		m_activeGems[static_cast<uint8_t>(affinity)] = *it;
	}
}

void PlayerWheel::saveActiveGems() const {
	for (const auto &affinity : magic_enum::enum_values<WheelGemAffinity_t>()) {
		const std::string key(magic_enum::enum_name(affinity));
		const auto &gem = m_activeGems[static_cast<uint8_t>(affinity)];
		if (gem) {
			gemsKV()->scoped("active")->set(key, gem.uuid);
		} else {
			gemsKV()->scoped("active")->remove(key);
		}
	}
}

void PlayerWheel::loadRevealedGems() {
	const auto unlockedGemUUIDs = gemsKV()->scoped("revealed")->keys();
	if (unlockedGemUUIDs.empty()) {
		return;
	}

	std::vector<std::string> sortedUnlockedGemGUIDs;
	for (const auto &uuid : unlockedGemUUIDs) {
		sortedUnlockedGemGUIDs.emplace_back(uuid);
	}

	std::ranges::sort(sortedUnlockedGemGUIDs, [](const std::string &a, const std::string &b) {
		if (std::ranges::all_of(a, ::isdigit) && std::ranges::all_of(b, ::isdigit)) {
			return std::stoull(a) < std::stoull(b);
		} else {
			return a < b;
		}
	});

	for (const auto &uuid : sortedUnlockedGemGUIDs) {
		auto gem = PlayerWheelGem::load(gemsKV(), uuid);
		if (!gem) {
			continue;
		}
		m_revealedGems.emplace_back(gem);
	}
}

void PlayerWheel::saveRevealedGems() const {
	for (const auto &gem : m_destroyedGems) {
		gem.remove(gemsKV());
	}

	for (const auto &gem : m_revealedGems) {
		gem.save(gemsKV());
	}
}

bool PlayerWheel::scrollAcquired(const std::string &scrollName) {
	auto it = std::ranges::find_if(m_unlockedScrolls, [&scrollName](const PromotionScroll &promotionScroll) {
		return scrollName == promotionScroll.name;
	});

	return it != m_unlockedScrolls.end();
}

bool PlayerWheel::unlockScroll(const std::string &scrollName) {
	if (scrollAcquired(scrollName)) {
		return false;
	}

	auto it = std::ranges::find_if(WheelOfDestinyPromotionScrolls, [&scrollName](const auto &scroll) {
		return scroll.name == scrollName;
	});

	if (it != WheelOfDestinyPromotionScrolls.end()) {
		m_unlockedScrolls.emplace_back(*it);
		return true;
	}

	return false;
}

void PlayerWheel::loadKVScrolls() {
	const auto &scrollKv = m_player.kv()->scoped("wheel-of-destiny")->scoped("scrolls");
	if (!scrollKv) {
		return;
	}

	for (const auto &[itemId, name, extraPoints] : WheelOfDestinyPromotionScrolls) {
		const auto scrollValue = scrollKv->get(name);
		if (scrollValue && scrollValue->get<bool>()) {
			m_unlockedScrolls.emplace_back(itemId, name, extraPoints);
		}
	}
}

void PlayerWheel::saveKVScrolls() const {
	const auto &scrollKv = m_player.kv()->scoped("wheel-of-destiny")->scoped("scrolls");
	if (!scrollKv) {
		return;
	}

	for (const auto &[itemId, name, extraPoints] : m_unlockedScrolls) {
		scrollKv->set(name, true);
	}
}

void PlayerWheel::loadKVModGrades() {
	for (const auto &modPosition : modsBasicPosition) {
		const auto pos = static_cast<uint8_t>(modPosition);
		auto gradeKV = gemsGradeKV(WheelFragmentType_t::Lesser, pos)->get("grade");

		if (gradeKV.has_value()) {
			uint8_t grade = gradeKV->get<IntType>();
			m_basicGrades[pos] = grade;
			m_modsMaxGrade += grade == 3 ? 1 : 0;
		}
	}

	const auto vocationBaseId = m_player.getVocation()->getBaseId();
	const auto modsSupremeIt = modsSupremePositionByVocation.find(vocationBaseId);
	if (modsSupremeIt != modsSupremePositionByVocation.end()) {
		for (const auto &modPosition : modsSupremeIt->second.get()) {
			const auto pos = static_cast<uint8_t>(modPosition);
			auto gradeKV = gemsGradeKV(WheelFragmentType_t::Greater, pos)->get("grade");

			if (gradeKV.has_value()) {
				uint8_t grade = gradeKV->get<IntType>();
				m_supremeGrades[pos] = grade;
				m_modsMaxGrade += grade == 3 ? 1 : 0;
			}
		}
	}
}

void PlayerWheel::saveKVModGrades() const {
	for (const auto &modPosition : modsBasicPosition) {
		const auto pos = static_cast<uint8_t>(modPosition);
		uint8_t grade = m_basicGrades[pos];
		if (grade > 0) {
			gemsGradeKV(WheelFragmentType_t::Lesser, pos)->set("grade", grade);
		}
	}

	const auto vocationBaseId = m_player.getVocation()->getBaseId();
	const auto modsSupremeIt = modsSupremePositionByVocation.find(vocationBaseId);
	if (modsSupremeIt != modsSupremePositionByVocation.end()) {
		for (const auto &modPosition : modsSupremeIt->second.get()) {
			const auto pos = static_cast<uint8_t>(modPosition);
			uint8_t grade = m_supremeGrades[pos];
			if (grade > 0) {
				gemsGradeKV(WheelFragmentType_t::Greater, pos)->set("grade", grade);
			}
		}
	}
}

/*
 * Functions for load and save player database informations
 */
void PlayerWheel::loadDBPlayerSlotPointsOnLogin() {
	auto resultString = fmt::format("SELECT `slot` FROM `player_wheeldata` WHERE `player_id` = {}", m_player.getGUID());
	const DBResult_ptr &result = g_database().storeQuery(resultString);
	// Ignore if player not have nothing inserted in the table
	if (!result) {
		return;
	}

	unsigned long size;
	const auto attribute = result->getStream("slot", size);
	PropStream propStream;
	propStream.init(attribute, size);
	for (size_t i = 0; i < size; i++) {
		uint8_t slot;
		uint16_t points;
		if (propStream.read<uint8_t>(slot) && propStream.read<uint16_t>(points)) {
			setPointsBySlotType(slot, points);
			g_logger().debug("Player: {}, loaded points {} to slot {}", m_player.getName(), points, slot);
		}
	}
}

bool PlayerWheel::saveDBPlayerSlotPointsOnLogout() const {
	DBInsert insertWheelData("INSERT INTO `player_wheeldata` (`player_id`, `slot`) VALUES ");
	insertWheelData.upsert({ "slot" });
	PropWriteStream stream;
	const auto wheelSlots = getSlots();
	for (uint8_t i = 1; i < wheelSlots.size(); ++i) {
		auto value = wheelSlots[i];

		stream.write<uint8_t>(i);
		stream.write<uint16_t>(value);
		g_logger().debug("Player: {}, saved points {} to slot {}", m_player.getName(), value, i);
	}

	size_t attributesSize;
	const char* attributes = stream.getStream(attributesSize);
	if (attributesSize > 0) {
		const auto query = fmt::format("{}, {}", m_player.getGUID(), g_database().escapeBlob(attributes, static_cast<uint32_t>(attributesSize)));
		if (!insertWheelData.addRow(query)) {
			g_logger().debug("[{}] failed to insert row data", __FUNCTION__);
			return false;
		}
	}

	if (!insertWheelData.execute()) {
		g_logger().debug("[{}] failed to execute database insert", __FUNCTION__);
		return false;
	}

	return true;
}

uint16_t PlayerWheel::getExtraPoints() const {
	if (m_player.getLevel() < 51) {
		g_logger().error("Character level must be above 50.");
		return 0;
	}

	uint16_t totalBonus = 0;
	for (const auto &[itemId, name, extraPoints] : m_unlockedScrolls) {
		if (itemId == 0) {
			continue;
		}

		totalBonus += extraPoints;
	}

	return totalBonus;
}

uint16_t PlayerWheel::getWheelPoints(bool includeExtraPoints /* = true*/) const {
	const uint32_t level = m_player.getLevel();
	auto totalPoints = std::max(0u, (level - m_minLevelToStartCountPoints)) * m_pointsPerLevel;

	if (includeExtraPoints) {
		const auto extraPoints = getExtraPoints();
		totalPoints += extraPoints;
	}

	return totalPoints;
}

void PlayerWheel::addInitialGems() {
	auto initialsGems = gemsKV()->get("initialGems");

	if (!initialsGems.has_value()) {
		for (auto gemAffinity : magic_enum::enum_values<WheelGemAffinity_t>()) {
			for (auto gemQuality : magic_enum::enum_values<WheelGemQuality_t>()) {
				if (gemQuality == WheelGemQuality_t::Greater) {
					continue;
				}

				PlayerWheelGem gem;
				gem.uuid = KV::generateUUID();
				gem.locked = false;
				gem.affinity = gemAffinity;
				gem.quality = gemQuality;

				gem.basicModifier1 = wheelGemBasicSlot1Allowed[uniform_random(0, wheelGemBasicSlot1Allowed.size() - 1)];
				gem.basicModifier2 = {};
				gem.supremeModifier = {};
				if (gemQuality >= WheelGemQuality_t::Regular) {
					gem.basicModifier2 = selectBasicModifier2(gem.basicModifier1);
				}
				gem.save(gemsKV());
			}
		}
		gemsKV()->set("initialGems", true);
	}
}

bool PlayerWheel::canOpenWheel() const {
	// Vocation check
	if (m_player.getPlayerVocationEnum() == Vocation_t::VOCATION_NONE) {
		return false;
	}

	// Level check, This is hardcoded on the client, cannot be changed
	if (m_player.getLevel() <= 50) {
		return false;
	}

	if (!m_player.isPremium()) {
		return false;
	}

	if (!m_player.isPromoted()) {
		return false;
	}

	return true;
}

uint8_t PlayerWheel::getOptions(uint32_t ownerId) const {
	// 0: Cannot change points.
	// 1: Can increase and decrease points.
	// 2: Can increase points but cannot decrease id.

	// Validate the owner id
	if (m_player.getID() != ownerId) {
		return 0;
	}

	// Check if is in the temple range (we assume the temple is within the range of 10 sqms)
	if (m_player.getZoneType() == ZONE_PROTECTION) {
		for (const auto &[townid, town] : g_game().map.towns.getTowns()) {
			if (Position::areInRange<1, 10>(town->getTemplePosition(), m_player.getPosition())) {
				return 1;
			}
		}
	}

	return 2;
}

bool PlayerWheel::canSelectSlotFullOrPartial(WheelSlots_t slot) const {
	if (getPointsBySlotType(slot) == getMaxPointsPerSlot(slot)) {
		g_logger().debug("[{}] points on slot {}, max points {}", __FUNCTION__, getPointsBySlotType(slot), getMaxPointsPerSlot(slot));
		return true;
	}
	g_logger().debug("[{}] slot {} is not full", __FUNCTION__, fmt::underlying(slot));
	return false;
}

uint8_t PlayerWheel::getMaxPointsPerSlot(WheelSlots_t slot) const {
	if (slot == WheelSlots_t::SLOT_BLUE_50 || slot == WheelSlots_t::SLOT_RED_50 || slot == WheelSlots_t::SLOT_PURPLE_50 || slot == WheelSlots_t::SLOT_GREEN_50) {
		return 50u;
	}

	if (slot == WheelSlots_t::SLOT_GREEN_TOP_75 || slot == WheelSlots_t::SLOT_GREEN_BOTTOM_75 || slot == WheelSlots_t::SLOT_RED_TOP_75 || slot == WheelSlots_t::SLOT_RED_BOTTOM_75 || slot == WheelSlots_t::SLOT_PURPLE_TOP_75 || slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_75 || slot == WheelSlots_t::SLOT_BLUE_TOP_75 || slot == WheelSlots_t::SLOT_BLUE_BOTTOM_75) {
		return 75u;
	}

	if (slot == WheelSlots_t::SLOT_GREEN_BOTTOM_100 || slot == WheelSlots_t::SLOT_GREEN_MIDDLE_100 || slot == WheelSlots_t::SLOT_GREEN_TOP_100 || slot == WheelSlots_t::SLOT_RED_BOTTOM_100 || slot == WheelSlots_t::SLOT_RED_MIDDLE_100 || slot == WheelSlots_t::SLOT_RED_TOP_100 || slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_100 || slot == WheelSlots_t::SLOT_PURPLE_MIDDLE_100 || slot == WheelSlots_t::SLOT_PURPLE_TOP_100 || slot == WheelSlots_t::SLOT_BLUE_BOTTOM_100 || slot == WheelSlots_t::SLOT_BLUE_MIDDLE_100 || slot == WheelSlots_t::SLOT_BLUE_TOP_100) {
		return 100u;
	}

	if (slot == WheelSlots_t::SLOT_GREEN_TOP_150 || slot == WheelSlots_t::SLOT_GREEN_BOTTOM_150 || slot == WheelSlots_t::SLOT_RED_TOP_150 || slot == WheelSlots_t::SLOT_RED_BOTTOM_150 || slot == WheelSlots_t::SLOT_PURPLE_TOP_150 || slot == WheelSlots_t::SLOT_PURPLE_BOTTOM_150 || slot == WheelSlots_t::SLOT_BLUE_TOP_150 || slot == WheelSlots_t::SLOT_BLUE_BOTTOM_150) {
		return 150u;
	}

	if (slot == WheelSlots_t::SLOT_GREEN_200 || slot == WheelSlots_t::SLOT_RED_200 || slot == WheelSlots_t::SLOT_PURPLE_200 || slot == WheelSlots_t::SLOT_BLUE_200) {
		return 200u;
	}

	g_logger().error("[{}] player: {}, is trying to use unknown slot: {}", __FUNCTION__, m_player.getName(), fmt::underlying(slot));
	return 0u;
}

void PlayerWheel::resetPlayerData() {
	m_playerBonusData = PlayerWheelMethodsBonusData();

	resetUpgradedSpells();
	resetResistance();
	resetStats();
	resetRevelationState();
}

void PlayerWheel::initializePlayerData() {
	if (m_player.client && m_player.client->oldProtocol) {
		return;
	}

	loadPlayerBonusData();
}

void PlayerWheel::setPlayerCombatStats(CombatType_t type, int32_t leechAmount) {
	if (type == COMBAT_LIFEDRAIN) {
		if (leechAmount > 0) {
			addStat(WheelStat_t::LIFE_LEECH, leechAmount);
		} else {
			addStat(WheelStat_t::LIFE_LEECH, 0);
		}
	} else if (type == COMBAT_MANADRAIN) {
		if (leechAmount > 0) {
			addStat(WheelStat_t::MANA_LEECH, leechAmount);
		} else {
			addStat(WheelStat_t::MANA_LEECH, 0);
		}
	}
}

void PlayerWheel::reloadPlayerData() const {
	// Maybe it's not really necessary, but it doesn't hurt to validate
	if (!m_player.getTile()) {
		return;
	}

	m_player.sendSkills();
	m_player.sendStats();
	m_player.sendBasicData();
	sendGiftOfLifeCooldown();
	g_game().reloadCreature(m_player.getPlayer());
}

void PlayerWheel::registerPlayerBonusData() {
	addStat(WheelStat_t::HEALTH, m_playerBonusData.stats.health);
	addStat(WheelStat_t::MANA, m_playerBonusData.stats.mana);
	addStat(WheelStat_t::CAPACITY, m_playerBonusData.stats.capacity);
	addStat(WheelStat_t::MITIGATION, m_playerBonusData.mitigation * 100);
	addStat(WheelStat_t::DAMAGE, m_playerBonusData.stats.damage);
	addStat(WheelStat_t::HEALING, m_playerBonusData.stats.healing);

	// Skills
	addStat(WheelStat_t::MELEE, m_playerBonusData.skills.melee);
	addStat(WheelStat_t::DISTANCE, m_playerBonusData.skills.distance);
	addStat(WheelStat_t::MAGIC, m_playerBonusData.skills.magic);

	// Leech
	setPlayerCombatStats(COMBAT_LIFEDRAIN, m_playerBonusData.leech.lifeLeech * 100);
	setPlayerCombatStats(COMBAT_MANADRAIN, m_playerBonusData.leech.manaLeech * 100);

	// Instant
	setSpellInstant("Battle Instinct", m_playerBonusData.instant.battleInstinct);
	setSpellInstant("Battle Healing", m_playerBonusData.instant.battleHealing);
	setSpellInstant("Positional Tactics", m_playerBonusData.instant.positionalTactics);
	setSpellInstant("Ballistic Mastery", m_playerBonusData.instant.ballisticMastery);
	setSpellInstant("Healing Link", m_playerBonusData.instant.healingLink);
	setSpellInstant("Runic Mastery", m_playerBonusData.instant.runicMastery);
	setSpellInstant("Focus Mastery", m_playerBonusData.instant.focusMastery);

	// Stages (Revelation)
	if (m_playerBonusData.stages.combatMastery > 0) {
		for (int i = 0; i < m_playerBonusData.stages.combatMastery; ++i) {
			setSpellInstant("Combat Mastery", true);
		}
	} else {
		setSpellInstant("Combat Mastery", false);
	}

	if (m_playerBonusData.stages.giftOfLife > 0) {
		for (int i = 0; i < m_playerBonusData.stages.giftOfLife; ++i) {
			setSpellInstant("Gift of Life", true);
		}
	} else {
		setSpellInstant("Gift of Life", false);
	}

	if (m_playerBonusData.stages.blessingOfTheGrove > 0) {
		for (int i = 0; i < m_playerBonusData.stages.blessingOfTheGrove; ++i) {
			setSpellInstant("Blessing of the Grove", true);
		}
	} else {
		setSpellInstant("Blessing of the Grove", false);
	}

	if (m_playerBonusData.stages.divineEmpowerment > 0) {
		for (int i = 0; i < m_playerBonusData.stages.divineEmpowerment; ++i) {
			setSpellInstant("Divine Empowerment", true);
		}
		WheelSpells::Bonus bonus;
		bonus.decrease.cooldown = 4 * 1000;

		if (m_playerBonusData.stages.divineEmpowerment >= 2) {
			addSpellBonus("Divine Empowerment", bonus);
		}
		if (m_playerBonusData.stages.divineEmpowerment >= 3) {
			addSpellBonus("Divine Empowerment", bonus);
		}
	} else {
		setSpellInstant("Divine Empowerment", false);
	}

	if (m_playerBonusData.stages.divineGrenade > 0) {
		for (int i = 0; i < m_playerBonusData.stages.divineGrenade; ++i) {
			setSpellInstant("Divine Grenade", true);
		}
		if (m_playerBonusData.stages.divineGrenade >= 2) {
			WheelSpells::Bonus bonus;
			bonus.decrease.cooldown = 4 * 1000;
			addSpellBonus("Divine Grenade", bonus);
		}
		if (m_playerBonusData.stages.divineGrenade >= 3) {
			WheelSpells::Bonus bonus;
			bonus.decrease.cooldown = 6 * 1000;
			addSpellBonus("Divine Grenade", bonus);
		}
	} else {
		setSpellInstant("Divine Grenade", false);
	}

	if (m_playerBonusData.stages.drainBody > 0) {
		for (int i = 0; i < m_playerBonusData.stages.drainBody; ++i) {
			setSpellInstant("Drain Body", true);
		}
	} else {
		setSpellInstant("Drain Body", false);
	}
	if (m_playerBonusData.stages.beamMastery > 0) {
		m_beamMasterySpells.emplace("Energy Beam");
		m_beamMasterySpells.emplace("Great Death Beam");
		m_beamMasterySpells.emplace("Great Energy Beam");
		for (int i = 0; i < m_playerBonusData.stages.beamMastery; ++i) {
			setSpellInstant("Beam Mastery", true);
		}
		WheelSpells::Bonus deathBeamBonus;
		deathBeamBonus.decrease.cooldown = 2 * 1000;
		deathBeamBonus.increase.damage = 6;
		if (m_playerBonusData.stages.beamMastery >= 2) {
			addSpellBonus("Great Death Beam", deathBeamBonus);
		}
		if (m_playerBonusData.stages.beamMastery >= 3) {
			addSpellBonus("Great Death Beam", deathBeamBonus);
		}
	} else {
		setSpellInstant("Beam Mastery", false);
	}

	if (m_playerBonusData.stages.twinBurst > 0) {
		for (int i = 0; i < m_playerBonusData.stages.twinBurst; ++i) {
			setSpellInstant("Twin Burst", true);
		}
		WheelSpells::Bonus bonus;
		bonus.decrease.cooldown = 4 * 1000;
		bonus.decrease.secondaryGroupCooldown = 4 * 1000;
		if (m_playerBonusData.stages.twinBurst >= 2) {
			addSpellBonus("Ice Burst", bonus);
			addSpellBonus("Terra Burst", bonus);
		}
		if (m_playerBonusData.stages.twinBurst >= 3) {
			addSpellBonus("Ice Burst", bonus);
			addSpellBonus("Terra Burst", bonus);
		}
	} else {
		setSpellInstant("Twin Burst", false);
	}

	if (m_playerBonusData.stages.executionersThrow > 0) {
		for (int i = 0; i < m_playerBonusData.stages.executionersThrow; ++i) {
			setSpellInstant("Executioner's Throw", true);
		}
		WheelSpells::Bonus bonus;
		bonus.decrease.cooldown = 4 * 1000;
		if (m_playerBonusData.stages.executionersThrow >= 2) {
			addSpellBonus("Executioner's Throw", bonus);
		}
		if (m_playerBonusData.stages.executionersThrow >= 3) {
			addSpellBonus("Executioner's Throw", bonus);
		}
	} else {
		setSpellInstant("Executioner's Throw", false);
	}

	// Avatar
	if (m_playerBonusData.avatar.light > 0) {
		for (int i = 0; i < m_playerBonusData.avatar.light; ++i) {
			setSpellInstant("Avatar of Light", true);
		}
		WheelSpells::Bonus bonus;
		bonus.decrease.cooldown = 30 * 60 * 1000; // 30 minutes

		if (m_playerBonusData.avatar.light >= 2) {
			addSpellBonus("Avatar of Light", bonus);
		}
		if (m_playerBonusData.avatar.light >= 3) {
			addSpellBonus("Avatar of Light", bonus);
		}
	} else {
		setSpellInstant("Avatar of Light", false);
	}

	if (m_playerBonusData.avatar.nature > 0) {
		for (int i = 0; i < m_playerBonusData.avatar.nature; ++i) {
			setSpellInstant("Avatar of Nature", true);
		}
		WheelSpells::Bonus bonus;
		bonus.decrease.cooldown = 30 * 60 * 1000; // 30 minutes

		if (m_playerBonusData.avatar.nature >= 2) {
			addSpellBonus("Avatar of Nature", bonus);
		}
		if (m_playerBonusData.avatar.nature >= 3) {
			addSpellBonus("Avatar of Nature", bonus);
		}
	} else {
		setSpellInstant("Avatar of Nature", false);
	}

	if (m_playerBonusData.avatar.steel > 0) {
		for (int i = 0; i < m_playerBonusData.avatar.steel; ++i) {
			setSpellInstant("Avatar of Steel", true);
		}
		WheelSpells::Bonus bonus;
		bonus.decrease.cooldown = 30 * 60 * 1000; // 30 minutes
		if (m_playerBonusData.avatar.steel >= 2) {
			addSpellBonus("Avatar of Steel", bonus);
		}
		if (m_playerBonusData.avatar.steel >= 3) {
			addSpellBonus("Avatar of Steel", bonus);
		}
	} else {
		setSpellInstant("Avatar of Steel", false);
	}

	if (m_playerBonusData.avatar.storm > 0) {
		for (int i = 0; i < m_playerBonusData.avatar.storm; ++i) {
			setSpellInstant("Avatar of Storm", true);
		}
		WheelSpells::Bonus bonus;
		bonus.decrease.cooldown = 30 * 60 * 1000; // 30 minutes
		if (m_playerBonusData.avatar.storm >= 2) {
			addSpellBonus("Avatar of Storm", bonus);
		}
		if (m_playerBonusData.avatar.storm >= 3) {
			addSpellBonus("Avatar of Storm", bonus);
		}
	} else {
		setSpellInstant("Avatar of Storm", false);
	}

	for (const auto &spell : m_playerBonusData.spells) {
		upgradeSpell(spell);
	}

	if (m_player.getHealth() > m_player.getMaxHealth()) {
		m_player.health = std::min<int32_t>(m_player.getMaxHealth(), m_player.healthMax);
		g_game().addCreatureHealth(m_player.getPlayer());
	}

	if (m_player.getMana() > m_player.getMaxMana()) {
		int32_t difference = m_player.getMana() - m_player.getMaxMana();
		m_player.changeMana(-difference);
	}

	onThink(false); // Not forcing the reload
	reloadPlayerData();
}

void PlayerWheel::loadPlayerBonusData() {
	// Check if the player can use the wheel, otherwise we dont need to do unnecessary loops and checks
	if (!canOpenWheel()) {
		return;
	}

	// Reset data to prevent stats from accumulating
	resetPlayerData();
	// Initialize the relevant IOWheel data in the PlayerWheel
	loadDedicationAndConvictionPerks();
	loadRevelationPerks();

	registerPlayerBonusData();

	printPlayerWheelMethodsBonusData(m_playerBonusData);
}

void PlayerWheel::printPlayerWheelMethodsBonusData(const PlayerWheelMethodsBonusData &bonusData) const {
	g_logger().debug("Initializing print of WhelPlayerBonusData informations for player {}", m_player.getName());

	g_logger().debug("Stats:");
	if (bonusData.stats.health > 0) {
		g_logger().debug("  health: {}", bonusData.stats.health);
	}
	if (bonusData.stats.mana > 0) {
		g_logger().debug("  mana: {}", bonusData.stats.mana);
	}
	if (bonusData.stats.capacity > 0) {
		g_logger().debug("  capacity: {}", bonusData.stats.capacity);
	}
	if (bonusData.stats.damage > 0) {
		g_logger().debug("  damage: {}", bonusData.stats.damage);
	}
	if (bonusData.stats.healing > 0) {
		g_logger().debug("  healing: {}", bonusData.stats.healing);
	}

	g_logger().debug("Vessel Resonance:");
	for (size_t i = 0; i < bonusData.unlockedVesselResonances.size(); ++i) {
		const auto count = bonusData.unlockedVesselResonances[i];
		if (count == 0) {
			continue;
		}

		const auto affinity = static_cast<WheelGemAffinity_t>(i);
		std::string affinityName(magic_enum::enum_name(affinity));
		g_logger().debug("  Affinity: {} count: {}", affinityName, bonusData.unlockedVesselResonances[i]);
	}

	g_logger().debug("Skills:");
	if (bonusData.skills.melee > 0) {
		g_logger().debug("  melee: {}", bonusData.skills.melee);
	}
	if (bonusData.skills.distance > 0) {
		g_logger().debug("  distance: {}", bonusData.skills.distance);
	}
	if (bonusData.skills.magic > 0) {
		g_logger().debug("  magic: {}", bonusData.skills.magic);
	}

	g_logger().debug("Leech:");
	if (bonusData.leech.manaLeech > 0) {
		g_logger().debug("  manaLeech: {}", bonusData.leech.manaLeech);
	}
	if (bonusData.leech.lifeLeech > 0) {
		g_logger().debug("  lifeLeech: {}", bonusData.leech.lifeLeech);
	}

	g_logger().debug("Instant:");
	if (bonusData.instant.battleInstinct) {
		g_logger().debug("  battleInstinct: {}", bonusData.instant.battleInstinct);
	}
	if (bonusData.instant.battleHealing) {
		g_logger().debug("  battleHealing: {}", bonusData.instant.battleHealing);
	}
	if (bonusData.instant.positionalTactics) {
		g_logger().debug("  positionalTactics: {}", bonusData.instant.positionalTactics);
	}
	if (bonusData.instant.ballisticMastery) {
		g_logger().debug("  ballisticMastery: {}", bonusData.instant.ballisticMastery);
	}
	if (bonusData.instant.healingLink) {
		g_logger().debug("  healingLink: {}", bonusData.instant.healingLink);
	}
	if (bonusData.instant.runicMastery) {
		g_logger().debug("  runicMastery: {}", bonusData.instant.runicMastery);
	}
	if (bonusData.instant.focusMastery) {
		g_logger().debug("  focusMastery: {}", bonusData.instant.focusMastery);
	}

	g_logger().debug("Stages:");
	if (bonusData.stages.combatMastery > 0) {
		g_logger().debug("  combatMastery: {}", bonusData.stages.combatMastery);
	}
	if (bonusData.stages.giftOfLife > 0) {
		g_logger().debug("  giftOfLife: {}", bonusData.stages.giftOfLife);
	}
	if (bonusData.stages.divineEmpowerment > 0) {
		g_logger().debug("  divineEmpowerment: {}", bonusData.stages.divineEmpowerment);
	}
	if (bonusData.stages.divineGrenade > 0) {
		g_logger().debug("  divineGrenade: {}", bonusData.stages.divineGrenade);
	}
	if (bonusData.stages.blessingOfTheGrove > 0) {
		g_logger().debug("  blessingOfTheGrove: {}", bonusData.stages.blessingOfTheGrove);
	}
	if (bonusData.stages.drainBody > 0) {
		g_logger().debug("  drainBody: {}", bonusData.stages.drainBody);
	}
	if (bonusData.stages.beamMastery > 0) {
		g_logger().debug("  beamMastery: {}", bonusData.stages.beamMastery);
	}
	if (bonusData.stages.twinBurst > 0) {
		g_logger().debug("  twinBurst: {}", bonusData.stages.twinBurst);
	}
	if (bonusData.stages.executionersThrow > 0) {
		g_logger().debug("  executionersThrow: {}", bonusData.stages.executionersThrow);
	}

	g_logger().debug("Avatar:");
	if (bonusData.avatar.light > 0) {
		g_logger().debug("  light: {}", bonusData.avatar.light);
	}
	if (bonusData.avatar.nature > 0) {
		g_logger().debug("  nature: {}", bonusData.avatar.nature);
	}
	if (bonusData.avatar.steel > 0) {
		g_logger().debug("  steel: {}", bonusData.avatar.steel);
	}
	if (bonusData.avatar.storm > 0) {
		g_logger().debug("  storm: {}", bonusData.avatar.storm);
	}

	if (bonusData.momentum > 0) {
		g_logger().debug("bonus: {}", bonusData.momentum);
	}

	if (bonusData.mitigation > 0) {
		g_logger().debug("mitigation: {}", bonusData.mitigation);
	}

	const auto &spellsVector = bonusData.spells;
	if (!spellsVector.empty()) {
		g_logger().debug("Spells:");
		for (const auto &spell : spellsVector) {
			g_logger().debug("  {}", spell);
		}
	}

	g_logger().debug("Print of player data finished!");
}

void PlayerWheel::loadDedicationAndConvictionPerks() {
	using VocationBonusFunction = std::function<void(const std::shared_ptr<Player> &, uint16_t, uint8_t, PlayerWheelMethodsBonusData &)>;
	const auto &wheelFunctions = g_game().getIOWheel()->getWheelMapFunctions();
	const auto vocationCipId = m_player.getPlayerVocationEnum();
	if (vocationCipId < VOCATION_KNIGHT_CIP || vocationCipId > VOCATION_DRUID_CIP) {
		return;
	}

	for (auto slot : magic_enum::enum_values<WheelSlots_t>()) {
		const uint16_t points = getPointsBySlotType(slot);
		if (points > 0) {
			VocationBonusFunction internalData = nullptr;
			auto it = wheelFunctions.find(slot);
			if (it != wheelFunctions.end()) {
				internalData = it->second;
			}
			if (internalData) {
				internalData(m_player.getPlayer(), points, vocationCipId, m_playerBonusData);
			}
		}
	}
}

void PlayerWheel::addSpellToVector(const std::string &spellName) {
	m_playerBonusData.spells.emplace_back(spellName);
}

void PlayerWheel::loadRevelationPerks() {
	processActiveGems();
	applyStageBonuses();
}

void PlayerWheel::resetRevelationState() {
	// First we reset the information
	resetRevelationBonus();
	if (!m_modifierContext) {
		m_modifierContext = std::make_unique<WheelModifierContext>(*this, static_cast<Vocation_t>(m_player.getVocation()->getBaseId()));
	}
	m_modifierContext->resetStrategies();
	m_spellsBonuses.clear();
}

void PlayerWheel::processActiveGems() {
	auto activeGems = getActiveGems();
	std::string playerName = m_player.getName();
	for (const auto &[uuid, locked, affinity, quality, basicModifier1, basicModifier2, supremeModifier] : activeGems) {
		if (uuid.empty()) {
			g_logger().error("[{}] Player {} has an empty gem uuid", __FUNCTION__, playerName);
			continue;
		}

		auto count = m_playerBonusData.unlockedVesselResonances[static_cast<uint8_t>(affinity)];
		if (count >= 1) {
			uint8_t grade = getGemGrade(WheelFragmentType_t::Lesser, static_cast<uint8_t>(basicModifier1));
			std::string modifierName(magic_enum::enum_name(basicModifier1));
			g_logger().debug("[{}] Adding basic modifier 1 {} to player {} from {} gem affinity {}", __FUNCTION__, modifierName, playerName, magic_enum::enum_name(quality), magic_enum::enum_name(affinity));
			m_modifierContext->addStrategies(basicModifier1, grade);
		}
		if (count >= 2 && quality >= WheelGemQuality_t::Regular) {
			uint8_t grade = getGemGrade(WheelFragmentType_t::Lesser, static_cast<uint8_t>(basicModifier2));
			std::string modifierName(magic_enum::enum_name(basicModifier2));
			g_logger().debug("[{}] Adding basic modifier 2 {} to player {} from {} gem affinity {}", __FUNCTION__, modifierName, playerName, magic_enum::enum_name(quality), magic_enum::enum_name(affinity));
			m_modifierContext->addStrategies(basicModifier2, grade);
		}
		if (count >= 3 && quality >= WheelGemQuality_t::Greater) {
			uint8_t grade = getGemGrade(WheelFragmentType_t::Greater, static_cast<uint8_t>(supremeModifier));
			std::string modifierName(magic_enum::enum_name(supremeModifier));
			g_logger().debug("[{}] Adding supreme modifier {} to player {} from {} gem affinity {}", __FUNCTION__, modifierName, playerName, magic_enum::enum_name(quality), magic_enum::enum_name(affinity));
			m_modifierContext->addStrategies(supremeModifier, grade);
		}
	}

	g_logger().debug("[{}] active gems: {} ", __FUNCTION__, activeGems.size());
	m_modifierContext->executeStrategies();
}

void PlayerWheel::applyStageBonuses() {
	applyStageBonusForColor("green");
	applyStageBonusForColor("red");
	applyStageBonusForColor("purple");
	applyStageBonusForColor("blue");
}

void PlayerWheel::applyStageBonusForColor(const std::string &color) {
	WheelStageEnum_t stageEnum = getPlayerSliceStage(color);
	if (stageEnum == WheelStageEnum_t::NONE) {
		return;
	}

	const auto &[statsDamage, statsHealing] = g_game().getIOWheel()->getRevelationStatByStage(stageEnum);
	m_playerBonusData.stats.damage += statsDamage;
	m_playerBonusData.stats.healing += statsHealing;

	auto stageValue = static_cast<uint8_t>(stageEnum);
	auto vocationEnum = static_cast<Vocation_t>(m_player.getPlayerVocationEnum());
	if (color == "green") {
		m_playerBonusData.stages.giftOfLife = stageValue;
	} else if (color == "red") {
		applyRedStageBonus(stageValue, vocationEnum);
	} else if (color == "purple") {
		applyPurpleStageBonus(stageValue, vocationEnum);
	} else if (color == "blue") {
		applyBlueStageBonus(stageValue, vocationEnum);
	}
}

void PlayerWheel::applyRedStageBonus(uint8_t stageValue, Vocation_t vocationEnum) {
	if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
		m_playerBonusData.stages.blessingOfTheGrove = stageValue;
	} else if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
		m_playerBonusData.stages.executionersThrow = stageValue;
		for (uint8_t i = 0; i < stageValue; ++i) {
			addSpellToVector("Executioner's Throw");
		}
	} else if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
		m_playerBonusData.stages.beamMastery = stageValue;
		for (uint8_t i = 0; i < stageValue; ++i) {
			addSpellToVector("Great Death Beam");
		}
	} else if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
		m_playerBonusData.stages.divineGrenade = stageValue;
		for (uint8_t i = 0; i < stageValue; ++i) {
			addSpellToVector("Divine Grenade");
		}
	}
}

void PlayerWheel::applyPurpleStageBonus(uint8_t stageValue, Vocation_t vocationEnum) {
	if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
		m_playerBonusData.avatar.steel = stageValue;
		for (uint8_t i = 0; i < stageValue; ++i) {
			addSpellToVector("Avatar of Steel");
		}
	} else if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
		m_playerBonusData.avatar.light = stageValue;
		for (uint8_t i = 0; i < stageValue; ++i) {
			addSpellToVector("Avatar of Light");
		}
	} else if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
		m_playerBonusData.avatar.nature = stageValue;
		for (uint8_t i = 0; i < stageValue; ++i) {
			addSpellToVector("Avatar of Nature");
		}
	} else if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
		m_playerBonusData.avatar.storm = stageValue;
		for (uint8_t i = 0; i < stageValue; ++i) {
			addSpellToVector("Avatar of Storm");
		}
	}
}

void PlayerWheel::applyBlueStageBonus(uint8_t stageValue, Vocation_t vocationEnum) {
	if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
		m_playerBonusData.stages.combatMastery = stageValue;
	} else if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
		m_playerBonusData.stages.drainBody = stageValue;
		for (uint8_t i = 0; i <= stageValue; ++i) {
			addSpellToVector("Drain_Body_Spells");
		}
	} else if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
		m_playerBonusData.stages.divineEmpowerment = stageValue;
		for (uint8_t i = 0; i <= stageValue; ++i) {
			addSpellToVector("Divine Empowerment");
		}
	} else if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
		m_playerBonusData.stages.twinBurst = stageValue;
		for (uint8_t i = 1; i <= stageValue; ++i) {
			addSpellToVector("Terra Burst");
			addSpellToVector("Ice Burst");
		}
	}
}

WheelStageEnum_t PlayerWheel::getPlayerSliceStage(const std::string &color) const {
	std::vector<WheelSlots_t> slots;
	auto affinity = WheelGemAffinity_t::Green;
	if (color == "green") {
		affinity = WheelGemAffinity_t::Green;
		slots = {
			WheelSlots_t::SLOT_GREEN_50,
			WheelSlots_t::SLOT_GREEN_TOP_75,
			WheelSlots_t::SLOT_GREEN_BOTTOM_75,
			WheelSlots_t::SLOT_GREEN_TOP_100,
			WheelSlots_t::SLOT_GREEN_MIDDLE_100,
			WheelSlots_t::SLOT_GREEN_BOTTOM_100,
			WheelSlots_t::SLOT_GREEN_TOP_150,
			WheelSlots_t::SLOT_GREEN_BOTTOM_150,
			WheelSlots_t::SLOT_GREEN_200
		};
	} else if (color == "red") {
		affinity = WheelGemAffinity_t::Red;
		slots = {
			WheelSlots_t::SLOT_RED_50,
			WheelSlots_t::SLOT_RED_TOP_75,
			WheelSlots_t::SLOT_RED_BOTTOM_75,
			WheelSlots_t::SLOT_RED_TOP_100,
			WheelSlots_t::SLOT_RED_MIDDLE_100,
			WheelSlots_t::SLOT_RED_BOTTOM_100,
			WheelSlots_t::SLOT_RED_TOP_150,
			WheelSlots_t::SLOT_RED_BOTTOM_150,
			WheelSlots_t::SLOT_RED_200
		};
	} else if (color == "purple") {
		affinity = WheelGemAffinity_t::Purple;
		slots = {
			WheelSlots_t::SLOT_PURPLE_50,
			WheelSlots_t::SLOT_PURPLE_TOP_75,
			WheelSlots_t::SLOT_PURPLE_BOTTOM_75,
			WheelSlots_t::SLOT_PURPLE_TOP_100,
			WheelSlots_t::SLOT_PURPLE_MIDDLE_100,
			WheelSlots_t::SLOT_PURPLE_BOTTOM_100,
			WheelSlots_t::SLOT_PURPLE_TOP_150,
			WheelSlots_t::SLOT_PURPLE_BOTTOM_150,
			WheelSlots_t::SLOT_PURPLE_200
		};
	} else if (color == "blue") {
		affinity = WheelGemAffinity_t::Blue;
		slots = {
			WheelSlots_t::SLOT_BLUE_50,
			WheelSlots_t::SLOT_BLUE_TOP_75,
			WheelSlots_t::SLOT_BLUE_BOTTOM_75,
			WheelSlots_t::SLOT_BLUE_TOP_100,
			WheelSlots_t::SLOT_BLUE_MIDDLE_100,
			WheelSlots_t::SLOT_BLUE_BOTTOM_100,
			WheelSlots_t::SLOT_BLUE_TOP_150,
			WheelSlots_t::SLOT_BLUE_BOTTOM_150,
			WheelSlots_t::SLOT_BLUE_200
		};
	} else {
		g_logger().error("[{}] error to wheel player {} color: {}, does not match any check and was ignored", __FUNCTION__, color, m_player.getName());
	}

	int totalPoints = 0;
	for (const auto &slot : slots) {
		totalPoints += getPointsBySlotType(slot);
	}

	auto affinityNumber = static_cast<uint8_t>(affinity);
	if (affinityNumber < m_bonusRevelationPoints.size()) {
		auto bonusRevelationPoints = m_bonusRevelationPoints[affinityNumber];
		if (bonusRevelationPoints > 0) {
			totalPoints += bonusRevelationPoints;
			g_logger().debug("[{}] Player: {}, has affinity: {}, revelation points: {} total points: {}, relations: {}", __FUNCTION__, m_player.getName(), magic_enum::enum_name(affinity), bonusRevelationPoints, totalPoints, m_bonusRevelationPoints.size());
		}
	}

	totalPoints += m_modsMaxGrade;

	if (totalPoints >= static_cast<int>(WheelStagePointsEnum_t::THREE)) {
		return WheelStageEnum_t::THREE;
	}
	if (totalPoints >= static_cast<int>(WheelStagePointsEnum_t::TWO)) {
		return WheelStageEnum_t::TWO;
	}
	if (totalPoints >= static_cast<uint8_t>(WheelStagePointsEnum_t::ONE)) {
		return WheelStageEnum_t::ONE;
	}

	return WheelStageEnum_t::NONE;
}

// Real player methods

void PlayerWheel::checkAbilities() {
	// Wheel of destiny
	bool reloadClient = false;
	if (getInstant("Battle Instinct") && getOnThinkTimer(WheelOnThink_t::BATTLE_INSTINCT) < OTSYS_TIME() && checkBattleInstinct()) {
		reloadClient = true;
	}
	if (getInstant("Positional Tactics") && getOnThinkTimer(WheelOnThink_t::POSITIONAL_TACTICS) < OTSYS_TIME() && checkPositionalTactics()) {
		reloadClient = true;
	}
	if (getInstant("Ballistic Mastery") && getOnThinkTimer(WheelOnThink_t::BALLISTIC_MASTERY) < OTSYS_TIME() && checkBallisticMastery()) {
		reloadClient = true;
	}

	if (reloadClient) {
		m_player.sendSkills();
		m_player.sendStats();
	}
}

bool PlayerWheel::checkBattleInstinct() {
	setOnThinkTimer(WheelOnThink_t::BATTLE_INSTINCT, OTSYS_TIME() + 2000);
	bool updateClient = false;
	m_creaturesNearby = 0;
	uint16_t creaturesNearby = Spectators().find<Monster>(m_player.getPosition(), false, 1, 1, 1, 1, false).excludePlayerMaster().size();
	if (creaturesNearby >= 5) {
		m_creaturesNearby = creaturesNearby;
		creaturesNearby -= 4;
		const uint16_t meleeSkill = 1 * creaturesNearby;
		const uint16_t shieldSkill = 6 * creaturesNearby;
		if (getMajorStat(WheelMajor_t::MELEE) != meleeSkill || getMajorStat(WheelMajor_t::SHIELD) != shieldSkill) {
			setMajorStat(WheelMajor_t::MELEE, meleeSkill);
			setMajorStat(WheelMajor_t::SHIELD, shieldSkill);
			updateClient = true;
		}
	} else if (getMajorStat(WheelMajor_t::MELEE) != 0 || getMajorStat(WheelMajor_t::SHIELD) != 0) {
		setMajorStat(WheelMajor_t::MELEE, 0);
		setMajorStat(WheelMajor_t::SHIELD, 0);
		updateClient = true;
	}

	return updateClient;
}

bool PlayerWheel::checkPositionalTactics() {
	setOnThinkTimer(WheelOnThink_t::POSITIONAL_TACTICS, OTSYS_TIME() + 2000);
	m_creaturesNearby = 0;
	bool updateClient = false;
	uint16_t creaturesNearby = Spectators().find<Monster>(m_player.getPosition(), false, 1, 1, 1, 1, false).excludePlayerMaster().size();
	constexpr uint16_t holyMagicSkill = 3;
	constexpr uint16_t healingMagicSkill = 3;
	constexpr uint16_t distanceSkill = 3;
	if (creaturesNearby == 0) {
		m_creaturesNearby = creaturesNearby;
		if (getMajorStat(WheelMajor_t::DISTANCE) != distanceSkill) {
			setMajorStat(WheelMajor_t::DISTANCE, distanceSkill);
			updateClient = true;
		}
		if (getSpecializedMagic(COMBAT_HOLYDAMAGE) != 0) {
			setSpecializedMagic(COMBAT_HOLYDAMAGE, 0);
			updateClient = true;
		}
		if (getSpecializedMagic(COMBAT_HEALING) != 0) {
			setSpecializedMagic(COMBAT_HEALING, 0);
			updateClient = true;
		}
	} else {
		if (getMajorStat(WheelMajor_t::DISTANCE) != 0) {
			setMajorStat(WheelMajor_t::DISTANCE, 0);
			updateClient = true;
		}
		if (getSpecializedMagic(COMBAT_HOLYDAMAGE) != holyMagicSkill) {
			setSpecializedMagic(COMBAT_HOLYDAMAGE, holyMagicSkill);
			updateClient = true;
		}
		if (getSpecializedMagic(COMBAT_HEALING) != healingMagicSkill) {
			setSpecializedMagic(COMBAT_HEALING, healingMagicSkill);
			updateClient = true;
		}
	}

	return updateClient;
}

bool PlayerWheel::checkBallisticMastery() {
	setOnThinkTimer(WheelOnThink_t::BALLISTIC_MASTERY, OTSYS_TIME() + 2000);
	bool updateClient = false;
	constexpr int32_t newCritical = 1000;
	constexpr uint16_t newHolyBonus = 2; // 2%
	constexpr uint16_t newPhysicalBonus = 2; // 2%

	const auto &item = m_player.getWeapon();
	if (item && item->getAmmoType() == AMMO_BOLT) {
		if (getMajorStat(WheelMajor_t::CRITICAL_DMG) != newCritical) {
			setMajorStat(WheelMajor_t::CRITICAL_DMG, newCritical);
			updateClient = true;
		}
		if (getMajorStat(WheelMajor_t::PHYSICAL_DMG) != 0 || getMajorStat(WheelMajor_t::HOLY_DMG) != 0) {
			setMajorStat(WheelMajor_t::PHYSICAL_DMG, 0);
			setMajorStat(WheelMajor_t::HOLY_DMG, 0);
			updateClient = true;
		}
	} else if (item && item->getAmmoType() == AMMO_ARROW) {
		if (getMajorStat(WheelMajor_t::CRITICAL_DMG) != 0) {
			setMajorStat(WheelMajor_t::CRITICAL_DMG, 0);
			updateClient = true;
		}
		if (getMajorStat(WheelMajor_t::PHYSICAL_DMG) != newPhysicalBonus || getMajorStat(WheelMajor_t::HOLY_DMG) != newHolyBonus) {
			setMajorStat(WheelMajor_t::PHYSICAL_DMG, newPhysicalBonus);
			setMajorStat(WheelMajor_t::HOLY_DMG, newHolyBonus);
			updateClient = true;
		}
	} else {
		if (getMajorStat(WheelMajor_t::CRITICAL_DMG) != 0) {
			setMajorStat(WheelMajor_t::CRITICAL_DMG, 0);
			updateClient = true;
		}
		if (getMajorStat(WheelMajor_t::PHYSICAL_DMG) != 0 || getMajorStat(WheelMajor_t::HOLY_DMG) != 0) {
			setMajorStat(WheelMajor_t::PHYSICAL_DMG, 0);
			setMajorStat(WheelMajor_t::HOLY_DMG, 0);
			updateClient = true;
		}
	}

	return updateClient;
}

bool PlayerWheel::checkCombatMastery() {
	setOnThinkTimer(WheelOnThink_t::COMBAT_MASTERY, OTSYS_TIME() + 2000);
	bool updateClient = false;
	const uint8_t stage = getStage(WheelStage_t::COMBAT_MASTERY);

	const auto &item = m_player.getWeapon();
	if (item && item->getSlotPosition() & SLOTP_TWO_HAND) {
		int32_t criticalSkill = 0;
		if (stage >= 3) {
			criticalSkill = 1200;
		} else if (stage >= 2) {
			criticalSkill = 800;
		} else if (stage >= 1) {
			criticalSkill = 400;
		}

		if (getMajorStat(WheelMajor_t::CRITICAL_DMG_2) != criticalSkill) {
			setMajorStat(WheelMajor_t::CRITICAL_DMG_2, criticalSkill);
			updateClient = true;
		}
		if (getMajorStat(WheelMajor_t::DEFENSE) != 0) {
			setMajorStat(WheelMajor_t::DEFENSE, 0);
			updateClient = true;
		}
	} else {
		if (getMajorStat(WheelMajor_t::CRITICAL_DMG_2) != 0) {
			setMajorStat(WheelMajor_t::CRITICAL_DMG_2, 0);
			updateClient = true;
		}
		if (getMajorStat(WheelMajor_t::DEFENSE) == 0) {
			int32_t shieldSkill = 0;
			if (stage >= 3) {
				shieldSkill = 30;
			} else if (stage >= 2) {
				shieldSkill = 20;
			} else if (stage >= 1) {
				shieldSkill = 10;
			}
			setMajorStat(WheelMajor_t::DEFENSE, shieldSkill);
			updateClient = true;
		}
	}

	return updateClient;
}

bool PlayerWheel::checkDivineEmpowerment() {
	bool updateClient = false;
	setOnThinkTimer(WheelOnThink_t::DIVINE_EMPOWERMENT, OTSYS_TIME() + 1000);

	const auto &tile = m_player.getTile();
	if (!tile) {
		return updateClient;
	}

	const auto &items = tile->getItemList();
	if (!items) {
		return updateClient;
	}

	int32_t damageBonus = 0;
	bool isOwner = false;
	for (const auto &item : *items) {
		if (item->getID() == ITEM_DIVINE_EMPOWERMENT && item->isOwner(m_player.getGUID())) {
			isOwner = true;
			break;
		}
	}

	if (isOwner) {
		const uint8_t stage = getStage(WheelStage_t::DIVINE_EMPOWERMENT);
		if (stage >= 3) {
			damageBonus = 7;
		} else if (stage >= 2) {
			damageBonus = 5;
		} else if (stage >= 1) {
			damageBonus = 3;
		}
	}

	if (damageBonus != getMajorStat(WheelMajor_t::DAMAGE)) {
		setMajorStat(WheelMajor_t::DAMAGE, damageBonus);
		updateClient = true;
	}

	return updateClient;
}

int32_t PlayerWheel::checkDivineGrenade(const std::shared_ptr<Creature> &target) const {
	if (!target || target == m_player.getPlayer()) {
		return 0;
	}

	int32_t damageBonus = 0;
	const uint8_t stage = getStage(WheelStage_t::DIVINE_GRENADE);

	if (stage >= 3) {
		damageBonus = 100;
	} else if (stage >= 2) {
		damageBonus = 60;
	} else if (stage >= 1) {
		damageBonus = 30;
	}

	return damageBonus;
}

void PlayerWheel::checkGiftOfLife() {
	// Healing
	CombatDamage giftDamage;
	giftDamage.primary.value = (m_player.getMaxHealth() * getGiftOfLifeValue()) / 100;
	giftDamage.primary.type = COMBAT_HEALING;
	m_player.sendTextMessage(MESSAGE_EVENT_ADVANCE, "That was close! Fortunately, your were saved by the Gift of Life.");
	g_game().addMagicEffect(m_player.getPosition(), CONST_ME_WATER_DROP);
	g_game().combatChangeHealth(m_player.getPlayer(), m_player.getPlayer(), giftDamage);
	// Condition cooldown reduction
	constexpr uint16_t reductionTimer = 60000;
	reduceAllSpellsCooldownTimer(reductionTimer);

	// Set cooldown
	setGiftOfCooldown(getGiftOfLifeTotalCooldown(), false);
	sendGiftOfLifeCooldown();
}

int32_t PlayerWheel::checkBlessingGroveHealingByTarget(const std::shared_ptr<Creature> &target) const {
	if (!target || target == m_player.getPlayer()) {
		return 0;
	}

	int32_t healingBonus = 0;
	const uint8_t stage = getStage(WheelStage_t::BLESSING_OF_THE_GROVE);
	const int32_t healthPercent = std::round((static_cast<double>(target->getHealth()) * 100) / static_cast<double>(target->getMaxHealth()));
	if (healthPercent <= 30) {
		if (stage >= 3) {
			healingBonus = 24;
		} else if (stage >= 2) {
			healingBonus = 18;
		} else if (stage >= 1) {
			healingBonus = 12;
		}
	} else if (healthPercent <= 60) {
		if (stage >= 3) {
			healingBonus = 12;
		} else if (stage >= 2) {
			healingBonus = 9;
		} else if (stage >= 1) {
			healingBonus = 6;
		}
	}

	return healingBonus;
}

int32_t PlayerWheel::checkTwinBurstByTarget(const std::shared_ptr<Creature> &target) const {
	if (!target || target == m_player.getPlayer()) {
		return 0;
	}

	int32_t damageBonus = 0;
	const uint8_t stage = getStage(WheelStage_t::TWIN_BURST);
	const int32_t healthPercent = std::round((static_cast<double>(target->getHealth()) * 100) / static_cast<double>(target->getMaxHealth()));
	if (healthPercent > 60) {
		if (stage >= 3) {
			damageBonus = 60;
		} else if (stage >= 2) {
			damageBonus = 40;
		} else if (stage >= 1) {
			damageBonus = 20;
		}
	}

	return damageBonus;
}

int32_t PlayerWheel::checkExecutionersThrow(const std::shared_ptr<Creature> &target) const {
	if (!target || target == m_player.getPlayer()) {
		return 0;
	}

	int32_t damageBonus = 0;
	const uint8_t stage = getStage(WheelStage_t::EXECUTIONERS_THROW);
	const int32_t healthPercent = std::round((static_cast<double>(target->getHealth()) * 100) / static_cast<double>(target->getMaxHealth()));
	if (healthPercent <= 30) {
		if (stage >= 3) {
			damageBonus = 150;
		} else if (stage >= 2) {
			damageBonus = 125;
		} else if (stage >= 1) {
			damageBonus = 100;
		}
	}

	return damageBonus;
}

int32_t PlayerWheel::checkBeamMasteryDamage() const {
	int32_t damageBoost = 0;
	const uint8_t stage = getStage(WheelStage_t::BEAM_MASTERY);
	if (stage >= 3) {
		damageBoost = 14;
	} else if (stage >= 2) {
		damageBoost = 12;
	} else if (stage >= 1) {
		damageBoost = 10;
	}

	return damageBoost;
}

int32_t PlayerWheel::checkDrainBodyLeech(const std::shared_ptr<Creature> &target, skills_t skill) const {
	if (!target || !target->getMonster() || target->getWheelOfDestinyDrainBodyDebuff() == 0) {
		return 0;
	}

	const uint8_t stage = target->getWheelOfDestinyDrainBodyDebuff();
	if (target->getBuff(BUFF_DAMAGERECEIVED) > 100 && skill == SKILL_MANA_LEECH_AMOUNT) {
		int32_t manaLeechSkill = 0;
		if (stage >= 3) {
			manaLeechSkill = 400;
		} else if (stage >= 2) {
			manaLeechSkill = 300;
		} else if (stage >= 1) {
			manaLeechSkill = 200;
		}
		return manaLeechSkill;
	}

	if (target->getBuff(BUFF_DAMAGEDEALT) < 100 && skill == SKILL_LIFE_LEECH_AMOUNT) {
		int32_t lifeLeechSkill = 0;
		if (stage >= 3) {
			lifeLeechSkill = 500;
		} else if (stage >= 2) {
			lifeLeechSkill = 400;
		} else if (stage >= 1) {
			lifeLeechSkill = 300;
		}
		return lifeLeechSkill;
	}

	return 0;
}

int32_t PlayerWheel::checkBattleHealingAmount() const {
	double amount = static_cast<double>(m_player.getSkillLevel(SKILL_SHIELD)) * 0.2;
	const uint8_t healthPercent = (m_player.getHealth() * 100) / m_player.getMaxHealth();
	if (healthPercent <= 30) {
		amount *= 3;
	} else if (healthPercent <= 60) {
		amount *= 2;
	}
	return static_cast<int32_t>(amount);
}

int32_t PlayerWheel::checkAvatarSkill(WheelAvatarSkill_t skill) const {
	if (skill == WheelAvatarSkill_t::NONE || (getOnThinkTimer(WheelOnThink_t::AVATAR_SPELL) <= OTSYS_TIME() && getOnThinkTimer(WheelOnThink_t::AVATAR_FORGE) <= OTSYS_TIME())) {
		return 0;
	}

	uint8_t stage = 0;
	if (getOnThinkTimer(WheelOnThink_t::AVATAR_SPELL) > OTSYS_TIME()) {
		if (getInstant("Avatar of Light")) {
			stage = getStage(WheelStage_t::AVATAR_OF_LIGHT);
		} else if (getInstant("Avatar of Steel")) {
			stage = getStage(WheelStage_t::AVATAR_OF_STEEL);
		} else if (getInstant("Avatar of Nature")) {
			stage = getStage(WheelStage_t::AVATAR_OF_NATURE);
		} else if (getInstant("Avatar of Storm")) {
			stage = getStage(WheelStage_t::AVATAR_OF_STORM);
		} else {
			return 0;
		}
	} else {
		stage = 3;
	}

	if (skill == WheelAvatarSkill_t::DAMAGE_REDUCTION) {
		if (stage >= 3) {
			return 15;
		}
		if (stage >= 2) {
			return 10;
		}
		if (stage >= 1) {
			return 5;
		}
	} else if (skill == WheelAvatarSkill_t::CRITICAL_CHANCE) {
		return 10000;
	} else if (skill == WheelAvatarSkill_t::CRITICAL_DAMAGE) {
		if (stage >= 3) {
			return 1500;
		}
		if (stage >= 2) {
			return 1000;
		}
		if (stage >= 1) {
			return 500;
		}
	}

	return 0;
}

int32_t PlayerWheel::checkFocusMasteryDamage() {
	if (getInstant(WheelInstant_t::FOCUS_MASTERY) && getOnThinkTimer(WheelOnThink_t::FOCUS_MASTERY) >= OTSYS_TIME()) {
		setOnThinkTimer(WheelOnThink_t::FOCUS_MASTERY, 0);
		return 35;
	}
	return 0;
}
int32_t PlayerWheel::checkElementSensitiveReduction(CombatType_t type) const {
	int32_t rt = 0;
	if (type == COMBAT_PHYSICALDAMAGE) {
		rt += getMajorStatConditional("Ballistic Mastery", WheelMajor_t::PHYSICAL_DMG);
	} else if (type == COMBAT_HOLYDAMAGE) {
		rt += getMajorStatConditional("Ballistic Mastery", WheelMajor_t::HOLY_DMG);
	}
	return rt;
}

void PlayerWheel::onThink(bool force /* = false*/) {
	bool updateClient = false;
	m_creaturesNearby = 0;
	// Gift of life (Cooldown)
	if (getGiftOfCooldown() > 0 /*getInstant("Gift of Life")*/ && getOnThinkTimer(WheelOnThink_t::GIFT_OF_LIFE) <= OTSYS_TIME()) {
		decreaseGiftOfCooldown(1);
	}
	if (!m_player.hasCondition(CONDITION_INFIGHT) || m_player.getZoneType() == ZONE_PROTECTION || (!getInstant("Battle Instinct") && !getInstant("Positional Tactics") && !getInstant("Ballistic Mastery") && !getInstant("Gift of Life") && !getInstant("Combat Mastery") && !getInstant("Divine Empowerment") && getGiftOfCooldown() == 0)) {
		bool mustReset = false;
		for (int i = 0; i < static_cast<int>(WheelMajor_t::TOTAL_COUNT); i++) {
			if (getMajorStat(static_cast<WheelMajor_t>(i)) != 0) {
				mustReset = true;
				break;
			}
		}

		if (mustReset) {
			for (int i = 0; i < static_cast<int>(WheelMajor_t::TOTAL_COUNT); i++) {
				setMajorStat(static_cast<WheelMajor_t>(i), 0);
			}
			m_player.sendSkills();
			m_player.sendStats();
			g_game().reloadCreature(m_player.getPlayer());
		}
		if (!force) {
			return;
		}
	}
	// Battle Instinct
	if (getInstant("Battle Instinct") && (force || getOnThinkTimer(WheelOnThink_t::BATTLE_INSTINCT) < OTSYS_TIME()) && checkBattleInstinct()) {
		updateClient = true;
	}
	// Positional Tactics
	if (getInstant("Positional Tactics") && (force || getOnThinkTimer(WheelOnThink_t::POSITIONAL_TACTICS) < OTSYS_TIME()) && checkPositionalTactics()) {
		updateClient = true;
	}
	// Ballistic Mastery
	if (getInstant("Ballistic Mastery") && (force || getOnThinkTimer(WheelOnThink_t::BALLISTIC_MASTERY) < OTSYS_TIME()) && checkBallisticMastery()) {
		updateClient = true;
	}
	// Combat Mastery
	if (getInstant("Combat Mastery") && (force || getOnThinkTimer(WheelOnThink_t::COMBAT_MASTERY) < OTSYS_TIME()) && checkCombatMastery()) {
		updateClient = true;
	}
	// Divine Empowerment
	if (getInstant("Divine Empowerment") && (force || getOnThinkTimer(WheelOnThink_t::DIVINE_EMPOWERMENT) < OTSYS_TIME()) && checkDivineEmpowerment()) {
		updateClient = true;
	}
	if (updateClient) {
		m_player.sendSkills();
		m_player.sendStats();
	}
}

void PlayerWheel::reduceAllSpellsCooldownTimer(int32_t value) const {
	for (const auto &condition : m_player.getConditionsByType(CONDITION_SPELLCOOLDOWN)) {
		const auto spellId = condition->getSubId();
		const auto &spell = g_spells().getInstantSpellById(spellId);
		if (!spell) {
			continue;
		}

		const auto spellSecondaryGroup = spell->getSecondaryGroup();
		const auto &secondCondition = m_player.getCondition(CONDITION_SPELLGROUPCOOLDOWN, CONDITIONID_DEFAULT, spellSecondaryGroup);

		if (secondCondition) {
			if (secondCondition->getTicks() <= value) {
				m_player.sendSpellGroupCooldown(spellSecondaryGroup, 0);
				secondCondition->endCondition(m_player.getPlayer());
			} else {
				secondCondition->setTicks(secondCondition->getTicks() - value);
				m_player.sendSpellGroupCooldown(spellSecondaryGroup, secondCondition->getTicks());
			}
		}

		if (condition) {
			if (condition->getTicks() <= value) {
				m_player.sendSpellCooldown(spellId, 0);
				condition->endCondition(m_player.getPlayer());
			} else {
				condition->setTicks(condition->getTicks() - value);
				m_player.sendSpellCooldown(spellId, condition->getTicks());
			}
		}
	}
}

void PlayerWheel::resetUpgradedSpells() {
	for (const auto &spell : m_learnedSpellsSelected) {
		if (m_player.hasLearnedInstantSpell(spell)) {
			m_player.forgetInstantSpell(spell);
		}
	}
	m_creaturesNearby = 0;
	m_spellsSelected.clear();
	m_learnedSpellsSelected.clear();
	m_beamMasterySpells.clear();
	for (int i = 0; i < static_cast<int>(WheelMajor_t::TOTAL_COUNT); i++) {
		setMajorStat(static_cast<WheelMajor_t>(i), 0);
	}
	for (int i = 0; i < static_cast<int>(WheelStage_t::STAGE_COUNT); i++) {
		setStage(static_cast<WheelStage_t>(i), 0);
	}
	setOnThinkTimer(WheelOnThink_t::FOCUS_MASTERY, 0);
}

void PlayerWheel::upgradeSpell(const std::string &name) {
	if (!m_player.hasLearnedInstantSpell(name)) {
		m_learnedSpellsSelected.emplace_back(name);
		m_player.learnInstantSpell(name);
	}
	if (m_spellsSelected[name] == WheelSpellGrade_t::NONE) {
		m_spellsSelected[name] = WheelSpellGrade_t::REGULAR;
	} else if (m_spellsSelected[name] == WheelSpellGrade_t::REGULAR) {
		m_spellsSelected[name] = WheelSpellGrade_t::UPGRADED;
	} else if (m_spellsSelected[name] == WheelSpellGrade_t::UPGRADED) {
		m_spellsSelected[name] = WheelSpellGrade_t::MAX;
	}
}

void PlayerWheel::downgradeSpell(const std::string &name) {
	if (m_spellsSelected[name] == WheelSpellGrade_t::NONE || m_spellsSelected[name] == WheelSpellGrade_t::REGULAR) {
		m_spellsSelected.erase(name);
	} else if (m_spellsSelected[name] == WheelSpellGrade_t::UPGRADED) {
		m_spellsSelected[name] = WheelSpellGrade_t::REGULAR;
	} else if (m_spellsSelected[name] == WheelSpellGrade_t::MAX) {
		m_spellsSelected[name] = WheelSpellGrade_t::UPGRADED;
	}
}

std::shared_ptr<Spell> PlayerWheel::getCombatDataSpell(CombatDamage &damage) {
	std::shared_ptr<Spell> spell = nullptr;
	auto spellGrade = WheelSpellGrade_t::NONE;
	if (!(damage.instantSpellName).empty()) {
		spellGrade = getSpellUpgrade(damage.instantSpellName);
		spell = g_spells().getInstantSpellByName(damage.instantSpellName);
	} else if (!(damage.runeSpellName).empty()) {
		spell = g_spells().getRuneSpellByName(damage.runeSpellName);
	}
	if (spell) {
		const auto &spellName = spell->getName();

		damage.damageMultiplier += checkFocusMasteryDamage();
		if (getHealingLinkUpgrade(spellName)) {
			damage.healingLink += 10;
		}
		if (spell->getSecondaryGroup() == SPELLGROUP_FOCUS && getInstant("Focus Mastery")) {
			setOnThinkTimer(WheelOnThink_t::FOCUS_MASTERY, (OTSYS_TIME() + 12000));
		}

		if (spell->getWheelOfDestinyUpgraded()) {
			damage.criticalDamage += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::CRITICAL_DAMAGE, spellGrade) * 100;
			damage.criticalChance += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::CRITICAL_CHANCE, spellGrade);
			damage.damageMultiplier += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::DAMAGE, spellGrade);
			damage.damageReductionMultiplier += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::DAMAGE_REDUCTION, spellGrade);
			damage.healingMultiplier += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::HEAL, spellGrade);
			damage.manaLeech += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::MANA_LEECH, spellGrade);
			damage.manaLeechChance += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::MANA_LEECH_CHANCE, spellGrade);
			damage.lifeLeech += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::LIFE_LEECH, spellGrade);
			damage.lifeLeechChance += spell->getWheelOfDestinyBoost(WheelSpellBoost_t::LIFE_LEECH_CHANCE, spellGrade);
		}

		damage.criticalDamage += (getSpellBonus(spellName, WheelSpellBoost_t::CRITICAL_DAMAGE) * 100);
		damage.criticalChance += getSpellBonus(spellName, WheelSpellBoost_t::CRITICAL_CHANCE);
		damage.damageMultiplier += getSpellBonus(spellName, WheelSpellBoost_t::DAMAGE);
		damage.damageReductionMultiplier += getSpellBonus(spellName, WheelSpellBoost_t::DAMAGE_REDUCTION);
		damage.healingMultiplier += getSpellBonus(spellName, WheelSpellBoost_t::HEAL);
		damage.manaLeech += getSpellBonus(spellName, WheelSpellBoost_t::MANA_LEECH);
		damage.manaLeechChance += getSpellBonus(spellName, WheelSpellBoost_t::MANA_LEECH_CHANCE);
		damage.lifeLeech += getSpellBonus(spellName, WheelSpellBoost_t::LIFE_LEECH);
		damage.lifeLeechChance += getSpellBonus(spellName, WheelSpellBoost_t::LIFE_LEECH_CHANCE);
	}

	return spell;
}

// Wheel of destiny - setSpellInstant helpers
void PlayerWheel::setStage(WheelStage_t type, uint8_t value) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_stages.at(enumValue) = value;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
}

void PlayerWheel::setOnThinkTimer(WheelOnThink_t type, int64_t time) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_onThink.at(enumValue) = time;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range, value {}. Error message: {}", __FUNCTION__, enumValue, time, e.what());
	}
}

void PlayerWheel::setMajorStat(WheelMajor_t type, int32_t value) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_majorStats.at(enumValue) = value;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range, value {}. Error message: {}", __FUNCTION__, enumValue, value, e.what());
	}
}

void PlayerWheel::setSpecializedMagic(CombatType_t type, int32_t value) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_specializedMagic.at(enumValue) = value;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range, value {}. Error message: {}", __FUNCTION__, enumValue, value, e.what());
	}
}

void PlayerWheel::setInstant(WheelInstant_t type, bool toggle) {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		m_instant.at(enumValue) = toggle;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
}

void PlayerWheel::addStat(WheelStat_t type, int32_t value) {
	auto enumValue = static_cast<uint8_t>(type);
	if (enumValue >= static_cast<uint8_t>(WheelStat_t::TOTAL_COUNT)) {
		g_logger().error("[{}]. Type {} is out of range, value {}. Error message: {}", __FUNCTION__, enumValue, value, "Enum value is out of range");
		return;
	}
	m_stats[enumValue] += value;
}

void PlayerWheel::addResistance(CombatType_t type, int32_t value) {
	auto index = combatTypeToIndex(type);
	if (index >= static_cast<uint8_t>(WheelStat_t::TOTAL_COUNT)) {
		g_logger().error("[{}]. Type {} is out of range, value {}. Error message: {}", __FUNCTION__, index, value, "Enum value is out of range");
		return;
	}
	m_resistance[index] += value;
}

void PlayerWheel::setSpellInstant(const std::string &name, bool value) {
	if (name == "Battle Instinct") {
		setInstant(WheelInstant_t::BATTLE_INSTINCT, value);
		if (!getInstant(WheelInstant_t::BATTLE_INSTINCT)) {
			setMajorStat(WheelMajor_t::SHIELD, 0);
			setMajorStat(WheelMajor_t::MELEE, 0);
		}
	} else if (name == "Battle Healing") {
		setInstant(WheelInstant_t::BATTLE_HEALING, value);
	} else if (name == "Positional Tactics") {
		setInstant(WheelInstant_t::POSITIONAL_TACTICS, value);
		if (!getInstant(WheelInstant_t::POSITIONAL_TACTICS)) {
			setMajorStat(WheelMajor_t::MAGIC, 0);
			setMajorStat(WheelMajor_t::HOLY_RESISTANCE, 0);
		}
	} else if (name == "Ballistic Mastery") {
		setInstant(WheelInstant_t::BALLISTIC_MASTERY, value);
		if (!getInstant(WheelInstant_t::BALLISTIC_MASTERY)) {
			setMajorStat(WheelMajor_t::CRITICAL_DMG, 0);
			setMajorStat(WheelMajor_t::PHYSICAL_DMG, 0);
			setMajorStat(WheelMajor_t::HOLY_DMG, 0);
		}
	} else if (name == "Healing Link") {
		setInstant(WheelInstant_t::HEALING_LINK, value);
	} else if (name == "Runic Mastery") {
		setInstant(WheelInstant_t::RUNIC_MASTERY, value);
	} else if (name == "Focus Mastery") {
		setInstant(WheelInstant_t::FOCUS_MASTERY, value);
		if (!getInstant(WheelInstant_t::FOCUS_MASTERY)) {
			setOnThinkTimer(WheelOnThink_t::FOCUS_MASTERY, 0);
		}
	} else if (name == "Beam Mastery") {
		if (value) {
			setStage(WheelStage_t::BEAM_MASTERY, getStage(WheelStage_t::BEAM_MASTERY) + 1);
		} else {
			setStage(WheelStage_t::BEAM_MASTERY, 0);
		}
	} else if (name == "Combat Mastery") {
		if (value) {
			setStage(WheelStage_t::COMBAT_MASTERY, getStage(WheelStage_t::COMBAT_MASTERY) + 1);
		} else {
			setStage(WheelStage_t::COMBAT_MASTERY, 0);
		}
	} else if (name == "Gift of Life") {
		if (value) {
			setStage(WheelStage_t::GIFT_OF_LIFE, getStage(WheelStage_t::GIFT_OF_LIFE) + 1);
		} else {
			setStage(WheelStage_t::GIFT_OF_LIFE, 0);
		}
	} else if (name == "Blessing of the Grove") {
		if (value) {
			setStage(WheelStage_t::BLESSING_OF_THE_GROVE, getStage(WheelStage_t::BLESSING_OF_THE_GROVE) + 1);
		} else {
			setStage(WheelStage_t::BLESSING_OF_THE_GROVE, 0);
		}
	} else if (name == "Drain Body") {
		if (value) {
			setStage(WheelStage_t::DRAIN_BODY, getStage(WheelStage_t::DRAIN_BODY) + 1);
		} else {
			setStage(WheelStage_t::DRAIN_BODY, 0);
		}
	} else if (name == "Divine Empowerment") {
		if (value) {
			setStage(WheelStage_t::DIVINE_EMPOWERMENT, getStage(WheelStage_t::DIVINE_EMPOWERMENT) + 1);
		} else {
			setStage(WheelStage_t::DIVINE_EMPOWERMENT, 0);
		}
	} else if (name == "Divine Grenade") {
		if (value) {
			setStage(WheelStage_t::DIVINE_GRENADE, getStage(WheelStage_t::DIVINE_GRENADE) + 1);
		} else {
			setStage(WheelStage_t::DIVINE_GRENADE, 0);
		}
	} else if (name == "Twin Burst") {
		if (value) {
			setStage(WheelStage_t::TWIN_BURST, getStage(WheelStage_t::TWIN_BURST) + 1);
		} else {
			setStage(WheelStage_t::TWIN_BURST, 0);
		}
	} else if (name == "Executioner's Throw") {
		if (value) {
			setStage(WheelStage_t::EXECUTIONERS_THROW, getStage(WheelStage_t::EXECUTIONERS_THROW) + 1);
		} else {
			setStage(WheelStage_t::EXECUTIONERS_THROW, 0);
		}
	} else if (name == "Avatar of Light") {
		if (value) {
			setStage(WheelStage_t::AVATAR_OF_LIGHT, getStage(WheelStage_t::AVATAR_OF_LIGHT) + 1);
		} else {
			setStage(WheelStage_t::AVATAR_OF_LIGHT, 0);
		}
	} else if (name == "Avatar of Nature") {
		if (value) {
			setStage(WheelStage_t::AVATAR_OF_NATURE, getStage(WheelStage_t::AVATAR_OF_NATURE) + 1);
		} else {
			setStage(WheelStage_t::AVATAR_OF_NATURE, 0);
		}
	} else if (name == "Avatar of Steel") {
		if (value) {
			setStage(WheelStage_t::AVATAR_OF_STEEL, getStage(WheelStage_t::AVATAR_OF_STEEL) + 1);
		} else {
			setStage(WheelStage_t::AVATAR_OF_STEEL, 0);
		}
	} else if (name == "Avatar of Storm") {
		if (value) {
			setStage(WheelStage_t::AVATAR_OF_STORM, getStage(WheelStage_t::AVATAR_OF_STORM) + 1);
		} else {
			setStage(WheelStage_t::AVATAR_OF_STORM, 0);
		}
	}
}

void PlayerWheel::resetResistance() {
	for (int32_t i = 0; i < COMBAT_COUNT; i++) {
		m_resistance[i] = 0;
	}
}

void PlayerWheel::resetStats() {
	for (int32_t i = 0; i < static_cast<int>(WheelStat_t::TOTAL_COUNT); i++) {
		m_stats[i] = 0;
	}
}

// Wheel of destiny - Header get:
bool PlayerWheel::getInstant(WheelInstant_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_instant.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return false;
}

uint8_t PlayerWheel::getStage(std::string_view name) const {
	using enum WheelInstant_t;
	using enum WheelStage_t;

	static const std::unordered_map<std::string_view, WheelInstant_t> instantMapping = {
		{ "Battle Instinct", BATTLE_INSTINCT },
		{ "Battle Healing", BATTLE_HEALING },
		{ "Positional Tatics", POSITIONAL_TACTICS },
		{ "Ballistic Mastery", BALLISTIC_MASTERY },
		{ "Healing Link", HEALING_LINK },
		{ "Runic Mastery", RUNIC_MASTERY },
		{ "Focus Mastery", FOCUS_MASTERY }
	};

	static const std::unordered_map<std::string_view, WheelStage_t> stageMapping = {
		{ "Beam Mastery", BEAM_MASTERY },
		{ "Combat Mastery", COMBAT_MASTERY },
		{ "Gift of Life", GIFT_OF_LIFE },
		{ "Blessing of the Grove", BLESSING_OF_THE_GROVE },
		{ "Drain Body", DRAIN_BODY },
		{ "Divine Empowerment", DIVINE_EMPOWERMENT },
		{ "Divine Grenade", DIVINE_GRENADE },
		{ "Twin Burst", TWIN_BURST },
		{ "Executioner's Throw", EXECUTIONERS_THROW },
		{ "Avatar of Light", AVATAR_OF_LIGHT },
		{ "Avatar of Nature", AVATAR_OF_NATURE },
		{ "Avatar of Steel", AVATAR_OF_STEEL },
		{ "Avatar of Storm", AVATAR_OF_STORM }
	};

	if (auto it = instantMapping.find(name); it != instantMapping.end()) {
		return PlayerWheel::getInstant(it->second);
	}
	if (auto it = stageMapping.find(name); it != stageMapping.end()) {
		return PlayerWheel::getStage(it->second);
	}

	return false;
}

uint8_t PlayerWheel::getStage(WheelStage_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_stages.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return 0;
}

int32_t PlayerWheel::getMajorStat(WheelMajor_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_majorStats.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return 0;
}

int32_t PlayerWheel::getSpecializedMagic(CombatType_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_specializedMagic.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return 0;
}

int32_t PlayerWheel::getStat(WheelStat_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_stats.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, enumValue, e.what());
	}
	return 0;
}

int32_t PlayerWheel::getResistance(CombatType_t type) const {
	auto index = combatTypeToIndex(type);
	try {
		return m_resistance.at(index);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Instant type {}. Error message: {}", __FUNCTION__, index, e.what());
	}
	return 0;
}

WheelSpellGrade_t PlayerWheel::getSpellUpgrade(const std::string &name) const {
	for (const auto &[name_it, grade_it] : m_spellsSelected) {
		if (name_it == name) {
			return grade_it;
		}
	}
	return WheelSpellGrade_t::NONE;
}

double PlayerWheel::getMitigationMultiplier() const {
	return static_cast<double>(getStat(WheelStat_t::MITIGATION)) / 100.;
}

bool PlayerWheel::getHealingLinkUpgrade(const std::string &spell) const {
	if (!getInstant("Healing Link")) {
		return false;
	}
	if (spell == "Nature's Embrace" || spell == "Heal Friend") {
		return true;
	}
	return false;
}

int32_t PlayerWheel::getMajorStatConditional(const std::string &instant, WheelMajor_t major) const {
	return PlayerWheel::getInstant(instant) ? PlayerWheel::getMajorStat(major) : 0;
}

int64_t PlayerWheel::getOnThinkTimer(WheelOnThink_t type) const {
	auto enumValue = static_cast<uint8_t>(type);
	try {
		return m_onThink.at(enumValue);
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Type {} is out of range. Error message: {}", __FUNCTION__, enumValue, e.what());
	}

	return 0;
}

bool PlayerWheel::getInstant(std::string_view name) const {
	using enum WheelInstant_t;
	using enum WheelStage_t;

	static const std::unordered_map<std::string_view, WheelInstant_t> instantMapping = {
		{ "Battle Instinct", BATTLE_INSTINCT },
		{ "Battle Healing", BATTLE_HEALING },
		{ "Positional Tactics", POSITIONAL_TACTICS },
		{ "Ballistic Mastery", BALLISTIC_MASTERY },
		{ "Healing Link", HEALING_LINK },
		{ "Runic Mastery", RUNIC_MASTERY },
		{ "Focus Mastery", FOCUS_MASTERY }
	};

	static const std::unordered_map<std::string_view, WheelStage_t> stageMapping = {
		{ "Beam Mastery", BEAM_MASTERY },
		{ "Combat Mastery", COMBAT_MASTERY },
		{ "Gift of Life", GIFT_OF_LIFE },
		{ "Blessing of the Grove", BLESSING_OF_THE_GROVE },
		{ "Drain Body", DRAIN_BODY },
		{ "Divine Empowerment", DIVINE_EMPOWERMENT },
		{ "Divine Grenade", DIVINE_GRENADE },
		{ "Twin Burst", TWIN_BURST },
		{ "Executioner's Throw", EXECUTIONERS_THROW },
		{ "Avatar of Light", AVATAR_OF_LIGHT },
		{ "Avatar of Nature", AVATAR_OF_NATURE },
		{ "Avatar of Steel", AVATAR_OF_STEEL },
		{ "Avatar of Storm", AVATAR_OF_STORM }
	};

	if (auto it = instantMapping.find(name); it != instantMapping.end()) {
		return PlayerWheel::getInstant(it->second);
	}
	if (auto it = stageMapping.find(name); it != stageMapping.end()) {
		return PlayerWheel::getStage(it->second);
	}

	return false;
}

// Wheel of destiny - Specific functions
uint32_t PlayerWheel::getGiftOfLifeTotalCooldown() const {
	if (getStage(WheelStage_t::GIFT_OF_LIFE) == 1) {
		return 1 * 60 * 60 * 30;
	}
	if (getStage(WheelStage_t::GIFT_OF_LIFE) == 2) {
		return 1 * 60 * 60 * 20;
	}
	if (getStage(WheelStage_t::GIFT_OF_LIFE) == 3) {
		return 1 * 60 * 60 * 10;
	}
	return 0;
}

uint8_t PlayerWheel::getGiftOfLifeValue() const {
	if (getStage(WheelStage_t::GIFT_OF_LIFE) == 1) {
		return 20;
	}
	if (getStage(WheelStage_t::GIFT_OF_LIFE) == 2) {
		return 25;
	}
	if (getStage(WheelStage_t::GIFT_OF_LIFE) == 3) {
		return 30;
	}

	return 0;
}

int32_t PlayerWheel::getGiftOfCooldown() const {
	const int32_t value = m_player.getStorageValue(STORAGEVALUE_GIFT_OF_LIFE_COOLDOWN_WOD);
	if (value <= 0) {
		return 0;
	}
	return value;
}

void PlayerWheel::setGiftOfCooldown(int32_t value, bool isOnThink) {
	m_player.addStorageValue(STORAGEVALUE_GIFT_OF_LIFE_COOLDOWN_WOD, value, true);
	if (!isOnThink) {
		setOnThinkTimer(WheelOnThink_t::GIFT_OF_LIFE, OTSYS_TIME() + 1000);
	}
}

void PlayerWheel::decreaseGiftOfCooldown(int32_t value) {
	const int32_t cooldown = getGiftOfCooldown() - value;
	if (cooldown <= 0) {
		setOnThinkTimer(WheelOnThink_t::GIFT_OF_LIFE, OTSYS_TIME() + 3600000);
		return;
	}
	setOnThinkTimer(WheelOnThink_t::GIFT_OF_LIFE, OTSYS_TIME() + (value * 1000));
	setGiftOfCooldown(cooldown, true);
}

void PlayerWheel::sendOpenWheelWindow(uint32_t ownerId) const {
	if (m_player.client) {
		m_player.client->sendOpenWheelWindow(ownerId);
	}
}

uint16_t PlayerWheel::getPointsBySlotType(WheelSlots_t slotType) const {
	try {
		return m_wheelSlots.at(static_cast<std::size_t>(slotType));
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Index {} is out of range, invalid slot type. Error message: {}", __FUNCTION__, slotType, e.what());
		return 0;
	}
}

const std::array<uint16_t, 37> &PlayerWheel::getSlots() const {
	return m_wheelSlots;
}

void PlayerWheel::setPointsBySlotType(uint8_t slotType, uint16_t points) {
	try {
		m_wheelSlots.at(slotType) = points;
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}]. Index {} is out of range, invalid slot type. Error message: {}", __FUNCTION__, slotType, e.what());
	}
}

const PlayerWheelMethodsBonusData &PlayerWheel::getBonusData() const {
	return m_playerBonusData;
}

PlayerWheelMethodsBonusData &PlayerWheel::getBonusData() {
	return m_playerBonusData;
}

void PlayerWheel::setWheelBonusData(const PlayerWheelMethodsBonusData &newBonusData) {
	m_playerBonusData = newBonusData;
}

// Functions used to Manage Combat
uint8_t PlayerWheel::getBeamAffectedTotal(const CombatDamage &tmpDamage) const {
	uint8_t beamAffectedTotal = 0; // Removed const
	if (m_beamMasterySpells.contains(tmpDamage.instantSpellName) && getInstant("Beam Mastery")) {
		beamAffectedTotal = 3;
	}
	return beamAffectedTotal;
}

void PlayerWheel::updateBeamMasteryDamage(CombatDamage &tmpDamage, uint8_t &beamAffectedTotal, uint8_t &beamAffectedCurrent) const {
	if (beamAffectedTotal > 0) {
		tmpDamage.damageMultiplier += checkBeamMasteryDamage();
		reduceAllSpellsCooldownTimer(1000); // Reduces all spell cooldown by 1 second per target hit (max 3 seconds)
		--beamAffectedTotal;
		beamAffectedCurrent++;
	}
}

void PlayerWheel::healIfBattleHealingActive() const {
	if (getInstant("Battle Healing")) {
		CombatDamage damage;
		damage.primary.value = checkBattleHealingAmount();
		damage.primary.type = COMBAT_HEALING;
		g_game().combatChangeHealth(m_player.getPlayer(), m_player.getPlayer(), damage);
	}
}

void PlayerWheel::adjustDamageBasedOnResistanceAndSkill(int32_t &damage, CombatType_t combatType) const {
	const int32_t wheelOfDestinyElementAbsorb = getResistance(combatType);
	if (wheelOfDestinyElementAbsorb > 0) {
		damage -= std::ceil((damage * wheelOfDestinyElementAbsorb) / 10000.);
	}

	damage -= std::ceil((damage * checkAvatarSkill(WheelAvatarSkill_t::DAMAGE_REDUCTION)) / 100.);
}

float PlayerWheel::calculateMitigation() const {
	const int32_t skill = m_player.getSkillLevel(SKILL_SHIELD);
	int32_t defenseValue = 0;
	float fightFactor = 1.0f;
	float shieldFactor = 1.0f;
	float distanceFactor = 1.0f;
	switch (m_player.fightMode) {
		case FIGHTMODE_ATTACK: {
			fightFactor = 0.67f;
			break;
		}
		case FIGHTMODE_BALANCED: {
			fightFactor = 0.84f;
			break;
		}
		case FIGHTMODE_DEFENSE: {
			fightFactor = 1.0f;
			break;
		}
		default:
			break;
	}

	const auto &shield = m_player.inventory[CONST_SLOT_RIGHT];
	if (shield) {
		if (shield->isSpellBook() || shield->isQuiver()) {
			distanceFactor = m_player.vocation->mitigationSecondaryShield;
		} else {
			shieldFactor = m_player.vocation->mitigationPrimaryShield;
		}
		defenseValue = shield->getDefense();
		// Wheel of destiny
		if (shield->getDefense() > 0) {
			defenseValue += getMajorStatConditional("Combat Mastery", WheelMajor_t::DEFENSE);
		}
	}

	const auto &weapon = m_player.inventory[CONST_SLOT_LEFT];
	if (weapon) {
		if (weapon->getAmmoType() == AMMO_BOLT || weapon->getAmmoType() == AMMO_ARROW) {
			distanceFactor = m_player.vocation->mitigationSecondaryShield;
		} else if (weapon->getSlotPosition() & SLOTP_TWO_HAND) {
			defenseValue = weapon->getDefense() + weapon->getExtraDefense();
			shieldFactor = m_player.vocation->mitigationSecondaryShield;
		} else {
			defenseValue += weapon->getExtraDefense();
			shieldFactor = m_player.vocation->mitigationPrimaryShield;
		}
	}

	float mitigation = std::ceil(((((skill * m_player.vocation->mitigationFactor) + (shieldFactor * static_cast<float>(defenseValue))) / 100.0f) * fightFactor * distanceFactor) * 100.0f) / 100.0f;
	mitigation += (mitigation * static_cast<float>(getMitigationMultiplier())) / 100.f;
	return mitigation;
}

WheelGemBasicModifier_t PlayerWheel::selectBasicModifier2(WheelGemBasicModifier_t modifier1) const {
	WheelGemBasicModifier_t modifier = modifier1;
	while (modifier == modifier1) {
		modifier = wheelGemBasicSlot2Allowed[uniform_random(0, wheelGemBasicSlot2Allowed.size() - 1)];
	}
	return modifier;
}

std::string PlayerWheelGem::toString() const {
	return fmt::format("[PlayerWheelGem] uuid: {}, locked: {}, affinity: {}, quality: {}, basicModifier1: {}, basicModifier2: {}, supremeModifier: {}", uuid, locked, static_cast<IntType>(affinity), static_cast<IntType>(quality), static_cast<IntType>(basicModifier1), static_cast<IntType>(basicModifier2), static_cast<IntType>(supremeModifier));
}

void PlayerWheelGem::save(const std::shared_ptr<KV> &kv) const {
	kv->scoped("revealed")->set(uuid, serialize());
}
void PlayerWheelGem::remove(const std::shared_ptr<KV> &kv) const {
	kv->scoped("revealed")->remove(uuid);
}

PlayerWheelGem PlayerWheelGem::load(const std::shared_ptr<KV> &kv, const std::string &uuid) {
	auto val = kv->scoped("revealed")->get(uuid);
	if (!val || !val.has_value()) {
		return {};
	}
	return deserialize(uuid, val.value());
}

ValueWrapper PlayerWheelGem::serialize() const {
	return {
		{ "uuid", uuid },
		{ "locked", locked },
		{ "affinity", static_cast<IntType>(affinity) },
		{ "quality", static_cast<IntType>(quality) },
		{ "basicModifier1", static_cast<IntType>(basicModifier1) },
		{ "basicModifier2", static_cast<IntType>(basicModifier2) },
		{ "supremeModifier", static_cast<IntType>(supremeModifier) }
	};
}

PlayerWheelGem PlayerWheelGem::deserialize(const std::string &uuid, const ValueWrapper &val) {
	auto map = val.get<MapType>();
	if (map.empty()) {
		return {};
	}
	return {
		uuid,
		map["locked"]->get<BooleanType>(),
		static_cast<WheelGemAffinity_t>(map["affinity"]->get<IntType>()),
		static_cast<WheelGemQuality_t>(map["quality"]->get<IntType>()),
		static_cast<WheelGemBasicModifier_t>(map["basicModifier1"]->get<IntType>()),
		static_cast<WheelGemBasicModifier_t>(map["basicModifier2"]->get<IntType>()),
		static_cast<WheelGemSupremeModifier_t>(map["supremeModifier"]->get<IntType>())
	};
}
