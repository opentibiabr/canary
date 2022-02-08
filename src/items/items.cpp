/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
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

#include "otpch.h"

#include "items/functions/item_parse.hpp"
#include "items/items.h"
#include "creatures/combat/spells.h"
#include "items/weapons/weapons.h"

#include "utils/pugicast.h"

#ifdef __cpp_lib_filesystem
#include <filesystem>
namespace fs = std::filesystem;
#else
#include <boost/filesystem.hpp>
namespace fs = boost::filesystem;
#endif

extern Weapons* g_weapons;

Items::Items(){}

void Items::clear()
{
	items.clear();
	reverseItemMap.clear();
	nameToItems.clear();
}

using LootTypeNames = std::unordered_map<std::string, ItemTypes_t>;

LootTypeNames lootTypeNames = {
	{"armor", ITEM_TYPE_ARMOR},
	{"amulet", ITEM_TYPE_AMULET},
	{"boots", ITEM_TYPE_BOOTS},
	{"container", ITEM_TYPE_CONTAINER},
	{"decoration", ITEM_TYPE_DECORATION},
	{"food", ITEM_TYPE_FOOD},
	{"helmet", ITEM_TYPE_HELMET},
	{"legs", ITEM_TYPE_LEGS},
	{"other", ITEM_TYPE_OTHER},
	{"potion", ITEM_TYPE_POTION},
	{"ring", ITEM_TYPE_RING},
	{"rune", ITEM_TYPE_RUNE},
	{"shield", ITEM_TYPE_SHIELD},
	{"tools", ITEM_TYPE_TOOLS},
	{"valuable", ITEM_TYPE_VALUABLE},
	{"ammo", ITEM_TYPE_AMMO},
	{"axe", ITEM_TYPE_AXE},
	{"club", ITEM_TYPE_CLUB},
	{"distance", ITEM_TYPE_DISTANCE},
	{"sword", ITEM_TYPE_SWORD},
	{"wand", ITEM_TYPE_WAND},
	{"creatureproduct", ITEM_TYPE_CREATUREPRODUCT},
	{"retrieve", ITEM_TYPE_RETRIEVE},
	{"gold", ITEM_TYPE_GOLD},
	{"unassigned", ITEM_TYPE_UNASSIGNED},
};

ItemTypes_t Items::getLootType(const std::string& strValue)
{
	auto lootType = lootTypeNames.find(strValue);
	if (lootType != lootTypeNames.end()) {
		return lootType->second;
	}
	return ITEM_TYPE_NONE;
}

bool Items::reload()
{
	clear();
	loadFromOtb("data/items/items.otb");

	if (!loadFromXml()) {
		return false;
	}

	g_weapons->loadDefaults();
	return true;
}

constexpr auto OTBI = OTB::Identifier{{'O','T', 'B', 'I'}};

FILELOADER_ERRORS Items::loadFromOtb(const std::string& file)
{
	if (!fs::exists(file)) {
		SPDLOG_ERROR("[Items::loadFromOtb] - Failed to load {}, file doesn't exist", file);
		return ERROR_NOT_OPEN;
	}

	OTB::Loader loader{file, OTBI};

	auto& root = loader.parseTree();

	PropStream props;
	if (loader.getProps(root, props)) {
		//4 byte flags
		//attributes
		//0x01 = version data
		uint32_t flags;
		if (!props.read<uint32_t>(flags)) {
			return ERROR_INVALID_FORMAT;
		}

		uint8_t attr;
		if (!props.read<uint8_t>(attr)) {
			return ERROR_INVALID_FORMAT;
		}

		if (attr == ROOT_ATTR_VERSION) {
			uint16_t datalen;
			if (!props.read<uint16_t>(datalen)) {
				return ERROR_INVALID_FORMAT;
			}

			if (datalen != sizeof(VERSIONINFO)) {
				return ERROR_INVALID_FORMAT;
			}

			VERSIONINFO vi;
			if (!props.read(vi)) {
				return ERROR_INVALID_FORMAT;
			}

			majorVersion = vi.dwMajorVersion; //items otb format file version
			minorVersion = vi.dwMinorVersion; //client version
			buildNumber = vi.dwBuildNumber; //revision
		}
	}

	if (majorVersion == 0xFFFFFFFF) {
		SPDLOG_WARN("[Items::loadFromOtb] - items.otb using generic client version");
	} else if (majorVersion != 3) {
		SPDLOG_ERROR("[Items::loadFromOtb] - "
                     "Old version detected, a newer version of items.otb is required");
		return ERROR_INVALID_FORMAT;
	} else if (minorVersion < CLIENT_VERSION_1285) {
		SPDLOG_ERROR("[Items::loadFromOtb] - "
                     "A newer version of items.otb is required");
		return ERROR_INVALID_FORMAT;
	}

	for (auto & itemNode : root.children) {
		PropStream stream;
		if (!loader.getProps(itemNode, stream)) {
			return ERROR_INVALID_FORMAT;
		}

		uint32_t flags;
		if (!stream.read<uint32_t>(flags)) {
			return ERROR_INVALID_FORMAT;
		}

		uint16_t serverId = 0;
		uint16_t clientId = 0;
		uint16_t speed = 0;
		uint16_t wareId = 0;
		uint8_t lightLevel = 0;
		uint8_t lightColor = 0;
		uint8_t alwaysOnTopOrder = 0;
		bool isPodium = false;

		if (clientId == 35973 || clientId == 35974) {
			isPodium = true;
		}

		uint8_t attrib;
		while (stream.read<uint8_t>(attrib)) {
			uint16_t datalen;
			if (!stream.read<uint16_t>(datalen)) {
				return ERROR_INVALID_FORMAT;
			}

			switch (attrib) {
				case ITEM_ATTR_SERVERID: {
					if (datalen != sizeof(uint16_t)) {
						return ERROR_INVALID_FORMAT;
					}

					if (!stream.read<uint16_t>(serverId)) {
						return ERROR_INVALID_FORMAT;
					}

					break;
				}

				case ITEM_ATTR_CLIENTID: {
					if (datalen != sizeof(uint16_t)) {
						return ERROR_INVALID_FORMAT;
					}

					if (!stream.read<uint16_t>(clientId)) {
						return ERROR_INVALID_FORMAT;
					}
					break;
				}

				case ITEM_ATTR_SPEED: {
					if (datalen != sizeof(uint16_t)) {
						return ERROR_INVALID_FORMAT;
					}

					if (!stream.read<uint16_t>(speed)) {
						return ERROR_INVALID_FORMAT;
					}
					break;
				}

				case ITEM_ATTR_LIGHT2: {
					if (datalen != sizeof(lightBlock2)) {
						return ERROR_INVALID_FORMAT;
					}

					lightBlock2 lb2;
					if (!stream.read(lb2)) {
						return ERROR_INVALID_FORMAT;
					}

					lightLevel = static_cast<uint8_t>(lb2.lightLevel);
					lightColor = static_cast<uint8_t>(lb2.lightColor);
					break;
				}

				case ITEM_ATTR_TOPORDER: {
					if (datalen != sizeof(uint8_t)) {
						return ERROR_INVALID_FORMAT;
					}

					if (!stream.read<uint8_t>(alwaysOnTopOrder)) {
						return ERROR_INVALID_FORMAT;
					}
					break;
				}

				case ITEM_ATTR_WAREID: {
					if (datalen != sizeof(uint16_t)) {
						return ERROR_INVALID_FORMAT;
					}

					if (!stream.read<uint16_t>(wareId)) {
						return ERROR_INVALID_FORMAT;
					}
					break;
				}

				default: {
					//skip unknown attributes
					if (!stream.skip(datalen)) {
						return ERROR_INVALID_FORMAT;
					}
					break;
				}
			}
		}

		reverseItemMap.emplace(clientId, serverId);

		// store the found item
		if (serverId >= items.size()) {
			items.resize(serverId + 1);
		}
		ItemType& iType = items[serverId];

		iType.group = static_cast<ItemGroup_t>(itemNode.type);
		switch (itemNode.type) {
			case ITEM_GROUP_CONTAINER:
				iType.type = ITEM_TYPE_CONTAINER;
				break;
			case ITEM_GROUP_DOOR:
				//not used
				iType.type = ITEM_TYPE_DOOR;
				break;
			// ITEM_GROUP_MAGICFIELD is Deprecated
			case ITEM_GROUP_MAGICFIELD:
				//not used
				iType.type = ITEM_TYPE_MAGICFIELD;
				break;
			case ITEM_GROUP_TELEPORT:
				//not used
				iType.type = ITEM_TYPE_TELEPORT;
				break;
			case ITEM_GROUP_NONE:
			case ITEM_GROUP_GROUND:
			case ITEM_GROUP_SPLASH:
			case ITEM_GROUP_FLUID:
			case ITEM_GROUP_CHARGES:
			case ITEM_GROUP_DEPRECATED:
				break;
			default:
				return ERROR_INVALID_FORMAT;
		}

		iType.blockSolid = hasBitSet(FLAG_BLOCK_SOLID, flags);
		iType.blockProjectile = hasBitSet(FLAG_BLOCK_PROJECTILE, flags);
		iType.blockPathFind = hasBitSet(FLAG_BLOCK_PATHFIND, flags);
		iType.hasHeight = hasBitSet(FLAG_HAS_HEIGHT, flags);
		iType.useable = hasBitSet(FLAG_USEABLE, flags);
		iType.pickupable = hasBitSet(FLAG_PICKUPABLE, flags);
		iType.moveable = hasBitSet(FLAG_MOVEABLE, flags);
		iType.wrapContainer = hasBitSet(FLAG_WRAPCONTAINER, flags);
		iType.stackable = hasBitSet(FLAG_STACKABLE, flags);

		iType.alwaysOnTop = hasBitSet(FLAG_ALWAYSONTOP, flags);
		iType.isVertical = hasBitSet(FLAG_VERTICAL, flags);
		iType.isHorizontal = hasBitSet(FLAG_HORIZONTAL, flags);
		iType.isHangable = hasBitSet(FLAG_HANGABLE, flags);
		iType.allowDistRead = hasBitSet(FLAG_ALLOWDISTREAD, flags);
		iType.rotatable = hasBitSet(FLAG_ROTATABLE, flags);
		iType.canReadText = hasBitSet(FLAG_READABLE, flags);
		iType.lookThrough = hasBitSet(FLAG_LOOKTHROUGH, flags);
		iType.isAnimation = hasBitSet(FLAG_ANIMATION, flags);
		// iType.walkStack = !hasBitSet(FLAG_FULLTILE, flags);
		iType.forceUse = hasBitSet(FLAG_FORCEUSE, flags);

		iType.id = serverId;
		iType.clientId = clientId;
		iType.speed = speed;
		iType.lightLevel = lightLevel;
		iType.lightColor = lightColor;
		iType.wareId = wareId;
		iType.alwaysOnTopOrder = alwaysOnTopOrder;
	}

	items.shrink_to_fit();
	return ERROR_NONE;
}

bool Items::loadFromXml()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/items/items.xml");
	if (!result) {
		printXMLError("Error - Items::loadFromXml", "data/items/items.xml", result);
		return false;
	}

	for (auto itemNode : doc.child("items").children()) {
		pugi::xml_attribute idAttribute = itemNode.attribute("id");
		if (idAttribute) {
			parseItemNode(itemNode, pugi::cast<uint16_t>(idAttribute.value()));
			continue;
		}

		pugi::xml_attribute fromIdAttribute = itemNode.attribute("fromid");
		if (!fromIdAttribute) {
			if (idAttribute) {
				SPDLOG_WARN("[Items::loadFromXml] - "
                            "No item id: {} found",
                            idAttribute.value());
			} else {
				SPDLOG_WARN("[Items::loadFromXml] - No item id found");
			}
			continue;
		}

		pugi::xml_attribute toIdAttribute = itemNode.attribute("toid");
		if (!toIdAttribute) {
			SPDLOG_WARN("[Items::loadFromXml] - "
                        "tag fromid: {} without toid",
                        fromIdAttribute.value());
			continue;
		}

		uint16_t id = pugi::cast<uint16_t>(fromIdAttribute.value());
		uint16_t toId = pugi::cast<uint16_t>(toIdAttribute.value());
		while (id <= toId) {
			parseItemNode(itemNode, id++);
		}
	}
	return true;
}

void Items::buildInventoryList()
{
	inventory.reserve(items.size());
	for (const auto& type: items) {
		if (type.weaponType != WEAPON_NONE || type.ammoType != AMMO_NONE ||
			type.attack != 0 || type.defense != 0 ||
			type.extraDefense != 0 || type.armor != 0 ||
			type.slotPosition & SLOTP_NECKLACE ||
			type.slotPosition & SLOTP_RING ||
			type.slotPosition & SLOTP_AMMO ||
			type.slotPosition & SLOTP_FEET ||
			type.slotPosition & SLOTP_HEAD ||
			type.slotPosition & SLOTP_ARMOR ||
			type.slotPosition & SLOTP_LEGS)
		{
			inventory.push_back(type.clientId);
		}
	}
	inventory.shrink_to_fit();
	std::sort(inventory.begin(), inventory.end());
}

void Items::parseItemNode(const pugi::xml_node & itemNode, uint16_t id) {
	if (id >= items.size()) {
		items.resize(id + 1);
	}
	ItemType & iType = items[id];
	iType.id = id;

	ItemType & itemType = getItemType(id);
	if (itemType.id == 0) {
		return;
	}

	if (!itemType.name.empty()) {
		SPDLOG_WARN("[Items::parseItemNode] - Duplicate item with id: {}", id);
		return;
	}

	itemType.name = itemNode.attribute("name").as_string();

	nameToItems.insert({
		asLowerCaseString(itemType.name),
		id
	});

	pugi::xml_attribute articleAttribute = itemNode.attribute("article");
	if (articleAttribute) {
		itemType.article = articleAttribute.as_string();
	}

	pugi::xml_attribute pluralAttribute = itemNode.attribute("plural");
	if (pluralAttribute) {
		itemType.pluralName = pluralAttribute.as_string();
	}

	for (auto attributeNode : itemNode.children()) {
		pugi::xml_attribute keyAttribute = attributeNode.attribute("key");
		if (!keyAttribute) {
			continue;
		}

		pugi::xml_attribute valueAttribute = attributeNode.attribute("value");
		if (!valueAttribute) {
			continue;
		}

		std::string tmpStrValue = asLowerCaseString(keyAttribute.as_string());
		auto parseAttribute = ItemParseAttributesMap.find(tmpStrValue);
		if (parseAttribute != ItemParseAttributesMap.end()) {
			ItemParse::initParse(tmpStrValue, attributeNode, keyAttribute, valueAttribute, itemType);
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown key value: {}",
                        keyAttribute.as_string());
		}
	}

	// Check bed items
	if ((itemType.transformToFree != 0 || itemType.transformToOnUse[PLAYERSEX_FEMALE] != 0 || itemType.transformToOnUse[PLAYERSEX_MALE] != 0) && itemType.type != ITEM_TYPE_BED) {
		SPDLOG_WARN("[Items::parseItemNode] - Item {} is not set as a bed-type", itemType.id);
	}
}

ItemType& Items::getItemType(size_t id)
{
	if (id < items.size()) {
		return items[id];
	}
	return items.front();
}

const ItemType& Items::getItemType(size_t id) const
{
	if (id < items.size()) {
		return items[id];
	}
	return items.front();
}

const ItemType& Items::getItemIdByClientId(uint16_t spriteId) const
{
	auto it = reverseItemMap.find(spriteId);
	if (it != reverseItemMap.end()) {
		return getItemType(it->second);
	}
	return items.front();
}

uint16_t Items::getItemIdByName(const std::string& name)
{
	auto result = nameToItems.find(asLowerCaseString(name));

	if (result == nameToItems.end())
		return 0;

	return result->second;
}
