/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <variant>

#include "game/movement/position.hpp"
#include "utils/worldpointer.hpp"

class Tile;
class Cylinder;
class Item;
class Creature;
class Container;
class Player;
class DepotChest;

class Thing {
public:
	// Unified parent reference. Either a legacy `weak_ptr<Cylinder>` (for
	// shared_ptr-managed parents like Container/Player/Inbox) OR a
	// `PolyPtr<Tile>::Weak` for Tile parents (Tile lives outside the
	// shared_ptr world).
	//
	// IMPORTANT: Tile arm uses Weak (NOT Shared) to break the Item↔Tile
	// ownership cycle. See `Item::m_parent` comment for the rationale.
	using ParentRef = std::variant<std::weak_ptr<Cylinder>, PolyPtr<Tile>::Weak>;

	constexpr Thing() = default;
	virtual ~Thing() = default;

	// non-copyable
	Thing(const Thing &) = delete;
	Thing &operator=(const Thing &) = delete;

	virtual std::string getDescription(int32_t lookDistance) = 0;

	virtual std::shared_ptr<Cylinder> getParent() {
		return nullptr;
	}
	virtual std::shared_ptr<Cylinder> getRealParent() {
		return getParent();
	}

	// PUBLIC API (NVI idiom). Only these two overloads are visible to
	// callsites. Both are non-virtual and dispatch to the protected
	// `setParentImpl(ParentRef)` virtual. This avoids the ambiguity that a
	// public `setParent(ParentRef)` virtual would create: variant has an
	// implicit converting ctor from each alternative, so a `shared_ptr<X>`
	// argument would be a viable match for BOTH `setParent(weak_ptr)` and
	// `setParent(ParentRef)`.
	void setParent(std::weak_ptr<Cylinder> parent) {
		setParentImpl(ParentRef { std::move(parent) });
	}
	void setParent(PolyPtr<Tile>::Borrowed tile) {
		if (tile) {
			// Borrowed → Weak (1 atomic weak ADD). Doesn't pin the Tile —
			// avoids the cycle. See ParentRef comment for rationale.
			setParentImpl(ParentRef { PolyPtr<Tile>::Weak { tile } });
		} else {
			setParentImpl(ParentRef { std::weak_ptr<Cylinder> {} });
		}
	}

protected:
	// Single virtual sink — derived classes override this and ONLY this.
	// Hidden behind the public `setParent` overloads above.
	virtual void setParentImpl(ParentRef /*parent*/) {
		//
	}

public:
	virtual PolyPtr<Tile>::Borrowed getTile() {
		return {};
	}

	virtual PolyPtr<Tile>::Borrowed getTile() const {
		return {};
	}

	virtual const Position &getPosition();
	virtual const Position &getPosition() const;
	virtual int32_t getThrowRange() const = 0;
	virtual bool isPushable() = 0;

	virtual std::shared_ptr<Player> getPlayer() {
		return nullptr;
	}
	virtual std::shared_ptr<Container> getContainer() {
		return nullptr;
	}
	virtual std::shared_ptr<const Container> getContainer() const {
		return nullptr;
	}
	virtual std::shared_ptr<Item> getItem() {
		return nullptr;
	}
	virtual std::shared_ptr<const Item> getItem() const {
		return nullptr;
	}
	virtual std::shared_ptr<Creature> getCreature() {
		return nullptr;
	}
	virtual std::shared_ptr<const Creature> getCreature() const {
		return nullptr;
	}
	virtual std::shared_ptr<Cylinder> getCylinder() {
		return nullptr;
	}

	virtual std::shared_ptr<DepotChest> getDepotChest() {
		return nullptr;
	}
	virtual std::shared_ptr<const DepotChest> getDepotChest() const {
		return nullptr;
	}

	virtual bool isRemoved() {
		return true;
	}
};
