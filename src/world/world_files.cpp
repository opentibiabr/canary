#include "world/world_files.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <nlohmann/json.hpp>
	#include <fstream>
	#include <chrono>
	#include <random>
	#include <set>
	#include <algorithm>
	#include <system_error>
#endif
#include <cerrno>
#ifdef _WIN32
	#ifndef NOMINMAX
		#define NOMINMAX
	#endif
	#include <windows.h>
#else
	#include <fcntl.h>
	#include <sys/file.h>
	#include <unistd.h>
	#ifdef __linux__
		#include <sys/syscall.h>
		#include <linux/fs.h>
	#elif defined(__APPLE__)
		#include <sys/stdio.h>
	#endif
#endif

namespace world_files {
	namespace {
		using Json = nlohmann::ordered_json;
#ifdef WORLD_FILES_TEST_HOOKS
		thread_local void (*testHook)(const char*, const std::filesystem::path &) = nullptr;
		void checkpoint(const char* stage, const std::filesystem::path &file) {
			if (testHook) {
				testHook(stage, file);
			}
		}
#else
		void checkpoint(const char*, const std::filesystem::path &) { }
#endif
		std::filesystem::path sidecar(std::filesystem::path catalog, const char* suffix) {
			catalog += suffix;
			return catalog;
		}
		std::string systemError() {
#ifdef _WIN32
			return "Windows error " + std::to_string(GetLastError());
#else
			return std::error_code(errno, std::generic_category()).message();
#endif
		}
		class Lease {
		public:
			Lease() = default;
			Lease(const Lease &) = delete;
			Lease &operator=(const Lease &) = delete;
			~Lease() {
#ifdef _WIN32
				if (handle != INVALID_HANDLE_VALUE) {
					CloseHandle(handle);
				}
#else
				if (handle != -1) {
					close(handle);
				}
#endif
			}
			bool acquire(const std::filesystem::path &file, bool create, bool movable, std::string &error) {
#ifdef _WIN32
				handle = CreateFileW(file.c_str(), GENERIC_READ, movable ? FILE_SHARE_READ | FILE_SHARE_DELETE : 0, nullptr, create ? OPEN_ALWAYS : OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
				if (handle != INVALID_HANDLE_VALUE) {
					return true;
				}
#else
				handle = open(file.c_str(), (create ? O_RDWR | O_CREAT : O_RDONLY) | O_CLOEXEC | O_NOFOLLOW, 0644);
				if (handle != -1 && flock(handle, LOCK_EX | LOCK_NB) == 0) {
					return true;
				}
#endif
				error = "File is busy or cannot be locked: " + file.generic_string() + " (" + systemError() + ")";
				return false;
			}

		private:
#ifdef _WIN32
			HANDLE handle = INVALID_HANDLE_VALUE;
#else
			int handle = -1;
#endif
		};
		bool durable(const std::filesystem::path &file, const std::string &content, std::string &error, bool publicFile = false) {
#ifdef _WIN32
			const auto handle = CreateFileW(file.c_str(), GENERIC_WRITE, 0, nullptr, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, nullptr);
			if (handle == INVALID_HANDLE_VALUE) {
				error = systemError();
				return false;
			}
			size_t cursor = 0;
			bool good = true;
			while (cursor < content.size()) {
				DWORD written = 0;
				if (!WriteFile(handle, content.data() + cursor, static_cast<DWORD>(std::min<size_t>(content.size() - cursor, 1024 * 1024)), &written, nullptr) || !written) {
					good = false;
					break;
				}
				cursor += written;
			}
			if (good) {
				good = FlushFileBuffers(handle) != 0;
			}
			if (!good) {
				error = systemError();
			}
			CloseHandle(handle);
#else
			const auto handle = open(file.c_str(), O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC | O_NOFOLLOW, publicFile ? 0644 : 0600);
			if (handle == -1) {
				error = systemError();
				return false;
			}
			size_t cursor = 0;
			bool good = true;
			while (cursor < content.size()) {
				const auto written = write(handle, content.data() + cursor, content.size() - cursor);
				if (written < 0 && errno == EINTR) {
					continue;
				}
				if (written <= 0) {
					good = false;
					break;
				}
				cursor += static_cast<size_t>(written);
			}
			if (good) {
				good = fsync(handle) == 0;
			}
			if (!good) {
				error = systemError();
			}
			close(handle);
#endif
			return good;
		}
		bool move(const std::filesystem::path &from, const std::filesystem::path &to, bool replace, std::string &error) {
#ifdef _WIN32
			if (MoveFileExW(from.c_str(), to.c_str(), MOVEFILE_WRITE_THROUGH | (replace ? MOVEFILE_REPLACE_EXISTING : 0))) {
				return true;
			}
			error = systemError();
			return false;
#else
			std::error_code code;
			if (replace) {
				std::filesystem::rename(from, to, code);
				if (code) {
					error = code.message();
					return false;
				}
				return true;
			}
	// Displacement must also be atomic. link+unlink could unlink a new
	// competing version installed between those two operations.
	#ifdef __linux__
			if (syscall(SYS_renameat2, AT_FDCWD, from.c_str(), AT_FDCWD, to.c_str(), RENAME_NOREPLACE) == 0) {
				return true;
			}
	#elif defined(__APPLE__)
			if (renamex_np(from.c_str(), to.c_str(), RENAME_EXCL) == 0) {
				return true;
			}
	#else
			error = "Atomic no-replace file publication is unavailable on this platform";
			return false;
	#endif
			error = systemError();
			return false;
#endif
		}
		void syncDirectory(const std::filesystem::path &directory) {
#ifndef _WIN32
			const auto descriptor = open(directory.c_str(), O_RDONLY | O_DIRECTORY | O_CLOEXEC);
			if (descriptor != -1) {
				fsync(descriptor);
				close(descriptor);
			}
#endif
		}
		std::string nonce() {
			return std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()) + "-" + std::to_string(std::random_device {}());
		}
		bool inside(const std::filesystem::path &root, const std::filesystem::path &file) {
			const auto relative = std::filesystem::weakly_canonical(file).lexically_relative(std::filesystem::weakly_canonical(root));
			if (relative.empty() || relative.is_absolute()) {
				return false;
			}
			for (const auto &part : relative) {
				if (part == "..") {
					return false;
				}
			}
			return true;
		}
		bool targetAllowed(const std::filesystem::path &root, const std::filesystem::path &catalog, const std::filesystem::path &file) {
			if (!inside(root, file)) {
				return false;
			}
			const auto path = std::filesystem::weakly_canonical(file);
			for (const auto suffix : { ".lock", ".pending", ".revision", ".transactions" }) {
				if (path == std::filesystem::weakly_canonical(sidecar(catalog, suffix))) {
					return false;
				}
			}
			return !inside(sidecar(catalog, ".transactions"), path);
		}
		bool regular(const std::filesystem::path &file, std::string &error) {
			std::error_code code;
			const auto status = std::filesystem::symlink_status(file, code);
			if (code == std::errc::no_such_file_or_directory || (!code && status.type() == std::filesystem::file_type::not_found)) {
				return true;
			}
			if (code || !std::filesystem::is_regular_file(status)) {
				error = "Expected a regular file: " + file.generic_string();
				return false;
			}
			return true;
		}
		bool expected(const std::filesystem::path &file, const Revision &wanted, std::string &error) {
			Revision actual;
			if (!revision(file, actual, error)) {
				return false;
			}
			if (actual != wanted) {
				error = "Concurrent change detected: " + file.generic_string();
				return false;
			}
			return true;
		}
		bool install(const Change &change, const std::filesystem::path &directory, const std::string &prefix, std::string &error) {
			if (!regular(change.file, error) || !expected(change.file, change.before, error)) {
				return false;
			}
			const auto permissions = change.before ? std::filesystem::status(change.file).permissions() : std::filesystem::perms::unknown;
			Lease original;
			const auto displaced = directory / (prefix + ".displaced");
			if (change.before) {
				if (!original.acquire(change.file, false, true, error) || !expected(change.file, change.before, error)) {
					return false;
				}
				checkpoint("verified", change.file);
				if (!move(change.file, displaced, false, error)) {
					return false;
				}
				// Catch a replacement between verification and displacement. It
				// remains recoverable even if another editor already created a name.
				if (!expected(displaced, change.before, error)) {
					std::string ignored;
					move(displaced, change.file, false, ignored);
					return false;
				}
			}
			checkpoint("displaced", change.file);
			if (change.after) {
				const auto next = directory / (prefix + ".publish");
				if (!durable(next, *change.after, error, true)) {
					return false;
				}
#ifndef _WIN32
				if (permissions != std::filesystem::perms::unknown) {
					std::filesystem::permissions(next, permissions);
				}
#endif
				if (!move(next, change.file, false, error)) {
					return false;
				}
			}
			syncDirectory(change.file.parent_path());
			checkpoint("installed", change.file);
			return expected(change.file, change.after, error);
		}
		bool complete(const std::filesystem::path &catalog, const std::filesystem::path &directory, std::string &error) {
			const auto token = nonce();
			const auto temporary = directory / ("revision-" + token);
			if (!durable(temporary, token, error) || !move(temporary, sidecar(catalog, ".revision"), true, error)) {
				return false;
			}
			std::error_code code;
			if (!std::filesystem::remove(sidecar(catalog, ".pending"), code) || code) {
				error = "Cannot finish World publication: " + code.message();
				return false;
			}
			syncDirectory(catalog.parent_path());
			return true;
		}
		bool jsonFile(const std::filesystem::path &file, Json &value, std::string &error) {
			Revision content;
			if (!revision(file, content, error) || !content) {
				if (error.empty()) {
					error = "Missing recovery journal";
				}
				return false;
			}
			std::vector<std::set<std::string>> keys;
			bool duplicate = false;
			value = Json::parse(*content, [&](int, Json::parse_event_t event, Json &entry) {
				if (event == Json::parse_event_t::object_start) {
					keys.emplace_back();
				} else if (event == Json::parse_event_t::key && !keys.back().insert(entry.get<std::string>()).second) {
					duplicate = true;
				} else if (event == Json::parse_event_t::object_end) {
					keys.pop_back();
				}
				return true;
			});
			if (duplicate || !value.is_object()) {
				error = "Invalid recovery JSON: " + file.generic_string();
				return false;
			}
			return true;
		}
		bool fields(const Json &value, std::initializer_list<const char*> names) {
			if (!value.is_object() || value.size() != names.size()) {
				return false;
			}
			return std::all_of(names.begin(), names.end(), [&](const char* name) { return value.contains(name); });
		}
		bool wasDisplaced(const std::filesystem::path &directory, size_t index, const Change &change, std::string &error) {
			const auto suffix = std::to_string(index) + ".displaced";
			for (const auto &entry : std::filesystem::directory_iterator(directory)) {
				const auto name = entry.path().filename().string();
				if (name != suffix && !(name.starts_with("recovery-") && name.ends_with("-" + suffix))) {
					continue;
				}
				Revision bytes;
				if (!revision(entry.path(), bytes, error)) {
					return false;
				}
				if (bytes && (bytes == change.before || bytes == change.after)) {
					return true;
				}
			}
			return false;
		}
	}
#ifdef WORLD_FILES_TEST_HOOKS
	void setTestHook(void (*hook)(const char*, const std::filesystem::path &)) {
		testHook = hook;
	}
#endif

	bool revision(const std::filesystem::path &file, Revision &result, std::string &error) {
		if (!regular(file, error)) {
			return false;
		}
		std::error_code code;
		if (!std::filesystem::exists(file, code)) {
			if (code) {
				error = code.message();
				return false;
			}
			result.reset();
			return true;
		}
		std::ifstream stream(file, std::ios::binary | std::ios::ate);
		if (!stream) {
			error = "Cannot read revision: " + file.generic_string();
			return false;
		}
		const auto length = stream.tellg();
		if (length < 0 || length > 16 * 1024 * 1024) {
			error = "Revision exceeds 16 MiB: " + file.generic_string();
			return false;
		}
		std::string bytes(static_cast<size_t>(length), '\0');
		stream.seekg(0);
		if (!stream.read(bytes.data(), length)) {
			error = "Cannot read complete revision: " + file.generic_string();
			return false;
		}
		result = std::move(bytes);
		return true;
	}
	bool pending(const std::filesystem::path &catalog) {
		std::error_code error;
		return std::filesystem::exists(sidecar(catalog, ".pending"), error) || bool(error);
	}

	bool publish(const Publication &publication, std::string &error) {
		try {
			const auto catalog = std::filesystem::absolute(publication.catalog).lexically_normal();
			const auto root = std::filesystem::weakly_canonical(publication.root);
			if (!inside(root, catalog)) {
				error = "Catalog lies outside the publication root";
				return false;
			}
			std::filesystem::create_directories(catalog.parent_path());
			Lease lock;
			if (!lock.acquire(sidecar(catalog, ".lock"), true, false, error)) {
				return false;
			}
			if (pending(catalog)) {
				error = "An interrupted World publication requires recovery: " + catalog.generic_string();
				return false;
			}
			std::set<std::filesystem::path> paths;
			for (const auto &change : publication.changes) {
				const auto path = std::filesystem::weakly_canonical(change.file);
				if (!targetAllowed(root, catalog, path) || !paths.insert(path).second) {
					error = "Invalid or repeated publication target";
					return false;
				}
				if (!expected(change.file, change.before, error)) {
					return false;
				}
			}
			for (const auto &[file, wanted] : publication.guards) {
				if (!expected(file, wanted, error)) {
					return false;
				}
			}
			if (publication.changes.empty()) {
				return true;
			}
			const auto transactions = sidecar(catalog, ".transactions");
			std::filesystem::create_directories(transactions);
			const auto id = nonce();
			const auto directory = transactions / id;
			if (!std::filesystem::create_directory(directory)) {
				error = "Cannot reserve publication directory";
				return false;
			}
			Json journal = { { "version", 1 }, { "catalog", catalog.lexically_relative(root).generic_string() }, { "changes", Json::array() }, { "guards", Json::array() } };
			for (size_t i = 0; i < publication.changes.size(); ++i) {
				const auto &change = publication.changes[i];
				const auto prefix = std::to_string(i);
				std::filesystem::create_directories(change.file.parent_path());
				if (change.before && !durable(directory / (prefix + ".before"), *change.before, error)) {
					return false;
				}
				if (change.after && !durable(directory / (prefix + ".after"), *change.after, error)) {
					return false;
				}
				journal["changes"].push_back({ { "file", std::filesystem::absolute(change.file).lexically_normal().lexically_relative(root).generic_string() }, { "before", change.before.has_value() }, { "after", change.after.has_value() } });
			}
			size_t guardIndex = 0;
			for (const auto &[file, wanted] : publication.guards) {
				if (paths.contains(std::filesystem::weakly_canonical(file))) {
					continue;
				}
				const auto name = "guard-" + std::to_string(guardIndex++);
				if (wanted && !durable(directory / name, *wanted, error)) {
					return false;
				}
				journal["guards"].push_back({ { "file", std::filesystem::absolute(file).lexically_normal().lexically_relative(root).generic_string() }, { "snapshot", name }, { "exists", wanted.has_value() } });
			}
			if (!durable(directory / "journal.json", journal.dump(2), error)) {
				return false;
			}
			syncDirectory(directory);
			if (!durable(sidecar(catalog, ".pending"), Json { { "version", 1 }, { "directory", id } }.dump(), error)) {
				return false;
			}
			syncDirectory(catalog.parent_path());
			checkpoint("prepared", catalog);
			for (size_t i = 0; i < publication.changes.size(); ++i) {
				if (!install(publication.changes[i], directory, std::to_string(i), error)) {
					error += "; recovery data: " + directory.generic_string();
					return false;
				}
			}
			for (const auto &[file, wanted] : publication.guards) {
				if (!paths.contains(std::filesystem::weakly_canonical(file)) && !expected(file, wanted, error)) {
					return false;
				}
			}
			for (const auto &change : publication.changes) {
				if (!expected(change.file, change.after, error)) {
					return false;
				}
			}
			return complete(catalog, directory, error);
		} catch (const std::exception &exception) {
			error = exception.what();
			return false;
		}
	}

	bool recover(const std::filesystem::path &catalog, const std::filesystem::path &root, bool rollback, std::string &error) {
		try {
			Lease lock;
			if (!inside(root, catalog) || !lock.acquire(sidecar(catalog, ".lock"), true, false, error)) {
				return false;
			}
			Json marker, journal;
			if (!jsonFile(sidecar(catalog, ".pending"), marker, error) || !fields(marker, { "version", "directory" }) || marker.value("version", 0) != 1 || !marker["directory"].is_string()) {
				error = "Invalid pending publication marker";
				return false;
			}
			const std::filesystem::path name = marker["directory"].get<std::string>();
			if (name.empty() || name != name.filename() || name == "." || name == "..") {
				error = "Invalid recovery directory";
				return false;
			}
			const auto directory = sidecar(catalog, ".transactions") / name;
			if (!inside(sidecar(catalog, ".transactions"), directory) || !jsonFile(directory / "journal.json", journal, error) || !fields(journal, { "version", "catalog", "changes", "guards" }) || journal.value("version", 0) != 1 || !journal["changes"].is_array() || !journal["guards"].is_array() || std::filesystem::weakly_canonical(root / journal.at("catalog").get<std::string>()) != std::filesystem::weakly_canonical(catalog)) {
				error = "Recovery journal does not belong to this catalog/root";
				return false;
			}
			std::vector<Change> changes;
			std::set<std::filesystem::path> paths;
			for (size_t i = 0; i < journal.at("changes").size(); ++i) {
				const auto &entry = journal["changes"][i];
				if (!fields(entry, { "file", "before", "after" })) {
					error = "Invalid recovery change";
					return false;
				}
				Change change;
				change.file = std::filesystem::absolute(root / entry.at("file").get<std::string>()).lexically_normal();
				if (!targetAllowed(root, catalog, change.file) || !paths.insert(change.file).second) {
					error = "Recovery target is reserved, outside the authorized root or repeated";
					return false;
				}
				if (entry.at("before").get<bool>() && (!revision(directory / (std::to_string(i) + ".before"), change.before, error) || !change.before)) {
					return false;
				}
				if (entry.at("after").get<bool>() && (!revision(directory / (std::to_string(i) + ".after"), change.after, error) || !change.after)) {
					return false;
				}
				changes.push_back(std::move(change));
			}
			std::map<std::filesystem::path, Revision> guards;
			for (const auto &entry : journal.at("guards")) {
				if (!fields(entry, { "file", "snapshot", "exists" })) {
					error = "Invalid recovery guard";
					return false;
				}
				const auto file = std::filesystem::weakly_canonical(root / entry.at("file").get<std::string>());
				const std::filesystem::path snapshot = entry.at("snapshot").get<std::string>();
				if (snapshot != snapshot.filename() || snapshot.empty() || snapshot == "." || snapshot == ".." || paths.contains(file)) {
					error = "Invalid recovery guard";
					return false;
				}
				Revision wanted;
				if (entry.at("exists").get<bool>() && (!revision(directory / snapshot, wanted, error) || !wanted)) {
					return false;
				}
				if (!expected(file, wanted, error)) {
					return false;
				}
				if (!guards.emplace(file, wanted).second) {
					error = "Repeated recovery guard";
					return false;
				}
			}
			// Preflight every target before changing any name. Unknown versions are
			// left untouched; recovery is not permission to overwrite later edits.
			std::vector<Revision> observed;
			for (size_t i = 0; i < changes.size(); ++i) {
				Revision actual;
				if (!revision(changes[i].file, actual, error)) {
					return false;
				}
				if (actual != changes[i].before && actual != changes[i].after) {
					if (actual || !wasDisplaced(directory, i, changes[i], error)) {
						error = "Recovery conflicts with a later edit: " + changes[i].file.generic_string();
						return false;
					}
				}
				observed.push_back(std::move(actual));
			}
			checkpoint("recovery-verified", catalog);
			const auto attempt = "recovery-" + nonce() + "-";
			for (size_t n = 0; n < changes.size(); ++n) {
				const size_t i = rollback ? changes.size() - n - 1 : n;
				const auto &wanted = rollback ? changes[i].before : changes[i].after;
				if (!expected(changes[i].file, observed[i], error)) {
					return false;
				}
				if (observed[i] != wanted && !install({ changes[i].file, observed[i], wanted }, directory, attempt + std::to_string(i), error)) {
					return false;
				}
			}
			for (const auto &[file, wanted] : guards) {
				if (!expected(file, wanted, error)) {
					return false;
				}
			}
			for (const auto &change : changes) {
				if (!expected(change.file, rollback ? change.before : change.after, error)) {
					return false;
				}
			}
			return complete(catalog, directory, error);
		} catch (const std::exception &exception) {
			error = exception.what();
			return false;
		}
	}

	struct ReadGuard::State {
		std::filesystem::path catalog;
		Revision token;
		Lease lock;
		bool good = false;
	};
	ReadGuard::ReadGuard(const std::filesystem::path &catalog, std::string &error) :
		state(std::make_unique<State>()) {
		state->catalog = catalog;
		if (!revision(sidecar(catalog, ".revision"), state->token, error)) {
			return;
		}
		const auto lock = sidecar(catalog, ".lock");
		if (std::filesystem::exists(lock) && !state->lock.acquire(lock, false, false, error)) {
			return;
		}
		if (pending(catalog)) {
			error = "Incomplete World publication; recover the project before loading it";
			return;
		}
		state->good = true;
	}
	ReadGuard::~ReadGuard() = default;
	bool ReadGuard::valid() const {
		return state->good;
	}
	bool ReadGuard::unchanged(std::string &error) const {
		if (!valid()) {
			return false;
		}
		if (pending(state->catalog)) {
			error = "World publication started while the project was loading";
			return false;
		}
		return expected(sidecar(state->catalog, ".revision"), state->token, error);
	}
}
