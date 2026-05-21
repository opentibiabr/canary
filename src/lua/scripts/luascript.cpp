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

#include <fstream>
#include <limits>
#include <optional>
#include <string_view>
#include <unordered_map>
#include <unordered_set>

#ifndef USE_PRECOMPILED_HEADERS
	#include <exception>
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

	uint64_t fnv1a64(std::string_view value) noexcept {
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
		std::unordered_map<std::string, std::string> chunks;
	};

	int luaBytecodeWriter(lua_State*, const void* data, size_t size, void* outputBuffer) {
		auto &output = *static_cast<std::string*>(outputBuffer);
		try {
			static_cast<void>(output.append(static_cast<const char*>(data), size));
		} catch (const std::exception &) {
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
			const bool readOk = static_cast<bool>(input.read(buffer.data(), expectedSize));
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

		LuaFileBufferLoadResult result;
		result.status = luaL_loadbuffer(luaState, buffer->data(), buffer->size(), chunkName.c_str());
		result.buffer = std::move(*buffer);
		return result;
	}

	bool ensureLuaBytecodeCacheDirectory(const std::filesystem::path &cacheDirectory) {
		static std::mutex mutex;
		static std::unordered_set<std::string> readyDirectories;

		const auto directoryKey = cacheDirectory.lexically_normal().string();
		std::scoped_lock lock(mutex);
		if (readyDirectories.contains(directoryKey)) {
			return true;
		}

		std::error_code error;
		std::filesystem::create_directories(cacheDirectory, error);
		if (error) {
			g_logger().debug("Could not create Lua bytecode cache directory '{}': {}", cacheDirectory.string(), error.message());
			return false;
		}

		static_cast<void>(readyDirectories.insert(directoryKey));
		return true;
	}

	const std::filesystem::path &getLuaBytecodeCacheDirectory() {
		static const auto cacheDirectory = [] {
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

			return directory.lexically_normal();
		}();

		return cacheDirectory;
	}

	const std::filesystem::path &getLuaStartupWorkingDirectory() {
		static const auto workingDirectory = [] {
			std::error_code error;
			auto directory = std::filesystem::current_path(error);
			if (error) {
				return std::filesystem::path();
			}

			return directory.lexically_normal();
		}();

		return workingDirectory;
	}

	std::string getLuaBytecodeSourceIdentity(const std::string &file) {
		std::filesystem::path sourcePath(file);
		if (sourcePath.is_relative()) {
			sourcePath = getLuaStartupWorkingDirectory() / sourcePath;
		}

		return sourcePath.lexically_normal().generic_string();
	}

	std::filesystem::path getLuaBytecodePackFile(const std::string &sourceIdentity) {
		const auto sourceFolder = std::filesystem::path(sourceIdentity).parent_path().generic_string();
		const auto packKey = fmt::format("{}:{}:{}", LuaBytecodeCacheVersion, sizeof(void*), sourceFolder);
		return getLuaBytecodeCacheDirectory() / "packs" / fmt::format("{:016x}.luapack", fnv1a64(packKey));
	}

	bool readBytes(std::istream &input, char* data, std::streamsize size) {
		return static_cast<bool>(input.read(data, size)) || input.gcount() == size;
	}

	template <typename T>
	bool readBinaryValue(std::istream &input, T &value) {
		return readBytes(input, reinterpret_cast<char*>(&value), static_cast<std::streamsize>(sizeof(T)));
	}

	template <typename T>
	bool writeBinaryValue(std::ostream &output, T value) {
		const auto size = static_cast<std::streamsize>(sizeof(T));
		return static_cast<bool>(output.write(reinterpret_cast<const char*>(&value), size));
	}

	LuaBytecodePack readLuaBytecodePack(const std::filesystem::path &packFile) {
		LuaBytecodePack pack;
		pack.loaded = true;

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
				break;
			}

			uint64_t chunkSize = 0;
			if (!readBinaryValue(input, chunkSize) || keySize == 0 || chunkSize > LuaBytecodePackMaxChunkSize) {
				break;
			}

			std::string key(keySize, '\0');
			if (!readBytes(input, key.data(), static_cast<std::streamsize>(key.size()))) {
				break;
			}

			std::string bytecode(static_cast<size_t>(chunkSize), '\0');
			if (!bytecode.empty() && !readBytes(input, bytecode.data(), static_cast<std::streamsize>(bytecode.size()))) {
				break;
			}

			static_cast<void>(pack.chunks.insert_or_assign(std::move(key), std::move(bytecode)));
		}

		return pack;
	}

	bool luaBytecodePackHasValidMagic(const std::filesystem::path &packFile) {
		std::ifstream input(packFile, std::ios::binary);
		if (!input.is_open()) {
			return false;
		}

		std::string magic(LuaBytecodePackMagic.size(), '\0');
		return readBytes(input, magic.data(), static_cast<std::streamsize>(magic.size())) && magic == std::string(LuaBytecodePackMagic);
	}

	std::mutex &getLuaBytecodePackMutex() {
		static std::mutex mutex;
		return mutex;
	}

	std::unordered_map<std::string, LuaBytecodePack> &getLuaBytecodePacks() {
		static std::unordered_map<std::string, LuaBytecodePack> packs;
		return packs;
	}

	std::optional<std::string> findLuaBytecodePackChunk(const LuaBytecodeCacheEntry &cacheEntry) {
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
			writeMagic = true;
		}

		std::ofstream output(cacheEntry.packFile, std::ios::binary | std::ios::app);
		if (!output.is_open()) {
			return;
		}

		if (writeMagic) {
			if (!output.write(LuaBytecodePackMagic.data(), static_cast<std::streamsize>(LuaBytecodePackMagic.size()))) {
				return;
			}
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

	std::optional<LuaBytecodeCacheEntry> getLuaBytecodeCacheEntry(const std::string &file, const LuaScriptFileMetadata* sourceMetadata) {
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
			"{}:{}:{}:{}:{}",
			LuaBytecodeCacheVersion,
			sizeof(void*),
			sourceIdentity,
			sourceMetadata->size,
			sourceMetadata->lastWriteTime.time_since_epoch().count()
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
				invalidateLuaBytecodePack(bytecodeCacheEntry->packFile);
				ret = -1;
			}
		}

		if (ret != 0) {
			const auto cacheLoadResult = loadLuaChunkFromFileBuffer(luaState, bytecodeCacheEntry->file, chunkName);
			if (cacheLoadResult) {
				ret = cacheLoadResult->status;
				if (ret == 0) {
					appendLuaBytecodePack(*bytecodeCacheEntry, cacheLoadResult->buffer);
				} else {
					lua_pop(luaState, 1);
					std::error_code error;
					std::filesystem::remove(bytecodeCacheEntry->file, error);
				}
			}
		}
	}

	const bool loadedFromBytecodeCache = ret == 0;
	if (!loadedFromBytecodeCache) {
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
