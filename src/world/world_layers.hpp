#pragma once

#include <cstdint>
#include <filesystem>
#include <optional>
#include <map>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>
#include <variant>

namespace world_layers {

	struct Position {
		int32_t x = 0;
		int32_t y = 0;
		int32_t z = 0;
		bool operator==(const Position &) const = default;
	};

	struct Replacement {
		Position position;
		uint16_t itemId = 0;
		bool operator==(const Replacement &) const = default;
	};

	struct Teleport {
		std::string destination;
		Position destinationOffset;
		bool operator==(const Teleport &) const = default;
	};

	// Values are owned snapshots. Neither Lua nor editor widgets borrow mutable
	// storage from a live configuration document.
	struct Value {
		using List = std::vector<Value>;
		using Record = std::map<std::string, Value>;
		std::variant<std::monostate, bool, int64_t, double, std::string, List, Record> data;
		bool operator==(const Value &) const = default;
	};

	struct Reference {
		std::string object;
		Position offset;
		bool operator==(const Reference &) const = default;
	};

	struct Occurrence {
		uint32_t index = 0;
		uint32_t count = 0;
		std::string fingerprint;
		bool operator==(const Occurrence &) const = default;
	};

	struct Selector {
		Position position;
		std::string container;
		bool ground = false;
		uint16_t itemId = 0;
		Value::Record attributes;
		std::optional<Occurrence> occurrence;
		bool operator==(const Selector &) const = default;
	};

	enum class ObjectKind { Item,
		                    Anchor };
	enum class SourceMode { Map,
		                    Create,
		                    Replace };
	enum class Lifecycle { Native,
		                   Fixture,
		                   RefillOnStartup };

	struct BehaviorBinding {
		std::string id;
		uint32_t contractVersion = 1;
		std::vector<std::string> events;
		Value::Record parameters;
		std::map<std::string, std::vector<Reference>> relations;
		bool operator==(const BehaviorBinding &) const = default;
	};

	struct Parameter {
		std::string type, label, help;
		bool required = false;
		std::optional<Value> defaultValue;
		std::optional<double> minimum, maximum;
		std::vector<Value> choices;
		std::vector<std::string> capabilities;
		std::map<std::string, Parameter> fields;
		std::vector<Parameter> element; // exactly one schema for a list
	};

	struct RelationType {
		std::string targetKind, label, help;
		std::vector<std::string> capabilities;
		uint32_t minimum = 0, maximum = 1;
		bool allowOffset = false;
	};

	struct BehaviorDescriptor {
		std::filesystem::path file, script;
		std::string id, name, targetKind;
		uint32_t contractVersion = 1;
		std::vector<std::string> events;
		std::map<std::string, Parameter> parameters;
		std::map<std::string, RelationType> relations;
	};

	struct Object {
		std::string id;
		std::string name;
		Position position;
		uint16_t itemId = 0;
		uint16_t aid = 0;
		uint16_t uid = 0;
		std::optional<Replacement> replaces;
		std::optional<Teleport> teleport;
		ObjectKind kind = ObjectKind::Item;
		SourceMode mode = SourceMode::Create;
		Lifecycle lifecycle = Lifecycle::Fixture;
		std::optional<Selector> selector;
		std::string container;
		uint32_t order = 0;
		uint16_t count = 1;
		std::optional<uint16_t> subtype;
		bool aidOverride = false, uidOverride = false;
		Value::Record attributes;
		std::map<std::string, std::vector<Reference>> relations;
		std::vector<BehaviorBinding> behaviors;
		bool operator==(const Object &) const = default;
	};

	struct Layer {
		std::filesystem::path file;
		std::string schema;
		std::string id;
		std::string name;
		std::vector<Object> objects;
		uint32_t schemaVersion = 1;
		bool enabled = true;
	};

	struct Diagnostic {
		std::filesystem::path file;
		std::string object;
		std::string field;
		std::string message;
		std::string describe() const;
	};

	using Diagnostics = std::vector<Diagnostic>;

	struct LegacyClaim {
		std::filesystem::path file;
		std::string table, key, occurrence, fingerprint, object;
		uint32_t declaration = 1;
		std::vector<std::string> responsibilities;
	};

	struct MigrationRecord {
		std::filesystem::path file;
		std::string id;
		// SHA-256 of UTF-8 source with CRLF normalized to LF. These are
		// transition preconditions, not another operational configuration.
		std::map<std::filesystem::path, std::string> sources;
		std::vector<LegacyClaim> claims;
	};

	struct Project {
		std::filesystem::path file;
		std::filesystem::path map;
		std::filesystem::path items;
		std::vector<Layer> layers;
		std::unordered_map<std::string, std::pair<size_t, size_t>> objects;
		uint32_t schemaVersion = 1;
		std::string id, schema;
		std::vector<BehaviorDescriptor> behaviors;
		std::vector<std::filesystem::path> migrations;
		std::vector<MigrationRecord> migrationRecords;

		const Object* find(const std::string &id) const;
		Object* find(const std::string &id);
		std::string qualifiedId(size_t layer, size_t object) const;
		bool rebuildIndex(Diagnostics &diagnostics);
		const BehaviorDescriptor* behavior(const std::string &id) const;
		bool active(const std::string &id) const;
	};

	bool isValidPosition(const Position &position);
	std::optional<Position> destination(const Project &project, const Object &object);
	bool parseLayer(const std::string &source, const std::filesystem::path &file, Layer &layer, Diagnostics &diagnostics);
	using SourceFiles = std::map<std::filesystem::path, std::string>;
	bool loadProject(const std::filesystem::path &file, Project &project, Diagnostics &diagnostics, SourceFiles* sources = nullptr);
	bool readProjectSource(const std::filesystem::path &file, std::string &content, std::string &error, SourceFiles* sources);
	void validateProject(const Project &project, Diagnostics &diagnostics);
	std::string serializeLayer(const Layer &layer);
	bool readFile(const std::filesystem::path &file, std::string &content, std::string &error);
	std::string objectId(const Layer &layer, const Object &object);
	std::optional<Position> objectPosition(const Project &project, const Object &object);
	bool parseLayerV2(const std::string &source, const std::filesystem::path &file, Layer &layer, Diagnostics &diagnostics);
	bool loadProjectV2(const std::filesystem::path &file, Project &project, Diagnostics &diagnostics, SourceFiles* sources = nullptr);
	std::string serializeLayerV2(const Layer &layer);
	std::string serializeProject(const Project &project);
	void validateProjectV2(const Project &project, Diagnostics &diagnostics);
	bool parseBehavior(const std::string &source, const std::filesystem::path &file, BehaviorDescriptor &descriptor, Diagnostics &diagnostics);
	bool validateParameter(const Parameter &schema, const Value &value, std::string &error);
	Value::Record resolveParameters(const BehaviorDescriptor &descriptor, const BehaviorBinding &binding);
	std::string serializeValue(const Value &value);
	bool parseValue(const std::string &source, Value &value, std::string &error);
	bool convertToV2(Project &project, Diagnostics &diagnostics);
	bool loadMigration(const std::filesystem::path &file, MigrationRecord &record, Diagnostics &diagnostics, SourceFiles* sources = nullptr);
	std::string serializeMigration(const MigrationRecord &record);

} // namespace world_layers
