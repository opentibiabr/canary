/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_CREATURES_CREATURES_DEFINITIONS_HPP_
#define SRC_CREATURES_CREATURES_DEFINITIONS_HPP_

// Enum

enum SkillsId_t {
	SKILLVALUE_LEVEL = 0,
	SKILLVALUE_TRIES = 1,
	SKILLVALUE_PERCENT = 2,
};

enum MatrixOperation_t {
	MATRIXOPERATION_COPY,
	MATRIXOPERATION_MIRROR,
	MATRIXOPERATION_FLIP,
	MATRIXOPERATION_ROTATE90,
	MATRIXOPERATION_ROTATE180,
	MATRIXOPERATION_ROTATE270,
};

enum ConditionAttr_t {
	CONDITIONATTR_TYPE = 1,
	CONDITIONATTR_ID,
	CONDITIONATTR_TICKS,
	CONDITIONATTR_HEALTHTICKS,
	CONDITIONATTR_HEALTHGAIN,
	CONDITIONATTR_MANATICKS,
	CONDITIONATTR_MANAGAIN,
	CONDITIONATTR_DELAYED,
	CONDITIONATTR_OWNER,
	CONDITIONATTR_INTERVALDATA,
	CONDITIONATTR_SPEEDDELTA,
	CONDITIONATTR_FORMULA_MINA,
	CONDITIONATTR_FORMULA_MINB,
	CONDITIONATTR_FORMULA_MAXA,
	CONDITIONATTR_FORMULA_MAXB,
	CONDITIONATTR_LIGHTCOLOR,
	CONDITIONATTR_LIGHTLEVEL,
	CONDITIONATTR_LIGHTTICKS,
	CONDITIONATTR_LIGHTINTERVAL,
	CONDITIONATTR_SOULTICKS,
	CONDITIONATTR_SOULGAIN,
	CONDITIONATTR_SKILLS,
	CONDITIONATTR_STATS,
	CONDITIONATTR_BUFFS,
	CONDITIONATTR_OUTFIT,
	CONDITIONATTR_PERIODDAMAGE,
	CONDITIONATTR_ISBUFF,
	CONDITIONATTR_SUBID,
	CONDITIONATTR_MANASHIELD,

	// reserved for serialization
	CONDITIONATTR_END = 254,
};

enum ConditionType_t {
	CONDITION_NONE,

	CONDITION_POISON = 1 << 0,
	CONDITION_FIRE = 1 << 1,
	CONDITION_ENERGY = 1 << 2,
	CONDITION_BLEEDING = 1 << 3,
	CONDITION_HASTE = 1 << 4,
	CONDITION_PARALYZE = 1 << 5,
	CONDITION_OUTFIT = 1 << 6,
	CONDITION_INVISIBLE = 1 << 7,
	CONDITION_LIGHT = 1 << 8,
	CONDITION_MANASHIELD = 1 << 9,
	CONDITION_INFIGHT = 1 << 10,
	CONDITION_DRUNK = 1 << 11,
	CONDITION_EXHAUST = 1 << 12, // unused
	CONDITION_REGENERATION = 1 << 13,
	CONDITION_SOUL = 1 << 14,
	CONDITION_DROWN = 1 << 15,
	CONDITION_MUTED = 1 << 16,
	CONDITION_CHANNELMUTEDTICKS = 1 << 17,
	CONDITION_YELLTICKS = 1 << 18,
	CONDITION_ATTRIBUTES = 1 << 19,
	CONDITION_FREEZING = 1 << 20,
	CONDITION_DAZZLED = 1 << 21,
	CONDITION_CURSED = 1 << 22,
	CONDITION_EXHAUST_COMBAT = 1 << 23, // unused
	CONDITION_EXHAUST_HEAL = 1 << 24, // unused
	CONDITION_PACIFIED = 1 << 25,
	CONDITION_SPELLCOOLDOWN = 1 << 26,
	CONDITION_SPELLGROUPCOOLDOWN = 1 << 27,
	CONDITION_ROOTED = 1 << 28,
};

enum ConditionParam_t {
	CONDITION_PARAM_OWNER = 1,
	CONDITION_PARAM_TICKS = 2,
	// CONDITION_PARAM_OUTFIT = 3,
	CONDITION_PARAM_HEALTHGAIN = 4,
	CONDITION_PARAM_HEALTHTICKS = 5,
	CONDITION_PARAM_MANAGAIN = 6,
	CONDITION_PARAM_MANATICKS = 7,
	CONDITION_PARAM_DELAYED = 8,
	CONDITION_PARAM_SPEED = 9,
	CONDITION_PARAM_LIGHT_LEVEL = 10,
	CONDITION_PARAM_LIGHT_COLOR = 11,
	CONDITION_PARAM_SOULGAIN = 12,
	CONDITION_PARAM_SOULTICKS = 13,
	CONDITION_PARAM_MINVALUE = 14,
	CONDITION_PARAM_MAXVALUE = 15,
	CONDITION_PARAM_STARTVALUE = 16,
	CONDITION_PARAM_TICKINTERVAL = 17,
	CONDITION_PARAM_FORCEUPDATE = 18,
	CONDITION_PARAM_SKILL_MELEE = 19,
	CONDITION_PARAM_SKILL_FIST = 20,
	CONDITION_PARAM_SKILL_CLUB = 21,
	CONDITION_PARAM_SKILL_SWORD = 22,
	CONDITION_PARAM_SKILL_AXE = 23,
	CONDITION_PARAM_SKILL_DISTANCE = 24,
	CONDITION_PARAM_SKILL_SHIELD = 25,
	CONDITION_PARAM_SKILL_FISHING = 26,
	CONDITION_PARAM_STAT_MAXHITPOINTS = 27,
	CONDITION_PARAM_STAT_MAXMANAPOINTS = 28,
	// CONDITION_PARAM_STAT_SOULPOINTS = 29,
	CONDITION_PARAM_STAT_MAGICPOINTS = 30,
	CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT = 31,
	CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT = 32,
	// CONDITION_PARAM_STAT_SOULPOINTSPERCENT = 33,
	CONDITION_PARAM_STAT_MAGICPOINTSPERCENT = 34,
	CONDITION_PARAM_PERIODICDAMAGE = 35,
	CONDITION_PARAM_SKILL_MELEEPERCENT = 36,
	CONDITION_PARAM_SKILL_FISTPERCENT = 37,
	CONDITION_PARAM_SKILL_CLUBPERCENT = 38,
	CONDITION_PARAM_SKILL_SWORDPERCENT = 39,
	CONDITION_PARAM_SKILL_AXEPERCENT = 40,
	CONDITION_PARAM_SKILL_DISTANCEPERCENT = 41,
	CONDITION_PARAM_SKILL_SHIELDPERCENT = 42,
	CONDITION_PARAM_SKILL_FISHINGPERCENT = 43,
	CONDITION_PARAM_BUFF_SPELL = 44,
	CONDITION_PARAM_SUBID = 45,
	CONDITION_PARAM_FIELD = 46,
	CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE = 47,
	CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE = 48,
	CONDITION_PARAM_SKILL_LIFE_LEECH_CHANCE = 49,
	CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT = 50,
	CONDITION_PARAM_SKILL_MANA_LEECH_CHANCE = 51,
	CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT = 52,
	CONDITION_PARAM_DISABLE_DEFENSE = 53,
	CONDITION_PARAM_STAT_CAPACITYPERCENT = 54,
	CONDITION_PARAM_MANASHIELD = 55,
	CONDITION_PARAM_BUFF_DAMAGEDEALT = 56,
	CONDITION_PARAM_BUFF_DAMAGERECEIVED = 57,
	CONDITION_PARAM_DRAIN_BODY = 58,
};

enum stats_t {
	STAT_MAXHITPOINTS,
	STAT_MAXMANAPOINTS,
	STAT_SOULPOINTS, // unused
	STAT_MAGICPOINTS,
	STAT_CAPACITY,

	STAT_FIRST = STAT_MAXHITPOINTS,
	STAT_LAST = STAT_CAPACITY
};

enum buffs_t {
	BUFF_DAMAGEDEALT,
	BUFF_DAMAGERECEIVED,

	BUFF_FIRST = BUFF_DAMAGEDEALT,
	BUFF_LAST = BUFF_DAMAGERECEIVED,
};

enum formulaType_t {
	COMBAT_FORMULA_UNDEFINED,
	COMBAT_FORMULA_LEVELMAGIC,
	COMBAT_FORMULA_SKILL,
	COMBAT_FORMULA_DAMAGE,
};

enum CombatParam_t {
	COMBAT_PARAM_TYPE,
	COMBAT_PARAM_EFFECT,
	COMBAT_PARAM_DISTANCEEFFECT,
	COMBAT_PARAM_BLOCKSHIELD,
	COMBAT_PARAM_BLOCKARMOR,
	COMBAT_PARAM_TARGETCASTERORTOPMOST,
	COMBAT_PARAM_CREATEITEM,
	COMBAT_PARAM_AGGRESSIVE,
	COMBAT_PARAM_DISPEL,
	COMBAT_PARAM_USECHARGES,
};

enum CombatOrigin {
	ORIGIN_NONE,
	ORIGIN_CONDITION,
	ORIGIN_SPELL,
	ORIGIN_MELEE,
	ORIGIN_RANGED,
	ORIGIN_REFLECT,
};

enum CallBackParam_t {
	CALLBACK_PARAM_LEVELMAGICVALUE,
	CALLBACK_PARAM_SKILLVALUE,
	CALLBACK_PARAM_TARGETTILE,
	CALLBACK_PARAM_TARGETCREATURE,
};

enum charm_t {
	CHARM_UNDEFINED = 0,
	CHARM_OFFENSIVE = 1,
	CHARM_DEFENSIVE = 2,
	CHARM_PASSIVE = 3,
};

enum SpeechBubble_t {
	SPEECHBUBBLE_NONE = 0,
	SPEECHBUBBLE_NORMAL = 1,
	SPEECHBUBBLE_TRADE = 2,
	SPEECHBUBBLE_QUEST = 3,
	SPEECHBUBBLE_QUESTTRADER = 4,
	SPEECHBUBBLE_HIRELING = 7,
};

enum MarketAction_t {
	MARKETACTION_BUY = 0,
	MARKETACTION_SELL = 1,
};

enum MarketRequest_t {
	MARKETREQUEST_OWN_HISTORY = 1,
	MARKETREQUEST_OWN_OFFERS = 2,
	MARKETREQUEST_ITEM_BROWSE = 3,
};

enum MarketOfferState_t {
	OFFERSTATE_ACTIVE = 0,
	OFFERSTATE_CANCELLED = 1,
	OFFERSTATE_EXPIRED = 2,
	OFFERSTATE_ACCEPTED = 3,

	OFFERSTATE_ACCEPTEDEX = 255,
};

enum ObjectCategory_t {
	OBJECTCATEGORY_NONE = 0,
	OBJECTCATEGORY_ARMORS = 1,
	OBJECTCATEGORY_NECKLACES = 2,
	OBJECTCATEGORY_BOOTS = 3,
	OBJECTCATEGORY_CONTAINERS = 4,
	OBJECTCATEGORY_DECORATION = 5,
	OBJECTCATEGORY_FOOD = 6,
	OBJECTCATEGORY_HELMETS = 7,
	OBJECTCATEGORY_LEGS = 8,
	OBJECTCATEGORY_OTHERS = 9,
	OBJECTCATEGORY_POTIONS = 10,
	OBJECTCATEGORY_RINGS = 11,
	OBJECTCATEGORY_RUNES = 12,
	OBJECTCATEGORY_SHIELDS = 13,
	OBJECTCATEGORY_TOOLS = 14,
	OBJECTCATEGORY_VALUABLES = 15,
	OBJECTCATEGORY_AMMO = 16,
	OBJECTCATEGORY_AXES = 17,
	OBJECTCATEGORY_CLUBS = 18,
	OBJECTCATEGORY_DISTANCEWEAPONS = 19,
	OBJECTCATEGORY_SWORDS = 20,
	OBJECTCATEGORY_WANDS = 21,
	OBJECTCATEGORY_PREMIUMSCROLLS = 22, // not used in quickloot
	OBJECTCATEGORY_TIBIACOINS = 23, // not used in quickloot
	OBJECTCATEGORY_CREATUREPRODUCTS = 24,
	OBJECTCATEGORY_STASHRETRIEVE = 27,
	OBJECTCATEGORY_GOLD = 30,
	OBJECTCATEGORY_DEFAULT = 31, // unassigned loot

	OBJECTCATEGORY_FIRST = OBJECTCATEGORY_ARMORS,
	OBJECTCATEGORY_LAST = OBJECTCATEGORY_DEFAULT,
};

enum RespawnPeriod_t {
	RESPAWNPERIOD_ALL,
	RESPAWNPERIOD_DAY,
	RESPAWNPERIOD_NIGHT
};

enum Slots_t : uint8_t {
	CONST_SLOT_WHEREEVER = 0,
	CONST_SLOT_HEAD = 1,
	CONST_SLOT_NECKLACE = 2,
	CONST_SLOT_BACKPACK = 3,
	CONST_SLOT_ARMOR = 4,
	CONST_SLOT_RIGHT = 5,
	CONST_SLOT_LEFT = 6,
	CONST_SLOT_LEGS = 7,
	CONST_SLOT_FEET = 8,
	CONST_SLOT_RING = 9,
	CONST_SLOT_AMMO = 10,
	CONST_SLOT_STORE_INBOX = 11,

	CONST_SLOT_FIRST = CONST_SLOT_HEAD,
	CONST_SLOT_LAST = CONST_SLOT_STORE_INBOX,
};

enum charmRune_t : int8_t {
	CHARM_NONE = -1,
	CHARM_WOUND = 0,
	CHARM_ENFLAME = 1,
	CHARM_POISON = 2,
	CHARM_FREEZE = 3,
	CHARM_ZAP = 4,
	CHARM_CURSE = 5,
	CHARM_CRIPPLE = 6,
	CHARM_PARRY = 7,
	CHARM_DODGE = 8,
	CHARM_ADRENALINE = 9,
	CHARM_NUMB = 10,
	CHARM_CLEANSE = 11,
	CHARM_BLESS = 12,
	CHARM_SCAVENGE = 13,
	CHARM_GUT = 14,
	CHARM_LOW = 15,
	CHARM_DIVINE = 16,
	CHARM_VAMP = 17,
	CHARM_VOID = 18,

	CHARM_LAST = CHARM_VOID,
};

enum ConditionId_t : int8_t {
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

enum PlayerSex_t : uint8_t {
	PLAYERSEX_FEMALE = 0,
	PLAYERSEX_MALE = 1,

	PLAYERSEX_LAST = PLAYERSEX_MALE
};

enum skills_t : int8_t {
	SKILL_NONE = -1,
	SKILL_FIST = 0,
	SKILL_CLUB = 1,
	SKILL_SWORD = 2,
	SKILL_AXE = 3,
	SKILL_DISTANCE = 4,
	SKILL_SHIELD = 5,
	SKILL_FISHING = 6,
	SKILL_CRITICAL_HIT_CHANCE = 7,
	SKILL_CRITICAL_HIT_DAMAGE = 8,
	SKILL_LIFE_LEECH_CHANCE = 9,
	SKILL_LIFE_LEECH_AMOUNT = 10,
	SKILL_MANA_LEECH_CHANCE = 11,
	SKILL_MANA_LEECH_AMOUNT = 12,

	SKILL_MAGLEVEL = 13,
	SKILL_LEVEL = 14,

	SKILL_FIRST = SKILL_FIST,
	SKILL_LAST = SKILL_MANA_LEECH_AMOUNT
};

enum CreatureType_t : uint8_t {
	CREATURETYPE_PLAYER = 0,
	CREATURETYPE_MONSTER = 1,
	CREATURETYPE_NPC = 2,
	CREATURETYPE_SUMMON_PLAYER = 3,
	CREATURETYPE_SUMMON_OTHERS = 4,
	CREATURETYPE_HIDDEN = 5,
};

enum SpellType_t : uint8_t {
	SPELL_UNDEFINED = 0,
	SPELL_INSTANT = 1,
	SPELL_RUNE = 2,
};

enum RaceType_t : uint8_t {
	RACE_NONE,
	RACE_VENOM,
	RACE_BLOOD,
	RACE_UNDEAD,
	RACE_FIRE,
	RACE_ENERGY,
	RACE_INK,
};

enum BlockType_t : uint8_t {
	BLOCK_NONE,
	BLOCK_DEFENSE,
	BLOCK_ARMOR,
	BLOCK_IMMUNITY,
	BLOCK_DODGE
};

enum BestiaryType_t : uint8_t {
	BESTY_RACE_NONE = 0,

	BESTY_RACE_AMPHIBIC = 1,
	BESTY_RACE_AQUATIC = 2,
	BESTY_RACE_BIRD = 3,
	BESTY_RACE_CONSTRUCT = 4,
	BESTY_RACE_DEMON = 5,
	BESTY_RACE_DRAGON = 6,
	BESTY_RACE_ELEMENTAL = 7,
	BESTY_RACE_EXTRA_DIMENSIONAL = 8,
	BESTY_RACE_FEY = 9,
	BESTY_RACE_GIANT = 10,
	BESTY_RACE_HUMAN = 11,
	BESTY_RACE_HUMANOID = 12,
	BESTY_RACE_LYCANTHROPE = 13,
	BESTY_RACE_MAGICAL = 14,
	BESTY_RACE_MAMMAL = 15,
	BESTY_RACE_PLANT = 16,
	BESTY_RACE_REPTILE = 17,
	BESTY_RACE_SLIME = 18,
	BESTY_RACE_UNDEAD = 19,
	BESTY_RACE_VERMIN = 20,

	BESTY_RACE_FIRST = BESTY_RACE_AMPHIBIC,
	BESTY_RACE_LAST = BESTY_RACE_VERMIN,
};

enum MonstersEvent_t : uint8_t {
	MONSTERS_EVENT_NONE = 0,
	MONSTERS_EVENT_THINK = 1,
	MONSTERS_EVENT_APPEAR = 2,
	MONSTERS_EVENT_DISAPPEAR = 3,
	MONSTERS_EVENT_MOVE = 4,
	MONSTERS_EVENT_SAY = 5,
};

enum NpcsEvent_t : uint8_t {
	NPCS_EVENT_NONE = 0,
	NPCS_EVENT_THINK = 1,
	NPCS_EVENT_APPEAR = 2,
	NPCS_EVENT_DISAPPEAR = 3,
	NPCS_EVENT_MOVE = 4,
	NPCS_EVENT_SAY = 5,
	NPCS_EVENT_PLAYER_BUY = 6,
	NPCS_EVENT_PLAYER_SELL = 7,
	NPCS_EVENT_PLAYER_CHECK_ITEM = 8,
	NPCS_EVENT_PLAYER_CLOSE_CHANNEL = 9
};

enum DailyRewardBonus : uint8_t {
	DAILY_REWARD_FIRST = 2,

	DAILY_REWARD_HP_REGENERATION = 2,
	DAILY_REWARD_MP_REGENERATION = 3,
	DAILY_REWARD_STAMINA_REGENERATION = 4,
	DAILY_REWARD_DOUBLE_HP_REGENERATION = 5,
	DAILY_REWARD_DOUBLE_MP_REGENERATION = 6,
	DAILY_REWARD_SOUL_REGENERATION = 7,

	DAILY_REWARD_LAST = 7,
};

enum DailyRewardStatus : uint8_t {
	DAILY_REWARD_COLLECTED = 0,
	DAILY_REWARD_NOTCOLLECTED = 1,
	DAILY_REWARD_NOTAVAILABLE = 2
};

enum class ForgeClassifications_t : uint8_t {
	FORGE_NORMAL_MONSTER = 0,
	FORGE_INFLUENCED_MONSTER = 1,
	FORGE_FIENDISH_MONSTER = 2,
};

enum OperatingSystem_t : uint8_t {
	CLIENTOS_NONE = 0,

	CLIENTOS_LINUX = 1,
	CLIENTOS_WINDOWS = 2,
	CLIENTOS_FLASH = 3,
	CLIENTOS_NEW_LINUX = 4,
	CLIENTOS_NEW_WINDOWS = 5,
	CLIENTOS_NEW_MAC = 6,

	CLIENTOS_OTCLIENT_LINUX = 10,
	CLIENTOS_OTCLIENT_WINDOWS = 11,
	CLIENTOS_OTCLIENT_MAC = 12,
};

enum SpellGroup_t : uint8_t {
	SPELLGROUP_NONE = 0,
	SPELLGROUP_ATTACK = 1,
	SPELLGROUP_HEALING = 2,
	SPELLGROUP_SUPPORT = 3,
	SPELLGROUP_SPECIAL = 4,
	SPELLGROUP_CONJURE = 5, // Deprecated
	SPELLGROUP_CRIPPLING = 6,
	SPELLGROUP_FOCUS = 7,
	SPELLGROUP_ULTIMATESTRIKES = 8,
};

enum ChannelEvent_t : uint8_t {
	CHANNELEVENT_JOIN = 0,
	CHANNELEVENT_LEAVE = 1,
	CHANNELEVENT_INVITE = 2,
	CHANNELEVENT_EXCLUDE = 3,
};

enum VipStatus_t : uint8_t {
	VIPSTATUS_OFFLINE = 0,
	VIPSTATUS_ONLINE = 1,
	VIPSTATUS_PENDING = 2,
	VIPSTATUS_TRAINING = 3
};

enum Vocation_t : uint16_t {
	VOCATION_NONE = 0,
	VOCATION_SORCERER = 1,
	VOCATION_DRUID = 2,
	VOCATION_PALADIN = 3,
	VOCATION_KNIGHT = 4,
	VOCATION_MASTER_SORCERER = 5,
	VOCATION_ELDER_DRUID = 6,
	VOCATION_ROYAL_PALADIN = 7,
	VOCATION_ELITE_KNIGHT = 8,
	VOCATION_LAST = VOCATION_ELITE_KNIGHT
};

enum FightMode_t : uint8_t {
	FIGHTMODE_ATTACK = 1,
	FIGHTMODE_BALANCED = 2,
	FIGHTMODE_DEFENSE = 3,
};

enum PvpMode_t : uint8_t {
	PVP_MODE_DOVE = 0,
	PVP_MODE_WHITE_HAND = 1,
	PVP_MODE_YELLOW_HAND = 2,
	PVP_MODE_RED_FIST = 3,
};

enum TradeState_t : uint8_t {
	TRADE_NONE,
	TRADE_INITIATED,
	TRADE_ACCEPT,
	TRADE_ACKNOWLEDGE,
	TRADE_TRANSFER,
};

enum CombatType_t : uint16_t {
	COMBAT_NONE = 0,

	COMBAT_PHYSICALDAMAGE = 1 << 0,
	COMBAT_ENERGYDAMAGE = 1 << 1,
	COMBAT_EARTHDAMAGE = 1 << 2,
	COMBAT_FIREDAMAGE = 1 << 3,
	COMBAT_UNDEFINEDDAMAGE = 1 << 4,
	COMBAT_LIFEDRAIN = 1 << 5,
	COMBAT_MANADRAIN = 1 << 6,
	COMBAT_HEALING = 1 << 7,
	COMBAT_DROWNDAMAGE = 1 << 8,
	COMBAT_ICEDAMAGE = 1 << 9,
	COMBAT_HOLYDAMAGE = 1 << 10,
	COMBAT_DEATHDAMAGE = 1 << 11,

	COMBAT_COUNT = 12
};

enum PlayerAsyncOngoingTaskFlags : uint64_t {
	PlayerAsyncTask_Highscore = 1 << 0,
	PlayerAsyncTask_RecentDeaths = 1 << 1,
	PlayerAsyncTask_RecentPvPKills = 1 << 2
};

enum PartyAnalyzer_t : uint8_t {
	MARKET_PRICE = 0,
	LEADER_PRICE = 1
};

enum WheelOfDestinyStage_t : uint8_t {
	WHEEL_OF_DESTINY_STAGE_GIFT_OF_LIFE = 0,
	WHEEL_OF_DESTINY_STAGE_COMBAT_MASTERY = 1,
	WHEEL_OF_DESTINY_STAGE_BLESSING_OF_THE_GROVE = 2,
	WHEEL_OF_DESTINY_STAGE_DRAIN_BODY = 3,
	WHEEL_OF_DESTINY_STAGE_BEAM_MASTERY = 4,
	WHEEL_OF_DESTINY_STAGE_DIVINE_EMPOWERMENT = 5,
	WHEEL_OF_DESTINY_STAGE_TWIN_BURST = 6,
	WHEEL_OF_DESTINY_STAGE_EXECUTIONERS_THROW = 7,
	WHEEL_OF_DESTINY_STAGE_AVATAR_OF_LIGHT = 8,
	WHEEL_OF_DESTINY_STAGE_AVATAR_OF_NATURE = 9,
	WHEEL_OF_DESTINY_STAGE_AVATAR_OF_STEEL = 10,
	WHEEL_OF_DESTINY_STAGE_AVATAR_OF_STORM = 11,

	WHEEL_OF_DESTINY_STAGE_COUNT = 12
};

enum WheelOfDestinyOnThink_t : uint8_t {
	WHEEL_OF_DESTINY_ONTHINK_BATTLE_INSTINCT = 0,
	WHEEL_OF_DESTINY_ONTHINK_POSITIONAL_TATICS = 1,
	WHEEL_OF_DESTINY_ONTHINK_BALLISTIC_MASTERY = 2,
	WHEEL_OF_DESTINY_ONTHINK_COMBAT_MASTERY = 3,
	WHEEL_OF_DESTINY_ONTHINK_FOCUS_MASTERY = 4,
	WHEEL_OF_DESTINY_ONTHINK_GIFT_OF_LIFE = 5,
	WHEEL_OF_DESTINY_ONTHINK_DIVINE_EMPOWERMENT = 6,
	WHEEL_OF_DESTINY_ONTHINK_AVATAR = 7,

	WHEEL_OF_DESTINY_ONTHINK_COUNT = 8
};

enum WheelOfDestinyStat_t : uint8_t {
	WHEEL_OF_DESTINY_STAT_HEALTH = 0,
	WHEEL_OF_DESTINY_STAT_MANA = 1,
	WHEEL_OF_DESTINY_STAT_CAPACITY = 2,
	WHEEL_OF_DESTINY_STAT_MITIGATION = 3,
	WHEEL_OF_DESTINY_STAT_MELEE = 4,
	WHEEL_OF_DESTINY_STAT_DISTANCE = 5,
	WHEEL_OF_DESTINY_STAT_MAGIC = 6,
	WHEEL_OF_DESTINY_STAT_LIFE_LEECH = 7,
	WHEEL_OF_DESTINY_STAT_MANA_LEECH = 8,
	WHEEL_OF_DESTINY_STAT_HEALING = 9,
	WHEEL_OF_DESTINY_STAT_DAMAGE = 10,
	WHEEL_OF_DESTINY_STAT_LIFE_LEECH_CHANCE = 11,
	WHEEL_OF_DESTINY_STAT_MANA_LEECH_CHANCE = 12,

	WHEEL_OF_DESTINY_STAT_COUNT = 13
};

enum WheelOfDestinyMajor_t : uint8_t {
	WHEEL_OF_DESTINY_MAJOR_MELEE = 0,
	WHEEL_OF_DESTINY_MAJOR_DISTANCE = 1,
	WHEEL_OF_DESTINY_MAJOR_SHIELD = 2,
	WHEEL_OF_DESTINY_MAJOR_MAGIC = 3,
	WHEEL_OF_DESTINY_MAJOR_HOLY_RESISTANCE = 4,
	WHEEL_OF_DESTINY_MAJOR_CRITICAL_DMG = 5,
	WHEEL_OF_DESTINY_MAJOR_PHYSICAL_DMG = 6,
	WHEEL_OF_DESTINY_MAJOR_HOLY_DMG = 7,
	WHEEL_OF_DESTINY_MAJOR_CRITICAL_DMG_2 = 8,
	WHEEL_OF_DESTINY_MAJOR_DEFENSE = 9,
	WHEEL_OF_DESTINY_MAJOR_DAMAGE = 10,

	WHEEL_OF_DESTINY_MAJOR_COUNT = 11
};

enum WheelOfDestinyInstant_t : uint8_t {
	WHEEL_OF_DESTINY_INSTANT_BATTLE_INSTINCT = 0,
	WHEEL_OF_DESTINY_INSTANT_BATTLE_HEALING = 1,
	WHEEL_OF_DESTINY_INSTANT_POSITIONAL_TATICS = 2,
	WHEEL_OF_DESTINY_INSTANT_BALLISTIC_MASTERY = 3,
	WHEEL_OF_DESTINY_INSTANT_HEALING_LINK = 4,
	WHEEL_OF_DESTINY_INSTANT_RUNIC_MASTERY = 5,
	WHEEL_OF_DESTINY_INSTANT_FOCUS_MASTERY = 6,

	WHEEL_OF_DESTINY_INSTANT_COUNT = 7
};

enum WheelOfDestinyAvatarSkill_t : uint8_t {
	WHEEL_OF_DESTINY_AVATAR_SKILL_NONE = 0,
	WHEEL_OF_DESTINY_AVATAR_SKILL_DAMAGE_REDUCTION = 1,
	WHEEL_OF_DESTINY_AVATAR_SKILL_CRITICAL_CHANCE = 2,
	WHEEL_OF_DESTINY_AVATAR_SKILL_CRITICAL_DAMAGE = 3
};

enum WheelOfDestinySpellGrade_t : uint8_t {
	WHEEL_OF_DESTINY_SPELL_GRADE_NONE = 0,
	WHEEL_OF_DESTINY_SPELL_GRADE_REGULAR = 1,
	WHEEL_OF_DESTINY_SPELL_GRADE_UPGRADED = 2,
	WHEEL_OF_DESTINY_SPELL_GRADE_MAX = 3 // This one is used only on LUA
};

enum WheelOfDestinySpellBoost_t : uint8_t {
	WHEEL_OF_DESTINY_SPELL_BOOST_MANA = 0,
	WHEEL_OF_DESTINY_SPELL_BOOST_COOLDOWN = 1,
	WHEEL_OF_DESTINY_SPELL_BOOST_GROUP_COOLDOWN = 2,
	WHEEL_OF_DESTINY_SPELL_BOOST_SECONDARY_GROUP_COOLDOWN = 3,
	WHEEL_OF_DESTINY_SPELL_BOOST_MANA_LEECH = 4,
	WHEEL_OF_DESTINY_SPELL_BOOST_MANA_LEECH_CHANCE = 5,
	WHEEL_OF_DESTINY_SPELL_BOOST_LIFE_LEECH = 6,
	WHEEL_OF_DESTINY_SPELL_BOOST_LIFE_LEECH_CHANCE = 7,
	WHEEL_OF_DESTINY_SPELL_BOOST_DAMAGE = 8,
	WHEEL_OF_DESTINY_SPELL_BOOST_DAMAGE_REDUCTION = 9,
	WHEEL_OF_DESTINY_SPELL_BOOST_HEAL = 10,
	WHEEL_OF_DESTINY_SPELL_BOOST_CRITICAL_DAMAGE = 11,
	WHEEL_OF_DESTINY_SPELL_BOOST_CRITICAL_CHANCE = 12,

	WHEEL_OF_DESTINY_SPELL_BOOST_COUNT = 13
};

// Structs
struct Position;

struct VIPEntry {
		VIPEntry(uint32_t initGuid, std::string initName, std::string initDescription, uint32_t initIcon, bool initNotify) :
			guid(initGuid),
			name(std::move(initName)),
			description(std::move(initDescription)),
			icon(initIcon),
			notify(initNotify) { }

		uint32_t guid;
		std::string name;
		std::string description;
		uint32_t icon;
		bool notify;
};

struct OutfitEntry {
		constexpr OutfitEntry(uint16_t initLookType, uint8_t initAddons) :
			lookType(initLookType), addons(initAddons) { }

		uint16_t lookType;
		uint8_t addons;
};

struct FamiliarEntry {
		constexpr explicit FamiliarEntry(uint16_t initLookType) :
			lookType(initLookType) { }
		uint16_t lookType;
};

struct Skill {
		uint64_t tries = 0;
		uint16_t level = 10;
		double_t percent = 0;
};

struct Kill {
		uint32_t target;
		time_t time;
		bool unavenged;

		Kill(uint32_t _target, time_t _time, bool _unavenged) :
			target(_target), time(_time), unavenged(_unavenged) { }
};

struct IntervalInfo {
		int32_t timeLeft;
		int32_t value;
		int32_t interval;
};

struct FindPathParams {
		bool fullPathSearch = true;
		bool clearSight = true;
		bool allowDiagonal = true;
		bool keepDistance = false;
		int32_t maxSearchDist = 0;
		int32_t minTargetDist = -1;
		int32_t maxTargetDist = -1;
};

struct RecentDeathEntry {
		RecentDeathEntry(std::string cause, uint32_t timestamp) :
			cause(std::move(cause)),
			timestamp(timestamp) { }

		std::string cause;
		uint32_t timestamp;
};

struct RecentPvPKillEntry {
		RecentPvPKillEntry(std::string description, uint32_t timestamp, uint8_t status) :
			description(std::move(description)),
			timestamp(timestamp),
			status(status) { }

		std::string description;
		uint32_t timestamp;
		uint8_t status;
};

struct MarketOffer {
		uint64_t price;
		uint32_t timestamp;
		uint16_t amount;
		uint16_t counter;
		uint16_t itemId;
		uint8_t tier;
		std::string playerName;
};

struct MarketOfferEx {
		MarketOfferEx() = default;
		MarketOfferEx(MarketOfferEx &&other) :
			id(other.id),
			playerId(other.playerId),
			timestamp(other.timestamp),
			price(other.price),
			amount(other.amount),
			counter(other.counter),
			itemId(other.itemId),
			type(other.type),
			tier(other.tier),
			playerName(std::move(other.playerName)) { }

		uint32_t id;
		uint32_t playerId;
		uint32_t timestamp;
		uint64_t price;
		uint16_t amount;
		uint16_t counter;
		uint16_t itemId;
		MarketAction_t type;
		uint8_t tier;
		std::string playerName;
};

struct HistoryMarketOffer {
		uint32_t timestamp;
		uint64_t price;
		uint16_t itemId;
		uint16_t amount;
		uint8_t tier;
		MarketOfferState_t state;
};

using MarketOfferList = std::list<MarketOffer>;
using HistoryMarketOfferList = std::list<HistoryMarketOffer>;
using StashItemList = std::map<uint16_t, uint32_t>;

using ItemsTierCountList = std::map<uint16_t, std::map<uint8_t, uint32_t>>;
/*
	> ItemsTierCountList structure:
	|- [itemID]
		|- [itemTier]
			|- Count
		| ...
	| ...
*/

struct Familiar {
		Familiar(std::string initName, uint16_t initLookType, bool initPremium, bool initUnlocked, std::string initType) :
			name(initName), lookType(initLookType),
			premium(initPremium), unlocked(initUnlocked),
			type(initType) { }

		std::string name;
		uint16_t lookType;
		bool premium;
		bool unlocked;
		std::string type;
};

struct ProtocolFamiliars {
		ProtocolFamiliars(const std::string &initName, uint16_t initLookType) :
			name(initName), lookType(initLookType) { }

		const std::string &name;
		uint16_t lookType;
};

struct LightInfo {
		uint8_t level = 0;
		uint8_t color = 215;
		constexpr LightInfo() = default;
		constexpr LightInfo(uint8_t newLevel, uint8_t newColor) :
			level(newLevel), color(newColor) { }
};

struct CombatDamage {
		struct {
				CombatType_t type;
				int32_t value;
		} primary, secondary;

		CombatOrigin origin;
		bool critical;
		int affected;
		bool extension;
		bool cleave;
		std::string exString;
		bool fatal;

		int32_t criticalDamage;
		int32_t criticalChance;
		int32_t damageMultiplier;
		int32_t damageReductionMultiplier;
		int32_t healingMultiplier;
		int32_t manaLeech;
		int32_t manaLeechChance;
		int32_t lifeLeech;
		int32_t lifeLeechChance;
		int32_t healingLink;

		std::string instantSpellName;
		std::string runeSpellName;

		CombatDamage() {
			origin = ORIGIN_NONE;
			primary.type = secondary.type = COMBAT_NONE;
			primary.value = secondary.value = 0;
			critical = false;
			affected = 1;
			extension = false;
			cleave = false;
			exString = "";
			fatal = false;
			criticalDamage = 0;
			criticalChance = 0;
			damageMultiplier = 0;
			damageReductionMultiplier = 0;
			healingMultiplier = 0;
			manaLeech = 0;
			manaLeechChance = 0;
			lifeLeech = 0;
			lifeLeechChance = 0;
			healingLink = 0;
			instantSpellName = "";
			runeSpellName = "";
		}
};

struct RespawnType {
		RespawnPeriod_t period;
		bool underground;
};

struct LootBlock;

struct LootBlock {
		uint16_t id;
		uint32_t countmax;
		uint32_t countmin;
		uint32_t chance;

		// optional
		int32_t subType;
		int32_t actionId;
		std::string text;
		std::string name;
		std::string article;
		int32_t attack;
		int32_t defense;
		int32_t extraDefense;
		int32_t armor;
		int32_t shootRange;
		int32_t hitChance;
		bool unique;

		std::vector<LootBlock> childLoot;
		LootBlock() {
			id = 0;
			countmax = 1;
			countmin = 1;
			chance = 0;

			subType = -1;
			actionId = -1;
			attack = -1;
			defense = -1;
			extraDefense = -1;
			armor = -1;
			shootRange = -1;
			hitChance = -1;
			unique = false;
		}
};

struct ShopBlock {
		uint16_t itemId;
		std::string itemName;
		int32_t itemSubType;
		uint32_t itemBuyPrice;
		uint32_t itemSellPrice;
		int32_t itemStorageKey;
		int32_t itemStorageValue;

		std::vector<ShopBlock> childShop;
		ShopBlock() {
			itemId = 0;
			itemName = "";
			itemSubType = 0;
			itemBuyPrice = 0;
			itemSellPrice = 0;
			itemStorageKey = 0;
			itemStorageValue = 0;
		}

		explicit ShopBlock(uint16_t newItemId, int32_t newSubType = 0, uint32_t newBuyPrice = 0, uint32_t newSellPrice = 0, int32_t newStorageKey = 0, int32_t newStorageValue = 0, std::string newName = "") :
			itemId(newItemId), itemSubType(newSubType), itemBuyPrice(newBuyPrice), itemSellPrice(newSellPrice), itemStorageKey(newStorageKey), itemStorageValue(newStorageValue), itemName(std::move(newName)) { }

		bool operator==(const ShopBlock &other) const {
			return itemId == other.itemId && itemName == other.itemName && itemSubType == other.itemSubType && itemBuyPrice == other.itemBuyPrice && itemSellPrice == other.itemSellPrice && itemStorageKey == other.itemStorageKey && itemStorageValue == other.itemStorageValue && childShop == other.childShop;
		}
};

struct summonBlock_t {
		std::string name;
		uint32_t chance;
		uint32_t speed;
		uint32_t count;
		bool force = false;
};

struct Outfit_t {
		uint16_t lookType = 0;
		uint16_t lookTypeEx = 0;
		uint16_t lookMount = 0;
		uint8_t lookHead = 0;
		uint8_t lookBody = 0;
		uint8_t lookLegs = 0;
		uint8_t lookFeet = 0;
		uint8_t lookAddons = 0;
		uint8_t lookMountHead = 0;
		uint8_t lookMountBody = 0;
		uint8_t lookMountLegs = 0;
		uint8_t lookMountFeet = 0;
		uint16_t lookFamiliarsType = 0;
};

struct voiceBlock_t {
		std::string text;
		bool yellText;
};

struct PartyAnalyzer {
		PartyAnalyzer(uint32_t playerId, std::string playerName) :
			id(playerId),
			name(std::move(playerName)) { }

		uint32_t id;

		std::string name;

		uint64_t damage = 0;
		uint64_t healing = 0;
		uint64_t lootPrice = 0;
		uint64_t supplyPrice = 0;

		std::map<uint16_t, uint64_t> lootMap; // [itemID] = amount
		std::map<uint16_t, uint64_t> supplyMap; // [itemID] = amount
};

#endif // SRC_CREATURES_CREATURES_DEFINITIONS_HPP_
