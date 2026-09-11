#pragma once

#include "world/world_layers.hpp"

#include <unordered_set>

namespace world_layers {

	struct MapItem {
		uint64_t key = 0;
		uint16_t itemId = 0;
		uint16_t uid = 0;
		bool teleport = false;
		Position destination;
	};

	struct MapTile {
		bool exists = false;
		bool ground = false;
		bool house = false;
		bool blocked = false;
		std::vector<MapItem> items;
	};

	struct UniqueOccurrence {
		uint16_t uid = 0;
		uint64_t key = 0;
		Position position;
	};

	// All calls are synchronous snapshots; keys identify items only during validation.
	class MapView {
	public:
		virtual ~MapView() = default;
		virtual bool nativeTeleport(uint16_t itemId) const = 0;
		virtual MapTile tile(const Position &position) = 0;
		virtual std::vector<UniqueOccurrence> uniqueIds(const std::unordered_set<uint16_t> &requested) = 0;
	};

	struct ResolvedObject {
		std::string id;
		uint64_t original = 0;
		std::optional<Position> destination;
	};

	struct ApplicationPlan {
		std::vector<ResolvedObject> objects;
		std::unordered_set<uint64_t> originals;
	};

	bool validateMap(const Project &project, MapView &map, ApplicationPlan &plan, Diagnostics &diagnostics);

} // namespace world_layers
