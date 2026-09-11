#include "world/world_files.hpp"
#include "world/world_layers.hpp"
#include <chrono>
#include <fstream>
#include <stdexcept>

namespace {
	void check(bool good, const char* message) {
		if (!good) {
			throw std::runtime_error(message);
		}
	}
	void put(const std::filesystem::path &file, const std::string &value) {
		std::ofstream stream(file, std::ios::binary | std::ios::trunc);
		stream << value;
		stream.close();
		check(!stream.fail(), "write concurrent fixture");
	}
	std::string get(const std::filesystem::path &file) {
		world_files::Revision revision;
		std::string error;
		check(world_files::revision(file, revision, error) && revision.has_value(), "read published revision");
		return *revision;
	}
	std::string atStage;
	std::filesystem::path atFile, competingFile;
	int fault = 0;
	void inject(const char* stage, const std::filesystem::path &file) {
		if (atStage != stage || (!atFile.empty() && file != atFile)) {
			return;
		}
		world_files::setTestHook(nullptr);
		if (fault == 1) {
			throw std::runtime_error("simulated process interruption");
		}
		if (fault == 2) {
			// A noncooperating editor replaces the path while RME still holds
			// the original file handle. Its version must be preserved.
			auto displaced = file;
			displaced += ".outsider-old";
			std::filesystem::rename(file, displaced);
			put(file, "concurrent replacement");
		} else if (fault == 3) {
			put(file, "concurrent creation");
		} else if (fault == 4) {
			put(competingFile, "later recovery edit");
		}
	}
	void arm(const char* stage, const std::filesystem::path &file, int value) {
		atStage = stage;
		atFile = file;
		fault = value;
		world_files::setTestHook(inject);
	}
}

void runWorldFileTests(const std::filesystem::path &scratch) {
	using namespace world_files;
	const auto root = scratch / ("files-" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
	check(std::filesystem::create_directory(root), "reserve file test directory");
	const auto catalog = root / "map.world.json", layer = root / "layer.json";
	std::string error;
	{
		const auto first = root / "first.world.json";
		ReadGuard reader(first, error);
		check(reader.valid(), "first reader need not create files in a read-only project");
		check(publish({ first, root, { { first, {}, "first publication" } }, {} }, error), "first publication creates a generation token");
		check(!reader.unchanged(error), "first reader detects overlapping publication before a lock existed");
	}
	Revision absent;
	check(revision(layer, absent, error) && !absent, "absence is not empty content");
	put(layer, "");
	check(revision(layer, absent, error) && absent && absent->empty(), "empty file has a revision");
	Publication publication { catalog, root, { { layer, "", "first" }, { catalog, {}, "catalog-first" } }, {} };
	check(publish(publication, error), "publish dependencies and catalog");
	check(get(layer) == "first" && get(catalog) == "catalog-first" && !pending(catalog), "complete publication visible together");
	check(!publish(publication, error) && !pending(catalog), "stale revisions fail before publication");
	publication.changes = { { layer, "first", "second" }, { catalog, "catalog-first", "catalog-second" } };
	{
		ReadGuard guard(catalog, error);
		check(guard.valid(), "lock reader snapshot");
		check(!publish(publication, error) && !pending(catalog), "cooperating reader blocks a publisher");
		check(guard.unchanged(error), "reader keeps its original revision");
	}
	arm("installed", layer, 1);
	check(!publish(publication, error) && pending(catalog), "interruption keeps recovery marker");
	check(get(layer) == "second" && get(catalog) == "catalog-first", "interrupt between dependency and catalog");
	world_layers::Project project;
	project.id = "preserved";
	world_layers::Diagnostics diagnostics;
	check(!world_layers::loadProject(catalog, project, diagnostics) && project.id == "preserved", "runtime loader refuses an incomplete set");
	check(recover(catalog, root, false, error), "finish an interrupted publication");
	check(get(catalog) == "catalog-second" && !pending(catalog), "recovery completes the catalog");
	publication.changes = { { layer, "second", "third" }, { catalog, "catalog-second", "catalog-third" } };
	arm("displaced", layer, 1);
	check(!publish(publication, error) && !std::filesystem::exists(layer), "interruption after displacement");
	check(recover(catalog, root, true, error) && get(layer) == "second", "rollback restores a displaced original");
	arm("verified", layer, 2);
	check(!publish(publication, error) && get(layer) == "concurrent replacement", "replacement during verification is never overwritten");
	check(!recover(catalog, root, false, error) && get(layer) == "concurrent replacement", "recovery preserves an unknown replacement");
	put(layer, "second");
	check(recover(catalog, root, true, error), "explicit conflict resolution permits rollback");
	arm("displaced", layer, 3);
	check(!publish(publication, error) && get(layer) == "concurrent creation", "creation in the replacement window is preserved");
	check(!recover(catalog, root, true, error), "rollback does not overwrite concurrent creation");
	put(layer, "second");
	check(recover(catalog, root, true, error), "resolve creation conflict explicitly");
	arm("prepared", catalog, 1);
	check(!publish(publication, error) && pending(catalog), "interrupt before any application");
	competingFile = layer;
	arm("recovery-verified", catalog, 4);
	check(!recover(catalog, root, false, error) && get(layer) == "later recovery edit", "recovery rechecks the originally observed revision");
	put(layer, "second");
	arm("displaced", layer, 1);
	check(!recover(catalog, root, false, error) && !std::filesystem::exists(layer), "recovery itself can be interrupted");
	check(recover(catalog, root, true, error) && get(layer) == "second", "a second recovery preserves recoverability");
	const auto external = scratch / (root.filename().string() + ".lua");
	put(external, "original implementation");
	publication.guards[external] = "original implementation";
	arm("prepared", catalog, 1);
	check(!publish(publication, error), "prepare external descriptor guard");
	put(external, "changed implementation");
	check(!recover(catalog, root, false, error) && get(layer) == "second", "recovery checks external read-only dependencies");
	put(external, "original implementation");
	check(recover(catalog, root, true, error), "recover after resolving external dependency");
	publication.changes = { { root / "map.world.json.pending", {}, "invalid" } };
	check(!publish(publication, error) && !pending(catalog), "reserved transaction paths cannot be publication targets");
	world_files::setTestHook(nullptr);
}
