/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_ITEMS_FUNCTIONS_ITEM_ITEM_PARSE_HPP_
#define SRC_ITEMS_FUNCTIONS_ITEM_ITEM_PARSE_HPP_

#include "creatures/combat/condition.h"
#include "declarations.hpp"
#include "items/item.h"
#include "items/items.h"

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
	{ "moveable", ITEM_PARSE_MOVEABLE },
	{ "movable", ITEM_PARSE_MOVEABLE },
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
	{ "magicpoints", ITEM_PARSE_MAGICPOINTS },
	{ "magicpointspercent", ITEM_PARSE_MAGICPOINTSPERCENT },
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
	{ "perfectshotdamage", ITEM_PARSE_PERFECTSHOTDAMAGE },
	{ "perfectshotrange", ITEM_PARSE_PERFECTSHOTRANGE },
	{ "deathmagiclevelpoints", ITEM_PARSE_DEATHMAGICLEVELPOINTS },
	{ "energymagiclevelpoints", ITEM_PARSE_PERFECTSHOTRANGE },
	{ "earthmagiclevelpoints", ITEM_PARSE_EARTHMAGICLEVELPOINTS },
	{ "firemagiclevelpoints", ITEM_PARSE_FIREMAGICLEVELPOINTS },
	{ "holymagiclevelpoints", ITEM_PARSE_HEALINGMAGICLEVELPOINTS },
	{ "healingmagiclevelpoints", ITEM_PARSE_HOLYMAGICLEVELPOINTS },
	{ "icemagiclevelpoints", ITEM_PARSE_ICEMAGICLEVELPOINTS },
	{ "physicalmagiclevelpoints", ITEM_PARSE_PHYSICALMAGICLEVELPOINTS },
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
	{ "transformto", ITEM_PARSE_TRANSFORMTO },
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
	{ "damagereflection", ITEM_PARSE_DAMAGE_REFLECTION },
	{ "magicshieldcapacitypercent", ITEM_PARSE_MAGIC_SHIELD_CAPACITY_PERCENT },
	{ "magicshieldcapacityflat", ITEM_PARSE_MAGIC_SHIELD_CAPACITY_FLAT },
	{ "cleavepercent", ITEM_PARSE_CLEAVE },
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
};

const phmap::flat_hash_map<std::string, WeaponType_t> WeaponTypesMap = {
	{ "sword", WEAPON_SWORD },
	{ "club", WEAPON_CLUB },
	{ "axe", WEAPON_AXE },
	{ "shield", WEAPON_SHIELD },
	{ "spellbook", WEAPON_SHIELD },
	{ "distance", WEAPON_DISTANCE },
	{ "wand", WEAPON_WAND },
	{ "ammunition", WEAPON_AMMO }
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
	{ "increase capacity", IMBUEMENT_INCREASE_CAPACITY }
};

class ItemParse : public Items {
	public:
		static void initParse(const std::string &tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType);

	protected:
		static void parseType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseDescription(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseRuneSpellName(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseWeight(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseShowCount(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseArmor(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseDefense(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseExtraDefense(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseAttack(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseRotateTo(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseWrapContainer(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseWrapableTo(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseMoveable(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseBlockProjectTile(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parsePickupable(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseFloorChange(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseContainerSize(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseFluidSource(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseWriteables(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseWeaponType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseSlotType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseAmmoType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseShootType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseMagicEffect(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseLootType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseRange(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseDecayTo(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseDuration(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseTransform(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseCharges(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseShowAttributes(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseHitChance(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseInvisible(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseSpeed(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseHealthAndMana(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseSkills(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseCriticalHit(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseLifeAndManaLeech(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseMaxHitAndManaPoints(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseMagicPoints(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseFieldAbsorbPercent(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseAbsorbPercent(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseSupressDrunk(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseElementalMagicLevel(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parsePerfectShotDamage(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parsePerfectShotRange(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseField(const std::string &tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseReplaceable(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseLevelDoor(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseBeds(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseElement(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseWalk(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseAllowDistanceRead(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseImbuement(const std::string &tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseDamageReflection(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseMagicShieldCapacity(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);
		static void parseCleave(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType);

	private:
		// Parent of the function: static void parseField
		static std::tuple<ConditionId_t, ConditionType_t> parseFieldConditions(std::string lowerStringValue, pugi::xml_attribute valueAttribute);
		static CombatType_t parseFieldCombatType(std::string string, pugi::xml_attribute valueAttribute);
		static void parseFieldCombatDamage(ConditionDamage* conditionDamage, std::string stringValue, pugi::xml_node attributeNode);
};

#endif // SRC_ITEMS_FUNCTIONS_ITEM_PARSE_HPP_
