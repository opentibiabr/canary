#include "world/world_runtime.hpp"
#include "world/world_behaviors.hpp"
#include "world/world_runtime_items.hpp"

#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "game/movement/teleport.hpp"
#include "items/containers/container.hpp"
#include "items/item.hpp"
#include "items/tile.hpp"
#include "utils/tools.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <exception>
	#include <limits>
	#include <set>
	#include <tuple>
#endif

namespace {
	using namespace world_runtime;
	using TileKey = std::tuple<int32_t, int32_t, int32_t>;
	using LegacyKey = std::tuple<std::filesystem::path, std::string, std::string, std::string, std::string>;
	using BaseTiles = std::map<TileKey, world_layers::MapTile>;
	TileKey key(const world_layers::Position &p) {
		return { p.x, p.y, p.z };
	}

	class ServerMapView final : public world_layers::MapView {
	public:
		explicit ServerMapView(const BaseTiles* baseline = nullptr) :
			baseline(baseline) { }
		bool knownItem(uint16_t id) const override {
			return Item::items.hasItemType(id);
		}
		bool nativeTeleport(uint16_t id) const override {
			return knownItem(id) && Item::items[id].isTeleport();
		}
		bool capability(uint16_t id, const std::string &name) const override {
			if (!knownItem(id)) {
				return false;
			}
			const auto &type = Item::items[id];
			if (name == "container") {
				return type.isContainer();
			}
			if (name == "door") {
				return type.isDoor();
			}
			if (name == "ground") {
				return type.isGroundTile();
			}
			if (name == "movable") {
				return type.movable;
			}
			if (name == "stackable") {
				return type.stackable;
			}
			if (name == "readable") {
				return type.canReadText || type.canWriteText;
			}
			if (name == "blocking") {
				return type.blockSolid;
			}
			return MapView::capability(id, name);
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
			const auto append = [&](const std::shared_ptr<Item> &item, bool ground) {
				if (!item || excluded.contains(reinterpret_cast<uintptr_t>(item.get()))) {
					return;
				}
				auto view = snapshot(item, items, ground);
				const auto canonicalize = [&](const auto &self, world_layers::MapItem &entry) -> void {
					const auto found = items.find(entry.key);
					if (found != items.end()) {
						const auto alias = baseKeys.find(found->second.get());
						if (alias != baseKeys.end()) {
							entry.key = alias->second;
						}
					}
					for (auto &child : entry.children) {
						self(self, child);
					}
				};
				canonicalize(canonicalize, view);
				result.items.push_back(std::move(view));
				result.blocked = result.blocked || Item::items[item->getID()].blockSolid;
			};
			append(tile->getGround(), true);
			if (const auto list = tile->getItemList()) {
				for (const auto &item : mapOrderedItems(*list)) {
					append(item, false);
				}
			}
			return result;
		}
		world_layers::MapTile selectionTile(const world_layers::Position &position) override {
			if (!baseline) {
				return tile(position);
			}
			const auto it = baseline->find(key(position));
			return it == baseline->end() ? world_layers::MapTile {} : it->second;
		}
		uint16_t effectiveUid(const world_layers::MapItem &original) override {
			const auto it = items.find(original.key);
			return it == items.end() ? original.uid : uid(it->second);
		}
		std::vector<world_layers::UniqueOccurrence> uniqueIds(const std::unordered_set<uint16_t> &requested) override {
			auto result = g_game().map.worldUniqueIds(requested);
			for (auto &entry : result) {
				const auto alias = baseKeys.find(reinterpret_cast<const Item*>(entry.key));
				if (alias != baseKeys.end()) {
					entry.key = alias->second;
				}
			}
			std::set<std::pair<uint16_t, uint64_t>> seen;
			std::erase_if(result, [&](const auto &entry) {
				return excluded.contains(entry.key) || !seen.emplace(entry.uid, entry.key).second;
			});
			for (const auto &[id, item] : g_game().getUniqueItems()) {
				const auto alias = baseKeys.find(item.get());
				const auto identity = alias == baseKeys.end() ? reinterpret_cast<uintptr_t>(item.get()) : alias->second;
				if ((!requested.empty() && !requested.contains(id)) || excluded.contains(identity)) {
					continue;
				}
				if (seen.emplace(id, identity).second) {
					result.push_back({ id, identity, portable(item->getPosition()) });
				}
			}
			return result;
		}
		std::unordered_map<uint64_t, std::shared_ptr<Item>> items;
		std::unordered_map<const Item*, uint64_t> baseKeys;
		std::unordered_set<uint64_t> excluded;

	private:
		const BaseTiles* baseline;
	};

	void report(const world_layers::Diagnostics &diagnostics) {
		for (const auto &diagnostic : diagnostics) {
			g_logger().error("World: {}", diagnostic.describe());
		}
	}

	std::vector<std::shared_ptr<Item>> children(const std::shared_ptr<Cylinder> &parent) {
		if (!parent) {
			return {};
		}
		if (const auto container = parent->getContainer()) {
			const auto &items = container->getItemList();
			return { items.begin(), items.end() };
		}
		if (const auto tile = parent->getTile()) {
			std::vector<std::shared_ptr<Item>> result;
			if (tile->getGround()) {
				result.push_back(tile->getGround());
			}
			if (const auto items = tile->getItemList()) {
				result.insert(result.end(), items->begin(), items->end());
			}
			return result;
		}
		return {};
	}

	// Invalidated identities retire at the limit; wrapping must never make an
	// old timer token valid again.
	void advance(uint64_t &generation) {
		generation = generation == std::numeric_limits<uint64_t>::max() ? 0 : generation ? generation + 1
																						 : 0;
	}
}

struct WorldLayerRuntime::State {
	explicit State(WorldLayerRuntime &runtime) :
		behaviors(runtime) { }
	WorldBehaviors behaviors;
	struct Binding {
		std::weak_ptr<Item> item;
		std::weak_ptr<Cylinder> origin;
		world_layers::Value::Record baseline;
		std::optional<world_layers::Position> baseDestination;
		uint64_t generation = 1;
		uint16_t count = 1;
	};
	WorldConfigurationMode mode = WorldConfigurationMode::Legacy;
	std::optional<world_layers::Project> project;
	std::string projectId;
	BaseTiles baseTiles;
	std::map<LegacyKey, std::string> legacyOwners;
	std::unordered_map<const Item*, std::string> baseIdentities;
	std::map<std::string, uint64_t> suspended;
	std::unordered_map<uint64_t, std::weak_ptr<Item>> originals;
	world_layers::ApplicationPlan basePlan;
	std::map<std::string, Binding> bindings;
	std::map<std::string, std::vector<std::weak_ptr<Item>>> restoredItems;
	std::unordered_map<const Item*, std::string> identities;
	uint64_t epoch = 1;
	uint32_t movementDepth = 0;
	std::vector<std::weak_ptr<Item>> moving;
	bool captured = false, failed = false, applied = false;
};

WorldLayerRuntime::WorldLayerRuntime() :
	state(std::make_unique<State>(*this)) { }
WorldLayerRuntime::~WorldLayerRuntime() = default;
WorldBehaviors &WorldLayerRuntime::behaviors() {
	return state->behaviors;
}
WorldConfigurationMode WorldLayerRuntime::mode() const {
	return state->mode;
}
const world_layers::Project* WorldLayerRuntime::declarations() const {
	return state->project ? &*state->project : nullptr;
}
const world_layers::Object* WorldLayerRuntime::object(const std::string &id) const {
	return state->project && state->project->active(id) ? state->project->find(id) : nullptr;
}
bool WorldLayerRuntime::isDeclared(const std::string &id) const {
	return object(id) != nullptr;
}
bool WorldLayerRuntime::readyForStartup() const {
	return !state->failed && (!state->project || state->captured);
}

bool WorldLayerRuntime::prepare() {
	if (state->project || state->applied) {
		return false;
	}
	try {
		const auto &mode = g_configManager().getString(WORLD_CONFIGURATION);
		state->mode = mode == "world" ? WorldConfigurationMode::World : mode == "mixed" ? WorldConfigurationMode::Mixed
																						: WorldConfigurationMode::Legacy;
		if (state->mode != WorldConfigurationMode::World) {
			g_logger().warn("Legacy world configuration is active and will be discontinued in a future release. See docs/systems/world-migration.md. Analyze with: python -m tools.world_migrate analyze --datapack {} --all", g_configManager().getString(DATA_DIRECTORY));
		}
		if (state->mode == WorldConfigurationMode::Legacy) {
			return true;
		}
		const auto setting = g_configManager().getString(WORLD_PROJECT);
		const auto root = std::filesystem::path(g_configManager().getString(DATA_DIRECTORY)) / "world";
		const auto mapName = g_configManager().getString(MAP_NAME);
		const auto file = setting == "auto" ? root / (mapName + ".world.json") : std::filesystem::path(setting);
		if (setting.empty()) {
			g_logger().error("World/mixed mode requires a worldProject catalog");
			return false;
		}
		world_layers::Project loaded;
		world_layers::Diagnostics diagnostics;
		if (!world_layers::loadProject(file, loaded, diagnostics)) {
			report(diagnostics);
			return false;
		}
		world_layers::validateProject(loaded, diagnostics);
		// Normalize only the in-memory runtime. Opening a v1 project never rewrites it.
		if (diagnostics.empty() && loaded.schemaVersion == 1) {
			world_layers::convertToV2(loaded, diagnostics);
		}
		const auto catalog = std::filesystem::path(g_configManager().getString(CORE_DIRECTORY)) / "items/items.xml";
		if (!std::filesystem::equivalent(loaded.map, root / (mapName + ".otbm")) || !std::filesystem::equivalent(loaded.items, catalog)) {
			g_logger().error("World project map/items must match the configured map and item catalog");
			return false;
		}
		if (!diagnostics.empty()) {
			report(diagnostics);
			return false;
		}
		for (const auto &record : loaded.migrationRecords) {
			for (const auto &[file, digest] : record.sources) {
				if (state->mode != WorldConfigurationMode::Mixed) {
					continue;
				}
				std::string source, error;
				if (!world_layers::readFile(file, source, error)) {
					g_logger().error("Cannot verify World migration source {}: {}", file.generic_string(), error);
					return false;
				}
				std::string normalized;
				normalized.reserve(source.size());
				for (size_t i = 0; i < source.size(); ++i) {
					if (source[i] == '\r' && i + 1 < source.size() && source[i + 1] == '\n') {
						continue;
					}
					normalized.push_back(source[i]);
				}
				if (transformToSHA256(normalized) != digest) {
					g_logger().error("World migration source changed: {}. Analyze and reconcile its ownership before startup", file.generic_string());
					return false;
				}
			}
			for (const auto &claim : record.claims) {
				if (!loaded.find(claim.object)) {
					g_logger().error("World migration {} references missing object {}", record.id, claim.object);
					return false;
				}
				for (const auto &responsibility : claim.responsibilities) {
					LegacyKey key { std::filesystem::weakly_canonical(claim.file), claim.table, claim.key, claim.occurrence, responsibility };
					if (!state->legacyOwners.emplace(std::move(key), claim.object).second) {
						g_logger().error("Overlapping World migration claims in {}", record.file.generic_string());
						return false;
					}
				}
			}
		}
		state->projectId = loaded.id;
		state->project = std::move(loaded);
		return true;
	} catch (const std::exception &error) {
		g_logger().error("Cannot prepare World: {}", error.what());
		return false;
	}
}

bool WorldLayerRuntime::captureBaseMap() {
	if (!state->project) {
		return true;
	}
	if (state->captured || state->failed) {
		return false;
	}
	try {
		ServerMapView map;
		for (const auto &layer : state->project->layers) {
			if (!layer.enabled) {
				continue;
			}
			for (const auto &object : layer.objects) {
				if (object.selector && object.selector->container.empty()) {
					const auto &p = object.selector->position;
					if (!state->baseTiles.contains(key(p))) {
						state->baseTiles.emplace(key(p), map.tile(p));
					}
				}
			}
		}
		world_layers::Diagnostics diagnostics;
		if (!world_layers::validateMap(*state->project, map, state->basePlan, diagnostics)) {
			report(diagnostics);
			state->failed = true;
			return false;
		}
		for (const auto &[key, item] : map.items) {
			state->originals.emplace(key, item);
		}
		for (const auto &entry : state->basePlan.objects) {
			if (entry.original) {
				state->baseIdentities.emplace(map.items.at(entry.original).get(), entry.id);
			}
		}
		if (state->mode != WorldConfigurationMode::Legacy) {
			std::map<std::string, world_layers::MapItem> selected;
			std::set<std::string> visiting;
			const auto resolve = [&](const auto &self, const std::string &id) -> bool {
				if (selected.contains(id)) {
					return true;
				}
				const auto definition = state->project->find(id);
				if (!definition || !definition->selector || !visiting.insert(id).second) {
					return false;
				}
				const auto &selector = *definition->selector;
				std::vector<world_layers::MapItem> candidates;
				if (selector.container.empty()) {
					auto tile = map.tile(selector.position);
					state->baseTiles.try_emplace(key(selector.position), tile);
					candidates = std::move(tile.items);
				} else if (self(self, selector.container)) {
					candidates = selected.at(selector.container).children;
				}
				world_layers::MapItem item;
				std::string error;
				if (!world_layers::resolveSelector(selector, candidates, item, error)) {
					g_logger().error("Cannot retain suspended World ownership for {}: {}", id, error);
					return false;
				}
				selected.emplace(id, std::move(item));
				visiting.erase(id);
				return true;
			};
			for (const auto &record : state->project->migrationRecords) {
				for (const auto &claim : record.claims) {
					if (state->project->active(claim.object) || !state->project->find(claim.object)->selector
					    || !std::any_of(claim.responsibilities.begin(), claim.responsibilities.end(), [](const auto &name) { return name.starts_with("on"); })) {
						continue;
					}
					if (!resolve(resolve, claim.object)) {
						state->failed = true;
						return false;
					}
					const auto original = selected.at(claim.object).key;
					const auto live = map.items.at(original);
					const auto [owner, inserted] = state->baseIdentities.emplace(live.get(), claim.object);
					if (!inserted && owner->second != claim.object) {
						state->failed = true;
						g_logger().error("Suspended World {} overlaps {}", claim.object, owner->second);
						return false;
					}
					state->suspended[claim.object] = original;
				}
			}
			for (const auto &[key, item] : map.items) {
				state->originals.try_emplace(key, item);
			}
		}
		state->captured = true;
		return true;
	} catch (const std::exception &error) {
		state->failed = true;
		g_logger().error("Cannot capture World base selections: {}", error.what());
		return false;
	}
}

bool WorldLayerRuntime::apply() {
	if (!state->project || state->applied) {
		return !state->failed;
	}
	if (!readyForStartup()) {
		return false;
	}
	struct Change {
		std::string id;
		const world_layers::Object* definition = nullptr;
		std::shared_ptr<Item> original, item;
		std::shared_ptr<Cylinder> oldParent, destination, relocationParent;
		world_layers::Value::Record before, values;
		std::optional<world_layers::Position> beforeDestination, destinationPosition;
		bool registered = false, removed = false, added = false, mutated = false, reused = false, relocated = false, detached = false;
	};
	std::vector<Change> changes;
	std::map<uint16_t, std::shared_ptr<Item>> oldRegistry;
	bool registryReleased = false;
	std::map<std::shared_ptr<Cylinder>, std::vector<std::shared_ptr<Item>>> orders;
	std::map<std::string, State::Binding> bindings;
	std::unordered_map<const Item*, std::string> identities;
	const auto rollback = [&] {
		// Release all newly registered UIDs before restoring any old UID (swaps).
		for (auto &change : changes) {
			if (change.registered && g_game().getUniqueItem(uid(change.item)) == change.item) {
				g_game().removeUniqueItem(uid(change.item));
			}
			change.registered = false;
		}
		for (auto it = changes.rbegin(); it != changes.rend(); ++it) {
			if (it->added && it->item->getParent()) {
				it->item->getParent()->removeThing(it->item, it->item->getItemCount());
			}
			it->added = false;
			if (it->mutated) {
				applyAttributes(it->item, it->before);
				if (it->beforeDestination && it->item->getTeleport()) {
					it->item->getTeleport()->setDestPos(native(*it->beforeDestination));
				}
				it->mutated = false;
			}
			if (it->relocated && !it->item->getParent()) {
				if (!attach(it->relocationParent, it->item, 0)) {
					g_logger().error("World rollback could not restore persisted {}", it->id);
				}
			}
			it->relocated = false;
			if (it->removed && !it->original->getParent()) {
				// Insert at the front; the complete original order is restored below.
				if (!attach(it->oldParent, it->original, 0)) {
					g_logger().error("World rollback could not restore {}", it->id);
				}
			}
			it->removed = false;
		}
		for (const auto &[parent, order] : orders) {
			if (const auto container = parent->getContainer()) {
				if (!container->restoreWorldItemOrder(order)) {
					g_logger().error("World rollback container order mismatch");
				}
			} else if (const auto tile = parent->getTile()) {
				std::vector<std::shared_ptr<Item>> items;
				for (const auto &item : order) {
					if (item != tile->getGround()) {
						items.push_back(item);
					}
				}
				const auto list = tile->getItemList();
				if (list && list->size() == items.size() && std::is_permutation(items.begin(), items.end(), list->begin())) {
					std::copy(items.begin(), items.end(), list->begin());
				}
			}
		}
		if (registryReleased) {
			for (const auto &[id, item] : oldRegistry) {
				if (!g_game().addUniqueItem(id, item)) {
					g_logger().error("World rollback UID {} remains unavailable", id);
				}
			}
			registryReleased = false;
		}
	};
	try {
		ServerMapView map(&state->baseTiles);
		for (const auto &[key, weak] : state->originals) {
			if (const auto item = weak.lock()) {
				map.items.emplace(key, item);
				map.baseKeys.emplace(item.get(), key);
			}
		}
		std::map<std::string, std::shared_ptr<Item>> stagedItems;
		changes.reserve(state->basePlan.objects.size());
		for (const auto &entry : state->basePlan.objects) {
			const auto &object = *state->project->find(entry.id);
			if (object.kind == world_layers::ObjectKind::Anchor) {
				bindings.emplace(entry.id, State::Binding {});
				continue;
			}
			Change change;
			change.id = entry.id;
			change.definition = &object;
			change.values = overrides(object);
			change.destinationPosition = entry.destination;
			if (entry.original) {
				const auto found = state->originals.find(entry.original);
				change.original = found == state->originals.end() ? nullptr : found->second.lock();
				if (!change.original || change.original->isRemoved()) {
					g_logger().error("World original {} disappeared during startup; reassociation is required", entry.id);
					return false;
				}
				change.oldParent = change.original->getParent();
				if (object.selector && !object.selector->container.empty()) {
					const auto parent = stagedItems.find(object.selector->container);
					if (parent == stagedItems.end() || change.oldParent != parent->second->getContainer()) {
						g_logger().error("World original {} changed its selected container during startup", entry.id);
						return false;
					}
				}
				const auto expected = object.selector && !object.selector->container.empty()
					? world_layers::objectPosition(*state->project, *state->project->find(object.selector->container))
					: object.selector ? std::optional(object.selector->position)
									  : std::nullopt;
				if (expected && portable(change.original->getPosition()) != *expected) {
					g_logger().error("World original {} moved out of its selected domain during startup", entry.id);
					return false;
				}
				// Persisted transformations may keep the same item identity. Its
				// original selector still refers to the captured OTBM instance.
			}
			if (object.mode == world_layers::SourceMode::Map) {
				change.item = change.original;
				change.destination = change.oldParent;
			} else {
				if (object.container.empty()) {
					change.destination = g_game().map.getTile(native(entry.position));
				} else {
					const auto parent = stagedItems.find(object.container);
					if (parent != stagedItems.end()) {
						change.destination = parent->second->getContainer();
					}
				}
				if (!change.destination) {
					g_logger().error("World destination unavailable for {}", entry.id);
					return false;
				}
				std::vector<std::shared_ptr<Item>> candidates = children(change.destination);
				if (const auto restored = state->restoredItems.find(entry.id); restored != state->restoredItems.end()) {
					for (const auto &weak : restored->second) {
						const auto item = weak.lock();
						if (item && !item->isRemoved() && std::find(candidates.begin(), candidates.end(), item) == candidates.end()) {
							candidates.push_back(item);
						}
					}
				}
				for (const auto &candidate : candidates) {
					if (marker(candidate, state->projectId) != entry.id) {
						continue;
					}
					if (candidate->getParent() != change.destination && object.lifecycle == world_layers::Lifecycle::RefillOnStartup) {
						// A former refill domain may have moved in the JSON. Preserve
						// the old content as an ordinary item, then refill the new one.
						Change detached;
						detached.id = entry.id;
						detached.definition = &object;
						detached.item = candidate;
						detached.reused = detached.detached = true;
						detached.values = overrides(object);
						auto custom = detached.values.contains("custom") ? std::get<world_layers::Value::Record>(detached.values.at("custom").data) : world_layers::Value::Record {};
						custom["__world.project"] = world_layers::Value {};
						custom["__world.object"] = world_layers::Value {};
						detached.values["custom"] = world_layers::Value { std::move(custom) };
						detached.before = captureAttributes(candidate, detached.values);
						changes.push_back(std::move(detached));
						continue;
					}
					if (change.item) {
						g_logger().error("World {} has multiple managed instances in its destination", entry.id);
						return false;
					}
					change.item = candidate;
					change.reused = true;
					if (candidate->getParent() != change.destination) {
						// Fixture content follows an explicit change of placement.
						change.relocationParent = candidate->getParent();
					}
					map.excluded.insert(reinterpret_cast<uintptr_t>(candidate.get()));
				}
				if (!change.item) {
					change.item = Item::CreateItem(object.itemId, object.subtype.value_or(object.count));
				}
				if (!change.item || (change.reused && change.item->getID() != object.itemId) || (object.lifecycle == world_layers::Lifecycle::Fixture && Item::items[object.itemId].decayTime != 0)) {
					g_logger().error("Cannot stage World item {} (missing, changed type, or decaying fixture)", entry.id);
					return false;
				}
			}
			if (object.mode != world_layers::SourceMode::Map) {
				auto custom = change.values.contains("custom") ? std::get<world_layers::Value::Record>(change.values.at("custom").data) : world_layers::Value::Record {};
				custom["__world.project"] = world_layers::Value { state->projectId };
				custom["__world.object"] = world_layers::Value { entry.id };
				change.values["custom"] = world_layers::Value { std::move(custom) };
			}
			if (!change.reused && object.mode != world_layers::SourceMode::Map && Item::items[object.itemId].stackable && (change.item->getItemCount() != object.count || object.count > change.item->getStackSize())) {
				g_logger().error("World stack count is outside the native range for {}", entry.id);
				return false;
			}
			change.before = captureAttributes(change.item, change.values);
			if (const auto teleport = change.item->getTeleport()) {
				change.beforeDestination = portable(teleport->getDestPos());
			}
			State::Binding binding;
			binding.item = change.item;
			binding.count = change.item->getItemCount();
			binding.origin = change.destination;
			binding.baseline = change.before;
			binding.baseDestination = change.beforeDestination;
			bindings.emplace(entry.id, std::move(binding));
			identities.emplace(change.item.get(), entry.id);
			stagedItems.emplace(entry.id, change.item);
			if (change.oldParent) {
				orders.try_emplace(change.oldParent, children(change.oldParent));
			}
			if (change.relocationParent) {
				orders.try_emplace(change.relocationParent, children(change.relocationParent));
			}
			if (change.destination && change.destination->getParent()) {
				orders.try_emplace(change.destination, children(change.destination));
			}
			changes.push_back(std::move(change));
		}
		world_layers::ApplicationPlan finalPlan;
		world_layers::Diagnostics diagnostics;
		if (!world_layers::validateMap(*state->project, map, finalPlan, diagnostics)) {
			report(diagnostics);
			return false;
		}
		std::map<std::shared_ptr<Cylinder>, std::vector<std::shared_ptr<Item>>> projected;
		const auto contents = [&](const std::shared_ptr<Cylinder> &parent) -> auto & {
			return projected.try_emplace(parent, children(parent)).first->second;
		};
		for (const auto &change : changes) {
			if (!change.detached && change.definition->mode == world_layers::SourceMode::Replace) {
				std::erase(contents(change.oldParent), change.original);
			}
		}
		for (const auto &change : changes) {
			if (change.detached || change.definition->mode == world_layers::SourceMode::Map || (change.reused && !change.relocationParent)) {
				continue;
			}
			if (change.relocationParent) {
				std::erase(contents(change.relocationParent), change.item);
			}
			auto &destination = contents(change.destination);
			if (const auto container = change.destination->getContainer()) {
				if (destination.size() >= container->capacity() || change.definition->order > destination.size()) {
					g_logger().error("World container capacity or insertion order is invalid for {}", change.id);
					return false;
				}
				destination.insert(destination.begin() + change.definition->order, change.item);
			} else {
				if (destination.size() >= 0xffff || (Item::items[change.item->getID()].isGroundTile() && std::any_of(destination.begin(), destination.end(), [](const auto &item) { return Item::items[item->getID()].isGroundTile(); }))) {
					g_logger().error("World tile capacity or ground conflicts for {}", change.id);
					return false;
				}
				destination.push_back(change.item);
			}
		}
		// Everything that can be allocated/configured off-map is ready. Mutations
		// below are journaled; nothing is visible through World until publication.
		const auto captureRegistry = [&](const auto &self, const std::shared_ptr<Item> &item, bool recursive) -> void {
			if (!item) {
				return;
			}
			const auto id = uid(item);
			if (id && g_game().getUniqueItem(id) == item) {
				oldRegistry.emplace(id, item);
			}
			if (recursive && item->getContainer()) {
				for (const auto &child : item->getContainer()->getItemList()) {
					self(self, child, true);
				}
			}
		};
		for (const auto &change : changes) {
			captureRegistry(captureRegistry, change.item, false);
			if (change.definition->mode == world_layers::SourceMode::Replace) {
				captureRegistry(captureRegistry, change.original, true);
			}
		}
		registryReleased = true;
		for (const auto &[id, item] : oldRegistry) {
			g_game().removeUniqueItem(id);
		}
		for (auto &change : changes) {
			if (!change.detached && change.definition->mode == world_layers::SourceMode::Replace) {
				change.removed = true;
				change.oldParent->removeThing(change.original, change.original->getItemCount());
				if (change.original->getParent()) {
					rollback();
					return false;
				}
			}
		}
		for (auto &change : changes) {
			change.mutated = true;
			applyAttributes(change.item, change.values);
			if (change.destinationPosition) {
				if (!change.item->getTeleport()) {
					rollback();
					return false;
				}
				change.item->getTeleport()->setDestPos(native(*change.destinationPosition));
			}
			if (change.reused && !change.detached && change.item->getParent() != change.destination) {
				change.relocated = true;
				change.relocationParent->removeThing(change.item, change.item->getItemCount());
				if (change.item->getParent()) {
					rollback();
					return false;
				}
			}
			if (!change.detached && change.definition->mode != world_layers::SourceMode::Map && (!change.reused || change.relocated)) {
				change.added = true;
				if (!attach(change.destination, change.item, change.definition->order)) {
					rollback();
					return false;
				}
			}
			if (uid(change.item)) {
				change.registered = g_game().addUniqueItem(uid(change.item), change.item);
				if (!change.registered) {
					rollback();
					return false;
				}
			}
		}
		g_logger().info("Prepared {} World objects from {}", bindings.size(), state->project->file.generic_string());
		for (const auto &[id, key] : state->suspended) {
			if (const auto live = state->originals.at(key).lock(); live && !live->isRemoved()) {
				State::Binding binding;
				binding.item = live;
				binding.origin = live->getParent();
				binding.count = live->getItemCount();
				bindings.emplace(id, std::move(binding));
				identities.emplace(live.get(), id);
			}
		}
		state->bindings.swap(bindings);
		state->identities.swap(identities);
		state->applied = true;
		state->baseTiles.clear();
		state->originals.clear();
		state->baseIdentities.clear();
		state->restoredItems.clear();
		return true;
	} catch (const std::exception &error) {
		g_logger().error("Cannot apply World: {}", error.what());
		try {
			rollback();
		} catch (const std::exception &rollbackError) {
			g_logger().error("World rollback failed: {}; startup remains aborted", rollbackError.what());
		}
		return false;
	}
}

std::vector<world_layers::UniqueOccurrence> Map::worldUniqueIds(const std::unordered_set<uint16_t> &requested) {
	std::vector<world_layers::UniqueOccurrence> result;
	const auto cached = [&](const auto &self, const std::shared_ptr<BasicItem> &item, const world_layers::Position &position) -> void {
		if (!item) {
			return;
		}
		if (item->uniqueId && (requested.empty() || requested.contains(item->uniqueId))) {
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
		if (uid(item) && (requested.empty() || requested.contains(uid(item)))) {
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

std::shared_ptr<Item> WorldLayerRuntime::item(const std::string &id) {
	if (!state->applied) {
		return nullptr;
	}
	const auto found = state->bindings.find(id);
	if (found == state->bindings.end() || found->second.generation == 0) {
		return nullptr;
	}
	const auto result = found->second.item.lock();
	if (!result || result->isRemoved()) {
		return nullptr;
	}
	return result;
}

std::optional<world_layers::Position> WorldLayerRuntime::position(const std::string &id) {
	const auto definition = object(id);
	if (!definition) {
		return std::nullopt;
	}
	if (const auto live = item(id)) {
		return portable(live->getPosition());
	}
	return definition->kind == world_layers::ObjectKind::Anchor || !state->applied ? world_layers::objectPosition(*state->project, *definition) : std::nullopt;
}

std::optional<WorldObjectToken> WorldLayerRuntime::token(const std::string &id, bool removing) {
	if (!state->applied || state->epoch == 0 || !object(id)) {
		return std::nullopt;
	}
	const auto found = state->bindings.find(id);
	if (found == state->bindings.end() || found->second.generation == 0 || (object(id)->kind == world_layers::ObjectKind::Item && !item(id) && (!removing || found->second.item.expired()))) {
		return std::nullopt;
	}
	return WorldObjectToken { id, found->second.generation, state->epoch };
}

bool WorldLayerRuntime::resolve(const WorldObjectToken &reference) {
	const auto current = token(reference.id);
	return current && current->epoch == reference.epoch && current->generation == reference.generation;
}

std::string WorldLayerRuntime::identity(const std::shared_ptr<Item> &item) {
	if (!item || !state->applied) {
		return "";
	}
	const auto found = state->identities.find(item.get());
	if (found == state->identities.end()) {
		return "";
	}
	const auto binding = state->bindings.find(found->second);
	if (binding == state->bindings.end() || binding->second.item.lock() != item) {
		state->identities.erase(found);
		return "";
	}
	return binding->first;
}

void WorldLayerRuntime::invalidateCallbacks() {
	advance(state->epoch);
}

uint64_t WorldLayerRuntime::callbackEpoch() const {
	return state->epoch;
}

void WorldLayerRuntime::removed(const std::shared_ptr<Item> &removedItem) {
	if (!removedItem || !state->applied) {
		return;
	}
	const auto id = identity(removedItem);
	if (!id.empty()) {
		auto &binding = state->bindings.at(id);
		advance(binding.generation);
		if (state->movementDepth) {
			state->moving.push_back(removedItem);
		} else {
			binding.item.reset();
			state->identities.erase(removedItem.get());
			unmark(removedItem);
		}
	}
	if (const auto container = removedItem->getContainer()) {
		for (const auto &child : container->getItemList()) {
			removed(child);
		}
	}
}

void WorldLayerRuntime::transformed(const std::shared_ptr<Item> &original, const std::shared_ptr<Item> &replacement) {
	if (!state->applied) {
		const auto found = state->baseIdentities.find(original.get());
		if (found != state->baseIdentities.end() && replacement && original != replacement) {
			const auto id = found->second;
			for (auto &[key, instance] : state->originals) {
				if (instance.lock() == original) {
					const auto oldUid = uid(original);
					if (oldUid && g_game().getUniqueItem(oldUid) == original) {
						g_game().removeUniqueItem(oldUid);
						if (!uid(replacement)) {
							replacement->setAttribute(ItemAttribute_t::UNIQUEID, oldUid);
						}
						if (g_game().getUniqueItem(uid(replacement)) != replacement && !g_game().addUniqueItem(uid(replacement), replacement)) {
							state->failed = true;
							g_logger().error("World startup transformation has a conflicting UID for {}", id);
							return;
						}
					}
					instance = replacement;
					state->baseIdentities.erase(found);
					state->baseIdentities.emplace(replacement.get(), id);
					break;
				}
			}
		}
		return;
	}
	const auto id = identity(original);
	if (id.empty()) {
		return;
	}
	auto &binding = state->bindings.at(id);
	advance(binding.generation);
	if (!replacement) {
		removed(original);
		return;
	}
	if (original == replacement) {
		return;
	}
	const auto* definition = object(id);
	const auto inheritedUid = uid(original);
	if (definition) {
		applyAttributes(replacement, overrides(*definition));
	}
	if (inheritedUid && (!definition || !definition->uidOverride)) {
		replacement->setAttribute(ItemAttribute_t::UNIQUEID, inheritedUid);
	}
	if (inheritedUid && g_game().getUniqueItem(inheritedUid) == original) {
		g_game().removeUniqueItem(inheritedUid);
	}
	if (uid(replacement) && g_game().getUniqueItem(uid(replacement)) != replacement && !g_game().addUniqueItem(uid(replacement), replacement)) {
		g_logger().error("World {} lost its instance after a conflicting UID transformation", id);
		replacement->removeAttribute(ItemAttribute_t::UNIQUEID);
		binding.generation = 0;
	}
	unmark(original);
	if (definition && definition->mode != world_layers::SourceMode::Map) {
		mark(replacement, state->projectId, id);
	}
	state->identities.erase(original.get());
	state->identities.emplace(replacement.get(), id);
	binding.item = replacement;
	if (state->movementDepth) {
		state->moving.push_back(replacement);
	}
}

bool WorldLayerRuntime::canMove(const std::shared_ptr<Item> &movingItem, const std::shared_ptr<Cylinder> &destination, uint32_t count) {
	if (!state->applied || !movingItem) {
		return true;
	}
	const auto id = identity(movingItem);
	if (!id.empty()) {
		const auto* definition = object(id);
		if (definition && definition->lifecycle == world_layers::Lifecycle::Fixture) {
			// A fixture can be reordered in its original container, but cannot
			// become inventory content or split into a second managed instance.
			if (destination != state->bindings.at(id).origin.lock() || count != movingItem->getItemCount()) {
				return false;
			}
		}
		if (definition && definition->lifecycle == world_layers::Lifecycle::Native && uid(movingItem) && count != movingItem->getItemCount()) {
			return false;
		}
	}
	if (destination != movingItem->getParent()) {
		const auto fixedContent = [&](const auto &self, const std::shared_ptr<Item> &parent) -> bool {
			if (const auto container = parent->getContainer()) {
				for (const auto &child : container->getItemList()) {
					const auto childId = identity(child);
					if (const auto childDefinition = object(childId); childDefinition && childDefinition->lifecycle == world_layers::Lifecycle::Fixture) {
						return true;
					}
					if (self(self, child)) {
						return true;
					}
				}
			}
			return false;
		};
		if (fixedContent(fixedContent, movingItem)) {
			return false;
		}
	}
	return true;
}

void WorldLayerRuntime::moved(const std::shared_ptr<Item> &movingItem) {
	if (!movingItem || !state->applied) {
		return;
	}
	const auto id = identity(movingItem);
	if (!id.empty()) {
		const auto* definition = object(id);
		auto &binding = state->bindings.at(id);
		if (binding.count != movingItem->getItemCount()) {
			advance(binding.generation);
			binding.count = movingItem->getItemCount();
		}
		bool outside = movingItem->isRemoved();
		if (definition && definition->lifecycle == world_layers::Lifecycle::RefillOnStartup) {
			const auto declaredPosition = world_layers::objectPosition(*state->project, *definition);
			outside = outside || movingItem->getParent() != binding.origin.lock() || !declaredPosition || portable(movingItem->getPosition()) != *declaredPosition;
		}
		if (outside) {
			removed(movingItem);
		} else if (uid(movingItem) && !g_game().getUniqueItem(uid(movingItem))) {
			g_game().addUniqueItem(uid(movingItem), movingItem);
		}
	}
	if (const auto container = movingItem->getContainer()) {
		for (const auto &child : container->getItemList()) {
			moved(child);
		}
	}
}

void WorldLayerRuntime::cloned(const std::shared_ptr<Item> &copy) {
	// Cloning configuration-derived content never clones its managed identity.
	if (!copy) {
		return;
	}
	unmark(copy);
	if (state->applied && uid(copy)) {
		const auto owner = g_game().getUniqueItem(uid(copy));
		if (owner != copy && !identity(owner).empty()) {
			copy->removeAttribute(ItemAttribute_t::UNIQUEID);
		}
	}
}

void WorldLayerRuntime::quantityChanged(const Item* item) {
	if (!state->applied || !item) {
		return;
	}
	const auto identity = state->identities.find(item);
	if (identity == state->identities.end()) {
		return;
	}
	const auto binding = state->bindings.find(identity->second);
	if (binding != state->bindings.end() && binding->second.item.lock().get() == item && binding->second.count != item->getItemCount()) {
		advance(binding->second.generation);
		binding->second.count = item->getItemCount();
	}
}

void WorldLayerRuntime::beginMovement(const std::shared_ptr<Item> &item) {
	++state->movementDepth;
	if (state->applied && item) {
		state->moving.push_back(item);
	}
}
void WorldLayerRuntime::endMovement() {
	if (!state->movementDepth || --state->movementDepth) {
		return;
	}
	for (const auto &pending : state->moving) {
		if (const auto live = pending.lock()) {
			moved(live);
		}
	}
	state->moving.clear();
}

bool WorldLayerRuntime::serializeHouseAttributes(const std::shared_ptr<Item> &source, PropWriteStream &stream) {
	const auto id = identity(source);
	if (id.empty() || !object(id)) {
		source->serializeAttr(stream);
		return true;
	}
	const auto &binding = state->bindings.at(id);
	// Qualified call intentionally copies only item attributes, not container
	// children. Normal house serialization traverses the live children once.
	const auto projection = source->Item::clone();
	if (!projection) {
		g_logger().error("Cannot project World attributes for house persistence: {}", id);
		return false;
	}
	applyAttributes(projection, binding.baseline);
	if (projection->getTeleport() && binding.baseDestination) {
		projection->getTeleport()->setDestPos(native(*binding.baseDestination));
	}
	if (object(id)->mode != world_layers::SourceMode::Map) {
		mark(projection, state->projectId, id);
	}
	if (source->getBed()) {
		// Bed's override serializes sleeper state only. Preserve that state and
		// append the projected general attributes/ownership without cloning it.
		source->serializeAttr(stream);
		projection->Item::serializeAttr(stream);
	} else {
		projection->serializeAttr(stream);
	}
	return true;
}

bool WorldLayerRuntime::allowLegacy(const WorldLegacyWrite &write, const std::shared_ptr<Item> &target) {
	if (state->mode == WorldConfigurationMode::Legacy) {
		return true;
	}
	if (state->mode == WorldConfigurationMode::World || state->failed) {
		return false;
	}
	std::error_code error;
	const auto file = std::filesystem::weakly_canonical(write.file, error);
	if (error) {
		state->failed = true;
		g_logger().error("Cannot identify legacy World source {}: {}", write.file.generic_string(), error.message());
		return false;
	}
	const LegacyKey key { file, write.table, write.key, write.occurrence, write.responsibility };
	if (state->legacyOwners.contains(key)) {
		// Disabled layers still own migrated responsibilities. Returning them to
		// the old loader requires an explicit migration reversal.
		return false;
	}
	std::string claimed;
	if (target) {
		if (state->applied) {
			claimed = identity(target);
		} else {
			const auto it = state->baseIdentities.find(target.get());
			if (it != state->baseIdentities.end()) {
				for (const auto &entry : state->basePlan.objects) {
					if (entry.id == it->second && state->originals.at(entry.original).lock() == target) {
						claimed = it->second;
						break;
					}
				}
			}
		}
	}
	const auto owns = [&](const world_layers::Object &object) {
		if (write.responsibility == "attributes.aid") {
			return object.aidOverride || object.aid != 0;
		}
		if (write.responsibility == "attributes.uid") {
			return object.uidOverride || object.uid != 0;
		}
		if (write.responsibility.starts_with("attributes.")) {
			return object.attributes.contains(write.responsibility.substr(11));
		}
		if (write.responsibility == "creation") {
			return object.mode != world_layers::SourceMode::Map;
		}
		if (write.responsibility == "replacement") {
			return object.mode == world_layers::SourceMode::Replace;
		}
		for (const auto &binding : object.behaviors) {
			if (std::find(binding.events.begin(), binding.events.end(), write.responsibility) != binding.events.end()) {
				return true;
			}
		}
		return false;
	};
	bool overlap = !claimed.empty() && object(claimed) && owns(*object(claimed));
	if (!overlap && write.responsibility == "creation") {
		for (const auto &layer : state->project->layers) {
			if (!layer.enabled) {
				continue;
			}
			for (const auto &candidate : layer.objects) {
				if (candidate.kind == world_layers::ObjectKind::Item && candidate.mode != world_layers::SourceMode::Map && candidate.itemId == write.itemId && world_layers::objectPosition(*state->project, candidate) == write.position) {
					claimed = world_layers::objectId(layer, candidate);
					overlap = true;
					break;
				}
			}
		}
	}
	if (overlap) {
		state->failed = true;
		g_logger().error("Unresolved World/legacy overlap: {} {}[{}] occurrence {}, responsibility {}, World object {}", file.generic_string(), write.table, write.key, write.occurrence, write.responsibility, claimed);
		return false;
	}
	return true;
}

bool WorldLayerRuntime::allowLuaCreation(const world_layers::Position &position, uint16_t itemId) {
	if (!state->project) {
		return true;
	}
	for (const auto &layer : state->project->layers) {
		if (!layer.enabled) {
			continue;
		}
		for (const auto &object : layer.objects) {
			if (object.kind == world_layers::ObjectKind::Item && object.mode != world_layers::SourceMode::Map && object.itemId == itemId && world_layers::objectPosition(*state->project, object) == position) {
				g_logger().error("Lua position registration creates item {} already owned by World object {}", itemId, world_layers::objectId(layer, object));
				state->failed = true;
				return false;
			}
		}
	}
	return true;
}

WorldPersistence WorldLayerRuntime::persistence(const std::shared_ptr<Item> &item) {
	if (!state->project || !item) {
		return WorldPersistence::Ordinary;
	}
	const auto owner = item->getCustomAttribute("__world.project");
	const auto key = item->getCustomAttribute("__world.object");
	if (!owner && !key) {
		return WorldPersistence::Ordinary;
	}
	const auto id = marker(item, state->projectId);
	const auto definition = object(id);
	if (id.empty() || !definition || definition->mode == world_layers::SourceMode::Map) {
		g_logger().error("Persisted World ownership is missing, disabled, or belongs to another project (item {}). Reconcile it before startup", item->getID());
		state->failed = true;
		return WorldPersistence::Conflict;
	}
	return WorldPersistence::External;
}

void WorldLayerRuntime::restored(const std::shared_ptr<Item> &item) {
	const auto id = marker(item, state->projectId);
	if (!id.empty()) {
		state->restoredItems[id].push_back(item);
	}
}

void WorldLayerRuntime::persistenceError() {
	state->failed = true;
	g_logger().error("World startup aborted after house item deserialization failed; stored data was not replaced");
}

bool WorldLayerRuntime::isFixture(const Item* item) const {
	if (!state->applied || !item) {
		return false;
	}
	const auto found = state->identities.find(item);
	if (found == state->identities.end()) {
		return false;
	}
	const auto binding = state->bindings.find(found->second);
	const auto definition = object(found->second);
	return binding != state->bindings.end() && binding->second.item.lock().get() == item && definition && definition->lifecycle == world_layers::Lifecycle::Fixture;
}
