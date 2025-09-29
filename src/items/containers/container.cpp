/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "items/containers/container.hpp"

#include "config/configmanager.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "map/spectators.hpp"

Container::Container(uint16_t type) :
	Container(type, items[type].maxItems) {
	m_maxItems = static_cast<uint32_t>(g_configManager().getNumber(MAX_CONTAINER_ITEM));
	if (getID() == ITEM_GOLD_POUCH) {
		pagination = true;
		m_maxItems = g_configManager().getNumber(LOOTPOUCH_MAXLIMIT);
		maxSize = 32;
	}

	if (isStoreInbox()) {
		pagination = true;
		m_maxItems = g_configManager().getNumber(STOREINBOX_MAXLIMIT);
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

std::shared_ptr<Container> Container::createBrowseField(const std::shared_ptr<Tile> &tile) {
	const auto &newContainer = create(ITEM_BROWSEFIELD, 30, false, true);
	if (!newContainer || !tile) {
		return nullptr;
	}

	const TileItemVector* itemVector = tile->getItemList();
	if (itemVector) {
		for (const auto &item : *itemVector) {
			if (!item) {
				continue;
			}

			// Checks if the item has an internal container, is movable, or is packable without blocking the path.
			bool isItemValid = item->getContainer() || item->hasProperty(CONST_PROP_MOVABLE) || (item->isWrapable() && !item->hasProperty(CONST_PROP_MOVABLE) && !item->hasProperty(CONST_PROP_BLOCKPATH));

			// If the item has a unique ID or is not valid, skip to the next item.
			if (item->hasAttribute(ItemAttribute_t::UNIQUEID) || !isItemValid) {
				continue;
			}

			// Add the item to the new container and set its parent.
			newContainer->itemlist.push_front(item);
			item->setParent(newContainer);
		}
	}

	// Set the parent of the new container to be the tile.
	newContainer->setParent(tile);
	return newContainer;
}

Container::~Container() {
	if (getID() == ITEM_BROWSEFIELD) {
		const auto &parent = getParent();
		if (parent) {
			const auto &tile = parent->getTile();
			if (tile) {
				auto browseField = g_game().browseFields.find(tile);
				if (browseField != g_game().browseFields.end()) {
					g_game().browseFields.erase(browseField);
				}
			}

			for (auto &item : itemlist) {
				if (item) {
					item->setParent(parent);
				}
			}
		}
	}
}

std::shared_ptr<Item> Container::clone() const {
	const std::shared_ptr<Container> &clone = std::static_pointer_cast<Container>(Item::clone());
	for (const std::shared_ptr<Item> &item : itemlist) {
		clone->addItem(item->clone());
	}
	clone->totalWeight = totalWeight;
	return clone;
}

std::shared_ptr<Container> Container::getParentContainer() {
	const std::shared_ptr<Thing> &thing = getParent();
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
	const auto &parent = getParent();
	if (!parent) {
		return false;
	}
	const auto &creature = parent->getCreature();
	const bool &isPlayer = creature && creature->getPlayer() != nullptr;
	return getID() != ITEM_BROWSEFIELD && !isPlayer;
}

void Container::addItem(const std::shared_ptr<Item> &item) {
	itemlist.push_back(item);
	item->setParent(getContainer());
	updateCacheOnAdd(item);
	updateItemWeight(item->getWeight());
}

StashContainerList Container::getStowableItems() {
	StashContainerList toReturnList;

	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		const auto &item = *it;
		const auto &itemType = Item::items.getItemType(item->getID());
		if (item->isItemStorable() && !itemType.isContainer()) {
			toReturnList.emplace_back(item, static_cast<uint32_t>(item->getItemCount()));
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
	const bool ret = Item::unserializeItemNode(loader, node, propStream, itemPosition);
	if (!ret) {
		return false;
	}

	for (const auto &itemNode : node.children) {
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

		const auto &item = Item::CreateItem(id, itemPosition);
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

bool Container::countsToLootAnalyzerBalance() const {
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

void Container::updateCacheOnAdd(const std::shared_ptr<Item> &item) {
	if (const auto &subContainer = item->getContainer()) {
		// Adding a container: count the container itself (+1) plus all its internal items and containers.
		m_cachedItemCount += 1 + subContainer->m_cachedItemCount;
		m_cachedContainerCount += 1 + subContainer->m_cachedContainerCount;
	} else {
		// Adding a regular item: increment item count by one.
		m_cachedItemCount += 1;
	}

	// Propagate the update to the parent container, maintaining accurate cached counts up the hierarchy.
	if (const auto &parent = getParentContainer()) {
		parent->updateCacheOnAdd(item);
	}
}

void Container::updateCacheOnRemove(const std::shared_ptr<Item> &item) {
	if (auto subContainer = item->getContainer()) {
		// Removing a container: subtract one (itself) plus all items and containers within it.
		m_cachedItemCount -= (1 + subContainer->m_cachedItemCount);
		m_cachedContainerCount -= (1 + subContainer->m_cachedContainerCount);
	} else {
		// Removing a regular item: decrease the item count by one.
		m_cachedItemCount -= 1;
	}

	// Propagate the update to the parent container, ensuring correct counts up the chain.
	if (auto parent = getParentContainer()) {
		parent->updateCacheOnRemove(item);
	}
}

void Container::updateItemCountCache() {
	m_cachedItemCount = 0;
	m_cachedContainerCount = 0;

	for (const auto &item : getItemList()) {
		++m_cachedItemCount;
		if (const auto &sub = item->getContainer()) {
			sub->updateItemCountCache();
			m_cachedItemCount += sub->getItemHoldingCount();
			m_cachedContainerCount += 1 + sub->getContainerHoldingCount();
		}
	}
}

uint32_t Container::getWeight() const {
	return Item::getWeight() + totalWeight;
}

std::string Container::getContentDescription(bool sendColoredMessage) {
	std::vector<std::string> descriptions;

	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		const auto &item = *it;
		if (!item) {
			continue;
		}

		const auto &container = item->getContainer();
		if (container && !container->empty()) {
			continue;
		}

		if (sendColoredMessage) {
			descriptions.push_back(fmt::format("{{{}|{}}}", item->getID(), item->getNameDescription()));
		} else {
			descriptions.push_back(item->getNameDescription());
		}
	}

	return descriptions.empty() ? "nothing" : fmt::format("{}", fmt::join(descriptions, ", "));
}

uint32_t Container::getMaxCapacity() const {
	return m_maxItems;
}

bool Container::isStoreInbox() const {
	return getID() == ITEM_STORE_INBOX;
}

bool Container::isStoreInboxFiltered() const {
	const auto attribute = getAttribute<std::string>(ItemAttribute_t::STORE_INBOX_CATEGORY);
	if (isStoreInbox() && !attribute.empty() && attribute != "All") {
		return true;
	}

	return false;
}

std::deque<std::shared_ptr<Item>> Container::getStoreInboxFilteredItems() const {
	const auto enumName = getAttribute<std::string>(ItemAttribute_t::STORE_INBOX_CATEGORY);
	ItemDeque storeInboxFilteredList;
	if (isStoreInboxFiltered()) {
		for (const std::shared_ptr<Item> &item : getItemList()) {
			auto itemId = item->getID();
			const auto attribute = item->getCustomAttribute("unWrapId");
			const uint16_t unWrapId = attribute ? static_cast<uint16_t>(attribute->getInteger()) : 0;
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
		const auto attribute = item->getCustomAttribute("unWrapId");
		const uint16_t unWrapId = attribute ? static_cast<uint16_t>(attribute->getInteger()) : 0;
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
	const auto &filteredItems = getStoreInboxFilteredItems();
	if (index >= filteredItems.size()) {
		return nullptr;
	}

	const auto &item = filteredItems[index];

	const auto it = std::ranges::find(itemlist, item);
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

uint32_t Container::getItemHoldingCount() const {
	return m_cachedItemCount;
}

uint32_t Container::getContainerHoldingCount() const {
	return m_cachedContainerCount;
}

bool Container::isHoldingItem(const std::shared_ptr<Item> &item) {
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		const auto &compareItem = *it;
		if (!compareItem || !item) {
			continue;
		}

		if (compareItem == item) {
			return true;
		}
	}
	return false;
}

bool Container::isHoldingItemWithId(const uint16_t id) {
	for (ContainerIterator it = iterator(); it.hasNext(); it.advance()) {
		const auto &item = *it;
		if (!item) {
			continue;
		}

		if (item && item->getID() == id) {
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
	return getID() == ITEM_REWARD_CHEST || (getID() == ITEM_REWARD_CONTAINER && getParent() && getParent()->getContainer() && getParent()->getContainer()->getID() == ITEM_REWARD_CHEST) || isBrowseFieldAndHoldsRewardChest();
}

bool Container::isAnyKindOfRewardContainer() {
	return getID() == ITEM_REWARD_CHEST || getID() == ITEM_REWARD_CONTAINER || isHoldingItemWithId(ITEM_REWARD_CONTAINER) || isInsideContainerWithId(ITEM_REWARD_CONTAINER);
}

bool Container::isBrowseFieldAndHoldsRewardChest() {
	return getID() == ITEM_BROWSEFIELD && isHoldingItemWithId(ITEM_REWARD_CHEST);
}

void Container::onAddContainerItem(const std::shared_ptr<Item> &item) {
	if (m_batching) {
		return;
	}

	const auto spectators = Spectators().find<Player>(getPosition(), false, 2, 2, 2, 2);

	// send to client
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->sendAddContainerItem(getContainer(), item);
	}

	// event methods
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->onAddContainerItem(item);
	}
}

void Container::onUpdateContainerItem(uint32_t index, const std::shared_ptr<Item> &oldItem, const std::shared_ptr<Item> &newItem) {
	const auto &holdingPlayer = getHoldingPlayer();
	const auto &thisContainer = getContainer();
	if (holdingPlayer) {
		holdingPlayer->sendUpdateContainerItem(thisContainer, index, newItem);
		holdingPlayer->onUpdateContainerItem(thisContainer, oldItem, newItem);
		return;
	}

	const auto spectators = Spectators().find<Player>(getPosition(), false, 2, 2, 2, 2);

	// send to client
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->sendUpdateContainerItem(thisContainer, index, newItem);
	}

	// event methods
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->onUpdateContainerItem(thisContainer, oldItem, newItem);
	}
}

void Container::onRemoveContainerItem(uint32_t index, const std::shared_ptr<Item> &item) {
	if (m_batching) {
		return;
	}

	const auto &holdingPlayer = getHoldingPlayer();
	const auto &thisContainer = getContainer();
	if (holdingPlayer) {
		holdingPlayer->sendRemoveContainerItem(thisContainer, index);
		holdingPlayer->onRemoveContainerItem(thisContainer, item);
		return;
	}

	const auto spectators = Spectators().find<Player>(getPosition(), false, 2, 2, 2, 2);

	// send change to client
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->sendRemoveContainerItem(thisContainer, index);
	}

	// event methods
	for (const auto &spectator : spectators) {
		spectator->getPlayer()->onRemoveContainerItem(thisContainer, item);
	}
}

ReturnValue Container::queryAdd(int32_t addIndex, const std::shared_ptr<Thing> &addThing, uint32_t addCount, uint32_t flags, const std::shared_ptr<Creature> &actor /* = nullptr*/) {
	const bool childIsOwner = hasBitSet(FLAG_CHILDISOWNER, flags);
	if (childIsOwner) {
		// a child container is querying, since we are the top container (not carried by a player)
		// just return with no error.
		return RETURNVALUE_NOERROR;
	}

	if (!unlocked && !hasBitSet(FLAG_LOOTPOUCH, flags)) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	const auto &item = addThing->getItem();
	if (item == nullptr) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (!item->isPickupable()) {
		return RETURNVALUE_CANNOTPICKUP;
	}

	if (item == getItem()) {
		return RETURNVALUE_THISISIMPOSSIBLE;
	}
	if (item->hasOwner()) {
		// a non-owner can move the item around but not pick it up
		const auto &toPlayer = getTopParent()->getPlayer();
		if (toPlayer && !item->isOwner(toPlayer)) {
			return RETURNVALUE_ITEMISNOTYOURS;
		}

		// a container cannot have items of different owners
		if (hasOwner() && getOwnerId() != item->getOwnerId()) {
			return RETURNVALUE_ITEMISNOTYOURS;
		}
	}

	std::shared_ptr<Cylinder> cylinder = getParent();
	const auto noLimit = hasBitSet(FLAG_NOLIMIT, flags);
	while (cylinder) {
		if (cylinder == addThing) {
			return RETURNVALUE_THISISIMPOSSIBLE;
		}
		const std::shared_ptr<Container> &container = cylinder->getContainer();
		if (!noLimit && container && container->isInbox()) {
			return RETURNVALUE_CONTAINERNOTENOUGHROOM;
		}
		const std::shared_ptr<Cylinder> &parent = cylinder->getParent();
		if (cylinder == parent) {
			g_logger().error("Container::queryAdd: parent == cylinder. Preventing infinite loop.");
			return RETURNVALUE_NOTPOSSIBLE;
		}
		cylinder = parent;
	}

	if (!noLimit && addIndex == INDEX_WHEREEVER && size() >= capacity() && !hasPagination()) {
		return RETURNVALUE_CONTAINERNOTENOUGHROOM;
	}

	if (const auto &topParentContainer = getTopParentContainer()) {
		if (const auto &addContainer = item->getContainer()) {
			uint32_t addContainerCount = addContainer->getContainerHoldingCount() + 1;
			uint32_t maxContainer = static_cast<uint32_t>(g_configManager().getNumber(MAX_CONTAINER));
			if (addContainerCount + topParentContainer->getContainerHoldingCount() > maxContainer) {
				return RETURNVALUE_CONTAINERISFULL;
			}

			const uint32_t addItemCount = addContainer->getItemHoldingCount() + 1;
			if (addItemCount + topParentContainer->getItemHoldingCount() > m_maxItems) {
				return RETURNVALUE_CONTAINERISFULL;
			}
		} else {
			if (topParentContainer->getItemHoldingCount() + 1 > m_maxItems) {
				return RETURNVALUE_CONTAINERISFULL;
			}
		}
	}

	if (isQuiver() && item->getWeaponType() != WEAPON_AMMO) {
		return RETURNVALUE_ONLYAMMOINQUIVER;
	}

	const std::shared_ptr<Cylinder> &topParent = getTopParent();
	if (topParent != getContainer()) {
		return topParent->queryAdd(INDEX_WHEREEVER, item, addCount, flags | FLAG_CHILDISOWNER, actor);
	} else {
		return RETURNVALUE_NOERROR;
	}
}

ReturnValue Container::queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) {
	const auto &item = thing->getItem();
	if (item == nullptr) {
		maxQueryCount = 0;
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (hasBitSet(FLAG_NOLIMIT, flags) || hasPagination()) {
		maxQueryCount = std::max<uint32_t>(1, count);
		return RETURNVALUE_NOERROR;
	}

	const int32_t freeSlots = std::max<int32_t>(capacity() - size(), 0);

	if (item->isStackable()) {
		uint32_t n = 0;

		if (index == INDEX_WHEREEVER) {
			// Iterate through every item and check how much free stackable slots there is.
			uint32_t slotIndex = 0;
			for (const auto &containerItem : itemlist) {
				if (containerItem != item && containerItem->equals(item) && containerItem->getItemCount() < containerItem->getStackSize()) {
					const uint32_t remainder = (containerItem->getStackSize() - containerItem->getItemCount());
					if (queryAdd(slotIndex++, item, remainder, flags) == RETURNVALUE_NOERROR) {
						n += remainder;
					}
				}
			}
		} else {
			const auto &destItem = getItemByIndex(index);
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

ReturnValue Container::queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor /*= nullptr */) {
	const int32_t index = getThingIndex(thing);
	if (index == -1) {
		g_logger().debug("{} - Failed to get thing index", __FUNCTION__);
		return RETURNVALUE_NOTPOSSIBLE;
	}

	const auto &item = thing->getItem();
	if (item == nullptr) {
		g_logger().debug("{} - Item is nullptr", __FUNCTION__);
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (count == 0 || (item->isStackable() && count > item->getItemCount())) {
		g_logger().debug("{} - Failed to get item count", __FUNCTION__);
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (!item->isMovable() && !hasBitSet(FLAG_IGNORENOTMOVABLE, flags)) {
		g_logger().debug("{} - Item is not movable", __FUNCTION__);
		return RETURNVALUE_NOTMOVABLE;
	}
	const std::shared_ptr<HouseTile> &houseTile = std::dynamic_pointer_cast<HouseTile>(getTopParent());
	if (houseTile) {
		return houseTile->queryRemove(thing, count, flags, actor);
	}
	return RETURNVALUE_NOERROR;
}

std::shared_ptr<Cylinder> Container::queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item> &destItem, uint32_t &flags) {
	const auto &thisContainer = getContainer();
	if (!unlocked && !hasBitSet(FLAG_LOOTPOUCH, flags)) {
		destItem = nullptr;
		return thisContainer;
	}

	if (index == 254 /*move up*/) {
		index = INDEX_WHEREEVER;
		destItem = nullptr;

		const auto &parentContainer = std::dynamic_pointer_cast<Container>(getParent());
		if (parentContainer) {
			return parentContainer;
		}
		return getContainer();
	}

	if (index == 255 /*add wherever*/) {
		index = INDEX_WHEREEVER;
		destItem = nullptr;
	} else if (index >= static_cast<int32_t>(capacity()) && !hasPagination()) {
		/*
		if you have a container, maximize it to show all 20 slots
		then you open a bag that is inside the container you will have a bag with 8 slots
		and a "grey" area where the other 12 slots where from the container
		if you drop the item on that grey area
		the client calculates the slot position as if the bag has 20 slots
		*/
		index = INDEX_WHEREEVER;
		destItem = nullptr;
	}

	const auto &item = thing->getItem();
	if (!item) {
		return getContainer();
	}

	if (index != INDEX_WHEREEVER) {
		const auto &itemFromIndex = getItemByIndex(index);
		if (itemFromIndex) {
			destItem = itemFromIndex;
		}

		const auto &subCylinder = std::dynamic_pointer_cast<Cylinder>(destItem);
		if (subCylinder) {
			index = INDEX_WHEREEVER;
			destItem = nullptr;
			return subCylinder;
		}
	}

	const bool autoStack = !hasBitSet(FLAG_IGNOREAUTOSTACK, flags);
	if (autoStack && item->isStackable() && item->getParent() != getContainer()) {
		if (destItem && destItem->equals(item) && destItem->getItemCount() < destItem->getStackSize()) {
			return getContainer();
		}

		// try find a suitable item to stack with
		uint32_t n = 0;
		for (const auto &listItem : itemlist) {
			if (listItem != item && listItem->equals(item) && listItem->getItemCount() < listItem->getStackSize()) {
				destItem = listItem;
				index = n;
				return getContainer();
			}
			++n;
		}
	}
	return getContainer();
}

void Container::addThing(const std::shared_ptr<Thing> &thing) {
	return addThing(0, thing);
}

void Container::addThing(int32_t index, const std::shared_ptr<Thing> &thing) {
	if (!thing) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	if (index >= static_cast<int32_t>(capacity())) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const auto &item = thing->getItem();
	if (item == nullptr) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	updateCacheOnAdd(item);

	item->setParent(getContainer());
	itemlist.push_front(item);
	updateItemWeight(item->getWeight());

	// send change to client
	if (getParent() && (getParent() != VirtualCylinder::virtualCylinder)) {
		onAddContainerItem(item);
	}
}

void Container::addItemBack(const std::shared_ptr<Item> &item) {
	addItem(item);
	updateItemWeight(item->getWeight());

	// send change to client
	if (getParent() && (getParent() != VirtualCylinder::virtualCylinder)) {
		onAddContainerItem(item);
	}
}

void Container::updateThing(const std::shared_ptr<Thing> &thing, uint16_t itemId, uint32_t count) {
	const int32_t index = getThingIndex(thing);
	if (index == -1) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const auto &item = thing->getItem();
	if (item == nullptr) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const int32_t oldWeight = item->getWeight();
	item->setID(itemId);
	item->setSubType(count);
	updateCacheOnRemove(item);
	updateCacheOnAdd(item);
	updateItemWeight(-oldWeight + item->getWeight());

	// send change to client
	if (getParent()) {
		onUpdateContainerItem(index, item, item);
	}
}

void Container::replaceThing(uint32_t index, const std::shared_ptr<Thing> &thing) {
	if (!thing) {
		return;
	}

	if (index >= itemlist.size()) {
		return;
	}

	const auto &item = thing->getItem();
	if (!item) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const auto &replacedItem = getItemByIndex(index);
	if (!replacedItem) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	itemlist[index] = item;
	item->setParent(getContainer());

	updateCacheOnRemove(replacedItem);
	updateCacheOnAdd(item);
	updateItemWeight(-static_cast<int32_t>(replacedItem->getWeight()) + item->getWeight());

	// send change to client
	if (getParent()) {
		onUpdateContainerItem(index, replacedItem, item);
	}

	replacedItem->resetParent();
}

void Container::removeThing(const std::shared_ptr<Thing> &thing, uint32_t count) {
	const auto &item = thing->getItem();
	if (item == nullptr) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const int32_t index = getThingIndex(thing);
	if (index == -1) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	if (item->isStackable() && count != item->getItemCount()) {
		const auto newCount = static_cast<uint8_t>(std::max<int32_t>(0, item->getItemCount() - count));
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

void Container::removeItemByIndex(size_t index, uint32_t count) {
	if (index >= itemlist.size() || count == 0) {
		return;
	}

	// Use copy to avoid aliasing after swap
	auto removed = itemlist[index];
	if (!removed) {
		return;
	}

	int32_t weightDiff = 0;

	if (removed->isStackable() && count < removed->getItemCount()) {
		const int32_t oldWeight = removed->getWeight();
		const uint8_t newCount = static_cast<uint8_t>(removed->getItemCount() - count);
		removed->setItemCount(newCount);
		weightDiff = -oldWeight + removed->getWeight();

		if (!m_batching && getParent()) {
			onUpdateContainerItem(static_cast<uint32_t>(index), removed, removed);
		}
	} else {
		weightDiff = -static_cast<int32_t>(removed->getWeight());
		updateCacheOnRemove(removed);

		if (!m_batching && getParent()) {
			onRemoveContainerItem(static_cast<uint32_t>(index), removed);
		}

		removed->stopDecaying();
		removed->onRemoved();

		if (m_batching) {
			if (index != itemlist.size() - 1) {
				std::swap(itemlist[index], itemlist.back());
				if (const auto &moved = itemlist[index]) {
					if (moved->getParent().get() != this) {
						moved->setParent(getContainer());
					}
				}
			}
			itemlist.pop_back();

			removed->resetParent();
		} else {
			removed->resetParent();
			itemlist.erase(itemlist.begin() + static_cast<std::ptrdiff_t>(index));
		}
	}

	updateItemWeight(weightDiff);
}

int32_t Container::getThingIndex(const std::shared_ptr<Thing> &thing) const {
	int32_t index = 0;
	if (thing == nullptr) {
		return -1;
	}

	const auto item = thing->getItem();
	if (item == nullptr) {
		return -1;
	}

	auto rawPtr = item.get();
	for (const std::shared_ptr<Item> &item : itemlist) {
		if (item.get() == rawPtr) {
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
	for (const std::shared_ptr<Item> &item : itemlist) {
		if (item->getID() == itemId) {
			count += countByType(item, subType);
		}
	}
	return count;
}

std::map<uint32_t, uint32_t> &Container::getAllItemTypeCount(std::map<uint32_t, uint32_t> &countMap) const {
	for (const std::shared_ptr<Item> &item : itemlist) {
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
		for (const std::shared_ptr<Item> &item : itemlist) {
			containerItems.push_back(item);
		}
	}
	return containerItems;
}

void Container::postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t) {
	const std::shared_ptr<Cylinder> &topParent = getTopParent();
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

void Container::postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t) {
	const std::shared_ptr<Cylinder> &topParent = getTopParent();
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

void Container::internalAddThing(const std::shared_ptr<Thing> &thing) {
	internalAddThing(0, thing);
}

void Container::internalAddThing(uint32_t, const std::shared_ptr<Thing> &thing) {
	if (!thing) {
		return;
	}

	const auto &item = thing->getItem();
	if (item == nullptr) {
		return;
	}

	item->setParent(getContainer());
	itemlist.push_front(item);
	updateItemWeight(item->getWeight());
	updateCacheOnAdd(item);
}

uint16_t Container::getFreeSlots() const {
	uint16_t counter = std::max<uint16_t>(0, capacity() - size());

	for (const auto &item : itemlist) {
		if (const auto &container = item->getContainer()) {
			counter += std::max<uint16_t>(0, container->getFreeSlots());
		}
	}

	return counter;
}

ContainerIterator Container::iterator() const {
	static thread_local std::unordered_set<const Container*> pool;
	pool.clear();

	// Always shrink the hash table to release unused memory
	pool.rehash(0);

	const auto &selfContainer = getContainer();
	if (!selfContainer) {
		return { nullptr, 0, pool };
	}
	return { selfContainer, static_cast<size_t>(g_configManager().getNumber(MAX_CONTAINER_DEPTH)), pool };
}

void Container::beginBatchUpdate() {
	m_batching = true;
}

void Container::endBatchUpdate(Player* actor) {
	if (!m_batching) {
		return;
	}
	m_batching = false;
	if (actor) {
		actor->sendBatchUpdateContainer(this, true, getFirstIndex());
	}
}

void Container::removeItem(const std::shared_ptr<Thing> &thing, bool sendUpdateToClient /* = false*/) {
	if (thing == nullptr) {
		return;
	}

	const auto &itemToRemove = thing->getItem();
	if (itemToRemove == nullptr) {
		return;
	}

	const auto it = std::ranges::find(itemlist.begin(), itemlist.end(), itemToRemove);
	if (it != itemlist.end()) {
		// Send change to client
		if (const auto thingIndex = getThingIndex(thing); sendUpdateToClient && thingIndex != -1 && getParent()) {
			onRemoveContainerItem(thingIndex, itemToRemove);
		}

		itemlist.erase(it);
		itemToRemove->resetParent();
	}
}

uint32_t Container::getOwnerId() const {
	uint32_t ownerId = Item::getOwnerId();
	if (ownerId > 0) {
		return ownerId;
	}
	for (const auto &item : itemlist) {
		ownerId = item->getOwnerId();
		if (ownerId > 0) {
			return ownerId;
		}
	}
	return 0;
}

/**
 * ContainerIterator
 * @brief Iterator for iterating over the items in a container
 */
ContainerIterator::ContainerIterator(const std::shared_ptr<const Container> &container, size_t maxDepth, std::unordered_set<const Container*> &pool) :
	visitedContainers(&pool), maxTraversalDepth(maxDepth) {
	if (container) {
		states.reserve(maxDepth);
		const auto &items = container->getItemList();

		states.emplace_back(container, items, 0, 1);
		visitedContainers->insert(container.get());
	}
}

bool ContainerIterator::hasNext() const {
	while (!states.empty()) {
		auto &s = states.back();
		if (!s.container.lock()) {
			states.pop_back();
			continue;
		}
		if (s.index < s.items->size()) {
			return true;
		}
		states.pop_back();
	}
	return false;
}

void ContainerIterator::advance() {
	while (!states.empty()) {
		auto &top = states.back();

		if (!top.container.lock()) {
			states.pop_back();
			continue;
		}
		if (top.index >= top.items->size()) {
			states.pop_back();
			continue;
		}

		const auto &currentItem = (*top.items)[top.index];
		++top.index;

		if (!currentItem) {
			return;
		}

		const auto &sub = currentItem->getContainer();
		if (!sub) {
			return;
		}

		const auto &list = sub->getItemList();
		if (list.empty()) {
			return;
		}

		const size_t newDepth = top.depth + 1;
		if (newDepth > maxTraversalDepth) {
			m_maxDepthReached = true;
			return;
		}

		const auto raw = sub.get();
		if (!visitedContainers->insert(raw).second) {
			m_cycleDetected = true;
			return;
		}

		states.emplace_back(sub, list, 0, newDepth);
		return;
	}
}

std::shared_ptr<Item> ContainerIterator::operator*() const {
	if (states.empty()) {
		return nullptr;
	}

	const auto &top = states.back();
	if (!top.container.lock()) {
		return nullptr;
	}

	const auto* items = top.items;
	if (!items || top.index >= items->size()) {
		return nullptr;
	}

	return (*items)[top.index];
}

bool ContainerIterator::hasReachedMaxDepth() const {
	return m_maxDepthReached;
}

size_t ContainerIterator::getCurrentIndex() const {
	if (states.empty()) {
		return 0;
	}
	const auto &top = states.back();
	return top.index;
}
