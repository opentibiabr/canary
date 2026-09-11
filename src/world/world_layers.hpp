#pragma once

#include <cstdint>
#include <filesystem>
#include <optional>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

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

	struct Object {
		std::string id;
		std::string name;
		Position position;
		uint16_t itemId = 0;
		uint16_t aid = 0;
		uint16_t uid = 0;
		std::optional<Replacement> replaces;
		std::optional<Teleport> teleport;
		bool operator==(const Object &) const = default;
	};

	struct Layer {
		std::filesystem::path file;
		std::string schema;
		std::string id;
		std::string name;
		std::vector<Object> objects;
	};

	struct Diagnostic {
		std::filesystem::path file;
		std::string object;
		std::string field;
		std::string message;
		std::string describe() const;
	};

	using Diagnostics = std::vector<Diagnostic>;

	struct Project {
		std::filesystem::path file;
		std::filesystem::path map;
		std::filesystem::path items;
		std::vector<Layer> layers;
		std::unordered_map<std::string, std::pair<size_t, size_t>> objects;

		const Object* find(const std::string &id) const;
		Object* find(const std::string &id);
		std::string qualifiedId(size_t layer, size_t object) const;
	};

	bool isValidPosition(const Position &position);
	std::optional<Position> destination(const Project &project, const Object &object);
	bool parseLayer(const std::string &source, const std::filesystem::path &file, Layer &layer, Diagnostics &diagnostics);
	bool loadProject(const std::filesystem::path &file, Project &project, Diagnostics &diagnostics);
	void validateProject(const Project &project, Diagnostics &diagnostics);
	std::string serializeLayer(const Layer &layer);
	bool readFile(const std::filesystem::path &file, std::string &content, std::string &error);

} // namespace world_layers
