#include "world/world_validation.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <map>
	#include <set>
	#include <tuple>
#endif

namespace world_layers {
	namespace {
		auto validationKey(const Position &position) {
			return std::tuple(position.x, position.y, position.z);
		}
	}

	bool validateMap(const Project &project, MapView &map, ApplicationPlan &plan, Diagnostics &diagnostics) {
		if (project.schemaVersion == 2) {
			return validateMapV2(project, map, plan, diagnostics);
		}
		const auto initialErrors = diagnostics.size();
		validateProject(project, diagnostics);
		if (diagnostics.size() != initialErrors) {
			return false;
		}
		ApplicationPlan resolved;
		std::unordered_set<uint16_t> requested;
		std::map<std::tuple<int32_t, int32_t, int32_t>, const Object*> external;
		const auto fail = [&](const Layer &layer, const Object &object, const std::string &field, const std::string &message) {
			diagnostics.push_back({ layer.file, layer.id + "." + object.id, field, message });
		};
		for (const auto &layer : project.layers) {
			for (const auto &object : layer.objects) {
				ResolvedObject entry { layer.id + "." + object.id, 0, destination(project, object) };
				external.emplace(validationKey(object.position), &object);
				if (!map.nativeTeleport(object.itemId)) {
					fail(layer, object, "/origin/itemId", "Version 1 requires a native teleport item");
				}
				if (object.uid) {
					requested.insert(object.uid);
				}
				if (object.replaces) {
					const auto tile = map.tile(object.replaces->position);
					const auto matches = std::count_if(tile.items.begin(), tile.items.end(), [&](const auto &item) { return item.itemId == object.replaces->itemId; });
					if (!tile.exists || tile.house || matches != 1) {
						fail(layer, object, "/origin/replaces", "Expected exactly one original item on a non-house tile; found " + std::to_string(matches));
					} else {
						const auto it = std::find_if(tile.items.begin(), tile.items.end(), [&](const auto &item) { return item.itemId == object.replaces->itemId; });
						if (!it->teleport) {
							fail(layer, object, "/origin/replaces", "Version 1 only replaces native teleport items");
						}
						entry.original = it->key;
						if (!entry.original || !resolved.originals.insert(entry.original).second) {
							fail(layer, object, "/origin/replaces", "Original item is already claimed or has no identity");
						}
					}
				}
				resolved.objects.push_back(entry);
			}
		}
		for (const auto &layer : project.layers) {
			for (const auto &object : layer.objects) {
				const auto tile = map.tile(object.position);
				if (!tile.exists || !tile.ground || tile.house || tile.blocked) {
					fail(layer, object, "/position", "Expected an existing, unblocked, non-house tile with ground");
				}
				if (std::any_of(tile.items.begin(), tile.items.end(), [&](const auto &item) { return item.teleport && !resolved.originals.contains(item.key); })) {
					fail(layer, object, "/position", "Another teleport already occupies this tile");
				}
				const auto arrival = destination(project, object);
				if (!arrival) {
					continue;
				}
				const auto arrivalTile = map.tile(*arrival);
				if (!arrivalTile.exists || !arrivalTile.ground || arrivalTile.house || arrivalTile.blocked) {
					fail(layer, object, "/components/destination", "Arrival requires an existing, unblocked, non-house tile with ground");
					continue;
				}
				std::set<std::tuple<int32_t, int32_t, int32_t>> visited { validationKey(object.position) };
				std::optional<Position> next = arrival;
				while (next) {
					if (!visited.insert(validationKey(*next)).second) {
						fail(layer, object, "/components/destination", "Effective teleport cycle");
						break;
					}
					const auto generated = external.find(validationKey(*next));
					if (generated != external.end()) {
						next = destination(project, *generated->second);
					} else {
						const auto tile = map.tile(*next);
						next.reset();
						for (const auto &item : tile.items) {
							if (item.teleport && !resolved.originals.contains(item.key)) {
								if (isValidPosition(item.destination)) {
									next = item.destination;
								}
								break;
							}
						}
					}
				}
			}
		}
		if (!requested.empty()) {
			for (const auto &occurrence : map.uniqueIds(requested)) {
				if (!resolved.originals.contains(occurrence.key)) {
					diagnostics.push_back({ project.file, "", "/attributes/uid", "UID " + std::to_string(occurrence.uid) + " already exists at " + std::to_string(occurrence.position.x) + "," + std::to_string(occurrence.position.y) + "," + std::to_string(occurrence.position.z) });
				}
			}
		}
		if (diagnostics.size() != initialErrors) {
			return false;
		}
		plan = std::move(resolved);
		return true;
	}

} // namespace world_layers
