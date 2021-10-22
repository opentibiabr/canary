/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2018-2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * It under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#ifndef SRC_ITEMS_ITEMS_FUNCTIONS_ITEM_PARSE_HPP_
#define SRC_ITEMS_ITEMS_FUNCTIONS_ITEM_PARSE_HPP_

#include "creatures/combat/condition.h"
#include "declarations.hpp"
#include "items/item.h"
#include "items/items.h"
#include "utils/pugicast.h"

class ConditionDamage;

const std::unordered_map<std::string, ItemTypes_t> ItemTypesMap = {
	{"key", ITEM_TYPE_KEY},
	{"magicfield", ITEM_TYPE_MAGICFIELD},
	{"container", ITEM_TYPE_CONTAINER},
	{"depot", ITEM_TYPE_DEPOT},
	{"rewardchest", ITEM_TYPE_REWARDCHEST},
	{"carpet", ITEM_TYPE_CARPET},
	{"mailbox", ITEM_TYPE_MAILBOX},
	{"trashholder", ITEM_TYPE_TRASHHOLDER},
	{"teleport", ITEM_TYPE_TELEPORT},
	{"door", ITEM_TYPE_DOOR},
	{"bed", ITEM_TYPE_BED},
	{"rune", ITEM_TYPE_RUNE},
	{"supply", ITEM_TYPE_SUPPLY},
	{"creatureproduct", ITEM_TYPE_CREATUREPRODUCT},
	{"food", ITEM_TYPE_FOOD},
	{"valuable", ITEM_TYPE_VALUABLE},
	{"potion", ITEM_TYPE_POTION},
};

const std::unordered_map<std::string, TileFlags_t> TileStatesMap = {
	{"down", TILESTATE_FLOORCHANGE_DOWN},
	{"north", TILESTATE_FLOORCHANGE_NORTH},
	{"south", TILESTATE_FLOORCHANGE_SOUTH},
	{"southalt", TILESTATE_FLOORCHANGE_SOUTH_ALT},
	{"west", TILESTATE_FLOORCHANGE_WEST},
	{"east", TILESTATE_FLOORCHANGE_EAST},
	{"eastalt", TILESTATE_FLOORCHANGE_EAST_ALT},
};

const std::unordered_map<std::string, RaceType_t> RaceTypesMap = {
	{"venom", RACE_VENOM},
	{"blood", RACE_BLOOD},
	{"undead", RACE_UNDEAD},
	{"fire", RACE_FIRE},
	{"energy", RACE_ENERGY},
};

const std::unordered_map<std::string, FluidTypes_t> FluidTypesMap = {
	{"water", FLUID_WATER },
	{"blood", FLUID_BLOOD},
	{"beer", FLUID_BEER},
	{"slime", FLUID_SLIME},
	{"lemonade", FLUID_LEMONADE},
	{"milk", FLUID_MILK },
	{"mana", FLUID_MANA },
	{"life", FLUID_LIFE },
	{"oil", FLUID_OIL },
	{"urine", FLUID_URINE },
	{"coconut", FLUID_COCONUTMILK },
	{"wine", FLUID_WINE },
	{"mud", FLUID_MUD },
	{"fruitjuice", FLUID_FRUITJUICE },
	{"lava", FLUID_LAVA },
	{"rum", FLUID_RUM },
	{"swamp", FLUID_SWAMP },
	{"tea", FLUID_TEA },
	{"mead", FLUID_MEAD },
};

const std::unordered_map<std::string, WeaponType_t> WeaponTypesMap = {
	{"sword", WEAPON_SWORD},
	{"club", WEAPON_CLUB},
	{"axe", WEAPON_AXE},
	{"shield", WEAPON_SHIELD},
	{"distance", WEAPON_DISTANCE},
	{"wand", WEAPON_WAND},
	{"ammunition", WEAPON_AMMO},
	{"quiver", WEAPON_QUIVER},
};

class ItemParse
{
	public:
	ItemParse() = default;

	//non-copyable
	ItemParse(const ItemParse& other) = delete;
		ItemParse& operator=(const ItemParse& other) = delete;

	ItemParse(ItemParse&& other) = default;
	ItemParse& operator=(ItemParse&& other) = default;

	static void parseType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseDescription(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseRuneSpellName(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseWeight(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseShowCount(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseArmor(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseDefense(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseExtraDefense(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseAttack(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseRotateTo(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseWrapContainer(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseImbuingSlot(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseWrapableTo(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseMoveable(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parsePodium(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseBlockProjectTile(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parsePickupable(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseFloorChange(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseCorpseType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseContainerSize(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseFluidSource(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseWriteables(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseWeaponType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseSlotType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseAmmoType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseShootType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseMagicEffect(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseLootType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseRange(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseDuration(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseTransform(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseCharges(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseShowAttributes(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseHitChance(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseInvisible(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseSpeed(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseHealthAndMana(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseSkills(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseCriticalHit(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseLifeAndManaLeech(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseMaxHitAndManaPoints(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseMagicPoints(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseFieldAbsorbPercent(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseAbsorbPercent(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseSupressDrunk(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseField(std::string tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseReplaceable(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseLevelDoor(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseBeds(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseElement(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseWalk(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
	static void parseAllowDistanceRead(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType);
};

#endif  // SRC_ITEMS_ITEMS_FUNCTIONS_ITEM_PARSE_HPP_
