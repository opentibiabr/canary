/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/scripts/luascript.hpp"

#include "lua/scripts/lua_environment.hpp"
#include "config/configmanager.hpp"
#include "lib/metrics/metrics.hpp"
#include "utils/transparent_string_hash.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <atomic>
	#include <array>
	#include <bit>
	#include <fstream>
	#include <limits>
	#include <new>
	#include <optional>
	#include <stdexcept>
	#include <string_view>
	#include <unordered_map>
	#include <unordered_set>
#endif

ScriptEnvironment::DBResultMap ScriptEnvironment::tempResults;
uint32_t ScriptEnvironment::lastResultId = 0;
std::multimap<ScriptEnvironment*, std::shared_ptr<Item>> ScriptEnvironment::tempItems;

ScriptEnvironment Lua::scriptEnv[16];
int32_t Lua::scriptEnvIndex = -1;

namespace {
	constexpr std::string_view LuaBytecodeCacheFallbackPath = "cache/lua-bytecode";
	constexpr std::string_view LuaBytecodePackMagic = "CLBP1";
	constexpr uint64_t LuaBytecodePackMaxChunkSize = 256ULL * 1024ULL * 1024ULL;

#if defined(LUAJIT_VERSION)
	constexpr std::string_view LuaBytecodeCacheVersion = LUAJIT_VERSION;
#else
	constexpr std::string_view LuaBytecodeCacheVersion = LUA_RELEASE;
#endif

	[[nodiscard]] uint64_t fnv1a64(std::string_view value) noexcept {
		uint64_t hash = 14695981039346656037ULL;
		for (const auto character : value) {
			hash ^= static_cast<uint8_t>(character);
			hash *= 1099511628211ULL;
		}
		return hash;
	}

	struct LuaBytecodeCacheEntry {
		std::filesystem::path file;
		std::filesystem::path packFile;
		std::string key;
	};

	struct LuaFileBufferLoadResult {
		int status = -1;
		std::string buffer;
	};

	struct LuaBytecodePack {
		bool loaded = false;
		std::unordered_map<std::string, std::string, TransparentStringHasher, std::equal_to<>> chunks;
	};

	struct AtomicLuaBytecodeCacheStats {
		std::atomic<uint64_t> packHits = 0;
		std::atomic<uint64_t> fileHits = 0;
		std::atomic<uint64_t> misses = 0;
		std::atomic<uint64_t> writes = 0;
		std::atomic<uint64_t> packInvalidations = 0;
		std::atomic<uint64_t> fileInvalidations = 0;
	};

	AtomicLuaBytecodeCacheStats g_luaBytecodeCacheStats;
	std::mutex g_luaBytecodeCacheDirectoryMutex;
	std::unordered_set<std::string, TransparentStringHasher, std::equal_to<>> g_luaBytecodeReadyDirectories;
	std::once_flag g_luaBytecodeCacheDirectoryInitFlag;
	std::filesystem::path g_luaBytecodeCacheDirectory;
	std::once_flag g_luaStartupWorkingDirectoryInitFlag;
	std::filesystem::path g_luaStartupWorkingDirectory;
	std::mutex g_luaBytecodePackMutex;
	std::unordered_map<std::string, LuaBytecodePack, TransparentStringHasher, std::equal_to<>> g_luaBytecodePacks;

	[[nodiscard]] AtomicLuaBytecodeCacheStats &getMutableLuaBytecodeCacheStats() {
		return g_luaBytecodeCacheStats;
	}

	void incrementLuaBytecodeCacheCounter(std::atomic<uint64_t> &counter) noexcept {
		static_cast<void>(counter.fetch_add(1, std::memory_order_relaxed));
	}

	int luaBytecodeWriter(
		lua_State*,
		const void* data, // NOSONAR
		size_t size,
		void* outputBuffer // NOSONAR
	) {
		auto &output = *static_cast<std::string*>(outputBuffer);
		try {
			static_cast<void>(output.append(static_cast<const char*>(data), size));
		} catch (const std::bad_alloc &) {
			return 1;
		} catch (const std::length_error &) {
			return 1;
		}

		return 0;
	}

	std::optional<std::string> readLuaFileBuffer(const std::filesystem::path &file) {
		std::ifstream input(file, std::ios::binary | std::ios::ate);
		if (!input.is_open()) {
			return std::nullopt;
		}

		const auto fileSize = input.tellg();
		if (fileSize < 0) {
			return std::nullopt;
		}

		std::string buffer(static_cast<size_t>(fileSize), '\0');
		if (!input.seekg(0, std::ios::beg)) {
			return std::nullopt;
		}
		if (!buffer.empty()) {
			const auto expectedSize = static_cast<std::streamsize>(buffer.size());
			const auto readOk = static_cast<bool>(input.read(buffer.data(), expectedSize));
			if (input.gcount() != expectedSize || (!readOk && !input.eof())) {
				return std::nullopt;
			}
		}

		return buffer;
	}

	std::optional<LuaFileBufferLoadResult> loadLuaChunkFromFileBuffer(lua_State* luaState, const std::filesystem::path &file, const std::string &chunkName) {
		auto buffer = readLuaFileBuffer(file);
		if (!buffer) {
			return std::nullopt;
		}

		const auto status = luaL_loadbuffer(luaState, buffer->data(), buffer->size(), chunkName.c_str());
		return LuaFileBufferLoadResult {
			.status = status,
			.buffer = std::move(*buffer),
		};
	}

	bool ensureLuaBytecodeCacheDirectory(const std::filesystem::path &cacheDirectory) {
		const auto directoryKey = cacheDirectory.lexically_normal().string();
		std::scoped_lock lock(g_luaBytecodeCacheDirectoryMutex);
		if (g_luaBytecodeReadyDirectories.contains(directoryKey)) {
			return true;
		}

		std::error_code error;
		const auto createdDirectory = std::filesystem::create_directories(cacheDirectory, error);
		if (error) {
			g_logger().debug("Could not create Lua bytecode cache directory '{}': {}", cacheDirectory.string(), error.message());
			return false;
		}
		if (!createdDirectory) {
			std::error_code statusError;
			if (!std::filesystem::is_directory(cacheDirectory, statusError)) {
				const auto reason = statusError ? statusError.message() : "path exists but is not a directory";
				g_logger().debug("Could not create Lua bytecode cache directory '{}': {}", cacheDirectory.string(), reason);
				return false;
			}
		}

		static_cast<void>(g_luaBytecodeReadyDirectories.insert(directoryKey));
		return true;
	}

	[[nodiscard]] const std::filesystem::path &getLuaBytecodeCacheDirectory() {
		std::call_once(g_luaBytecodeCacheDirectoryInitFlag, [] {
			auto configuredPath = g_configManager().getString(LUA_SCRIPT_BYTECODE_CACHE_PATH);
			if (configuredPath.empty()) {
				configuredPath = std::string(LuaBytecodeCacheFallbackPath);
			}

			std::filesystem::path directory(configuredPath);
			if (directory.is_relative()) {
				std::error_code error;
				const auto currentPath = std::filesystem::current_path(error);
				if (!error) {
					directory = currentPath / directory;
				}
			}

			g_luaBytecodeCacheDirectory = directory.lexically_normal();
		});

		return g_luaBytecodeCacheDirectory;
	}

	[[nodiscard]] const std::filesystem::path &getLuaStartupWorkingDirectory() {
		std::call_once(g_luaStartupWorkingDirectoryInitFlag, [] {
			std::error_code error;
			auto directory = std::filesystem::current_path(error);
			if (error) {
				g_luaStartupWorkingDirectory.clear();
				return;
			}

			g_luaStartupWorkingDirectory = directory.lexically_normal();
		});

		return g_luaStartupWorkingDirectory;
	}

	[[nodiscard]] std::string getLuaBytecodeSourceIdentity(const std::string &file) {
		std::filesystem::path sourcePath(file);
		if (sourcePath.is_relative()) {
			sourcePath = getLuaStartupWorkingDirectory() / sourcePath;
		}

		return sourcePath.lexically_normal().generic_string();
	}

	[[nodiscard]] std::filesystem::path getLuaBytecodePackFile(const std::string &sourceIdentity) {
		const auto sourceFolder = std::filesystem::path(sourceIdentity).parent_path().generic_string();
		const auto packKey = fmt::format("{}:{}:{}", LuaBytecodeCacheVersion, sizeof(void*), sourceFolder);
		return getLuaBytecodeCacheDirectory() / "packs" / fmt::format("{:016x}.luapack", fnv1a64(packKey));
	}

	[[nodiscard]] bool readBytes(std::istream &input, char* data, std::streamsize size) {
		return static_cast<bool>(input.read(data, size)) || input.gcount() == size;
	}

	template <typename T>
	[[nodiscard]] bool readBinaryValue(std::istream &input, T &value) {
		std::array<char, sizeof(T)> bytes {};
		if (!readBytes(input, bytes.data(), static_cast<std::streamsize>(bytes.size()))) {
			return false;
		}

		value = std::bit_cast<T>(bytes);
		return true;
	}

	template <typename T>
	[[nodiscard]] bool writeBinaryValue(std::ostream &output, T value) {
		const auto bytes = std::bit_cast<std::array<char, sizeof(T)>>(value);
		return static_cast<bool>(output.write(bytes.data(), static_cast<std::streamsize>(bytes.size())));
	}

	[[nodiscard]] LuaBytecodePack readLuaBytecodePack(const std::filesystem::path &packFile) {
		LuaBytecodePack pack;

		std::ifstream input(packFile, std::ios::binary);
		if (!input.is_open()) {
			return pack;
		}

		std::string magic(LuaBytecodePackMagic.size(), '\0');
		if (!readBytes(input, magic.data(), static_cast<std::streamsize>(magic.size())) || magic != std::string(LuaBytecodePackMagic)) {
			return pack;
		}

		while (true) {
			uint16_t keySize = 0;
			if (!readBinaryValue(input, keySize)) {
				if (input.eof() && input.gcount() == 0) {
					pack.loaded = true;
				}
				return pack;
			}

			uint64_t chunkSize = 0;
			if (!readBinaryValue(input, chunkSize) || keySize == 0 || chunkSize > LuaBytecodePackMaxChunkSize) {
				return {};
			}

			std::string key(keySize, '\0');
			if (!readBytes(input, key.data(), static_cast<std::streamsize>(key.size()))) {
				return {};
			}

			std::string bytecode(static_cast<size_t>(chunkSize), '\0');
			if (!bytecode.empty() && !readBytes(input, bytecode.data(), static_cast<std::streamsize>(bytecode.size()))) {
				return {};
			}

			static_cast<void>(pack.chunks.insert_or_assign(std::move(key), std::move(bytecode)));
		}

		return pack;
	}

	[[nodiscard]] bool luaBytecodePackHasValidMagic(const std::filesystem::path &packFile) {
		std::ifstream input(packFile, std::ios::binary);
		if (!input.is_open()) {
			return false;
		}

		std::string magic(LuaBytecodePackMagic.size(), '\0');
		return readBytes(input, magic.data(), static_cast<std::streamsize>(magic.size())) && magic == std::string(LuaBytecodePackMagic);
	}

	[[nodiscard]] std::mutex &getLuaBytecodePackMutex() {
		return g_luaBytecodePackMutex;
	}

	[[nodiscard]] std::unordered_map<std::string, LuaBytecodePack, TransparentStringHasher, std::equal_to<>> &getLuaBytecodePacks() {
		return g_luaBytecodePacks;
	}

	[[nodiscard]] std::optional<std::string> findLuaBytecodePackChunk(const LuaBytecodeCacheEntry &cacheEntry) {
		std::scoped_lock lock(getLuaBytecodePackMutex());
		auto &packs = getLuaBytecodePacks();
		const auto packKey = cacheEntry.packFile.string();
		auto [packIt, inserted] = packs.try_emplace(packKey);
		if (inserted || !packIt->second.loaded) {
			packIt->second = readLuaBytecodePack(cacheEntry.packFile);
		}

		const auto chunkIt = packIt->second.chunks.find(cacheEntry.key);
		if (chunkIt == packIt->second.chunks.end()) {
			return std::nullopt;
		}

		return chunkIt->second;
	}

	void invalidateLuaBytecodePack(const std::filesystem::path &packFile) {
		std::scoped_lock lock(getLuaBytecodePackMutex());
		std::error_code error;
		static_cast<void>(std::filesystem::remove(packFile, error));
		static_cast<void>(getLuaBytecodePacks().erase(packFile.string()));
	}

	void appendLuaBytecodePack(const LuaBytecodeCacheEntry &cacheEntry, std::string_view bytecode) {
		if (cacheEntry.key.size() > std::numeric_limits<uint16_t>::max() || bytecode.size() > LuaBytecodePackMaxChunkSize) {
			return;
		}

		if (!ensureLuaBytecodeCacheDirectory(cacheEntry.packFile.parent_path())) {
			return;
		}

		std::scoped_lock lock(getLuaBytecodePackMutex());
		std::error_code error;
		const auto packSize = std::filesystem::file_size(cacheEntry.packFile, error);
		bool writeMagic = error || packSize == 0;
		if (!writeMagic && !luaBytecodePackHasValidMagic(cacheEntry.packFile)) {
			error.clear();
			static_cast<void>(std::filesystem::remove(cacheEntry.packFile, error));
			incrementLuaBytecodeCacheCounter(getMutableLuaBytecodeCacheStats().packInvalidations);
			writeMagic = true;
		}

		std::ofstream output(cacheEntry.packFile, std::ios::binary | std::ios::app);
		if (!output.is_open()) {
			return;
		}

		if (writeMagic && !output.write(LuaBytecodePackMagic.data(), static_cast<std::streamsize>(LuaBytecodePackMagic.size()))) {
			return;
		}

		if (!writeBinaryValue(output, static_cast<uint16_t>(cacheEntry.key.size()))
		    || !writeBinaryValue(output, static_cast<uint64_t>(bytecode.size()))
		    || !output.write(cacheEntry.key.data(), static_cast<std::streamsize>(cacheEntry.key.size()))
		    || !output.write(bytecode.data(), static_cast<std::streamsize>(bytecode.size()))) {
			return;
		}

		output.close();
		if (!output.good()) {
			return;
		}

		auto &pack = getLuaBytecodePacks()[cacheEntry.packFile.string()];
		if (!pack.loaded) {
			pack = readLuaBytecodePack(cacheEntry.packFile);
		}
		static_cast<void>(pack.chunks.insert_or_assign(cacheEntry.key, std::string(bytecode)));
	}

	[[nodiscard]] std::optional<LuaBytecodeCacheEntry> getLuaBytecodeCacheEntry(const std::string &file, const LuaScriptFileMetadata* sourceMetadata) {
		const auto sourceBuffer = readLuaFileBuffer(file);
		if (!sourceBuffer) {
			return std::nullopt;
		}
		const auto sourceHash = fnv1a64(std::string_view { *sourceBuffer });
		LuaScriptFileMetadata fallbackMetadata;
		if (sourceMetadata == nullptr) {
			std::error_code error;
			const std::filesystem::directory_entry sourceEntry(file, error);
			if (error) {
				return std::nullopt;
			}

			fallbackMetadata.size = sourceEntry.file_size(error);
			if (error) {
				return std::nullopt;
			}

			fallbackMetadata.lastWriteTime = sourceEntry.last_write_time(error);
			if (error) {
				return std::nullopt;
			}

			sourceMetadata = &fallbackMetadata;
		}

		const auto sourceIdentity = getLuaBytecodeSourceIdentity(file);
		const auto cacheKey = fmt::format(
			"{}:{}:{}:{}:{}:{}",
			LuaBytecodeCacheVersion,
			sizeof(void*),
			sourceIdentity,
			sourceMetadata->size,
			sourceMetadata->lastWriteTime.time_since_epoch().count(),
			fmt::format("{:016x}", sourceHash)
		);
		const auto cacheKeyHash = fmt::format("{:016x}", fnv1a64(cacheKey));

		LuaBytecodeCacheEntry entry;
		entry.file = getLuaBytecodeCacheDirectory() / fmt::format("{}.luac", cacheKeyHash);
		entry.packFile = getLuaBytecodePackFile(sourceIdentity);
		entry.key = cacheKeyHash;
		return entry;
	}

	void writeLuaBytecodeCache(lua_State* luaState, const LuaBytecodeCacheEntry &cacheEntry) {
		if (!ensureLuaBytecodeCacheDirectory(cacheEntry.file.parent_path())) {
			return;
		}

		std::string bytecode;
#if LUA_VERSION_NUM >= 503
		const int dumpResult = lua_dump(luaState, luaBytecodeWriter, &bytecode, 0);
#else
		const int dumpResult = lua_dump(luaState, luaBytecodeWriter, &bytecode);
#endif
		if (dumpResult != 0) {
			return;
		}

		const auto temporaryFile = cacheEntry.file.parent_path() / (cacheEntry.file.filename().string() + ".tmp");
		std::ofstream output(temporaryFile, std::ios::binary | std::ios::trunc);
		if (!output.is_open()) {
			g_logger().debug("Could not write Lua bytecode cache file '{}'", temporaryFile.string());
			return;
		}

		if (!output.write(bytecode.data(), static_cast<std::streamsize>(bytecode.size()))) {
			std::error_code error;
			output.close();
			static_cast<void>(std::filesystem::remove(temporaryFile, error));
			return;
		}

		output.close();
		if (!output.good()) {
			std::error_code error;
			static_cast<void>(std::filesystem::remove(temporaryFile, error));
			return;
		}

		std::error_code error;
		error.clear();
		static_cast<void>(std::filesystem::remove(cacheEntry.file, error));

		error.clear();
		std::filesystem::rename(temporaryFile, cacheEntry.file, error);
		if (error) {
			g_logger().debug("Could not publish Lua bytecode cache file '{}': {}", cacheEntry.file.string(), error.message());
			static_cast<void>(std::filesystem::remove(temporaryFile, error));
			return;
		}

		incrementLuaBytecodeCacheCounter(getMutableLuaBytecodeCacheStats().writes);
		appendLuaBytecodePack(cacheEntry, bytecode);
	}
}

LuaScriptInterface::LuaScriptInterface(std::string initInterfaceName) :
	interfaceName(std::move(initInterfaceName)) {
}

LuaScriptInterface::~LuaScriptInterface() {
	LuaScriptInterface::closeState();
}

bool LuaScriptInterface::reInitState() {
	g_luaEnvironment().clearAreaObjects(this);

	closeState();
	return initState();
}

LuaBytecodeCacheStats LuaScriptInterface::getBytecodeCacheStats() {
	const auto &stats = getMutableLuaBytecodeCacheStats();
	return LuaBytecodeCacheStats {
		.packHits = stats.packHits.load(std::memory_order_relaxed),
		.fileHits = stats.fileHits.load(std::memory_order_relaxed),
		.misses = stats.misses.load(std::memory_order_relaxed),
		.writes = stats.writes.load(std::memory_order_relaxed),
		.packInvalidations = stats.packInvalidations.load(std::memory_order_relaxed),
		.fileInvalidations = stats.fileInvalidations.load(std::memory_order_relaxed),
	};
}

/// Same as lua_pcall, but adds stack trace to error strings in called function.
int32_t LuaScriptInterface::loadFile(const std::string &file, const std::string &scriptName, const LuaScriptFileMetadata* sourceMetadata) {
	// loads file as a chunk at stack top
	int ret = -1;
	const auto bytecodeCacheEntry = g_configManager().getBoolean(LUA_SCRIPT_BYTECODE_CACHE) ? getLuaBytecodeCacheEntry(file, sourceMetadata) : std::nullopt;
	if (bytecodeCacheEntry) {
		const std::string chunkName = "@" + file;
		if (const auto packedBytecode = findLuaBytecodePackChunk(*bytecodeCacheEntry)) {
			ret = luaL_loadbuffer(luaState, packedBytecode->data(), packedBytecode->size(), chunkName.c_str());
			if (ret != 0) {
				lua_pop(luaState, 1);
				incrementLuaBytecodeCacheCounter(getMutableLuaBytecodeCacheStats().packInvalidations);
				invalidateLuaBytecodePack(bytecodeCacheEntry->packFile);
				ret = -1;
			} else {
				incrementLuaBytecodeCacheCounter(getMutableLuaBytecodeCacheStats().packHits);
			}
		}

		if (ret != 0) {
			const auto cacheLoadResult = loadLuaChunkFromFileBuffer(luaState, bytecodeCacheEntry->file, chunkName);
			if (cacheLoadResult) {
				ret = cacheLoadResult->status;
				if (ret == 0) {
					incrementLuaBytecodeCacheCounter(getMutableLuaBytecodeCacheStats().fileHits);
					appendLuaBytecodePack(*bytecodeCacheEntry, cacheLoadResult->buffer);
				} else {
					lua_pop(luaState, 1);
					std::error_code error;
					static_cast<void>(std::filesystem::remove(bytecodeCacheEntry->file, error));
					incrementLuaBytecodeCacheCounter(getMutableLuaBytecodeCacheStats().fileInvalidations);
				}
			}
		}
	}

	const bool loadedFromBytecodeCache = ret == 0;
	if (!loadedFromBytecodeCache) {
		if (bytecodeCacheEntry) {
			incrementLuaBytecodeCacheCounter(getMutableLuaBytecodeCacheStats().misses);
		}
		const auto sourceLoadResult = loadLuaChunkFromFileBuffer(luaState, file, "@" + file);
		ret = sourceLoadResult ? sourceLoadResult->status : luaL_loadfile(luaState, file.c_str());
	}

	if (ret != 0) {
		lastLuaError = popString(luaState);
		return -1;
	}

	// check that it is loaded as a function
	if (!isFunction(luaState, -1)) {
		return -1;
	}

	if (bytecodeCacheEntry && !loadedFromBytecodeCache) {
		writeLuaBytecodeCache(luaState, *bytecodeCacheEntry);
	}

	loadingFile = file;
	setLoadingScriptName(scriptName);

	if (!reserveScriptEnv()) {
		return -1;
	}

	ScriptEnvironment* env = getScriptEnv();
	env->setScriptId(EVENT_ID_LOADING, this);
	// env->setNpc(npc);

	// execute it
	ret = protectedCall(luaState, 0, 0);
	if (ret != 0) {
		reportError(nullptr, popString(luaState));
		resetScriptEnv();
		return -1;
	}

	resetScriptEnv();
	return 0;
}

int32_t LuaScriptInterface::getEvent(const std::string &eventName) {
	// get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	// get current event function pointer
	lua_getglobal(luaState, eventName.c_str());
	if (!isFunction(luaState, -1)) {
		lua_pop(luaState, 2);
		return -1;
	}

	// save in our events table
	lua_pushvalue(luaState, -1);
	lua_rawseti(luaState, -3, runningEventId);
	lua_pop(luaState, 2);

	// reset global value of this event
	lua_pushnil(luaState);
	lua_setglobal(luaState, eventName.c_str());

	cacheFiles[runningEventId] = loadingFile + ":" + eventName;
	return runningEventId++;
}

int32_t LuaScriptInterface::getEvent() {
	// check if function is on the stack
	if (!isFunction(luaState, -1)) {
		return -1;
	}

	// get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	// save in our events table
	lua_pushvalue(luaState, -2);
	lua_rawseti(luaState, -2, runningEventId);
	lua_pop(luaState, 2);

	cacheFiles[runningEventId] = loadingFile + ":callback";
	return runningEventId++;
}

int32_t LuaScriptInterface::getMetaEvent(const std::string &globalName, const std::string &eventName) {
	// get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	// get current event function pointer
	lua_getglobal(luaState, globalName.c_str());
	lua_getfield(luaState, -1, eventName.c_str());
	if (!isFunction(luaState, -1)) {
		lua_pop(luaState, 3);
		return -1;
	}

	// save in our events table
	lua_pushvalue(luaState, -1);
	lua_rawseti(luaState, -4, runningEventId);
	lua_pop(luaState, 1);

	// reset global value of this event
	lua_pushnil(luaState);
	lua_setfield(luaState, -2, eventName.c_str());
	lua_pop(luaState, 2);

	cacheFiles[runningEventId] = loadingFile + ":" + globalName + "@" + eventName;
	return runningEventId++;
}

const std::string &LuaScriptInterface::getFileById(int32_t scriptId) {
	if (scriptId == EVENT_ID_LOADING) {
		return loadingFile;
	}

	const auto it = cacheFiles.find(scriptId);
	if (it == cacheFiles.end()) {
		static const std::string &unk = "(Unknown scriptfile)";
		return unk;
	}
	return it->second;
}

std::string LuaScriptInterface::getStackTrace(const std::string &error_desc) const {
	lua_getglobal(luaState, "debug");
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		g_logger().error("Lua debug table not found.");
		return error_desc;
	}

	lua_getfield(luaState, -1, "traceback");
	if (!isFunction(luaState, -1)) {
		lua_pop(luaState, 2);
		g_logger().error("Lua traceback function not found.");
		return error_desc;
	}

	lua_replace(luaState, -2);
	pushString(luaState, error_desc);
	if (lua_pcall(luaState, 1, 1, 0) != LUA_OK) {
		std::string luaError = lua_tostring(luaState, -1);
		lua_pop(luaState, 1);
		g_logger().error("Error running Lua traceback: {}", luaError);
		return "Lua traceback failed: " + luaError;
	}

	std::string stackTrace = popString(luaState);

	return stackTrace;
}

bool LuaScriptInterface::pushFunction(int32_t functionId) const {
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		return false;
	}

	lua_rawgeti(luaState, -1, functionId);
	lua_replace(luaState, -2);
	return isFunction(luaState, -1);
}

bool LuaScriptInterface::initState() {
	luaState = g_luaEnvironment().getLuaState();
	if (!luaState) {
		return false;
	}

	lua_newtable(luaState);
	eventTableRef = luaL_ref(luaState, LUA_REGISTRYINDEX);
	runningEventId = EVENT_ID_USER;
	return true;
}

bool LuaScriptInterface::closeState() {
	if (LuaEnvironment::isShuttingDown()) {
		luaState = nullptr;
	}

	if (!luaState || !g_luaEnvironment().getLuaState()) {
		return false;
	}

	cacheFiles.clear();
	if (eventTableRef != -1) {
		luaL_unref(luaState, LUA_REGISTRYINDEX, eventTableRef);
		eventTableRef = -1;
	}

	luaState = nullptr;
	return true;
}

std::string LuaScriptInterface::getMetricsScope() const {
#ifdef FEATURE_METRICS
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	int32_t scriptId;
	int32_t callbackId;
	bool timerEvent;
	LuaScriptInterface* scriptInterface;
	getScriptEnv()->getEventInfo(scriptId, scriptInterface, callbackId, timerEvent);

	std::string name;
	if (scriptId == EVENT_ID_LOADING) {
		name = "loading";
	} else if (scriptId == EVENT_ID_USER) {
		name = "user";
	} else {
		name = scriptInterface->getFileById(scriptId);
		if (name.empty()) {
			return "unknown";
		}
		const auto pos = name.find("data");
		if (pos != std::string::npos) {
			name = name.substr(pos);
		}
	}

	return fmt::format("{}:{}", name, timerEvent ? "timer" : "<direct>");
#else
	return {};
#endif
}

bool LuaScriptInterface::callFunction(int params) const {
	metrics::lua_latency measure(getMetricsScope());
	bool result = false;
	const int size = lua_gettop(luaState);
	if (protectedCall(luaState, params, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::getString(luaState, -1));
	} else {
		result = LuaScriptInterface::getBoolean(luaState, -1, true);
	}

	lua_pop(luaState, 1);
	if ((lua_gettop(luaState) + params + 1) != size) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	resetScriptEnv();
	return result;
}

void LuaScriptInterface::callVoidFunction(int params) const {
	metrics::lua_latency measure(getMetricsScope());
	const int size = lua_gettop(luaState);
	if (protectedCall(luaState, params, 0) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(luaState));
	}

	if ((lua_gettop(luaState) + params + 1) != size) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	resetScriptEnv();
}
