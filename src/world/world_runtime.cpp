#include "world/world_runtime.hpp"

#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "game/movement/teleport.hpp"
#include "items/containers/container.hpp"
#include "items/item.hpp"
#include "items/tile.hpp"
#include "world/world_validation.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <exception>
#endif

namespace {
	::Position native(const world_layers::Position &p) {
		return { static_cast<uint16_t>(p.x), static_cast<uint16_t>(p.y), static_cast<uint8_t>(p.z) };
	}
	world_layers::Position portable(const ::Position &p) {
		return { p.x, p.y, p.z };
	}
	uint16_t uid(const std::shared_ptr<Item> &item) {
		return item->getAttribute<uint16_t>(ItemAttribute_t::UNIQUEID);
	}

	class ServerMapView final : public world_layers::MapView {
	public:
		bool nativeTeleport(uint16_t id) const override {
			return Item::items[id].isTeleport();
		}
		world_layers::MapTile tile(const world_layers::Position &position) override {
			world_layers::MapTile result;
			const auto tile = g_game().map.getTile(native(position));
			if (!tile) {
				return result;
			}
			result.exists = true;
			result.ground = tile->getGround() != nullptr;
			result.house = tile->getHouse() != nullptr;
			const auto append = [&](const std::shared_ptr<Item> &item) {
				if (!item) {
					return;
				}
				const auto teleport = item->getTeleport();
				result.items.push_back({ reinterpret_cast<uintptr_t>(item.get()), item->getID(), uid(item), teleport != nullptr, teleport ? portable(teleport->getDestPos()) : world_layers::Position {} });
				result.blocked = result.blocked || Item::items[item->getID()].blockSolid;
				items.emplace(reinterpret_cast<uintptr_t>(item.get()), item);
			};
			append(tile->getGround());
			if (const auto list = tile->getItemList()) {
				for (const auto &item : *list) {
					append(item);
				}
			}
			return result;
		}
		std::vector<world_layers::UniqueOccurrence> uniqueIds(const std::unordered_set<uint16_t> &requested) override {
			auto result = g_game().map.worldUniqueIds(requested);
			// The UID registry can also retain items outside map tiles.
			for (const auto id : requested) {
				if (const auto item = g_game().getUniqueItem(id)) {
					result.push_back({ id, reinterpret_cast<uintptr_t>(item.get()), portable(item->getPosition()) });
				}
			}
			return result;
		}
		std::unordered_map<uint64_t, std::shared_ptr<Item>> items;
	};

	void report(const world_layers::Diagnostics &diagnostics) {
		for (const auto &diagnostic : diagnostics) {
			g_logger().error("World layers: {}", diagnostic.describe());
		}
	}
} // namespace

std::vector<world_layers::UniqueOccurrence> Map::worldUniqueIds(const std::unordered_set<uint16_t> &requested) {
	std::vector<world_layers::UniqueOccurrence> result;
	const auto cached = [&](const auto &self, const std::shared_ptr<BasicItem> &item, const world_layers::Position &position) -> void {
		if (!item) {
			return;
		}
		if (requested.contains(item->uniqueId)) {
			result.push_back({ item->uniqueId, reinterpret_cast<uintptr_t>(item.get()), position });
		}
		for (const auto &child : item->items) {
			self(self, child, position);
		}
	};
	const auto live = [&](const auto &self, const std::shared_ptr<Item> &item, const world_layers::Position &position) -> void {
		if (!item) {
			return;
		}
		if (requested.contains(uid(item))) {
			result.push_back({ uid(item), reinterpret_cast<uintptr_t>(item.get()), position });
		}
		if (const auto container = item->getContainer()) {
			for (const auto &child : container->getItemList()) {
				self(self, child, position);
			}
		}
	};
	for (auto &[sectorKey, sector] : mapSectors) {
		for (uint8_t z = 0; z < MAP_MAX_LAYERS; ++z) {
			const auto floor = sector.getFloor(z);
			if (!floor) {
				continue;
			}
			for (int32_t x = 0; x < SECTOR_SIZE; ++x) {
				for (int32_t y = 0; y < SECTOR_SIZE; ++y) {
					const world_layers::Position position { static_cast<int32_t>(sectorKey & 0xffff) * SECTOR_SIZE + x, static_cast<int32_t>(sectorKey >> 16) * SECTOR_SIZE + y, z };
					const auto entry = floor->getTileAndCache(static_cast<uint16_t>(position.x), static_cast<uint16_t>(position.y));
					if (entry.tile) {
						live(live, entry.tile->getGround(), position);
						if (const auto list = entry.tile->getItemList()) {
							for (const auto &item : *list) {
								live(live, item, position);
							}
						}
					} else if (entry.cachedTile) {
						cached(cached, entry.cachedTile->ground, position);
						for (const auto &item : entry.cachedTile->items) {
							cached(cached, item, position);
						}
					}
				}
			}
		}
	}
	return result;
}

bool WorldLayerRuntime::isDeclared(const std::string &id) const {
	return project && project->find(id);
}

bool WorldLayerRuntime::prepare() {
	try {
		const auto setting = g_configManager().getString(WORLD_PROJECT);
		if (setting.empty()) {
			return true;
		}
		const auto root = std::filesystem::path(g_configManager().getString(DATA_DIRECTORY)) / "world";
		const auto mapName = g_configManager().getString(MAP_NAME);
		const auto file = setting == "auto" ? root / (mapName + ".world.json") : std::filesystem::path(setting);
		if (setting == "auto" && !std::filesystem::exists(file)) {
			return true;
		}
		world_layers::Project loaded;
		world_layers::Diagnostics diagnostics;
		if (!world_layers::loadProject(file, loaded, diagnostics)) {
			report(diagnostics);
			return false;
		}
		world_layers::validateProject(loaded, diagnostics);
		const auto catalog = std::filesystem::path(g_configManager().getString(CORE_DIRECTORY)) / "items/items.xml";
		if (!std::filesystem::equivalent(loaded.map, root / (mapName + ".otbm")) || !std::filesystem::equivalent(loaded.items, catalog)) {
			g_logger().error("World project map/items must match the configured map and item catalog");
			return false;
		}
		if (!diagnostics.empty()) {
			report(diagnostics);
			return false;
		}
		project = std::move(loaded);
		return true;
	} catch (const std::exception &error) {
		g_logger().error("Cannot prepare world layers: {}", error.what());
		return false;
	}
}

bool WorldLayerRuntime::apply() {
	if (!project || applied) {
		return true;
	}
	struct Change {
		std::shared_ptr<Item> original, created;
		std::shared_ptr<Tile> oldTile, newTile;
		bool removed = false, added = false, registered = false, oldRegistered = false;
	};
	std::vector<Change> changes;
	const auto rollback = [&] {
		for (auto it = changes.rbegin(); it != changes.rend(); ++it) {
			if (it->registered) {
				g_game().removeUniqueItem(uid(it->created));
				it->registered = false;
			}
			if (it->added && it->newTile->getThingIndex(it->created) >= 0) {
				it->newTile->removeThing(it->created, 1);
			}
			it->added = false;
			if (it->removed && it->oldTile->getThingIndex(it->original) < 0) {
				it->oldTile->internalAddThing(it->original);
			}
			it->removed = false;
			if (it->oldRegistered && !g_game().getUniqueItem(uid(it->original))) {
				g_game().addUniqueItem(uid(it->original), it->original);
			}
			it->oldRegistered = false;
		}
	};
	try {
		ServerMapView map;
		world_layers::ApplicationPlan plan;
		world_layers::Diagnostics diagnostics;
		if (!world_layers::validateMap(*project, map, plan, diagnostics)) {
			report(diagnostics);
			return false;
		}
		changes.reserve(plan.objects.size());
		// Allocate and configure everything before touching the effective map.
		for (const auto &entry : plan.objects) {
			const auto &object = *project->find(entry.id);
			Change change;
			change.created = Item::CreateItem(object.itemId, 1);
			change.newTile = g_game().map.getTile(native(object.position));
			if (!change.created || !change.created->getTeleport() || Item::items[object.itemId].decayTime != 0 || !change.newTile || (change.newTile->getItemList() && change.newTile->getItemList()->size() >= 0xfffe)) {
				g_logger().error("Cannot stage world object {}", entry.id);
				return false;
			}
			if (entry.original) {
				change.original = map.items.at(entry.original);
				change.oldTile = change.original->getTile();
				if (!change.oldTile || change.oldTile->getThingIndex(change.original) < 0 || change.original->getDecaying() != DECAYING_FALSE) {
					g_logger().error("Cannot replace detached or decaying world original {}", entry.id);
					return false;
				}
			}
			if (object.aid) {
				change.created->setAttribute(ItemAttribute_t::ACTIONID, object.aid);
			}
			if (object.uid) {
				change.created->setAttribute(ItemAttribute_t::UNIQUEID, object.uid);
			}
			if (entry.destination) {
				change.created->getTeleport()->setDestPos(native(*entry.destination));
			}
			changes.push_back(std::move(change));
		}
		for (auto &change : changes) {
			if (!change.original) {
				continue;
			}
			change.oldRegistered = uid(change.original) && g_game().getUniqueItem(uid(change.original)) == change.original;
			if (change.oldRegistered) {
				g_game().removeUniqueItem(uid(change.original));
			}
			change.removed = true;
			change.oldTile->removeThing(change.original, 1);
			if (change.oldTile->getThingIndex(change.original) >= 0) {
				rollback();
				g_logger().error("World layer original removal failed; restored original items");
				return false;
			}
		}
		for (auto &change : changes) {
			change.added = true;
			change.newTile->internalAddThing(change.created);
			if (change.newTile->getThingIndex(change.created) < 0) {
				rollback();
				g_logger().error("World layer placement failed; restored original items");
				return false;
			}
			if (uid(change.created)) {
				change.registered = g_game().addUniqueItem(uid(change.created), change.created);
				if (!change.registered) {
					rollback();
					g_logger().error("World layer UID registration failed; restored original items");
					return false;
				}
			}
		}
		g_logger().info("Applied {} world objects from {}", changes.size(), project->file.generic_string());
		applied = true;
		return true;
	} catch (const std::exception &error) {
		g_logger().error("Cannot apply world layers: {}", error.what());
		try {
			rollback();
		} catch (const std::exception &rollbackError) {
			g_logger().error("World layer rollback failed: {}; startup remains aborted", rollbackError.what());
		}
		return false;
	}
}
