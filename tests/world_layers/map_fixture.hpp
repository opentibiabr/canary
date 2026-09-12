#pragma once
#include "world/world_validation.hpp"
#include <map>
#include <tuple>

struct WorldMapFixture final : world_layers::MapView {
	using Key = std::tuple<int32_t, int32_t, int32_t>;
	std::map<Key, world_layers::MapTile> tiles;
	std::vector<world_layers::UniqueOccurrence> ids;
	static Key key(const world_layers::Position &p) {
		return { p.x, p.y, p.z };
	}

	explicit WorldMapFixture(const world_layers::Project &project) {
		uint64_t identity = 1;
		for (const auto &layer : project.layers) {
			for (const auto &object : layer.objects) {
				tiles[key(object.position)] = { true, true, false, false, {} };
				if (const auto arrival = world_layers::destination(project, object)) {
					tiles[key(*arrival)] = { true, true, false, false, {} };
				}
				if (object.replaces) {
					tiles[key(object.replaces->position)] = { true, true, false, false, { { identity, object.replaces->itemId, object.uid, true, world_layers::destination(project, object).value_or(world_layers::Position {}) } } };
					if (object.uid) {
						ids.push_back({ object.uid, identity, object.replaces->position });
					}
					++identity;
				}
			}
		}
	}
	bool nativeTeleport(uint16_t id) const override {
		return id == 1949;
	}
	world_layers::MapTile tile(const world_layers::Position &p) override {
		const auto it = tiles.find(key(p));
		return it == tiles.end() ? world_layers::MapTile {} : it->second;
	}
	std::vector<world_layers::UniqueOccurrence> uniqueIds(const std::unordered_set<uint16_t> &requested) override {
		std::vector<world_layers::UniqueOccurrence> result;
		for (const auto &id : ids) {
			if (requested.contains(id.uid)) {
				result.push_back(id);
			}
		}
		return result;
	}
};
