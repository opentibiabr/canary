#include "world/world_layers.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <nlohmann/json.hpp>
	#include <algorithm>
	#include <cmath>
	#include <limits>
	#include <set>
	#include <tuple>
#endif

namespace world_layers {
	namespace {
		using Json = nlohmann::ordered_json;
		constexpr size_t MaxDepth = 128;

		Json encode(const Value &value) {
			return std::visit([](const auto &entry) -> Json {
				using T = std::decay_t<decltype(entry)>;
				if constexpr (std::is_same_v<T, std::monostate>) {
					return nullptr;
				} else if constexpr (std::is_same_v<T, Value::List>) {
					Json result = Json::array();
					for (const auto &child : entry) {
						result.push_back(encode(child));
					}
					return result;
				} else if constexpr (std::is_same_v<T, Value::Record>) {
					Json result = Json::object();
					for (const auto &[name, child] : entry) {
						result[name] = encode(child);
					}
					return result;
				} else {
					return entry;
				}
			},
			                  value.data);
		}

		Value decode(const Json &value) {
			Value result;
			if (value.is_boolean()) {
				result.data = value.get<bool>();
			} else if (value.is_number_integer()) {
				result.data = value.get<int64_t>();
			} else if (value.is_number()) {
				result.data = value.get<double>();
			} else if (value.is_string()) {
				result.data = value.get<std::string>();
			} else if (value.is_array()) {
				Value::List list;
				for (const auto &entry : value) {
					list.push_back(decode(entry));
				}
				result.data = std::move(list);
			} else if (value.is_object()) {
				Value::Record record;
				for (const auto &entry : value.items()) {
					record.emplace(entry.key(), decode(entry.value()));
				}
				result.data = std::move(record);
			}
			return result;
		}

		Json positionJson(const Position &position) {
			return { { "x", position.x }, { "y", position.y }, { "z", position.z } };
		}

		class Reader {
		public:
			Reader(const std::filesystem::path &file, Diagnostics &diagnostics) :
				file(file), diagnostics(diagnostics) { }
			std::string object;
			bool fail(const std::string &field, const std::string &message) {
				diagnostics.push_back({ file, object, field, message });
				return false;
			}
			bool keys(const Json &value, const std::string &field, std::initializer_list<const char*> allowed) {
				if (!value.is_object()) {
					return fail(field, "Expected an object");
				}
				for (const auto &entry : value.items()) {
					if (std::none_of(allowed.begin(), allowed.end(), [&](const char* name) { return name == entry.key(); })) {
						return fail(field + "/" + entry.key(), "Unsupported field");
					}
				}
				return true;
			}
			bool parse(const std::string &source, Json &result) {
				if (source.size() > 16 * 1024 * 1024) {
					return fail("", "Document exceeds 16 MiB");
				}
				std::vector<std::set<std::string>> names;
				std::string invalid;
				try {
					result = Json::parse(source, [&](int depth, Json::parse_event_t event, Json &value) {
						if (depth > static_cast<int>(MaxDepth)) {
							invalid = "JSON nesting exceeds 128";
						}
						if (event == Json::parse_event_t::object_start) {
							names.emplace_back();
						} else if (event == Json::parse_event_t::object_end) {
							names.pop_back();
						} else if (event == Json::parse_event_t::key && !names.back().insert(value.get<std::string>()).second) {
							invalid = "Duplicate JSON property: " + value.get<std::string>();
						} else if (event == Json::parse_event_t::value && value.is_number_unsigned() && value.get<uint64_t>() > uint64_t(std::numeric_limits<int64_t>::max())) {
							invalid = "Integer exceeds signed 64-bit range";
						}
						return depth <= static_cast<int>(MaxDepth);
					});
				} catch (const Json::exception &error) {
					return fail("", error.what());
				}
				return invalid.empty() || fail("", invalid);
			}
			bool text(const Json &value, const std::string &field, std::string &result) {
				if (!value.is_string()) {
					return fail(field, "Expected a string");
				}
				result = value.get<std::string>();
				return true;
			}
			bool identifier(const Json &value, const std::string &field, std::string &result) {
				if (!text(value, field, result)) {
					return false;
				}
				return (!result.empty() && result.size() <= 256 && result[0] >= 'a' && result[0] <= 'z' && std::all_of(result.begin(), result.end(), [](char ch) { return (ch >= 'a' && ch <= 'z') || (ch >= '0' && ch <= '9') || ch == '.' || ch == '_' || ch == '-'; })) || fail(field, "Invalid stable identifier");
			}
			bool integer(const Json &value, const std::string &field, int64_t minimum, int64_t maximum, int64_t &result) {
				if (!value.is_number_integer()) {
					return fail(field, "Expected an integer");
				}
				if (value.is_number_unsigned() && value.get<uint64_t>() > uint64_t(maximum)) {
					return fail(field, "Integer outside the supported range");
				}
				result = value.get<int64_t>();
				return (result >= minimum && result <= maximum) || fail(field, "Integer outside the supported range");
			}
			template <typename T>
			bool number(const Json &value, const std::string &field, T &result, int64_t minimum = 0, int64_t maximum = 65535) {
				int64_t number = 0;
				if (!integer(value, field, minimum, maximum, number)) {
					return false;
				}
				result = static_cast<T>(number);
				return true;
			}
			bool boolean(const Json &value, const std::string &field, bool &result) {
				if (!value.is_boolean()) {
					return fail(field, "Expected a boolean");
				}
				result = value.get<bool>();
				return true;
			}
			bool position(const Json &value, const std::string &field, Position &result, bool offset = false) {
				return keys(value, field, { "x", "y", "z" })
					&& number(value.value("x", Json()), field + "/x", result.x, offset ? -65535 : 0)
					&& number(value.value("y", Json()), field + "/y", result.y, offset ? -65535 : 0)
					&& number(value.value("z", Json()), field + "/z", result.z, offset ? -15 : 0, 15)
					&& (offset || isValidPosition(result) || fail(field, "The null position is not a map tile"));
			}
			bool strings(const Json &value, const std::string &field, std::vector<std::string> &result) {
				if (!value.is_array()) {
					return fail(field, "Expected an array of strings");
				}
				std::set<std::string> seen;
				for (const auto &entry : value) {
					std::string name;
					if (!text(entry, field, name) || name.empty() || !seen.insert(name).second) {
						return fail(field, "Expected distinct nonempty strings");
					}
					result.push_back(name);
				}
				return true;
			}
			bool relative(const Json &value, const std::string &field, std::filesystem::path &result) {
				std::string name;
				if (!text(value, field, name)) {
					return false;
				}
				const auto path = std::filesystem::u8path(name);
				if (name.empty() || path.is_absolute() || path.has_root_name() || name.find(':') != std::string::npos || name.find('\\') != std::string::npos) {
					return fail(field, "Expected a relative path using forward slashes");
				}
				std::error_code error;
				result = std::filesystem::weakly_canonical(file.parent_path() / path, error);
				return !error || fail(field, error.message());
			}

		private:
			const std::filesystem::path &file;
			Diagnostics &diagnostics;
		};

		bool readReference(Reader &reader, const Json &value, const std::string &field, Reference &reference) {
			return reader.keys(value, field, { "object", "offset" })
				&& reader.identifier(value.value("object", Json()), field + "/object", reference.object)
				&& (!value.contains("offset") || reader.position(value["offset"], field + "/offset", reference.offset, true));
		}

		bool readRelations(Reader &reader, const Json &value, const std::string &field, std::map<std::string, std::vector<Reference>> &relations) {
			if (!value.is_object()) {
				return reader.fail(field, "Expected named relations");
			}
			for (const auto &entry : value.items()) {
				std::vector<Reference> refs;
				const auto values = entry.value().is_array() ? entry.value() : Json::array({ entry.value() });
				for (const auto &target : values) {
					Reference ref;
					if (!readReference(reader, target, field + "/" + entry.key(), ref)) {
						return false;
					}
					refs.push_back(ref);
				}
				relations.emplace(entry.key(), std::move(refs));
			}
			return true;
		}

		bool readAttributes(Reader &reader, const Json &value, const std::string &field, Value::Record &attributes) {
			if (!reader.keys(value, field, { "aid", "uid", "text", "description", "name", "article", "plural", "writer", "date", "custom" })) {
				return false;
			}
			for (const auto &entry : value.items()) {
				const auto &name = entry.key();
				if (name == "aid" || name == "uid" || name == "date") {
					int64_t ignored = 0;
					if (!reader.integer(entry.value(), field + "/" + name, 0, name == "date" ? 0xffffffffLL : 65535, ignored)) {
						return false;
					}
				} else if (name == "custom") {
					if (!entry.value().is_object()) {
						return reader.fail(field + "/custom", "Expected named scalar attributes");
					}
					for (const auto &custom : entry.value().items()) {
						if (custom.key().empty() || custom.key().starts_with("__world.") || custom.value().is_structured() || custom.value().is_null()) {
							return reader.fail(field + "/custom/" + custom.key(), "Expected an application-owned scalar attribute");
						}
					}
				} else if (!entry.value().is_string()) {
					return reader.fail(field + "/" + name, "Expected a string");
				}
				attributes[name] = decode(entry.value());
			}
			return true;
		}

		bool readSelector(Reader &reader, const Json &value, Selector &selector) {
			const std::string field = "/source/selector";
			if (!reader.keys(value, field, { "position", "part", "container", "itemId", "attributes", "occurrence" })
			    || !reader.number(value.value("itemId", Json()), field + "/itemId", selector.itemId, 1)) {
				return false;
			}
			if (value.contains("container")) {
				if (value.contains("position") || value.contains("part")) {
					return reader.fail(field, "Container and tile selectors are mutually exclusive");
				}
				if (!reader.identifier(value["container"], field + "/container", selector.container)) {
					return false;
				}
			} else {
				if (!reader.position(value.value("position", Json()), field + "/position", selector.position)) {
					return false;
				}
				const auto part = value.value("part", Json());
				if (part != "ground" && part != "item") {
					return reader.fail(field + "/part", "Expected ground or item");
				}
				selector.ground = part == "ground";
			}
			if (value.contains("attributes") && !readAttributes(reader, value["attributes"], field + "/attributes", selector.attributes)) {
				return false;
			}
			if (value.contains("occurrence")) {
				Occurrence occurrence;
				const auto &item = value["occurrence"];
				if (!reader.keys(item, field + "/occurrence", { "index", "count", "fingerprint" })
				    || !reader.number(item.value("index", Json()), field + "/occurrence/index", occurrence.index, 0, 0xffffffffLL)
				    || !reader.number(item.value("count", Json()), field + "/occurrence/count", occurrence.count, 1, 0xffffffffLL)
				    || !reader.text(item.value("fingerprint", Json()), field + "/occurrence/fingerprint", occurrence.fingerprint)) {
					return false;
				}
				if (occurrence.index >= occurrence.count || occurrence.fingerprint.empty()) {
					return reader.fail(field + "/occurrence", "Occurrence requires a valid index, expected count and base fingerprint");
				}
				selector.occurrence = occurrence;
			}
			return true;
		}

		bool readBinding(Reader &reader, const Json &value, BehaviorBinding &binding) {
			if (!reader.keys(value, "/behaviors", { "id", "contractVersion", "events", "parameters", "relations" })
			    || !reader.identifier(value.value("id", Json()), "/behaviors/id", binding.id)
			    || !reader.number(value.value("contractVersion", Json()), "/behaviors/contractVersion", binding.contractVersion, 1, 0xffffffffLL)
			    || !reader.strings(value.value("events", Json()), "/behaviors/events", binding.events)) {
				return false;
			}
			if (binding.events.empty()) {
				return reader.fail("/behaviors/events", "A behavior must explicitly own at least one event");
			}
			if (value.contains("parameters")) {
				if (!value["parameters"].is_object()) {
					return reader.fail("/behaviors/parameters", "Expected named parameters");
				}
				binding.parameters = std::get<Value::Record>(decode(value["parameters"]).data);
			}
			return !value.contains("relations") || readRelations(reader, value["relations"], "/behaviors/relations", binding.relations);
		}

		bool readObject(Reader &reader, const Json &value, Object &object) {
			if (!reader.keys(value, "/objects", { "id", "name", "kind", "source", "position", "lifecycle", "attributes", "components", "relations", "behaviors" })
			    || !reader.identifier(value.value("id", Json()), "/id", object.id)) {
				return false;
			}
			reader.object = object.id;
			if (value.contains("name") && !reader.text(value["name"], "/name", object.name)) {
				return false;
			}
			const auto kind = value.value("kind", Json());
			if (kind != "item" && kind != "anchor") {
				return reader.fail("/kind", "Expected item or anchor");
			}
			object.kind = kind == "anchor" ? ObjectKind::Anchor : ObjectKind::Item;
			if (object.kind == ObjectKind::Anchor) {
				if (value.contains("source") || value.contains("attributes") || value.contains("components") || value.contains("lifecycle")) {
					return reader.fail("/kind", "An anchor has no gameplay item or item attributes");
				}
				if (!reader.position(value.value("position", Json()), "/position", object.position)) {
					return false;
				}
			} else {
				if (value.contains("position")) {
					return reader.fail("/position", "Item positions belong to source.selector or source.placement");
				}
				const auto source = value.value("source", Json());
				if (!reader.keys(source, "/source", { "mode", "selector", "itemId", "count", "subtype", "placement" })) {
					return false;
				}
				const auto mode = source.value("mode", Json());
				if (mode != "map" && mode != "create" && mode != "replace") {
					return reader.fail("/source/mode", "Expected map, create or replace");
				}
				object.mode = mode == "map" ? SourceMode::Map : mode == "create" ? SourceMode::Create
																				 : SourceMode::Replace;
				object.lifecycle = object.mode == SourceMode::Map ? Lifecycle::Native : Lifecycle::Fixture;
				if (object.mode != SourceMode::Create) {
					Selector selector;
					if (!readSelector(reader, source.value("selector", Json()), selector)) {
						return false;
					}
					object.selector = selector;
					object.position = selector.position;
					object.container = selector.container;
					object.itemId = selector.itemId;
				} else if (source.contains("selector")) {
					return reader.fail("/source/selector", "A create operation cannot consume an original");
				}
				if (object.mode == SourceMode::Map) {
					if (source.contains("itemId") || source.contains("count") || source.contains("subtype") || source.contains("placement")) {
						return reader.fail("/source", "A map binding selects an existing item without creating or moving it");
					}
				} else {
					if (!reader.number(source.value("itemId", Json()), "/source/itemId", object.itemId, 1)
					    || !reader.number(source.value("count", Json(1)), "/source/count", object.count, 1)) {
						return false;
					}
					if (source.contains("subtype")) {
						uint16_t subtype = 0;
						if (!reader.number(source["subtype"], "/source/subtype", subtype)) {
							return false;
						}
						object.subtype = subtype;
					}
					const auto placement = source.value("placement", Json());
					if (!reader.keys(placement, "/source/placement", { "position", "container", "order" })) {
						return false;
					}
					object.container.clear();
					if (placement.contains("container")) {
						if (placement.contains("position")) {
							return reader.fail("/source/placement", "Choose a tile or a container");
						}
						if (!reader.identifier(placement["container"], "/source/placement/container", object.container)
						    || !reader.number(placement.value("order", Json(0)), "/source/placement/order", object.order, 0, 0xffffffffLL)) {
							return false;
						}
					} else if (placement.contains("order") || !reader.position(placement.value("position", Json()), "/source/placement/position", object.position)) {
						return reader.fail("/source/placement", "Expected a position or container placement");
					}
				}
				if (value.contains("lifecycle")) {
					const auto policy = value["lifecycle"];
					if (policy != "native" && policy != "fixture" && policy != "refillOnStartup") {
						return reader.fail("/lifecycle", "Unsupported lifecycle policy");
					}
					object.lifecycle = policy == "native" ? Lifecycle::Native : policy == "fixture" ? Lifecycle::Fixture
																									: Lifecycle::RefillOnStartup;
					if (object.mode == SourceMode::Map && object.lifecycle == Lifecycle::RefillOnStartup) {
						return reader.fail("/lifecycle", "Map bindings cannot replenish items");
					}
					if (object.mode != SourceMode::Map && object.lifecycle == Lifecycle::Native) {
						return reader.fail("/lifecycle", "External items require an explicit managed lifecycle");
					}
				}
				if (value.contains("attributes")) {
					if (!readAttributes(reader, value["attributes"], "/attributes", object.attributes)) {
						return false;
					}
					object.aidOverride = object.attributes.contains("aid");
					object.uidOverride = object.attributes.contains("uid");
					if (object.aidOverride) {
						object.aid = static_cast<uint16_t>(std::get<int64_t>(object.attributes.at("aid").data));
					}
					if (object.uidOverride) {
						object.uid = static_cast<uint16_t>(std::get<int64_t>(object.attributes.at("uid").data));
					}
					object.attributes.erase("aid");
					object.attributes.erase("uid");
				}
				if (value.contains("components")) {
					if (!value["components"].is_array()) {
						return reader.fail("/components", "Expected an array");
					}
					for (const auto &component : value["components"]) {
						if (!reader.keys(component, "/components", { "type", "destination" })) {
							return false;
						}
						if (component.value("type", Json()) != "teleport" || object.teleport) {
							return reader.fail("/components/type", "Expected at most one teleport component");
						}
						Reference ref;
						if (!readReference(reader, component.value("destination", Json()), "/components/destination", ref)) {
							return false;
						}
						object.teleport = Teleport { ref.object, ref.offset };
					}
				}
			}
			if (value.contains("relations") && !readRelations(reader, value["relations"], "/relations", object.relations)) {
				return false;
			}
			if (value.contains("behaviors")) {
				if (!value["behaviors"].is_array()) {
					return reader.fail("/behaviors", "Expected an array");
				}
				for (const auto &entry : value["behaviors"]) {
					BehaviorBinding binding;
					if (!readBinding(reader, entry, binding)) {
						return false;
					}
					object.behaviors.push_back(std::move(binding));
				}
			}
			return true;
		}

		bool readParameter(Reader &reader, const Json &value, const std::string &field, Parameter &parameter, size_t depth = 0) {
			if (depth > MaxDepth) {
				return reader.fail(field, "Parameter nesting exceeds 128");
			}
			if (!reader.keys(value, field, { "type", "required", "default", "minimum", "maximum", "values", "enum", "label", "help", "capabilities", "fields", "items" })
			    || !reader.text(value.value("type", Json()), field + "/type", parameter.type)) {
				return false;
			}
			const std::set<std::string> types { "boolean", "integer", "number", "string", "enum", "itemId", "position", "offset", "objectRef", "list", "record" };
			if (!types.contains(parameter.type)) {
				return reader.fail(field + "/type", "Unknown parameter type");
			}
			if ((value.contains("fields") && parameter.type != "record") || (value.contains("items") && parameter.type != "list") || ((value.contains("values") || value.contains("enum")) && parameter.type != "enum")) {
				return reader.fail(field, "Type-specific schema fields do not match the parameter type");
			}
			if (value.contains("enum") && value.contains("values")) {
				return reader.fail(field, "Declare enum choices once");
			}
			if (value.contains("capabilities") && parameter.type != "itemId") {
				return reader.fail(field + "/capabilities", "Capabilities require an itemId parameter");
			}
			if (value.contains("required") && !reader.boolean(value["required"], field + "/required", parameter.required)) {
				return false;
			}
			if (value.contains("label") && !reader.text(value["label"], field + "/label", parameter.label)) {
				return false;
			}
			if (value.contains("help") && !reader.text(value["help"], field + "/help", parameter.help)) {
				return false;
			}
			if (value.contains("capabilities") && !reader.strings(value["capabilities"], field + "/capabilities", parameter.capabilities)) {
				return false;
			}
			for (const auto* name : { "minimum", "maximum" }) {
				if (value.contains(name)) {
					if (!value[name].is_number() || !std::isfinite(value[name].get<double>())) {
						return reader.fail(field + "/" + name, "Expected a finite numeric bound");
					}
					(name == std::string("minimum") ? parameter.minimum : parameter.maximum) = value[name].get<double>();
				}
			}
			if (parameter.minimum && parameter.maximum && *parameter.minimum > *parameter.maximum) {
				return reader.fail(field, "Minimum exceeds maximum");
			}
			if (parameter.type == "enum") {
				const auto choices = value.value("values", value.value("enum", Json()));
				if (!choices.is_array() || choices.empty()) {
					return reader.fail(field, "An enum requires values");
				}
				for (const auto &choice : choices) {
					if (choice.is_structured() || choice.is_null()) {
						return reader.fail(field, "Enum values must be scalars");
					}
					parameter.choices.push_back(decode(choice));
				}
			}
			if (parameter.type == "record") {
				if (!value.contains("fields") || !value["fields"].is_object()) {
					return reader.fail(field + "/fields", "A record requires typed fields");
				}
				for (const auto &entry : value["fields"].items()) {
					Parameter child;
					if (!readParameter(reader, entry.value(), field + "/fields/" + entry.key(), child, depth + 1)) {
						return false;
					}
					parameter.fields.emplace(entry.key(), std::move(child));
				}
			}
			if (parameter.type == "list") {
				Parameter child;
				if (!readParameter(reader, value.value("items", Json()), field + "/items", child, depth + 1)) {
					return false;
				}
				parameter.element.push_back(std::move(child));
			}
			if (value.contains("default")) {
				parameter.defaultValue = decode(value["default"]);
				std::string error;
				if (!validateParameter(parameter, *parameter.defaultValue, error)) {
					return reader.fail(field + "/default", error);
				}
			}
			return true;
		}

		Json referenceJson(const Reference &reference) {
			Json value = { { "object", reference.object } };
			if (reference.offset != Position {}) {
				value["offset"] = positionJson(reference.offset);
			}
			return value;
		}

		Json relationsJson(const std::map<std::string, std::vector<Reference>> &relations) {
			Json result = Json::object();
			for (const auto &[name, refs] : relations) {
				if (refs.size() == 1) {
					result[name] = referenceJson(refs.front());
				} else {
					result[name] = Json::array();
					for (const auto &ref : refs) {
						result[name].push_back(referenceJson(ref));
					}
				}
			}
			return result;
		}

		Json selectorJson(const Selector &selector) {
			Json value = Json::object();
			if (!selector.container.empty()) {
				value["container"] = selector.container;
			} else {
				value["position"] = positionJson(selector.position);
				value["part"] = selector.ground ? "ground" : "item";
			}
			value["itemId"] = selector.itemId;
			if (!selector.attributes.empty()) {
				value["attributes"] = encode(Value { selector.attributes });
			}
			if (selector.occurrence) {
				value["occurrence"] = { { "index", selector.occurrence->index }, { "count", selector.occurrence->count }, { "fingerprint", selector.occurrence->fingerprint } };
			}
			return value;
		}
	}

	std::string objectId(const Layer &layer, const Object &object) {
		return layer.schemaVersion == 1 ? layer.id + "." + object.id : object.id;
	}

	bool Project::rebuildIndex(Diagnostics &diagnostics) {
		objects.clear();
		bool valid = true;
		std::set<std::string> layerIds;
		for (size_t l = 0; l < layers.size(); ++l) {
			if (!layerIds.insert(layers[l].id).second) {
				diagnostics.push_back({ layers[l].file, "", "/id", "Duplicate layer identity" });
				valid = false;
			}
			for (size_t o = 0; o < layers[l].objects.size(); ++o) {
				const auto id = qualifiedId(l, o);
				if (!objects.emplace(id, std::pair(l, o)).second) {
					diagnostics.push_back({ layers[l].file, id, "/id", "Duplicate object identity" });
					valid = false;
				}
			}
		}
		return valid;
	}

	const BehaviorDescriptor* Project::behavior(const std::string &id) const {
		const auto it = std::find_if(behaviors.begin(), behaviors.end(), [&](const auto &entry) { return entry.id == id; });
		return it == behaviors.end() ? nullptr : &*it;
	}

	bool Project::active(const std::string &id) const {
		const auto it = objects.find(id);
		return it != objects.end() && layers[it->second.first].enabled;
	}

	std::optional<Position> objectPosition(const Project &project, const Object &object) {
		const Object* current = &object;
		std::set<const Object*> visited;
		while (visited.insert(current).second) {
			if (current->container.empty()) {
				return isValidPosition(current->position) ? std::optional(current->position) : std::nullopt;
			}
			current = project.find(current->container);
			if (!current) {
				return std::nullopt;
			}
		}
		return std::nullopt;
	}

	bool parseLayerV2(const std::string &source, const std::filesystem::path &file, Layer &layer, Diagnostics &diagnostics) {
		Reader reader(file, diagnostics);
		Json value;
		Layer parsed;
		parsed.file = file;
		parsed.schemaVersion = 2;
		if (!reader.parse(source, value) || !reader.keys(value, "", { "$schema", "schemaVersion", "id", "name", "objects" })) {
			return false;
		}
		if (!value.value("schemaVersion", Json()).is_number_integer() || value["schemaVersion"] != 2) {
			return reader.fail("/schemaVersion", "Expected integer schemaVersion 2");
		}
		if (!reader.identifier(value.value("id", Json()), "/id", parsed.id)) {
			return false;
		}
		if (value.contains("$schema") && !reader.text(value["$schema"], "/$schema", parsed.schema)) {
			return false;
		}
		if (value.contains("name") && !reader.text(value["name"], "/name", parsed.name)) {
			return false;
		}
		if (!value.contains("objects") || !value["objects"].is_array()) {
			return reader.fail("/objects", "Expected an array");
		}
		for (const auto &entry : value["objects"]) {
			Object object;
			if (!readObject(reader, entry, object)) {
				return false;
			}
			parsed.objects.push_back(std::move(object));
		}
		layer = std::move(parsed);
		return true;
	}

	bool parseBehavior(const std::string &source, const std::filesystem::path &file, BehaviorDescriptor &descriptor, Diagnostics &diagnostics) {
		Reader reader(file, diagnostics);
		Json value;
		BehaviorDescriptor parsed;
		parsed.file = file;
		if (!reader.parse(source, value) || !reader.keys(value, "", { "$schema", "schemaVersion", "id", "contractVersion", "name", "script", "targetKind", "events", "parameters", "relations" })) {
			return false;
		}
		if (!value.value("schemaVersion", Json()).is_number_integer() || value["schemaVersion"] != 2) {
			return reader.fail("/schemaVersion", "Expected integer schemaVersion 2");
		}
		if (!reader.identifier(value.value("id", Json()), "/id", parsed.id)
		    || !reader.number(value.value("contractVersion", Json()), "/contractVersion", parsed.contractVersion, 1, 0xffffffffLL)
		    || !reader.relative(value.value("script", Json()), "/script", parsed.script)
		    || !reader.text(value.value("targetKind", Json()), "/targetKind", parsed.targetKind)
		    || !reader.strings(value.value("events", Json()), "/events", parsed.events)) {
			return false;
		}
		if (parsed.targetKind != "item" && parsed.targetKind != "anchor") {
			return reader.fail("/targetKind", "Expected item or anchor");
		}
		if (value.contains("name") && !reader.text(value["name"], "/name", parsed.name)) {
			return false;
		}
		const std::set<std::string> events { "onUse", "onStepIn", "onStepOut", "onAddItem", "onRemoveItem" };
		if (parsed.events.empty()) {
			return reader.fail("/events", "Expected at least one supported event");
		}
		for (const auto &event : parsed.events) {
			if (!events.contains(event)) {
				return reader.fail("/events", "Unsupported event: " + event);
			}
		}
		if (value.contains("parameters")) {
			if (!value["parameters"].is_object()) {
				return reader.fail("/parameters", "Expected named parameter schemas");
			}
			for (const auto &entry : value["parameters"].items()) {
				Parameter parameter;
				if (!readParameter(reader, entry.value(), "/parameters/" + entry.key(), parameter)) {
					return false;
				}
				parsed.parameters.emplace(entry.key(), std::move(parameter));
			}
		}
		if (value.contains("relations")) {
			if (!value["relations"].is_object()) {
				return reader.fail("/relations", "Expected named relation schemas");
			}
			for (const auto &entry : value["relations"].items()) {
				const auto &schema = entry.value();
				const auto field = "/relations/" + entry.key();
				RelationType relation;
				bool required = false;
				if (!reader.keys(schema, field, { "type", "targetKind", "capabilities", "required", "allowOffset", "minimum", "maximum", "label", "help" })) {
					return false;
				}
				if (schema.value("type", Json()) != "objectRef") {
					return reader.fail(field + "/type", "Expected objectRef");
				}
				if (!reader.text(schema.value("targetKind", Json("item")), field + "/targetKind", relation.targetKind)
				    || !reader.boolean(schema.value("required", Json(false)), field + "/required", required)
				    || !reader.boolean(schema.value("allowOffset", Json(false)), field + "/allowOffset", relation.allowOffset)
				    || !reader.number(schema.value("minimum", Json(required ? 1 : 0)), field + "/minimum", relation.minimum, required ? 1 : 0, 65535)
				    || !reader.number(schema.value("maximum", Json(1)), field + "/maximum", relation.maximum, 1)) {
					return false;
				}
				if (relation.targetKind != "item" && relation.targetKind != "anchor") {
					return reader.fail(field + "/targetKind", "Expected item or anchor");
				}
				if (relation.minimum > relation.maximum) {
					return reader.fail(field, "Minimum cardinality exceeds maximum");
				}
				if (schema.contains("capabilities") && !reader.strings(schema["capabilities"], field + "/capabilities", relation.capabilities)) {
					return false;
				}
				if (schema.contains("label") && !reader.text(schema["label"], field + "/label", relation.label)) {
					return false;
				}
				if (schema.contains("help") && !reader.text(schema["help"], field + "/help", relation.help)) {
					return false;
				}
				parsed.relations.emplace(entry.key(), std::move(relation));
			}
		}
		descriptor = std::move(parsed);
		return true;
	}

	bool loadMigration(const std::filesystem::path &file, MigrationRecord &record, Diagnostics &diagnostics) {
		Reader reader(file, diagnostics);
		std::string source, error;
		Json json;
		if (!readFile(file, source, error)) {
			return reader.fail("", error);
		}
		if (!reader.parse(source, json) || !reader.keys(json, "", { "$schema", "schemaVersion", "id", "sources", "claims" })) {
			return false;
		}
		if (!json.contains("schemaVersion") || !json["schemaVersion"].is_number_integer() || json["schemaVersion"] != 2) {
			return reader.fail("/schemaVersion", "Expected schemaVersion 2");
		}
		MigrationRecord result;
		result.file = file;
		if (!reader.text(json.value("id", Json()), "/id", result.id) || result.id.empty()) {
			return reader.fail("/id", "Expected a migration identity");
		}
		if (!json.contains("sources") || !json["sources"].is_array() || !json.contains("claims") || !json["claims"].is_array()) {
			return reader.fail("", "Expected sources and claims arrays");
		}
		const auto hash = [&](const Json &value, const std::string &field, std::string &result) {
			if (!reader.text(value, field, result) || result.size() != 64 || !std::all_of(result.begin(), result.end(), [](char ch) { return (ch >= '0' && ch <= '9') || (ch >= 'a' && ch <= 'f'); })) {
				return reader.fail(field, "Expected lowercase SHA-256");
			}
			return true;
		};
		for (const auto &entry : json["sources"]) {
			std::filesystem::path path;
			std::string digest;
			if (!reader.keys(entry, "/sources", { "file", "sha256" }) || !reader.relative(entry.value("file", Json()), "/sources/file", path) || !hash(entry.value("sha256", Json()), "/sources/sha256", digest)) {
				return false;
			}
			if (!result.sources.emplace(path, digest).second) {
				return reader.fail("/sources", "Duplicate source path");
			}
		}
		std::set<std::tuple<std::filesystem::path, std::string, std::string, uint32_t, std::string, std::string, std::string>> claims;
		for (const auto &entry : json["claims"]) {
			LegacyClaim claim;
			if (!reader.keys(entry, "/claims", { "source", "occurrence", "object", "responsibilities" })) {
				return false;
			}
			const auto origin = entry.value("source", Json());
			if (!reader.keys(origin, "/claims/source", { "file", "table", "key", "declaration", "fingerprint" }) || !reader.relative(origin.value("file", Json()), "/claims/source/file", claim.file)) {
				return false;
			}
			if (!result.sources.contains(claim.file)) {
				return reader.fail("/claims/source/file", "Source lacks a revision precondition");
			}
			if (!reader.text(origin.value("table", Json()), "/claims/source/table", claim.table) || !reader.text(origin.value("key", Json()), "/claims/source/key", claim.key) || !hash(origin.value("fingerprint", Json()), "/claims/source/fingerprint", claim.fingerprint)) {
				return false;
			}
			const auto ordinal = origin.value("declaration", Json(1));
			if (!ordinal.is_number_integer() || ordinal < 1 || ordinal > UINT32_MAX) {
				return reader.fail("/claims/source/declaration", "Expected a positive declaration occurrence");
			}
			claim.declaration = ordinal.get<uint32_t>();
			if (!reader.text(entry.value("occurrence", Json()), "/claims/occurrence", claim.occurrence) || !reader.text(entry.value("object", Json()), "/claims/object", claim.object)) {
				return false;
			}
			if (claim.table.empty() || claim.key.empty() || claim.occurrence.empty() || claim.object.empty()) {
				return reader.fail("/claims", "Claim identity fields cannot be empty");
			}
			if (!entry.contains("responsibilities") || !entry["responsibilities"].is_array() || entry["responsibilities"].empty()) {
				return reader.fail("/claims/responsibilities", "Expected non-empty responsibilities");
			}
			for (const auto &value : entry["responsibilities"]) {
				std::string responsibility;
				if (!reader.text(value, "/claims/responsibilities", responsibility)) {
					return false;
				}
				const std::set<std::string> known { "attributes.aid", "attributes.uid", "attributes.text", "attributes.description", "attributes.name", "attributes.article", "attributes.plural", "attributes.writer", "attributes.date", "attributes.custom", "creation", "replacement", "onUse", "onStepIn", "onStepOut", "onAddItem", "onRemoveItem" };
				if (!known.contains(responsibility)) {
					return reader.fail("/claims/responsibilities", "Unknown responsibility: " + responsibility);
				}
				if (!claims.emplace(claim.file, claim.table, claim.key, claim.declaration, claim.occurrence, claim.object, responsibility).second) {
					return reader.fail("/claims", "Duplicate ownership claim");
				}
				claim.responsibilities.push_back(responsibility);
			}
			result.claims.push_back(std::move(claim));
		}
		record = std::move(result);
		return true;
	}

	bool loadProjectV2(const std::filesystem::path &file, Project &project, Diagnostics &diagnostics) {
		Reader reader(file, diagnostics);
		std::string source, error;
		Json value;
		Project parsed;
		parsed.file = file;
		parsed.schemaVersion = 2;
		if (!readFile(file, source, error)) {
			return reader.fail("", error);
		}
		if (!reader.parse(source, value) || !reader.keys(value, "", { "$schema", "schemaVersion", "id", "map", "items", "layers", "behaviorCatalog", "migrations" })) {
			return false;
		}
		if (!value.value("schemaVersion", Json()).is_number_integer() || value["schemaVersion"] != 2) {
			return reader.fail("/schemaVersion", "Expected integer schemaVersion 2");
		}
		if (!reader.identifier(value.value("id", Json()), "/id", parsed.id)
		    || !reader.relative(value.value("map", Json()), "/map", parsed.map)
		    || !reader.relative(value.value("items", Json()), "/items", parsed.items)) {
			return false;
		}
		if (value.contains("$schema") && !reader.text(value["$schema"], "/$schema", parsed.schema)) {
			return false;
		}
		if (!value.contains("layers") || !value["layers"].is_array()) {
			return reader.fail("/layers", "Expected explicitly listed layers");
		}
		std::set<std::filesystem::path> files { file };
		for (const auto &entry : value["layers"]) {
			Layer layer;
			bool enabled = true;
			if (!reader.keys(entry, "/layers", { "file", "enabled" })
			    || !reader.relative(entry.value("file", Json()), "/layers/file", layer.file)
			    || !reader.boolean(entry.value("enabled", Json(true)), "/layers/enabled", enabled)) {
				return false;
			}
			if (!files.insert(layer.file).second) {
				return reader.fail("/layers/file", "Duplicate document path");
			}
			if (!readFile(layer.file, source, error)) {
				return reader.fail("/layers/file", layer.file.generic_string() + ": " + error);
			}
			const auto layerFile = layer.file;
			if (!parseLayer(source, layerFile, layer, diagnostics)) {
				return false;
			}
			layer.enabled = enabled;
			parsed.layers.push_back(std::move(layer));
		}
		if (value.contains("behaviorCatalog")) {
			if (!value["behaviorCatalog"].is_array()) {
				return reader.fail("/behaviorCatalog", "Expected an array of descriptor paths");
			}
			std::set<std::string> identities;
			for (const auto &entry : value["behaviorCatalog"]) {
				std::filesystem::path path;
				BehaviorDescriptor behavior;
				if (!reader.relative(entry, "/behaviorCatalog", path)) {
					return false;
				}
				if (!files.insert(path).second) {
					return reader.fail("/behaviorCatalog", "Duplicate document path");
				}
				if (!readFile(path, source, error)) {
					return reader.fail("/behaviorCatalog", path.generic_string() + ": " + error);
				}
				if (!parseBehavior(source, path, behavior, diagnostics)) {
					return false;
				}
				if (!identities.insert(behavior.id).second) {
					return reader.fail("/behaviorCatalog", "Duplicate behavior identity");
				}
				parsed.behaviors.push_back(std::move(behavior));
			}
		}
		if (value.contains("migrations")) {
			if (!value["migrations"].is_array()) {
				return reader.fail("/migrations", "Expected explicit migration record paths");
			}
			for (const auto &entry : value["migrations"]) {
				std::filesystem::path path;
				if (!reader.relative(entry, "/migrations", path)) {
					return false;
				}
				if (!files.insert(path).second) {
					return reader.fail("/migrations", "Duplicate document path");
				}
				MigrationRecord record;
				if (!loadMigration(path, record, diagnostics)) {
					return false;
				}
				parsed.migrationRecords.push_back(std::move(record));
				parsed.migrations.push_back(path);
			}
		}
		if (!parsed.rebuildIndex(diagnostics)) {
			return false;
		}
		project = std::move(parsed);
		return true;
	}

	std::string serializeLayerV2(const Layer &layer) {
		Json json = { { "schemaVersion", 2 }, { "id", layer.id } };
		if (!layer.schema.empty()) {
			json["$schema"] = layer.schema;
		}
		if (!layer.name.empty()) {
			json["name"] = layer.name;
		}
		json["objects"] = Json::array();
		for (const auto &object : layer.objects) {
			Json value = { { "id", object.id }, { "kind", object.kind == ObjectKind::Anchor ? "anchor" : "item" } };
			if (!object.name.empty()) {
				value["name"] = object.name;
			}
			if (object.kind == ObjectKind::Anchor) {
				value["position"] = positionJson(object.position);
			} else {
				Json source = { { "mode", object.mode == SourceMode::Map ? "map" : object.mode == SourceMode::Create ? "create"
					                                                                                                 : "replace" } };
				if (object.selector) {
					source["selector"] = selectorJson(*object.selector);
				}
				if (object.mode != SourceMode::Map) {
					source["itemId"] = object.itemId;
					source["count"] = object.count;
					if (object.subtype) {
						source["subtype"] = *object.subtype;
					}
					source["placement"] = object.container.empty() ? Json { { "position", positionJson(object.position) } } : Json { { "container", object.container }, { "order", object.order } };
				}
				value["source"] = std::move(source);
				if (object.lifecycle != Lifecycle::Native) {
					value["lifecycle"] = object.lifecycle == Lifecycle::Fixture ? "fixture" : "refillOnStartup";
				}
				Json attributes = encode(Value { object.attributes });
				if (object.aidOverride || object.aid) {
					attributes["aid"] = object.aid;
				}
				if (object.uidOverride || object.uid) {
					attributes["uid"] = object.uid;
				}
				if (!attributes.empty()) {
					value["attributes"] = std::move(attributes);
				}
				if (object.teleport) {
					value["components"] = Json::array({ { { "type", "teleport" }, { "destination", referenceJson({ object.teleport->destination, object.teleport->destinationOffset }) } } });
				}
			}
			if (!object.relations.empty()) {
				value["relations"] = relationsJson(object.relations);
			}
			if (!object.behaviors.empty()) {
				value["behaviors"] = Json::array();
				for (const auto &binding : object.behaviors) {
					value["behaviors"].push_back({ { "id", binding.id }, { "contractVersion", binding.contractVersion }, { "events", binding.events }, { "parameters", encode(Value { binding.parameters }) }, { "relations", relationsJson(binding.relations) } });
				}
			}
			json["objects"].push_back(std::move(value));
		}
		return json.dump(2) + "\n";
	}

	std::string serializeProject(const Project &project) {
		const auto relative = [&](const std::filesystem::path &path) { return path.lexically_relative(project.file.parent_path()).generic_string(); };
		Json json = { { "schemaVersion", project.schemaVersion } };
		if (!project.schema.empty()) {
			json["$schema"] = project.schema;
		}
		if (project.schemaVersion == 2) {
			json["id"] = project.id;
		}
		json["map"] = relative(project.map);
		json["items"] = relative(project.items);
		json["layers"] = Json::array();
		for (const auto &layer : project.layers) {
			if (project.schemaVersion == 1) {
				json["layers"].push_back(relative(layer.file));
			} else {
				json["layers"].push_back({ { "file", relative(layer.file) }, { "enabled", layer.enabled } });
			}
		}
		if (project.schemaVersion == 2) {
			json["behaviorCatalog"] = Json::array();
			for (const auto &behavior : project.behaviors) {
				json["behaviorCatalog"].push_back(relative(behavior.file));
			}
			json["migrations"] = Json::array();
			for (const auto &migration : project.migrations) {
				json["migrations"].push_back(relative(migration));
			}
		}
		return json.dump(2) + "\n";
	}

	bool validateParameter(const Parameter &schema, const Value &value, std::string &error) {
		const auto json = encode(value);
		const auto fail = [&](const std::string &message) { error = message; return false; };
		const auto &type = schema.type;
		if (const auto integer = std::get_if<int64_t>(&value.data); integer && (*integer < -9007199254740991LL || *integer > 9007199254740991LL)) {
			return fail("Integer cannot be represented exactly by the Lua number type");
		}
		if (type == "boolean" && !json.is_boolean()) {
			return fail("Expected a boolean");
		}
		if ((type == "integer" || type == "itemId") && !json.is_number_integer()) {
			return fail("Expected an integer");
		}
		if (type == "number" && (!json.is_number() || !std::isfinite(json.get<double>()))) {
			return fail("Expected a finite number");
		}
		if (type == "string" && !json.is_string()) {
			return fail("Expected a string");
		}
		if (type == "itemId" && (json.get<int64_t>() < 1 || json.get<int64_t>() > 65535)) {
			return fail("Item ID is outside the supported range");
		}
		if (json.is_number()) {
			const auto number = json.get<double>();
			if (!std::isfinite(number) || (schema.minimum && number < *schema.minimum) || (schema.maximum && number > *schema.maximum)) {
				return fail("Number is outside the declared bounds");
			}
		}
		if (type == "enum" && std::find(schema.choices.begin(), schema.choices.end(), value) == schema.choices.end()) {
			return fail("Value is not an enum choice");
		}
		if (type == "position" || type == "offset" || type == "objectRef") {
			Diagnostics diagnostics;
			const std::filesystem::path file;
			Reader reader(file, diagnostics);
			Position position;
			Reference reference;
			const bool valid = type == "objectRef" ? readReference(reader, json, "", reference) : reader.position(json, "", position, type == "offset");
			if (!valid) {
				return fail(diagnostics.front().message);
			}
		}
		if (type == "list") {
			if (!json.is_array() || schema.element.size() != 1) {
				return fail("Expected a typed list");
			}
			if ((schema.minimum && json.size() < *schema.minimum) || (schema.maximum && json.size() > *schema.maximum)) {
				return fail("List length is outside the declared bounds");
			}
			for (const auto &entry : std::get<Value::List>(value.data)) {
				if (!validateParameter(schema.element.front(), entry, error)) {
					return false;
				}
			}
		}
		if (type == "record") {
			if (!json.is_object()) {
				return fail("Expected a typed record");
			}
			const auto &record = std::get<Value::Record>(value.data);
			for (const auto &[name, entry] : record) {
				const auto it = schema.fields.find(name);
				if (it == schema.fields.end()) {
					return fail("Unknown record field: " + name);
				}
				if (!validateParameter(it->second, entry, error)) {
					return false;
				}
			}
			for (const auto &[name, field] : schema.fields) {
				if (field.required && !field.defaultValue && !record.contains(name)) {
					return fail("Missing record field: " + name);
				}
			}
		}
		return true;
	}

	Value::Record resolveParameters(const BehaviorDescriptor &descriptor, const BehaviorBinding &binding) {
		const auto resolve = [&](const auto &self, const Parameter &schema, const Value &input) -> Value {
			auto result = input;
			if (schema.type == "record") {
				if (auto fields = std::get_if<Value::Record>(&result.data)) {
					for (const auto &[name, field] : schema.fields) {
						auto entry = fields->find(name);
						if (entry == fields->end() && field.defaultValue) {
							entry = fields->emplace(name, *field.defaultValue).first;
						}
						if (entry != fields->end()) {
							entry->second = self(self, field, entry->second);
						}
					}
				}
			} else if (schema.type == "list" && schema.element.size() == 1) {
				if (auto entries = std::get_if<Value::List>(&result.data)) {
					for (auto &entry : *entries) {
						entry = self(self, schema.element.front(), entry);
					}
				}
			}
			return result;
		};
		auto result = binding.parameters;
		for (const auto &[name, schema] : descriptor.parameters) {
			auto entry = result.find(name);
			if (entry == result.end() && schema.defaultValue) {
				entry = result.emplace(name, *schema.defaultValue).first;
			}
			if (entry != result.end()) {
				entry->second = resolve(resolve, schema, entry->second);
			}
		}
		return result;
	}

	void validateProjectV2(const Project &project, Diagnostics &diagnostics) {
		std::set<std::string> identities;
		std::map<uint16_t, std::string> unique;
		for (const auto &layer : project.layers) {
			for (const auto &object : layer.objects) {
				const auto id = objectId(layer, object);
				const auto fail = [&](const std::string &field, const std::string &message) { diagnostics.push_back({ layer.file, id, field, message }); };
				if (!identities.insert(id).second) {
					fail("/id", "Duplicate object identity");
				}
				if (!layer.enabled) {
					continue;
				}
				if (!objectPosition(project, object)) {
					fail("/source", "Invalid position or cyclic/missing container relation");
				}
				if (object.kind == ObjectKind::Item && object.itemId == 0) {
					fail("/source/itemId", "Item ID must be nonzero");
				}
				if (object.kind == ObjectKind::Item && object.mode != SourceMode::Create && !object.selector && layer.schemaVersion == 2) {
					fail("/source/selector", "Expected an explicit base selector");
				}
				if (object.uid && !unique.emplace(object.uid, id).second) {
					fail("/attributes/uid", "Duplicate UID " + std::to_string(object.uid) + ": " + unique[object.uid]);
				}
				if (object.lifecycle == Lifecycle::RefillOnStartup && object.uid) {
					fail("/attributes/uid", "Refill items cannot reserve an exclusive UID");
				}
				const auto validateRef = [&](const Reference &reference, const std::string &field, const RelationType* type = nullptr) {
					const auto* target = project.find(reference.object);
					if (!target || !project.active(reference.object)) {
						fail(field, "Missing or disabled object: " + reference.object);
						return;
					}
					if (type) {
						if ((type->targetKind == "item") != (target->kind == ObjectKind::Item)) {
							fail(field, "Relation target kind is incompatible");
						}
						if (!type->allowOffset && reference.offset != Position {}) {
							fail(field, "This relation does not allow an offset");
						}
					}
					const auto position = objectPosition(project, *target);
					if (position && !isValidPosition({ position->x + reference.offset.x, position->y + reference.offset.y, position->z + reference.offset.z })) {
						fail(field, "Relation offset leaves the map");
					}
				};
				if (!object.container.empty()) {
					validateRef({ object.container, {} }, "/source/placement/container");
				}
				if (object.selector && !object.selector->container.empty()) {
					validateRef({ object.selector->container, {} }, "/source/selector/container");
				}
				if (object.teleport) {
					validateRef({ object.teleport->destination, object.teleport->destinationOffset }, "/components/destination");
				}
				for (const auto &[name, refs] : object.relations) {
					for (const auto &ref : refs) {
						validateRef(ref, "/relations/" + name);
					}
				}
				std::set<std::string> ownedEvents;
				for (const auto &binding : object.behaviors) {
					const auto* descriptor = project.behavior(binding.id);
					if (!descriptor) {
						fail("/behaviors/id", "Unknown behavior: " + binding.id);
						continue;
					}
					if (descriptor->contractVersion != binding.contractVersion) {
						fail("/behaviors/contractVersion", "Behavior contract version is incompatible");
					}
					if ((descriptor->targetKind == "item") != (object.kind == ObjectKind::Item)) {
						fail("/behaviors", "Behavior target kind is incompatible");
					}
					for (const auto &event : binding.events) {
						if (!ownedEvents.insert(event).second) {
							fail("/behaviors/events", "More than one behavior owns event " + event);
						}
						if (std::find(descriptor->events.begin(), descriptor->events.end(), event) == descriptor->events.end()) {
							fail("/behaviors/events", "Event is not declared by the descriptor: " + event);
						}
					}
					for (const auto &[name, value] : binding.parameters) {
						const auto it = descriptor->parameters.find(name);
						std::string error;
						if (it == descriptor->parameters.end()) {
							fail("/behaviors/parameters/" + name, "Unknown parameter");
						} else if (!validateParameter(it->second, value, error)) {
							fail("/behaviors/parameters/" + name, error);
						}
					}
					for (const auto &[name, parameter] : descriptor->parameters) {
						if (parameter.required && !parameter.defaultValue && !binding.parameters.contains(name)) {
							fail("/behaviors/parameters/" + name, "Missing required parameter");
						}
					}
					for (const auto &[name, refs] : binding.relations) {
						const auto it = descriptor->relations.find(name);
						if (it == descriptor->relations.end()) {
							fail("/behaviors/relations/" + name, "Unknown relation");
							continue;
						}
						if (refs.size() < it->second.minimum || refs.size() > it->second.maximum) {
							fail("/behaviors/relations/" + name, "Relation cardinality is incompatible");
						}
						for (const auto &ref : refs) {
							validateRef(ref, "/behaviors/relations/" + name, &it->second);
						}
					}
					for (const auto &[name, relation] : descriptor->relations) {
						if (relation.minimum && !binding.relations.contains(name)) {
							fail("/behaviors/relations/" + name, "Missing required relation");
						}
					}
				}
			}
		}
		std::set<std::string> migrationIds;
		std::set<std::tuple<std::filesystem::path, std::string, std::string, std::string, std::string>> claims;
		for (const auto &record : project.migrationRecords) {
			if (!migrationIds.insert(record.id).second) {
				diagnostics.push_back({ record.file, "", "/id", "Duplicate migration identity" });
			}
			for (const auto &claim : record.claims) {
				if (!project.find(claim.object)) {
					diagnostics.push_back({ record.file, claim.object, "/claims/object", "Missing migration target" });
				}
				for (const auto &responsibility : claim.responsibilities) {
					if (!claims.emplace(claim.file.lexically_normal(), claim.table, claim.key, claim.occurrence, responsibility).second) {
						diagnostics.push_back({ record.file, claim.object, "/claims", "More than one migration owns this legacy occurrence/responsibility" });
					}
				}
			}
		}
	}

	std::string serializeValue(const Value &value) {
		return encode(value).dump(2);
	}

	bool parseValue(const std::string &source, Value &value, std::string &error) {
		Diagnostics diagnostics;
		const std::filesystem::path file;
		Reader reader(file, diagnostics);
		Json parsed;
		if (!reader.parse(source, parsed)) {
			error = diagnostics.front().message;
			return false;
		}
		value = decode(parsed);
		return true;
	}

	bool convertToV2(Project &project, Diagnostics &diagnostics) {
		Project converted = project;
		for (auto &layer : converted.layers) {
			if (layer.schemaVersion == 2) {
				continue;
			}
			for (auto &object : layer.objects) {
				object.id = objectId(layer, object);
				object.aidOverride = object.aid != 0;
				object.uidOverride = object.uid != 0;
				if (object.replaces) {
					object.mode = SourceMode::Replace;
					Selector selector;
					selector.position = object.replaces->position;
					selector.itemId = object.replaces->itemId;
					object.selector = selector;
					object.replaces.reset();
				}
			}
			layer.schemaVersion = 2;
			layer.schema.clear();
		}
		converted.schemaVersion = 2;
		converted.schema.clear();
		if (converted.id.empty()) {
			converted.id = "world";
		}
		if (!converted.rebuildIndex(diagnostics)) {
			return false;
		}
		const auto before = diagnostics.size();
		validateProjectV2(converted, diagnostics);
		if (before != diagnostics.size()) {
			return false;
		}
		project = std::move(converted);
		return true;
	}
} // namespace world_layers
