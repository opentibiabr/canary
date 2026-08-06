/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Creature;
class Player;
class Monster;
class Npc;
struct Position;

// Forward declaration para CreatureVector
using CreatureVector = std::vector<std::shared_ptr<Creature>>;

struct SpectatorsCache {
	struct FloorData {
		std::optional<CreatureVector> floor;
		std::optional<CreatureVector> multiFloor;
	};

	int32_t minRangeX { 0 };
	int32_t maxRangeX { 0 };
	int32_t minRangeY { 0 };
	int32_t maxRangeY { 0 };

	FloorData creatures;
	FloorData monsters;
	FloorData npcs;
	FloorData players;
};

class Spectators {
public:
	static void clearCache();

	template <typename T>
		requires std::is_base_of_v<Creature, T>
	Spectators find(const Position &centerPos, bool multifloor = false, int32_t minRangeX = 0, int32_t maxRangeX = 0, int32_t minRangeY = 0, int32_t maxRangeY = 0, bool useCache = true) {
		constexpr bool onlyPlayers = std::is_same_v<T, Player>;
		constexpr bool onlyMonsters = std::is_same_v<T, Monster>;
		constexpr bool onlyNpcs = std::is_same_v<T, Npc>;
		return find(centerPos, multifloor, onlyPlayers, onlyMonsters, onlyNpcs, minRangeX, maxRangeX, minRangeY, maxRangeY, useCache);
	}

	template <typename T>
		requires std::is_base_of_v<Creature, T>
	Spectators filter() const {
		constexpr bool onlyPlayers = std::is_same_v<T, Player>;
		constexpr bool onlyMonsters = std::is_same_v<T, Monster>;
		constexpr bool onlyNpcs = std::is_same_v<T, Npc>;
		return filter(onlyPlayers, onlyMonsters, onlyNpcs);
	}

	Spectators excludeMaster() const;
	Spectators excludePlayerMaster() const;

	/**
	 * Adds a strong spectator reference to this snapshot.
	 *
	 * Spectator snapshots own `shared_ptr<Creature>` entries so immediate
	 * fanout code may derive short-lived raw type views from them without
	 * risking dangling spectators.
	 */
	Spectators &insert(const std::shared_ptr<Creature> &creature);
	/**
	 * Appends a spectator list by copying strong references.
	 *
	 * Use this overload for cached or shared lists that must remain intact
	 * after insertion.
	 */
	Spectators &insertAll(const CreatureVector &list);
	/**
	 * Appends a freshly built spectator list by moving strong references.
	 *
	 * This avoids extra refcount churn for temporary snapshots while preserving
	 * the same ownership contract: stored spectators are still `shared_ptr`
	 * entries, not borrowed raw pointers.
	 */
	Spectators &insertAll(CreatureVector &&list);
	Spectators join(const Spectators &anotherSpectators) {
		return insertAll(anotherSpectators.creatures);
	}

	bool contains(const std::shared_ptr<Creature> &creature) const {
		return std::ranges::find(creatures, creature) != creatures.end();
	}

	bool erase(const std::shared_ptr<Creature> &creature) {
		return std::erase(creatures, creature) > 0;
	}

	bool empty() const noexcept {
		return creatures.empty();
	}

	size_t size() const noexcept {
		return creatures.size();
	}

	auto begin() const noexcept {
		return creatures.begin();
	}

	auto end() const noexcept {
		return creatures.end();
	}

	const auto &data() const noexcept {
		return creatures;
	}

private:
	static phmap::flat_hash_map<Position, SpectatorsCache> spectatorsCache;

	Spectators find(const Position &centerPos, bool multifloor = false, bool onlyPlayers = false, bool onlyMonsters = false, bool onlyNpcs = false, int32_t minRangeX = 0, int32_t maxRangeX = 0, int32_t minRangeY = 0, int32_t maxRangeY = 0, bool useCache = true);
	CreatureVector getSpectators(const Position &centerPos, bool multifloor = false, bool onlyPlayers = false, bool onlyMonsters = false, bool onlyNpcs = false, int32_t minRangeX = 0, int32_t maxRangeX = 0, int32_t minRangeY = 0, int32_t maxRangeY = 0);

	Spectators filter(bool onlyPlayers, bool onlyMonsters, bool onlyNpcs) const;

	bool checkCache(const SpectatorsCache::FloorData &specData, bool onlyPlayers, bool onlyMonsters, bool onlyNpcs, const Position &centerPos, bool checkDistance, bool multifloor, int32_t minRangeX, int32_t maxRangeX, int32_t minRangeY, int32_t maxRangeY);

	CreatureVector creatures;
};
