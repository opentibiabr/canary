module;

#include <array>
#include <cstdint>

export module enum_modules;

/**
 * @file
 * @brief Defines enums and related functions.
 * @details This module exports various enums and related functions to convert between enum values and their underlying types.
 */

/**
 * @enum CombatType_t
 * @brief Enumerates types of enum.
 *
 * @fn combatToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn combatFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 * 
 * @var COMBAT_COUNT
 * @brief The number of enum types (+1) for iteration purposes.
 */
export enum class CombatType_t : uint8_t {
	COMBAT_PHYSICALDAMAGE = 0,
	COMBAT_ENERGYDAMAGE = 1,
	COMBAT_EARTHDAMAGE = 2,
	COMBAT_FIREDAMAGE = 3,
	COMBAT_UNDEFINEDDAMAGE = 4,
	COMBAT_LIFEDRAIN = 5,
	COMBAT_MANADRAIN = 6,
	COMBAT_HEALING = 7,
	COMBAT_DROWNDAMAGE = 8,
	COMBAT_ICEDAMAGE = 9,
	COMBAT_HOLYDAMAGE = 10,
	COMBAT_DEATHDAMAGE = 11,
	COMBAT_AGONYDAMAGE = 12,
	COMBAT_NEUTRALDAMAGE = 13,

	COUNT = 14,

	// Server read only
	COMBAT_NONE = 255
};

export constexpr auto COMBAT_COUNT = static_cast<uint8_t>(CombatType_t::COUNT);

export uint8_t combatToValue(CombatType_t combatType) {
	return static_cast<uint8_t>(combatType);
}

export CombatType_t combatFromValue(uint8_t combatvalue) {
	return static_cast<CombatType_t>(combatvalue);
}

/**
 * @enum Buffs_t
 * @brief Enumerates types of enum.
 *
 * @fn buffToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn buffFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 * 
 * @var BUFF_FIRST
 * @brief The number first buff type.
 * 
 * @var BUFF_LAST
 * @brief The number last buff type.
 */
export enum class Buffs_t : uint8_t {
	BUFF_DAMAGEDEALT,
	BUFF_DAMAGERECEIVED,
	BUFF_HEALINGRECEIVED,

	BUFF_LAST,
};

export constexpr auto BUFF_FIRST = static_cast<uint8_t>(Buffs_t::BUFF_DAMAGEDEALT);
export constexpr auto BUFF_LAST = static_cast<uint8_t>(Buffs_t::BUFF_LAST);

export uint8_t buffToValue(Buffs_t buffType) {
	return static_cast<uint8_t>(buffType);
}

export Buffs_t buffFromValue(uint8_t buffValue) {
	return static_cast<Buffs_t>(buffValue);
}

/**
 * @enum Faction_t
 * @brief Enumerates types of enum.
 *
 * @fn factionToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn factionFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 * 
 * @var FACTION_LAST
 * @brief The number last buff type.
 */
export enum class Faction_t {
	FACTION_DEFAULT = 0,
	FACTION_PLAYER = 1,
	FACTION_LION = 2,
	FACTION_LIONUSURPERS = 3,
	FACTION_MARID = 4,
	FACTION_EFREET = 5,
	FACTION_DEEPLING = 6,
	FACTION_DEATHLING = 7,
	FACTION_ANUMA = 8,
	FACTION_FAFNAR = 9,

	FACTION_LAST,
};

export uint8_t factionToValue(Faction_t factionType) {
	return static_cast<uint8_t>(factionType);
}

export Faction_t factionFromValue(uint8_t factionValue) {
	return static_cast<Faction_t>(factionValue);
}

export constexpr auto FACTION_LAST = static_cast<uint8_t>(Faction_t::FACTION_LAST);

/**
 * @enum SpeakClasses
 * @brief Enumerates types of enum.
 *
 * @fn factionToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn factionFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 */
export enum SpeakClasses : uint8_t {
	TALKTYPE_SAY = 1,
	TALKTYPE_WHISPER = 2,
	TALKTYPE_YELL = 3,
	TALKTYPE_PRIVATE_FROM = 4,
	TALKTYPE_PRIVATE_TO = 5,
	TALKTYPE_CHANNEL_MANAGER = 6,
	TALKTYPE_CHANNEL_Y = 7,
	TALKTYPE_CHANNEL_O = 8,
	TALKTYPE_SPELL_USE = 9,
	TALKTYPE_PRIVATE_NP = 10,
	TALKTYPE_NPC_UNKOWN = 11, /* no effect (?)*/
	TALKTYPE_PRIVATE_PN = 12,
	TALKTYPE_BROADCAST = 13,
	TALKTYPE_CHANNEL_R1 = 14, // red - #c text
	TALKTYPE_PRIVATE_RED_FROM = 15, //@name@text
	TALKTYPE_PRIVATE_RED_TO = 16, //@name@text
	TALKTYPE_MONSTER_SAY = 36,
	TALKTYPE_MONSTER_YELL = 37,

	TALKTYPE_MONSTER_LAST_OLDPROTOCOL = 38, /* Dont forget about the CHANNEL_R2*/
	TALKTYPE_CHANNEL_R2 = 0xFF // #d
};

export uint8_t speakToValue(SpeakClasses type) {
	return static_cast<uint8_t>(type);
}

export SpeakClasses speakFromValue(uint8_t value) {
	return static_cast<SpeakClasses>(value);
}

export constexpr auto TALK_LAST_OLDPROTOCOL = static_cast<uint8_t>(SpeakClasses::TALKTYPE_MONSTER_LAST_OLDPROTOCOL);

/**
 * @enum CreatureType_t
 * @brief Enumerates types of enum.
 *
 * @fn creatureTypeToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn creatureTypeFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 */
export enum class CreatureType_t : uint8_t {
	CREATURETYPE_PLAYER = 0,
	CREATURETYPE_MONSTER = 1,
	CREATURETYPE_NPC = 2,
	CREATURETYPE_SUMMON_PLAYER = 3,
	CREATURETYPE_SUMMON_OTHERS = 4,
	CREATURETYPE_HIDDEN = 5,
};

export uint8_t creatureTypeToValue(CreatureType_t type) {
	return static_cast<uint8_t>(type);
}

export CreatureType_t creatureTypeFromValue(uint8_t value) {
	return static_cast<CreatureType_t>(value);
}

/**
 * @enum Skulls_t
 * @brief Enumerates types of enum.
 *
 * @fn skullsToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn skullsFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 */
export enum class Skulls_t : uint8_t {
	SKULL_NONE = 0,
	SKULL_YELLOW = 1,
	SKULL_GREEN = 2,
	SKULL_WHITE = 3,
	SKULL_RED = 4,
	SKULL_BLACK = 5,
	SKULL_ORANGE = 6,
};

export uint8_t skullsToValue(Skulls_t type) {
	return static_cast<uint8_t>(type);
}

export Skulls_t skullsFromValue(uint8_t value) {
	return static_cast<Skulls_t>(value);
}

/**
 * @enum ZoneType_t
 * @brief Enumerates types of enum.
 *
 * @fn zonesToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn zonesFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 */

export enum class ZoneType_t {
	ZONE_PROTECTION,
	ZONE_NOPVP,
	ZONE_PVP,
	ZONE_NOLOGOUT,
	ZONE_NORMAL,
};

export uint8_t zonesToValue(ZoneType_t type) {
	return static_cast<uint8_t>(type);
}

export ZoneType_t zonesFromValue(uint8_t value) {
	return static_cast<ZoneType_t>(value);
}

/**
 * @enum RaceType_t
 * @brief Enumerates types of enum.
 *
 * @fn raceToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn raceFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 */

export enum class RaceType_t : uint8_t {
	RACE_NONE,
	RACE_VENOM,
	RACE_BLOOD,
	RACE_UNDEAD,
	RACE_FIRE,
	RACE_ENERGY,
	RACE_INK,
};

export uint8_t raceToValue(RaceType_t type) {
	return static_cast<uint8_t>(type);
}

export RaceType_t raceFromValue(uint8_t value) {
	return static_cast<RaceType_t>(value);
}

/**
 * @enum BlockType_t
 * @brief Enumerates types of enum.
 *
 * @fn blockToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn blockFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 */

export enum class BlockType_t : uint8_t {
	BLOCK_NONE,
	BLOCK_DEFENSE,
	BLOCK_ARMOR,
	BLOCK_IMMUNITY,
	BLOCK_DODGE
};

export uint8_t blockToValue(BlockType_t type) {
	return static_cast<uint8_t>(type);
}

export BlockType_t blockFromValue(uint8_t value) {
	return static_cast<BlockType_t>(value);
}

/**
 * @enum ConditionType_t
 * @brief Enumerates types of enum.
 *
 * @fn conditionToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn conditionFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 */

export enum class ConditionType_t : uint8_t {
	CONDITION_NONE = 0,

	CONDITION_POISON = 1,
	CONDITION_FIRE = 2,
	CONDITION_ENERGY = 3,
	CONDITION_BLEEDING = 4,
	CONDITION_HASTE = 5,
	CONDITION_PARALYZE = 6,
	CONDITION_OUTFIT = 7,
	CONDITION_INVISIBLE = 8,
	CONDITION_LIGHT = 9,
	CONDITION_MANASHIELD = 10,
	CONDITION_INFIGHT = 11,
	CONDITION_DRUNK = 12,
	CONDITION_EXHAUST = 13, // unused
	CONDITION_REGENERATION = 14,
	CONDITION_SOUL = 15,
	CONDITION_DROWN = 16,
	CONDITION_MUTED = 17,
	CONDITION_CHANNELMUTEDTICKS = 18,
	CONDITION_YELLTICKS = 19,
	CONDITION_ATTRIBUTES = 20,
	CONDITION_FREEZING = 21,
	CONDITION_DAZZLED = 22,
	CONDITION_CURSED = 23,
	CONDITION_EXHAUST_COMBAT = 24, // unused
	CONDITION_EXHAUST_HEAL = 25, // unused
	CONDITION_PACIFIED = 26,
	CONDITION_SPELLCOOLDOWN = 27,
	CONDITION_SPELLGROUPCOOLDOWN = 28,
	CONDITION_ROOTED = 29,
	CONDITION_FEARED = 30,
	CONDITION_LESSERHEX = 31,
	CONDITION_INTENSEHEX = 32,
	CONDITION_GREATERHEX = 33,
	CONDITION_GOSHNAR1 = 34,
	CONDITION_GOSHNAR2 = 35,
	CONDITION_GOSHNAR3 = 36,
	CONDITION_GOSHNAR4 = 37,
	CONDITION_GOSHNAR5 = 38,

	// Need the last ever
	CONDITION_COUNT,
};

export constexpr auto CONDITION_COUNT = static_cast<uint8_t>(ConditionType_t::CONDITION_COUNT);

export uint8_t conditionToValue(ConditionType_t type) {
	return static_cast<uint8_t>(type);
}

export ConditionType_t conditionFromValue(uint8_t value) {
	return static_cast<ConditionType_t>(value);
}

export bool IsConditionSuppressible(ConditionType_t condition) {
	static std::array<ConditionType_t, 8> suppressibleConditions = {
		ConditionType_t::CONDITION_POISON,
		ConditionType_t::CONDITION_FIRE,
		ConditionType_t::CONDITION_ENERGY,
		ConditionType_t::CONDITION_BLEEDING,
		ConditionType_t::CONDITION_PARALYZE,
		ConditionType_t::CONDITION_DROWN,
		ConditionType_t::CONDITION_FREEZING,
		ConditionType_t::CONDITION_CURSED,
	};

	for (const auto &suppressibleCondition : suppressibleConditions) {
		if (condition == suppressibleCondition) {
			return true;
		}
	}

	return false;
}

/**
 * @enum ConditionId_t
 * @brief Enumerates types of enum.
 *
 * @fn conditionIdToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn conditionIdFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 */

export enum class ConditionId_t : int8_t {
	CONDITIONID_DEFAULT = -1,
	CONDITIONID_COMBAT,
	CONDITIONID_HEAD,
	CONDITIONID_NECKLACE,
	CONDITIONID_BACKPACK,
	CONDITIONID_ARMOR,
	CONDITIONID_RIGHT,
	CONDITIONID_LEFT,
	CONDITIONID_LEGS,
	CONDITIONID_FEET,
	CONDITIONID_RING,
	CONDITIONID_AMMO,
};

export int8_t conditionIdToValue(ConditionId_t type) {
	return static_cast<int8_t>(type);
}

export ConditionId_t conditionIdFromValue(int8_t value) {
	return static_cast<ConditionId_t>(value);
}

/**
 * @enum SpeechBubble_t
 * @brief Enumerates types of enum.
 *
 * @fn bubbleToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn bubbleFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 */
export enum class SpeechBubble_t {
	SPEECHBUBBLE_NONE = 0,
	SPEECHBUBBLE_NORMAL = 1,
	SPEECHBUBBLE_TRADE = 2,
	SPEECHBUBBLE_QUEST = 3,
	SPEECHBUBBLE_QUESTTRADER = 4,
	SPEECHBUBBLE_HIRELING = 7,
};

export uint8_t bubbleToValue(SpeechBubble_t type) {
	return static_cast<uint8_t>(type);
}

export SpeechBubble_t bubbleFromValue(uint8_t value) {
	return static_cast<SpeechBubble_t>(value);
}

/**
 * @enum CreatureEventType_t
 * @brief Enumerates types of enum.
 *
 * @fn eventToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn eventFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 */
export enum class CreatureEventType_t : uint8_t {
	CREATURE_EVENT_NONE,
	CREATURE_EVENT_LOGIN,
	CREATURE_EVENT_LOGOUT,
	CREATURE_EVENT_THINK,
	CREATURE_EVENT_PREPAREDEATH,
	CREATURE_EVENT_DEATH,
	CREATURE_EVENT_KILL,
	CREATURE_EVENT_ADVANCE,
	CREATURE_EVENT_MODALWINDOW,
	CREATURE_EVENT_TEXTEDIT,
	CREATURE_EVENT_HEALTHCHANGE,
	CREATURE_EVENT_MANACHANGE,
	// Otclient additional network opcodes.
	CREATURE_EVENT_EXTENDED_OPCODE,
};

export uint8_t eventToValue(CreatureEventType_t type) {
	return static_cast<uint8_t>(type);
}

export CreatureEventType_t eventFromValue(uint8_t value) {
	return static_cast<CreatureEventType_t>(value);
}
