/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/movement/position.hpp"
#include "items/item.hpp"
#include "creatures/creature.hpp"

class Tile;
class Creature;
class Monster;
class Player;
class Npc;
class Item;
class Thing;

struct Area {
	constexpr Area() = default;
	constexpr Area(Position from, Position to) :
		from(from), to(to) { }

	static bool intersects(Area a, Area b) {
		return a.from.x <= b.to.x && a.to.x >= b.from.x && a.from.y <= b.to.y && a.to.y >= b.from.y && a.from.z <= b.to.z && a.to.z >= b.from.z;
	}

	bool intersects(Area other) const {
		return intersects(*this, other);
	}

	bool contains(Position position) const {
		return position.x >= from.x && position.x <= to.x && position.y >= from.y && position.y <= to.y && position.z >= from.z && position.z <= to.z;
	}

	Position from;
	Position to;

	std::string toString() const {
		return fmt::format("Area(from: {}, to: {})", from.toString(), to.toString());
	}

	class PositionIterator {
	public:
		PositionIterator(Position startPosition, const Area &refArea) :
			currentPosition(startPosition), area(refArea) { }

		const Position &operator*() const {
			return currentPosition;
		}
		PositionIterator &operator++() {
			currentPosition.x++;
			if (currentPosition.x > area.to.x) {
				currentPosition.x = area.from.x;
				currentPosition.y++;
				if (currentPosition.y > area.to.y) {
					currentPosition.y = area.from.y;
					currentPosition.z++;
				}
			}
			return *this;
		}
		bool operator!=(const PositionIterator &other) const {
			return !(currentPosition == other.currentPosition);
		}

	private:
		Position currentPosition;
		const Area &area;
	};

	PositionIterator begin() const {
		return PositionIterator(from, *this);
	}

	PositionIterator end() const {
		Position endPosition(from.x, from.y, to.z + 1); // z is incremented so it's past the last valid position.
		return PositionIterator(endPosition, *this);
	}
};

namespace weak {
	template <typename T>
	struct ThingHasher {
		std::size_t operator()(std::weak_ptr<T> thing) const {
			if (thing.expired()) {
				return 0;
			}
			return std::hash<void*> {}(thing.lock().get());
		}
	};

	template <typename T>
	struct ThingComparator {
		bool operator()(const std::weak_ptr<T> &lhs, const std::weak_ptr<T> &rhs) const {
			return lhs.lock() == rhs.lock();
		}
	};

	template <>
	struct ThingHasher<Creature> {
		std::size_t operator()(const std::weak_ptr<Creature> &weakCreature) const {
			auto locked = weakCreature.lock();
			if (!locked) {
				return 0;
			}
			return std::hash<uint32_t> {}(locked->getID());
		}
	};

	template <>
	struct ThingComparator<Creature> {
		bool operator()(const std::weak_ptr<Creature> &lhs, const std::weak_ptr<Creature> &rhs) const {
			if (lhs.expired() || rhs.expired()) {
				return false;
			}
			return lhs.lock()->getID() == rhs.lock()->getID();
		}
	};

	template <typename T>
	using set = std::unordered_set<std::weak_ptr<T>, ThingHasher<T>, ThingComparator<T>>;

	template <typename T>
	std::vector<std::shared_ptr<T>> lock(set<T> &weakSet) {
		std::vector<std::shared_ptr<T>> result;
		for (auto it = weakSet.begin(); it != weakSet.end();) {
			if (it->expired()) {
				it = weakSet.erase(it);
			} else {
				result.push_back(it->lock());
				++it;
			}
		}
		return result;
	}
}

class Zone {
public:
	explicit Zone(std::string name, uint32_t id = 0) :
		name(std::move(name)), id(id) { }
	explicit Zone(uint32_t id) :
		id(id) { }

	// Deleted copy constructor and assignment operator.
	Zone(const Zone &) = delete;
	Zone &operator=(const Zone &) = delete;

	const std::string &getName() const {
		return name;
	}
	void addArea(Area area);
	void subtractArea(Area area);
	void addPosition(const Position &position) {
		positions.emplace(position);
	}
	void removePosition(const Position &position) {
		positions.erase(position);
	}
	Position getRemoveDestination(const std::shared_ptr<Creature> &creature = nullptr) const;
	void setRemoveDestination(const Position &position) {
		removeDestination = position;
	}

	std::vector<Position> getPositions() const;
	std::vector<std::shared_ptr<Creature>> getCreatures();
	std::vector<std::shared_ptr<Player>> getPlayers();
	std::vector<std::shared_ptr<Monster>> getMonsters();
	std::vector<std::shared_ptr<Npc>> getNpcs();
	std::vector<std::shared_ptr<Item>> getItems();

	void creatureAdded(const std::shared_ptr<Creature> &creature);
	void creatureRemoved(const std::shared_ptr<Creature> &creature);
	void thingAdded(const std::shared_ptr<Thing> &thing);
	void itemAdded(const std::shared_ptr<Item> &item);
	void itemRemoved(const std::shared_ptr<Item> &item);

	void removePlayers();
	void removeMonsters();
	void removeNpcs();

	void refresh();

	void setMonsterVariant(const std::string &variant);
	const std::string &getMonsterVariant() const {
		return monsterVariant;
	}

	bool isStatic() const {
		return id != 0;
	}

	static std::shared_ptr<Zone> addZone(const std::string &name, uint32_t id = 0);
	static std::shared_ptr<Zone> getZone(const std::string &name);
	static std::shared_ptr<Zone> getZone(uint32_t id);
	static std::vector<std::shared_ptr<Zone>> getZones(Position position);
	static std::vector<std::shared_ptr<Zone>> getZones();
	static void refreshAll() {
		for (const auto &[_, zone] : zones) {
			zone->refresh();
		}
	}
	static void clearZones();

	static bool loadFromXML(const std::string &fileName, uint16_t shiftID = 0);

protected:
	bool contains(const Position &position) const;

	Position removeDestination = Position();
	std::string name;
	std::string monsterVariant;
	phmap::flat_hash_set<Position> positions;
	uint32_t id = 0; // ID 0 is used in zones created dynamically from lua. The map editor uses IDs starting from 1 (automatically generated).

	weak::set<Item> itemsCache;
	weak::set<Creature> creaturesCache;
	weak::set<Monster> monstersCache;
	weak::set<Npc> npcsCache;
	weak::set<Player> playersCache;

	static phmap::parallel_flat_hash_map<std::string, std::shared_ptr<Zone>> zones;
	static phmap::parallel_flat_hash_map<uint32_t, std::shared_ptr<Zone>> zonesByID;
};
