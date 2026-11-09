/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <optional>
	#include <string>
#endif

// This keyspace bypasses the global write-back cache. Its values use the normal
// KV ValueWrapper protobuf codec, but must commit atomically with bank/owner SQL.
// Never access cyclopedia.atomic.* through g_kv(): a cached snapshot could undo
// a committed transaction during the next general KV save.
namespace CyclopediaStorage {
	inline constexpr auto donationsKey = "cyclopedia.atomic.donations";
	bool ready();
	bool initialize(const std::string &key, const std::string &value);
	std::optional<std::string> read(const std::string &key, bool forUpdate = false);
	bool write(const std::string &key, const std::string &value);
	std::string discoveryKey(uint32_t playerId);
}
