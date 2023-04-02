/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/functions/item/item_parse.hpp"
#include "items/items.h"
#include "items/weapons/weapons.h"
#include "game/game.h"
#include "utils/pugicast.h"

Items::Items() = default;

void Items::clear() {
	items.clear();
	nameToItems.clear();
}

using LootTypeNames = phmap::flat_hash_map<std::string, ItemTypes_t>;

LootTypeNames lootTypeNames = {
	{ "armor", ITEM_TYPE_ARMOR },
	{ "amulet", ITEM_TYPE_AMULET },
	{ "boots", ITEM_TYPE_BOOTS },
	{ "container", ITEM_TYPE_CONTAINER },
	{ "decoration", ITEM_TYPE_DECORATION },
	{ "food", ITEM_TYPE_FOOD },
	{ "helmet", ITEM_TYPE_HELMET },
	{ "legs", ITEM_TYPE_LEGS },
	{ "other", ITEM_TYPE_OTHER },
	{ "potion", ITEM_TYPE_POTION },
	{ "ring", ITEM_TYPE_RING },
	{ "rune", ITEM_TYPE_RUNE },
	{ "shield", ITEM_TYPE_SHIELD },
	{ "tools", ITEM_TYPE_TOOLS },
	{ "valuable", ITEM_TYPE_VALUABLE },
	{ "ammo", ITEM_TYPE_AMMO },
	{ "axe", ITEM_TYPE_AXE },
	{ "club", ITEM_TYPE_CLUB },
	{ "distance", ITEM_TYPE_DISTANCE },
	{ "sword", ITEM_TYPE_SWORD },
	{ "wand", ITEM_TYPE_WAND },
	{ "creatureproduct", ITEM_TYPE_CREATUREPRODUCT },
	{ "retrieve", ITEM_TYPE_RETRIEVE },
	{ "gold", ITEM_TYPE_GOLD },
	{ "unassigned", ITEM_TYPE_UNASSIGNED },
};

ItemTypes_t Items::getLootType(const std::string &strValue) {
	auto lootType = lootTypeNames.find(strValue);
	if (lootType != lootTypeNames.end()) {
		return lootType->second;
	}
	return ITEM_TYPE_NONE;
}

bool Items::reload() {
	clear();
	loadFromProtobuf();

	if (!loadFromXml()) {
		return false;
	}

	return true;
}

void Items::loadFromProtobuf() {
	using namespace Canary::protobuf::appearances;

	for (uint32_t it = 0; it < g_game().appearances.object_size(); ++it) {
		Appearance object = g_game().appearances.object(it);

		// This scenario should never happen but on custom assets this can break the loader.
		if (!object.has_flags()) {
			SPDLOG_WARN("[Items::loadFromProtobuf] - Item with id '{}' is invalid and was ignored.", object.id());
			continue;
		}

		if (object.id() >= items.size()) {
			items.resize(object.id() + 1);
		}

		if (!object.has_id()) {
			continue;
		}

		ItemType &iType = items[object.id()];
		if (object.flags().container()) {
			iType.type = ITEM_TYPE_CONTAINER;
			iType.group = ITEM_GROUP_CONTAINER;
		} else if (object.flags().has_bank()) {
			iType.group = ITEM_GROUP_GROUND;
		} else if (object.flags().liquidcontainer()) {
			iType.group = ITEM_GROUP_FLUID;
		} else if (object.flags().liquidpool()) {
			iType.group = ITEM_GROUP_SPLASH;
		}

		if (object.flags().clip()) {
			iType.alwaysOnTopOrder = 1;
		} else if (object.flags().top()) {
			iType.alwaysOnTopOrder = 3;
		} else if (object.flags().bottom()) {
			iType.alwaysOnTopOrder = 2;
		}

		if (object.flags().has_clothes()) {
			iType.slotPosition |= static_cast<SlotPositionBits>(1 << (object.flags().clothes().slot() - 1));
		}

		if (object.flags().has_market()) {
			iType.type = static_cast<ItemTypes_t>(object.flags().market().category());
		}

		iType.name = object.name();
		iType.description = object.description();

		iType.upgradeClassification = object.flags().has_upgradeclassification() ? static_cast<uint8_t>(object.flags().upgradeclassification().upgrade_classification()) : 0;
		iType.lightLevel = object.flags().has_light() ? static_cast<uint8_t>(object.flags().light().brightness()) : 0;
		iType.lightColor = object.flags().has_light() ? static_cast<uint8_t>(object.flags().light().color()) : 0;

		iType.id = static_cast<uint16_t>(object.id());
		iType.speed = object.flags().has_bank() ? static_cast<uint16_t>(object.flags().bank().waypoints()) : 0;
		iType.wareId = object.flags().has_market() ? static_cast<uint16_t>(object.flags().market().trade_as_object_id()) : 0;

		iType.isCorpse = object.flags().corpse() || object.flags().player_corpse();
		iType.forceUse = object.flags().forceuse();
		iType.hasHeight = object.flags().has_height();
		iType.blockSolid = object.flags().unpass();
		iType.blockProjectile = object.flags().unsight();
		iType.blockPathFind = object.flags().avoid();
		iType.pickupable = object.flags().take();
		iType.rotatable = object.flags().rotate();
		iType.wrapContainer = object.flags().wrap() || object.flags().unwrap();
		iType.multiUse = object.flags().multiuse();
		iType.moveable = object.flags().unmove() == false;
		iType.canReadText = (object.flags().has_lenshelp() && object.flags().lenshelp().id() == 1112) || (object.flags().has_write() && object.flags().write().max_text_length() != 0) || (object.flags().has_write_once() && object.flags().write_once().max_text_length_once() != 0);
		iType.canReadText = object.flags().has_write() || object.flags().has_write_once();
		iType.isVertical = object.flags().has_hook() && object.flags().hook().direction() == HOOK_TYPE_SOUTH;
		iType.isHorizontal = object.flags().has_hook() && object.flags().hook().direction() == HOOK_TYPE_EAST;
		iType.isHangable = object.flags().hang();
		iType.lookThrough = object.flags().ignore_look();
		iType.stackable = object.flags().cumulative();
		iType.isPodium = object.flags().show_off_socket();
		iType.wearOut = object.flags().wearout();
		iType.clockExpire = object.flags().clockexpire();
		iType.expire = object.flags().expire();
		iType.expireStop = object.flags().expirestop();

		if (!iType.name.empty()) {
			nameToItems.insert({ asLowerCaseString(iType.name),
								 iType.id });
		}
	}

	items.shrink_to_fit();
}

bool Items::loadFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY) + "/items/items.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (auto itemNode : doc.child("items").children()) {
		if (auto idAttribute = itemNode.attribute("id")) {
			parseItemNode(itemNode, pugi::cast<uint16_t>(idAttribute.value()));
			continue;
		}

		auto fromIdAttribute = itemNode.attribute("fromid");
		if (!fromIdAttribute) {
			SPDLOG_WARN("[Items::loadFromXml] - No item id found, use id or fromid");
			continue;
		}

		auto toIdAttribute = itemNode.attribute("toid");
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

void Items::buildInventoryList() {
	inventory.reserve(items.size());
	for (const auto &type : items) {
		if (type.weaponType != WEAPON_NONE || type.ammoType != AMMO_NONE || type.attack != 0 || type.defense != 0 || type.extraDefense != 0 || type.armor != 0 || type.slotPosition & SLOTP_NECKLACE || type.slotPosition & SLOTP_RING || type.slotPosition & SLOTP_AMMO || type.slotPosition & SLOTP_FEET || type.slotPosition & SLOTP_HEAD || type.slotPosition & SLOTP_ARMOR || type.slotPosition & SLOTP_LEGS) {
			inventory.push_back(type.id);
		}
	}
	inventory.shrink_to_fit();
	std::sort(inventory.begin(), inventory.end());
}

void Items::parseItemNode(const pugi::xml_node &itemNode, uint16_t id) {
	if (id >= items.size()) {
		items.resize(id + 1);
	}
	ItemType &iType = items[id];
	if (iType.id == 0 && (iType.name.empty() || iType.name == asLowerCaseString("reserved sprite"))) {
		return;
	}

	iType.id = id;

	ItemType &itemType = getItemType(id);
	if (itemType.id == 0) {
		return;
	}

	if (itemType.loaded) {
		SPDLOG_WARN("[Items::parseItemNode] - Duplicate item with id: {}", id);
		return;
	}

	if (std::string xmlName = itemNode.attribute("name").as_string();
		!xmlName.empty() && itemType.name != xmlName) {
		if (!itemType.name.empty()) {
			if (auto it = std::find_if(nameToItems.begin(), nameToItems.end(), [id](const auto nameMapIt) {
					return nameMapIt.second == id;
				});
				it != nameToItems.end()) {
				nameToItems.erase(it);
			}
		}

		itemType.name = xmlName;
		nameToItems.insert({ asLowerCaseString(itemType.name),
							 id });
	}

	itemType.loaded = true;
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
			ItemParse::initParse(tmpStrValue, attributeNode, valueAttribute, itemType);
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown key value: {}", keyAttribute.as_string());
		}
	}

	// Check bed items
	if ((itemType.transformToFree != 0 || itemType.transformToOnUse[PLAYERSEX_FEMALE] != 0 || itemType.transformToOnUse[PLAYERSEX_MALE] != 0) && itemType.type != ITEM_TYPE_BED) {
		SPDLOG_WARN("[Items::parseItemNode] - Item {} is not set as a bed-type", itemType.id);
	}
}

ItemType &Items::getItemType(size_t id) {
	if (id < items.size()) {
		return items[id];
	}
	return items.front();
}

const ItemType &Items::getItemType(size_t id) const {
	if (id < items.size()) {
		return items[id];
	}
	return items.front();
}

uint16_t Items::getItemIdByName(const std::string &name) {
	auto result = nameToItems.find(asLowerCaseString(name));

	if (result == nameToItems.end())
		return 0;

	return result->second;
}

bool Items::hasItemType(size_t hasId) const {
	if (hasId < items.size()) {
		return true;
	}
	return false;
}
