#pragma once

#include "world/world_validation.hpp"
#include <memory>

namespace world_layers {
	// Standalone, read-only OTBM inspection. Retains requested tiles and teleport
	// tiles, plus the complete UID census; it does not instantiate a game server.
	class MapSnapshot final : public MapView {
	public:
		MapSnapshot();
		~MapSnapshot() override;
		bool load(const std::filesystem::path &map, const std::filesystem::path &items, const std::vector<Position> &positions, Diagnostics &diagnostics);
		bool knownItem(uint16_t itemId) const override;
		bool nativeTeleport(uint16_t itemId) const override;
		bool capability(uint16_t itemId, const std::string &name) const override;
		MapTile tile(const Position &position) override;
		std::vector<UniqueOccurrence> uniqueIds(const std::unordered_set<uint16_t> &requested) override;
		std::vector<IdentifierOccurrence> identifiers() override;
		uint64_t tileCount() const;
		uint64_t itemCount() const;
		Value inspect(const Position &position);

	private:
		struct State;
		std::unique_ptr<State> state;
	};

	std::vector<Position> projectPositions(const Project &project);
	Value snapshotValue(const Position &position, const MapTile &tile);
}
