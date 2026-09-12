#include "world/world_snapshot.hpp"
#include "world/world_files.hpp"

#include <fstream>
#include <iostream>
#include <map>
#include <set>
#include <stdexcept>

namespace {
	using namespace world_layers;

	const Value::Record &record(const Value &value, const std::set<std::string> &fields) {
		const auto result = std::get_if<Value::Record>(&value.data);
		if (!result) {
			throw std::runtime_error("Expected an object in the publication manifest");
		}
		for (const auto &[name, content] : *result) {
			if (!fields.contains(name)) {
				throw std::runtime_error("Unknown publication field: " + name);
			}
		}
		return *result;
	}

	std::filesystem::path childPath(const std::filesystem::path &root, const Value &value) {
		const auto name = std::filesystem::u8path(std::get<std::string>(value.data));
		if (name.empty() || name.is_absolute() || name.has_root_name()) {
			throw std::runtime_error("Publication paths must be relative to their declared root");
		}
		const auto path = (root / name).lexically_normal();
		const auto relative = path.lexically_relative(root);
		if (relative.empty() || *relative.begin() == "..") {
			throw std::runtime_error("Publication path leaves its root: " + name.generic_string());
		}
		return path;
	}

	world_files::Revision snapshot(const std::filesystem::path &root, const Value &value) {
		if (std::holds_alternative<std::monostate>(value.data)) {
			return std::nullopt;
		}
		const auto path = childPath(root, value);
		const auto real = std::filesystem::canonical(path).lexically_relative(std::filesystem::canonical(root));
		if (real.empty() || *real.begin() == ".." || !std::filesystem::is_regular_file(path)) {
			throw std::runtime_error("Snapshot must be a regular file inside the bundle");
		}
		std::string content, error;
		if (!readFile(path, content, error)) {
			throw std::runtime_error(error);
		}
		return content;
	}

	int publicationCommand(int argc, char** argv) {
		const std::string command = argv[1];
		if (argc < 3) {
			throw std::runtime_error("Expected a manifest or catalog path");
		}
		std::filesystem::path root;
		bool offline = false, rollback = false, finish = false;
		for (int i = 3; i < argc; ++i) {
			const std::string name = argv[i];
			if (name == "--root" && root.empty() && i + 1 < argc) {
				root = std::filesystem::absolute(std::filesystem::u8path(argv[++i])).lexically_normal();
			} else if (name == "--confirm-offline" && !offline) {
				offline = true;
			} else if (name == "--rollback" && !rollback && command == "recover") {
				rollback = true;
			} else if (name == "--finish" && !finish && command == "recover") {
				finish = true;
			} else {
				throw std::runtime_error("Unknown, duplicate or incomplete publication option: " + name);
			}
		}
		if (root.empty() || !offline) {
			throw std::runtime_error("Publication requires --root and --confirm-offline; stop the server and editing sessions first");
		}
		std::string error;
		if (command == "recover") {
			if (finish == rollback) {
				throw std::runtime_error("Choose exactly one of --finish or --rollback");
			}
			const auto catalog = std::filesystem::absolute(std::filesystem::u8path(argv[2])).lexically_normal();
			if (!world_files::recover(catalog, root, rollback, error)) {
				throw std::runtime_error(error);
			}
			std::cout << "{\"recovered\":true}\n";
			return 0;
		}
		const auto manifest = std::filesystem::absolute(std::filesystem::u8path(argv[2])).lexically_normal();
		std::string content;
		Value value;
		if (!readFile(manifest, content, error) || !parseValue(content, value, error)) {
			throw std::runtime_error(error);
		}
		const auto &spec = record(value, { "schemaVersion", "catalog", "changes", "guards" });
		if (std::get<int64_t>(spec.at("schemaVersion").data) != 1) {
			throw std::runtime_error("Unsupported publication manifest version");
		}
		world_files::Publication publication;
		publication.root = root;
		publication.catalog = childPath(root, spec.at("catalog"));
		for (const auto &entry : std::get<Value::List>(spec.at("changes").data)) {
			const auto &change = record(entry, { "file", "before", "after" });
			publication.changes.push_back({ childPath(root, change.at("file")), snapshot(manifest.parent_path(), change.at("before")), snapshot(manifest.parent_path(), change.at("after")) });
		}
		for (const auto &entry : std::get<Value::List>(spec.at("guards").data)) {
			const auto &guard = record(entry, { "file", "expected" });
			if (!publication.guards.emplace(childPath(root, guard.at("file")), snapshot(manifest.parent_path(), guard.at("expected"))).second) {
				throw std::runtime_error("Duplicate publication guard");
			}
		}
		if (!world_files::publish(publication, error)) {
			throw std::runtime_error(error);
		}
		std::cout << "{\"published\":true,\"changes\":" << publication.changes.size() << "}\n";
		return 0;
	}
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
			std::cout << "world-tool validate PROJECT [--map OTBM] [--items ITEMS_XML]\nworld-tool inspect --map OTBM --items ITEMS_XML --positions POSITIONS_JSON\nworld-tool normalize PROJECT [--convert-v2]\nworld-tool publish MANIFEST --root DIRECTORY --confirm-offline\nworld-tool recover CATALOG --root DIRECTORY (--finish|--rollback) --confirm-offline\n";
			return argc < 2 ? 2 : 0;
		}
		const std::string command = argv[1];
		if (command == "publish" || command == "recover") {
			return publicationCommand(argc, argv);
		}
		std::map<std::string, std::string> options;
		std::filesystem::path projectFile;
		bool convert = false;
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
			if (name == "--convert-v2" && command == "normalize" && !convert) {
				convert = true;
				continue;
			}
			if ((name != "--map" && name != "--items" && name != "--positions") || index >= argc || options.contains(name)) {
				std::cerr << "Unknown, duplicate or incomplete option: " << name << '\n';
				return 2;
			}
			options[name] = argv[index++];
		}
		Project project;
		SourceFiles projectSources;
		Diagnostics diagnostics;
		std::vector<Position> positions;
		std::filesystem::path map, items;
		if (!projectFile.empty()) {
			if (!loadProject(projectFile, project, diagnostics, &projectSources)) {
				return diagnosticsResult(diagnostics);
			}
			if (convert && !convertToV2(project, diagnostics)) {
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
				Value::List files;
				for (const auto &[file, content] : projectSources) {
					files.push_back(Value { Value::Record { { "file", Value { file.lexically_relative(projectFile.parent_path()).generic_string() } }, { "content", Value { content } } } });
				}
				result["files"] = Value { files };
				std::cout << serializeValue(Value { result }) << '\n';
				return 0;
			}
			map = options.contains("--map") ? std::filesystem::u8path(options.at("--map")) : project.map;
			items = options.contains("--items") ? std::filesystem::u8path(options.at("--items")) : project.items;
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
				tiles.push_back(snapshot.inspect(position));
			}
			output["tiles"] = Value { tiles };
			Value::List uids;
			for (const auto &entry : snapshot.uniqueIds({})) {
				uids.push_back(Value { Value::Record { { "uid", Value { int64_t(entry.uid) } }, { "key", Value { int64_t(entry.key) } }, { "position", Value { Value::Record { { "x", Value { int64_t(entry.position.x) } }, { "y", Value { int64_t(entry.position.y) } }, { "z", Value { int64_t(entry.position.z) } } } } } } });
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
