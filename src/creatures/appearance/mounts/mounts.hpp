/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "utils/worldpointer.hpp"

struct Mount {
	Mount(uint8_t initId, uint16_t initClientId, std::string initName, int32_t initSpeed, bool initPremium, std::string initType) :
		name(std::move(initName)), speed(initSpeed), clientId(initClientId), id(initId), premium(initPremium),
		type(std::move(initType)) { }

	std::string name;
	int32_t speed;
	uint16_t clientId;
	uint8_t id;
	bool premium;
	std::string type;
};

class Mounts {
public:
	using MountAllocator = WorldPtr<Mount>::DefaultAllocator;
	using OwningMount = WorldPtr<Mount>::Owning<MountAllocator>;
	using BorrowedMount = WorldPtr<Mount>::Borrowed<MountAllocator>;
	using StorageType = phmap::parallel_flat_hash_set<
		OwningMount,
		WorldPtrOwningHash<Mount>>;

	bool reload();
	bool loadFromXml();

	// Storage owns each Mount via an affine WorldPtr<Mount>::Owning; callers
	// receive a WorldPtr<Mount>::Borrowed (`BorrowedMount`), free to copy
	// and cheap to pass around. To escape the world (Lua, network), assign
	// to a WorldPtr<Mount>::Shared — the implicit conversion bumps the
	// existing block's refcount and pins the Mount past any reload.
	[[nodiscard]] BorrowedMount getMountByID(uint8_t id) const;
	[[nodiscard]] BorrowedMount getMountByName(const std::string &name) const;
	[[nodiscard]] BorrowedMount getMountByClientID(uint16_t clientId) const;

	[[nodiscard]] const StorageType &getMounts() const {
		return mounts;
	}

private:
	StorageType mounts;
};
