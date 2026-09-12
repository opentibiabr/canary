#include "world/world_effective.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <functional>
	#include <map>
	#include <set>
#endif

namespace world_layers {
	namespace {
		struct Definition {
			const Object* object = nullptr;
			const Layer* layer = nullptr;
			std::string id;
			MapItem original;
			bool resolved = false;
		};

		const char* confidenceName(EffectiveConfidence value) {
			switch (value) {
				case EffectiveConfidence::Proven:
					return "proven";
				case EffectiveConfidence::Predicted:
					return "predicted";
				case EffectiveConfidence::Unknown:
					return "unknown";
			}
			return "unknown";
		}

		const char* ownerName(EffectiveOwner value) {
			switch (value) {
				case EffectiveOwner::BaseMap:
					return "otbm";
				case EffectiveOwner::Legacy:
					return "legacy";
				case EffectiveOwner::World:
					return "world";
				case EffectiveOwner::SuspendedWorld:
					return "suspendedWorld";
				case EffectiveOwner::Unknown:
					return "unknown";
			}
			return "unknown";
		}

		bool sameClaim(const MigrationClaim &claim, const LegacyIdentifierWrite &write, const std::string &responsibility) {
			return claim.kind == MigrationSourceKind::LuaTable
				&& claim.file.lexically_normal() == write.file.lexically_normal()
				&& claim.table == write.table && claim.key == write.key
				&& claim.declaration == write.declaration && claim.occurrence == write.occurrence
				&& std::find(claim.responsibilities.begin(), claim.responsibilities.end(), responsibility) != claim.responsibilities.end();
		}

		Value optionalNumber(const std::optional<uint16_t> &value) {
			return value ? Value { int64_t(*value) } : Value {};
		}

		Value identifierValue(const EffectiveIdentifierValue &value) {
			Value::List evidence;
			for (const auto &entry : value.evidence) {
				evidence.push_back(Value { entry });
			}
			return Value { Value::Record {
				{ "base", Value { int64_t(value.base) } },
				{ "world", optionalNumber(value.world) },
				{ "worldOverride", Value { value.worldOverride } },
				{ "legacy", optionalNumber(value.legacy) },
				{ "effective", optionalNumber(value.effective) },
				{ "confidence", Value { std::string(confidenceName(value.confidence)) } },
				{ "owner", Value { std::string(ownerName(value.owner)) } },
				{ "evidence", Value { evidence } },
			} };
		}
	}

	bool buildEffectiveWorldModel(const Project &project, MapView &map, EffectiveMode mode, const std::vector<LegacyIdentifierWrite> &legacyWrites, EffectiveWorldModel &model, Diagnostics &diagnostics, const std::function<bool()> &cancelled) {
		const auto initialErrors = diagnostics.size();
		EffectiveWorldModel staged;
		staged.mode = mode;
		std::map<uint64_t, size_t> byKey;
		for (const auto &entry : map.identifiers()) {
			if (cancelled && cancelled()) {
				return false;
			}
			EffectiveIdentifierInstance instance;
			instance.base = entry;
			instance.aid.base = entry.aid;
			instance.aid.effective = entry.aid;
			instance.uid.base = entry.uid;
			instance.uid.effective = entry.uid;
			byKey.emplace(entry.key, staged.instances.size());
			staged.instances.push_back(std::move(instance));
		}

		std::map<std::string, Definition> definitions;
		for (const auto &layer : project.layers) {
			for (const auto &object : layer.objects) {
				if (cancelled && cancelled()) {
					return false;
				}
				const auto id = objectId(layer, object);
				definitions.emplace(id, Definition { &object, &layer, id });
			}
		}
		std::set<std::string> visiting;
		std::function<bool(Definition &)> resolve = [&](Definition &definition) {
			if (definition.resolved || !definition.object->selector) {
				return definition.resolved;
			}
			if (!visiting.insert(definition.id).second) {
				diagnostics.push_back({ definition.layer->file, definition.id, "/source/selector", "Cyclic base-item selection dependency" });
				return false;
			}
			const auto &selector = *definition.object->selector;
			std::vector<MapItem> candidates;
			if (selector.container.empty()) {
				candidates = map.selectionTile(selector.position).items;
			} else {
				const auto parent = definitions.find(selector.container);
				if (parent == definitions.end() || !resolve(parent->second)) {
					diagnostics.push_back({ definition.layer->file, definition.id, "/source/selector/container", "Cannot resolve the declared base container" });
					visiting.erase(definition.id);
					return false;
				}
				candidates = parent->second.original.children;
			}
			std::string error;
			definition.resolved = resolveSelector(selector, candidates, definition.original, error);
			visiting.erase(definition.id);
			if (!definition.resolved) {
				diagnostics.push_back({ definition.layer->file, definition.id, "/source/selector", error });
			}
			return definition.resolved;
		};

		std::map<uint64_t, std::string> identities;
		for (auto &[id, definition] : definitions) {
			if (cancelled && cancelled()) {
				return false;
			}
			const auto &object = *definition.object;
			const bool active = definition.layer->enabled;
			if (object.kind != ObjectKind::Item) {
				continue;
			}
			EffectiveIdentifierInstance* instance = nullptr;
			if (object.selector && resolve(definition)) {
				const auto [owner, inserted] = identities.emplace(definition.original.key, id);
				if (!inserted && owner->second != id) {
					diagnostics.push_back({ definition.layer->file, id, "/source/selector", "Base item already has World identity " + owner->second });
					continue;
				}
				auto found = byKey.find(definition.original.key);
				if (found == byKey.end()) {
					IdentifierOccurrence occurrence { definition.original.key, definition.object->selector->position, definition.original.itemId, definition.original.aid, definition.original.uid, definition.original.ground };
					found = byKey.emplace(definition.original.key, staged.instances.size()).first;
					EffectiveIdentifierInstance added;
					added.base = std::move(occurrence);
					added.aid.base = definition.original.aid;
					added.aid.effective = definition.original.aid;
					added.uid.base = definition.original.uid;
					added.uid.effective = definition.original.uid;
					staged.instances.push_back(std::move(added));
				}
				instance = &staged.instances[found->second];
			} else if (object.mode == SourceMode::Create && active) {
				staged.instances.emplace_back();
				instance = &staged.instances.back();
				instance->base.position = object.position;
				instance->base.itemId = object.itemId;
			}
			if (!instance) {
				continue;
			}
			if (!instance->object.empty() && instance->object != id) {
				diagnostics.push_back({ definition.layer->file, id, "/source", "World identity overlaps " + instance->object });
				continue;
			}
			instance->object = id;
			instance->worldActive = instance->worldActive || active;
			instance->worldDisabled = instance->worldDisabled || !active;
			instance->replacement = object.mode == SourceMode::Replace;
			const auto applyDefinition = [&](EffectiveIdentifierValue &value, bool overrideValue, uint16_t declared) {
				value.worldOverride = overrideValue;
				if (object.mode != SourceMode::Map) {
					value.world = overrideValue ? declared : 0;
				} else if (overrideValue) {
					value.world = declared;
				}
			};
			applyDefinition(instance->aid, object.aidOverride, object.aid);
			applyDefinition(instance->uid, object.uidOverride, object.uid);
		}

		const auto legacyEnabled = mode != EffectiveMode::World;
		for (const auto &write : legacyWrites) {
			if (cancelled && cancelled()) {
				return false;
			}
			if (!legacyEnabled) {
				continue;
			}
			auto found = byKey.find(write.itemKey);
			if (write.itemKey && found == byKey.end() && write.base && write.base->key == write.itemKey) {
				EffectiveIdentifierInstance added;
				added.base = *write.base;
				added.aid.base = write.base->aid;
				added.aid.effective = write.base->aid;
				added.uid.base = write.base->uid;
				added.uid.effective = write.base->uid;
				found = byKey.emplace(write.itemKey, staged.instances.size()).first;
				staged.instances.push_back(std::move(added));
			}
			if (!write.itemKey || found == byKey.end()) {
				if (write.property == IdentifierProperty::Uid && write.confidence != EffectiveConfidence::Proven) {
					staged.uidComplete = false;
				}
				continue;
			}
			auto &instance = staged.instances[found->second];
			auto &value = write.property == IdentifierProperty::Aid ? instance.aid : instance.uid;
			const auto responsibility = write.property == IdentifierProperty::Aid ? "attributes.aid" : "attributes.uid";
			const MigrationClaim* claim = nullptr;
			for (const auto &record : project.migrationRecords) {
				const auto match = std::find_if(record.claims.begin(), record.claims.end(), [&](const auto &candidate) { return sameClaim(candidate, write, responsibility); });
				if (match != record.claims.end()) {
					claim = &*match;
					break;
				}
			}
			if (claim) {
				if (instance.object != claim->object) {
					diagnostics.push_back({ write.file, claim->object, "/claims", "Claimed legacy write resolves to a different base item" });
				}
				value.evidence.push_back("suppressed legacy: " + write.evidence);
				if (!instance.worldActive) {
					value.owner = EffectiveOwner::SuspendedWorld;
				}
				continue;
			}
			if (mode == EffectiveMode::Mixed && instance.worldActive && value.worldOverride) {
				diagnostics.push_back({ write.file, instance.object, "/claims", "Legacy and World both own this identifier responsibility" });
				continue;
			}
			value.legacy = write.value;
			value.effective = write.value;
			value.confidence = write.confidence;
			value.owner = write.confidence == EffectiveConfidence::Unknown ? EffectiveOwner::Unknown : EffectiveOwner::Legacy;
			value.evidence.push_back(write.evidence);
			if (write.property == IdentifierProperty::Uid && (write.confidence != EffectiveConfidence::Proven || !write.value)) {
				staged.uidComplete = false;
			}
		}

		if (mode != EffectiveMode::Legacy) {
			for (auto &instance : staged.instances) {
				if (!instance.worldActive) {
					continue;
				}
				const auto apply = [&](EffectiveIdentifierValue &value) {
					if (value.world) {
						value.effective = value.world;
						value.confidence = EffectiveConfidence::Proven;
						value.owner = EffectiveOwner::World;
						value.evidence.push_back("active World declaration");
					}
				};
				apply(instance.aid);
				apply(instance.uid);
			}
		}

		std::map<uint16_t, std::string> uids;
		for (const auto &instance : staged.instances) {
			if (cancelled && cancelled()) {
				return false;
			}
			if (instance.uid.confidence != EffectiveConfidence::Proven || !instance.uid.effective) {
				continue;
			}
			const auto uid = *instance.uid.effective;
			if (!uid) {
				continue;
			}
			const auto identity = instance.object.empty() ? "base item " + std::to_string(instance.base.key) : instance.object;
			const auto [first, inserted] = uids.emplace(uid, identity);
			if (!inserted) {
				diagnostics.push_back({ project.file, identity, "/attributes/uid", "Duplicate effective UID " + std::to_string(uid) + "; already used by " + first->second });
			}
		}
		if (diagnostics.size() != initialErrors) {
			return false;
		}
		model = std::move(staged);
		return true;
	}

	Value effectiveWorldValue(const EffectiveWorldModel &model) {
		Value::List instances;
		for (const auto &instance : model.instances) {
			Value::List containers;
			for (const auto key : instance.base.containers) {
				containers.push_back(Value { int64_t(key) });
			}
			Value::Record record {
				{ "key", Value { int64_t(instance.base.key) } },
				{ "position", Value { Value::Record { { "x", Value { int64_t(instance.base.position.x) } }, { "y", Value { int64_t(instance.base.position.y) } }, { "z", Value { int64_t(instance.base.position.z) } } } } },
				{ "itemId", Value { int64_t(instance.base.itemId) } },
				{ "object", Value { instance.object } },
				{ "worldActive", Value { instance.worldActive } },
				{ "worldDisabled", Value { instance.worldDisabled } },
				{ "replacement", Value { instance.replacement } },
				{ "containers", Value { containers } },
				{ "aid", identifierValue(instance.aid) },
				{ "uid", identifierValue(instance.uid) },
			};
			instances.push_back(Value { record });
		}
		const char* mode = model.mode == EffectiveMode::Legacy ? "legacy" : model.mode == EffectiveMode::World ? "world"
																											   : "mixed";
		return Value { Value::Record {
			{ "mode", Value { std::string(mode) } },
			{ "uidComplete", Value { model.uidComplete } },
			{ "instances", Value { instances } },
		} };
	}

} // namespace world_layers
