/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_MAP_MAP_H_
#define SRC_MAP_MAP_H_

#include "game/movement/position.h"
#include "items/item.h"
#include "items/tile.h"
#include "map/town.h"
#include "map/house/house.h"
#include "creatures/monsters/spawns/spawn_monster.h"
#include "creatures/npcs/spawns/spawn_npc.h"

class Creature;
class Player;
class Game;
class Tile;
class Map;

static constexpr int8_t MAP_MAX_LAYERS = 16;
static constexpr int8_t MAP_INIT_SURFACE_LAYER = 7; // (MAP_MAX_LAYERS / 2) -1
static constexpr int8_t MAP_LAYER_VIEW_LIMIT = 2;

struct FindPathParams;
struct AStarNode {
		AStarNode* parent;
		int_fast32_t f;
		uint16_t x, y;
};

static constexpr int32_t MAX_NODES = 512;

static constexpr int32_t MAP_NORMALWALKCOST = 10;
static constexpr int32_t MAP_PREFERDIAGONALWALKCOST = 14;
static constexpr int32_t MAP_DIAGONALWALKCOST = 25;

class AStarNodes {
	public:
		AStarNodes(uint32_t x, uint32_t y);

		AStarNode* createOpenNode(AStarNode* parent, uint32_t x, uint32_t y, int_fast32_t f);
		AStarNode* getBestNode();
		void closeNode(AStarNode* node);
		void openNode(AStarNode* node);
		int_fast32_t getClosedNodes() const;
		AStarNode* getNodeByPosition(uint32_t x, uint32_t y);

		static int_fast32_t getMapWalkCost(AStarNode* node, const Position &neighborPos, bool preferDiagonal = false);
		static int_fast32_t getTileWalkCost(const Creature &creature, const Tile* tile);

	private:
		AStarNode nodes[MAX_NODES];
		bool openNodes[MAX_NODES];
		phmap::flat_hash_map<uint32_t, AStarNode*> nodeTable;
		size_t curNode;
		int_fast32_t closedNodes;
};

using SpectatorCache = std::map<Position, SpectatorHashSet>;

static constexpr int32_t FLOOR_BITS = 3;
static constexpr int32_t FLOOR_SIZE = (1 << FLOOR_BITS);
static constexpr int32_t FLOOR_MASK = (FLOOR_SIZE - 1);

struct Floor {
		constexpr Floor() = default;
		~Floor();

		// non-copyable
		Floor(const Floor &) = delete;
		Floor &operator=(const Floor &) = delete;

		Tile* tiles[FLOOR_SIZE][FLOOR_SIZE] = {};
};

class FrozenPathingConditionCall;
class QTreeLeafNode;

class QTreeNode {
	public:
		constexpr QTreeNode() = default;
		virtual ~QTreeNode();

		// non-copyable
		QTreeNode(const QTreeNode &) = delete;
		QTreeNode &operator=(const QTreeNode &) = delete;

		bool isLeaf() const {
			return leaf;
		}

		QTreeLeafNode* getLeaf(uint32_t x, uint32_t y);

		template <typename Leaf, typename Node>
		static Leaf getLeafStatic(Node node, uint32_t x, uint32_t y) {
			do {
				node = node->child[((x & 0x8000) >> 15) | ((y & 0x8000) >> 14)];
				if (!node) {
					return nullptr;
				}

				x <<= 1;
				y <<= 1;
			} while (!node->leaf);
			return static_cast<Leaf>(node);
		}

		QTreeLeafNode* createLeaf(uint32_t x, uint32_t y, uint32_t level);

	protected:
		QTreeNode* child[4] = {};

		bool leaf = false;

		friend class Map;
};

class QTreeLeafNode final : public QTreeNode {
	public:
		QTreeLeafNode() {
			leaf = true;
			newLeaf = true;
		}
		~QTreeLeafNode();

		// non-copyable
		QTreeLeafNode(const QTreeLeafNode &) = delete;
		QTreeLeafNode &operator=(const QTreeLeafNode &) = delete;

		Floor* createFloor(uint32_t z);
		Floor* getFloor(uint8_t z) const {
			return array[z];
		}

		void addCreature(Creature* c);
		void removeCreature(Creature* c);

	private:
		static bool newLeaf;
		QTreeLeafNode* leafS = nullptr;
		QTreeLeafNode* leafE = nullptr;
		Floor* array[MAP_MAX_LAYERS] = {};
		CreatureVector creature_list;
		CreatureVector player_list;

		friend class Map;
		friend class QTreeNode;
};

/**
 * Map class.
 * Holds all the actual map-data
 */

class Map {
	public:
		static constexpr int32_t maxClientViewportX = 8;
		static constexpr int32_t maxClientViewportY = 6;
		static constexpr int32_t maxViewportX = maxClientViewportX + 3; // min value: maxClientViewportX + 1
		static constexpr int32_t maxViewportY = maxClientViewportY + 5; // min value: maxClientViewportY + 1

		uint32_t clean() const;

		/**
		 * Load a map.
		 * \returns true if the map was loaded successfully
		 */
		bool load(const std::string &identifier, const Position &pos = Position(), bool unload = false);
		/**
		 * Load the main map
		 * \param identifier Is the main map name (name of file .otbm)
		 * \param loadHouses if true, the main map houses is loaded
		 * \param loadMonsters if true, the main map monsters is loaded
		 * \param loadNpcs if true, the main map npcs is loaded
		 * \returns true if the main map was loaded successfully
		 */
		bool loadMap(const std::string &identifier, bool mainMap = false, bool loadHouses = false, bool loadMonsters = false, bool loadNpcs = false, const Position &pos = Position(), bool unload = false);
		/**
		 * Load the custom map
		 * \param identifier Is the map custom folder
		 * \param loadHouses if true, the map custom houses is loaded
		 * \param loadMonsters if true, the map custom monsters is loaded
		 * \param loadNpcs if true, the map custom npcs is loaded
		 * \returns true if the custom map was loaded successfully
		 */
		bool loadMapCustom(const std::string &identifier, bool loadHouses, bool loadMonsters, bool loadNpcs);

		/**
		 * Save a map.
		 * \returns true if the map was saved successfully
		 */
		static bool save();

		/**
		 * Get a single tile.
		 * \returns A pointer to that tile.
		 */
		Tile* getTile(uint16_t x, uint16_t y, uint8_t z) const;
		Tile* getTile(const Position &pos) const {
			return getTile(pos.x, pos.y, pos.z);
		}

		/**
		 * Set a single tile.
		 */
		void setTile(uint16_t x, uint16_t y, uint8_t z, Tile* newTile);
		void setTile(const Position &pos, Tile* newTile) {
			setTile(pos.x, pos.y, pos.z, newTile);
		}

		/**
		 * Place a creature on the map
		 * \param centerPos The position to place the creature
		 * \param creature Creature to place on the map
		 * \param extendedPos If true, the creature will in first-hand be placed 2 tiles away
		 * \param forceLogin If true, placing the creature will not fail becase of obstacles (creatures/chests)
		 */
		bool placeCreature(const Position &centerPos, Creature* creature, bool extendedPos = false, bool forceLogin = false);

		void moveCreature(Creature &creature, Tile &newTile, bool forceTeleport = false);

		void getSpectators(SpectatorHashSet &spectators, const Position &centerPos, bool multifloor = false, bool onlyPlayers = false, int32_t minRangeX = 0, int32_t maxRangeX = 0, int32_t minRangeY = 0, int32_t maxRangeY = 0);

		void clearSpectatorCache();

		/**
		 * Checks if you can throw an object to that position
		 *	\param fromPos from Source point
		 *	\param toPos Destination point
		 *	\param rangex maximum allowed range horizontially
		 *	\param rangey maximum allowed range vertically
		 *	\param checkLineOfSight checks if there is any blocking objects in the way
		 *	\returns The result if you can throw there or not
		 */
		bool canThrowObjectTo(const Position &fromPos, const Position &toPos, bool checkLineOfSight = true, int32_t rangex = Map::maxClientViewportX, int32_t rangey = Map::maxClientViewportY) const;

		/**
		 * Checks if path is clear from fromPos to toPos
		 * Notice: This only checks a straight line if the path is clear, for path finding use getPathTo.
		 *	\param fromPos from Source point
		 *	\param toPos Destination point
		 *	\param floorCheck if true then view is not clear if fromPos.z is not the same as toPos.z
		 *	\returns The result if there is no obstacles
		 */
		bool isSightClear(const Position &fromPos, const Position &toPos, bool floorCheck) const;
		bool checkSightLine(const Position &fromPos, const Position &toPos) const;

		const Tile* canWalkTo(const Creature &creature, const Position &pos) const;

		bool getPathMatching(const Creature &creature, std::forward_list<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp) const;

		bool getPathMatching(const Position &startPos, std::forward_list<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp) const;

		std::map<std::string, Position> waypoints;

		QTreeLeafNode* getQTNode(uint16_t x, uint16_t y) {
			return QTreeNode::getLeafStatic<QTreeLeafNode*, QTreeNode*>(&root, x, y);
		}

		// Storage made by "loadFromXML" of houses, monsters and npcs for main map
		SpawnsMonster spawnsMonster;
		SpawnsNpc spawnsNpc;
		Towns towns;
		Houses houses;

		// Storage made by "loadFromXML" of houses, monsters and npcs for custom map
		SpawnsMonster spawnsMonsterCustom;
		SpawnsNpc spawnsNpcCustom;
		Houses housesCustom;

	private:
		SpectatorCache spectatorCache;
		SpectatorCache playersSpectatorCache;

		QTreeNode root;

		std::string monsterfile;
		std::string housefile;
		std::string npcfile;

		uint32_t width = 0;
		uint32_t height = 0;

		// Actually scans the map for spectators
		void getSpectatorsInternal(SpectatorHashSet &spectators, const Position &centerPos, int32_t minRangeX, int32_t maxRangeX, int32_t minRangeY, int32_t maxRangeY, int32_t minRangeZ, int32_t maxRangeZ, bool onlyPlayers) const;

		friend class Game;
		friend class IOMap;
};

#endif // SRC_MAP_MAP_H_
