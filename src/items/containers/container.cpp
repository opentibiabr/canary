/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/containers/container.h"
#include "items/decay/decay.h"
#include "io/iomap.h"
#include "game/game.h"

Container::Container(uint16_t type) :
	Container(type, items[type].maxItems) {
	if (getID() == ITEM_GOLD_POUCH) {
		pagination = true;
	}
}

Container::Container(uint16_t initType, uint16_t initSize, bool initUnlocked /*= true*/, bool initPagination /*= false*/) :
	Item(initType),
	maxSize(initSize),
	unlocked(initUnlocked),
	pagination(initPagination) { }

Container::Container(Tile* tile) :
	Container(ITEM_BROWSEFIELD, 30, false, true) {
	TileItemVector* itemVector = tile->getItemList();
	if (itemVector) {
		for (Item* item : *itemVector) {
			if (((item->getContainer() || item->hasProperty(CONST_PROP_MOVEABLE)) || (item->isWrapable() && !item->hasProperty(CONST_PROP_MOVEABLE) && !item->hasProperty(CONST_PROP_BLOCKPATH))) && !item->hasAttribute(ItemAttribute_t::UNIQUEID)) {
				itemlist.push_front(item);
				item->setParent(this);
			}
		}
	}

	setParent(tile);
}

Container::~Container() {
	if (getID() == ITEM_BROWSEFIELD) {
		g_game().browseFields.erase(getTile());

		for (Item* item : itemlist) {
			item->setParent(parent);
		}
	} else {
		for (Item* item : itemlist) {
			item->setParent(nullptr);
			item->decrementReferenceCounter();
		}
	}
}

Item* Container::clone() const {
	Container* clone = static_cast<Container*>(Item::clone());
	for (Item* item : itemlist) {
		clone->addItem(item->clone());
	}
	clone->totalWeight = totalWeight;
	return clone;
}

Container* Container::getParentContainer() {
	Thing* thing = getParent();
	if (!thing) {
		return nullptr;
	}
	return thing->getContainer();
}

Container* Container::getTopParentContainer() const {
	Thing* thing = getParent();
	Thing* prevThing = const_cast<Container*>(this);
	if (!thing) {
		return prevThing->getContainer();
	}

	while (thing->getParent() != nullptr && thing->getParent()->getContainer()) {
		prevThing = thing;
		thing = thing->getParent();
	}

	if (prevThing) {
		return prevThing->getContainer();
	}

	return thing->getContainer();
}

bool Container::hasParent() const {
	return getID() != ITEM_BROWSEFIELD && dynamic_cast<const Player*>(getParent()) == nullptr;
}

void Container::addItem(Item* item) {
	itemlist.push_back(item);
	item->setParent(this);
}

StashContainerList Container::getStowableItems() const {
	StashContainerList toReturnList;
	for (auto item : itemlist) {
		if (item->getContainer() != NULL) {
			auto subContainer = item->getContainer()->getStowableItems();
			for (auto subContItem : subContainer) {
				Item* containerItem = subContItem.first;
				toReturnList.push_back(std::pair<Item*, uint32_t>(containerItem, static_cast<uint32_t>(containerItem->getItemCount())));
			}
		} else if (item->isItemStorable()) {
			toReturnList.push_back(std::pair<Item*, uint32_t>(item, static_cast<uint32_t>(item->getItemCount())));
		}
	}

	return toReturnList;
}

Attr_ReadValue Container::readAttr(AttrTypes_t attr, PropStream &propStream) {
	if (attr == ATTR_CONTAINER_ITEMS) {
		if (!propStream.read<uint32_t>(serializationCount)) {
			return ATTR_READ_ERROR;
		}
		return ATTR_READ_END;
	}
	return Item::readAttr(attr, propStream);
}

bool Container::unserializeItemNode(OTB::Loader &loader, const OTB::Node &node, PropStream &propStream, Position &itemPosition) {
	bool ret = Item::unserializeItemNode(loader, node, propStream, itemPosition);
	if (!ret) {
		return false;
	}

	for (auto &itemNode : node.children) {
		// load container items
		if (itemNode.type != OTBM_ITEM) {
			// unknown type
			return false;
		}

		PropStream itemPropStream;
		if (!loader.getProps(itemNode, itemPropStream)) {
			return false;
		}

		uint16_t id;
		if (!itemPropStream.read<uint16_t>(id)) {
			return false;
		}

		Item* item = Item::CreateItem(id, itemPosition);
		if (!item) {
			continue;
		}

		if (!item->unserializeItemNode(loader, itemNode, itemPropStream, itemPosition)) {
			continue;
		}

		addItem(item);
		updateItemWeight(item->getWeight());
	}
	return true;
}

bool Container::countsToLootAnalyzerBalance() {
	if (isCorpse()) {
		return true;
	}

	if (getID() == ITEM_REWARD_CONTAINER) {
		return true;
	}

	return false;
}

void Container::updateItemWeight(int32_t diff) {
	totalWeight += diff;
	Container* parentContainer = this; // credits: SaiyansKing
	while ((parentContainer = parentContainer->getParentContainer()) != nullptr) {
		parentContainer->totalWeight += diff;
	}
}

uint32_t Container::getWeight() const {
	return Item::getWeight() + totalWeight;
}

std::string Container::getContentDescription() const {
	std::ostringstream os;
	return getContentDescription(os).str();
}

std::ostringstream &Container::getContentDescription(std::ostringstream &os) const {
	bool firstitem = true;
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		Item* item = *it;

		Container* container = item->getContainer();
		if (container && !container->empty()) {
			continue;
		}

		if (firstitem) {
			firstitem = false;
		} else {
			os << ", ";
		}

		os << "{" << item->getID() << "|" << item->getNameDescription() << "}";
	}

	if (firstitem) {
		os << "nothing";
	}
	return os;
}

Item* Container::getItemByIndex(size_t index) const {
	if (index >= size()) {
		return nullptr;
	}
	return itemlist[index];
}

uint32_t Container::getItemHoldingCount() const {
	uint32_t counter = 0;
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		++counter;
	}
	return counter;
}

uint32_t Container::getContainerHoldingCount() const {
	uint32_t counter = 0;
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		if ((*it)->getContainer()) {
			++counter;
		}
	}
	return counter;
}

bool Container::isHoldingItem(const Item* item) const {
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		if (*it == item) {
			return true;
		}
	}
	return false;
}

bool Container::isHoldingItemWithId(const uint16_t id) const {
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		const Item* item = *it;
		if (item->getID() == id) {
			return true;
		}
	}
	return false;
}

bool Container::isInsideContainerWithId(const uint16_t id) const {
	auto nextParent = parent;
	while (nextParent != nullptr && nextParent->getContainer()) {
		if (nextParent->getContainer()->getID() == id) {
			return true;
		}
		nextParent = nextParent->getRealParent();
	}
	return false;
}

bool Container::isAnyKindOfRewardChest() const {
	return getID() == ITEM_REWARD_CHEST || getID() == ITEM_REWARD_CONTAINER && parent && parent->getContainer() && parent->getContainer()->getID() == ITEM_REWARD_CHEST || isBrowseFieldAndHoldsRewardChest();
}

bool Container::isAnyKindOfRewardContainer() const {
	return getID() == ITEM_REWARD_CHEST || getID() == ITEM_REWARD_CONTAINER || isHoldingItemWithId(ITEM_REWARD_CONTAINER) || isInsideContainerWithId(ITEM_REWARD_CONTAINER);
}

bool Container::isBrowseFieldAndHoldsRewardChest() const {
	return getID() == ITEM_BROWSEFIELD && isHoldingItemWithId(ITEM_REWARD_CHEST);
}

void Container::onAddContainerItem(Item* item) {
	SpectatorHashSet spectators;
	g_game().map.getSpectators(spectators, getPosition(), false, true, 2, 2, 2, 2);

	// send to client
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->sendAddContainerItem(this, item);
	}

	// event methods
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->onAddContainerItem(item);
	}
}

void Container::onUpdateContainerItem(uint32_t index, Item* oldItem, Item* newItem) {
	SpectatorHashSet spectators;
	g_game().map.getSpectators(spectators, getPosition(), false, true, 2, 2, 2, 2);

	// send to client
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->sendUpdateContainerItem(this, index, newItem);
	}

	// event methods
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->onUpdateContainerItem(this, oldItem, newItem);
	}
}

void Container::onRemoveContainerItem(uint32_t index, Item* item) {
	SpectatorHashSet spectators;
	g_game().map.getSpectators(spectators, getPosition(), false, true, 2, 2, 2, 2);

	// send change to client
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->sendRemoveContainerItem(this, index);
	}

	// event methods
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->onRemoveContainerItem(this, item);
	}
}

ReturnValue Container::queryAdd(int32_t addIndex, const Thing &addThing, uint32_t addCount, uint32_t flags, Creature* actor /* = nullptr*/) const {
	bool childIsOwner = hasBitSet(FLAG_CHILDISOWNER, flags);
	if (childIsOwner) {
		// a child container is querying, since we are the top container (not carried by a player)
		// just return with no error.
		return RETURNVALUE_NOERROR;
	}

	if (!unlocked) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	const Item* item = addThing.getItem();
	if (item == nullptr) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (!item->isPickupable()) {
		return RETURNVALUE_CANNOTPICKUP;
	}

	if (item == this) {
		return RETURNVALUE_THISISIMPOSSIBLE;
	}

	const Cylinder* cylinder = getParent();
	if (!hasBitSet(FLAG_NOLIMIT, flags)) {
		while (cylinder) {
			if (cylinder == &addThing) {
				return RETURNVALUE_THISISIMPOSSIBLE;
			}

			if (dynamic_cast<const Inbox*>(cylinder)) {
				return RETURNVALUE_CONTAINERNOTENOUGHROOM;
			}

			cylinder = cylinder->getParent();
		}

		if (addIndex == INDEX_WHEREEVER && size() >= capacity() && !hasPagination()) {
			return RETURNVALUE_CONTAINERNOTENOUGHROOM;
		}
	} else {
		while (cylinder) {
			if (cylinder == &addThing) {
				return RETURNVALUE_THISISIMPOSSIBLE;
			}

			cylinder = cylinder->getParent();
		}
	}

	if (const Container* topParentContainer = getTopParentContainer()) {
		uint32_t maxItem = static_cast<uint32_t>(g_configManager().getNumber(MAX_ITEM));
		if (const Container* addContainer = item->getContainer()) {
			uint32_t addContainerCount = addContainer->getContainerHoldingCount() + 1;
			uint32_t maxContainer = static_cast<uint32_t>(g_configManager().getNumber(MAX_CONTAINER));
			if (addContainerCount + topParentContainer->getContainerHoldingCount() > maxContainer) {
				return RETURNVALUE_NOTPOSSIBLE;
			}

			uint32_t addItemCount = addContainer->getItemHoldingCount() + 1;
			if (addItemCount + topParentContainer->getItemHoldingCount() > maxItem) {
				return RETURNVALUE_NOTPOSSIBLE;
			}
		}

		if (topParentContainer->getItemHoldingCount() + 1 > maxItem) {
			return RETURNVALUE_NOTPOSSIBLE;
		}
	}

	if (isQuiver() && item->getWeaponType() != WEAPON_AMMO) {
		return RETURNVALUE_ONLYAMMOINQUIVER;
	}

	const Cylinder* topParent = getTopParent();
	if (topParent != this) {
		return topParent->queryAdd(INDEX_WHEREEVER, *item, addCount, flags | FLAG_CHILDISOWNER, actor);
	} else {
		return RETURNVALUE_NOERROR;
	}
}

ReturnValue Container::queryMaxCount(int32_t index, const Thing &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) const {
	const Item* item = thing.getItem();
	if (item == nullptr) {
		maxQueryCount = 0;
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (hasBitSet(FLAG_NOLIMIT, flags) || hasPagination()) {
		maxQueryCount = std::max<uint32_t>(1, count);
		return RETURNVALUE_NOERROR;
	}

	int32_t freeSlots = std::max<int32_t>(capacity() - size(), 0);

	if (item->isStackable()) {
		uint32_t n = 0;

		if (index == INDEX_WHEREEVER) {
			// Iterate through every item and check how much free stackable slots there is.
			uint32_t slotIndex = 0;
			for (Item* containerItem : itemlist) {
				if (containerItem != item && containerItem->equals(item) && containerItem->getItemCount() < 100) {
					uint32_t remainder = (100 - containerItem->getItemCount());
					if (queryAdd(slotIndex++, *item, remainder, flags) == RETURNVALUE_NOERROR) {
						n += remainder;
					}
				}
			}
		} else {
			const Item* destItem = getItemByIndex(index);
			if (item->equals(destItem) && destItem->getItemCount() < 100) {
				n = 100 - destItem->getItemCount();
			}
		}

		// maxQueryCount is the limit of items I can add
		maxQueryCount = freeSlots * 100 + n;
		if (maxQueryCount < count) {
			return RETURNVALUE_CONTAINERNOTENOUGHROOM;
		}
	} else {
		maxQueryCount = freeSlots;
		if (maxQueryCount == 0) {
			return RETURNVALUE_CONTAINERNOTENOUGHROOM;
		}
	}
	return RETURNVALUE_NOERROR;
}

ReturnValue Container::queryRemove(const Thing &thing, uint32_t count, uint32_t flags, Creature* actor /*= nullptr */) const {
	int32_t index = getThingIndex(&thing);
	if (index == -1) {
		SPDLOG_DEBUG("{} - Failed to get thing index", __FUNCTION__);
		return RETURNVALUE_NOTPOSSIBLE;
	}

	const Item* item = thing.getItem();
	if (item == nullptr) {
		SPDLOG_DEBUG("{} - Item is nullptr", __FUNCTION__);
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (count == 0 || (item->isStackable() && count > item->getItemCount())) {
		SPDLOG_DEBUG("{} - Failed to get item count", __FUNCTION__);
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (!item->isMoveable() && !hasBitSet(FLAG_IGNORENOTMOVEABLE, flags)) {
		SPDLOG_DEBUG("{} - Item is not moveable", __FUNCTION__);
		return RETURNVALUE_NOTMOVEABLE;
	}
	const HouseTile* houseTile = dynamic_cast<const HouseTile*>(getTopParent());
	if (houseTile) {
		return houseTile->queryRemove(thing, count, flags, actor);
	}
	return RETURNVALUE_NOERROR;
}

Cylinder* Container::queryDestination(int32_t &index, const Thing &thing, Item** destItem, uint32_t &flags) {
	if (!unlocked) {
		*destItem = nullptr;
		return this;
	}

	if (index == 254 /*move up*/) {
		index = INDEX_WHEREEVER;
		*destItem = nullptr;

		Container* parentContainer = dynamic_cast<Container*>(getParent());
		if (parentContainer) {
			return parentContainer;
		}
		return this;
	}

	if (index == 255 /*add wherever*/) {
		index = INDEX_WHEREEVER;
		*destItem = nullptr;
	} else if (index >= static_cast<int32_t>(capacity()) && !hasPagination()) {
		/*
		if you have a container, maximize it to show all 20 slots
		then you open a bag that is inside the container you will have a bag with 8 slots
		and a "grey" area where the other 12 slots where from the container
		if you drop the item on that grey area
		the client calculates the slot position as if the bag has 20 slots
		*/
		index = INDEX_WHEREEVER;
		*destItem = nullptr;
	}

	const Item* item = thing.getItem();
	if (!item) {
		return this;
	}

	if (index != INDEX_WHEREEVER) {
		Item* itemFromIndex = getItemByIndex(index);
		if (itemFromIndex) {
			*destItem = itemFromIndex;
		}

		Cylinder* subCylinder = dynamic_cast<Cylinder*>(*destItem);
		if (subCylinder) {
			index = INDEX_WHEREEVER;
			*destItem = nullptr;
			return subCylinder;
		}
	}

	bool autoStack = !hasBitSet(FLAG_IGNOREAUTOSTACK, flags);
	if (autoStack && item->isStackable() && item->getParent() != this) {
		if (*destItem && (*destItem)->equals(item) && (*destItem)->getItemCount() < 100) {
			return this;
		}

		// try find a suitable item to stack with
		uint32_t n = 0;
		for (Item* listItem : itemlist) {
			if (listItem != item && listItem->equals(item) && listItem->getItemCount() < 100) {
				*destItem = listItem;
				index = n;
				return this;
			}
			++n;
		}
	}
	return this;
}

void Container::addThing(Thing* thing) {
	return addThing(0, thing);
}

void Container::addThing(int32_t index, Thing* thing) {
	if (index >= static_cast<int32_t>(capacity())) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	Item* item = thing->getItem();
	if (item == nullptr) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	item->setParent(this);
	itemlist.push_front(item);
	updateItemWeight(item->getWeight());

	// send change to client
	if (getParent() && (getParent() != VirtualCylinder::virtualCylinder)) {
		onAddContainerItem(item);
	}
}

void Container::addItemBack(Item* item) {
	addItem(item);
	updateItemWeight(item->getWeight());

	// send change to client
	if (getParent() && (getParent() != VirtualCylinder::virtualCylinder)) {
		onAddContainerItem(item);
	}
}

void Container::updateThing(Thing* thing, uint16_t itemId, uint32_t count) {
	int32_t index = getThingIndex(thing);
	if (index == -1) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	Item* item = thing->getItem();
	if (item == nullptr) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const int32_t oldWeight = item->getWeight();
	item->setID(itemId);
	item->setSubType(count);
	updateItemWeight(-oldWeight + item->getWeight());

	// send change to client
	if (getParent()) {
		onUpdateContainerItem(index, item, item);
	}
}

void Container::replaceThing(uint32_t index, Thing* thing) {
	Item* item = thing->getItem();
	if (!item) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	Item* replacedItem = getItemByIndex(index);
	if (!replacedItem) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	itemlist[index] = item;
	item->setParent(this);
	updateItemWeight(-static_cast<int32_t>(replacedItem->getWeight()) + item->getWeight());

	// send change to client
	if (getParent()) {
		onUpdateContainerItem(index, replacedItem, item);
	}

	replacedItem->setParent(nullptr);
}

void Container::removeThing(Thing* thing, uint32_t count) {
	Item* item = thing->getItem();
	if (item == nullptr) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	int32_t index = getThingIndex(thing);
	if (index == -1) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	if (item->isStackable() && count != item->getItemCount()) {
		uint8_t newCount = static_cast<uint8_t>(std::max<int32_t>(0, item->getItemCount() - count));
		const int32_t oldWeight = item->getWeight();
		item->setItemCount(newCount);
		updateItemWeight(-oldWeight + item->getWeight());

		// send change to client
		if (getParent()) {
			onUpdateContainerItem(index, item, item);
		}
	} else {
		updateItemWeight(-static_cast<int32_t>(item->getWeight()));

		// send change to client
		if (getParent()) {
			onRemoveContainerItem(index, item);
		}

		item->setParent(nullptr);
		itemlist.erase(itemlist.begin() + index);
	}
}

int32_t Container::getThingIndex(const Thing* thing) const {
	int32_t index = 0;
	for (Item* item : itemlist) {
		if (item == thing) {
			return index;
		}
		++index;
	}
	return -1;
}

size_t Container::getFirstIndex() const {
	return 0;
}

size_t Container::getLastIndex() const {
	return size();
}

uint32_t Container::getItemTypeCount(uint16_t itemId, int32_t subType /* = -1*/) const {
	uint32_t count = 0;
	for (Item* item : itemlist) {
		if (item->getID() == itemId) {
			count += countByType(item, subType);
		}
	}
	return count;
}

std::map<uint32_t, uint32_t> &Container::getAllItemTypeCount(std::map<uint32_t, uint32_t> &countMap) const {
	for (Item* item : itemlist) {
		countMap[item->getID()] += item->getItemCount();
	}
	return countMap;
}

Thing* Container::getThing(size_t index) const {
	return getItemByIndex(index);
}

ItemVector Container::getItems(bool recursive /*= false*/) const {
	ItemVector containerItems;
	if (recursive) {
		for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
			containerItems.push_back(*it);
		}
	} else {
		for (Item* item : itemlist) {
			containerItems.push_back(item);
		}
	}
	return containerItems;
}

void Container::postAddNotification(Thing* thing, const Cylinder* oldParent, int32_t index, CylinderLink_t) {
	Cylinder* topParent = getTopParent();
	if (topParent->getCreature()) {
		topParent->postAddNotification(thing, oldParent, index, LINK_TOPPARENT);
	} else if (topParent == this) {
		// let the tile class notify surrounding players
		if (topParent->getParent()) {
			topParent->getParent()->postAddNotification(thing, oldParent, index, LINK_NEAR);
		}
	} else {
		topParent->postAddNotification(thing, oldParent, index, LINK_PARENT);
	}
}

void Container::postRemoveNotification(Thing* thing, const Cylinder* newParent, int32_t index, CylinderLink_t) {
	Cylinder* topParent = getTopParent();
	if (topParent->getCreature()) {
		topParent->postRemoveNotification(thing, newParent, index, LINK_TOPPARENT);
	} else if (topParent == this) {
		// let the tile class notify surrounding players
		if (topParent->getParent()) {
			topParent->getParent()->postRemoveNotification(thing, newParent, index, LINK_NEAR);
		}
	} else {
		topParent->postRemoveNotification(thing, newParent, index, LINK_PARENT);
	}
}

void Container::internalAddThing(Thing* thing) {
	internalAddThing(0, thing);
}

void Container::internalAddThing(uint32_t, Thing* thing) {
	Item* item = thing->getItem();
	if (item == nullptr) {
		return;
	}

	item->setParent(this);
	itemlist.push_front(item);
	updateItemWeight(item->getWeight());
}

void Container::startDecaying() {
	g_decay().startDecay(this);
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		g_decay().startDecay(*it);
	}
}

void Container::stopDecaying() {
	g_decay().stopDecay(this);
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		g_decay().stopDecay(*it);
	}
}

uint16_t Container::getFreeSlots() const {
	uint16_t counter = std::max<uint16_t>(0, capacity() - size());

	for (Item* item : itemlist) {
		if (Container* container = item->getContainer()) {
			counter += std::max<uint16_t>(0, container->getFreeSlots());
		}
	}

	return counter;
}

ContainerIterator Container::iterator() const {
	ContainerIterator cit;
	if (!itemlist.empty()) {
		cit.over.push_back(this);
		cit.cur = itemlist.begin();
	}
	return cit;
}

Item* ContainerIterator::operator*() {
	return *cur;
}

void ContainerIterator::advance() {
	if (Item* i = *cur) {
		if (Container* c = i->getContainer()) {
			if (!c->empty()) {
				over.push_back(c);
			}
		}
	}

	++cur;

	if (cur == over.front()->itemlist.end()) {
		over.pop_front();
		if (!over.empty()) {
			cur = over.front()->itemlist.begin();
		}
	}
}
