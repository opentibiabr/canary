/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "map/navigation_snapshot.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
#endif

NavSectorSnapshot::NavSectorSnapshot(uint32_t sectorIndex, uint8_t z, uint64_t topologyRevision, uint64_t occupancyRevision, Cells cells) :
	sectorIndex(sectorIndex), z(z), topologyRevision(topologyRevision), occupancyRevision(occupancyRevision), cells(std::move(cells)) { }

const NavCell* NavSectorSnapshot::getCell(uint16_t x, uint16_t y, uint8_t requestedZ) const {
	const auto requestedSector = static_cast<uint32_t>(x / SECTOR_SIZE) | (static_cast<uint32_t>(y / SECTOR_SIZE) << 16);
	if (requestedZ != z || requestedSector != sectorIndex) {
		return nullptr;
	}

	const auto index = static_cast<size_t>(x & SECTOR_MASK) * SECTOR_SIZE + static_cast<size_t>(y & SECTOR_MASK);
	return &cells[index];
}

NavRegionSnapshot::NavRegionSnapshot(uint64_t epoch, Position center, uint8_t radius, SectorList sectors) :
	epoch(epoch), center(center), radius(radius), sectors(std::move(sectors)) {
	std::ranges::sort(this->sectors, {}, &NavSectorSnapshot::getSectorIndex);
}

const NavCell* NavRegionSnapshot::getCell(const Position &position) const {
	if (position.z != center.z || Position::getDistanceX(position, center) > radius || Position::getDistanceY(position, center) > radius) {
		return nullptr;
	}

	const auto sectorIndex = static_cast<uint32_t>(position.x / SECTOR_SIZE) | (static_cast<uint32_t>(position.y / SECTOR_SIZE) << 16);
	const auto it = std::ranges::lower_bound(sectors, sectorIndex, {}, &NavSectorSnapshot::getSectorIndex);
	if (it == sectors.end() || (*it)->getSectorIndex() != sectorIndex) {
		return nullptr;
	}
	return (*it)->getCell(position.x, position.y, position.z);
}
