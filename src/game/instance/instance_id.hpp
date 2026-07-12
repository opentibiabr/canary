/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <functional>
#endif

// Strong-typed instance identifier. Deliberately not just a uint32_t so a
// raw index or a player/account id can never be passed where an InstanceId
// is expected by accident.
enum class InstanceId : uint32_t {
	Invalid = 0,
};

// Strong-typed identifier for one reserved slot in an InstanceManager's
// pool. What a slot physically *is* (a map region offset, eventually) is
// deliberately not defined here - see docs/architecture/instance-manager.md.
// This foundation only tracks which slots are reserved and by which
// instance; a later PR gives slot ids real map-region meaning.
enum class InstanceSlotId : uint32_t {
	Invalid = 0xFFFFFFFFu,
};

[[nodiscard]] constexpr uint32_t toIndex(InstanceSlotId slot) {
	return static_cast<uint32_t>(slot);
}

[[nodiscard]] constexpr InstanceSlotId toSlotId(uint32_t index) {
	return static_cast<InstanceSlotId>(index);
}

template <>
struct std::hash<InstanceId> {
	std::size_t operator()(InstanceId id) const noexcept {
		return std::hash<uint32_t> {}(static_cast<uint32_t>(id));
	}
};
