/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/functions/item/item_parse.hpp"
#include "items/items.hpp"
#include "items/weapons/weapons.hpp"
#include "lua/creature/movement.hpp"
#include "game/game.hpp"
#include "utils/pugicast.hpp"
#include "core.hpp"

#include <appearances.pb.h>

Items::Items() = default;

void Items::clear() {
	items.clear();
	ladders.clear();
	dummys.clear();
	nameToItems.clear();
	g_moveEvents().clear(true);
	g_weapons().clear(true);
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
#if CLIENT_VERSION < 1100
	loadFromOtb("data/items/items.otb");
#else
	loadFromProtobuf();
#endif

	if (!loadFromXml()) {
		return false;
	}

	return true;
}

void Items::loadFromProtobuf() {
	using namespace Canary::protobuf::appearances;

	bool supportAnimation = g_configManager().getBoolean(OLD_PROTOCOL, __FUNCTION__);
	for (uint32_t it = 0; it < g_game().m_appearancesPtr->object_size(); ++it) {
		Appearance object = g_game().m_appearancesPtr->object(it);

		// This scenario should never happen but on custom assets this can break the loader.
		if (!object.has_flags()) {
			g_logger().warn("[Items::loadFromProtobuf] - Item with id '{}' is invalid and was ignored.", object.id());
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

		// This attribute is only used on 10x protocol, so we should not waste our time iterating it when it's disabled.
		if (supportAnimation) {
			for (uint32_t frame_it = 0; frame_it < object.frame_group_size(); ++frame_it) {
				FrameGroup objectFrame = object.frame_group(frame_it);
				if (!objectFrame.has_sprite_info()) {
					continue;
				}

				if (!objectFrame.sprite_info().has_animation()) {
					continue;
				}

				if (objectFrame.sprite_info().animation().random_start_phase()) {
					iType.animationType = ANIMATION_RANDOM;
				} else {
					iType.animationType = ANIMATION_DESYNC;
				}
			}
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
		if (iType.wrapContainer) {
			iType.wrapableTo = ITEM_DECORATION_KIT;
			iType.wrapable = true;
		}
		iType.multiUse = object.flags().multiuse();
		iType.movable = object.flags().unmove() == false;
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
		iType.isWrapKit = object.flags().wrapkit();

		if (!iType.name.empty()) {
			nameToItems.insert({ asLowerCaseString(iType.name), iType.id });
		}
	}

	items.shrink_to_fit();
}

#if CLIENT_VERSION < 1100
constexpr auto OTBI = OTB::Identifier { { 'O', 'T', 'B', 'I' } };

enum rootattrib_ {
	ROOT_ATTR_VERSION = 0x01,
};

struct VERSIONINFO {
	uint32_t dwMajorVersion;
	uint32_t dwMinorVersion;
	uint32_t dwBuildNumber;
	uint8_t CSDVersion[128];
};

enum OtbItemAttribute_t {
	ITEM_ATTR_FIRST = 0x10,
	ITEM_ATTR_SERVERID = ITEM_ATTR_FIRST,
	ITEM_ATTR_CLIENTID,
	ITEM_ATTR_NAME,
	ITEM_ATTR_DESCR,
	ITEM_ATTR_SPEED,
	ITEM_ATTR_SLOT,
	ITEM_ATTR_MAXITEMS,
	ITEM_ATTR_WEIGHT,
	ITEM_ATTR_WEAPON,
	ITEM_ATTR_AMMO,
	ITEM_ATTR_ARMOR,
	ITEM_ATTR_MAGLEVEL,
	ITEM_ATTR_MAGFIELDTYPE,
	ITEM_ATTR_WRITEABLE,
	ITEM_ATTR_ROTATETO,
	ITEM_ATTR_DECAY,
	ITEM_ATTR_SPRITEHASH,
	ITEM_ATTR_MINIMAPCOLOR,
	ITEM_ATTR_07,
	ITEM_ATTR_08,
	ITEM_ATTR_LIGHT,

	// 1-byte aligned
	ITEM_ATTR_DECAY2,
	ITEM_ATTR_WEAPON2,
	ITEM_ATTR_AMMO2,
	ITEM_ATTR_ARMOR2,
	ITEM_ATTR_WRITEABLE2,
	ITEM_ATTR_LIGHT2,
	ITEM_ATTR_TOPORDER,
	ITEM_ATTR_WRITEABLE3,

	ITEM_ATTR_WAREID,

	ITEM_ATTR_LAST
};

enum OtbItemFlags_t {
	FLAG_BLOCK_SOLID = 1 << 0,
	FLAG_BLOCK_PROJECTILE = 1 << 1,
	FLAG_BLOCK_PATHFIND = 1 << 2,
	FLAG_HAS_HEIGHT = 1 << 3,
	FLAG_USEABLE = 1 << 4,
	FLAG_PICKUPABLE = 1 << 5,
	FLAG_MOVEABLE = 1 << 6,
	FLAG_STACKABLE = 1 << 7,
	FLAG_FLOORCHANGEDOWN = 1 << 8,
	FLAG_FLOORCHANGENORTH = 1 << 9,
	FLAG_FLOORCHANGEEAST = 1 << 10,
	FLAG_FLOORCHANGESOUTH = 1 << 11,
	FLAG_FLOORCHANGEWEST = 1 << 12,
	FLAG_ALWAYSONTOP = 1 << 13,
	FLAG_READABLE = 1 << 14,
	FLAG_ROTATABLE = 1 << 15,
	FLAG_HANGABLE = 1 << 16,
	FLAG_VERTICAL = 1 << 17,
	FLAG_HORIZONTAL = 1 << 18,
	FLAG_CANNOTDECAY = 1 << 19,
	FLAG_ALLOWDISTREAD = 1 << 20,
	FLAG_UNUSED = 1 << 21, // unused
	FLAG_CLIENTCHARGES = 1 << 22, /* deprecated */
	FLAG_LOOKTHROUGH = 1 << 23,
	FLAG_ANIMATION = 1 << 24,
	FLAG_FULLTILE = 1 << 25, // unused
	FLAG_FORCEUSE = 1 << 26,
};

struct OtbLightBlock {
	uint16_t lightLevel;
	uint16_t lightColor;
};

enum slotsOTB_t {
	OTB_SLOT_DEFAULT,
	OTB_SLOT_HEAD,
	OTB_SLOT_BODY,
	OTB_SLOT_LEGS,
	OTB_SLOT_BACKPACK,
	OTB_SLOT_WEAPON,
	OTB_SLOT_2HAND,
	OTB_SLOT_FEET,
	OTB_SLOT_AMULET,
	OTB_SLOT_RING,
	OTB_SLOT_HAND,
};

enum subfightOTB_t {
	OTB_DIST_NONE,
	OTB_DIST_BOLT,
	OTB_DIST_ARROW,
	OTB_DIST_FIRE,
	OTB_DIST_ENERGY,
	OTB_DIST_POISONARROW,
	OTB_DIST_BURSTARROW,
	OTB_DIST_THROWINGSTAR,
	OTB_DIST_THROWINGKNIFE,
	OTB_DIST_SMALLSTONE,
	OTB_DIST_SUDDENDEATH,
	OTB_DIST_LARGEROCK,
	OTB_DIST_SNOWBALL,
	OTB_DIST_POWERBOLT,
	OTB_DIST_SPEAR,
	OTB_DIST_POISONFIELD
};

struct weaponBlock {
	uint8_t weaponType;
	uint8_t ammoType;
	uint8_t shootType;
	uint8_t attack;
	uint8_t defense;
};

struct ammoBlock {
	uint8_t ammoType;
	uint8_t shootType;
	uint8_t attack;
};

struct armorBlock {
	uint16_t armor;
	double weight;
	uint16_t slotPosition;
};

struct decayBlock {
	uint16_t decayTo;
	uint16_t decayTime;
};

bool Items::loadFromOtb(const std::string &file) {
	if (!std::filesystem::exists(file)) {
		std::cout << "[Fatal Error - Items::loadFromOtb] Failed to load " << file << ": File doesn't exist." << std::endl;
		return false;
	}

	OTB::Loader loader { file, OTBI };
	auto &root = loader.parseTree();

	PropStream props;
	if (loader.getProps(root, props)) {
		// 4 byte flags
		// attributes
		// 0x01 = version data
		uint32_t flags;
		if (!props.read<uint32_t>(flags)) {
			return false;
		}

		uint8_t attr;
		if (!props.read<uint8_t>(attr)) {
			return false;
		}

		if (attr == ROOT_ATTR_VERSION) {
			uint16_t datalen;
			if (!props.read<uint16_t>(datalen)) {
				return false;
			}

			if (datalen != sizeof(VERSIONINFO)) {
				return false;
			}

			VERSIONINFO vi;
			if (!props.read(vi)) {
				return false;
			}

			majorVersion = vi.dwMajorVersion; // items otb format file version
			minorVersion = vi.dwMinorVersion; // client version
			buildNumber = vi.dwBuildNumber; // revision
		}
	}

	if (majorVersion == 0xFFFFFFFF) {
		g_logger().warn("Items::loadFromOtb] items.otb using generic client version.");
	}

	for (auto &itemNode : root.children) {
		PropStream stream;
		if (!loader.getProps(itemNode, stream)) {
			return false;
		}

		uint32_t flags;
		if (!stream.read<uint32_t>(flags)) {
			return false;
		}

		uint16_t serverId = 0;
		uint16_t clientId = 0;
		uint16_t speed = 0;
		uint16_t wareId = 0;
		uint8_t lightLevel = 0;
		uint8_t lightColor = 0;
		uint8_t alwaysOnTopOrder = 0;

		uint8_t attrib;
		while (stream.read<uint8_t>(attrib)) {
			uint16_t datalen;
			if (!stream.read<uint16_t>(datalen)) {
				return false;
			}

			switch (attrib) {
				case ITEM_ATTR_SERVERID: {
					if (datalen != sizeof(uint16_t)) {
						return false;
					}

					if (!stream.read<uint16_t>(serverId)) {
						return false;
					}
					break;
				}

				case ITEM_ATTR_CLIENTID: {
					if (datalen != sizeof(uint16_t)) {
						return false;
					}

					if (!stream.read<uint16_t>(clientId)) {
						return false;
					}
					break;
				}

				case ITEM_ATTR_SPEED: {
					if (datalen != sizeof(uint16_t)) {
						return false;
					}

					if (!stream.read<uint16_t>(speed)) {
						return false;
					}
					break;
				}

				case ITEM_ATTR_LIGHT2: {
					if (datalen != sizeof(OtbLightBlock)) {
						return false;
					}

					OtbLightBlock light;
					if (!stream.read(light)) {
						return false;
					}

					lightLevel = static_cast<uint8_t>(light.lightLevel);
					lightColor = static_cast<uint8_t>(light.lightColor);
					break;
				}

				case ITEM_ATTR_TOPORDER: {
					if (datalen != sizeof(uint8_t)) {
						return false;
					}

					if (!stream.read<uint8_t>(alwaysOnTopOrder)) {
						return false;
					}
					break;
				}

				case ITEM_ATTR_WAREID: {
					if (datalen != sizeof(uint16_t)) {
						return false;
					}

					if (!stream.read<uint16_t>(wareId)) {
						return false;
					}
					break;
				}

				default: {
					// skip unknown attributes
					if (!stream.skip(datalen)) {
						return false;
					}
					break;
				}
			}
		}

		// store the found item
		if (clientId >= items.size()) {
			items.resize(clientId + 1);
		}
		ItemType &iType = items[clientId];

		iType.group = static_cast<ItemGroup_t>(itemNode.type);
		switch (itemNode.type) {
			case ITEM_GROUP_CONTAINER:
				iType.type = ITEM_TYPE_CONTAINER;
				break;
			case ITEM_GROUP_DOOR:
				// not used
				iType.type = ITEM_TYPE_DOOR;
				break;
			case ITEM_GROUP_MAGICFIELD:
				// not used
				iType.type = ITEM_TYPE_MAGICFIELD;
				break;
			case ITEM_GROUP_TELEPORT:
				// not used
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
				return false;
		}

		iType.blockSolid = hasBitSet(FLAG_BLOCK_SOLID, flags);
		iType.blockProjectile = hasBitSet(FLAG_BLOCK_PROJECTILE, flags);
		iType.blockPathFind = hasBitSet(FLAG_BLOCK_PATHFIND, flags);
		iType.hasHeight = hasBitSet(FLAG_HAS_HEIGHT, flags);
		iType.multiUse = hasBitSet(FLAG_USEABLE, flags);
		iType.pickupable = hasBitSet(FLAG_PICKUPABLE, flags);
		iType.movable = hasBitSet(FLAG_MOVEABLE, flags);
		iType.stackable = hasBitSet(FLAG_STACKABLE, flags);

		iType.alwaysOnTopOrder = hasBitSet(FLAG_ALWAYSONTOP, flags);
		iType.isVertical = hasBitSet(FLAG_VERTICAL, flags);
		iType.isHorizontal = hasBitSet(FLAG_HORIZONTAL, flags);
		iType.isHangable = hasBitSet(FLAG_HANGABLE, flags);
		iType.allowDistRead = hasBitSet(FLAG_ALLOWDISTREAD, flags);
		iType.rotatable = hasBitSet(FLAG_ROTATABLE, flags);
		iType.canReadText = hasBitSet(FLAG_READABLE, flags);
		iType.lookThrough = hasBitSet(FLAG_LOOKTHROUGH, flags);
		iType.m_isAnimation = hasBitSet(FLAG_ANIMATION, flags);
		// iType.walkStack = !hasBitSet(FLAG_FULLTILE, flags);
		iType.forceUse = hasBitSet(FLAG_FORCEUSE, flags);

		iType.id = clientId;
		iType.speed = speed;
		iType.lightLevel = lightLevel;
		iType.lightColor = lightColor;
		iType.wareId = wareId;
		iType.alwaysOnTopOrder = alwaysOnTopOrder;

		// TODO: make this as actual .otb flag
		if (clientId == 35973 || clientId == 35974) {
			iType.isPodium = true;
		}
	}

	items.shrink_to_fit();
	return true;
}
#endif

bool Items::loadFromXml() {
	pugi::xml_document doc;
	std::string xmlLocation = "/items/items.xml";
	auto folder = g_configManager().getString(CORE_DIRECTORY, __FUNCTION__) + xmlLocation;
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
			g_logger().warn("[Items::loadFromXml] - No item id found, use id or fromid");
			continue;
		}

		auto toIdAttribute = itemNode.attribute("toid");
		if (!toIdAttribute) {
			g_logger().warn("[Items::loadFromXml] - "
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
	ItemType &itemType = getItemType(id);
	// Ids 0-100 are used for fluids in the XML
	if (id >= 100 && (itemType.id == 0 && (itemType.name.empty() || itemType.name == asLowerCaseString("reserved sprite")))) {
		return;
	}
	itemType.id = id;

	if (itemType.loaded) {
		g_logger().warn("[Items::parseItemNode] - Duplicate item with id: {}", id);
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
		nameToItems.insert({ asLowerCaseString(itemType.name), id });
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
			g_logger().warn("[Items::parseItemNode] - Unknown key value: {}", keyAttribute.as_string());
		}
	}

	// Check bed items
	if ((itemType.transformToFree != 0 || itemType.transformToOnUse[PLAYERSEX_FEMALE] != 0 || itemType.transformToOnUse[PLAYERSEX_MALE] != 0) && itemType.type != ITEM_TYPE_BED) {
		g_logger().warn("[Items::parseItemNode] - Item {} is not set as a bed-type", itemType.id);
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

	if (result == nameToItems.end()) {
		return 0;
	}

	return result->second;
}

bool Items::hasItemType(size_t hasId) const {
	if (hasId < items.size()) {
		return true;
	}
	return false;
}
