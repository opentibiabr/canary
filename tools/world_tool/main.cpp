#include "world/world_snapshot.hpp"

#include <fstream>
#include <iostream>
#include <map>

namespace {
	using namespace world_layers;
	int diagnosticsResult(const Diagnostics &diagnostics) {
		Value::List entries;
		for (const auto &diagnostic : diagnostics) {
			entries.push_back(Value { Value::Record { { "file", Value { diagnostic.file.generic_string() } }, { "object", Value { diagnostic.object } }, { "field", Value { diagnostic.field } }, { "message", Value { diagnostic.message } } } });
		}
		std::cout << serializeValue(Value { Value::Record { { "valid", Value { false } }, { "diagnostics", Value { entries } } } }) << '\n';
		return 1;
	}

	bool readPositions(const std::filesystem::path &file, std::vector<Position> &positions, std::string &error) {
		std::string source;
		Value value;
		if (!readFile(file, source, error) || !parseValue(source, value, error)) {
			return false;
		}
		const auto* list = std::get_if<Value::List>(&value.data);
		if (!list) {
			error = "Expected an array of positions";
			return false;
		}
		Parameter schema;
		schema.type = "position";
		for (const auto &entry : *list) {
			if (!validateParameter(schema, entry, error)) {
				return false;
			}
			const auto &record = std::get<Value::Record>(entry.data);
			positions.push_back({ static_cast<int32_t>(std::get<int64_t>(record.at("x").data)), static_cast<int32_t>(std::get<int64_t>(record.at("y").data)), static_cast<int32_t>(std::get<int64_t>(record.at("z").data)) });
		}
		return true;
	}
}

int main(int argc, char** argv) {
	using namespace world_layers;
	try {
		if (argc == 2 && std::string(argv[1]) == "--version") {
			std::cout << "world-tool 2.0.0 (schema 1,2)\n";
			return 0;
		}
		if (argc < 2 || std::string(argv[1]) == "--help") {
			std::cout << "world-tool validate PROJECT [--map OTBM]\nworld-tool inspect --map OTBM --items ITEMS_XML --positions POSITIONS_JSON\nworld-tool normalize PROJECT\n";
			return argc < 2 ? 2 : 0;
		}
		const std::string command = argv[1];
		std::map<std::string, std::string> options;
		std::filesystem::path projectFile;
		int index = 2;
		if (command == "validate" || command == "normalize") {
			if (index >= argc) {
				std::cerr << "Expected a project path\n";
				return 2;
			}
			projectFile = std::filesystem::absolute(std::filesystem::u8path(argv[index++]));
		} else if (command != "inspect") {
			std::cerr << "Unknown command\n";
			return 2;
		}
		while (index < argc) {
			const std::string name = argv[index++];
			if ((name != "--map" && name != "--items" && name != "--positions") || index >= argc || options.contains(name)) {
				std::cerr << "Unknown, duplicate or incomplete option: " << name << '\n';
				return 2;
			}
			options[name] = argv[index++];
		}
		Project project;
		Diagnostics diagnostics;
		std::vector<Position> positions;
		std::filesystem::path map, items;
		if (!projectFile.empty()) {
			if (!loadProject(projectFile, project, diagnostics)) {
				return diagnosticsResult(diagnostics);
			}
			validateProject(project, diagnostics);
			if (!diagnostics.empty()) {
				return diagnosticsResult(diagnostics);
			}
			if (command == "normalize") {
				Value::Record result;
				Value value;
				std::string error;
				if (!parseValue(serializeProject(project), value, error)) {
					std::cerr << error << '\n';
					return 2;
				}
				result["project"] = value;
				Value::List layers;
				for (const auto &layer : project.layers) {
					if (!parseValue(serializeLayer(layer), value, error)) {
						std::cerr << error << '\n';
						return 2;
					}
					layers.push_back(value);
				}
				result["layers"] = Value { layers };
				std::cout << serializeValue(Value { result }) << '\n';
				return 0;
			}
			map = options.contains("--map") ? std::filesystem::u8path(options.at("--map")) : project.map;
			items = project.items;
			positions = projectPositions(project);
		} else {
			if (!options.contains("--map") || !options.contains("--items") || !options.contains("--positions")) {
				std::cerr << "inspect requires --map, --items and --positions\n";
				return 2;
			}
			map = std::filesystem::u8path(options.at("--map"));
			items = std::filesystem::u8path(options.at("--items"));
			std::string error;
			if (!readPositions(std::filesystem::u8path(options.at("--positions")), positions, error)) {
				std::cerr << error << '\n';
				return 2;
			}
		}
		MapSnapshot snapshot;
		if (!snapshot.load(map, items, positions, diagnostics)) {
			return diagnosticsResult(diagnostics);
		}
		Value::Record output { { "schemaVersion", Value { int64_t(2) } }, { "tilesScanned", Value { int64_t(snapshot.tileCount()) } }, { "itemsScanned", Value { int64_t(snapshot.itemCount()) } } };
		if (command == "validate") {
			ApplicationPlan plan;
			if (!validateMap(project, snapshot, plan, diagnostics)) {
				return diagnosticsResult(diagnostics);
			}
			output["valid"] = Value { true };
			output["objects"] = Value { int64_t(plan.objects.size()) };
		} else {
			Value::List tiles;
			for (const auto &position : positions) {
				tiles.push_back(snapshotValue(position, snapshot.tile(position)));
			}
			output["tiles"] = Value { tiles };
			Value::List uids;
			for (const auto &entry : snapshot.uniqueIds({})) {
				uids.push_back(Value { Value::Record { { "uid", Value { int64_t(entry.uid) } }, { "key", Value { int64_t(entry.key) } } } });
			}
			output["uniqueIds"] = Value { uids };
		}
		std::cout << serializeValue(Value { output }) << '\n';
		return 0;
	} catch (const std::exception &error) {
		std::cerr << "world-tool: " << error.what() << '\n';
		return 2;
	}
}
