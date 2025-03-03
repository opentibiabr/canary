/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/cylinder.hpp"
#include "items/item.hpp"
#include "items/tile.hpp"

class Container;
class DepotChest;
class DepotLocker;
class RewardChest;
class Reward;

class ContainerIterator {
public:
	/**
	 * @brief Constructs a ContainerIterator with a specified container and maximum traversal depth.
	 *
	 * This constructor initializes the iterator to start iterating over the specified container
	 * and ensures that it will not traverse deeper than the specified maxDepth.
	 *
	 * @param container The root container to start iterating from.
	 * @param maxDepth The maximum depth of nested containers to traverse.
	 */
	ContainerIterator(const std::shared_ptr<Container> &container, size_t maxDepth);

	/**
	 * @brief Checks if there are more items to iterate over in the container.
	 *
	 * This function checks if there are more items to iterate over in the current container or
	 * in any of the nested sub-containers. If no items are left, the function will return false.
	 *
	 * @return true if there are more items to iterate over; false otherwise.
	 */
	bool hasNext() const;

	/**
	 * @brief Advances the iterator to the next item in the container.
	 *
	 * This function moves the iterator to the next item. If the current item is a sub-container,
	 * it adds that sub-container to the stack to iterate over its items as well.
	 * It also handles maximum depth and cycle detection to prevent infinite loops.
	 */
	void advance();

	/**
	 * @brief Returns the current item pointed to by the iterator.
	 *
	 * This function returns the current item in the container that the iterator points to.
	 * If there are no more items to iterate over, it returns nullptr.
	 *
	 * @return A shared pointer to the current item, or nullptr if no items are left.
	 */
	std::shared_ptr<Item> operator*() const;

	bool hasReachedMaxDepth() const;

	std::shared_ptr<Container> getCurrentContainer() const;
	size_t getCurrentIndex() const;

private:
	/**
	 * @brief Represents the state of the iterator at a given point in time.
	 *
	 * This structure is used to keep track of the current container,
	 * the index of the current item within that container, and the depth
	 * of traversal for nested containers. It is primarily used in the
	 * ContainerIterator to manage the state of the iteration as it traverses
	 * through containers and their sub-containers.
	 */
	struct IteratorState {
		/**
		 * @brief The container being iterated over.
		 */
		std::weak_ptr<Container> container;

		/**
		 * @brief The current index within the container's item list.
		 */
		size_t index;

		/**
		 * @brief The depth of traversal, indicating how deep the iteration is
		 * within nested sub-containers.
		 */
		size_t depth;

		/**
		 * @brief Constructs an IteratorState with the given container, index, and depth.
		 *
		 * @param c The container to iterate over.
		 * @param i The starting index within the container.
		 * @param d The depth of traversal.
		 */
		IteratorState(std::shared_ptr<Container> c, size_t i, size_t d) :
			container(c), index(i), depth(d) { }
	};

	/**
	 * @brief Stack of IteratorState objects representing the state of the iteration.
	 *
	 * This stack keeps track of the current position in each container and is
	 * used to traverse containers and their nested sub-containers in a depth-first manner.
	 * Each element in the stack represents a different level in the container hierarchy.
	 */
	mutable std::vector<IteratorState> states;

	/**
	 * @brief Set of containers that have already been visited during the iteration.
	 *
	 * This set is used to keep track of all containers that have been visited
	 * to avoid revisiting them and causing infinite loops or cycles. It ensures
	 * that each container is processed only once, preventing redundant processing
	 * and potential crashes due to cyclic references.
	 */
	mutable std::unordered_set<std::shared_ptr<Container>> visitedContainers;
	size_t maxTraversalDepth = 0;

	bool m_maxDepthReached = false;
	bool m_cycleDetected = false;

	friend class Container;
};

class Container : public Item, public Cylinder {
public:
	explicit Container(uint16_t type);
	Container(uint16_t type, uint16_t size, bool unlocked = true, bool pagination = false);
	~Container() override;

	static std::shared_ptr<Container> create(uint16_t type);
	static std::shared_ptr<Container> create(uint16_t type, uint16_t size, bool unlocked = true, bool pagination = false);

	/**
	 * @brief Creates a container for browse field functionality with items from a specified tile.
	 *
	 * This function generates a new container specifically for browse field use,
	 * populating it with items that meet certain criteria from the provided tile. Items
	 * that can be included must either have an internal container, be movable, or be
	 * wrapable without blocking path and without a unique ID.
	 *
	 * @param tile A shared pointer to the Tile from which items will be sourced.
	 * @return std::shared_ptr<Container> Returns a shared pointer to the newly created Container if successful; otherwise, returns nullptr.
	 *
	 * @note This function will return nullptr if the newContainer could not be created or if the tile pointer is null.
	 */
	static std::shared_ptr<Container> createBrowseField(const std::shared_ptr<Tile> &type);

	// non-copyable
	Container(const Container &) = delete;
	Container &operator=(const Container &) = delete;

	std::shared_ptr<Item> clone() const final;

	std::shared_ptr<Container> getContainer() final {
		return static_self_cast<Container>();
	}

	std::shared_ptr<const Container> getContainer() const final {
		return static_self_cast<Container>();
	}

	std::shared_ptr<Cylinder> getCylinder() final {
		return getContainer();
	}

	std::shared_ptr<Container> getRootContainer();

	virtual std::shared_ptr<DepotLocker> getDepotLocker() {
		return nullptr;
	}

	virtual std::shared_ptr<RewardChest> getRewardChest() {
		return nullptr;
	}

	virtual std::shared_ptr<Reward> getReward() {
		return nullptr;
	}
	virtual bool isInbox() const {
		return false;
	}
	virtual bool isDepotChest() const {
		return false;
	}

	Attr_ReadValue readAttr(AttrTypes_t attr, PropStream &propStream) override;
	bool unserializeItemNode(OTB::Loader &loader, const OTB::Node &node, PropStream &propStream, Position &itemPosition) override;
	std::string getContentDescription(bool sendColoredMessage);

	uint32_t getMaxCapacity() const;

	size_t size() const {
		return itemlist.size();
	}
	bool empty() const {
		return itemlist.empty();
	}
	uint32_t capacity() const {
		return maxSize;
	}

	ContainerIterator iterator();

	const ItemDeque &getItemList() const {
		return itemlist;
	}

	ItemDeque::const_reverse_iterator getReversedItems() const {
		return itemlist.rbegin();
	}
	ItemDeque::const_reverse_iterator getReversedEnd() const {
		return itemlist.rend();
	}

	bool countsToLootAnalyzerBalance() const;
	bool hasParent();
	void addItem(const std::shared_ptr<Item> &item);
	StashContainerList getStowableItems() const;
	bool isStoreInbox() const;
	bool isStoreInboxFiltered() const;
	std::deque<std::shared_ptr<Item>> getStoreInboxFilteredItems() const;
	std::vector<ContainerCategory_t> getStoreInboxValidCategories() const;
	std::shared_ptr<Item> getFilteredItemByIndex(size_t index) const;
	std::shared_ptr<Item> getItemByIndex(size_t index) const;
	bool isHoldingItem(const std::shared_ptr<Item> &item);
	bool isHoldingItemWithId(uint16_t id);

	uint32_t getItemHoldingCount();
	uint32_t getContainerHoldingCount();
	uint16_t getFreeSlots() const;
	uint32_t getWeight() const final;

	bool isUnlocked() const {
		return !this->isCorpse() && unlocked;
	}
	bool hasPagination() const {
		return pagination;
	}

	// cylinder implementations
	virtual ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;
	ReturnValue queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) final;
	ReturnValue queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;
	std::shared_ptr<Cylinder> queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item> &destItem, uint32_t &flags) final;

	void addThing(const std::shared_ptr<Thing> &thing) final;
	void addThing(int32_t index, const std::shared_ptr<Thing> &thing) final;
	void addItemBack(const std::shared_ptr<Item> &item);

	void updateThing(const std::shared_ptr<Thing> &thing, uint16_t itemId, uint32_t count) final;
	void replaceThing(uint32_t index, const std::shared_ptr<Thing> &thing) final;

	void removeThing(const std::shared_ptr<Thing> &thing, uint32_t count) final;

	int32_t getThingIndex(const std::shared_ptr<Thing> &thing) const final;
	size_t getFirstIndex() const final;
	size_t getLastIndex() const final;
	uint32_t getItemTypeCount(uint16_t itemId, int32_t subType = -1) const final;
	std::map<uint32_t, uint32_t> &getAllItemTypeCount(std::map<uint32_t, uint32_t> &countMap) const final;
	std::shared_ptr<Thing> getThing(size_t index) const final;

	ItemVector getItems(bool recursive = false);

	void postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
	void postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

	void internalAddThing(const std::shared_ptr<Thing> &thing) final;
	void internalAddThing(uint32_t index, const std::shared_ptr<Thing> &thing) final;

	virtual void removeItem(const std::shared_ptr<Thing> &thing, bool sendUpdateToClient = false);

	uint32_t getOwnerId() const final;

	bool isAnyKindOfRewardChest();
	bool isAnyKindOfRewardContainer();
	bool isBrowseFieldAndHoldsRewardChest();
	bool isInsideContainerWithId(uint16_t id);

protected:
	uint32_t m_maxItems {};
	uint32_t maxSize {};
	uint32_t totalWeight {};
	ItemDeque itemlist;
	uint32_t serializationCount = {};

	bool unlocked {};
	bool pagination {};

	friend class MapCache;

private:
	void onAddContainerItem(const std::shared_ptr<Item> &item);
	void onUpdateContainerItem(uint32_t index, const std::shared_ptr<Item> &oldItem, const std::shared_ptr<Item> &newItem);
	void onRemoveContainerItem(uint32_t index, const std::shared_ptr<Item> &item);

	std::shared_ptr<Container> getParentContainer();
	std::shared_ptr<Container> getTopParentContainer();
	void updateItemWeight(int32_t diff);

	friend class ContainerIterator;
	friend class IOMapSerialize;
};
