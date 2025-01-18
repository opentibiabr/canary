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

class Creature;
class Teleport;
class TrashHolder;
class Mailbox;
class MagicField;
class BedItem;
class House;
class Zone;
class Cylinder;
class Item;
class ItemType;

using CreatureVector = std::vector<std::shared_ptr<Creature>>;
using ItemVector = std::vector<std::shared_ptr<Item>>;

class TileItemVector : private ItemVector {
public:
	using ItemVector::at;
	using ItemVector::begin;
	using ItemVector::clear;
	using ItemVector::const_iterator;
	using ItemVector::const_reverse_iterator;
	using ItemVector::empty;
	using ItemVector::end;
	using ItemVector::erase;
	using ItemVector::insert;
	using ItemVector::iterator;
	using ItemVector::push_back;
	using ItemVector::rbegin;
	using ItemVector::rend;
	using ItemVector::reverse_iterator;
	using ItemVector::size;
	using ItemVector::value_type;

	iterator getBeginDownItem() {
		return begin();
	}
	const_iterator getBeginDownItem() const {
		return begin();
	}
	iterator getEndDownItem() {
		return begin() + downItemCount;
	}
	const_iterator getEndDownItem() const {
		return begin() + downItemCount;
	}
	iterator getBeginTopItem() {
		return getEndDownItem();
	}
	const_iterator getBeginTopItem() const {
		return getEndDownItem();
	}
	iterator getEndTopItem() {
		return end();
	}
	const_iterator getEndTopItem() const {
		return end();
	}

	uint32_t getTopItemCount() const {
		return size() - downItemCount;
	}
	uint32_t getDownItemCount() const {
		return downItemCount;
	}
	inline std::shared_ptr<Item> getTopTopItem() const {
		if (getTopItemCount() == 0) {
			return nullptr;
		}
		return *(getEndTopItem() - 1);
	}
	inline std::shared_ptr<Item> getTopDownItem() const {
		if (downItemCount == 0) {
			return nullptr;
		}
		return *getBeginDownItem();
	}
	void increaseDownItemCount() {
		downItemCount += 1;
	}
	void decreaseDownItemCount() {
		downItemCount -= 1;
	}

private:
	uint32_t downItemCount = 0;
};

class Tile : public Cylinder, public SharedObject {
public:
	static const std::shared_ptr<Tile> &nullptr_tile;
	Tile(uint16_t x, uint16_t y, uint8_t z) :
		tilePos(x, y, z) { }
	~Tile() override = default;

	// non-copyable
	Tile(const Tile &) = delete;
	Tile &operator=(const Tile &) = delete;

	virtual TileItemVector* getItemList() = 0;
	virtual const TileItemVector* getItemList() const = 0;
	virtual TileItemVector* makeItemList() = 0;

	virtual CreatureVector* getCreatures() = 0;
	virtual const CreatureVector* getCreatures() const = 0;
	virtual CreatureVector* makeCreatures() = 0;
	virtual std::shared_ptr<House> getHouse() {
		return nullptr;
	}

	int32_t getThrowRange() const final {
		return 0;
	}
	bool isPushable() final {
		return false;
	}

	std::shared_ptr<Tile> getTile() final {
		return static_self_cast<Tile>();
	}

	std::shared_ptr<Cylinder> getCylinder() final {
		return getTile();
	}

	std::shared_ptr<MagicField> getFieldItem() const;
	std::shared_ptr<Teleport> getTeleportItem() const;
	std::shared_ptr<TrashHolder> getTrashHolder() const;
	std::shared_ptr<Mailbox> getMailbox() const;
	std::shared_ptr<BedItem> getBedItem() const;

	std::shared_ptr<Creature> getTopCreature() const;
	std::shared_ptr<Creature> getBottomCreature() const;
	std::shared_ptr<Creature> getTopVisibleCreature(const std::shared_ptr<Creature> &creature) const;

	std::shared_ptr<Creature> getBottomVisibleCreature(const std::shared_ptr<Creature> &creature) const;
	std::shared_ptr<Item> getTopTopItem() const;
	std::shared_ptr<Item> getTopDownItem() const;
	bool isMovableBlocking() const;
	std::shared_ptr<Thing> getTopVisibleThing(const std::shared_ptr<Creature> &creature);
	std::shared_ptr<Item> getItemByTopOrder(int32_t topOrder);

	size_t getThingCount() const {
		size_t thingCount = getCreatureCount() + getItemCount();
		if (ground) {
			thingCount++;
		}
		return thingCount;
	}
	// If these return != 0 the associated vectors are guaranteed to exists
	size_t getCreatureCount() const;
	size_t getItemCount() const;
	uint32_t getTopItemCount() const;
	uint32_t getDownItemCount() const;

	bool hasProperty(ItemProperty prop) const;
	bool hasProperty(const std::shared_ptr<Item> &exclude, ItemProperty prop) const;

	bool hasFlag(uint32_t flag) const;
	void setFlag(uint32_t flag) {
		this->flags |= flag;
	}
	void resetFlag(uint32_t flag) {
		this->flags &= ~flag;
	}
	void addZone(const std::shared_ptr<Zone> &zone);
	void clearZones();

	auto getZones() const {
		return zones;
	}

	ZoneType_t getZoneType() const {
		if (hasFlag(TILESTATE_PROTECTIONZONE)) {
			return ZONE_PROTECTION;
		} else if (hasFlag(TILESTATE_NOPVPZONE)) {
			return ZONE_NOPVP;
		} else if (hasFlag(TILESTATE_PVPZONE)) {
			return ZONE_PVP;
		} else if (hasFlag(TILESTATE_NOLOGOUT)) {
			return ZONE_NOLOGOUT;
		}
		return ZONE_NORMAL;
	}

	bool hasHeight(uint32_t n) const;

	std::string getDescription(int32_t lookDistance) final;

	int32_t getClientIndexOfCreature(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &creature) const;
	int32_t getStackposOfCreature(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &creature) const;
	int32_t getStackposOfItem(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item) const;

	// cylinder implementations
	ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;
	ReturnValue queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) final;
	ReturnValue queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t tileFlags, const std::shared_ptr<Creature> &actor = nullptr) override;
	std::shared_ptr<Cylinder> queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item> &destItem, uint32_t &flags) override;

	std::vector<std::shared_ptr<Tile>> getSurroundingTiles();

	void addThing(const std::shared_ptr<Thing> &thing) final;
	void addThing(int32_t index, const std::shared_ptr<Thing> &thing) override;

	void updateTileFlags(const std::shared_ptr<Item> &item);
	void updateThing(const std::shared_ptr<Thing> &thing, uint16_t itemId, uint32_t count) final;
	void replaceThing(uint32_t index, const std::shared_ptr<Thing> &thing) final;

	void removeThing(const std::shared_ptr<Thing> &thing, uint32_t count) final;

	void removeCreature(const std::shared_ptr<Creature> &creature);

	int32_t getThingIndex(const std::shared_ptr<Thing> &thing) const final;
	size_t getFirstIndex() const final;
	size_t getLastIndex() const final;
	uint32_t getItemTypeCount(uint16_t itemId, int32_t subType = -1) const final;
	std::shared_ptr<Thing> getThing(size_t index) const final;

	void postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) final;
	void postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t link = LINK_OWNER) final;

	void internalAddThing(const std::shared_ptr<Thing> &thing) override;
	void internalAddThing(uint32_t index, const std::shared_ptr<Thing> &thing) override;

	const Position &getPosition() final {
		return tilePos;
	}

	bool isRemoved() final {
		return false;
	}

	std::shared_ptr<Item> getUseItem(int32_t index) const;
	std::shared_ptr<Item> getDoorItem() const;

	std::shared_ptr<Item> getGround() const {
		return ground;
	}
	void setGround(const std::shared_ptr<Item> &item) {
		if (ground) {
			resetTileFlags(ground);
		}

		if ((ground = item)) {
			setTileFlags(item);
		}
	}

	// This method maintains safety in asynchronous calls, avoiding competition between threads.
	void safeCall(std::function<void(void)> &&action) const;

private:
	void onAddTileItem(const std::shared_ptr<Item> &item);
	void onUpdateTileItem(const std::shared_ptr<Item> &oldItem, const ItemType &oldType, const std::shared_ptr<Item> &newItem, const ItemType &newType);
	void onRemoveTileItem(const CreatureVector &spectators, const std::vector<int32_t> &oldStackPosVector, const std::shared_ptr<Item> &item);
	void onUpdateTile(const CreatureVector &spectators);

	void setTileFlags(const std::shared_ptr<Item> &item);
	void resetTileFlags(const std::shared_ptr<Item> &item);
	bool hasHarmfulField() const;
	ReturnValue checkNpcCanWalkIntoTile() const;

protected:
	std::shared_ptr<Item> ground = nullptr;
	Position tilePos;
	uint32_t flags = 0;
	std::unordered_set<std::shared_ptr<Zone>> zones {};
};

// Used for walkable tiles, where there is high likeliness of
// items being added/removed
class DynamicTile : public Tile {
	// By allocating the vectors in-house, we avoid some memory fragmentation
	TileItemVector items;
	CreatureVector creatures;

public:
	explicit DynamicTile(const Position &position) :
		Tile(position.x, position.y, position.z) { }
	DynamicTile(uint16_t x, uint16_t y, uint8_t z) :
		Tile(x, y, z) { }

	// non-copyable
	DynamicTile(const DynamicTile &) = delete;
	DynamicTile &operator=(const DynamicTile &) = delete;

	TileItemVector* getItemList() override {
		return &items;
	}
	const TileItemVector* getItemList() const override {
		return &items;
	}
	TileItemVector* makeItemList() override {
		return &items;
	}

	CreatureVector* getCreatures() override {
		return &creatures;
	}
	const CreatureVector* getCreatures() const override {
		return &creatures;
	}
	CreatureVector* makeCreatures() override {
		return &creatures;
	}
};

// For blocking tiles, where we very rarely actually have items
class StaticTile final : public Tile {
	// We very rarely even need the vectors, so don't keep them in memory
	std::unique_ptr<TileItemVector> items;
	std::unique_ptr<CreatureVector> creatures;

public:
	explicit StaticTile(const Position &position) :
		Tile(position.x, position.y, position.z) { }
	StaticTile(uint16_t x, uint16_t y, uint8_t z) :
		Tile(x, y, z) { }

	// non-copyable
	StaticTile(const StaticTile &) = delete;
	StaticTile &operator=(const StaticTile &) = delete;

	TileItemVector* getItemList() override {
		return items.get();
	}
	const TileItemVector* getItemList() const override {
		return items.get();
	}
	TileItemVector* makeItemList() override {
		if (!items) {
			items = std::make_unique<TileItemVector>();
		}
		return items.get();
	}

	CreatureVector* getCreatures() override {
		return creatures.get();
	}
	const CreatureVector* getCreatures() const override {
		return creatures.get();
	}
	CreatureVector* makeCreatures() override {
		if (!creatures) {
			creatures = std::make_unique<CreatureVector>();
		}
		return creatures.get();
	}
};
