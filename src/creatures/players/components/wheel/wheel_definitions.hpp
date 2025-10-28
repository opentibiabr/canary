/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#pragma once

enum class WheelSlots_t : uint8_t {
	SLOT_GREEN_200 = 1,
	SLOT_GREEN_TOP_150 = 2,
	SLOT_GREEN_TOP_100 = 3,

	SLOT_RED_TOP_100 = 4,
	SLOT_RED_TOP_150 = 5,
	SLOT_RED_200 = 6,

	SLOT_GREEN_BOTTOM_150 = 7,
	SLOT_GREEN_MIDDLE_100 = 8,
	SLOT_GREEN_TOP_75 = 9,

	SLOT_RED_TOP_75 = 10,
	SLOT_RED_MIDDLE_100 = 11,
	SLOT_RED_BOTTOM_150 = 12,

	SLOT_GREEN_BOTTOM_100 = 13,
	SLOT_GREEN_BOTTOM_75 = 14,
	SLOT_GREEN_50 = 15,

	SLOT_RED_50 = 16,
	SLOT_RED_BOTTOM_75 = 17,
	SLOT_RED_BOTTOM_100 = 18,

	SLOT_BLUE_TOP_100 = 19,
	SLOT_BLUE_TOP_75 = 20,
	SLOT_BLUE_50 = 21,

	SLOT_PURPLE_50 = 22,
	SLOT_PURPLE_TOP_75 = 23,
	SLOT_PURPLE_TOP_100 = 24,

	SLOT_BLUE_TOP_150 = 25,
	SLOT_BLUE_MIDDLE_100 = 26,
	SLOT_BLUE_BOTTOM_75 = 27,

	SLOT_PURPLE_BOTTOM_75 = 28,
	SLOT_PURPLE_MIDDLE_100 = 29,
	SLOT_PURPLE_TOP_150 = 30,

	SLOT_BLUE_200 = 31,
	SLOT_BLUE_BOTTOM_150 = 32,
	SLOT_BLUE_BOTTOM_100 = 33,

	SLOT_PURPLE_BOTTOM_100 = 34,
	SLOT_PURPLE_BOTTOM_150 = 35,
	SLOT_PURPLE_200 = 36,
};

enum class WheelStageEnum_t : uint8_t {
	NONE = 0,
	ONE = 1,
	TWO = 2,
	THREE = 3,
};

enum class WheelStagePointsEnum_t {
	ONE = 250,
	TWO = 500,
	THREE = 1000
};

enum class WheelStage_t : uint8_t {
	GIFT_OF_LIFE = 0,
	COMBAT_MASTERY = 1,
	BLESSING_OF_THE_GROVE = 2,
	DRAIN_BODY = 3,
	BEAM_MASTERY = 4,
	DIVINE_EMPOWERMENT = 5,
	TWIN_BURST = 6,
	EXECUTIONERS_THROW = 7,
	AVATAR_OF_LIGHT = 8,
	AVATAR_OF_NATURE = 9,
	AVATAR_OF_STEEL = 10,
	AVATAR_OF_STORM = 11,
	DIVINE_GRENADE = 12,
	AVATAR_OF_BALANCE = 13,
	SPIRITUAL_OUTBURST = 14,
	ASCETIC = 15,

	STAGE_COUNT = 16
};

enum class WheelOnThink_t : uint8_t {
	BATTLE_INSTINCT = 0,
	POSITIONAL_TACTICS = 1,
	BALLISTIC_MASTERY = 2,
	COMBAT_MASTERY = 3,
	FOCUS_MASTERY = 4,
	GIFT_OF_LIFE = 5,
	DIVINE_EMPOWERMENT = 6,
	AVATAR_SPELL = 7,
	AVATAR_FORGE = 8,
	SANCTUARY = 9,
	ASCETIC = 10,
	SPIRITUAL_OUTBURST = 11,

	TOTAL_COUNT = 12
};

enum class WheelStat_t : uint8_t {
	HEALTH = 0,
	MANA = 1,
	CAPACITY = 2,
	MITIGATION = 3,
	MELEE = 4,
	DISTANCE = 5,
	MAGIC = 6,
	LIFE_LEECH = 7,
	MANA_LEECH = 8,
	HEALING = 9,
	DAMAGE = 10,
	LIFE_LEECH_CHANCE = 11,
	MANA_LEECH_CHANCE = 12,
	DODGE = 13,
	CRITICAL_DAMAGE = 14,
	FIST = 15,

	TOTAL_COUNT = 16
};

enum class WheelMajor_t : uint8_t {
	MELEE = 0,
	DISTANCE = 1,
	SHIELD = 2,
	MAGIC = 3,
	HOLY_RESISTANCE = 4,
	CRITICAL_DMG = 5,
	PHYSICAL_DMG = 6,
	HOLY_DMG = 7,
	CRITICAL_DMG_2 = 8,
	DEFENSE = 9,
	DAMAGE = 10,

	TOTAL_COUNT = 11
};

enum class WheelInstant_t : uint8_t {
	BATTLE_INSTINCT = 0,
	BATTLE_HEALING = 1,
	POSITIONAL_TACTICS = 2,
	BALLISTIC_MASTERY = 3,
	HEALING_LINK = 4,
	RUNIC_MASTERY = 5,
	FOCUS_MASTERY = 6,
	GUIDING_PRESENCE = 7,
	SANCTUARY = 8,

	INSTANT_COUNT = 9
};

enum class WheelAvatarSkill_t : uint8_t {
	NONE = 0,
	DAMAGE_REDUCTION = 1,
	CRITICAL_CHANCE = 2,
	CRITICAL_DAMAGE = 3,
};

enum class WheelSpellGrade_t : uint8_t {
	NONE = 0,
	REGULAR = 1,
	UPGRADED = 2,
	MAX = 3 // This one is used only on LUA
};

enum class WheelSpellBoost_t : uint8_t {
	MANA = 0,
	COOLDOWN = 1,
	GROUP_COOLDOWN = 2,
	SECONDARY_GROUP_COOLDOWN = 3,
	MANA_LEECH = 4,
	MANA_LEECH_CHANCE = 5,
	LIFE_LEECH = 6,
	LIFE_LEECH_CHANCE = 7,
	DAMAGE = 8,
	DAMAGE_REDUCTION = 9,
	HEAL = 10,
	CRITICAL_DAMAGE = 11,
	CRITICAL_CHANCE = 12,
};

/**
 * @brief Slot information struct.
 *
 * This struct stores the order, slot, and points information for a slot.
 */
struct SlotInfo {
	int8_t order; ///< The order of the slot.
	uint8_t slot; ///< The slot index.
	uint16_t points; ///< The points for the slot.
};
