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
 * @enum CombatType
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
 * @var COUNT
 * @brief The number of enum types (+1) for iteration purposes.
 */
export enum class CombatType : uint8_t {
	PhysicalDamage = 0,
	EnergyDamage = 1,
	EarthDamage = 2,
	FireDamage = 3,
	UndefinedDamage = 4,
	LifeDrain = 5,
	ManaDrain = 6,
	Healing = 7,
	DrownDamage = 8,
	IceDamage = 9,
	HolyDamage = 10,
	DeathDamage = 11,
	AgonyDamage = 12,
	NeutralDamage = 13,

	Count = 14,

	// Server read only
	None = 255
};

export constexpr uint8_t combatToValue(CombatType combatType) {
	return static_cast<uint8_t>(combatType);
}

export constexpr CombatType combatFromValue(uint8_t combatvalue) {
	return static_cast<CombatType>(combatvalue);
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
 * @var FIRST
 * @brief The number first buff type.
 * 
 * @var LAST
 * @brief The number last buff type.
 */
export enum class Buffs_t : uint8_t {
	DamageDealt = 0,
	DamageReceived = 1,
	HealingReceived = 2,

	First = DamageDealt,
	Last = HealingReceived,
};

export constexpr uint8_t buffToValue(Buffs_t buffType) {
	return static_cast<uint8_t>(buffType);
}

export constexpr Buffs_t buffFromValue(uint8_t buffValue) {
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
	Default = 0,
	Player = 1,
	Lion = 2,
	LionUsurpers = 3,
	Marid = 4,
	Efreet = 5,
	Deepling = 6,
	Deathling = 7,
	Anuma = 8,
	Fafnar = 9,

	Last
};

export constexpr uint8_t factionToValue(Faction_t factionType) {
	return static_cast<uint8_t>(factionType);
}

export constexpr Faction_t factionFromValue(uint8_t factionValue) {
	return static_cast<Faction_t>(factionValue);
}

/**
 * @enum TalkType
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
export enum TalkType : uint8_t {
	Say = 1,
	Whisper = 2,
	Yell = 3,
	PrivateFrom = 4,
	PrivateTo = 5,
	ChannelManager = 6,
	ChannelY = 7,
	ChannelO = 8,
	SpellUse = 9,
	PrivateNpcToPlayer = 10,
	NpcUnknown = 11, /* no effect (?)*/
	PrivatePlayerToNpc = 12,
	Broadcast = 13,
	ChannelR1 = 14, // red - #c text
	PrivateRedFrom = 15, //@name@text
	PrivateRedTo = 16, //@name@text
	MonsterSay = 36,
	MonsterYell = 37,

	LastOldProtocol = 38, /* Dont forget about the CHANNEL_R2*/
	ChannelR2 = 255 // #d
};

export constexpr uint8_t speakToValue(TalkType type) {
	return static_cast<uint8_t>(type);
}

export constexpr TalkType speakFromValue(uint8_t value) {
	return static_cast<TalkType>(value);
}

/**
 * @enum CreatureType
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
export enum class CreatureType : uint8_t {
	Player = 0,
	Monster = 1,
	Npc = 2,
	SummonPlayer = 3,
	SummonOthers = 4,
	Hidden = 5,
};

export constexpr uint8_t creatureTypeToValue(CreatureType type) {
	return static_cast<uint8_t>(type);
}

export constexpr CreatureType creatureTypeFromValue(uint8_t value) {
	return static_cast<CreatureType>(value);
}

/**
 * @enum Skull_t
 * @brief Enumerates types of enum.
 *
 * @fn skullToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn skullFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 */
export enum class Skull_t : uint8_t {
	None = 0,
	Yellow = 1,
	Green = 2,
	White = 3,
	Red = 4,
	Black = 5,
	Orange = 6,
};

export constexpr uint8_t skullToValue(Skull_t type) {
	return static_cast<uint8_t>(type);
}

export constexpr Skull_t skullFromValue(uint8_t value) {
	return static_cast<Skull_t>(value);
}

/**
 * @enum ZoneType
 * @brief Enumerates types of enum.
 *
 * @fn zoneToValue
 * @brief Converts a enum type to its underlying numeric value.
 * @return The numeric value of the enum type.
 * 
 * @fn zoneFromValue
 * @brief Converts a numeric value into a enum type.
 * @return The enum type of the numeric value
 */

export enum class ZoneType {
	Protection,
	NoPvp,
	Pvp,
	NoLogout,
	Normal,
};

export constexpr uint8_t zoneToValue(ZoneType type) {
	return static_cast<uint8_t>(type);
}

export constexpr ZoneType zoneFromValue(uint8_t value) {
	return static_cast<ZoneType>(value);
}

/**
 * @enum RaceType
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

export enum class RaceType : uint8_t {
	None,
	Venom,
	Blood,
	Unded,
	Fire,
	Energy,
	Ink,
};

export constexpr uint8_t raceToValue(RaceType type) {
	return static_cast<uint8_t>(type);
}

export constexpr RaceType raceFromValue(uint8_t value) {
	return static_cast<RaceType>(value);
}

/**
 * @enum BlockType
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

export enum class BlockType : uint8_t {
	None,
	Defense,
	Armor,
	Immunity,
	Dodge
};

export constexpr uint8_t blockToValue(BlockType type) {
	return static_cast<uint8_t>(type);
}

export constexpr BlockType blockFromValue(uint8_t value) {
	return static_cast<BlockType>(value);
}

/**
 * @enum ConditionType
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

export enum class ConditionType : uint8_t {
	None = 0,

	Poison = 1,
	Fire = 2,
	Energy = 3,
	Bleeding = 4,
	Haste = 5,
	Paralyze = 6,
	Outfit = 7,
	Invisible = 8,
	Light = 9,
	ManaShield = 10,
	InFight = 11,
	Drunk = 12,
	Exhaust = 13, // unused
	Regeneration = 14,
	Soul = 15,
	Drown = 16,
	Muted = 17,
	ChannelMutedTicks = 18,
	YellTicks = 19,
	Attributes = 20,
	Freezing = 21,
	Dazzled = 22,
	Cursed = 23,
	ExhaustCombat = 24, // unused
	ExhaustHeal = 25, // unused
	Pacified = 26,
	SpellCooldown = 27,
	SpellGroupCooldown = 28,
	Rooted = 29,
	Feared = 30,
	LesserHex = 31,
	IntenseHex = 32,
	GreaterHex = 33,
	Goshnar1 = 34,
	Goshnar2 = 35,
	Goshnar3 = 36,
	Goshnar4 = 37,
	Goshnar5 = 38,

	// Need the last ever
	Count,
};

export constexpr uint8_t conditionToValue(ConditionType type) {
	return static_cast<uint8_t>(type);
}

export constexpr ConditionType conditionFromValue(uint8_t value) {
	return static_cast<ConditionType>(value);
}

export bool IsConditionSuppressible(ConditionType condition) {
	static std::array<ConditionType, 8> suppressibleConditions = {
		ConditionType::Poison,
		ConditionType::Fire,
		ConditionType::Energy,
		ConditionType::Bleeding,
		ConditionType::Paralyze,
		ConditionType::Drown,
		ConditionType::Freezing,
		ConditionType::Cursed,
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
	Default = -1,
	Combat = 0,
	Head = 1,
	Necklace = 2,
	Backpack = 3,
	Armor = 4,
	Right = 5,
	Left = 6,
	Legs = 7,
	Feet = 8,
	Ring = 9,
	Ammo = 10,
};

export int8_t conditionIdToValue(ConditionId_t type) {
	return static_cast<int8_t>(type);
}

export constexpr ConditionId_t conditionIdFromValue(int8_t value) {
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
	None = 0,
	Normal = 1,
	Trade = 2,
	Quest = 3,
	QuestTrader = 4,
	Hireling = 7,
};

export constexpr uint8_t bubbleToValue(SpeechBubble_t type) {
	return static_cast<uint8_t>(type);
}

export constexpr SpeechBubble_t bubbleFromValue(uint8_t value) {
	return static_cast<SpeechBubble_t>(value);
}

/**
 * @enum CreatureEventType
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
export enum class CreatureEventType : uint8_t {
	None,
	Login,
	Logout,
	Think,
	PrepareDeath,
	Death,
	Kill,
	Advance,
	ModalWindow,
	TextEdit,
	HealthChange,
	ManaChange,
	// Otclient additional network opcodes.
	ExtendedOpcode,
};

export constexpr uint8_t eventToValue(CreatureEventType type) {
	return static_cast<uint8_t>(type);
}

export constexpr CreatureEventType eventFromValue(uint8_t value) {
	return static_cast<CreatureEventType>(value);
}
