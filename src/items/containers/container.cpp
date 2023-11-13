/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/containers/container.hpp"
#include "items/decay/decay.hpp"
#include "io/iomap.hpp"
#include "game/game.hpp"
#include "map/spectators.hpp"

Container::Container(uint16_t type) :
	Container(type, items[type].maxItems) {
	m_maxItems = static_cast<uint32_t>(g_configManager().getNumber(MAX_CONTAINER_ITEM));
	if (getID() == ITEM_GOLD_POUCH || isStoreInbox()) {
		pagination = true;
		m_maxItems = 2000;
		maxSize = 32;
	}
}

Container::Container(uint16_t initType, uint16_t initSize, bool initUnlocked /*= true*/, bool initPagination /*= false*/) :
	Item(initType),
	maxSize(initSize),
	unlocked(initUnlocked),
	pagination(initPagination) { }

std::shared_ptr<Container> Container::create(uint16_t type) {
	return std::make_shared<Container>(type);
}

std::shared_ptr<Container> Container::create(uint16_t type, uint16_t size, bool unlocked /*= true*/, bool pagination /*= false*/) {
	return std::make_shared<Container>(type, size, unlocked, pagination);
}

std::shared_ptr<Container> Container::create(std::shared_ptr<Tile> tile) {
	auto container = std::make_shared<Container>(ITEM_BROWSEFIELD, 30, false, true);
	TileItemVector* itemVector = tile->getItemList();
	if (itemVector) {
		for (auto &item : *itemVector) {
			if (((item->getContainer() || item->hasProperty(CONST_PROP_MOVEABLE)) || (item->isWrapable() && !item->hasProperty(CONST_PROP_MOVEABLE) && !item->hasProperty(CONST_PROP_BLOCKPATH))) && !item->hasAttribute(ItemAttribute_t::UNIQUEID)) {
				container->itemlist.push_front(item);
				item->setParent(container);
			}
		}
	}

	container->setParent(tile);
	return container;
}

Container::~Container() {
	if (getID() == ITEM_BROWSEFIELD) {
		for (std::shared_ptr<Item> item : itemlist) {
			item->setParent(getParent());
		}
	}
}

std::shared_ptr<Item> Container::clone() const {
	std::shared_ptr<Container> clone = std::static_pointer_cast<Container>(Item::clone());
	for (std::shared_ptr<Item> item : itemlist) {
		clone->addItem(item->clone());
	}
	clone->totalWeight = totalWeight;
	return clone;
}

std::shared_ptr<Container> Container::getParentContainer() {
	std::shared_ptr<Thing> thing = getParent();
	if (!thing) {
		return nullptr;
	}
	return thing->getContainer();
}

std::shared_ptr<Container> Container::getTopParentContainer() {
	std::shared_ptr<Thing> thing = getParent();
	std::shared_ptr<Thing> prevThing = getContainer();
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

std::shared_ptr<Container> Container::getRootContainer() {
	return getTopParentContainer();
}

bool Container::hasParent() {
	auto parent = getParent();
	if (!parent) {
		return false;
	}
	auto creature = parent->getCreature();
	bool isPlayer = creature && creature->getPlayer() != nullptr;
	return getID() != ITEM_BROWSEFIELD && !isPlayer;
}

void Container::addItem(std::shared_ptr<Item> item) {
	itemlist.push_back(item);
	item->setParent(getContainer());
}

StashContainerList Container::getStowableItems() const {
	StashContainerList toReturnList;
	for (auto item : itemlist) {
		if (item->getContainer() != NULL) {
			auto subContainer = item->getContainer()->getStowableItems();
			for (auto subContItem : subContainer) {
				std::shared_ptr<Item> containerItem = subContItem.first;
				toReturnList.push_back(std::pair<std::shared_ptr<Item>, uint32_t>(containerItem, static_cast<uint32_t>(containerItem->getItemCount())));
			}
		} else if (item->isItemStorable()) {
			toReturnList.push_back(std::pair<std::shared_ptr<Item>, uint32_t>(item, static_cast<uint32_t>(item->getItemCount())));
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

		std::shared_ptr<Item> item = Item::CreateItem(id, itemPosition);
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
	std::shared_ptr<Container> parentContainer = getContainer();
	while ((parentContainer = parentContainer->getParentContainer()) != nullptr) {
		parentContainer->totalWeight += diff;
	}
}

uint32_t Container::getWeight() const {
	return Item::getWeight() + totalWeight;
}

std::string Container::getContentDescription(bool oldProtocol) {
	std::ostringstream os;
	return getContentDescription(os, oldProtocol).str();
}

std::ostringstream &Container::getContentDescription(std::ostringstream &os, bool oldProtocol) {
	bool firstitem = true;
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		std::shared_ptr<Item> item = *it;

		std::shared_ptr<Container> container = item->getContainer();
		if (container && !container->empty()) {
			continue;
		}

		if (firstitem) {
			firstitem = false;
		} else {
			os << ", ";
		}

		if (oldProtocol) {
			os << item->getNameDescription();
		} else {
			os << "{" << item->getID() << "|" << item->getNameDescription() << "}";
		}
	}

	if (firstitem) {
		os << "nothing";
	}
	return os;
}

bool Container::isStoreInbox() const {
	return getID() == ITEM_STORE_INBOX;
}

bool Container::isStoreInboxFiltered() const {
	auto attribute = getAttribute<std::string>(ItemAttribute_t::STORE_INBOX_CATEGORY);
	if (isStoreInbox() && !attribute.empty() && attribute != "All") {
		return true;
	}

	return false;
}

std::deque<std::shared_ptr<Item>> Container::getStoreInboxFilteredItems() const {
	const auto enumName = getAttribute<std::string>(ItemAttribute_t::STORE_INBOX_CATEGORY);
	ItemDeque storeInboxFilteredList;
	if (isStoreInboxFiltered()) {
		for (std::shared_ptr<Item> item : getItemList()) {
			auto itemId = item->getID();
			auto attribute = item->getCustomAttribute("unWrapId");
			uint16_t unWrapId = attribute ? static_cast<uint16_t>(attribute->getInteger()) : 0;
			if (unWrapId != 0) {
				itemId = unWrapId;
			}
			const auto &itemType = Item::items.getItemType(itemId);
			auto primaryType = toPascalCase(itemType.m_primaryType);
			auto name = toPascalCase(enumName);
			g_logger().debug("Get filtered items, primaty type {}, enum name {}", primaryType, name);
			if (primaryType == name) {
				storeInboxFilteredList.push_back(item);
			}
		}
	}

	return storeInboxFilteredList;
}

std::vector<ContainerCategory_t> Container::getStoreInboxValidCategories() const {
	stdext::vector_set<ContainerCategory_t> validCategories;
	for (const auto &item : itemlist) {
		auto itemId = item->getID();
		auto attribute = item->getCustomAttribute("unWrapId");
		uint16_t unWrapId = attribute ? static_cast<uint16_t>(attribute->getInteger()) : 0;
		if (unWrapId != 0) {
			itemId = unWrapId;
		}
		const auto &itemType = Item::items.getItemType(itemId);
		auto convertedString = toPascalCase(itemType.m_primaryType);
		g_logger().debug("Store item '{}', primary type {}", itemId, convertedString);
		auto category = magic_enum::enum_cast<ContainerCategory_t>(convertedString);
		if (category.has_value()) {
			g_logger().debug("Adding valid category {}", static_cast<uint8_t>(category.value()));
			validCategories.insert(category.value());
		}
	}

	return validCategories.data();
}

std::shared_ptr<Item> Container::getFilteredItemByIndex(size_t index) const {
	const auto filteredItems = getStoreInboxFilteredItems();
	if (index >= filteredItems.size()) {
		return nullptr;
	}

	auto item = filteredItems[index];

	auto it = std::find(itemlist.begin(), itemlist.end(), item);
	if (it == itemlist.end()) {
		return nullptr;
	}

	return *it;
}

std::shared_ptr<Item> Container::getItemByIndex(size_t index) const {
	if (index >= size()) {
		return nullptr;
	}

	return itemlist[index];
}

uint32_t Container::getItemHoldingCount() {
	uint32_t counter = 0;
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		++counter;
	}
	return counter;
}

uint32_t Container::getContainerHoldingCount() {
	uint32_t counter = 0;
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		if ((*it)->getContainer()) {
			++counter;
		}
	}
	return counter;
}

bool Container::isHoldingItem(std::shared_ptr<Item> item) {
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		if (*it == item) {
			return true;
		}
	}
	return false;
}

bool Container::isHoldingItemWithId(const uint16_t id) {
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		std::shared_ptr<Item> item = *it;
		if (item->getID() == id) {
			return true;
		}
	}
	return false;
}

bool Container::isInsideContainerWithId(const uint16_t id) {
	auto nextParent = getParent();
	while (nextParent != nullptr && nextParent->getContainer()) {
		if (nextParent->getContainer()->getID() == id) {
			return true;
		}
		nextParent = nextParent->getRealParent();
	}
	return false;
}

bool Container::isAnyKindOfRewardChest() {
	return getID() == ITEM_REWARD_CHEST || getID() == ITEM_REWARD_CONTAINER && getParent() && getParent()->getContainer() && getParent()->getContainer()->getID() == ITEM_REWARD_CHEST || isBrowseFieldAndHoldsRewardChest();
}

bool Container::isAnyKindOfRewardContainer() {
	return getID() == ITEM_REWARD_CHEST || getID() == ITEM_REWARD_CONTAINER || isHoldingItemWithId(ITEM_REWARD_CONTAINER) || isInsideContainerWithId(ITEM_REWARD_CONTAINER);
}

bool Container::isBrowseFieldAndHoldsRewardChest() {
	return getID() == ITEM_BROWSEFIELD && isHoldingItemWithId(ITEM_REWARD_CHEST);
}

void Container::onAddContainerItem(std::shared_ptr<Item> item) {
	auto spectators = Spectators().find<Player>(getPosition(), false, 2, 2, 2, 2);

	// send to client
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->sendAddContainerItem(getContainer(), item);
	}

	// event methods
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->onAddContainerItem(item);
	}
}

void Container::onUpdateContainerItem(uint32_t index, std::shared_ptr<Item> oldItem, std::shared_ptr<Item> newItem) {
	auto spectators = Spectators().find<Player>(getPosition(), false, 2, 2, 2, 2);

	// send to client
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->sendUpdateContainerItem(getContainer(), index, newItem);
	}

	// event methods
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->onUpdateContainerItem(getContainer(), oldItem, newItem);
	}
}

void Container::onRemoveContainerItem(uint32_t index, std::shared_ptr<Item> item) {
	auto spectators = Spectators().find<Player>(getPosition(), false, 2, 2, 2, 2);

	// send change to client
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->sendRemoveContainerItem(getContainer(), index);
	}

	// event methods
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->onRemoveContainerItem(getContainer(), item);
	}
}

ReturnValue Container::queryAdd(int32_t addIndex, const std::shared_ptr<Thing> &addThing, uint32_t addCount, uint32_t flags, std::shared_ptr<Creature> actor /* = nullptr*/) {
	bool childIsOwner = hasBitSet(FLAG_CHILDISOWNER, flags);
	if (childIsOwner) {
		// a child container is querying, since we are the top container (not carried by a player)
		// just return with no error.
		return RETURNVALUE_NOERROR;
	}

	if (!unlocked) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	std::shared_ptr<Item> item = addThing->getItem();
	if (item == nullptr) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (!item->isPickupable()) {
		return RETURNVALUE_CANNOTPICKUP;
	}

	if (item == getItem()) {
		return RETURNVALUE_THISISIMPOSSIBLE;
	}

	std::shared_ptr<Cylinder> cylinder = getParent();
	auto noLimit = hasBitSet(FLAG_NOLIMIT, flags);
	while (cylinder) {
		if (cylinder == addThing) {
			return RETURNVALUE_THISISIMPOSSIBLE;
		}
		std::shared_ptr<Container> container = cylinder->getContainer();
		if (!noLimit && container && container->isInbox()) {
			return RETURNVALUE_CONTAINERNOTENOUGHROOM;
		}
		std::shared_ptr<Cylinder> parent = cylinder->getParent();
		if (cylinder == parent) {
			g_logger().error("Container::queryAdd: parent == cylinder. Preventing infinite loop.");
			return RETURNVALUE_NOTPOSSIBLE;
		}
		cylinder = parent;
	}

	if (!noLimit && addIndex == INDEX_WHEREEVER && size() >= capacity() && !hasPagination()) {
		return RETURNVALUE_CONTAINERNOTENOUGHROOM;
	}

	if (std::shared_ptr<Container> topParentContainer = getTopParentContainer()) {
		if (std::shared_ptr<Container> addContainer = item->getContainer()) {
			uint32_t addContainerCount = addContainer->getContainerHoldingCount() + 1;
			uint32_t maxContainer = static_cast<uint32_t>(g_configManager().getNumber(MAX_CONTAINER));
			if (addContainerCount + topParentContainer->getContainerHoldingCount() > maxContainer) {
				return RETURNVALUE_CONTAINERISFULL;
			}

			uint32_t addItemCount = addContainer->getItemHoldingCount() + 1;
			if (addItemCount + topParentContainer->getItemHoldingCount() > m_maxItems) {
				return RETURNVALUE_CONTAINERISFULL;
			}
		}

		if (topParentContainer->getItemHoldingCount() + 1 > m_maxItems) {
			return RETURNVALUE_CONTAINERISFULL;
		}
	}

	if (isQuiver() && item->getWeaponType() != WEAPON_AMMO) {
		return RETURNVALUE_ONLYAMMOINQUIVER;
	}

	std::shared_ptr<Cylinder> topParent = getTopParent();
	if (topParent != getContainer()) {
		return topParent->queryAdd(INDEX_WHEREEVER, item, addCount, flags | FLAG_CHILDISOWNER, actor);
	} else {
		return RETURNVALUE_NOERROR;
	}
}

ReturnValue Container::queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) {
	std::shared_ptr<Item> item = thing->getItem();
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
			for (std::shared_ptr<Item> containerItem : itemlist) {
				if (containerItem != item && containerItem->equals(item) && containerItem->getItemCount() < containerItem->getStackSize()) {
					uint32_t remainder = (containerItem->getStackSize() - containerItem->getItemCount());
					if (queryAdd(slotIndex++, item, remainder, flags) == RETURNVALUE_NOERROR) {
						n += remainder;
					}
				}
			}
		} else {
			std::shared_ptr<Item> destItem = getItemByIndex(index);
			if (item->equals(destItem) && destItem->getItemCount() < destItem->getStackSize()) {
				n = destItem->getStackSize() - destItem->getItemCount();
			}
		}

		// maxQueryCount is the limit of items I can add
		maxQueryCount = freeSlots * item->getStackSize() + n;
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

ReturnValue Container::queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature> actor /*= nullptr */) {
	int32_t index = getThingIndex(thing);
	if (index == -1) {
		g_logger().debug("{} - Failed to get thing index", __FUNCTION__);
		return RETURNVALUE_NOTPOSSIBLE;
	}

	std::shared_ptr<Item> item = thing->getItem();
	if (item == nullptr) {
		g_logger().debug("{} - Item is nullptr", __FUNCTION__);
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (count == 0 || (item->isStackable() && count > item->getItemCount())) {
		g_logger().debug("{} - Failed to get item count", __FUNCTION__);
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (!item->isMoveable() && !hasBitSet(FLAG_IGNORENOTMOVEABLE, flags)) {
		g_logger().debug("{} - Item is not moveable", __FUNCTION__);
		return RETURNVALUE_NOTMOVEABLE;
	}
	std::shared_ptr<HouseTile> houseTile = std::dynamic_pointer_cast<HouseTile>(getTopParent());
	if (houseTile) {
		return houseTile->queryRemove(thing, count, flags, actor);
	}
	return RETURNVALUE_NOERROR;
}

std::shared_ptr<Cylinder> Container::queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item>* destItem, uint32_t &flags) {
	if (!unlocked) {
		*destItem = nullptr;
		return getContainer();
	}

	if (index == 254 /*move up*/) {
		index = INDEX_WHEREEVER;
		*destItem = nullptr;

		std::shared_ptr<Container> parentContainer = std::dynamic_pointer_cast<Container>(getParent());
		if (parentContainer) {
			return parentContainer;
		}
		return getContainer();
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

	std::shared_ptr<Item> item = thing->getItem();
	if (!item) {
		return getContainer();
	}

	if (index != INDEX_WHEREEVER) {
		std::shared_ptr<Item> itemFromIndex = getItemByIndex(index);
		if (itemFromIndex) {
			*destItem = itemFromIndex;
		}

		std::shared_ptr<Cylinder> subCylinder = std::dynamic_pointer_cast<Cylinder>(*destItem);
		if (subCylinder) {
			index = INDEX_WHEREEVER;
			*destItem = nullptr;
			return subCylinder;
		}
	}

	bool autoStack = !hasBitSet(FLAG_IGNOREAUTOSTACK, flags);
	if (autoStack && item->isStackable() && item->getParent() != getContainer()) {
		if (*destItem && (*destItem)->equals(item) && (*destItem)->getItemCount() < (*destItem)->getStackSize()) {
			return getContainer();
		}

		// try find a suitable item to stack with
		uint32_t n = 0;
		for (std::shared_ptr<Item> listItem : itemlist) {
			if (listItem != item && listItem->equals(item) && listItem->getItemCount() < listItem->getStackSize()) {
				*destItem = listItem;
				index = n;
				return getContainer();
			}
			++n;
		}
	}
	return getContainer();
}

void Container::addThing(std::shared_ptr<Thing> thing) {
	return addThing(0, thing);
}

void Container::addThing(int32_t index, std::shared_ptr<Thing> thing) {
	if (!thing) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	if (index >= static_cast<int32_t>(capacity())) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	std::shared_ptr<Item> item = thing->getItem();
	if (item == nullptr) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	item->setParent(getContainer());
	itemlist.push_front(item);
	updateItemWeight(item->getWeight());

	// send change to client
	if (getParent() && (getParent() != VirtualCylinder::virtualCylinder)) {
		onAddContainerItem(item);
	}
}

void Container::addItemBack(std::shared_ptr<Item> item) {
	addItem(item);
	updateItemWeight(item->getWeight());

	// send change to client
	if (getParent() && (getParent() != VirtualCylinder::virtualCylinder)) {
		onAddContainerItem(item);
	}
}

void Container::updateThing(std::shared_ptr<Thing> thing, uint16_t itemId, uint32_t count) {
	int32_t index = getThingIndex(thing);
	if (index == -1) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	std::shared_ptr<Item> item = thing->getItem();
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

void Container::replaceThing(uint32_t index, std::shared_ptr<Thing> thing) {
	std::shared_ptr<Item> item = thing->getItem();
	if (!item) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	std::shared_ptr<Item> replacedItem = getItemByIndex(index);
	if (!replacedItem) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	itemlist[index] = item;
	item->setParent(getContainer());
	updateItemWeight(-static_cast<int32_t>(replacedItem->getWeight()) + item->getWeight());

	// send change to client
	if (getParent()) {
		onUpdateContainerItem(index, replacedItem, item);
	}

	replacedItem->resetParent();
}

void Container::removeThing(std::shared_ptr<Thing> thing, uint32_t count) {
	std::shared_ptr<Item> item = thing->getItem();
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

		item->resetParent();
		itemlist.erase(itemlist.begin() + index);
	}
}

int32_t Container::getThingIndex(std::shared_ptr<Thing> thing) const {
	int32_t index = 0;
	for (std::shared_ptr<Item> item : itemlist) {
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
	for (std::shared_ptr<Item> item : itemlist) {
		if (item->getID() == itemId) {
			count += countByType(item, subType);
		}
	}
	return count;
}

std::map<uint32_t, uint32_t> &Container::getAllItemTypeCount(std::map<uint32_t, uint32_t> &countMap) const {
	for (std::shared_ptr<Item> item : itemlist) {
		countMap[item->getID()] += item->getItemCount();
	}
	return countMap;
}

std::shared_ptr<Thing> Container::getThing(size_t index) const {
	return getItemByIndex(index);
}

ItemVector Container::getItems(bool recursive /*= false*/) {
	ItemVector containerItems;
	if (recursive) {
		for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
			containerItems.push_back(*it);
		}
	} else {
		for (std::shared_ptr<Item> item : itemlist) {
			containerItems.push_back(item);
		}
	}
	return containerItems;
}

void Container::postAddNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> oldParent, int32_t index, CylinderLink_t) {
	std::shared_ptr<Cylinder> topParent = getTopParent();
	if (topParent->getCreature()) {
		topParent->postAddNotification(thing, oldParent, index, LINK_TOPPARENT);
	} else if (topParent == getContainer()) {
		// let the tile class notify surrounding players
		if (topParent->getParent()) {
			topParent->getParent()->postAddNotification(thing, oldParent, index, LINK_NEAR);
		}
	} else {
		topParent->postAddNotification(thing, oldParent, index, LINK_PARENT);
	}
}

void Container::postRemoveNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> newParent, int32_t index, CylinderLink_t) {
	std::shared_ptr<Cylinder> topParent = getTopParent();
	if (topParent->getCreature()) {
		topParent->postRemoveNotification(thing, newParent, index, LINK_TOPPARENT);
	} else if (topParent == getContainer()) {
		// let the tile class notify surrounding players
		if (topParent->getParent()) {
			topParent->getParent()->postRemoveNotification(thing, newParent, index, LINK_NEAR);
		}
	} else {
		topParent->postRemoveNotification(thing, newParent, index, LINK_PARENT);
	}
}

void Container::internalAddThing(std::shared_ptr<Thing> thing) {
	internalAddThing(0, thing);
}

void Container::internalAddThing(uint32_t, std::shared_ptr<Thing> thing) {
	if (!thing) {
		return;
	}

	std::shared_ptr<Item> item = thing->getItem();
	if (item == nullptr) {
		return;
	}

	item->setParent(getContainer());
	itemlist.push_front(item);
	updateItemWeight(item->getWeight());
}

void Container::startDecaying() {
	g_decay().startDecay(getContainer());
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		g_decay().startDecay(*it);
	}
}

void Container::stopDecaying() {
	g_decay().stopDecay(getContainer());
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		g_decay().stopDecay(*it);
	}
}

uint16_t Container::getFreeSlots() {
	uint16_t counter = std::max<uint16_t>(0, capacity() - size());

	for (std::shared_ptr<Item> item : itemlist) {
		if (std::shared_ptr<Container> container = item->getContainer()) {
			counter += std::max<uint16_t>(0, container->getFreeSlots());
		}
	}

	return counter;
}

ContainerIterator Container::iterator() {
	ContainerIterator cit;
	if (!itemlist.empty()) {
		cit.over.push_back(getContainer());
		cit.cur = itemlist.begin();
	}
	return cit;
}

void Container::removeItem(std::shared_ptr<Thing> thing, bool sendUpdateToClient /* = false*/) {
	if (thing == nullptr) {
		return;
	}

	auto itemToRemove = thing->getItem();
	if (itemToRemove == nullptr) {
		return;
	}

	auto it = std::ranges::find(itemlist.begin(), itemlist.end(), itemToRemove);
	if (it != itemlist.end()) {
		// Send change to client
		if (auto thingIndex = getThingIndex(thing); sendUpdateToClient && thingIndex != -1 && getParent()) {
			onRemoveContainerItem(thingIndex, itemToRemove);
		}

		itemlist.erase(it);
		itemToRemove->resetParent();
	}
}

std::shared_ptr<Item> ContainerIterator::operator*() {
	return *cur;
}

void ContainerIterator::advance() {
	if (std::shared_ptr<Item> i = *cur) {
		if (std::shared_ptr<Container> c = i->getContainer()) {
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
