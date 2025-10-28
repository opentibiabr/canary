/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/combat/condition.hpp"
#include "declarations.hpp"
#include "items/item.hpp"
#include "items/items.hpp"

class ConditionDamage;

const phmap::flat_hash_map<std::string, ItemParseAttributes_t> ItemParseAttributesMap = {
	{ "type", ITEM_PARSE_TYPE },
	{ "description", ITEM_PARSE_DESCRIPTION },
	{ "runespellname", ITEM_PARSE_RUNESPELLNAME },
	{ "weight", ITEM_PARSE_WEIGHT },
	{ "showcount", ITEM_PARSE_SHOWCOUNT },
	{ "armor", ITEM_PARSE_ARMOR },
	{ "defense", ITEM_PARSE_DEFENSE },
	{ "extradef", ITEM_PARSE_EXTRADEF },
	{ "attack", ITEM_PARSE_ATTACK },
	{ "rotateto", ITEM_PARSE_ROTATETO },
	{ "wrapcontainer", ITEM_PARSE_WRAPCONTAINER },
	{ "wrapableto", ITEM_PARSE_WRAPABLETO },
	{ "unwrapableto", ITEM_PARSE_WRAPABLETO },
	{ "movable", ITEM_PARSE_MOVABLE },
	{ "movable", ITEM_PARSE_MOVABLE },
	{ "blockprojectile", ITEM_PARSE_BLOCKPROJECTILE },
	{ "allowpickupable", ITEM_PARSE_PICKUPABLE },
	{ "pickupable", ITEM_PARSE_PICKUPABLE },
	{ "floorchange", ITEM_PARSE_FLOORCHANGE },
	{ "containersize", ITEM_PARSE_CONTAINERSIZE },
	{ "fluidsource", ITEM_PARSE_FLUIDSOURCE },
	{ "readable", ITEM_PARSE_READABLE },
	{ "writeable", ITEM_PARSE_WRITEABLE },
	{ "maxtextlen", ITEM_PARSE_MAXTEXTLEN },
	{ "writeonceitemid", ITEM_PARSE_WRITEONCEITEMID },
	{ "weapontype", ITEM_PARSE_WEAPONTYPE },
	{ "slottype", ITEM_PARSE_SLOTTYPE },
	{ "ammotype", ITEM_PARSE_AMMOTYPE },
	{ "shoottype", ITEM_PARSE_SHOOTTYPE },
	{ "effect", ITEM_PARSE_EFFECT },
	{ "loottype", ITEM_PARSE_LOOTTYPE },
	{ "range", ITEM_PARSE_RANGE },
	{ "stopduration", ITEM_PARSE_STOPDURATION },
	{ "decayto", ITEM_PARSE_DECAYTO },
	{ "transformequipto", ITEM_PARSE_TRANSFORMEQUIPTO },
	{ "transformdeequipto", ITEM_PARSE_TRANSFORMDEEQUIPTO },
	{ "duration", ITEM_PARSE_DURATION },
	{ "showduration", ITEM_PARSE_SHOWDURATION },
	{ "charges", ITEM_PARSE_CHARGES },
	{ "showcharges", ITEM_PARSE_SHOWCHARGES },
	{ "showattributes", ITEM_PARSE_SHOWATTRIBUTES },
	{ "hitchance", ITEM_PARSE_HITCHANCE },
	{ "maxhitchance", ITEM_PARSE_MAXHITCHANCE },
	{ "invisible", ITEM_PARSE_INVISIBLE },
	{ "speed", ITEM_PARSE_SPEED },
	{ "healthgain", ITEM_PARSE_HEALTHGAIN },
	{ "healthticks", ITEM_PARSE_HEALTHTICKS },
	{ "managain", ITEM_PARSE_MANAGAIN },
	{ "manaticks", ITEM_PARSE_MANATICKS },
	{ "manashield", ITEM_PARSE_MANASHIELD },
	{ "skillsword", ITEM_PARSE_SKILLSWORD },
	{ "skillaxe", ITEM_PARSE_SKILLAXE },
	{ "skillclub", ITEM_PARSE_SKILLCLUB },
	{ "skilldist", ITEM_PARSE_SKILLDIST },
	{ "skillfish", ITEM_PARSE_SKILLFISH },
	{ "skillshield", ITEM_PARSE_SKILLSHIELD },
	{ "skillfist", ITEM_PARSE_SKILLFIST },
	{ "criticalhitchance", ITEM_PARSE_CRITICALHITCHANCE },
	{ "criticalhitdamage", ITEM_PARSE_CRITICALHITDAMAGE },
	{ "lifeleechchance", ITEM_PARSE_LIFELEECHCHANCE },
	{ "lifeleechamount", ITEM_PARSE_LIFELEECHAMOUNT },
	{ "manaleechchance", ITEM_PARSE_MANALEECHCHANCE },
	{ "manaleechamount", ITEM_PARSE_MANALEECHAMOUNT },
	{ "maxhitpoints", ITEM_PARSE_MAXHITPOINTS },
	{ "maxhitpointspercent", ITEM_PARSE_MAXHITPOINTSPERCENT },
	{ "maxmanapoints", ITEM_PARSE_MAXMANAPOINTS },
	{ "maxmanapointspercent", ITEM_PARSE_MAXMANAPOINTSPERCENT },
	{ "magiclevelpoints", ITEM_PARSE_MAGICLEVELPOINTS },
	{ "magicpoints", ITEM_PARSE_MAGICLEVELPOINTS },
	{ "magicpointspercent", ITEM_PARSE_MAGICLEVELPOINTSPERCENT },
	{ "fieldabsorbpercentenergy", ITEM_PARSE_FIELDABSORBPERCENTENERGY },
	{ "fieldabsorbpercentfire", ITEM_PARSE_FIELDABSORBPERCENTFIRE },
	{ "fieldabsorbpercentpoison", ITEM_PARSE_FIELDABSORBPERCENTPOISON },
	{ "fieldabsorbpercentearth", ITEM_PARSE_FIELDABSORBPERCENTPOISON },
	{ "absorbpercentall", ITEM_PARSE_ABSORBPERCENTALL },
	{ "absorbpercentallelements", ITEM_PARSE_ABSORBPERCENTELEMENTS },
	{ "absorbpercentelements", ITEM_PARSE_ABSORBPERCENTELEMENTS },
	{ "absorbpercentmagic", ITEM_PARSE_ABSORBPERCENTMAGIC },
	{ "absorbpercentenergy", ITEM_PARSE_ABSORBPERCENTENERGY },
	{ "absorbpercentfire", ITEM_PARSE_ABSORBPERCENTFIRE },
	{ "absorbpercentpoison", ITEM_PARSE_ABSORBPERCENTPOISON },
	{ "absorbpercentearth", ITEM_PARSE_ABSORBPERCENTPOISON },
	{ "absorbpercentice", ITEM_PARSE_ABSORBPERCENTICE },
	{ "absorbpercentholy", ITEM_PARSE_ABSORBPERCENTHOLY },
	{ "absorbpercentdeath", ITEM_PARSE_ABSORBPERCENTDEATH },
	{ "absorbpercentlifedrain", ITEM_PARSE_ABSORBPERCENTLIFEDRAIN },
	{ "absorbpercentmanadrain", ITEM_PARSE_ABSORBPERCENTMANADRAIN },
	{ "absorbpercentdrown", ITEM_PARSE_ABSORBPERCENTDROWN },
	{ "absorbpercentphysical", ITEM_PARSE_ABSORBPERCENTPHYSICAL },
	{ "absorbpercenthealing", ITEM_PARSE_ABSORBPERCENTHEALING },
	{ "suppressdrunk", ITEM_PARSE_SUPPRESSDRUNK },
	{ "suppressenergy", ITEM_PARSE_SUPPRESSENERGY },
	{ "suppressfire", ITEM_PARSE_SUPPRESSFIRE },
	{ "suppresspoison", ITEM_PARSE_SUPPRESSPOISON },
	{ "suppressdrown", ITEM_PARSE_SUPPRESSDROWN },
	{ "suppressphysical", ITEM_PARSE_SUPPRESSPHYSICAL },
	{ "suppressfreeze", ITEM_PARSE_SUPPRESSFREEZE },
	{ "suppressdazzle", ITEM_PARSE_SUPPRESSDAZZLE },
	{ "suppresscurse", ITEM_PARSE_SUPPRESSCURSE },
	{ "field", ITEM_PARSE_FIELD },
	{ "replaceable", ITEM_PARSE_REPLACEABLE },
	{ "partnerdirection", ITEM_PARSE_PARTNERDIRECTION },
	{ "leveldoor", ITEM_PARSE_LEVELDOOR },
	{ "maletransformto", ITEM_PARSE_MALETRANSFORMTO },
	{ "malesleeper", ITEM_PARSE_MALETRANSFORMTO },
	{ "femaletransformto", ITEM_PARSE_FEMALETRANSFORMTO },
	{ "femalesleeper", ITEM_PARSE_FEMALETRANSFORMTO },
	{ "bedpart", ITEM_PARSE_PARTNERDIRECTION },
	{ "bedpartof", ITEM_PARSE_PARTNERDIRECTION },
	{ "transformonuse", ITEM_PARSE_TRANSFORMONUSE },
	{ "destroyto", ITEM_PARSE_DESTROYTO },
	{ "elementice", ITEM_PARSE_ELEMENTICE },
	{ "elementearth", ITEM_PARSE_ELEMENTEARTH },
	{ "elementfire", ITEM_PARSE_ELEMENTFIRE },
	{ "elementenergy", ITEM_PARSE_ELEMENTENERGY },
	{ "elementdeath", ITEM_PARSE_ELEMENTDEATH },
	{ "elementholy", ITEM_PARSE_ELEMENTHOLY },
	{ "walkstack", ITEM_PARSE_WALKSTACK },
	{ "blocking", ITEM_PARSE_BLOCK_SOLID },
	{ "allowdistread", ITEM_PARSE_ALLOWDISTREAD },
	{ "imbuementslot", ITEM_PARSE_IMBUEMENT },
	{ "stacksize", ITEM_PARSE_STACKSIZE },
	// 12.72 modifiers
	{ "deathmagiclevelpoints", ITEM_PARSE_DEATHMAGICLEVELPOINTS },
	{ "energymagiclevelpoints", ITEM_PARSE_ENERGYMAGICLEVELPOINTS },
	{ "earthmagiclevelpoints", ITEM_PARSE_EARTHMAGICLEVELPOINTS },
	{ "firemagiclevelpoints", ITEM_PARSE_EARTHMAGICLEVELPOINTS },
	{ "icemagiclevelpoints", ITEM_PARSE_ICEMAGICLEVELPOINTS },
	{ "holymagiclevelpoints", ITEM_PARSE_HOLYMAGICLEVELPOINTS },
	{ "healingmagiclevelpoints", ITEM_PARSE_HEALINGMAGICLEVELPOINTS },
	{ "physicalmagiclevelpoints", ITEM_PARSE_PHYSICALMAGICLEVELPOINTS },
	{ "magicshieldcapacitypercent", ITEM_PARSE_MAGICSHIELDCAPACITYPERCENT },
	{ "magicshieldcapacityflat", ITEM_PARSE_MAGICSHIELDCAPACITYFLAT },
	{ "perfectshotdamage", ITEM_PARSE_PERFECTSHOTDAMAGE },
	{ "perfectshotrange", ITEM_PARSE_PERFECTSHOTRANGE },
	{ "cleavepercent", ITEM_PARSE_CLEAVEPERCENT },
	{ "reflectdamage", ITEM_PARSE_REFLECTDAMAGE },
	{ "reflectpercentall", ITEM_PARSE_REFLECTPERCENTALL },
	{ "primarytype", ITEM_PARSE_PRIMARYTYPE },
	{ "usedbyhouseguests", ITEM_PARSE_USEDBYGUESTS },
	{ "script", ITEM_PARSE_SCRIPT },
	{ "augments", ITEM_PARSE_AUGMENT },
	{ "elementalbond", ITEM_PARSE_ELEMENTALBOND },
	{ "mantra", ITEM_PARSE_MANTRA },
};

const phmap::flat_hash_map<std::string, ItemTypes_t> ItemTypesMap = {
	{ "key", ITEM_TYPE_KEY },
	{ "magicfield", ITEM_TYPE_MAGICFIELD },
	{ "container", ITEM_TYPE_CONTAINER },
	{ "depot", ITEM_TYPE_DEPOT },
	{ "rewardchest", ITEM_TYPE_REWARDCHEST },
	{ "carpet", ITEM_TYPE_CARPET },
	{ "mailbox", ITEM_TYPE_MAILBOX },
	{ "trashholder", ITEM_TYPE_TRASHHOLDER },
	{ "teleport", ITEM_TYPE_TELEPORT },
	{ "door", ITEM_TYPE_DOOR },
	{ "bed", ITEM_TYPE_BED },
	{ "rune", ITEM_TYPE_RUNE },
	{ "supply", ITEM_TYPE_SUPPLY },
	{ "creatureproduct", ITEM_TYPE_CREATUREPRODUCT },
	{ "food", ITEM_TYPE_FOOD },
	{ "valuable", ITEM_TYPE_VALUABLE },
	{ "potion", ITEM_TYPE_POTION },
	{ "soulcore", ITEM_TYPE_SOULCORES },
	{ "ladder", ITEM_TYPE_LADDER },
	{ "dummy", ITEM_TYPE_DUMMY },
};

const phmap::flat_hash_map<std::string, TileFlags_t> TileStatesMap = {
	{ "down", TILESTATE_FLOORCHANGE_DOWN },
	{ "north", TILESTATE_FLOORCHANGE_NORTH },
	{ "south", TILESTATE_FLOORCHANGE_SOUTH },
	{ "southalt", TILESTATE_FLOORCHANGE_SOUTH_ALT },
	{ "west", TILESTATE_FLOORCHANGE_WEST },
	{ "east", TILESTATE_FLOORCHANGE_EAST },
	{ "eastalt", TILESTATE_FLOORCHANGE_EAST_ALT },
};

const phmap::flat_hash_map<std::string, Fluids_t> FluidTypesMap = {
	{ "water", FLUID_WATER },
	{ "blood", FLUID_BLOOD },
	{ "beer", FLUID_BEER },
	{ "slime", FLUID_SLIME },
	{ "lemonade", FLUID_LEMONADE },
	{ "milk", FLUID_MILK },
	{ "mana", FLUID_MANA },
	{ "life", FLUID_LIFE },
	{ "oil", FLUID_OIL },
	{ "urine", FLUID_URINE },
	{ "coconut", FLUID_COCONUTMILK },
	{ "wine", FLUID_WINE },
	{ "mud", FLUID_MUD },
	{ "fruitjuice", FLUID_FRUITJUICE },
	{ "rum", FLUID_RUM },
	{ "tea", FLUID_TEA },
	{ "mead", FLUID_MEAD },
	{ "ink", FLUID_INK },
	{ "candyfluid", FLUID_CANDY },
	{ "chocolate", FLUID_CHOCOLATE },
};

const phmap::flat_hash_map<std::string, WeaponType_t> WeaponTypesMap = {
	{ "sword", WEAPON_SWORD },
	{ "club", WEAPON_CLUB },
	{ "axe", WEAPON_AXE },
	{ "shield", WEAPON_SHIELD },
	{ "spellbook", WEAPON_SHIELD },
	{ "distance", WEAPON_DISTANCE },
	{ "wand", WEAPON_WAND },
	{ "ammunition", WEAPON_AMMO },
	{ "missile", WEAPON_MISSILE },
	{ "fist", WEAPON_FIST }
};

const phmap::flat_hash_map<std::string, ImbuementTypes_t> ImbuementsTypeMap = {
	{ "elemental damage", IMBUEMENT_ELEMENTAL_DAMAGE },
	{ "life leech", IMBUEMENT_LIFE_LEECH },
	{ "mana leech", IMBUEMENT_MANA_LEECH },
	{ "critical hit", IMBUEMENT_CRITICAL_HIT },
	{ "elemental protection death", IMBUEMENT_ELEMENTAL_PROTECTION_DEATH },
	{ "elemental protection earth", IMBUEMENT_ELEMENTAL_PROTECTION_EARTH },
	{ "elemental protection fire", IMBUEMENT_ELEMENTAL_PROTECTION_FIRE },
	{ "elemental protection ice", IMBUEMENT_ELEMENTAL_PROTECTION_ICE },
	{ "elemental protection energy", IMBUEMENT_ELEMENTAL_PROTECTION_ENERGY },
	{ "elemental protection holy", IMBUEMENT_ELEMENTAL_PROTECTION_HOLY },
	{ "increase speed", IMBUEMENT_INCREASE_SPEED },
	{ "skillboost axe", IMBUEMENT_SKILLBOOST_AXE },
	{ "skillboost sword", IMBUEMENT_SKILLBOOST_SWORD },
	{ "skillboost club", IMBUEMENT_SKILLBOOST_CLUB },
	{ "skillboost shielding", IMBUEMENT_SKILLBOOST_SHIELDING },
	{ "skillboost distance", IMBUEMENT_SKILLBOOST_DISTANCE },
	{ "skillboost magic level", IMBUEMENT_SKILLBOOST_MAGIC_LEVEL },
	{ "increase capacity", IMBUEMENT_INCREASE_CAPACITY },
	{ "skillboost fist", IMBUEMENT_SKILLBOOST_FIST },
};

const phmap::flat_hash_map<Augment_t, ConfigKey_t> AugmentWithoutValueDescriptionDefaultKeys = {
	{ Augment_t::IncreasedDamage, AUGMENT_INCREASED_DAMAGE_PERCENT },
	{ Augment_t::PowerfulImpact, AUGMENT_POWERFUL_IMPACT_PERCENT },
	{ Augment_t::StrongImpact, AUGMENT_STRONG_IMPACT_PERCENT },
};

class ItemParse : public Items {
public:
	static void initParse(const std::string &stringValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType);

private:
	static void parseDummyRate(pugi::xml_node attributeNode, ItemType &itemType);
	static void parseType(const std::string &stringValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseDescription(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseRuneSpellName(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseWeight(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseShowCount(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseArmor(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseDefense(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseExtraDefense(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseAttack(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseRotateTo(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseWrapContainer(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseWrapableTo(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseMovable(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseBlockProjectTile(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parsePickupable(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseFloorChange(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseContainerSize(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseFluidSource(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseWriteables(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseWeaponType(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseSlotType(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseAmmoType(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseShootType(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseMagicEffect(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseLootType(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseRange(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseDecayTo(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseDuration(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseTransform(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseCharges(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseShowAttributes(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseHitChance(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseInvisible(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseSpeed(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseHealthAndMana(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseSkills(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseCriticalHit(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseLifeAndManaLeech(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseMaxHitAndManaPoints(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseMagicLevelPoint(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseFieldAbsorbPercent(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseAbsorbPercent(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseSupressDrunk(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseField(const std::string &stringValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseReplaceable(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseLevelDoor(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseBeds(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseElement(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseWalk(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseAllowDistanceRead(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseImbuement(const std::string &stringValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseAugment(const std::string &stringValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseStackSize(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseSpecializedMagicLevelPoint(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseMagicShieldCapacity(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parsePerfecShot(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseCleavePercent(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseReflectDamage(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseTransformOnUse(std::string_view stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parsePrimaryType(std::string_view stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseHouseRelated(std::string_view stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseUnscriptedItems(std::string_view stringValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseMantra(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
	static void parseElementalBond(const std::string &stringValue, pugi::xml_attribute valueAttribute, ItemType &itemType);

private:
	// Parent of the function: static void parseField
	static std::tuple<ConditionId_t, ConditionType_t> parseFieldConditions(pugi::xml_attribute valueAttribute);
	static CombatType_t parseFieldCombatType(pugi::xml_attribute valueAttribute);
	static void parseFieldCombatDamage(const std::shared_ptr<ConditionDamage> &conditionDamage, pugi::xml_node attributeNode);
	static void createAndRegisterScript(ItemType &itemType, pugi::xml_node attributeNode, MoveEvent_t eventType = MOVE_EVENT_NONE, WeaponType_t weaponType = WEAPON_NONE);
};
