#include "world/world_validation.hpp"
#include <iomanip>
#include <sstream>

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <functional>
	#include <set>
	#include <tuple>
#endif

namespace world_layers {
	namespace {
		Value::Record attributes(const MapItem &item) {
			auto result = item.attributes;
			result["aid"] = Value { int64_t(item.aid) };
			result["uid"] = Value { int64_t(item.uid) };
			return result;
		}

		bool matches(const MapItem &item, const Selector &selector) {
			if (item.itemId != selector.itemId || (selector.container.empty() && item.ground != selector.ground)) {
				return false;
			}
			const auto values = attributes(item);
			for (const auto &[name, expected] : selector.attributes) {
				const auto it = values.find(name);
				if (it == values.end() || it->second != expected) {
					return false;
				}
			}
			return true;
		}

		void descendants(const MapItem &item, std::unordered_set<uint64_t> &keys) {
			keys.insert(item.key);
			for (const auto &child : item.children) {
				descendants(child, keys);
			}
		}

		Value fingerprintItem(const MapItem &item) {
			Value::List children;
			for (const auto &child : item.children) {
				children.push_back(fingerprintItem(child));
			}
			return Value { Value::Record {
				{ "itemId", Value { int64_t(item.itemId) } },
				{ "ground", Value { item.ground } },
				{ "attributes", Value { attributes(item) } },
				{ "children", Value { std::move(children) } },
				{ "destination", Value { Value::Record { { "x", Value { int64_t(item.destination.x) } }, { "y", Value { int64_t(item.destination.y) } }, { "z", Value { int64_t(item.destination.z) } } } } } } };
		}

		using TileKey = std::tuple<int32_t, int32_t, int32_t>;
		TileKey tileKey(const Position &position) {
			return { position.x, position.y, position.z };
		}
	}

	bool MapView::knownItem(uint16_t itemId) const {
		return itemId != 0;
	}
	MapTile MapView::selectionTile(const Position &position) {
		return tile(position);
	}
	uint16_t MapView::effectiveUid(const MapItem &original) {
		return original.uid;
	}
	bool MapView::capability(uint16_t itemId, const std::string &name) const {
		return name == "teleport" && nativeTeleport(itemId);
	}

	std::string selectorFingerprint(const std::vector<MapItem> &items) {
		Value::List list;
		for (const auto &item : items) {
			list.push_back(fingerprintItem(item));
		}
		// The fingerprint is a revision precondition, not an authentication token.
		uint64_t hash = 14695981039346656037ULL;
		for (const auto ch : serializeValue(Value { std::move(list) })) {
			hash ^= static_cast<unsigned char>(ch);
			hash *= 1099511628211ULL;
		}
		std::ostringstream result;
		result << "fnv1a64:" << std::hex << std::setfill('0') << std::setw(16) << hash;
		return result.str();
	}

	bool resolveSelector(const Selector &selector, const std::vector<MapItem> &candidates, MapItem &selected, std::string &error) {
		std::vector<MapItem> matches;
		for (const auto &item : candidates) {
			if (world_layers::matches(item, selector)) {
				matches.push_back(item);
			}
		}
		size_t occurrence = 0;
		bool valid = matches.size() == 1;
		if (selector.occurrence) {
			occurrence = selector.occurrence->index;
			valid = matches.size() == selector.occurrence->count && occurrence < matches.size() && selectorFingerprint(matches) == selector.occurrence->fingerprint;
		}
		if (!valid) {
			error = "Expected one original, or matching occurrence preconditions; found " + std::to_string(matches.size());
			return false;
		}
		selected = matches[occurrence];
		return true;
	}

	bool captureSelector(Selector &selector, const std::vector<MapItem> &candidates, uint64_t key, std::string &error) {
		std::vector<MapItem> selected;
		std::optional<uint32_t> occurrence;
		for (const auto &candidate : candidates) {
			if (matches(candidate, selector)) {
				if (candidate.key == key) {
					occurrence = static_cast<uint32_t>(selected.size());
				}
				selected.push_back(candidate);
			}
		}
		if (!key || !occurrence) {
			error = "The selected base item no longer matches this selector";
			return false;
		}
		if (selected.size() == 1 && !selector.occurrence) {
			selector.occurrence.reset();
		} else {
			selector.occurrence = Occurrence { *occurrence, static_cast<uint32_t>(selected.size()), selectorFingerprint(selected) };
		}
		return true;
	}

	bool validateMapV2(const Project &project, MapView &map, ApplicationPlan &plan, Diagnostics &diagnostics) {
		const auto initialErrors = diagnostics.size();
		validateProjectV2(project, diagnostics);
		if (initialErrors != diagnostics.size()) {
			return false;
		}
		ApplicationPlan staged;
		std::map<std::string, MapItem> originals;
		std::map<std::string, size_t> resolved;
		std::set<std::string> visiting;
		std::map<uint64_t, std::string> claimed;
		std::map<TileKey, MapTile> tiles;
		const auto tile = [&](const Position &position) -> const MapTile & {
			const auto key = tileKey(position);
			const auto it = tiles.find(key);
			if (it != tiles.end()) {
				return it->second;
			}
			return tiles.emplace(key, map.tile(position)).first->second;
		};
		const auto fail = [&](const std::string &id, const std::string &field, const std::string &message) {
			const auto it = project.objects.find(id);
			diagnostics.push_back({ it == project.objects.end() ? project.file : project.layers[it->second.first].file, id, field, message });
		};
		std::function<bool(const std::string &)> resolve;
		resolve = [&](const std::string &id) {
			if (resolved.contains(id)) {
				return true;
			}
			const auto* object = project.find(id);
			if (!object || !project.active(id)) {
				fail(id, "/source", "Missing or disabled object");
				return false;
			}
			if (!visiting.insert(id).second) {
				fail(id, "/source", "Cyclic containment or selection dependency");
				return false;
			}
			ResolvedObject entry;
			entry.id = id;
			entry.position = objectPosition(project, *object).value_or(Position {});
			if (object->kind == ObjectKind::Item) {
				if (!map.knownItem(object->itemId)) {
					fail(id, "/source/itemId", "Unknown item ID");
				}
				if (object->selector) {
					const auto &selector = *object->selector;
					std::vector<MapItem> candidates;
					if (!selector.container.empty()) {
						if (!resolve(selector.container)) {
							return false;
						}
						const auto parent = originals.find(selector.container);
						if (parent == originals.end() || !parent->second.container) {
							fail(id, "/source/selector/container", "Selection requires an original container from the base map");
						} else {
							candidates = parent->second.children;
						}
					} else {
						candidates = map.selectionTile(selector.position).items;
					}
					MapItem original;
					std::string error;
					if (!resolveSelector(selector, candidates, original, error)) {
						fail(id, "/source/selector", error);
					} else {
						entry.original = original.key;
						if (!entry.original || !claimed.emplace(entry.original, id).second) {
							fail(id, "/source/selector", "An original item can have only one World identity");
						}
						originals[id] = original;
						if (object->mode == SourceMode::Replace) {
							descendants(original, staged.originals);
						} else {
							entry.effectiveUid = map.effectiveUid(original);
						}
					}
				} else if (object->replaces) {
					const auto &base = tile(object->replaces->position);
					std::vector<MapItem> candidates;
					for (const auto &item : base.items) {
						if (item.itemId == object->replaces->itemId) {
							candidates.push_back(item);
						}
					}
					if (candidates.size() != 1) {
						fail(id, "/origin/replaces", "Expected exactly one original");
					} else {
						entry.original = candidates.front().key;
						originals[id] = candidates.front();
						descendants(candidates.front(), staged.originals);
					}
				}
				if (object->uidOverride || object->uid) {
					entry.effectiveUid = object->uid;
				}
				if (!object->container.empty()) {
					if (!resolve(object->container)) {
						return false;
					}
					const auto* parent = project.find(object->container);
					if (!parent || parent->kind != ObjectKind::Item || !map.capability(parent->itemId, "container")) {
						fail(id, "/source/placement/container", "Placement requires a container");
					}
				} else {
					const auto &placement = tile(entry.position);
					if (!placement.exists || (object->mode != SourceMode::Map && !placement.ground)) {
						fail(id, "/source/placement", "Expected an existing tile; external placement also requires ground");
					}
				}
				if (object->teleport) {
					if (!map.nativeTeleport(object->itemId)) {
						fail(id, "/components/type", "Teleport component requires a native teleport item");
					}
					const auto* target = project.find(object->teleport->destination);
					const auto targetPosition = target ? objectPosition(project, *target) : std::nullopt;
					if (targetPosition) {
						const auto &offset = object->teleport->destinationOffset;
						entry.destination = Position { targetPosition->x + offset.x, targetPosition->y + offset.y, targetPosition->z + offset.z };
						const auto &arrival = tile(*entry.destination);
						if (!arrival.exists || !arrival.ground || arrival.blocked) {
							fail(id, "/components/destination", "Arrival requires an existing unblocked tile with ground");
						}
					}
				}
			}
			visiting.erase(id);
			resolved[id] = staged.objects.size();
			staged.objects.push_back(entry);
			return true;
		};
		for (const auto &layer : project.layers) {
			if (layer.enabled) {
				for (const auto &object : layer.objects) {
					resolve(objectId(layer, object));
				}
			}
		}
		if (initialErrors != diagnostics.size()) {
			return false;
		}

		for (const auto &[owner, original] : originals) {
			if (project.find(owner)->mode != SourceMode::Replace) {
				continue;
			}
			std::unordered_set<uint64_t> consumed;
			descendants(original, consumed);
			for (const auto &[other, selected] : originals) {
				if (other != owner && consumed.contains(selected.key)) {
					fail(other, "/source/selector", "The selected original is consumed by replacement " + owner);
				}
			}
		}

		std::map<uint16_t, std::string> effective;
		for (const auto &entry : staged.objects) {
			if (entry.original && staged.originals.contains(entry.original) && project.find(entry.id)->mode == SourceMode::Map) {
				fail(entry.id, "/source/selector", "This original is inside a replaced container");
			}
			if (entry.effectiveUid && !effective.emplace(entry.effectiveUid, entry.id).second) {
				fail(entry.id, "/attributes/uid", "Duplicate effective UID: " + effective[entry.effectiveUid]);
			}
		}
		for (const auto &occurrence : map.uniqueIds({})) {
			if (staged.originals.contains(occurrence.key) || claimed.contains(occurrence.key)) {
				continue;
			}
			const auto identity = "base item " + std::to_string(occurrence.key);
			if (occurrence.uid && !effective.emplace(occurrence.uid, identity).second) {
				fail("", "/attributes/uid", "Duplicate effective UID " + std::to_string(occurrence.uid) + " at " + std::to_string(occurrence.position.x) + "," + std::to_string(occurrence.position.y) + "," + std::to_string(occurrence.position.z) + "; already used by " + effective.at(occurrence.uid));
			}
		}

		std::map<TileKey, const ResolvedObject*> portals;
		for (const auto &entry : staged.objects) {
			const auto* object = project.find(entry.id);
			if (!object || object->kind != ObjectKind::Item || !object->container.empty() || !map.nativeTeleport(object->itemId)) {
				continue;
			}
			if (!portals.emplace(tileKey(entry.position), &entry).second) {
				fail(entry.id, "/source/placement", "Multiple native teleports occupy the same tile");
			}
			for (const auto &item : tile(entry.position).items) {
				if (item.teleport && item.key != entry.original && !staged.originals.contains(item.key) && !claimed.contains(item.key)) {
					fail(entry.id, "/source/placement", "Another native teleport occupies this tile");
				}
			}
		}
		for (const auto &[position, portal] : portals) {
			std::set<TileKey> visited { position };
			auto next = portal->destination;
			if (!next && originals.contains(portal->id) && isValidPosition(originals.at(portal->id).destination)) {
				next = originals.at(portal->id).destination;
			}
			while (next && isValidPosition(*next)) {
				if (!visited.insert(tileKey(*next)).second) {
					fail(portal->id, "/components/destination", "Effective teleport cycle");
					break;
				}
				const auto generated = portals.find(tileKey(*next));
				if (generated != portals.end()) {
					next = generated->second->destination;
					if (!next && originals.contains(generated->second->id) && isValidPosition(originals.at(generated->second->id).destination)) {
						next = originals.at(generated->second->id).destination;
					}
				} else {
					const auto &base = tile(*next);
					next.reset();
					for (const auto &item : base.items) {
						if (item.teleport && !staged.originals.contains(item.key)) {
							next = item.destination;
							break;
						}
					}
				}
			}
		}

		std::function<void(const Parameter &, const Value &, const std::string &, const std::string &)> validateValue;
		validateValue = [&](const Parameter &schema, const Value &value, const std::string &id, const std::string &field) {
			if (schema.type == "itemId") {
				const auto itemId = static_cast<uint16_t>(std::get<int64_t>(value.data));
				if (!map.knownItem(itemId)) {
					fail(id, field, "Unknown item ID");
				}
				for (const auto &capability : schema.capabilities) {
					if (!map.capability(itemId, capability)) {
						fail(id, field, "Item lacks capability: " + capability);
					}
				}
			} else if (schema.type == "objectRef") {
				const auto &record = std::get<Value::Record>(value.data);
				const auto &target = std::get<std::string>(record.at("object").data);
				if (!project.active(target)) {
					fail(id, field, "Missing or disabled object: " + target);
				}
			} else if (schema.type == "list") {
				for (const auto &entry : std::get<Value::List>(value.data)) {
					validateValue(schema.element.front(), entry, id, field);
				}
			} else if (schema.type == "record") {
				const auto &record = std::get<Value::Record>(value.data);
				for (const auto &[name, child] : schema.fields) {
					const auto it = record.find(name);
					if (it != record.end()) {
						validateValue(child, it->second, id, field + "/" + name);
					} else if (child.defaultValue) {
						validateValue(child, *child.defaultValue, id, field + "/" + name);
					}
				}
			}
		};
		for (const auto &layer : project.layers) {
			if (layer.enabled) {
				for (const auto &object : layer.objects) {
					const auto id = objectId(layer, object);
					for (const auto &binding : object.behaviors) {
						const auto* descriptor = project.behavior(binding.id);
						for (const auto &[name, parameter] : descriptor->parameters) {
							const auto it = binding.parameters.find(name);
							if (it != binding.parameters.end()) {
								validateValue(parameter, it->second, id, "/behaviors/parameters/" + name);
							} else if (parameter.defaultValue) {
								validateValue(parameter, *parameter.defaultValue, id, "/behaviors/parameters/" + name);
							}
						}
						for (const auto &[name, references] : binding.relations) {
							for (const auto &reference : references) {
								const auto* target = project.find(reference.object);
								for (const auto &capability : descriptor->relations.at(name).capabilities) {
									if (!target || !map.capability(target->itemId, capability)) {
										fail(id, "/behaviors/relations/" + name, "Target lacks capability: " + capability);
									}
								}
							}
						}
					}
				}
			}
		}
		if (initialErrors != diagnostics.size()) {
			return false;
		}
		plan = std::move(staged);
		return true;
	}
} // namespace world_layers
