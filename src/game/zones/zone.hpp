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
};

class Zone {
	public:
		Zone(const std::string &name) :
			name(name) { }

		// Deleted copy constructor and assignment operator.
		Zone(const Zone &) = delete;
		Zone &operator=(const Zone &) = delete;

		std::vector<Area> getAreas() const {
			return areas;
		}

		const std::string &getName() const {
			return name;
		}
		void addArea(Area area);
		bool isPositionInZone(const Position &position) const;

		phmap::btree_set<Position> getPositions() const;
		phmap::btree_set<Tile*> getTiles() const;
		phmap::btree_set<Creature*> getCreatures() const;
		phmap::btree_set<Player*> getPlayers() const;
		phmap::btree_set<Monster*> getMonsters() const;
		phmap::btree_set<Npc*> getNpcs() const;
		phmap::btree_set<Item*> getItems() const;

		void removeMonsters();
		void removeNpcs();

		static std::shared_ptr<Zone> addZone(const std::string &name);
		static std::shared_ptr<Zone> getZone(const std::string &name);
		static std::shared_ptr<Zone> getZone(const Position &position);
		static void clearZones();

	private:
		std::string name;
		std::vector<Area> areas = {};

		static phmap::btree_map<std::string, std::shared_ptr<Zone>> zones;
};

#endif // SRC_GAME_ZONE_ZONE_HPP_
