/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "items/item.hpp"

#include "config/configmanager.hpp"
#include "containers/rewards/rewardchest.hpp"
#include "creatures/combat/combat.hpp"
#include "creatures/combat/spells.hpp"
#include "creatures/players/imbuements/imbuements.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "enums/object_category.hpp"
#include "game/game.hpp"
#include "game/movement/teleport.hpp"
#include "items/bed.hpp"
#include "items/containers/container.hpp"
#include "items/containers/depot/depotlocker.hpp"
#include "items/containers/mailbox/mailbox.hpp"
#include "items/decay/decay.hpp"
#include "items/trashholder.hpp"
#include "lua/creature/actions.hpp"
#include "map/house/house.hpp"

#define ITEM_IMBUEMENT_SLOT 500

Items Item::items;

std::shared_ptr<Item> Item::CreateItem(const uint16_t type, uint16_t count /*= 0*/, Position* itemPosition /*= nullptr*/) {
	// A map which contains items that, when on creating, should be transformed to the default type.
	static const phmap::flat_hash_map<ItemID_t, ItemID_t> ItemTransformationMap = {
		{ ITEM_SWORD_RING_ACTIVATED, ITEM_SWORD_RING },
		{ ITEM_CLUB_RING_ACTIVATED, ITEM_CLUB_RING },
		{ ITEM_DWARVEN_RING_ACTIVATED, ITEM_DWARVEN_RING },
		{ ITEM_RING_HEALING_ACTIVATED, ITEM_RING_HEALING },
		{ ITEM_STEALTH_RING_ACTIVATED, ITEM_STEALTH_RING },
		{ ITEM_TIME_RING_ACTIVATED, ITEM_TIME_RING },
		{ ITEM_PAIR_SOFT_BOOTS_ACTIVATED, ITEM_PAIR_SOFT_BOOTS },
		{ ITEM_DEATH_RING_ACTIVATED, ITEM_DEATH_RING },
		{ ITEM_PRISMATIC_RING_ACTIVATED, ITEM_PRISMATIC_RING },
		{ ITEM_OLD_DIAMOND_ARROW, ITEM_DIAMOND_ARROW },
	};

	std::shared_ptr<Item> newItem = nullptr;

	const ItemType &it = Item::items[type];
	if (it.stackable && count == 0) {
		count = 1;
	}

	if (it.id != 0) {
		if (it.isDepot()) {
			newItem = std::make_shared<DepotLocker>(type, 4);
		} else if (it.isRewardChest()) {
			newItem = std::make_shared<RewardChest>(type);
		} else if (it.isContainer()) {
			newItem = std::make_shared<Container>(type);
		} else if (it.isTeleport()) {
			newItem = std::make_shared<Teleport>(type);
		} else if (it.isMagicField()) {
			newItem = std::make_shared<MagicField>(type);
		} else if (it.isDoor()) {
			newItem = std::make_shared<Door>(type);
		} else if (it.isTrashHolder()) {
			newItem = std::make_shared<TrashHolder>(type);
		} else if (it.isMailbox()) {
			newItem = std::make_shared<Mailbox>(type);
		} else if (it.isBed()) {
			newItem = std::make_shared<BedItem>(type);
		} else {
			const auto itemMap = ItemTransformationMap.find(static_cast<ItemID_t>(it.id));
			if (itemMap != ItemTransformationMap.end()) {
				newItem = std::make_shared<Item>(itemMap->second, count);
			} else {
				newItem = std::make_shared<Item>(type, count);
			}
		}
	} else if (type > 0 && itemPosition) {
		const auto position = *itemPosition;
		g_logger().warn("[Item::CreateItem] Item with id '{}', in position '{}' not exists in the appearances.dat and cannot be created.", type, position.toString());
	} else {
		g_logger().warn("[Item::CreateItem] Item with id '{}' is not registered and cannot be created.", type);
	}

	return newItem;
}

bool Item::hasImbuementAttribute(const std::string &attributeSlot) const {
	// attributeSlot = ITEM_IMBUEMENT_SLOT + slot id
	return getCustomAttribute(attributeSlot) != nullptr;
}

bool Item::getImbuementInfo(uint8_t slot, ImbuementInfo* imbuementInfo) const {
	std::string attributeSlot = std::to_string(ITEM_IMBUEMENT_SLOT + slot);
	if (!hasImbuementAttribute(attributeSlot)) {
		return false;
	}

	const CustomAttribute* attribute = getCustomAttribute(attributeSlot);
	const auto info = attribute ? attribute->getAttribute<uint32_t>() : 0;
	imbuementInfo->imbuement = g_imbuements().getImbuement(info & 0xFF);
	imbuementInfo->duration = info >> 8;
	return imbuementInfo->duration && imbuementInfo->imbuement;
}

void Item::setImbuement(uint8_t slot, uint16_t imbuementId, uint32_t duration) {
	const auto valueDuration = (static_cast<int64_t>(duration > 0 ? (duration << 8) | imbuementId : 0));
	setCustomAttribute(std::to_string(ITEM_IMBUEMENT_SLOT + slot), valueDuration);
}

void Item::addImbuement(uint8_t slot, uint16_t imbuementId, uint32_t duration) {
	const auto &player = getHoldingPlayer();
	if (!player) {
		return;
	}

	// Get imbuement by the id
	const Imbuement* imbuement = g_imbuements().getImbuement(imbuementId);
	if (!imbuement) {
		return;
	}

	// Get category imbuement for acess category id
	const CategoryImbuement* categoryImbuement = g_imbuements().getCategoryByID(imbuement->getCategory());
	if (!hasImbuementType(static_cast<ImbuementTypes_t>(categoryImbuement->id), imbuement->getBaseID())) {
		return;
	}

	// Checks if the item already has the imbuement category id
	if (hasImbuementCategoryId(categoryImbuement->id)) {
		g_logger().error("[Item::setImbuement] - An error occurred while player with name {} try to apply imbuement, item already contains imbuement of the same type: {}", player->getName(), imbuement->getName());
		player->sendImbuementResult("An error ocurred, please reopen imbuement window.");
		return;
	}

	setImbuement(slot, imbuementId, duration);
}

bool Item::hasImbuementCategoryId(uint16_t categoryId) const {
	for (uint8_t slotid = 0; slotid < getImbuementSlot(); slotid++) {
		ImbuementInfo imbuementInfo;
		if (getImbuementInfo(slotid, &imbuementInfo)) {
			if (const CategoryImbuement* categoryImbuement = g_imbuements().getCategoryByID(imbuementInfo.imbuement->getCategory());
			    categoryImbuement->id == categoryId) {
				return true;
			}
		}
	}
	return false;
}

double Item::getDodgeChance() const {
	if (getTier() == 0) {
		return 0;
	}
	return quadraticPoly(
		g_configManager().getFloat(RUSE_CHANCE_FORMULA_A),
		g_configManager().getFloat(RUSE_CHANCE_FORMULA_B),
		g_configManager().getFloat(RUSE_CHANCE_FORMULA_C),
		getTier()
	);
}

double Item::getFatalChance() const {
	if (getTier() == 0) {
		return 0;
	}
	return quadraticPoly(
		g_configManager().getFloat(ONSLAUGHT_CHANCE_FORMULA_A),
		g_configManager().getFloat(ONSLAUGHT_CHANCE_FORMULA_B),
		g_configManager().getFloat(ONSLAUGHT_CHANCE_FORMULA_C),
		getTier()
	);
}

double Item::getMomentumChance() const {
	if (getTier() == 0) {
		return 0;
	}
	return quadraticPoly(
		g_configManager().getFloat(MOMENTUM_CHANCE_FORMULA_A),
		g_configManager().getFloat(MOMENTUM_CHANCE_FORMULA_B),
		g_configManager().getFloat(MOMENTUM_CHANCE_FORMULA_C),
		getTier()
	);
}

double Item::getTranscendenceChance() const {
	if (getTier() == 0) {
		return 0;
	}
	return quadraticPoly(
		g_configManager().getFloat(TRANSCENDANCE_CHANCE_FORMULA_A),
		g_configManager().getFloat(TRANSCENDANCE_CHANCE_FORMULA_B),
		g_configManager().getFloat(TRANSCENDANCE_CHANCE_FORMULA_C),
		getTier()
	);
}

uint8_t Item::getTier() const {
	if (!hasAttribute(ItemAttribute_t::TIER)) {
		return 0;
	}

	auto tier = getAttribute<uint8_t>(ItemAttribute_t::TIER);
	if (tier > g_configManager().getNumber(FORGE_MAX_ITEM_TIER)) {
		g_logger().error("{} - Item {} have a wrong tier {}", __FUNCTION__, getName(), tier);
		return 0;
	}

	return tier;
}

void Item::setTier(uint8_t tier) {
	auto configTier = g_configManager().getNumber(FORGE_MAX_ITEM_TIER);
	if (tier > configTier) {
		g_logger().error("{} - It is not possible to set a tier higher than {}", __FUNCTION__, configTier);
		return;
	}

	if (items[id].upgradeClassification) {
		setAttribute(ItemAttribute_t::TIER, tier);
	}
}

std::shared_ptr<Container> Item::CreateItemAsContainer(const uint16_t type, uint16_t size) {
	if (const ItemType &it = Item::items[type];
	    it.id == 0
	    || it.stackable
	    || it.multiUse
	    || it.movable
	    || it.pickupable
	    || it.isDepot()
	    || it.isSplash()
	    || it.isDoor()) {
		return nullptr;
	}

	auto newItem = std::make_shared<Container>(type, size);
	return newItem;
}

std::shared_ptr<Item> Item::CreateItem(uint16_t itemId, Position &itemPosition) {
	switch (itemId) {
		case ITEM_FIREFIELD_PVP_FULL:
			itemId = ITEM_FIREFIELD_PERSISTENT_FULL;
			break;

		case ITEM_FIREFIELD_PVP_MEDIUM:
			itemId = ITEM_FIREFIELD_PERSISTENT_MEDIUM;
			break;

		case ITEM_FIREFIELD_PVP_SMALL:
			itemId = ITEM_FIREFIELD_PERSISTENT_SMALL;
			break;

		case ITEM_ENERGYFIELD_PVP:
			itemId = ITEM_ENERGYFIELD_PERSISTENT;
			break;

		case ITEM_POISONFIELD_PVP:
			itemId = ITEM_POISONFIELD_PERSISTENT;
			break;

		case ITEM_MAGICWALL:
			itemId = ITEM_MAGICWALL_PERSISTENT;
			break;

		case ITEM_WILDGROWTH:
			itemId = ITEM_WILDGROWTH_PERSISTENT;
			break;

		default:
			break;
	}

	return Item::CreateItem(itemId, 0, &itemPosition);
}

Item::Item(const uint16_t itemId, uint16_t itemCount /*= 0*/) :
	id(itemId) {
	const ItemType &it = items[id];
	const auto itemCharges = it.charges;
	if (it.isFluidContainer() || it.isSplash()) {
		const auto fluidType = std::clamp<uint16_t>(itemCount, 0, magic_enum::enum_count<Fluids_t>());
		setAttribute(ItemAttribute_t::FLUIDTYPE, fluidType);
	} else if (it.stackable) {
		if (itemCount != 0) {
			setItemCount(static_cast<uint8_t>(itemCount));
		} else if (itemCharges != 0) {
			setItemCount(static_cast<uint8_t>(it.charges));
		}
	} else if (itemCharges != 0) {
		if (itemCount != 0) {
			setAttribute(ItemAttribute_t::CHARGES, itemCount);
		} else {
			setAttribute(ItemAttribute_t::CHARGES, it.charges);
		}
	}

	setDefaultDuration();
}

Item::Item(const std::shared_ptr<Item> &i) :
	Thing(), id(i->id), count(i->count), loadedFromMap(i->loadedFromMap) {
	if (i->attributePtr) {
		attributePtr = std::make_unique<ItemAttribute>(*i->attributePtr);
	}
}

std::shared_ptr<Item> Item::clone() const {
	const auto &item = Item::CreateItem(id, count);
	if (item == nullptr) {
		g_logger().error("[{}] item is nullptr", __FUNCTION__);
		return nullptr;
	}

	if (attributePtr) {
		item->attributePtr = std::make_unique<ItemAttribute>(*attributePtr);
	}

	return item;
}

bool Item::equals(const std::shared_ptr<Item> &compareItem) const {
	if (!compareItem) {
		return false;
	}

	if (id != compareItem->id) {
		return false;
	}

	if (isStoreItem() != compareItem->isStoreItem()) {
		return false;
	}

	if (getOwnerId() != compareItem->getOwnerId()) {
		return false;
	}

	for (const auto &attribute : getAttributeVector()) {
		if (attribute.getAttributeType() == ItemAttribute_t::STORE) {
			continue;
		}

		for (const auto &compareAttribute : compareItem->getAttributeVector()) {
			if (attribute.getAttributeType() != compareAttribute.getAttributeType()) {
				continue;
			}

			if (isAttributeInteger(attribute.getAttributeType()) && attribute.getInteger() != compareAttribute.getInteger()) {
				return false;
			}

			if (isAttributeString(attribute.getAttributeType()) && attribute.getString() != compareAttribute.getString()) {
				return false;
			}
		}
	}

	return true;
}

void Item::setDefaultSubtype() {
	const ItemType &it = items[id];

	setItemCount(1);

	const auto itemCharges = it.charges;
	if (itemCharges != 0) {
		if (it.stackable) {
			setItemCount(static_cast<uint8_t>(itemCharges));
		} else {
			setAttribute(ItemAttribute_t::CHARGES, it.charges);
		}
	}
}

void Item::onRemoved() {
	ScriptEnvironment::removeTempItem(static_self_cast<Item>());

	if (hasAttribute(ItemAttribute_t::UNIQUEID)) {
		g_game().removeUniqueItem(getAttribute<uint16_t>(ItemAttribute_t::UNIQUEID));
	}
}

void Item::setID(uint16_t newid) {
	const ItemType &prevIt = Item::items[id];
	id = newid;

	const ItemType &it = Item::items[newid];
	const uint32_t newDuration = it.decayTime * 1000;

	if (newDuration == 0 && !it.stopTime && it.decayTo < 0) {
		// We'll get called startDecay anyway so let's schedule it - actually not in all casses
		if (hasAttribute(ItemAttribute_t::DECAYSTATE)) {
			setDecaying(DECAYING_STOPPING);
		}
		removeAttribute(ItemAttribute_t::DURATION);
	}

	if (!isRewardCorpse()) {
		removeAttribute(ItemAttribute_t::CORPSEOWNER);
	}

	if (newDuration > 0 && (!prevIt.stopTime || !hasAttribute(ItemAttribute_t::DURATION))) {
		setDecaying(DECAYING_PENDING);
		setDuration(newDuration);
	}
}

bool Item::isOwner(uint32_t ownerId) const {
	if (getOwnerId() == ownerId) {
		return true;
	}
	if (ownerId >= Player::getFirstID() && ownerId <= Player::getLastID()) {
		const auto &player = g_game().getPlayerByID(ownerId);
		return player && player->getGUID() == getOwnerId();
	}
	if (const auto &player = g_game().getPlayerByGUID(ownerId); player) {
		return player->getID() == getOwnerId();
	}
	return false;
}

std::shared_ptr<Cylinder> Item::getTopParent() {
	auto aux = getParent();
	auto prevaux = std::dynamic_pointer_cast<Cylinder>(shared_from_this());
	if (!aux) {
		return prevaux;
	}

	while (aux && aux->getParent() != nullptr) {
		prevaux = aux;
		aux = aux->getParent();
	}

	if (prevaux) {
		return prevaux;
	}
	return aux;
}

std::shared_ptr<Tile> Item::getTile() {
	auto cylinder = getTopParent();
	// get root cylinder
	if (cylinder && cylinder->getParent()) {
		cylinder = cylinder->getParent();
	}
	return std::dynamic_pointer_cast<Tile>(cylinder);
}

bool Item::isRemoved() {
	auto parent = getParent();
	if (parent) {
		return parent->isRemoved();
	}
	return true;
}

uint16_t Item::getSubType() const {
	const ItemType &it = items[id];
	if (it.isFluidContainer() || it.isSplash()) {
		return getAttribute<uint16_t>(ItemAttribute_t::FLUIDTYPE);
	} else if (it.stackable) {
		return count;
	} else if (it.charges != 0) {
		return getAttribute<uint16_t>(ItemAttribute_t::CHARGES);
	}
	return static_cast<uint16_t>(count);
}

std::shared_ptr<Player> Item::getHoldingPlayer() {
	auto p = getParent();
	while (p) {
		if (p->getCreature()) {
			return p->getCreature()->getPlayer();
		}

		p = p->getParent();
	}
	return nullptr;
}

bool Item::isItemStorable() const {
	if (isStoreItem() || hasOwner()) {
		return false;
	}
	const auto isContainerAndHasSomethingInside = (getContainer() != nullptr) && (!getContainer()->getItemList().empty());
	return (isStowable() || isContainerAndHasSomethingInside);
}

void Item::setSubType(uint16_t n) {
	const ItemType &it = items[id];
	if (it.isFluidContainer() || it.isSplash()) {
		setAttribute(ItemAttribute_t::FLUIDTYPE, n);
	} else if (it.stackable) {
		setItemCount(n);
	} else if (it.charges != 0) {
		setAttribute(ItemAttribute_t::CHARGES, n);
	} else {
		setItemCount(n);
	}
}

Attr_ReadValue Item::readAttr(AttrTypes_t attr, PropStream &propStream) {
	switch (attr) {
		case ATTR_STORE: {
			int64_t timeStamp;
			if (!propStream.read<int64_t>(timeStamp)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::STORE, timeStamp);
			break;
		}
		case ATTR_COUNT:
		case ATTR_RUNE_CHARGES: {
			uint8_t charges;
			if (!propStream.read<uint8_t>(charges)) {
				return ATTR_READ_ERROR;
			}

			setSubType(charges);
			break;
		}

		case ATTR_ACTION_ID: {
			uint16_t actionId;
			if (!propStream.read<uint16_t>(actionId)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::ACTIONID, actionId);
			break;
		}

		case ATTR_UNIQUE_ID: {
			uint16_t uniqueId;
			if (!propStream.read<uint16_t>(uniqueId)) {
				return ATTR_READ_ERROR;
			}

			addUniqueId(uniqueId);
			break;
		}

		case ATTR_TEXT: {
			std::string text;
			if (!propStream.readString(text)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::TEXT, text);
			break;
		}

		case ATTR_WRITTENDATE: {
			uint64_t writtenDate;
			if (!propStream.read<uint64_t>(writtenDate)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::DATE, writtenDate);
			break;
		}

		case ATTR_WRITTENBY: {
			std::string writer;
			if (!propStream.readString(writer)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::WRITER, writer);
			break;
		}

		case ATTR_DESC: {
			std::string text;
			if (!propStream.readString(text)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::DESCRIPTION, text);
			break;
		}

		case ATTR_CHARGES: {
			uint16_t charges;
			if (!propStream.read<uint16_t>(charges)) {
				return ATTR_READ_ERROR;
			}

			setSubType(charges);
			break;
		}

		case ATTR_DURATION: {
			int32_t duration;
			if (!propStream.read<int32_t>(duration)) {
				return ATTR_READ_ERROR;
			}

			setDuration(duration);
			break;
		}

		case ATTR_DECAYING_STATE: {
			uint8_t state;
			if (!propStream.read<uint8_t>(state)) {
				return ATTR_READ_ERROR;
			}

			if (state != DECAYING_FALSE) {
				setDecaying(DECAYING_PENDING);
			}
			break;
		}

		case ATTR_NAME: {
			std::string name;
			if (!propStream.readString(name)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::NAME, name);
			break;
		}

		case ATTR_ARTICLE: {
			std::string article;
			if (!propStream.readString(article)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::ARTICLE, article);
			break;
		}

		case ATTR_PLURALNAME: {
			std::string pluralName;
			if (!propStream.readString(pluralName)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::PLURALNAME, pluralName);
			break;
		}

		case ATTR_WEIGHT: {
			uint32_t weight;
			if (!propStream.read<uint32_t>(weight)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::WEIGHT, weight);
			break;
		}

		case ATTR_ATTACK: {
			int32_t attack;
			if (!propStream.read<int32_t>(attack)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::ATTACK, attack);
			break;
		}

		case ATTR_DEFENSE: {
			int32_t defense;
			if (!propStream.read<int32_t>(defense)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::DEFENSE, defense);
			break;
		}

		case ATTR_EXTRADEFENSE: {
			int32_t extraDefense;
			if (!propStream.read<int32_t>(extraDefense)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::EXTRADEFENSE, extraDefense);
			break;
		}

		case ATTR_IMBUEMENT_SLOT: {
			int32_t imbuementSlot;
			if (!propStream.read<int32_t>(imbuementSlot)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::IMBUEMENT_SLOT, imbuementSlot);
			break;
		}

		case ATTR_OPENCONTAINER: {
			uint8_t openContainer;
			if (!propStream.read<uint8_t>(openContainer)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::OPENCONTAINER, openContainer);
			break;
		}

		case ATTR_ARMOR: {
			int32_t armor;
			if (!propStream.read<int32_t>(armor)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::ARMOR, armor);
			break;
		}

		case ATTR_HITCHANCE: {
			int8_t hitChance;
			if (!propStream.read<int8_t>(hitChance)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::HITCHANCE, hitChance);
			break;
		}

		case ATTR_SHOOTRANGE: {
			uint8_t shootRange;
			if (!propStream.read<uint8_t>(shootRange)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::SHOOTRANGE, shootRange);
			break;
		}

		case ATTR_SPECIAL: {
			std::string special;
			if (!propStream.readString(special)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::SPECIAL, special);

			// Migrate hireling lamps to CustomAttribute instead of SpecialAttribute
			if (getID() == ItemID_t::HIRELING_LAMP) {
				// Remove special attribute
				removeAttribute(ItemAttribute_t::SPECIAL);
				// Add custom attribute
				setCustomAttribute("Hireling", static_cast<int64_t>(std::atoi(special.c_str())));
			}
			break;
		}

		case ATTR_QUICKLOOTCONTAINER: {
			uint32_t flags;
			if (!propStream.read<uint32_t>(flags)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::QUICKLOOTCONTAINER, flags);
			break;
		}

		// these should be handled through derived classes
		// If these are called then something has changed in the items.xml since the map was saved
		// just read the values

		// Depot class
		case ATTR_DEPOT_ID: {
			if (!propStream.skip(2)) {
				return ATTR_READ_ERROR;
			}
			break;
		}

		// Door class
		case ATTR_HOUSEDOORID: {
			if (!propStream.skip(1)) {
				return ATTR_READ_ERROR;
			}
			break;
		}

		// Bed class
		case ATTR_SLEEPERGUID: {
			if (!propStream.skip(4)) {
				return ATTR_READ_ERROR;
			}
			break;
		}

		case ATTR_SLEEPSTART: {
			if (!propStream.skip(4)) {
				return ATTR_READ_ERROR;
			}
			break;
		}

		// Teleport class
		case ATTR_TELE_DEST: {
			if (!propStream.skip(5)) {
				return ATTR_READ_ERROR;
			}
			break;
		}

		// Container class
		case ATTR_CONTAINER_ITEMS: {
			return ATTR_READ_ERROR;
		}

		// Deprecated, all items that still exist with this attribute will work normally, but new items will be created with the new system, using ATTR_CUSTOM
		case ATTR_CUSTOM_ATTRIBUTES: {
			uint64_t size;
			if (!propStream.read<uint64_t>(size)) {
				return ATTR_READ_ERROR;
			}

			for (uint64_t i = 0; i < size; i++) {
				// Unserialize key type and value
				std::string key;
				if (!propStream.readString(key)) {
					return ATTR_READ_ERROR;
				}

				// Unserialize value type and value
				CustomAttribute customAttribute;
				if (!customAttribute.unserialize(propStream, __FUNCTION__)) {
					return ATTR_READ_ERROR;
				}
				// Add new custom attribute
				addCustomAttribute(key, customAttribute);
				// Remove old custom attribute
				removeAttribute(ItemAttribute_t::CUSTOM);

				// Migrate wrapable items to the new store attribute
				if (getCustomAttribute("unWrapId") && getAttribute<int64_t>(ItemAttribute_t::STORE) == 0) {
					setAttribute(ItemAttribute_t::STORE, getTimeNow());
				}
			}
			break;
		}

		case ATTR_TIER: {
			uint8_t tier;
			if (!propStream.read<uint8_t>(tier)) {
				g_logger().error("[{}] failed to read tier", __FUNCTION__);
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::TIER, tier);
			break;
		}

		case ATTR_AMOUNT: {
			uint16_t amount;
			if (!propStream.read<uint16_t>(amount)) {
				g_logger().error("[{}] failed to read amount", __FUNCTION__);
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::AMOUNT, amount);
			break;
		}

		case ATTR_CUSTOM: {
			uint64_t size;
			if (!propStream.read<uint64_t>(size)) {
				g_logger().error("[{}] failed to read size", __FUNCTION__);
				return ATTR_READ_ERROR;
			}

			for (uint64_t i = 0; i < size; i++) {
				// Unserialize custom attribute key type
				std::string key;
				if (!propStream.readString(key)) {
					g_logger().error("[{}] failed to read custom type", __FUNCTION__);
					return ATTR_READ_ERROR;
				};

				CustomAttribute customAttribute;
				if (!customAttribute.unserialize(propStream, __FUNCTION__)) {
					g_logger().error("[{}] failed to read custom value", __FUNCTION__);
					return ATTR_READ_ERROR;
				}

				addCustomAttribute(key, customAttribute);
			}
			break;
		}

		case ATTR_STORE_INBOX_CATEGORY: {
			std::string category;
			if (!propStream.readString(category)) {
				g_logger().error("[{}] failed to read store inbox category from item {}", __FUNCTION__, getName());
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::STORE_INBOX_CATEGORY, category);
			break;
		}

		case ATTR_OWNER: {
			uint32_t ownerId;
			if (!propStream.read<uint32_t>(ownerId)) {
				g_logger().error("[{}] failed to read amount", __FUNCTION__);
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::OWNER, ownerId);
			break;
		}

		case ATTR_OBTAINCONTAINER: {
			uint32_t flags;
			if (!propStream.read<uint32_t>(flags)) {
				return ATTR_READ_ERROR;
			}

			g_logger().trace("Setting obtain flag {} flags, to item id {}", flags, getID());
			setAttribute(ItemAttribute_t::OBTAINCONTAINER, flags);
			break;
		}
		default:
			return ATTR_READ_ERROR;
	}

	return ATTR_READ_CONTINUE;
}

bool Item::unserializeAttr(PropStream &propStream) {
	uint8_t attr_type;
	while (propStream.read<uint8_t>(attr_type) && attr_type != 0) {
		const Attr_ReadValue ret = readAttr(static_cast<AttrTypes_t>(attr_type), propStream);
		if (ret == ATTR_READ_ERROR) {
			return false;
		} else if (ret == ATTR_READ_END) {
			return true;
		}
	}
	return true;
}

bool Item::unserializeItemNode(OTB::Loader &, const OTB::Node &, PropStream &propStream, Position &itemPosition) {
	return unserializeAttr(propStream);
}

void Item::serializeAttr(PropWriteStream &propWriteStream) const {
	const ItemType &it = items[id];
	if (const auto timeStamp = getAttribute<int64_t>(ItemAttribute_t::STORE)) {
		propWriteStream.write<uint8_t>(ATTR_STORE);
		propWriteStream.write<int64_t>(timeStamp);
	}
	if (it.stackable || it.isFluidContainer() || it.isSplash()) {
		propWriteStream.write<uint8_t>(ATTR_COUNT);
		propWriteStream.write<uint8_t>(getSubType());
	}

	if (const auto charges = getAttribute<uint16_t>(ItemAttribute_t::CHARGES)) {
		propWriteStream.write<uint8_t>(ATTR_CHARGES);
		propWriteStream.write<uint16_t>(charges);
	}

	if (it.movable) {
		if (const auto actionId = getAttribute<uint16_t>(ItemAttribute_t::ACTIONID)) {
			propWriteStream.write<uint8_t>(ATTR_ACTION_ID);
			propWriteStream.write<uint16_t>(actionId);
		}
	}

	if (const std::string &text = getString(ItemAttribute_t::TEXT);
	    !text.empty()) {
		propWriteStream.write<uint8_t>(ATTR_TEXT);
		propWriteStream.writeString(text);
	}

	if (const auto writtenDate = getAttribute<uint64_t>(ItemAttribute_t::DATE)) {
		propWriteStream.write<uint8_t>(ATTR_WRITTENDATE);
		propWriteStream.write<uint64_t>(writtenDate);
	}

	const std::string &writer = getString(ItemAttribute_t::WRITER);
	if (!writer.empty()) {
		propWriteStream.write<uint8_t>(ATTR_WRITTENBY);
		propWriteStream.writeString(writer);
	}

	const std::string &specialDesc = getString(ItemAttribute_t::DESCRIPTION);
	if (!specialDesc.empty()) {
		propWriteStream.write<uint8_t>(ATTR_DESC);
		propWriteStream.writeString(specialDesc);
	}

	if (hasAttribute(ItemAttribute_t::DURATION)) {
		propWriteStream.write<uint8_t>(ATTR_DURATION);
		propWriteStream.write<int32_t>(getDuration());
	}

	if (const auto decayState = getDecaying();
	    decayState == DECAYING_TRUE || decayState == DECAYING_PENDING) {
		propWriteStream.write<uint8_t>(ATTR_DECAYING_STATE);
		propWriteStream.write<uint8_t>(decayState);
	}

	if (hasAttribute(ItemAttribute_t::NAME)) {
		propWriteStream.write<uint8_t>(ATTR_NAME);
		propWriteStream.writeString(getString(ItemAttribute_t::NAME));
	}

	if (hasAttribute(ItemAttribute_t::ARTICLE)) {
		propWriteStream.write<uint8_t>(ATTR_ARTICLE);
		propWriteStream.writeString(getString(ItemAttribute_t::ARTICLE));
	}

	if (hasAttribute(ItemAttribute_t::PLURALNAME)) {
		propWriteStream.write<uint8_t>(ATTR_PLURALNAME);
		propWriteStream.writeString(getString(ItemAttribute_t::PLURALNAME));
	}

	if (hasAttribute(ItemAttribute_t::WEIGHT)) {
		propWriteStream.write<uint8_t>(ATTR_WEIGHT);
		propWriteStream.write<uint32_t>(getAttribute<uint32_t>(ItemAttribute_t::WEIGHT));
	}

	if (hasAttribute(ItemAttribute_t::ATTACK)) {
		propWriteStream.write<uint8_t>(ATTR_ATTACK);
		propWriteStream.write<int32_t>(getAttribute<int32_t>(ItemAttribute_t::ATTACK));
	}

	if (hasAttribute(ItemAttribute_t::DEFENSE)) {
		propWriteStream.write<uint8_t>(ATTR_DEFENSE);
		propWriteStream.write<int32_t>(getAttribute<int32_t>(ItemAttribute_t::DEFENSE));
	}

	if (hasAttribute(ItemAttribute_t::EXTRADEFENSE)) {
		propWriteStream.write<uint8_t>(ATTR_EXTRADEFENSE);
		propWriteStream.write<int32_t>(getAttribute<int32_t>(ItemAttribute_t::EXTRADEFENSE));
	}

	if (hasAttribute(ItemAttribute_t::IMBUEMENT_SLOT)) {
		propWriteStream.write<uint8_t>(ATTR_IMBUEMENT_SLOT);
		propWriteStream.write<int32_t>(getAttribute<int32_t>(ItemAttribute_t::IMBUEMENT_SLOT));
	}

	if (hasAttribute(ItemAttribute_t::OPENCONTAINER)) {
		propWriteStream.write<uint8_t>(ATTR_OPENCONTAINER);
		propWriteStream.write<uint8_t>(getAttribute<uint8_t>(ItemAttribute_t::OPENCONTAINER));
	}

	if (hasAttribute(ItemAttribute_t::ARMOR)) {
		propWriteStream.write<uint8_t>(ATTR_ARMOR);
		propWriteStream.write<int32_t>(getAttribute<int32_t>(ItemAttribute_t::ARMOR));
	}

	if (hasAttribute(ItemAttribute_t::HITCHANCE)) {
		propWriteStream.write<uint8_t>(ATTR_HITCHANCE);
		propWriteStream.write<int8_t>(getAttribute<int8_t>(ItemAttribute_t::HITCHANCE));
	}

	if (hasAttribute(ItemAttribute_t::SHOOTRANGE)) {
		propWriteStream.write<uint8_t>(ATTR_SHOOTRANGE);
		propWriteStream.write<uint8_t>(getAttribute<uint8_t>(ItemAttribute_t::SHOOTRANGE));
	}

	if (hasAttribute(ItemAttribute_t::SPECIAL)) {
		propWriteStream.write<uint8_t>(ATTR_SPECIAL);
		propWriteStream.writeString(getString(ItemAttribute_t::SPECIAL));
	}

	if (hasAttribute(ItemAttribute_t::QUICKLOOTCONTAINER)) {
		propWriteStream.write<uint8_t>(ATTR_QUICKLOOTCONTAINER);
		propWriteStream.write<uint32_t>(getAttribute<uint32_t>(ItemAttribute_t::QUICKLOOTCONTAINER));
	}

	if (hasAttribute(ItemAttribute_t::TIER)) {
		propWriteStream.write<uint8_t>(ATTR_TIER);
		propWriteStream.write<uint8_t>(getTier());
	}

	if (hasAttribute(ItemAttribute_t::AMOUNT)) {
		propWriteStream.write<uint8_t>(ATTR_AMOUNT);
		propWriteStream.write<uint16_t>(getAttribute<uint16_t>(ItemAttribute_t::AMOUNT));
	}

	if (hasAttribute(ItemAttribute_t::STORE_INBOX_CATEGORY)) {
		propWriteStream.write<uint8_t>(ATTR_STORE_INBOX_CATEGORY);
		propWriteStream.writeString(getString(ItemAttribute_t::STORE_INBOX_CATEGORY));
	}

	if (hasAttribute(ItemAttribute_t::OWNER)) {
		propWriteStream.write<uint8_t>(ATTR_OWNER);
		propWriteStream.write<uint32_t>(getAttribute<uint32_t>(ItemAttribute_t::OWNER));
	}

	// Serialize custom attributes, only serialize if the map not is empty
	if (hasCustomAttribute()) {
		auto customAttributeMap = getCustomAttributeMap();
		propWriteStream.write<uint8_t>(ATTR_CUSTOM);
		propWriteStream.write<uint64_t>(customAttributeMap.size());
		for (const auto &[attributeKey, customAttribute] : customAttributeMap) {
			// Serializing custom attribute key type
			propWriteStream.writeString(attributeKey);
			// Serializing custom attribute value type
			customAttribute.serialize(propWriteStream);
		}
	}

	if (hasAttribute(ItemAttribute_t::OBTAINCONTAINER)) {
		propWriteStream.write<uint8_t>(ATTR_OBTAINCONTAINER);
		auto flags = getAttribute<uint32_t>(ItemAttribute_t::OBTAINCONTAINER);
		g_logger().debug("Reading flag {}, to item id {}", flags, getID());
		propWriteStream.write<uint32_t>(flags);
	}
}

void Item::setOwner(const std::shared_ptr<Creature> &owner) {
	auto ownerId = owner->getID();
	if (owner->getPlayer()) {
		ownerId = owner->getPlayer()->getGUID();
	}
	setOwner(ownerId);
}

bool Item::isOwner(const std::shared_ptr<Creature> &owner) const {
	if (!owner) {
		return false;
	}
	auto ownerId = owner->getID();
	if (isOwner(ownerId)) {
		return true;
	}
	if (owner->getPlayer()) {
		ownerId = owner->getPlayer()->getGUID();
	}
	return isOwner(ownerId);
}

uint32_t Item::getOwnerId() const {
	if (hasAttribute(ItemAttribute_t::OWNER)) {
		return getAttribute<uint32_t>(ItemAttribute_t::OWNER);
	}
	return 0;
}

std::string Item::getOwnerName() const {
	if (!hasOwner()) {
		return "";
	}

	const auto &creature = g_game().getCreatureByID(getOwnerId());
	if (creature) {
		return creature->getName();
	}
	if (auto name = g_game().getPlayerNameByGUID(getOwnerId()); !name.empty()) {
		return name;
	}
	return "someone else";
}

bool Item::hasProperty(ItemProperty prop) const {
	const ItemType &it = items[id];
	switch (prop) {
		case CONST_PROP_BLOCKSOLID:
			return it.blockSolid;
		case CONST_PROP_MOVABLE:
			return canBeMoved();
		case CONST_PROP_HASHEIGHT:
			return it.hasHeight;
		case CONST_PROP_BLOCKPROJECTILE:
			return it.blockProjectile;
		case CONST_PROP_BLOCKPATH:
			return it.blockPathFind;
		case CONST_PROP_ISVERTICAL:
			return it.isVertical;
		case CONST_PROP_ISHORIZONTAL:
			return it.isHorizontal;
		case CONST_PROP_IMMOVABLEBLOCKSOLID:
			return it.blockSolid && !canBeMoved();
		case CONST_PROP_IMMOVABLEBLOCKPATH:
			return it.blockPathFind && !canBeMoved();
		case CONST_PROP_IMMOVABLENOFIELDBLOCKPATH:
			return !it.isMagicField() && it.blockPathFind && !canBeMoved();
		case CONST_PROP_NOFIELDBLOCKPATH:
			return !it.isMagicField() && it.blockPathFind;
		case CONST_PROP_SUPPORTHANGABLE:
			return it.isHorizontal || it.isVertical;
		default:
			return false;
	}
}

bool Item::canBeMoved() const {
	static std::unordered_set<int32_t> immovableActionIds = {
		IMMOVABLE_ACTION_ID,
	};
	if (hasAttribute(ItemAttribute_t::UNIQUEID)) {
		return false;
	}
	if (hasAttribute(ItemAttribute_t::ACTIONID) && immovableActionIds.contains(static_cast<int32_t>(getAttribute<uint16_t>(ItemAttribute_t::ACTIONID)))) {
		return false;
	}
	return isMovable();
}

void Item::checkDecayMapItemOnMove() {
	if (getDuration() > 0 && isDecayDisabled() && canBeMoved()) {
		decayDisabled = false;
		loadedFromMap = false;
		startDecaying();
	}
}

uint32_t Item::getWeight() const {
	const uint32_t baseWeight = getBaseWeight();
	if (isStackable()) {
		return baseWeight * std::max<uint32_t>(1, getItemCount());
	}
	return baseWeight;
}

int32_t Item::getReflectionFlat(CombatType_t combatType) const {
	return items[id].abilities->reflectFlat[combatTypeToIndex(combatType)];
}

int32_t Item::getReflectionPercent(CombatType_t combatType) const {
	return items[id].abilities->reflectPercent[combatTypeToIndex(combatType)];
}

int32_t Item::getSpecializedMagicLevel(CombatType_t combat) const {
	return items[id].abilities->specializedMagicLevel[combatTypeToIndex(combat)];
}

std::vector<std::pair<std::string, std::string>>
Item::getDescriptions(const ItemType &it, const std::shared_ptr<Item> &item /*= nullptr*/) {
	std::ostringstream ss;
	std::vector<std::pair<std::string, std::string>> descriptions;
	bool isTradeable = true;
	descriptions.reserve(30);

	if (item) {
		const std::string &specialDescription = item->getAttribute<std::string>(ItemAttribute_t::DESCRIPTION);
		if (!specialDescription.empty()) {
			descriptions.emplace_back("Description", specialDescription);
		} else if (!it.description.empty()) {
			descriptions.emplace_back("Description", it.description);
		}

		if (item->getContainer()) {
			descriptions.emplace_back("Capacity", std::to_string(item->getContainer()->capacity()));
		}

		if (it.showCharges) {
			auto charges = item->getAttribute<int32_t>(ItemAttribute_t::CHARGES);
			if (charges != 0) {
				descriptions.emplace_back("Charges", std::to_string(charges));
			}
		}

		int32_t attack = item->getAttack();
		if (it.isRanged()) {
			bool separator = false;
			if (attack != 0) {
				ss << "attack +" << attack;
				separator = true;
			}
			if (int32_t hitChance = item->getHitChance();
			    hitChance != 0) {
				if (separator) {
					ss << ", ";
				}
				ss << "chance to hit +" << static_cast<int16_t>(hitChance) << "%";
				separator = true;
			}
			if (int32_t shootRange = item->getShootRange();
			    shootRange != 0) {
				if (separator) {
					ss << ", ";
				}
				ss << static_cast<uint16_t>(shootRange) << " fields";
			}
			descriptions.emplace_back("Attack", ss.str());
		} else {
			std::string attackDescription;
			if (it.abilities && it.abilities->elementType != COMBAT_NONE && it.abilities->elementDamage != 0) {
				attackDescription = fmt::format("{} {}", it.abilities->elementDamage, getCombatName(it.abilities->elementType));
			}

			if (attack != 0 && !attackDescription.empty()) {
				attackDescription = fmt::format("{} physical + {}", attack, attackDescription);
			} else if (attack != 0 && attackDescription.empty()) {
				attackDescription = std::to_string(attack);
			}

			if (!attackDescription.empty()) {
				descriptions.emplace_back("Attack", attackDescription);
			}
		}

		int32_t hitChance = item->getHitChance();
		if (hitChance != 0) {
			descriptions.emplace_back("HitChance", std::to_string(hitChance));
		}

		int32_t defense = item->getDefense(), extraDefense = item->getExtraDefense();
		if (defense != 0 || extraDefense != 0 || item->getWeaponType() == WEAPON_MISSILE) {
			if (extraDefense != 0) {
				ss.str("");
				ss << defense << ' ' << std::showpos << extraDefense << std::noshowpos;
				descriptions.emplace_back("Defence", ss.str());
			} else {
				descriptions.emplace_back("Defence", std::to_string(defense));
			}
		}

		int32_t armor = item->getArmor();
		if (armor != 0) {
			descriptions.emplace_back("Armor", std::to_string(armor));
		}

		if (it.abilities) {
			// Protection
			ss.str("");
			bool protection = false;
			for (size_t i = 0; i < COMBAT_COUNT; ++i) {
				if (it.abilities->absorbPercent[i] == 0) {
					continue;
				}

				if (protection) {
					ss << ", ";
				}

				ss << fmt::format("{} {:+}%", getCombatName(indexToCombatType(i)), it.abilities->fieldAbsorbPercent[i]);
				protection = true;
			}
			if (protection) {
				descriptions.emplace_back("Protection", ss.str());
			}

			// Skill Boost
			ss.str("");
			bool skillBoost = false;
			if (it.abilities->speed) {
				ss << std::showpos << "speed " << (it.abilities->speed >> 1) << std::noshowpos;
				skillBoost = true;
			}

			for (uint8_t i = SKILL_FIRST; i <= SKILL_FISHING; i++) {
				if (!it.abilities->skills[i]) {
					continue;
				}

				if (skillBoost) {
					ss << ", ";
				}

				ss << std::showpos << getSkillName(i) << ' ' << it.abilities->skills[i] << std::noshowpos;
				skillBoost = true;
			}

			if (it.abilities->regeneration) {
				ss << ", faster regeneration";
			}

			if (it.abilities->stats[STAT_MAGICPOINTS]) {
				if (skillBoost) {
					ss << ", ";
				}

				ss << std::showpos << "magic level " << it.abilities->stats[STAT_MAGICPOINTS] << std::noshowpos;
				skillBoost = true;
			}

			for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; i++) {
				auto skill = item ? item->getSkill(static_cast<skills_t>(i)) : it.getSkill(static_cast<skills_t>(i));
				if (!skill) {
					continue;
				}

				if (skillBoost) {
					ss << ", ";
				}

				if (i != SKILL_CRITICAL_HIT_CHANCE) {
					ss << std::showpos;
				}

				ss << getSkillName(i) << ' ';
				// Show float
				ss << skill / 100.;
				ss << '%' << std::noshowpos;
				skillBoost = true;
			}

			if (skillBoost) {
				descriptions.emplace_back("Skill Boost", ss.str());
			}

			if (it.abilities->stats[STAT_MAGICPOINTS]) {
				ss.str("");
				ss << std::showpos << it.abilities->stats[STAT_MAGICPOINTS] << std::noshowpos;
				descriptions.emplace_back("Magic Level", ss.str());
			}

			for (uint8_t i = 1; i <= 11; i++) {
				if (it.abilities->specializedMagicLevel[i]) {
					ss.str("");

					ss << std::showpos << it.abilities->specializedMagicLevel[i] << std::noshowpos;
					std::string combatName = getCombatName(indexToCombatType(i));
					combatName[0] = toupper(combatName[0]);
					descriptions.emplace_back(combatName + " Magic Level", ss.str());
				}
			}

			if (it.abilities->magicShieldCapacityFlat || it.abilities->magicShieldCapacityPercent) {
				ss.str("");
				ss << std::showpos << it.abilities->magicShieldCapacityFlat << std::noshowpos << " and " << it.abilities->magicShieldCapacityPercent << "%";
				descriptions.emplace_back("Magic Shield Capacity", ss.str());
			}

			if (it.abilities->perfectShotRange) {
				ss.str("");
				ss << std::showpos << it.abilities->perfectShotDamage << std::noshowpos << " at range " << unsigned(it.abilities->perfectShotRange);
				descriptions.emplace_back("Perfect Shot", ss.str());
			}

			if (it.abilities->reflectFlat[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)]) {
				ss.str("");
				ss << it.abilities->reflectFlat[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)];
				descriptions.emplace_back("Damage Reflection", ss.str());
			}

			if (it.abilities->speed) {
				ss.str("");
				ss << std::showpos << it.abilities->speed << std::noshowpos;
				descriptions.emplace_back("Speed", ss.str());
			}

			if (it.abilities->cleavePercent) {
				ss.str("");
				ss << std::showpos << (it.abilities->cleavePercent) << std::noshowpos << "%";
				descriptions.emplace_back("Cleave", ss.str());
			}

			if (it.abilities->conditionSuppressions[CONDITION_DRUNK] != 0) {
				ss.str("");
				ss << "Hard Drinking";
				descriptions.emplace_back("Effect", ss.str());
			}

			if (it.abilities->invisible) {
				ss.str("");
				ss << "Invisibility";
				descriptions.emplace_back("Effect", ss.str());
			}

			if (it.abilities->regeneration) {
				ss.str("");
				ss << "Faster Regeneration";
				descriptions.emplace_back("Effect", ss.str());
			}

			if (it.abilities->manaShield) {
				ss.str("");
				ss << "Mana Shield";
				descriptions.emplace_back("Effect", ss.str());
			}

			for (size_t i = 0; i < COMBAT_COUNT; ++i) {
				if (it.abilities->absorbPercent[i] == 0) {
					continue;
				}

				ss.str("");
				ss << getCombatName(indexToCombatType(i)) << ' '
				   << std::showpos << it.abilities->absorbPercent[i] << std::noshowpos << '%';
				descriptions.emplace_back("Protection", ss.str());
			}
			for (size_t i = 0; i < COMBAT_COUNT; ++i) {
				if (it.abilities->fieldAbsorbPercent[i] == 0) {
					continue;
				}

				ss.str("");
				ss << fmt::format("{} {:+}%", getCombatName(indexToCombatType(i)), it.abilities->fieldAbsorbPercent[i]);
				descriptions.emplace_back("Field Protection", ss.str());
			}

			if (it.abilities->conditionSuppressions[CONDITION_DRUNK] != 0) {
				ss.str("");
				ss << "Hard Drinking";
				descriptions.emplace_back("Skill Boost", ss.str());
			}

			if (it.abilities->invisible) {
				ss.str("");
				ss << "Invisibility";
				descriptions.emplace_back("Skill Boost", ss.str());
			}

			if (it.abilities->regeneration) {
				ss.str("");
				ss << "Faster Regeneration";
				descriptions.emplace_back("Skill Boost", ss.str());
			}

			if (it.abilities->manaShield) {
				ss.str("");
				ss << "Mana Shield";
				descriptions.emplace_back("Skill Boost", ss.str());
			}
		}

		if (it.upgradeClassification > 0) {
			descriptions.emplace_back("Tier", std::to_string(item->getTier()));
		}

		std::string slotName;
		if (item->getImbuementSlot() > 0) {
			for (uint8_t i = 0; i < item->getImbuementSlot(); ++i) {
				slotName = fmt::format("Imbuement Slot {}", i + 1);
				ss.str("");
				const auto &castItem = item;
				if (!castItem) {
					continue;
				}

				ImbuementInfo imbuementInfo;
				if (!castItem->getImbuementInfo(i, &imbuementInfo)) {
					ss << "empty";
					descriptions.emplace_back(slotName, ss.str());
					continue;
				}

				const BaseImbuement* baseImbuement = g_imbuements().getBaseByID(imbuementInfo.imbuement->getBaseID());
				if (!baseImbuement) {
					continue;
				}

				auto minutes = imbuementInfo.duration / 60;
				auto hours = minutes / 60;
				ss << fmt::format("{} {} ({}), lasts {:02}:{:02}h while fighting.", baseImbuement->name, imbuementInfo.imbuement->getName(), imbuementInfo.imbuement->getDescription(), hours, minutes % 60);
				isTradeable = false;
				descriptions.emplace_back(slotName, ss.str());
			}
		}

		std::string augmentsDescription = parseAugmentDescription(item, true);
		if (!augmentsDescription.empty()) {
			descriptions.emplace_back("Augments", augmentsDescription);
		}

		if (it.isKey()) {
			ss.str("");
			ss << fmt::format("{:04}", item->getAttribute<uint16_t>(ItemAttribute_t::ACTIONID));
			descriptions.emplace_back("Key", ss.str());
		}

		if (it.isFluidContainer()) {
			ss.str("");

			uint16_t subType = item->getSubType();
			if (subType > 0) {
				const std::string &itemName = items[subType].name;
				ss << (!itemName.empty() ? itemName : "Nothing");
			} else {
				ss << "Nothing";
			}
			descriptions.emplace_back("Contain", "Nothing");
		}

		if (it.isRune()) {
			descriptions.emplace_back("Rune Spell Name", it.runeSpellName);
		}

		if (it.showCharges) {
			int32_t charges = item->getCharges();
			if (charges != 0) {
				ss.str("");
				// Missing Actual Charges
				ss << charges << "/" << charges;
				descriptions.emplace_back("Charges", ss.str());
			}
		}

		if (it.showDuration) {
			ss.str("");
			ss << "brand-new";
			descriptions.emplace_back("Expires", ss.str());
		}

		uint32_t weight = item->getWeight();
		if (weight != 0) {
			ss.str("");
			if (weight < 10) {
				ss << "0.0" << weight;
			} else if (weight < 100) {
				ss << "0." << weight;
			} else {
				std::string weightString = std::to_string(weight);
				weightString.insert(weightString.end() - 2, '.');
				ss << weightString;
			}

			ss << " oz";
			if (item->getContainer()) {
				descriptions.emplace_back("Total Weight", ss.str());
			} else {
				descriptions.emplace_back("Weight", ss.str());
			}
		}

		if (it.wieldInfo & WIELDINFO_PREMIUM) {
			descriptions.emplace_back("Required", "Premium");
		}

		if (it.minReqLevel != 0) {
			descriptions.emplace_back("Required Level", std::to_string(it.minReqLevel));
		}

		if (it.minReqMagicLevel != 0) {
			descriptions.emplace_back("Required Magic Level", std::to_string(it.minReqMagicLevel));
		}

		if (!it.vocationString.empty()) {
			descriptions.emplace_back("Professions", it.vocationString);
		}

		// Missing Tradeable Conditions
		if (isTradeable) {
			descriptions.emplace_back("Tradeable", "yes");
		}

		std::string weaponName = getWeaponName(it.weaponType);
		if (it.slotPosition & SLOTP_TWO_HAND) {
			if (!weaponName.empty()) {
				weaponName += ", two-handed";
			} else {
				weaponName = "two-handed";
			}
		}
		if (!weaponName.empty()) {
			descriptions.emplace_back("Weapon Type", weaponName);
		}

		if (it.slotPosition & SLOTP_BACKPACK) {
			descriptions.emplace_back("Body Position", "container");
		} else if (it.slotPosition & SLOTP_HEAD) {
			descriptions.emplace_back("Body Position", "head");
		} else if (it.slotPosition & SLOTP_ARMOR) {
			descriptions.emplace_back("Body Position", "body");
		} else if (it.slotPosition & SLOTP_LEGS) {
			descriptions.emplace_back("Body Position", "legs");
		} else if (it.slotPosition & SLOTP_FEET) {
			descriptions.emplace_back("Body Position", "feet");
		} else if (it.slotPosition & SLOTP_NECKLACE) {
			descriptions.emplace_back("Body Position", "neck");
		} else if (it.slotPosition & SLOTP_RING) {
			descriptions.emplace_back("Body Position", "finger");
		} else if (it.slotPosition & SLOTP_AMMO) {
			descriptions.emplace_back("Body Position", "extra slot");
		} else if (it.slotPosition & SLOTP_TWO_HAND) {
			descriptions.emplace_back("Body Position", "both hands");
		} else if ((it.slotPosition & SLOTP_LEFT) && it.weaponType != WEAPON_SHIELD) {
			descriptions.emplace_back("Body Position", "weapon hand");
		} else if (it.slotPosition & SLOTP_RIGHT) {
			descriptions.emplace_back("Body Position", "shield hand");
		}

		if (it.upgradeClassification > 0) {
			descriptions.emplace_back("Classification", std::to_string(it.upgradeClassification));
		}
	} else {
		if (!it.description.empty()) {
			descriptions.emplace_back("Description", it.description);
		}

		if (it.isContainer()) {
			descriptions.emplace_back("Capacity", std::to_string(it.maxItems));
		}

		int32_t attack = it.attack;
		if (it.isRanged()) {
			bool separator = false;
			if (attack != 0) {
				ss << "attack +" << attack;
				separator = true;
			}
			if (int32_t hitChance = it.hitChance;
			    hitChance != 0) {
				if (separator) {
					ss << ", ";
				}
				ss << "chance to hit +" << static_cast<int16_t>(hitChance) << "%";
				separator = true;
			}
			if (int32_t shootRange = it.shootRange;
			    shootRange != 0) {
				if (separator) {
					ss << ", ";
				}
				ss << static_cast<uint16_t>(shootRange) << " fields";
			}
			descriptions.emplace_back("Attack", ss.str());
		} else {
			std::string attackDescription;
			if (it.abilities && it.abilities->elementType != COMBAT_NONE && it.abilities->elementDamage != 0) {
				attackDescription = fmt::format("{} {}", it.abilities->elementDamage, getCombatName(it.abilities->elementType));
			}

			if (attack != 0 && !attackDescription.empty()) {
				attackDescription = fmt::format("{} physical + {}", attack, attackDescription);
			} else if (attack != 0 && attackDescription.empty()) {
				attackDescription = std::to_string(attack);
			}

			if (!attackDescription.empty()) {
				descriptions.emplace_back("Attack", attackDescription);
			}
		}

		int32_t defense = it.defense, extraDefense = it.extraDefense;
		if (defense != 0 || extraDefense != 0 || it.isMissile()) {
			if (extraDefense != 0) {
				ss.str("");
				ss << defense << ' ' << std::showpos << extraDefense << std::noshowpos;
				descriptions.emplace_back("Defence", ss.str());
			} else {
				descriptions.emplace_back("Defence", std::to_string(defense));
			}
		}

		int32_t armor = it.armor;
		if (armor != 0) {
			descriptions.emplace_back("Armor", std::to_string(armor));
		}

		if (it.abilities) {
			// Protection
			ss.str("");
			bool protection = false;
			for (size_t i = 0; i < COMBAT_COUNT; ++i) {
				if (it.abilities->absorbPercent[i] == 0) {
					continue;
				}

				if (protection) {
					ss << ", ";
				}

				ss << fmt::format("{} {:+}%", getCombatName(indexToCombatType(i)), it.abilities->absorbPercent[i]);
				protection = true;
			}
			if (protection) {
				descriptions.emplace_back("Protection", ss.str());
			}

			// Skill Boost
			ss.str("");
			bool skillBoost = false;
			if (it.abilities->speed) {
				ss << std::showpos << "speed " << it.abilities->speed << std::noshowpos;
				skillBoost = true;
			}

			for (uint8_t i = SKILL_FIRST; i <= SKILL_FISHING; i++) {
				if (!it.abilities->skills[i]) {
					continue;
				}

				if (skillBoost) {
					ss << ", ";
				}

				ss << std::showpos << getSkillName(i) << ' ' << it.abilities->skills[i] << std::noshowpos;
				skillBoost = true;
			}

			if (it.abilities->stats[STAT_MAGICPOINTS]) {
				if (skillBoost) {
					ss << ", ";
				}

				ss << std::showpos << "magic level " << it.abilities->stats[STAT_MAGICPOINTS] << std::noshowpos;
				skillBoost = true;
			}

			for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; i++) {
				auto skill = item ? item->getSkill(static_cast<skills_t>(i)) : it.getSkill(static_cast<skills_t>(i));
				if (!skill) {
					continue;
				}

				if (skillBoost) {
					ss << ", ";
				}

				if (i != SKILL_CRITICAL_HIT_CHANCE) {
					ss << std::showpos;
				}

				ss << getSkillName(i) << ' ';
				// Show float
				ss << skill / 100.;
				ss << '%' << std::noshowpos;

				skillBoost = true;
			}

			if (skillBoost) {
				descriptions.emplace_back("Skill Boost", ss.str());
			}

			for (uint8_t i = 1; i <= 11; i++) {
				if (it.abilities->specializedMagicLevel[i]) {
					ss.str("");

					ss << std::showpos << it.abilities->specializedMagicLevel[i] << std::noshowpos;
					std::string combatName = getCombatName(indexToCombatType(i));
					combatName[0] = toupper(combatName[0]);
					descriptions.emplace_back(combatName + " Magic Level", ss.str());
				}
			}

			if (it.abilities->magicShieldCapacityFlat || it.abilities->magicShieldCapacityPercent) {
				ss.str("");
				ss << std::showpos << it.abilities->magicShieldCapacityFlat << std::noshowpos << " and " << it.abilities->magicShieldCapacityPercent << "%";
				descriptions.emplace_back("Magic Shield Capacity", ss.str());
			}

			if (it.abilities->perfectShotRange) {
				ss.str("");
				ss << std::showpos << it.abilities->perfectShotDamage << std::noshowpos << " at range " << unsigned(it.abilities->perfectShotRange);
				descriptions.emplace_back("Perfect Shot", ss.str());
			}

			if (it.abilities->reflectFlat[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)]) {
				ss.str("");
				ss << it.abilities->reflectFlat[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)];
				descriptions.emplace_back("Damage Reflection", ss.str());
			}

			if (it.abilities->cleavePercent) {
				ss.str("");
				ss << std::showpos << (it.abilities->cleavePercent) << std::noshowpos << "%";
				descriptions.emplace_back("Cleave", ss.str());
			}

			if (it.abilities->conditionSuppressions[CONDITION_DRUNK] != 0) {
				ss.str("");
				ss << "Hard Drinking";
				descriptions.emplace_back("Effect", ss.str());
			}

			if (it.abilities->invisible) {
				ss.str("");
				ss << "Invisibility";
				descriptions.emplace_back("Effect", ss.str());
			}

			if (it.abilities->regeneration) {
				ss.str("");
				ss << "Faster Regeneration";
				descriptions.emplace_back("Effect", ss.str());
			}

			if (it.abilities->manaShield) {
				ss.str("");
				ss << "Mana Shield";
				descriptions.emplace_back("Effect", ss.str());
			}

			for (size_t i = 0; i < COMBAT_COUNT; ++i) {
				if (it.abilities->fieldAbsorbPercent[i] == 0) {
					continue;
				}

				ss.str("");
				ss << fmt::format("{} {:+}%", getCombatName(indexToCombatType(i)), it.abilities->fieldAbsorbPercent[i]);
				descriptions.emplace_back("Field Protection", ss.str());
			}

			if (it.abilities->conditionSuppressions[CONDITION_DRUNK] != 0) {
				ss.str("");
				ss << "Hard Drinking";
				descriptions.emplace_back("Skill Boost", ss.str());
			}

			if (it.abilities->invisible) {
				ss.str("");
				ss << "Invisibility";
				descriptions.emplace_back("Skill Boost", ss.str());
			}

			if (it.abilities->regeneration) {
				ss.str("");
				ss << "Faster Regeneration";
				descriptions.emplace_back("Skill Boost", ss.str());
			}

			if (it.abilities->manaShield) {
				ss.str("");
				ss << "Mana Shield";
				descriptions.emplace_back("Skill Boost", ss.str());
			}
		}

		if (it.imbuementSlot > 0) {
			descriptions.emplace_back("Imbuement Slots", std::to_string(it.imbuementSlot));
		}

		std::string augmentsDescription = it.parseAugmentDescription(true);
		if (!augmentsDescription.empty()) {
			descriptions.emplace_back("Augments", augmentsDescription);
		}

		if (it.isKey()) {
			ss.str("");
			ss << fmt::format("{:04}", 0);
			descriptions.emplace_back("Key", ss.str());
		}

		if (it.isFluidContainer()) {
			descriptions.emplace_back("Contain", "Nothing");
		}

		if (it.isRune()) {
			descriptions.emplace_back("Rune Spell Name", it.runeSpellName);
		}

		if (it.showCharges) {
			int32_t charges = it.charges;
			if (charges != 0) {
				ss.str("");
				// Missing Actual Charges
				ss << charges << "/" << charges;
				descriptions.emplace_back("Charges", ss.str());
			}
		}

		if (it.showDuration) {
			// Missing Total Expire Time
			descriptions.emplace_back("Total Expire Time", "brand-new");
		}

		auto weight = it.weight;
		if (weight != 0) {
			ss.str("");
			if (weight < 10) {
				ss << "0.0" << weight;
			} else if (weight < 100) {
				ss << "0." << weight;
			} else {
				std::string weightString = std::to_string(weight);
				weightString.insert(weightString.end() - 2, '.');
				ss << weightString;
			}
			ss << " oz";
			descriptions.emplace_back("Weight", ss.str());
		}

		if (it.wieldInfo & WIELDINFO_PREMIUM) {
			descriptions.emplace_back("Required", "Premium");
		}

		if (it.minReqLevel != 0) {
			descriptions.emplace_back("Required Level", std::to_string(it.minReqLevel));
		}

		if (it.minReqMagicLevel != 0) {
			descriptions.emplace_back("Required Magic Level", std::to_string(it.minReqMagicLevel));
		}

		if (!it.vocationString.empty()) {
			descriptions.emplace_back("Professions", it.vocationString);
		}

		// Missing Tradeable Conditions
		descriptions.emplace_back("Tradeable In Market", "yes");

		std::string weaponName = getWeaponName(it.weaponType);
		if (it.slotPosition & SLOTP_TWO_HAND) {
			if (!weaponName.empty()) {
				weaponName += ", two-handed";
			} else {
				weaponName = "two-handed";
			}
		}
		if (!weaponName.empty()) {
			descriptions.emplace_back("Weapon Type", weaponName);
		}

		if (it.slotPosition & SLOTP_BACKPACK) {
			descriptions.emplace_back("Body Position", "container");
		} else if (it.slotPosition & SLOTP_HEAD) {
			descriptions.emplace_back("Body Position", "head");
		} else if (it.slotPosition & SLOTP_ARMOR) {
			descriptions.emplace_back("Body Position", "body");
		} else if (it.slotPosition & SLOTP_LEGS) {
			descriptions.emplace_back("Body Position", "legs");
		} else if (it.slotPosition & SLOTP_FEET) {
			descriptions.emplace_back("Body Position", "feet");
		} else if (it.slotPosition & SLOTP_NECKLACE) {
			descriptions.emplace_back("Body Position", "neck");
		} else if (it.slotPosition & SLOTP_RING) {
			descriptions.emplace_back("Body Position", "finger");
		} else if (it.slotPosition & SLOTP_AMMO) {
			descriptions.emplace_back("Body Position", "extra slot");
		} else if (it.slotPosition & SLOTP_TWO_HAND) {
			descriptions.emplace_back("Body Position", "both hands");
		} else if ((it.slotPosition & SLOTP_LEFT) && it.weaponType != WEAPON_SHIELD) {
			descriptions.emplace_back("Body Position", "weapon hand");
		} else if (it.slotPosition & SLOTP_RIGHT) {
			descriptions.emplace_back("Body Position", "shield hand");
		}

		if (it.upgradeClassification > 0) {
			descriptions.emplace_back("Classification", std::to_string(it.upgradeClassification));
		}
	}
	descriptions.shrink_to_fit();
	return descriptions;
}

std::string Item::parseImbuementDescription(const std::shared_ptr<Item> &item) {
	std::ostringstream s;
	if (item && item->getImbuementSlot() >= 1) {
		s << std::endl
		  << "Imbuements: (";

		for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
			if (slotid >= 1) {
				s << ", ";
			}

			ImbuementInfo imbuementInfo;
			if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
				s << "Empty Slot";
				continue;
			}

			const BaseImbuement* baseImbuement = g_imbuements().getBaseByID(imbuementInfo.imbuement->getBaseID());
			if (!baseImbuement) {
				continue;
			}

			const int minutes = imbuementInfo.duration / 60;
			int hours = minutes / 60;
			s << fmt::format("{} {} {:02}:{:02}h", baseImbuement->name, imbuementInfo.imbuement->getName(), hours, minutes % 60);
		}
		s << ").";
	}

	return s.str();
}

bool Item::isSavedToHouses() {
	const auto &it = items[id];
	return it.movable || it.isWrappable() || it.isCarpet() || getDoor() || (getContainer() && !getContainer()->empty()) || it.canWriteText || getBed() || it.m_transformOnUse;
}

SoundEffect_t Item::getMovementSound(const std::shared_ptr<Cylinder> &toCylinder) const {
	if (!toCylinder) {
		return SoundEffect_t::ITEM_MOVE_DEFAULT;
	}

	if (const auto &toContainer = toCylinder->getContainer();
	    toContainer && toContainer->getHoldingPlayer()) {
		return SoundEffect_t::ITEM_MOVE_BACKPACK;
	}

	switch (items[id].type) {
		case ITEM_TYPE_ARMOR: {
			return SoundEffect_t::ITEM_MOVE_ARMORS;
		}
		case ITEM_TYPE_AMULET: {
			return SoundEffect_t::ITEM_MOVE_NECKLACES;
		}
		case ITEM_TYPE_BOOTS: {
			return SoundEffect_t::ITEM_MOVE_BOOTS;
		}
		case ITEM_TYPE_CONTAINER: {
			return SoundEffect_t::ITEM_MOVE_BACKPACK;
		}
		case ITEM_TYPE_HELMET: {
			return SoundEffect_t::ITEM_MOVE_HELMETS;
		}
		case ITEM_TYPE_LEGS: {
			return SoundEffect_t::ITEM_MOVE_LEGS;
		}
		case ITEM_TYPE_RING: {
			return SoundEffect_t::ITEM_MOVE_RINGS;
		}
		case ITEM_TYPE_DISTANCE: {
			return SoundEffect_t::ITEM_MOVE_DISTANCE;
		}
		case ITEM_TYPE_QUIVER: {
			return SoundEffect_t::ITEM_MOVE_QUIVERS;
		}
		case ITEM_TYPE_VALUABLE: {
			return SoundEffect_t::ITEM_MOVE_STACKABLE;
		}

		case ITEM_TYPE_WAND:
		case ITEM_TYPE_SHIELD:
		case ITEM_TYPE_TOOLS:
		case ITEM_TYPE_AMMO: {
			return SoundEffect_t::ITEM_MOVE_WOOD;
		}

		case ITEM_TYPE_AXE:
		case ITEM_TYPE_SWORD:
		case ITEM_TYPE_CLUB: {
			return SoundEffect_t::ITEM_MOVE_METALIC;
		}

		default:
			break;
	}

	return SoundEffect_t::ITEM_MOVE_DEFAULT;
}

std::string Item::parseClassificationDescription(const std::shared_ptr<Item> &item) {
	std::ostringstream string;
	if (item && item->getClassification() >= 1) {
		string << std::endl
			   << "Classification: " << std::to_string(item->getClassification()) << " Tier: " << std::to_string(item->getTier());
		if (item->getTier() != 0) {
			if (Item::items[item->getID()].weaponType != WEAPON_NONE) {
				string << fmt::format(" ({:.2f}% Onslaught).", item->getFatalChance());
			} else if (g_game().getObjectCategory(item) == OBJECTCATEGORY_HELMETS) {
				string << fmt::format(" ({:.2f}% Momentum).", item->getMomentumChance());
			} else if (g_game().getObjectCategory(item) == OBJECTCATEGORY_ARMORS) {
				string << fmt::format(" ({:.2f}% Ruse).", item->getDodgeChance());
			} else if (g_game().getObjectCategory(item) == OBJECTCATEGORY_LEGS) {
				string << fmt::format(" ({:.2f}% Transcendence).", item->getTranscendenceChance());
			}
		}
	}
	return string.str();
}

std::string Item::parseShowDurationSpeed(int32_t speed, bool &begin) {
	std::ostringstream description;
	if (begin) {
		begin = false;
		description << " (";
	} else {
		description << ", ";
	}

	description << fmt::format("speed {:+}", speed);
	return description.str();
}

std::string Item::parseShowDuration(const std::shared_ptr<Item> &item) {
	if (!item) {
		return {};
	}

	std::ostringstream description;
	const uint32_t duration = item->getDuration() / 1000;
	if (item && item->hasAttribute(ItemAttribute_t::DURATION) && duration > 0) {
		description << " that will expire in ";
		if (duration >= 86400) {
			const uint16_t days = duration / 86400;
			const uint16_t hours = (duration % 86400) / 3600;
			description << days << " day" << (days != 1 ? "s" : "");

			if (hours > 0) {
				description << " and " << hours << " hour" << (hours != 1 ? "s" : "");
			}
		} else if (duration >= 3600) {
			const uint16_t hours = duration / 3600;
			const uint16_t minutes = (duration % 3600) / 60;
			description << hours << " hour" << (hours != 1 ? "s" : "");

			if (minutes > 0) {
				description << " and " << minutes << " minute" << (minutes != 1 ? "s" : "");
			}
		} else if (duration >= 60) {
			const uint16_t minutes = duration / 60;
			description << minutes << " minute" << (minutes != 1 ? "s" : "");
			const uint16_t seconds = duration % 60;

			if (seconds > 0) {
				description << " and " << seconds << " second" << (seconds != 1 ? "s" : "");
			}
		} else {
			description << duration << " second" << (duration != 1 ? "s" : "");
		}
	} else {
		description << " that is brand-new";
	}

	return description.str();
}

std::string Item::parseShowAttributesDescription(const std::shared_ptr<Item> &item, const uint16_t itemId) {
	std::ostringstream itemDescription;
	const ItemType &itemType = Item::items[itemId];

	if (itemType.armor != 0 || (item && item->getArmor() != 0) || itemType.showAttributes) {
		bool begin = itemType.isQuiver() ? false : true;

		const int32_t armor = (item ? item->getArmor() : itemType.armor);
		if (armor != 0) {
			if (begin) {
				itemDescription << " (Arm:" << armor;
				begin = false;
			} else {
				itemDescription << ", Arm:" << armor;
			}
		}

		if (itemType.abilities) {
			for (uint8_t i = SKILL_FIRST; i <= SKILL_FISHING; i++) {
				if (!itemType.abilities->skills[i]) {
					continue;
				}

				if (begin) {
					begin = false;
					itemDescription << " (";
				} else {
					itemDescription << ", ";
				}

				itemDescription << getSkillName(i) << ' ' << std::showpos << itemType.abilities->skills[i] << std::noshowpos;
			}

			for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; i++) {
				const auto skill = item ? item->getSkill(static_cast<skills_t>(i)) : itemType.getSkill(static_cast<skills_t>(i));
				if (!skill) {
					continue;
				}

				if (begin) {
					begin = false;
					itemDescription << " (";
				} else {
					itemDescription << ", ";
				}
				itemDescription << getSkillName(i) << ' ';
				if (i != SKILL_CRITICAL_HIT_CHANCE) {
					itemDescription << std::showpos;
				}
				// Show float
				itemDescription << skill / 100.;
				if (i != SKILL_CRITICAL_HIT_CHANCE) {
					itemDescription << std::noshowpos;
				}
				itemDescription << '%';
			}

			if (itemType.abilities->stats[STAT_MAGICPOINTS]) {
				if (begin) {
					begin = false;
					itemDescription << " (";
				} else {
					itemDescription << ", ";
				}

				itemDescription << "magic level " << std::showpos << itemType.abilities->stats[STAT_MAGICPOINTS] << std::noshowpos;
			}

			for (uint8_t i = 1; i <= 11; i++) {
				if (itemType.abilities->specializedMagicLevel[i]) {
					if (begin) {
						begin = false;
						itemDescription << " (";
					} else {
						itemDescription << ", ";
					}

					itemDescription << getCombatName(indexToCombatType(i)) << " magic level " << std::showpos << itemType.abilities->specializedMagicLevel[i] << std::noshowpos;
				}
			}

			if (itemType.abilities->magicShieldCapacityFlat || itemType.abilities->magicShieldCapacityPercent) {
				if (begin) {
					begin = false;
					itemDescription << " (";
				} else {
					itemDescription << ", ";
				}

				itemDescription << "Magic Shield Capacity " << std::showpos << itemType.abilities->magicShieldCapacityFlat << std::noshowpos << " and " << itemType.abilities->magicShieldCapacityPercent << "%";
			}

			if (itemType.abilities->perfectShotRange) {
				if (begin) {
					begin = false;
					itemDescription << " (";
				} else {
					itemDescription << ", ";
				}

				itemDescription << "perfect shot " << std::showpos << itemType.abilities->perfectShotDamage << std::noshowpos << " at range " << unsigned(itemType.abilities->perfectShotRange);
			}

			if (itemType.abilities->reflectFlat[0] != 0) {
				if (begin) {
					begin = false;
					itemDescription << " (";
				} else {
					itemDescription << ", ";
				}

				itemDescription << "damage reflection " << std::showpos << itemType.abilities->reflectFlat[0] << std::noshowpos;
			}

			int16_t show = itemType.abilities->absorbPercent[0];
			if (show != 0) {
				for (size_t i = 1; i < COMBAT_COUNT; ++i) {
					if (itemType.abilities->absorbPercent[i] != show) {
						show = 0;
						break;
					}
				}
			}

			if (!show) {
				bool protectionBegin = true;
				for (size_t i = 0; i < COMBAT_COUNT; ++i) {
					if (itemType.abilities->absorbPercent[i] == 0) {
						continue;
					}

					if (protectionBegin) {
						protectionBegin = false;

						if (begin) {
							begin = false;
							itemDescription << " (";
						} else {
							itemDescription << ", ";
						}

						itemDescription << "protection ";
					} else {
						itemDescription << ", ";
					}
					itemDescription << fmt::format("{} {:+}%", getCombatName(indexToCombatType(i)), itemType.abilities->absorbPercent[i]);
				}
			} else {
				if (begin) {
					begin = false;
					itemDescription << " (";
				} else {
					itemDescription << ", ";
				}

				itemDescription << fmt::format("protection all {:+}%", show);
			}

			show = itemType.abilities->fieldAbsorbPercent[0];
			if (show != 0) {
				for (size_t i = 1; i < COMBAT_COUNT; ++i) {
					if (itemType.abilities->absorbPercent[i] != show) {
						show = 0;
						break;
					}
				}
			}

			if (!show) {
				bool tmp = true;

				for (size_t i = 0; i < COMBAT_COUNT; ++i) {
					if (itemType.abilities->fieldAbsorbPercent[i] == 0) {
						continue;
					}

					if (tmp) {
						tmp = false;

						if (begin) {
							begin = false;
							itemDescription << " (";
						} else {
							itemDescription << ", ";
						}

						itemDescription << "protection ";
					} else {
						itemDescription << ", ";
					}

					itemDescription << fmt::format("{} field {:+}%", getCombatName(indexToCombatType(i)), itemType.abilities->fieldAbsorbPercent[i]);
				}
			} else {
				if (begin) {
					begin = false;
					itemDescription << " (";
				} else {
					itemDescription << ", ";
				}

				itemDescription << fmt::format("protection all fields {:+}%", show);
			}

			if (itemType.abilities->speed) {
				itemDescription << parseShowDurationSpeed(itemType.abilities->speed, begin);
			}

			if (itemType.abilities->cleavePercent) {
				if (begin) {
					begin = false;
					itemDescription << " (";
				} else {
					itemDescription << ", ";
				}

				itemDescription << "Cleave " << std::showpos << (itemType.abilities->cleavePercent) << std::noshowpos << "%";
			}
		}

		if (!begin) {
			itemDescription << ')';
		}
	}

	return itemDescription.str();
}

std::string Item::getDescription(const ItemType &it, int32_t lookDistance, const std::shared_ptr<Item> &item /*= nullptr*/, int32_t subType /*= -1*/, bool addArticle /*= true*/) {
	std::string text;

	std::ostringstream s;
	s << getNameDescription(it, item, subType, addArticle);

	if (item) {
		subType = item->getSubType();
	}

	if (it.isRune()) {
		if (it.runeLevel > 0 || it.runeMagLevel > 0) {
			if (const auto &rune = g_spells().getRuneSpell(it.id)) {
				int32_t tmpSubType = subType;
				if (item) {
					tmpSubType = item->getSubType();
				}
				s << " (\"" << it.runeSpellName << "\"). " << (it.stackable && tmpSubType > 1 ? "They" : "It") << " can only be used by ";

				const VocSpellMap &vocMap = rune->getVocMap();
				std::vector<std::shared_ptr<Vocation>> showVocMap;

				// vocations are usually listed with the unpromoted and promoted version, the latter being
				// hidden from description, so `total / 2` is most likely the amount of vocations to be shown.
				showVocMap.reserve(vocMap.size() / 2);
				for (const auto &voc : vocMap) {
					if (voc.second) {
						showVocMap.push_back(g_vocations().getVocation(voc.first));
					}
				}

				if (!showVocMap.empty()) {
					auto vocIt = showVocMap.begin(), vocLast = (showVocMap.end() - 1);
					while (vocIt != vocLast) {
						s << asLowerCaseString((*vocIt)->getVocName()) << "s";
						if (++vocIt == vocLast) {
							s << " and ";
						} else {
							s << ", ";
						}
					}
					s << asLowerCaseString((*vocLast)->getVocName()) << "s";
				} else {
					s << "players";
				}

				s << " with";

				if (it.runeLevel > 0) {
					s << " level " << it.runeLevel;
				}

				if (it.runeMagLevel > 0) {
					if (it.runeLevel > 0) {
						s << " and";
					}

					s << " magic level " << it.runeMagLevel;
				}

				s << " or higher";
			}
		}
	} else if (it.weaponType != WEAPON_NONE) {
		if (it.weaponType == WEAPON_DISTANCE && it.ammoType != AMMO_NONE) {
			bool begin = true;
			begin = false;
			s << " (Range: " << static_cast<uint16_t>(item ? item->getShootRange() : it.shootRange);

			int32_t attack;
			int8_t hitChance;
			if (item) {
				attack = item->getAttack();
				hitChance = item->getHitChance();
			} else {
				attack = it.attack;
				hitChance = it.hitChance;
			}

			if (attack != 0) {
				s << ", Atk " << std::showpos << attack << std::noshowpos;
			}

			if (hitChance != 0) {
				s << ", Hit% " << std::showpos << static_cast<int16_t>(hitChance) << std::noshowpos;
			}

			if (it.abilities) {
				for (uint8_t i = SKILL_FIRST; i <= SKILL_FISHING; i++) {
					if (!it.abilities->skills[i]) {
						continue;
					}

					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << getSkillName(i) << ' ' << std::showpos << it.abilities->skills[i] << std::noshowpos;
				}

				for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; i++) {
					auto skill = item ? item->getSkill(static_cast<skills_t>(i)) : it.getSkill(static_cast<skills_t>(i));
					if (!skill) {
						continue;
					}

					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}
					s << getSkillName(i) << ' ';
					if (i != SKILL_CRITICAL_HIT_CHANCE) {
						s << std::showpos;
					}
					// Show float
					s << skill / 100.;
					if (i != SKILL_CRITICAL_HIT_CHANCE) {
						s << std::noshowpos;
					}
					s << '%';
				}

				if (it.abilities->stats[STAT_MAGICPOINTS]) {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << "magic level " << std::showpos << it.abilities->stats[STAT_MAGICPOINTS] << std::noshowpos;
				}

				for (uint8_t i = 1; i <= 11; i++) {
					if (it.abilities->specializedMagicLevel[i]) {
						if (begin) {
							begin = false;
							s << " (";
						} else {
							s << ", ";
						}

						s << getCombatName(indexToCombatType(i)) << " magic level " << std::showpos << it.abilities->specializedMagicLevel[i] << std::noshowpos;
					}
				}

				if (it.abilities->magicShieldCapacityFlat || it.abilities->magicShieldCapacityPercent) {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << "magic shield capacity " << std::showpos << it.abilities->magicShieldCapacityFlat << std::noshowpos << " and " << it.abilities->magicShieldCapacityPercent << "%";
				}

				if (it.abilities->perfectShotRange) {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << "perfect shot " << std::showpos << it.abilities->perfectShotDamage << std::noshowpos << " at range " << unsigned(it.abilities->perfectShotRange);
				}

				if (it.abilities->reflectFlat[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)]) {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << "damage reflection " << std::showpos << it.abilities->reflectFlat[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)] << std::noshowpos;
				}

				int16_t show = it.abilities->absorbPercent[0];
				if (show != 0) {
					for (size_t i = 1; i < COMBAT_COUNT; ++i) {
						if (it.abilities->absorbPercent[i] != show) {
							show = 0;
							break;
						}
					}
				}

				if (show == 0) {
					bool tmp = true;

					for (size_t i = 0; i < COMBAT_COUNT; ++i) {
						if (it.abilities->absorbPercent[i] == 0) {
							continue;
						}

						if (tmp) {
							tmp = false;

							if (begin) {
								begin = false;
								s << " (";
							} else {
								s << ", ";
							}

							s << "protection ";
						} else {
							s << ", ";
						}

						s << fmt::format("{} {:+}%", getCombatName(indexToCombatType(i)), it.abilities->absorbPercent[i]);
					}
				} else {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << fmt::format("protection all {:+}%", show);
				}

				show = it.abilities->fieldAbsorbPercent[0];
				if (show != 0) {
					for (size_t i = 1; i < COMBAT_COUNT; ++i) {
						if (it.abilities->absorbPercent[i] != show) {
							show = 0;
							break;
						}
					}
				}

				if (show == 0) {
					bool tmp = true;

					for (size_t i = 0; i < COMBAT_COUNT; ++i) {
						if (it.abilities->fieldAbsorbPercent[i] == 0) {
							continue;
						}

						if (tmp) {
							tmp = false;

							if (begin) {
								begin = false;
								s << " (";
							} else {
								s << ", ";
							}

							s << "protection ";
						} else {
							s << ", ";
						}

						s << fmt::format("{} field {:+}%", getCombatName(indexToCombatType(i)), it.abilities->fieldAbsorbPercent[i]);
					}
				} else {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << fmt::format("protection all fields {:+}%", show);
				}

				if (it.abilities->speed) {
					s << parseShowDurationSpeed(it.abilities->speed, begin);
				}

				if (it.abilities->cleavePercent) {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << "cleave " << std::showpos << (it.abilities->cleavePercent) << std::noshowpos << "%";
				}
			}

			if (!begin) {
				s << ')';
			}
			// This block refers to the look of the weapons.
		} else if (it.weaponType != WEAPON_AMMO) {
			bool begin = true;

			int32_t attack, defense, extraDefense;
			if (item) {
				attack = item->getAttack();
				defense = item->getDefense();
				extraDefense = item->getExtraDefense();
			} else {
				attack = it.attack;
				defense = it.defense;
				extraDefense = it.extraDefense;
			}

			if (it.isContainer() || (item && item->getContainer())) {
				uint32_t volume = 0;

				if (!item || !item->hasAttribute(ItemAttribute_t::UNIQUEID)) {
					if (it.isContainer()) {
						volume = it.maxItems;
					} else if (item) {
						volume = item->getContainer()->capacity();
					}
				}

				if (volume != 0) {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << "Vol:" << volume;
				}
			}

			if (attack != 0) {
				begin = false;
				s << " (Atk:" << attack;
			}

			if (it.abilities && it.abilities->elementType != COMBAT_NONE && it.abilities->elementDamage != 0 && !begin) {
				s << " physical + " << it.abilities->elementDamage << ' ' << getCombatName(it.abilities->elementType);
			} else if (it.abilities && it.abilities->elementType != COMBAT_NONE && it.abilities->elementDamage != 0 && begin) {
				begin = false;
				s << " (" << it.abilities->elementDamage << ' ' << getCombatName(it.abilities->elementType);
			}

			if (defense != 0 || extraDefense != 0 || it.isMissile()) {
				if (begin) {
					begin = false;
					s << " (";
				} else {
					s << ", ";
				}

				s << "Def:" << defense;
				if (extraDefense != 0) {
					s << ' ' << std::showpos << extraDefense << std::noshowpos;
				}
			}

			if (it.abilities) {
				for (uint8_t i = SKILL_FIRST; i <= SKILL_FISHING; i++) {
					if (!it.abilities->skills[i]) {
						continue;
					}

					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << getSkillName(i) << ' ' << std::showpos << it.abilities->skills[i] << std::noshowpos;
				}

				if (it.abilities->regeneration) {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << "faster regeneration";
				}

				for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; i++) {
					auto skill = item ? item->getSkill(static_cast<skills_t>(i)) : it.getSkill(static_cast<skills_t>(i));
					if (!skill) {
						continue;
					}

					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}
					s << getSkillName(i) << ' ';
					if (i != SKILL_CRITICAL_HIT_CHANCE) {
						s << std::showpos;
					}
					// Show float
					s << skill / 100.;
					if (i != SKILL_CRITICAL_HIT_CHANCE) {
						s << std::noshowpos;
					}
					s << '%';
				}

				if (it.abilities->stats[STAT_MAGICPOINTS]) {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << "magic level " << std::showpos << it.abilities->stats[STAT_MAGICPOINTS] << std::noshowpos;
				}

				for (uint8_t i = 1; i <= 11; i++) {
					if (it.abilities->specializedMagicLevel[i]) {
						if (begin) {
							begin = false;
							s << " (";
						} else {
							s << ", ";
						}

						s << getCombatName(indexToCombatType(i)) << " magic level " << std::showpos << it.abilities->specializedMagicLevel[i] << std::noshowpos;
					}
				}

				if (it.abilities->magicShieldCapacityFlat || it.abilities->magicShieldCapacityPercent) {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << "magic shield capacity " << std::showpos << it.abilities->magicShieldCapacityFlat << std::noshowpos << " and " << it.abilities->magicShieldCapacityPercent << "%";
				}

				if (it.abilities->perfectShotRange) {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << "perfect shot " << std::showpos << it.abilities->perfectShotDamage << std::noshowpos << " at range " << unsigned(it.abilities->perfectShotRange);
				}

				if (it.abilities->reflectFlat[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)]) {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << "damage reflection " << std::showpos << it.abilities->reflectFlat[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)] << std::noshowpos;
				}

				int16_t show = it.abilities->absorbPercent[0];
				if (show != 0) {
					for (size_t i = 1; i < COMBAT_COUNT; ++i) {
						if (it.abilities->absorbPercent[i] != show) {
							show = 0;
							break;
						}
					}
				}

				if (show == 0) {
					bool tmp = true;

					for (size_t i = 0; i < COMBAT_COUNT; ++i) {
						if (it.abilities->absorbPercent[i] == 0) {
							continue;
						}

						if (tmp) {
							tmp = false;

							if (begin) {
								begin = false;
								s << " (";
							} else {
								s << ", ";
							}

							s << "protection ";
						} else {
							s << ", ";
						}

						s << fmt::format("{} {:+}%", getCombatName(indexToCombatType(i)), it.abilities->absorbPercent[i]);
					}
				} else {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << fmt::format("protection all {:+}%", show);
				}

				show = it.abilities->fieldAbsorbPercent[0];
				if (show != 0) {
					for (size_t i = 1; i < COMBAT_COUNT; ++i) {
						if (it.abilities->absorbPercent[i] != show) {
							show = 0;
							break;
						}
					}
				}

				if (show == 0) {
					bool tmp = true;

					for (size_t i = 0; i < COMBAT_COUNT; ++i) {
						if (it.abilities->fieldAbsorbPercent[i] == 0) {
							continue;
						}

						if (tmp) {
							tmp = false;

							if (begin) {
								begin = false;
								s << " (";
							} else {
								s << ", ";
							}

							s << "protection ";
						} else {
							s << ", ";
						}

						s << fmt::format("{} field {:+}%", getCombatName(indexToCombatType(i)), it.abilities->fieldAbsorbPercent[i]);
					}
				} else {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << fmt::format("protection all fields {:+}%", show);
				}

				if (it.abilities->speed) {
					s << parseShowDurationSpeed(it.abilities->speed, begin);
				}

				if (it.abilities->cleavePercent) {
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << "Cleave " << std::showpos << (it.abilities->cleavePercent) << std::noshowpos << "%";
				}
			}

			if (!begin) {
				s << ')';
			}
		}
	} else if (it.isContainer() || (item && item->getContainer())) {
		uint32_t volume = 0;
		if (!item || !item->hasAttribute(ItemAttribute_t::UNIQUEID)) {
			if (it.isContainer()) {
				volume = it.maxItems;
			} else {
				volume = item->getContainer()->capacity();
			}
		}

		if (volume != 0 && !it.isQuiver()) {
			s << " (Vol:" << volume << ')';
		} else if (volume != 0 && it.isQuiver()) {
			s << " (Vol:" << volume;
		}
	} else {
		bool found = true;

		if (it.abilities && it.slotPosition & SLOTP_RING) {
			if (it.abilities->speed > 0) {
				bool begin = true;
				s << parseShowDurationSpeed(it.abilities->speed, begin) << ")" << parseShowDuration(item);
			} else if (it.abilities->conditionSuppressions[CONDITION_DRUNK] != 0) {
				s << " (hard drinking)";
			} else if (it.abilities->invisible) {
				s << " (invisibility)";
			} else if (it.abilities->regeneration) {
				s << " (faster regeneration)";
			} else if (it.abilities->manaShield) {
				s << " (mana shield)";
			} else {
				found = false;
			}
		} else {
			found = false;
		}

		if (!found) {
			if (it.isKey()) {
				s << fmt::format(" (Key:{:04})", item ? item->getAttribute<uint16_t>(ItemAttribute_t::ACTIONID) : 0);
			} else if (it.isFluidContainer()) {
				if (subType > 0) {
					const std::string &itemName = items[subType].name;
					s << " of " << (!itemName.empty() ? itemName : "unknown");
				} else {
					s << ". It is empty";
				}
			} else if (it.isSplash()) {
				s << " of ";

				if (subType > 0 && !items[subType].name.empty()) {
					s << items[subType].name;
				} else {
					s << "unknown";
				}
			} else if (it.allowDistRead && (it.id < 7369 || it.id > 7371)) {
				s << '.' << std::endl;

				if (lookDistance <= 4) {
					if (item) {
						text = item->getAttribute<std::string>(ItemAttribute_t::TEXT);
						if (!text.empty()) {
							const std::string &writer = item->getAttribute<std::string>(ItemAttribute_t::WRITER);
							if (!writer.empty()) {
								s << writer << " wrote";
								auto date = item->getAttribute<time_t>(ItemAttribute_t::DATE);
								if (date != 0) {
									s << " on " << formatDateShort(date);
								}
								s << ": ";
							} else {
								s << "You read: ";
							}
							s << text;
						} else {
							s << "Nothing is written on it";
						}
					} else {
						s << "Nothing is written on it";
					}
				} else {
					s << "You are too far away to read it";
				}
			} else if (it.levelDoor != 0 && item) {
				auto actionId = item->getAttribute<uint16_t>(ItemAttribute_t::ACTIONID);
				if (actionId >= it.levelDoor) {
					s << " for level " << (actionId - it.levelDoor);
				}
			}
		}
	}

	if (it.transformEquipTo != 0) {
		s << parseShowAttributesDescription(item, it.transformEquipTo);
	} else {
		s << parseShowAttributesDescription(item, it.id);
	}

	if (it.showCharges) {
		if (subType == 0) {
			s << " that has " << it.charges << " charge" << (subType != 1 ? "s" : "") << " left";
		} else {
			s << " that has " << subType << " charge" << (subType != 1 ? "s" : "") << " left";
		}
	}

	if (it.showDuration) {
		s << parseShowDuration(item);
	}

	if (!it.allowDistRead || (it.id >= 7369 && it.id <= 7371)) {
		s << '.';
	} else {
		if (text.empty() && item) {
			text = item->getAttribute<std::string>(ItemAttribute_t::TEXT);
		}

		if (text.empty()) {
			s << '.';
		}
	}

	if (it.wieldInfo != 0) {
		s << std::endl
		  << "It can only be wielded properly by ";

		if (it.wieldInfo & WIELDINFO_PREMIUM) {
			s << "premium ";
		}

		if (!it.vocationString.empty()) {
			s << it.vocationString;
		} else {
			s << "players";
		}

		if (it.wieldInfo & WIELDINFO_LEVEL) {
			s << " of level " << it.minReqLevel << " or higher";
		}

		if (it.wieldInfo & WIELDINFO_MAGLV) {
			if (it.wieldInfo & WIELDINFO_LEVEL) {
				s << " and";
			} else {
				s << " of";
			}

			s << " magic level " << it.minReqMagicLevel << " or higher";
		}

		s << '.';
	}

	s << parseAugmentDescription(item);

	s << parseImbuementDescription(item);

	s << parseClassificationDescription(item);

	if (lookDistance <= 1) {
		if (item) {
			const uint32_t weight = item->getWeight();
			if (weight != 0 && it.pickupable) {
				s << std::endl
				  << getWeightDescription(it, weight, item->getItemCount());
			}
		} else if (it.weight != 0 && it.pickupable) {
			s << std::endl
			  << getWeightDescription(it, it.weight);
		}
	}

	if (item) {
		const std::string &specialDescription = item->getAttribute<std::string>(ItemAttribute_t::DESCRIPTION);
		if (!specialDescription.empty()) {
			s << std::endl
			  << specialDescription;
		} else if (lookDistance <= 1 && !it.description.empty()) {
			s << std::endl
			  << it.description;
		}
	} else if (lookDistance <= 1 && !it.description.empty()) {
		s << std::endl
		  << it.description;
	}

	if (it.allowDistRead && it.id >= 7369 && it.id <= 7371) {
		if (text.empty() && item) {
			text = item->getAttribute<std::string>(ItemAttribute_t::TEXT);
		}

		if (!text.empty()) {
			s << std::endl
			  << text;
		}
	}
	return s.str();
}

std::string Item::getDescription(int32_t lookDistance) {
	const ItemType &it = items[id];
	return getDescription(it, lookDistance, getItem());
}

std::string Item::getNameDescription(const ItemType &it, const std::shared_ptr<Item> &item /*= nullptr*/, int32_t subType /*= -1*/, bool addArticle /*= true*/) {
	if (item) {
		subType = item->getSubType();
	}

	std::ostringstream s;

	const std::string &name = (item ? item->getName() : it.name);
	if (!name.empty()) {
		if (it.stackable && subType > 1) {
			if (it.showCount) {
				s << subType << ' ';
			}

			s << (item ? item->getPluralName() : it.getPluralName());
		} else {
			if (addArticle) {
				const std::string &article = (item ? item->getArticle() : it.article);
				if (!article.empty()) {
					s << article << ' ';
				}
			}

			s << name;
		}
	} else {
		s << "an item of type " << it.id;
	}
	return s.str();
}

std::string Item::getNameDescription() {
	const ItemType &it = items[id];
	return getNameDescription(it, getItem());
}

std::string Item::getWeightDescription(const ItemType &it, uint32_t weight, uint32_t count /*= 1*/) {
	std::ostringstream ss;
	if (it.stackable && count > 1 && it.showCount != 0) {
		ss << "They weigh ";
	} else {
		ss << "It weighs ";
	}

	if (weight < 10) {
		ss << "0.0" << weight;
	} else if (weight < 100) {
		ss << "0." << weight;
	} else {
		std::string weightString = std::to_string(weight);
		weightString.insert(weightString.end() - 2, '.');
		ss << weightString;
	}

	ss << " oz.";
	return ss.str();
}

std::string Item::getWeightDescription(uint32_t weight) const {
	const ItemType &it = Item::items[id];
	return getWeightDescription(it, weight, getItemCount());
}

std::string Item::getWeightDescription() const {
	const uint32_t weight = getWeight();
	if (weight == 0) {
		return {};
	}
	return getWeightDescription(weight);
}

void Item::addUniqueId(uint16_t uniqueId) {
	if (hasAttribute(ItemAttribute_t::UNIQUEID)) {
		return;
	}

	if (g_game().addUniqueItem(uniqueId, static_self_cast<Item>())) {
		setAttribute(ItemAttribute_t::UNIQUEID, uniqueId);
	}
}

bool Item::canDecay() {
	const ItemType &it = Item::items[id];
	if (it.decayTo < 0 || it.decayTime == 0 || isDecayDisabled()) {
		return false;
	}

	if (hasAttribute(ItemAttribute_t::UNIQUEID)) {
		return false;
	}

	// In certain conditions, such as depth nested containers, this can overload the CPU, so it is left last.
	if (isRemoved()) {
		return false;
	}

	return true;
}

uint32_t Item::getWorth() const {
	switch (id) {
		case ITEM_GOLD_COIN:
			return count;

		case ITEM_PLATINUM_COIN:
			return count * 100;

		case ITEM_CRYSTAL_COIN:
			return count * 10000;

		default:
			return 0;
	}
}

uint32_t Item::getForgeSlivers() const {
	if (getID() == ITEM_FORGE_SLIVER) {
		return getItemCount();
	} else {
		return 0;
	}
}

uint32_t Item::getForgeCores() const {
	if (getID() == ITEM_FORGE_CORE) {
		return getItemCount();
	} else {
		return 0;
	}
}

LightInfo Item::getLightInfo() const {
	const ItemType &it = items[id];
	return { it.lightLevel, it.lightColor };
}

void Item::startDecaying() {
	g_decay().startDecay(static_self_cast<Item>());
}

void Item::stopDecaying() {
	g_decay().stopDecay(static_self_cast<Item>());
}

std::shared_ptr<Item> Item::transform(uint16_t itemId, uint16_t itemCount /*= -1*/) {
	std::shared_ptr<Cylinder> cylinder = getParent();
	if (cylinder == nullptr) {
		g_logger().info("[{}] failed to transform item {}, cylinder is nullptr", __FUNCTION__, getID());
		return nullptr;
	}

	const auto &fromTile = cylinder->getTile();
	if (fromTile) {
		const auto it = g_game().browseFields.find(fromTile);
		if (it != g_game().browseFields.end() && it->second.lock() == cylinder) {
			cylinder = fromTile;
		}
	}

	std::shared_ptr<Item> newItem;
	if (itemCount == 0) {
		newItem = Item::CreateItem(itemId, 1);
	} else {
		newItem = Item::CreateItem(itemId, itemCount);
	}

	const int32_t itemIndex = cylinder->getThingIndex(static_self_cast<Item>());
	const auto duration = getDuration();
	if (duration > 0) {
		newItem->setDuration(duration);
	}

	cylinder->replaceThing(itemIndex, newItem);
	cylinder->postAddNotification(newItem, cylinder, itemIndex);

	resetParent();
	cylinder->postRemoveNotification(static_self_cast<Item>(), cylinder, itemIndex);
	stopDecaying();
	newItem->startDecaying();
	return newItem;
}

bool Item::hasMarketAttributes() const {
	if (!isInitializedAttributePtr()) {
		return true;
	}

	for (const auto &attribute : getAttributeVector()) {
		if (attribute.getAttributeType() == ItemAttribute_t::CHARGES && static_cast<uint16_t>(attribute.getInteger()) != items[id].charges) {
			return false;
		}

		if (attribute.getAttributeType() == ItemAttribute_t::DURATION && static_cast<uint32_t>(attribute.getInteger()) != getDefaultDuration()) {
			return false;
		}

		if (attribute.getAttributeType() == ItemAttribute_t::TIER && static_cast<uint8_t>(attribute.getInteger()) != getTier()) {
			return false;
		}
	}

	return !hasImbuements() && !isStoreItem() && !hasOwner();
}

bool Item::isInsideDepot(bool includeInbox /* = false*/) {
	const auto &thisContainer = getContainer();
	if (thisContainer && (thisContainer->getDepotLocker() || thisContainer->isDepotChest() || (includeInbox && thisContainer->isInbox()))) {
		return true;
	}

	const auto &cylinder = getParent();
	if (!cylinder) {
		return false;
	}

	auto container = cylinder->getContainer();
	if (!container) {
		return false;
	}

	while (container) {
		if (container->getDepotLocker() || container->isDepotChest() || (includeInbox && container->isInbox())) {
			return true;
		}

		container = container->getParent() ? container->getParent()->getContainer() : nullptr;
	}

	return false;
}

void Item::updateTileFlags() {
	if (const auto &tile = getTile()) {
		tile->updateTileFlags(static_self_cast<Item>());
	}
}

// Custom Attributes

const std::map<std::string, CustomAttribute, std::less<>> &ItemProperties::getCustomAttributeMap() const {
	static std::map<std::string, CustomAttribute, std::less<>> map = {};
	if (!attributePtr) {
		return map;
	}
	return attributePtr->getCustomAttributeMap();
}

int32_t ItemProperties::getDuration() const {
	ItemDecayState_t decayState = getDecaying();
	if (decayState == DECAYING_TRUE || decayState == DECAYING_STOPPING) {
		return std::max<int32_t>(0, getAttribute<int32_t>(ItemAttribute_t::DURATION_TIMESTAMP) - static_cast<int32_t>(OTSYS_TIME()));
	} else {
		return getAttribute<int32_t>(ItemAttribute_t::DURATION);
	}
}
