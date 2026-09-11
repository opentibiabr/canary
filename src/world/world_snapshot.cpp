#include "world/world_snapshot.hpp"
#include <bit>

#ifndef USE_PRECOMPILED_HEADERS
	#include <pugixml.hpp>
	#include <algorithm>
	#include <array>
	#include <cmath>
	#include <fstream>
	#include <set>
	#include <span>
	#include <tuple>
#endif

namespace world_layers {
	namespace {
		using Key = std::tuple<int32_t, int32_t, int32_t>;
		Key key(const Position &p) {
			return { p.x, p.y, p.z };
		}
		struct ItemType {
			bool known = false, ground = false, container = false, teleport = false, door = false;
			bool blocking = false, movable = true, stackable = false, readable = false, fluid = false;
			uint8_t topOrder = 0;
		};

		struct Bytes {
			std::span<const uint8_t> bytes;
			size_t cursor = 0;
			bool valid = true;
			template <typename T>
			T number() {
				if (bytes.size() - cursor < sizeof(T)) {
					valid = false;
					return 0;
				}
				uint64_t result = 0;
				for (size_t i = 0; i < sizeof(T); ++i) {
					result |= uint64_t(bytes[cursor++]) << (i * 8);
				}
				return static_cast<T>(result);
			}
			std::span<const uint8_t> take(size_t count) {
				if (count > bytes.size() - cursor) {
					valid = false;
					return {};
				}
				const auto result = bytes.subspan(cursor, count);
				cursor += count;
				return result;
			}
			std::string text(bool longString = false) {
				const auto size = longString ? number<uint32_t>() : number<uint16_t>();
				const auto data = take(size);
				return { reinterpret_cast<const char*>(data.data()), data.size() };
			}
			uint64_t varint() {
				uint64_t result = 0;
				for (uint32_t shift = 0; shift < 64; shift += 7) {
					const auto byte = number<uint8_t>();
					if (!valid || (shift == 63 && byte > 1)) {
						valid = false;
						return 0;
					}
					result |= uint64_t(byte & 0x7f) << shift;
					if (!(byte & 0x80)) {
						return result;
					}
				}
				valid = false;
				return 0;
			}
			bool field(uint32_t &number, uint32_t &wire, uint64_t &scalar, std::span<const uint8_t> &data) {
				if (!valid || cursor == bytes.size()) {
					return false;
				}
				const auto tag = varint();
				number = static_cast<uint32_t>(tag >> 3);
				wire = tag & 7;
				data = {};
				scalar = 0;
				if (!number || tag > 0xffffffffULL) {
					valid = false;
					return false;
				}
				if (wire == 0) {
					scalar = varint();
				} else if (wire == 1) {
					scalar = this->number<uint64_t>();
				} else if (wire == 2) {
					const auto size = varint();
					if (size > bytes.size() - cursor) {
						valid = false;
					} else {
						data = take(static_cast<size_t>(size));
					}
				} else if (wire == 5) {
					scalar = this->number<uint32_t>();
				} else {
					valid = false;
				}
				return valid;
			}
		};

		bool readBytes(const std::filesystem::path &file, std::vector<uint8_t> &bytes, size_t maximum, std::string &error) {
			std::ifstream stream(file, std::ios::binary | std::ios::ate);
			if (!stream) {
				error = "Cannot open file";
				return false;
			}
			const auto length = stream.tellg();
			if (length < 0 || uint64_t(length) > maximum) {
				error = "File exceeds the inspection size limit";
				return false;
			}
			bytes.resize(static_cast<size_t>(length));
			stream.seekg(0);
			if (!stream.read(reinterpret_cast<char*>(bytes.data()), static_cast<std::streamsize>(bytes.size()))) {
				error = "Cannot read file";
				return false;
			}
			return true;
		}

		bool readAppearances(const std::filesystem::path &file, std::array<ItemType, 65536> &types, std::string &error) {
			std::vector<uint8_t> content;
			if (!readBytes(file, content, 256 * 1024 * 1024, error)) {
				return false;
			}
			Bytes reader { content };
			uint32_t field = 0, wire = 0;
			uint64_t scalar = 0;
			std::span<const uint8_t> data;
			while (reader.field(field, wire, scalar, data)) {
				if (field != 1 || wire != 2) {
					continue;
				}
				Bytes appearance { data };
				uint32_t id = 0;
				ItemType type;
				while (appearance.field(field, wire, scalar, data)) {
					if (field == 1 && wire == 0) {
						if (scalar > 65535) {
							error = "Appearance item ID exceeds 65535";
							return false;
						}
						id = static_cast<uint32_t>(scalar);
					} else if (field == 3 && wire == 2) {
						Bytes flags { data };
						while (flags.field(field, wire, scalar, data)) {
							if (field == 1 && wire == 2) {
								type.ground = true;
							} else if (field == 2 && wire == 0 && scalar) {
								type.topOrder = 1;
							} else if (field == 3 && wire == 0 && scalar) {
								type.topOrder = 2;
							} else if (field == 4 && wire == 0 && scalar) {
								type.topOrder = 3;
							} else if (field == 5 && wire == 0) {
								type.container = scalar != 0;
							} else if (field == 6 && wire == 0) {
								type.stackable = scalar != 0;
							} else if ((field == 10 || field == 11) && wire == 2) {
								type.readable = true;
							} else if (field == 13 && wire == 0) {
								type.blocking = scalar != 0;
							} else if (field == 14 && wire == 0) {
								type.movable = scalar == 0;
							} else if ((field == 12 || field == 19) && wire == 0 && scalar) {
								type.fluid = true;
							}
						}
						if (!flags.valid) {
							error = "Invalid appearance flags";
							return false;
						}
					}
				}
				if (!appearance.valid || !id || types[id].known) {
					error = "Invalid or duplicate appearance item";
					return false;
				}
				type.known = true;
				types[id] = type;
			}
			if (!reader.valid) {
				error = "Invalid appearances protobuf";
			}
			return reader.valid;
		}

		bool readTypes(const std::filesystem::path &file, std::array<ItemType, 65536> &types, std::string &error) {
			if (!readAppearances(file.parent_path() / "appearances.dat", types, error)) {
				return false;
			}
			pugi::xml_document document;
			const auto loaded = document.load_file(file.c_str());
			if (!loaded || !document.child("items")) {
				error = loaded.description();
				return false;
			}
			for (const auto item : document.child("items").children("item")) {
				const auto first = item.attribute("id") ? item.attribute("id").as_uint() : item.attribute("fromid").as_uint();
				const auto last = item.attribute("id") ? first : item.attribute("toid").as_uint();
				if (!first || first > last || last > 65535) {
					error = "Invalid item XML range";
					return false;
				}
				for (uint32_t id = first; id <= last; ++id) {
					auto &type = types[id];
					for (const auto attribute : item.children("attribute")) {
						const std::string name = attribute.attribute("key").value();
						const std::string value = attribute.attribute("value").value();
						if (name == "type") {
							type.teleport = value == "teleport";
							type.door = value == "door";
							if (value == "container" || value == "depot") {
								type.container = true;
							}
						} else if (name == "containersize") {
							type.container = true;
						} else if (name == "readable" || name == "writeable") {
							type.readable = value == "1" || value == "true";
						} else if (name == "moveable" || name == "movable") {
							type.movable = value == "1" || value == "true";
						}
					}
				}
			}
			return true;
		}

		struct Node {
			uint8_t type = 0;
			uint64_t key = 0;
			std::vector<uint8_t> props;
			std::vector<Node> children;
		};
		struct OTBM {
			std::span<const uint8_t> bytes;
			size_t cursor = 4;
			std::string error;
			bool start(Node &node) {
				node.key = cursor;
				if (cursor + 2 > bytes.size() || bytes[cursor++] != 0xfe) {
					error = "Expected OTBM node";
					return false;
				}
				node.type = bytes[cursor++];
				while (cursor < bytes.size() && bytes[cursor] != 0xfe && bytes[cursor] != 0xff) {
					uint8_t value = bytes[cursor++];
					if (value == 0xfd) {
						if (cursor == bytes.size()) {
							error = "Truncated OTBM escape";
							return false;
						}
						value = bytes[cursor++];
					}
					node.props.push_back(value);
					if (node.props.size() > 16 * 1024 * 1024) {
						error = "OTBM node property limit exceeded";
						return false;
					}
				}
				return true;
			}
			bool end() {
				if (cursor >= bytes.size() || bytes[cursor++] != 0xff) {
					error = "Expected end of OTBM node";
					return false;
				}
				return true;
			}
			bool children() const {
				return cursor < bytes.size() && bytes[cursor] == 0xfe;
			}
			bool node(Node &result, size_t depth = 0) {
				if (depth > 128) {
					error = "OTBM nesting exceeds 128";
					return false;
				}
				if (!start(result)) {
					return false;
				}
				while (children()) {
					Node child;
					if (!node(child, depth + 1)) {
						return false;
					}
					result.children.push_back(std::move(child));
				}
				return end();
			}
			bool skip(size_t depth = 0) {
				if (depth > 128) {
					error = "OTBM nesting exceeds 128";
					return false;
				}
				Node ignored;
				if (!start(ignored)) {
					return false;
				}
				while (children()) {
					if (!skip(depth + 1)) {
						return false;
					}
				}
				return end();
			}
		};

		bool itemAttributes(Bytes &reader, MapItem &item, std::string &error) {
			while (reader.cursor < reader.bytes.size() && reader.valid) {
				const auto attribute = reader.number<uint8_t>();
				switch (attribute) {
					case 0:
						return reader.cursor == reader.bytes.size();
					case 4:
						item.aid = reader.number<uint16_t>();
						break;
					case 5:
						item.uid = reader.number<uint16_t>();
						break;
					case 6:
						item.attributes["text"] = Value { reader.text() };
						break;
					case 7:
						item.attributes["description"] = Value { reader.text() };
						break;
					case 8:
						item.destination = { reader.number<uint16_t>(), reader.number<uint16_t>(), reader.number<uint8_t>() };
						break;
					case 18:
						item.attributes["date"] = Value { int64_t(reader.number<uint32_t>()) };
						break;
					case 19:
						item.attributes["writer"] = Value { reader.text() };
						break;
					case 24:
						item.attributes["name"] = Value { reader.text() };
						break;
					case 25:
						item.attributes["article"] = Value { reader.text() };
						break;
					case 26:
						item.attributes["plural"] = Value { reader.text() };
						break;
					case 10:
					case 22:
					case 39:
						reader.take(2);
						break;
					case 12:
					case 14:
					case 15:
					case 17:
					case 32:
					case 33:
					case 36:
					case 40:
						reader.take(1);
						break;
					case 1:
					case 16:
					case 20:
					case 21:
					case 23:
					case 27:
					case 28:
					case 29:
					case 30:
					case 31:
					case 35:
					case 38:
					case 43:
					case 44:
					case 45:
						reader.take(4);
						break;
					case 34:
					case 42:
						reader.text();
						break;
					case 37:
					case 41:
					case 128: {
						const auto count = attribute == 128 ? reader.number<uint16_t>() : reader.number<uint64_t>();
						if (count > 65535) {
							error = "Too many custom OTBM attributes";
							return false;
						}
						Value::Record custom;
						for (uint64_t i = 0; i < count && reader.valid; ++i) {
							const auto name = reader.text();
							const auto type = reader.number<uint8_t>();
							Value value;
							if (type == 1) {
								value.data = reader.text(attribute == 128);
							} else if (type == 2) {
								value.data = attribute == 128 ? int64_t(reader.number<int32_t>()) : reader.number<int64_t>();
							} else if (type == 3 && attribute == 128) {
								value.data = double(std::bit_cast<float>(reader.number<uint32_t>()));
							} else if ((type == 3 && attribute != 128) || (type == 5 && attribute == 128)) {
								value.data = std::bit_cast<double>(reader.number<uint64_t>());
							} else if (type == 4) {
								value.data = reader.number<uint8_t>() != 0;
							} else {
								error = "Unsupported custom OTBM attribute type";
								return false;
							}
							if (attribute == 128 && (name == "aid" || name == "uid") && std::holds_alternative<int64_t>(value.data)) {
								const auto number = std::get<int64_t>(value.data);
								if (number < 0 || number > 65535) {
									error = "Invalid OTBM AID/UID";
									return false;
								}
								(name == "aid" ? item.aid : item.uid) = static_cast<uint16_t>(number);
							} else if (attribute == 128 && (name == "text" || name == "desc" || name == "name" || name == "article" || name == "plural" || name == "writer" || name == "date")) {
								item.attributes[name == "desc" ? "description" : name] = value;
							} else {
								custom[name] = std::move(value);
							}
						}
						if (!custom.empty()) {
							item.attributes["custom"] = Value { std::move(custom) };
						}
						break;
					}
					default:
						error = "Unsupported OTBM item attribute " + std::to_string(attribute);
						return false;
				}
			}
			if (!reader.valid) {
				error = "Truncated OTBM item attributes";
			}
			return reader.valid;
		}

		bool readItem(const Node &node, const std::array<ItemType, 65536> &types, uint32_t version, MapItem &item, std::string &error) {
			if (node.type != 6) {
				error = "Expected an OTBM item node";
				return false;
			}
			Bytes reader { node.props };
			item.key = node.key;
			item.itemId = reader.number<uint16_t>();
			const auto &type = types[item.itemId];
			if (!type.known && version == 0) {
				error = "Cannot decode subtype of unknown item in OTBM v1";
				return false;
			}
			item.ground = type.ground;
			item.container = type.container;
			item.teleport = type.teleport;
			if (version == 0 && (type.stackable || type.fluid)) {
				reader.take(1);
			}
			if (!itemAttributes(reader, item, error)) {
				return false;
			}
			for (const auto &child : node.children) {
				MapItem content;
				if (!readItem(child, types, version, content, error)) {
					return false;
				}
				item.children.push_back(std::move(content));
			}
			if (!item.children.empty() && !item.container) {
				error = "OTBM content belongs to a non-container";
				return false;
			}
			return true;
		}

		Value itemValue(const MapItem &item) {
			auto attributes = item.attributes;
			attributes["aid"] = Value { int64_t(item.aid) };
			attributes["uid"] = Value { int64_t(item.uid) };
			Value::List children;
			for (const auto &child : item.children) {
				children.push_back(itemValue(child));
			}
			return Value { Value::Record { { "key", Value { int64_t(item.key) } }, { "itemId", Value { int64_t(item.itemId) } }, { "part", Value { std::string(item.ground ? "ground" : "item") } }, { "container", Value { item.container } }, { "teleport", Value { item.teleport } }, { "attributes", Value { attributes } }, { "children", Value { children } } } };
		}
	}

	struct MapSnapshot::State {
		std::array<ItemType, 65536> types;
		std::map<Key, MapTile> tiles;
		std::vector<UniqueOccurrence> ids;
		uint64_t tileCount = 0, itemCount = 0;
		void census(const MapItem &item, const Position &position) {
			++itemCount;
			if (item.uid) {
				ids.push_back({ item.uid, item.key, position });
			}
			for (const auto &child : item.children) {
				census(child, position);
			}
		}
	};

	MapSnapshot::MapSnapshot() :
		state(std::make_unique<State>()) { }
	MapSnapshot::~MapSnapshot() = default;
	bool MapSnapshot::knownItem(uint16_t id) const {
		return state->types[id].known;
	}
	bool MapSnapshot::nativeTeleport(uint16_t id) const {
		return state->types[id].teleport;
	}
	bool MapSnapshot::capability(uint16_t id, const std::string &name) const {
		const auto &type = state->types[id];
		if (name == "container") {
			return type.container;
		}
		if (name == "door") {
			return type.door;
		}
		if (name == "ground") {
			return type.ground;
		}
		if (name == "movable") {
			return type.movable;
		}
		if (name == "stackable") {
			return type.stackable;
		}
		if (name == "readable") {
			return type.readable;
		}
		if (name == "blocking") {
			return type.blocking;
		}
		return MapView::capability(id, name);
	}
	MapTile MapSnapshot::tile(const Position &position) {
		const auto it = state->tiles.find(key(position));
		return it == state->tiles.end() ? MapTile {} : it->second;
	}
	std::vector<UniqueOccurrence> MapSnapshot::uniqueIds(const std::unordered_set<uint16_t> &requested) {
		if (requested.empty()) {
			return state->ids;
		}
		std::vector<UniqueOccurrence> result;
		for (const auto &entry : state->ids) {
			if (requested.contains(entry.uid)) {
				result.push_back(entry);
			}
		}
		return result;
	}
	uint64_t MapSnapshot::tileCount() const {
		return state->tileCount;
	}
	uint64_t MapSnapshot::itemCount() const {
		return state->itemCount;
	}

	bool MapSnapshot::load(const std::filesystem::path &map, const std::filesystem::path &items, const std::vector<Position> &positions, Diagnostics &diagnostics) {
		auto loaded = std::make_unique<State>();
		std::string error;
		if (!readTypes(items, loaded->types, error)) {
			diagnostics.push_back({ items, "", "", error });
			return false;
		}
		std::vector<uint8_t> bytes;
		const auto fail = [&](const std::string &message) { diagnostics.push_back({ map, "", "", message }); return false; };
		if (!readBytes(map, bytes, size_t(2) * 1024 * 1024 * 1024, error)) {
			return fail(error);
		}
		if (bytes.size() < 6 || !(std::equal(bytes.begin(), bytes.begin() + 4, "OTBM") || std::all_of(bytes.begin(), bytes.begin() + 4, [](uint8_t value) { return value == 0; }))) {
			return fail("Invalid OTBM identifier");
		}
		std::set<Key> requested;
		for (const auto &position : positions) {
			requested.insert(key(position));
		}
		OTBM reader { bytes };
		Node root;
		if (!reader.start(root) || (root.type != 0 && root.type != 1)) {
			return fail("Invalid OTBM root");
		}
		Bytes header { root.props };
		const auto version = header.number<uint32_t>();
		if (!header.valid || version > 4 || root.props.size() < 16) {
			return fail("Unsupported OTBM version or truncated header");
		}
		Node data;
		if (!reader.start(data) || data.type != 2) {
			return fail("Missing OTBM map data");
		}
		while (reader.children()) {
			if (reader.cursor + 1 >= reader.bytes.size()) {
				return fail("Truncated OTBM child node");
			}
			const auto type = reader.bytes[reader.cursor + 1];
			if (type != 4) {
				if (!reader.skip()) {
					return fail(reader.error);
				}
				continue;
			}
			Node area;
			if (!reader.start(area)) {
				return fail(reader.error);
			}
			Bytes areaProps { area.props };
			const Position base { areaProps.number<uint16_t>(), areaProps.number<uint16_t>(), areaProps.number<uint8_t>() };
			if (!areaProps.valid || base.z > 15) {
				return fail("Invalid OTBM tile area");
			}
			while (reader.children()) {
				Node node;
				if (!reader.node(node)) {
					return fail(reader.error);
				}
				if (node.type != 5 && node.type != 14) {
					return fail("Invalid OTBM tile node");
				}
				Bytes props { node.props };
				const Position position { base.x + props.number<uint8_t>(), base.y + props.number<uint8_t>(), base.z };
				if (!props.valid || !isValidPosition(position)) {
					return fail("Invalid OTBM tile position");
				}
				MapTile tile;
				tile.exists = true;
				tile.house = node.type == 14;
				if (tile.house) {
					props.take(4);
				}
				while (props.cursor < props.bytes.size() && props.valid) {
					const auto attribute = props.number<uint8_t>();
					if (attribute == 3) {
						props.take(4);
					} else if (attribute == 9) {
						MapItem item;
						item.key = node.key;
						item.itemId = props.number<uint16_t>();
						item.ground = loaded->types[item.itemId].ground;
						item.teleport = loaded->types[item.itemId].teleport;
						item.container = loaded->types[item.itemId].container;
						tile.items.push_back(item);
					} else {
						return fail("Unsupported OTBM tile attribute " + std::to_string(attribute));
					}
				}
				if (!props.valid) {
					return fail("Truncated OTBM tile");
				}
				for (const auto &child : node.children) {
					if (child.type == 19) {
						Bytes zones { child.props };
						const auto count = zones.number<uint16_t>();
						zones.take(size_t(count) * 2);
						if (!zones.valid || zones.cursor != zones.bytes.size() || !child.children.empty()) {
							return fail("Invalid OTBM tile-zone metadata");
						}
						continue;
					}
					MapItem item;
					if (!readItem(child, loaded->types, version, item, error)) {
						return fail(error + " at " + std::to_string(position.x) + "," + std::to_string(position.y) + "," + std::to_string(position.z));
					}
					tile.items.push_back(std::move(item));
				}
				bool portal = false;
				for (const auto &item : tile.items) {
					tile.ground = tile.ground || item.ground;
					tile.blocked = tile.blocked || loaded->types[item.itemId].blocking;
					portal = portal || item.teleport;
					loaded->census(item, position);
				}
				++loaded->tileCount;
				if (portal || requested.contains(key(position))) {
					if (!loaded->tiles.emplace(key(position), std::move(tile)).second) {
						return fail("Duplicate OTBM tile position");
					}
				}
			}
			if (!reader.end()) {
				return fail(reader.error);
			}
		}
		if (!reader.end() || !reader.end() || reader.cursor != bytes.size()) {
			return fail(reader.error.empty() ? "Unexpected trailing OTBM data" : reader.error);
		}
		state = std::move(loaded);
		return true;
	}

	std::vector<Position> projectPositions(const Project &project) {
		std::vector<Position> result;
		for (const auto &layer : project.layers) {
			for (const auto &object : layer.objects) {
				if (const auto position = objectPosition(project, object)) {
					result.push_back(*position);
				}
				if (object.selector && object.selector->container.empty()) {
					result.push_back(object.selector->position);
				}
				if (object.replaces) {
					result.push_back(object.replaces->position);
				}
				if (object.teleport) {
					const auto* target = project.find(object.teleport->destination);
					const auto position = target ? objectPosition(project, *target) : std::nullopt;
					if (position) {
						result.push_back({ position->x + object.teleport->destinationOffset.x, position->y + object.teleport->destinationOffset.y, position->z + object.teleport->destinationOffset.z });
					}
				}
			}
		}
		return result;
	}

	Value snapshotValue(const Position &position, const MapTile &tile) {
		Value::List items;
		for (const auto &item : tile.items) {
			items.push_back(itemValue(item));
		}
		return Value { Value::Record { { "position", Value { Value::Record { { "x", Value { int64_t(position.x) } }, { "y", Value { int64_t(position.y) } }, { "z", Value { int64_t(position.z) } } } } }, { "exists", Value { tile.exists } }, { "ground", Value { tile.ground } }, { "house", Value { tile.house } }, { "blocked", Value { tile.blocked } }, { "items", Value { items } }, { "fingerprint", Value { selectorFingerprint(tile.items) } } } };
	}
}
