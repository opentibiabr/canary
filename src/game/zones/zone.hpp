/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_GAME_ZONE_ZONE_HPP_
#define SRC_GAME_ZONE_ZONE_HPP_

#include "game/movement/position.h"

class Tile;
class Creature;
class Monster;
class Player;
class Npc;
class Item;

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

class Zone {
	public:
		explicit Zone(const std::string &name) :
			name(name) { }

		// Deleted copy constructor and assignment operator.
		Zone(const Zone &) = delete;
		Zone &operator=(const Zone &) = delete;

		const std::string &getName() const {
			return name;
		}
		void addArea(Area area);
		bool isPositionInZone(const Position &position) const;

		const phmap::btree_set<Position> &getPositions() const;
		const phmap::parallel_flat_hash_set<Tile*> &getTiles() const;
		const phmap::parallel_flat_hash_set<Creature*> &getCreatures() const;
		const phmap::parallel_flat_hash_set<Player*> &getPlayers() const;
		const phmap::parallel_flat_hash_set<Monster*> &getMonsters() const;
		const phmap::parallel_flat_hash_set<Npc*> &getNpcs() const;
		const phmap::parallel_flat_hash_set<Item*> &getItems() const;

		void creatureAdded(Creature* creature);
		void creatureRemoved(Creature* creature);
		void itemAdded(Item* item);
		void itemRemoved(Item* item);

		void removeMonsters() const;
		void removeNpcs() const;

		const static std::shared_ptr<Zone> &addZone(const std::string &name);
		const static std::shared_ptr<Zone> &getZone(const std::string &name);
		static phmap::parallel_flat_hash_set<std::shared_ptr<Zone>> getZones(const Position &position);
		const static phmap::parallel_flat_hash_set<std::shared_ptr<Zone>> &getZones();
		static void clearZones();

	private:
		std::string name;
		phmap::btree_set<Position> positions;
		phmap::parallel_flat_hash_set<Tile*> tiles;
		phmap::parallel_flat_hash_set<Item*> items;
		phmap::parallel_flat_hash_set<Creature*> creatures;
		phmap::parallel_flat_hash_set<Monster*> monsters;
		phmap::parallel_flat_hash_set<Npc*> npcs;
		phmap::parallel_flat_hash_set<Player*> players;

		static std::mutex zonesMutex;
		static phmap::btree_map<std::string, std::shared_ptr<Zone>> zones;
};

#endif // SRC_GAME_ZONE_ZONE_HPP_
