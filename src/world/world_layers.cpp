#include "world/world_layers.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <nlohmann/json.hpp>
	#include <algorithm>
	#include <fstream>
	#include <set>
#endif

namespace world_layers {
	namespace {

		using Json = nlohmann::ordered_json;
		constexpr size_t MaxDocumentBytes = 16 * 1024 * 1024;

		class Reader {
		public:
			Reader(const std::filesystem::path &file, Diagnostics &diagnostics) : file(file), diagnostics(diagnostics) { }

			bool fail(const std::string &field, const std::string &message) {
				diagnostics.push_back({ file, object, field, message });
				return false;
			}

			bool keys(const Json &value, const std::string &field, std::initializer_list<const char*> allowed) {
				if (!value.is_object()) {
					return fail(field, "Expected an object");
				}
				for (const auto &entry : value.items()) {
					if (std::none_of(allowed.begin(), allowed.end(), [&](const char* key) { return entry.key() == key; })) {
						return fail(field + "/" + entry.key(), "Unsupported field");
					}
				}
				return true;
			}

			bool integer(const Json &value, const std::string &field, int32_t minimum, int32_t maximum, int32_t &result) {
				if (!value.is_number_integer()) {
					return fail(field, "Expected an integer");
				}
				if (value.is_number_unsigned() && value.get<uint64_t>() > static_cast<uint64_t>(maximum)) {
					return fail(field, "Integer outside the supported range");
				}
				const auto number = value.get<int64_t>();
				if (number < minimum || number > maximum) {
					return fail(field, "Integer outside the supported range");
				}
				result = static_cast<int32_t>(number);
				return true;
			}

			bool number(const Json &value, const std::string &field, uint16_t &result, int32_t minimum = 0) {
				int32_t number = 0;
				if (!integer(value, field, minimum, 65535, number)) {
					return false;
				}
				result = static_cast<uint16_t>(number);
				return true;
			}

			bool text(const Json &value, const std::string &field, std::string &result) {
				if (!value.is_string()) {
					return fail(field, "Expected a string");
				}
				result = value.get<std::string>();
				return true;
			}

			bool identifier(const Json &value, const std::string &field, std::string &result, bool localObject = false) {
				if (!text(value, field, result)) {
					return false;
				}
				if (result.empty() || result.size() > 128 || result.front() < 'a' || result.front() > 'z'
				    || !std::all_of(result.begin(), result.end(), [localObject](char ch) {
						   return (ch >= 'a' && ch <= 'z') || (ch >= '0' && ch <= '9') || ch == '_' || (localObject && (ch == '.' || ch == '-'));
					   })) {
					return fail(field, "Invalid stable identifier");
				}
				return true;
			}

			bool position(const Json &value, const std::string &field, Position &result, bool offset = false) {
				return keys(value, field, { "x", "y", "z" })
					&& integer(value.value("x", Json()), field + "/x", offset ? -65535 : 0, 65535, result.x)
					&& integer(value.value("y", Json()), field + "/y", offset ? -65535 : 0, 65535, result.y)
					&& integer(value.value("z", Json()), field + "/z", offset ? -15 : 0, 15, result.z)
					&& (offset || isValidPosition(result) || fail(field, "The null position is not a map tile"));
			}

			bool parse(const std::string &source, Json &result) {
				if (source.size() > MaxDocumentBytes) {
					return fail("", "Document exceeds 16 MiB");
				}
				std::vector<std::set<std::string>> keys;
				bool duplicate = false;
				result = Json::parse(source, [&](int, Json::parse_event_t event, Json &parsed) {
			if (event == Json::parse_event_t::object_start) {
				keys.emplace_back();
			} else if (event == Json::parse_event_t::object_end) {
				keys.pop_back();
			} else if (event == Json::parse_event_t::key && !keys.back().insert(parsed.get<std::string>()).second) {
				duplicate = true;
			}
			return true; }, false);
				if (result.is_discarded()) {
					return fail("", "Invalid JSON");
				}
				if (duplicate) {
					return fail("", "Duplicate JSON property");
				}
				return true;
			}

			bool version(const Json &value) {
				int32_t version = 0;
				return integer(value.value("schemaVersion", Json()), "/schemaVersion", 1, 1, version);
			}

			std::string object;

		private:
			const std::filesystem::path &file;
			Diagnostics &diagnostics;
		};

		Json toJson(const Position &position) {
			return { { "x", position.x }, { "y", position.y }, { "z", position.z } };
		}

		bool relativeFile(Reader &reader, const Json &value, const std::filesystem::path &root, const std::string &field, std::filesystem::path &result) {
			std::string name;
			if (!reader.text(value, field, name)) {
				return false;
			}
			const auto path = std::filesystem::u8path(name);
			if (name.empty() || path.is_absolute() || path.has_root_name() || name.find(':') != std::string::npos || name.find('\\') != std::string::npos) {
				return reader.fail(field, "Expected a relative path using forward slashes");
			}
			std::error_code error;
			result = std::filesystem::weakly_canonical(root / path, error);
			return !error || reader.fail(field, error.message());
		}

	} // namespace

	std::string Diagnostic::describe() const {
		return file.generic_string() + (object.empty() ? "" : " [" + object + "]") + " " + field + ": " + message;
	}

	const Object* Project::find(const std::string &id) const {
		const auto it = objects.find(id);
		return it == objects.end() ? nullptr : &layers[it->second.first].objects[it->second.second];
	}

	Object* Project::find(const std::string &id) {
		const auto it = objects.find(id);
		return it == objects.end() ? nullptr : &layers[it->second.first].objects[it->second.second];
	}

	std::string Project::qualifiedId(size_t layer, size_t object) const {
		return layers[layer].id + "." + layers[layer].objects[object].id;
	}

	bool isValidPosition(const Position &position) {
		return position.x >= 0 && position.x <= 65535 && position.y >= 0 && position.y <= 65535
			&& position.z >= 0 && position.z <= 15 && position != Position {};
	}

	std::optional<Position> destination(const Project &project, const Object &object) {
		if (!object.teleport) {
			return std::nullopt;
		}
		const auto* target = project.find(object.teleport->destination);
		if (!target) {
			return std::nullopt;
		}
		const auto &offset = object.teleport->destinationOffset;
		const int64_t x = int64_t(target->position.x) + offset.x;
		const int64_t y = int64_t(target->position.y) + offset.y;
		const int64_t z = int64_t(target->position.z) + offset.z;
		if (x < 0 || x > 65535 || y < 0 || y > 65535 || z < 0 || z > 15) {
			return std::nullopt;
		}
		Position position { static_cast<int32_t>(x), static_cast<int32_t>(y), static_cast<int32_t>(z) };
		return isValidPosition(position) ? std::optional(position) : std::nullopt;
	}

	bool readFile(const std::filesystem::path &file, std::string &content, std::string &error) {
		std::ifstream stream(file, std::ios::binary | std::ios::ate);
		if (!stream) {
			error = "Cannot open file";
			return false;
		}
		const auto length = stream.tellg();
		if (length < 0 || length > static_cast<std::streamoff>(MaxDocumentBytes)) {
			error = "Cannot read document, or document exceeds 16 MiB";
			return false;
		}
		content.resize(static_cast<size_t>(length));
		stream.seekg(0);
		if (!stream.read(content.data(), static_cast<std::streamsize>(content.size()))) {
			error = "Cannot read file";
			return false;
		}
		return true;
	}

	bool parseLayer(const std::string &source, const std::filesystem::path &file, Layer &layer, Diagnostics &diagnostics) {
		Reader reader(file, diagnostics);
		Json json;
		Layer parsed;
		parsed.file = file;
		if (!reader.parse(source, json) || !reader.keys(json, "", { "$schema", "schemaVersion", "id", "name", "objects" })
		    || !reader.version(json) || !reader.identifier(json.value("id", Json()), "/id", parsed.id)) {
			return false;
		}
		if (json.contains("$schema") && !reader.text(json["$schema"], "/$schema", parsed.schema)) {
			return false;
		}
		if (json.contains("name") && !reader.text(json["name"], "/name", parsed.name)) {
			return false;
		}
		if (!json.contains("objects") || !json["objects"].is_array()) {
			return reader.fail("/objects", "Expected an array");
		}
		for (const auto &value : json["objects"]) {
			Object object;
			if (!reader.keys(value, "/objects", { "id", "name", "position", "origin", "attributes", "components" })
			    || !reader.identifier(value.value("id", Json()), "/id", object.id, true)) {
				return false;
			}
			reader.object = parsed.id + "." + object.id;
			if ((value.contains("name") && !reader.text(value["name"], "/name", object.name))
			    || !reader.position(value.value("position", Json()), "/position", object.position)) {
				return false;
			}
			const auto origin = value.value("origin", Json());
			if (!reader.keys(origin, "/origin", { "type", "itemId", "replaces" })) {
				return false;
			}
			if (origin.value("type", Json()) != "layer") {
				return reader.fail("/origin/type", "Version 1 supports external layer objects only");
			}
			if (!reader.number(origin.value("itemId", Json()), "/origin/itemId", object.itemId, 1)) {
				return false;
			}
			if (origin.contains("replaces")) {
				Replacement replacement;
				const auto &replace = origin["replaces"];
				if (!reader.keys(replace, "/origin/replaces", { "position", "itemId" })
				    || !reader.position(replace.value("position", Json()), "/origin/replaces/position", replacement.position)
				    || !reader.number(replace.value("itemId", Json()), "/origin/replaces/itemId", replacement.itemId, 1)) {
					return false;
				}
				object.replaces = replacement;
			}
			if (value.contains("attributes")) {
				const auto &attributes = value["attributes"];
				if (!reader.keys(attributes, "/attributes", { "aid", "uid" })
				    || (attributes.contains("aid") && !reader.number(attributes["aid"], "/attributes/aid", object.aid))
				    || (attributes.contains("uid") && !reader.number(attributes["uid"], "/attributes/uid", object.uid))) {
					return false;
				}
			}
			if (value.contains("components")) {
				if (!value["components"].is_array()) {
					return reader.fail("/components", "Expected an array");
				}
				for (const auto &component : value["components"]) {
					Teleport teleport;
					if (!reader.keys(component, "/components", { "type", "destination", "destinationOffset" })) {
						return false;
					}
					if (component.value("type", Json()) != "teleport" || object.teleport) {
						return reader.fail("/components/type", "Expected at most one native teleport component");
					}
					if (!reader.text(component.value("destination", Json()), "/components/destination", teleport.destination)
					    || (component.contains("destinationOffset") && !reader.position(component["destinationOffset"], "/components/destinationOffset", teleport.destinationOffset, true))) {
						return false;
					}
					object.teleport = teleport;
				}
			}
			parsed.objects.push_back(std::move(object));
		}
		layer = std::move(parsed);
		return true;
	}

	bool loadProject(const std::filesystem::path &file, Project &project, Diagnostics &diagnostics) {
		Reader reader(file, diagnostics);
		std::string source, error;
		Json json;
		Project parsed;
		parsed.file = file;
		if (!readFile(file, source, error)) {
			return reader.fail("", error);
		}
		if (!reader.parse(source, json) || !reader.keys(json, "", { "$schema", "schemaVersion", "map", "items", "layers" }) || !reader.version(json)
		    || !relativeFile(reader, json.value("map", Json()), file.parent_path(), "/map", parsed.map)
		    || !relativeFile(reader, json.value("items", Json()), file.parent_path(), "/items", parsed.items)) {
			return false;
		}
		if (!json.contains("layers") || !json["layers"].is_array()) {
			return reader.fail("/layers", "Expected an explicit array of layer paths");
		}
		std::set<std::filesystem::path> files;
		std::string schema;
		if (json.contains("$schema") && !reader.text(json["$schema"], "/$schema", schema)) {
			return false;
		}
		std::set<std::string> layerIds;
		for (const auto &entry : json["layers"]) {
			std::filesystem::path layerFile;
			Layer layer;
			if (!relativeFile(reader, entry, file.parent_path(), "/layers", layerFile)) {
				return false;
			}
			if (!files.insert(layerFile).second) {
				return reader.fail("/layers", "Duplicate layer file");
			}
			if (!readFile(layerFile, source, error)) {
				diagnostics.push_back({ layerFile, "", "", error });
				return false;
			}
			if (!parseLayer(source, layerFile, layer, diagnostics)) {
				return false;
			}
			if (!layerIds.insert(layer.id).second) {
				return reader.fail("/layers", "Duplicate layer identity: " + layer.id);
			}
			for (size_t i = 0; i < layer.objects.size(); ++i) {
				const auto id = layer.id + "." + layer.objects[i].id;
				if (!parsed.objects.emplace(id, std::pair(parsed.layers.size(), i)).second) {
					return reader.fail("/layers", "Duplicate object identity: " + id);
				}
			}
			parsed.layers.push_back(std::move(layer));
		}
		project = std::move(parsed);
		return true;
	}

	void validateProject(const Project &project, Diagnostics &diagnostics) {
		std::unordered_map<uint16_t, std::string> uniqueIds;
		std::set<std::string> claims;
		std::set<std::string> positions;
		for (const auto &layer : project.layers) {
			for (const auto &object : layer.objects) {
				const auto id = layer.id + "." + object.id;
				const auto fail = [&](const std::string &field, const std::string &message) { diagnostics.push_back({ layer.file, id, field, message }); };
				if (!isValidPosition(object.position)) {
					fail("/position", "Invalid map position");
				}
				const auto positionKey = toJson(object.position).dump();
				if (!positions.insert(positionKey).second) {
					fail("/position", "Version 1 permits one external object per tile");
				}
				if (object.uid && !uniqueIds.emplace(object.uid, id).second) {
					fail("/attributes/uid", "Duplicate UID " + std::to_string(object.uid) + ": " + uniqueIds[object.uid]);
				}
				if (object.replaces && !claims.insert(toJson(object.replaces->position).dump() + ":" + std::to_string(object.replaces->itemId)).second) {
					fail("/origin/replaces", "The same original item is claimed more than once");
				}
				if (object.teleport && !project.find(object.teleport->destination)) {
					fail("/components/destination", "Unknown object: " + object.teleport->destination);
				} else if (object.teleport && !destination(project, object)) {
					fail("/components/destinationOffset", "Arrival falls outside the map coordinate range");
				}
			}
		}
	}

	std::string serializeLayer(const Layer &layer) {
		Json json = Json::object();
		if (!layer.schema.empty()) {
			json["$schema"] = layer.schema;
		}
		json["schemaVersion"] = 1;
		json["id"] = layer.id;
		if (!layer.name.empty()) {
			json["name"] = layer.name;
		}
		json["objects"] = Json::array();
		for (const auto &object : layer.objects) {
			Json value = { { "id", object.id } };
			if (!object.name.empty()) {
				value["name"] = object.name;
			}
			value["position"] = toJson(object.position);
			value["origin"] = { { "type", "layer" }, { "itemId", object.itemId } };
			if (object.replaces) {
				value["origin"]["replaces"] = { { "position", toJson(object.replaces->position) }, { "itemId", object.replaces->itemId } };
			}
			if (object.aid || object.uid) {
				value["attributes"] = Json::object();
				if (object.aid) {
					value["attributes"]["aid"] = object.aid;
				}
				if (object.uid) {
					value["attributes"]["uid"] = object.uid;
				}
			}
			value["components"] = Json::array();
			if (object.teleport) {
				value["components"].push_back({ { "type", "teleport" }, { "destination", object.teleport->destination }, { "destinationOffset", toJson(object.teleport->destinationOffset) } });
			}
			json["objects"].push_back(std::move(value));
		}
		return json.dump(2) + "\n";
	}

} // namespace world_layers
