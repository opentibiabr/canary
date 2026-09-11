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
		uint16_t aid = 0;
		bool ground = false;
		bool container = false;
		Value::Record attributes;
		std::vector<MapItem> children;
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
		virtual bool knownItem(uint16_t itemId) const;
		virtual bool capability(uint16_t itemId, const std::string &name) const;
		virtual MapTile tile(const Position &position) = 0;
		// Runtime selection reads the captured OTBM, before startup/persistence.
		virtual MapTile selectionTile(const Position &position);
		virtual uint16_t effectiveUid(const MapItem &original);
		// An empty request returns the complete UID census, including containers.
		virtual std::vector<UniqueOccurrence> uniqueIds(const std::unordered_set<uint16_t> &requested) = 0;
	};

	struct ResolvedObject {
		std::string id;
		uint64_t original = 0;
		std::optional<Position> destination;
		Position position;
		uint16_t effectiveUid = 0;
	};

	struct ApplicationPlan {
		std::vector<ResolvedObject> objects;
		std::unordered_set<uint64_t> originals;
	};

	bool validateMap(const Project &project, MapView &map, ApplicationPlan &plan, Diagnostics &diagnostics);
	bool validateMapV2(const Project &project, MapView &map, ApplicationPlan &plan, Diagnostics &diagnostics);
	std::string selectorFingerprint(const std::vector<MapItem> &items);
	bool resolveSelector(const Selector &selector, const std::vector<MapItem> &candidates, MapItem &selected, std::string &error);
	bool captureSelector(Selector &selector, const std::vector<MapItem> &candidates, uint64_t key, std::string &error);

} // namespace world_layers
