#pragma once

#include "world/world_validation.hpp"

#include <functional>

namespace world_layers {

	enum class EffectiveMode { Legacy,
		                       World,
		                       Mixed };
	enum class EffectiveConfidence { Proven,
		                             Predicted,
		                             Unknown };
	enum class EffectiveOwner { BaseMap,
		                        Legacy,
		                        World,
		                        SuspendedWorld,
		                        Unknown };
	enum class IdentifierProperty { Aid,
		                            Uid };

	struct LegacyIdentifierWrite {
		uint64_t itemKey = 0;
		// Required when the base item has no identifier and is therefore absent
		// from the compact identifier census.
		std::optional<IdentifierOccurrence> base;
		IdentifierProperty property = IdentifierProperty::Aid;
		std::optional<uint16_t> value;
		EffectiveConfidence confidence = EffectiveConfidence::Unknown;
		std::filesystem::path file;
		std::string table;
		std::string key;
		std::string occurrence;
		std::string evidence;
		uint32_t declaration = 1;
	};

	struct EffectiveIdentifierValue {
		uint16_t base = 0;
		std::optional<uint16_t> world;
		std::optional<uint16_t> legacy;
		std::optional<uint16_t> effective;
		EffectiveConfidence confidence = EffectiveConfidence::Proven;
		EffectiveOwner owner = EffectiveOwner::BaseMap;
		bool worldOverride = false;
		std::vector<std::string> evidence;
	};

	struct EffectiveIdentifierInstance {
		IdentifierOccurrence base;
		std::string object;
		bool worldActive = false;
		bool worldDisabled = false;
		bool replacement = false;
		EffectiveIdentifierValue aid;
		EffectiveIdentifierValue uid;
	};

	struct EffectiveWorldModel {
		EffectiveMode mode = EffectiveMode::Legacy;
		std::vector<EffectiveIdentifierInstance> instances;
		bool uidComplete = true;
	};

	// Builds one canonical instance per base item, then overlays permitted legacy
	// writes and active World declarations. Legacy writes must be provided in the
	// exact order used by their loader. The function rejects unresolved overlap
	// between the two systems and duplicate proven effective UIDs.
	bool buildEffectiveWorldModel(const Project &project, MapView &map, EffectiveMode mode, const std::vector<LegacyIdentifierWrite> &legacyWrites, EffectiveWorldModel &model, Diagnostics &diagnostics, const std::function<bool()> &cancelled = {});
	Value effectiveWorldValue(const EffectiveWorldModel &model);

} // namespace world_layers
