/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#include "pch.hpp"

#include "items/item.h"
#include "items/functions/item/item_parse.hpp"
#include "items/containers/container.h"
#include "items/decay/decay.h"
#include "game/movement/teleport.h"
#include "items/trashholder.h"
#include "items/containers/mailbox/mailbox.h"
#include "map/house/house.h"
#include "game/game.h"
#include "items/bed.h"
#include "containers/rewards/rewardchest.h"
#include "creatures/players/imbuements/imbuements.h"
#include "lua/creature/actions.h"
#include "creatures/combat/spells.h"

#define ITEM_IMBUEMENT_SLOT 500

Items Item::items;

Item* Item::CreateItem(const uint16_t type, uint16_t count /*= 0*/) {
	Item* newItem = nullptr;

	const ItemType &it = Item::items[type];
	if (it.stackable && count == 0) {
		count = 1;
	}

	if (it.id != 0) {
		if (it.isDepot()) {
			newItem = new DepotLocker(type);
		} else if (it.isRewardChest()) {
			newItem = new RewardChest(type);
		} else if (it.isContainer()) {
			newItem = new Container(type);
		} else if (it.isTeleport()) {
			newItem = new Teleport(type);
		} else if (it.isMagicField()) {
			newItem = new MagicField(type);
		} else if (it.isDoor()) {
			newItem = new Door(type);
		} else if (it.isTrashHolder()) {
			newItem = new TrashHolder(type);
		} else if (it.isMailbox()) {
			newItem = new Mailbox(type);
		} else if (it.isBed()) {
			newItem = new BedItem(type);
		} else {
			auto itemMap = ItemTransformationMap.find(static_cast<ItemID_t>(it.id));
			if (itemMap != ItemTransformationMap.end()) {
				newItem = new Item(itemMap->second, count);
			} else {
				newItem = new Item(type, count);
			}
		}

		newItem->incrementReferenceCounter();
	} else if (type != 0) {
		SPDLOG_WARN("[Item::CreateItem] Item with id '{}' is not registered and cannot be created.", type);
	}

	return newItem;
}

bool Item::getImbuementInfo(uint8_t slot, ImbuementInfo* imbuementInfo) const {
	const CustomAttribute* attribute = getCustomAttribute(std::to_string(ITEM_IMBUEMENT_SLOT + slot));
	auto info = attribute ? attribute->getAttribute<uint32_t>() : 0;
	imbuementInfo->imbuement = g_imbuements().getImbuement(info & 0xFF);
	imbuementInfo->duration = info >> 8;
	return imbuementInfo->duration && imbuementInfo->imbuement;
}

void Item::setImbuement(uint8_t slot, uint16_t imbuementId, uint32_t duration) {
	auto valueDuration = (static_cast<int64_t>(duration > 0 ? (duration << 8) | imbuementId : 0));
	setCustomAttribute(std::to_string(ITEM_IMBUEMENT_SLOT + slot), valueDuration);
}

void Item::addImbuement(uint8_t slot, uint16_t imbuementId, uint32_t duration) {
	Player* player = getHoldingPlayer();
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
		SPDLOG_ERROR("[Item::setImbuement] - An error occurred while player with name {} try to apply imbuement, item already contains imbuement of the same type: {}", player->getName(), imbuement->getName());
		player->sendImbuementResult("An error ocurred, please reopen imbuement window.");
		return;
	}

	setImbuement(slot, imbuementId, duration);
}

bool Item::hasImbuementCategoryId(uint16_t categoryId) const {
	for (uint8_t slotid = 0; slotid < getImbuementSlot(); slotid++) {
		ImbuementInfo imbuementInfo;
		if (getImbuementInfo(slotid, &imbuementInfo)) {
			const CategoryImbuement* categoryImbuement = g_imbuements().getCategoryByID(imbuementInfo.imbuement->getCategory());
			if (categoryImbuement->id == categoryId) {
				return true;
			}
		}
	}
	return false;
}

Container* Item::CreateItemAsContainer(const uint16_t type, uint16_t size) {
	if (const ItemType &it = Item::items[type];
		it.id == 0
		|| it.stackable
		|| it.multiUse
		|| it.moveable
		|| it.pickupable
		|| it.isDepot()
		|| it.isSplash()
		|| it.isDoor()) {
		return nullptr;
	}

	Container* newItem = new Container(type, size);
	newItem->incrementReferenceCounter();
	return newItem;
}

Item* Item::CreateItem(PropStream &propStream) {
	uint16_t id;
	if (!propStream.read<uint16_t>(id)) {
		return nullptr;
	}

	switch (id) {
		case ITEM_FIREFIELD_PVP_FULL:
			id = ITEM_FIREFIELD_PERSISTENT_FULL;
			break;

		case ITEM_FIREFIELD_PVP_MEDIUM:
			id = ITEM_FIREFIELD_PERSISTENT_MEDIUM;
			break;

		case ITEM_FIREFIELD_PVP_SMALL:
			id = ITEM_FIREFIELD_PERSISTENT_SMALL;
			break;

		case ITEM_ENERGYFIELD_PVP:
			id = ITEM_ENERGYFIELD_PERSISTENT;
			break;

		case ITEM_POISONFIELD_PVP:
			id = ITEM_POISONFIELD_PERSISTENT;
			break;

		case ITEM_MAGICWALL:
			id = ITEM_MAGICWALL_PERSISTENT;
			break;

		case ITEM_WILDGROWTH:
			id = ITEM_WILDGROWTH_PERSISTENT;
			break;

		default:
			break;
	}

	return Item::CreateItem(id, 0);
}

Item::Item(const uint16_t itemId, uint16_t itemCount /*= 0*/) :
	id(itemId) {
	const ItemType &it = items[id];
	auto itemCharges = it.charges;
	if (it.isFluidContainer() || it.isSplash()) {
		setAttribute(ItemAttribute_t::FLUIDTYPE, itemCount);
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

Item::Item(const Item &i) :
	Thing(), id(i.id), count(i.count), loadedFromMap(i.loadedFromMap) {
	if (i.initAttributePtr()) {
		initAttributePtr().reset(new ItemAttribute());
	}
}

Item* Item::clone() const {
	Item* item = Item::CreateItem(id, count);
	if (item == nullptr) {
		SPDLOG_ERROR("[{}] item is nullptr", __FUNCTION__);
		return nullptr;
	}

	if (initAttributePtr()) {
		item->initAttributePtr().reset(new ItemAttribute());
	}

	return item;
}

bool Item::equals(const Item* compareItem) const {
	if (!compareItem) {
		return false;
	}

	if (id != compareItem->id) {
		return false;
	}

	for (const auto &attribute : initAttributePtr()->getAttributeVector()) {
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

	auto itemCharges = it.charges;
	if (itemCharges != 0) {
		if (it.stackable) {
			setItemCount(static_cast<uint8_t>(itemCharges));
		} else {
			setAttribute(ItemAttribute_t::CHARGES, it.charges);
		}
	}
}

void Item::onRemoved() {
	ScriptEnvironment::removeTempItem(this);

	if (hasAttribute(ItemAttribute_t::UNIQUEID)) {
		g_game().removeUniqueItem(getAttribute<uint16_t>(ItemAttribute_t::UNIQUEID));
	}
}

void Item::setID(uint16_t newid) {
	const ItemType &prevIt = Item::items[id];
	id = newid;

	const ItemType &it = Item::items[newid];
	uint32_t newDuration = it.decayTime * 1000;

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

Cylinder* Item::getTopParent() {
	Cylinder* aux = getParent();
	Cylinder* prevaux = dynamic_cast<Cylinder*>(this);
	if (!aux) {
		return prevaux;
	}

	while (aux->getParent() != nullptr) {
		prevaux = aux;
		aux = aux->getParent();
	}

	if (prevaux) {
		return prevaux;
	}
	return aux;
}

const Cylinder* Item::getTopParent() const {
	const Cylinder* aux = getParent();
	const Cylinder* prevaux = dynamic_cast<const Cylinder*>(this);
	if (!aux) {
		return prevaux;
	}

	while (aux->getParent() != nullptr) {
		prevaux = aux;
		aux = aux->getParent();
	}

	if (prevaux) {
		return prevaux;
	}
	return aux;
}

Tile* Item::getTile() {
	Cylinder* cylinder = getTopParent();
	// get root cylinder
	if (cylinder && cylinder->getParent()) {
		cylinder = cylinder->getParent();
	}
	return dynamic_cast<Tile*>(cylinder);
}

const Tile* Item::getTile() const {
	const Cylinder* cylinder = getTopParent();
	// get root cylinder
	if (cylinder && cylinder->getParent()) {
		cylinder = cylinder->getParent();
	}
	return dynamic_cast<const Tile*>(cylinder);
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

Player* Item::getHoldingPlayer() const {
	Cylinder* p = getParent();
	while (p) {
		if (p->getCreature()) {
			return p->getCreature()->getPlayer();
		}

		p = p->getParent();
	}
	return nullptr;
}

bool Item::isItemStorable() const {
	auto isContainerAndHasSomethingInside = (getContainer() != NULL) && (getContainer()->getItemList().size() > 0);
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
			}
			break;
		}

		case ATTR_IMBUEMENT_TYPE: {
			std::string imbuementType;
			if (!propStream.readString(imbuementType)) {
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::IMBUEMENT_TYPE, imbuementType);
			break;
		}

		case ATTR_TIER: {
			uint8_t tier;
			if (!propStream.read<uint8_t>(tier)) {
				SPDLOG_ERROR("[{}] failed to read tier", __FUNCTION__);
				return ATTR_READ_ERROR;
			}

			setAttribute(ItemAttribute_t::TIER, tier);
			break;
		}

		case ATTR_CUSTOM: {
			uint64_t size;
			if (!propStream.read<uint64_t>(size)) {
				SPDLOG_ERROR("[{}] failed to read size", __FUNCTION__);
				return ATTR_READ_ERROR;
			}

			for (uint64_t i = 0; i < size; i++) {
				// Unserialize custom attribute key type
				std::string key;
				if (!propStream.readString(key)) {
					SPDLOG_ERROR("[{}] failed to read custom type", __FUNCTION__);
					return ATTR_READ_ERROR;
				};

				CustomAttribute customAttribute;
				if (!customAttribute.unserialize(propStream, __FUNCTION__)) {
					SPDLOG_ERROR("[{}] failed to read custom value", __FUNCTION__);
					return ATTR_READ_ERROR;
				}

				addCustomAttribute(key, customAttribute);
			}
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
		Attr_ReadValue ret = readAttr(static_cast<AttrTypes_t>(attr_type), propStream);
		if (ret == ATTR_READ_ERROR) {
			return false;
		} else if (ret == ATTR_READ_END) {
			return true;
		}
	}
	return true;
}

bool Item::unserializeItemNode(OTB::Loader &, const OTB::Node &, PropStream &propStream) {
	return unserializeAttr(propStream);
}

void Item::serializeAttr(PropWriteStream &propWriteStream) const {
	const ItemType &it = items[id];
	if (it.stackable || it.isFluidContainer() || it.isSplash()) {
		propWriteStream.write<uint8_t>(ATTR_COUNT);
		propWriteStream.write<uint8_t>(getSubType());
	}

	if (auto charges = getAttribute<uint16_t>(ItemAttribute_t::CHARGES)) {
		propWriteStream.write<uint8_t>(ATTR_CHARGES);
		propWriteStream.write<uint16_t>(charges);
	}

	if (it.moveable) {
		if (auto actionId = getAttribute<uint16_t>(ItemAttribute_t::ACTIONID)) {
			propWriteStream.write<uint8_t>(ATTR_ACTION_ID);
			propWriteStream.write<uint16_t>(actionId);
		}
	}

	if (const std::string &text = getString(ItemAttribute_t::TEXT);
		!text.empty()) {
		propWriteStream.write<uint8_t>(ATTR_TEXT);
		propWriteStream.writeString(text);
	}

	if (const uint64_t writtenDate = getAttribute<uint64_t>(ItemAttribute_t::DATE)) {
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

	if (auto decayState = getAttribute<ItemDecayState_t>(ItemAttribute_t::DECAYSTATE);
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

	if (hasAttribute(ItemAttribute_t::IMBUEMENT_TYPE)) {
		propWriteStream.write<uint8_t>(ATTR_IMBUEMENT_TYPE);
		propWriteStream.writeString(getString(ItemAttribute_t::IMBUEMENT_TYPE));
	}

	if (hasAttribute(ItemAttribute_t::TIER)) {
		propWriteStream.write<uint8_t>(ATTR_TIER);
		propWriteStream.write<uint8_t>(getTier());
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
}

bool Item::hasProperty(ItemProperty prop) const {
	const ItemType &it = items[id];
	switch (prop) {
		case CONST_PROP_BLOCKSOLID:
			return it.blockSolid;
		case CONST_PROP_MOVEABLE:
			return it.moveable && !hasAttribute(ItemAttribute_t::UNIQUEID);
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
			return it.blockSolid && (!it.moveable || hasAttribute(ItemAttribute_t::UNIQUEID));
		case CONST_PROP_IMMOVABLEBLOCKPATH:
			return it.blockPathFind && (!it.moveable || hasAttribute(ItemAttribute_t::UNIQUEID));
		case CONST_PROP_IMMOVABLENOFIELDBLOCKPATH:
			return !it.isMagicField() && it.blockPathFind && (!it.moveable || hasAttribute(ItemAttribute_t::UNIQUEID));
		case CONST_PROP_NOFIELDBLOCKPATH:
			return !it.isMagicField() && it.blockPathFind;
		case CONST_PROP_SUPPORTHANGABLE:
			return it.isHorizontal || it.isVertical;
		default:
			return false;
	}
}

uint32_t Item::getWeight() const {
	uint32_t baseWeight = getBaseWeight();
	if (isStackable()) {
		return baseWeight * std::max<uint32_t>(1, getItemCount());
	}
	return baseWeight;
}

std::vector<std::pair<std::string, std::string>>
Item::getDescriptions(const ItemType &it, const Item* item /*= nullptr*/) {
	std::ostringstream ss;
	std::vector<std::pair<std::string, std::string>> descriptions;
	descriptions.reserve(30);
	if (item) {
		const std::string &specialDescription = item->getAttribute<std::string>(ItemAttribute_t::DESCRIPTION);
		if (!specialDescription.empty()) {
			descriptions.emplace_back("Description", specialDescription);
		} else if (!it.description.empty()) {
			descriptions.emplace_back("Description", it.description);
		}

		if (it.showCharges) {
			auto charges = item->getAttribute<int32_t>(ItemAttribute_t::CHARGES);
			if (charges != 0) {
				descriptions.emplace_back("Charges", std::to_string(charges));
			}
		}

		int32_t attack = item->getAttack();
		if (attack != 0) {
			if (it.abilities && it.abilities->elementType != COMBAT_NONE && it.abilities->elementDamage != 0) {
				ss.str("");
				ss << attack << " physical +" << it.abilities->elementDamage << ' ' << getCombatName(it.abilities->elementType);
				descriptions.emplace_back("Attack", ss.str());
			} else {
				descriptions.emplace_back("Attack", std::to_string(attack));
			}
		}

		int32_t hitChance = item->getHitChance();
		if (hitChance != 0) {
			descriptions.emplace_back("HitChance", std::to_string(hitChance));
		}

		int32_t defense = item->getDefense(), extraDefense = item->getExtraDefense();
		if (defense != 0 || extraDefense != 0) {
			if (extraDefense != 0) {
				ss.str("");
				ss << defense << ' ' << std::showpos << extraDefense << std::noshowpos;
				descriptions.emplace_back("Defense", ss.str());
			} else {
				descriptions.emplace_back("Defense", std::to_string(defense));
			}
		}

		int32_t armor = item->getArmor();
		if (armor != 0) {
			descriptions.emplace_back("Armor", std::to_string(armor));
		}

		if (it.abilities) {
			for (uint8_t i = SKILL_FIRST; i <= SKILL_LAST; i++) {
				if (!it.abilities->skills[i]) {
					continue;
				}

				ss.str("");
				ss << std::showpos << it.abilities->skills[i] << std::noshowpos;
				descriptions.emplace_back(getSkillName(i), ss.str());
			}

			for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; i++) {
				if (!it.abilities->skills[i]) {
					continue;
				}

				ss.str("");
				if (i != SKILL_CRITICAL_HIT_CHANCE) {
					ss << std::showpos;
				}
				ss << it.abilities->skills[i] << '%';
				if (i != SKILL_CRITICAL_HIT_CHANCE) {
					ss << std::noshowpos;
				}
				descriptions.emplace_back(getSkillName(i), ss.str());
			}

			if (it.abilities->stats[STAT_MAGICPOINTS]) {
				ss.str("");
				ss << std::showpos << it.abilities->stats[STAT_MAGICPOINTS] << std::noshowpos;
				descriptions.emplace_back("Magic Level", ss.str());
			}

			if (it.abilities->speed) {
				ss.str("");
				ss << std::showpos << (it.abilities->speed) << std::noshowpos;
				descriptions.emplace_back("Speed", ss.str());
			}

			if (hasBitSet(CONDITION_DRUNK, it.abilities->conditionSuppressions)) {
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
				ss << fmt::format("{} {:+}%", getCombatName(indexToCombatType(i)), it.abilities->absorbPercent[i]);
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

		if (item->getContainer()) {
			descriptions.emplace_back("Capacity", std::to_string(item->getContainer()->capacity()));
		}

		if (it.isRune()) {
			descriptions.emplace_back("Rune Spell Name", it.runeSpellName);
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
			descriptions.emplace_back("Weight", ss.str());
		}

		if (it.showDuration) {
			ss.str("");
			if (item->hasAttribute(ItemAttribute_t::DURATION)) {
				uint32_t duration = item->getDuration() / 1000;
				ss << "Will expire in ";
				if (duration >= 86400) {
					uint16_t days = duration / 86400;
					uint16_t hours = (duration % 86400) / 3600;
					ss << days << " day" << (days != 1 ? "s" : "");
					if (hours > 0) {
						ss << " and " << hours << " hour" << (hours != 1 ? "s" : "");
					}
				} else if (duration >= 3600) {
					uint16_t hours = duration / 3600;
					uint16_t minutes = (duration % 3600) / 60;
					ss << hours << " hour" << (hours != 1 ? "s" : "");
					if (minutes > 0) {
						ss << " and " << minutes << " minute" << (minutes != 1 ? "s" : "");
					}
				} else if (duration >= 60) {
					uint16_t minutes = duration / 60;
					ss << minutes << " minute" << (minutes != 1 ? "s" : "");
					uint16_t seconds = duration % 60;
					if (seconds > 0) {
						ss << " and " << seconds << " second" << (seconds != 1 ? "s" : "");
					}
				} else {
					ss << duration << " second" << (duration != 1 ? "s" : "");
				}
			} else {
				ss << "Is brand-new";
			}
			descriptions.emplace_back("Expiration", ss.str());
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
			descriptions.emplace_back("Body Position", "Container");
		} else if (it.slotPosition & SLOTP_HEAD) {
			descriptions.emplace_back("Body Position", "Head");
		} else if (it.slotPosition & SLOTP_ARMOR) {
			descriptions.emplace_back("Body Position", "Body");
		} else if (it.slotPosition & SLOTP_LEGS) {
			descriptions.emplace_back("Body Position", "Legs");
		} else if (it.slotPosition & SLOTP_FEET) {
			descriptions.emplace_back("Body Position", "Feet");
		} else if (it.slotPosition & SLOTP_NECKLACE) {
			descriptions.emplace_back("Body Position", "Neck");
		} else if (it.slotPosition & SLOTP_RING) {
			descriptions.emplace_back("Body Position", "Finger");
		} else if (it.slotPosition & SLOTP_AMMO) {
			descriptions.emplace_back("Body Position", "Extra Slot");
		} else if (it.slotPosition & SLOTP_TWO_HAND || it.slotPosition & SLOTP_LEFT || it.slotPosition & SLOTP_RIGHT) {
			descriptions.emplace_back("Body Position", "Hand");
		}
	} else {
		if (!it.description.empty()) {
			descriptions.emplace_back("Description", it.description);
		}

		if (it.showCharges) {
			int32_t charges = it.charges;
			if (charges != 0) {
				descriptions.emplace_back("Charges", std::to_string(charges));
			}
		}

		int32_t attack = it.attack;
		if (attack != 0) {
			if (it.abilities && it.abilities->elementType != COMBAT_NONE && it.abilities->elementDamage != 0) {
				ss.str("");
				ss << attack << " physical +" << it.abilities->elementDamage << ' ' << getCombatName(it.abilities->elementType);
				descriptions.emplace_back("Attack", ss.str());
			} else {
				descriptions.emplace_back("Attack", std::to_string(attack));
			}
		}

		int32_t hitChance = it.hitChance;
		if (hitChance != 0) {
			descriptions.emplace_back("HitChance", std::to_string(hitChance));
		}

		int32_t defense = it.defense, extraDefense = it.extraDefense;
		if (defense != 0 || extraDefense != 0) {
			if (extraDefense != 0) {
				ss.str("");
				ss << defense << ' ' << std::showpos << extraDefense << std::noshowpos;
				descriptions.emplace_back("Defense", ss.str());
			} else {
				descriptions.emplace_back("Defense", std::to_string(defense));
			}
		}

		int32_t armor = it.armor;
		if (armor != 0) {
			descriptions.emplace_back("Armor", std::to_string(armor));
		}

		if (it.abilities) {
			for (uint8_t i = SKILL_FIRST; i <= SKILL_LAST; i++) {
				if (!it.abilities->skills[i]) {
					continue;
				}

				ss.str("");
				ss << std::showpos << it.abilities->skills[i] << std::noshowpos;
				descriptions.emplace_back(getSkillName(i), ss.str());
			}

			for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; i++) {
				if (!it.abilities->skills[i]) {
					continue;
				}

				ss.str("");
				if (i != SKILL_CRITICAL_HIT_CHANCE) {
					ss << std::showpos;
				}
				ss << it.abilities->skills[i] << '%';
				if (i != SKILL_CRITICAL_HIT_CHANCE) {
					ss << std::noshowpos;
				}
				descriptions.emplace_back(getSkillName(i), ss.str());
			}

			if (it.abilities->stats[STAT_MAGICPOINTS]) {
				ss.str("");
				ss << std::showpos << it.abilities->stats[STAT_MAGICPOINTS] << std::noshowpos;
				descriptions.emplace_back("Magic Level", ss.str());
			}

			if (it.abilities->speed) {
				ss.str("");
				ss << std::showpos << (it.abilities->speed) << std::noshowpos;
				descriptions.emplace_back("Speed", ss.str());
			}

			if (hasBitSet(CONDITION_DRUNK, it.abilities->conditionSuppressions)) {
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
				ss << fmt::format("{} {:+}%", getCombatName(indexToCombatType(i)), it.abilities->absorbPercent[i]);
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
		}

		if (it.isKey()) {
			ss.str("");
			ss << fmt::format("{:04}", 0);
			descriptions.emplace_back("Key", ss.str());
		}

		if (it.isFluidContainer()) {
			descriptions.emplace_back("Contain", "Nothing");
		}

		if (it.isContainer()) {
			descriptions.emplace_back("Capacity", std::to_string(it.maxItems));
		}

		if (it.isRune()) {
			descriptions.emplace_back("Rune Spell Name", it.runeSpellName);
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

		if (it.showDuration) {
			descriptions.emplace_back("Expiration", "Is brand-new");
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
			descriptions.emplace_back("Body Position", "Container");
		} else if (it.slotPosition & SLOTP_HEAD) {
			descriptions.emplace_back("Body Position", "Head");
		} else if (it.slotPosition & SLOTP_ARMOR) {
			descriptions.emplace_back("Body Position", "Body");
		} else if (it.slotPosition & SLOTP_LEGS) {
			descriptions.emplace_back("Body Position", "Legs");
		} else if (it.slotPosition & SLOTP_FEET) {
			descriptions.emplace_back("Body Position", "Feet");
		} else if (it.slotPosition & SLOTP_NECKLACE) {
			descriptions.emplace_back("Body Position", "Neck");
		} else if (it.slotPosition & SLOTP_RING) {
			descriptions.emplace_back("Body Position", "Finger");
		} else if (it.slotPosition & SLOTP_AMMO) {
			descriptions.emplace_back("Body Position", "Extra Slot");
		} else if (it.slotPosition & SLOTP_TWO_HAND || it.slotPosition & SLOTP_LEFT || it.slotPosition & SLOTP_RIGHT) {
			descriptions.emplace_back("Body Position", "Hand");
		}

		if (it.upgradeClassification > 0) {
			descriptions.emplace_back("Classification", std::to_string(it.upgradeClassification));
		}
	}
	descriptions.shrink_to_fit();
	return descriptions;
}

std::string Item::parseImbuementDescription(const Item* item) {
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

			auto minutes = imbuementInfo.duration / 60;
			auto hours = minutes / 60;
			s << fmt::format("{} {} {:02}:{:02}h", baseImbuement->name, imbuementInfo.imbuement->getName(), hours, minutes % 60);
		}
		s << ").";
	}

	return s.str();
}

std::string Item::parseClassificationDescription(const Item* item) {
	std::ostringstream string;
	if (item && item->getClassification() >= 1) {
		string << std::endl
			   << "Classification: " << std::to_string(item->getClassification()) << " Tier: " << std::to_string(item->getTier());
		if (item->getTier() != 0) {
			if (Item::items[item->getID()].weaponType != WEAPON_NONE) {
				string << fmt::format(" ({}% Onslaught).", item->getFatalChance());
			} else if (g_game().getObjectCategory(item) == OBJECTCATEGORY_HELMETS) {
				string << fmt::format(" ({}% Momentum).", item->getMomentumChance());
			} else if (g_game().getObjectCategory(item) == OBJECTCATEGORY_ARMORS) {
				string << fmt::format(" ({:.2f}% Ruse).", item->getDodgeChance());
			}
		}
	}
	return string.str();
}

std::string Item::parseShowAttributesDescription(const Item* item, const uint16_t itemId) {
	std::ostringstream itemDescription;
	const ItemType &itemType = Item::items[itemId];
	if (itemType.armor != 0 || (item && item->getArmor() != 0) || itemType.showAttributes) {
		bool begin = true;

		int32_t armor = (item ? item->getArmor() : itemType.armor);
		if (armor != 0) {
			itemDescription << " (Arm:" << armor;
			begin = false;
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
				if (!itemType.abilities->skills[i]) {
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
				itemDescription << itemType.abilities->skills[i];
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
				if (begin) {
					begin = false;
					itemDescription << " (";
				} else {
					itemDescription << ", ";
				}

				itemDescription << fmt::format("speed {:+}", itemType.abilities->speed);
			}
		}

		if (!begin) {
			itemDescription << ')';
		}
	}

	return itemDescription.str();
}

std::string Item::getDescription(const ItemType &it, int32_t lookDistance, const Item* item /*= nullptr*/, int32_t subType /*= -1*/, bool addArticle /*= true*/) {
	const std::string* text = nullptr;

	std::ostringstream s;
	s << getNameDescription(it, item, subType, addArticle);

	if (item) {
		subType = item->getSubType();
	}

	if (it.isRune()) {
		if (it.runeLevel > 0 || it.runeMagLevel > 0) {
			if (const RuneSpell* rune = g_spells().getRuneSpell(it.id)) {
				int32_t tmpSubType = subType;
				if (item) {
					tmpSubType = item->getSubType();
				}
				s << " (\"" << it.runeSpellName << "\"). " << (it.stackable && tmpSubType > 1 ? "They" : "It") << " can only be used by ";

				const VocSpellMap &vocMap = rune->getVocMap();
				std::vector<Vocation*> showVocMap;

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
					if (!it.abilities->skills[i]) {
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
					s << it.abilities->skills[i];
					if (i != SKILL_CRITICAL_HIT_CHANCE) {
						s << std::noshowpos;
					}
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
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << fmt::format("speed {:+}", it.abilities->speed);
				}
			}

			if (!begin) {
				s << ')';
			}
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

			if (attack != 0) {
				begin = false;
				s << " (Atk:" << attack;

				if (it.abilities && it.abilities->elementType != COMBAT_NONE && it.abilities->elementDamage != 0) {
					s << " physical + " << it.abilities->elementDamage << ' ' << getCombatName(it.abilities->elementType);
				}
			}

			if (defense != 0 || extraDefense != 0) {
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

				for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; i++) {
					if (!it.abilities->skills[i]) {
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
					s << it.abilities->skills[i];
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
					if (begin) {
						begin = false;
						s << " (";
					} else {
						s << ", ";
					}

					s << fmt::format("speed {:+}", it.abilities->speed);
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

		if (volume != 0) {
			s << " (Vol:" << volume << ')';
		}
	} else {
		bool found = true;

		if (it.abilities && it.slotPosition & SLOTP_RING) {
			if (it.abilities->speed > 0) {
				s << fmt::format(" (speed {:+})", it.abilities->speed);
			} else if (hasBitSet(CONDITION_DRUNK, it.abilities->conditionSuppressions)) {
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
						auto string = item->getAttribute<std::string>(ItemAttribute_t::TEXT);
						text = &string;
						if (!text->empty()) {
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
							s << *text;
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
		if (item && item->hasAttribute(ItemAttribute_t::DURATION)) {
			uint32_t duration = item->getDuration() / 1000;
			s << " that will expire in ";

			if (duration >= 86400) {
				uint16_t days = duration / 86400;
				uint16_t hours = (duration % 86400) / 3600;
				s << days << " day" << (days != 1 ? "s" : "");

				if (hours > 0) {
					s << " and " << hours << " hour" << (hours != 1 ? "s" : "");
				}
			} else if (duration >= 3600) {
				uint16_t hours = duration / 3600;
				uint16_t minutes = (duration % 3600) / 60;
				s << hours << " hour" << (hours != 1 ? "s" : "");

				if (minutes > 0) {
					s << " and " << minutes << " minute" << (minutes != 1 ? "s" : "");
				}
			} else if (duration >= 60) {
				uint16_t minutes = duration / 60;
				s << minutes << " minute" << (minutes != 1 ? "s" : "");
				uint16_t seconds = duration % 60;

				if (seconds > 0) {
					s << " and " << seconds << " second" << (seconds != 1 ? "s" : "");
				}
			} else {
				s << duration << " second" << (duration != 1 ? "s" : "");
			}
		} else {
			s << " that is brand-new";
		}
	}

	if (!it.allowDistRead || (it.id >= 7369 && it.id <= 7371)) {
		s << '.';
	} else {
		if (!text && item) {
			auto string = item->getAttribute<std::string>(ItemAttribute_t::TEXT);
			text = &string;
		}

		if (!text || text->empty()) {
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
		if (!text && item) {
			auto string = item->getAttribute<std::string>(ItemAttribute_t::TEXT);
			text = &string;
		}

		if (text && !text->empty()) {
			s << std::endl
			  << *text;
		}
	}
	return s.str();
}

std::string Item::getDescription(int32_t lookDistance) const {
	const ItemType &it = items[id];
	return getDescription(it, lookDistance, this);
}

std::string Item::getNameDescription(const ItemType &it, const Item* item /*= nullptr*/, int32_t subType /*= -1*/, bool addArticle /*= true*/) {
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

std::string Item::getNameDescription() const {
	const ItemType &it = items[id];
	return getNameDescription(it, this);
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
	uint32_t weight = getWeight();
	if (weight == 0) {
		return std::string();
	}
	return getWeightDescription(weight);
}

void Item::addUniqueId(uint16_t uniqueId) {
	if (hasAttribute(ItemAttribute_t::UNIQUEID)) {
		return;
	}

	if (g_game().addUniqueItem(uniqueId, this)) {
		setAttribute(ItemAttribute_t::UNIQUEID, uniqueId);
	}
}

bool Item::canDecay() const {
	if (isRemoved()) {
		return false;
	}

	const ItemType &it = Item::items[id];
	if (it.decayTo < 0 || it.decayTime == 0) {
		return false;
	}

	if (hasAttribute(ItemAttribute_t::UNIQUEID)) {
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
	if (getID() == ITEM_FORGE_SLIVER)
		return getItemCount();
	else
		return 0;
}

uint32_t Item::getForgeCores() const {
	if (getID() == ITEM_FORGE_CORE)
		return getItemCount();
	else
		return 0;
}

LightInfo Item::getLightInfo() const {
	const ItemType &it = items[id];
	return { it.lightLevel, it.lightColor };
}

void Item::startDecaying() {
	g_decay().startDecay(this);
}

void Item::stopDecaying() {
	g_decay().stopDecay(this);
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

		if (attribute.getAttributeType() == ItemAttribute_t::IMBUEMENT_TYPE && !hasImbuements()) {
			return false;
		}

		if (attribute.getAttributeType() == ItemAttribute_t::TIER && static_cast<uint8_t>(attribute.getInteger()) != getTier()) {
			return false;
		}
	}

	return true;
}

bool Item::isInsideDepot(bool includeInbox /* = false*/) const {
	if (const Container* thisContainer = getContainer(); thisContainer && (thisContainer->getDepotLocker() || thisContainer->isDepotChest() || (includeInbox && thisContainer->isInbox()))) {
		return true;
	}

	const Cylinder* cylinder = getParent();
	if (!cylinder) {
		return false;
	}

	const Container* container = cylinder->getContainer();
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
