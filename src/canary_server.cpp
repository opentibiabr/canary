/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "canary_server.hpp"

#include "core.hpp"
#include "config/configmanager.hpp"
#include "creatures/npcs/npcs.hpp"
#include "creatures/players/grouping/familiars.hpp"
#include "creatures/players/imbuements/imbuements.hpp"
#include "creatures/players/storages/storages.hpp"
#include "database/databasemanager.hpp"
#include "declarations.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/scheduling/events_scheduler.hpp"
#include "game/zones/zone.hpp"
#include "io/io_bosstiary.hpp"
#include "io/iomarket.hpp"
#include "io/ioprey.hpp"
#include "lib/thread/thread_pool.hpp"
#include "lua/docgen/lua_api_doc_generator.hpp"
#include "lua/creature/events.hpp"
#include "lua/modules/modules.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "lua/scripts/scripts.hpp"
#include "server/network/protocol/protocollogin.hpp"
#include "server/network/protocol/protocol_port_utils.hpp"
#include "server/network/protocol/protocol_profile.hpp"
#include "server/network/protocol/protocolstatus.hpp"
#include "server/network/webhook/webhook.hpp"
#include "creatures/players/components/weapon_proficiency.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "utils/benchmark.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <string_view>
#endif

namespace {
	[[nodiscard]] constexpr std::string_view getLuaRuntimeDisplayVersion() {
#if defined(LUAJIT_VERSION)
		constexpr std::string_view version = LUAJIT_VERSION;
		constexpr std::string_view prefix = "LuaJIT ";
		constexpr auto majorSeparator = version.find('.', prefix.size());
		if constexpr (majorSeparator != std::string_view::npos) {
			constexpr auto minorSeparator = version.find('.', majorSeparator + 1);
			if constexpr (minorSeparator != std::string_view::npos) {
				return version.substr(0, minorSeparator);
			}
		}
		return version;
#elif defined(LUA_VERSION)
		return LUA_VERSION;
#else
		return "Lua";
#endif
	}

	[[nodiscard]] std::string formatClientVersion(uint16_t version) {
		return fmt::format("{}.{:02d}", version / 100, version % 100);
	}

	[[nodiscard]] std::string getClientProtocolPortSummary(bool includeOldProtocolProfiles) {
		std::vector<std::string> entries;
		entries.emplace_back(fmt::format("{} -> {}", formatClientVersion(ProtocolProfileRegistry::getCurrentProfile().clientVersion), protocol_port_utils::getModernGamePort()));

		if (includeOldProtocolProfiles) {
			if (const auto* tibia1100 = ProtocolProfileRegistry::getProfile(ProtocolProfileId::Tibia1100);
			    tibia1100 && ProtocolProfileRegistry::isProfileAllowed(tibia1100->id)) {
				entries.emplace_back(fmt::format("11.00 -> {}", protocol_port_utils::getLegacy1100GamePort()));
			}

			if (const auto* cipsoft860 = ProtocolProfileRegistry::getProfile(ProtocolProfileId::Cipsoft860Vanilla);
			    cipsoft860 && ProtocolProfileRegistry::isProfileAllowed(cipsoft860->id)) {
				entries.emplace_back(fmt::format("8.60 -> {}", protocol_port_utils::getLegacy860GamePort()));
			}
		}

		return fmt::format("login {} | world {}", g_configManager().getNumber(LOGIN_PORT), fmt::join(entries, ", "));
	}

	void warnLegacy860WorldIpConfiguration(Logger &logger, bool allowOldProtocol) {
		if (!allowOldProtocol) {
			return;
		}

		const auto* cipsoft860 = ProtocolProfileRegistry::getProfile(ProtocolProfileId::Cipsoft860Vanilla);
		if (!cipsoft860 || !ProtocolProfileRegistry::isProfileAllowed(cipsoft860->id)) {
			return;
		}

		const auto configuredWorldIp = g_configManager().getString(IP);
		if (protocol_port_utils::legacyIpStringToNumber(configuredWorldIp) != 0) {
			return;
		}

		logger.warn(
			"Legacy 8.60 clients require a numeric IPv4 server IP, but configured ip is '{}'. "
			"8.60 clients will be rejected before the character list is sent.",
			configuredWorldIp
		);
	}
}

CanaryServer::CanaryServer(
	Logger &logger,
	RSAManager &rsa,
	ServiceManager &serviceManager
) :
	logger(logger),
	rsa(rsa),
	serviceManager(serviceManager) {
	logInfos();
	toggleForceCloseButton();
	g_game().setGameState(GAME_STATE_STARTUP);
	std::set_new_handler(badAllocationHandler);
	srand(static_cast<unsigned int>(OTSYS_TIME()));

	g_dispatcher().init();

#ifdef _WIN32
	SetConsoleTitleA(ProtocolStatus::SERVER_NAME.c_str());
#endif
}

bool CanaryServer::generateLuaApiDocs(const bool force) const {
	if (!force && !g_configManager().getBoolean(GENERATE_LUA_API_DOCS)) {
		logger.debug("Lua API documentation generation is disabled.");
		return true;
	}

	LuaApiDocGenerator apiDocGenerator(std::filesystem::current_path(), g_configManager().getString(LUA_API_DOCS_OUTPUT_DIRECTORY), logger);
	if (apiDocGenerator.generate()) {
		logger.info("Lua API documentation generated successfully.");
		return true;
	}
	return false;
}

int CanaryServer::generateLuaApiDocsOnly() {
	const auto shutdownDocgenRuntime = [] {
		g_dispatcher().shutdown();
		g_threadPool().shutdown();
	};

	try {
		loadConfigLua();
		const auto generated = generateLuaApiDocs(true);
		shutdownDocgenRuntime();
		return generated ? EXIT_SUCCESS : EXIT_FAILURE;
	} catch (const FailedToInitializeCanary &err) {
		logger.error(err.what());
		shutdownDocgenRuntime();
		return EXIT_FAILURE;
	} catch (const std::exception &err) {
		logger.error("Failed to generate Lua API documentation: {}", err.what());
		shutdownDocgenRuntime();
		return EXIT_FAILURE;
	}
}

int CanaryServer::run() {
	g_dispatcher().addEvent(
		[this] {
			try {
				loadConfigLua();
				if (!generateLuaApiDocs()) {
					logger.warn("Lua API documentation generation failed; continuing startup.");
				}
				validateDatapack();

				const auto allowOldProtocol = g_configManager().getBoolean(OLD_PROTOCOL);
				logger.info(
					"Allowed client protocols: {} ({})",
					ProtocolProfileRegistry::getAllowedClientProtocolDescription(allowOldProtocol),
					getClientProtocolPortSummary(allowOldProtocol)
				);
				warnLegacy860WorldIpConfiguration(logger, allowOldProtocol);

#ifdef FEATURE_METRICS
				metrics::Options metricsOptions;
				metricsOptions.enablePrometheusExporter = g_configManager().getBoolean(METRICS_ENABLE_PROMETHEUS);
				if (metricsOptions.enablePrometheusExporter) {
					metricsOptions.prometheusOptions.url = g_configManager().getString(METRICS_PROMETHEUS_ADDRESS);
				}
				metricsOptions.enableOStreamExporter = g_configManager().getBoolean(METRICS_ENABLE_OSTREAM);
				if (metricsOptions.enableOStreamExporter) {
					metricsOptions.ostreamOptions.export_interval_millis = std::chrono::milliseconds(g_configManager().getNumber(METRICS_OSTREAM_INTERVAL));
				}
				g_metrics().init(metricsOptions);
#endif
				rsa.start();
				initializeDatabase();
				loadModules();
				setWorldType();
				loadMaps();

				logger.info("Initializing gamestate...");
				g_game().setGameState(GAME_STATE_INIT);

				setupHousesRent();
				g_game().transferHouseItemsToDepot();

				IOMarket::checkExpiredOffers();
				IOMarket::getInstance().updateStatistics();

				logger.info("Loaded all modules, server starting up...");

#ifndef _WIN32
				if (getuid() == 0 || geteuid() == 0) {
					logger.warn("{} has been executed as root user, "
				                "please consider running it as a normal user",
				                ProtocolStatus::SERVER_NAME);
				}
#endif

				g_game().start(&serviceManager);
				if (g_configManager().getBoolean(TOGGLE_MAINTAIN_MODE)) {
					g_game().setGameState(GAME_STATE_CLOSED);
					g_logger().warn("Initialized in maintain mode!");
					g_webhook().sendMessage(":yellow_square: Server is now **online** _(access restricted to staff)_");
				} else {
					g_game().setGameState(GAME_STATE_NORMAL);
					g_webhook().sendMessage(":green_circle: Server is now **online**");
				}

				{
					std::scoped_lock lock(loaderMutex);
					loaderStatus = LoaderStatus::LOADED;
				}
				loaderCV.notify_all();
			} catch (FailedToInitializeCanary &err) {
				{
					std::scoped_lock lock(loaderMutex);
					loaderStatus = LoaderStatus::FAILED;
				}
				loaderCV.notify_all();
				logger.error(err.what());
			}
		},
		__FUNCTION__
	);

	constexpr auto timeout = std::chrono::minutes(10);
	constexpr auto warnEvery = std::chrono::seconds(120);
	const auto start = std::chrono::steady_clock::now();
	const auto deadline = start + timeout;
	auto nextWarning = start + warnEvery;

	std::unique_lock loaderLock(loaderMutex);
	while (loaderStatus == LoaderStatus::LOADING) {
		const auto wakeAt = std::min(deadline, nextWarning);
		loaderCV.wait_until(loaderLock, wakeAt, [this] {
			return loaderStatus != LoaderStatus::LOADING;
		});

		if (loaderStatus != LoaderStatus::LOADING) {
			break;
		}

		const auto now = std::chrono::steady_clock::now();
		if (now >= deadline) {
			loaderLock.unlock();
			logger.error("Startup exceeded {} minutes - aborting.", std::chrono::duration_cast<std::chrono::minutes>(timeout).count());
			shutdown();
			return EXIT_FAILURE;
		}

		if (now >= nextWarning) {
			logger.warn("Startup still running ({} s)...", std::chrono::duration_cast<std::chrono::seconds>(now - start).count());
			nextWarning = now + warnEvery;
		}
	}
	loaderLock.unlock();

	if (loaderStatus == LoaderStatus::FAILED || !serviceManager.is_running()) {
		logger.error("No services running. The server is NOT online!");
		logger.error("The program will close after pressing the enter key...");
		if (isatty(STDIN_FILENO)) {
			std::cin.get();
		}

		shutdown();
		return EXIT_FAILURE;
	}

	logger.info("{} {}", g_configManager().getString(SERVER_NAME), "server online!");
	g_logger().setLevel(g_configManager().getString(LOGLEVEL));
	g_dispatcher().setQueueLatencyLoggingEnabled(true);

	serviceManager.run();

	shutdown();
	return EXIT_SUCCESS;
}

void CanaryServer::setWorldType() {
	const std::string worldType = asLowerCaseString(g_configManager().getString(WORLD_TYPE));
	if (worldType == "pvp") {
		g_game().setWorldType(WORLD_TYPE_PVP);
	} else if (worldType == "no-pvp") {
		g_game().setWorldType(WORLD_TYPE_NO_PVP);
	} else if (worldType == "pvp-enforced") {
		g_game().setWorldType(WORLD_TYPE_PVP_ENFORCED);
	} else {
		throw FailedToInitializeCanary(
			fmt::format(
				"Unknown world type: {}, valid world types are: pvp, no-pvp and pvp-enforced",
				g_configManager().getString(WORLD_TYPE)
			)
		);
	}

	logger.info("World type set as {}", asUpperCaseString(worldType));
}

void CanaryServer::loadMaps() const {
	try {
		g_game().loadMainMap(g_configManager().getString(MAP_NAME));

		// If "mapCustomEnabled" is true on config.lua, then load the custom map
		if (g_configManager().getBoolean(TOGGLE_MAP_CUSTOM)) {
			g_game().loadCustomMaps(g_configManager().getString(DATA_DIRECTORY) + "/world/custom/");
		}
		Zone::refreshAll();
	} catch (const std::exception &err) {
		throw FailedToInitializeCanary(err.what());
	}
}

void CanaryServer::setupHousesRent() {
	RentPeriod_t rentPeriod;
	std::string strRentPeriod = asLowerCaseString(g_configManager().getString(HOUSE_RENT_PERIOD));

	if (strRentPeriod == "yearly") {
		rentPeriod = RENTPERIOD_YEARLY;
	} else if (strRentPeriod == "weekly") {
		rentPeriod = RENTPERIOD_WEEKLY;
	} else if (strRentPeriod == "monthly") {
		rentPeriod = RENTPERIOD_MONTHLY;
	} else if (strRentPeriod == "daily") {
		rentPeriod = RENTPERIOD_DAILY;
	} else {
		rentPeriod = RENTPERIOD_NEVER;
	}

	g_game().map.houses.payHouses(rentPeriod);
}

void CanaryServer::logInfos() {
#if defined(GIT_RETRIEVED_STATE) && GIT_RETRIEVED_STATE
	logger.info("{} - Version [{}] dated [{}]", ProtocolStatus::SERVER_NAME, SERVER_RELEASE_VERSION, GIT_COMMIT_DATE_ISO8601);
	#if GIT_IS_DIRTY
	logger.info("DIRTY - NOT OFFICIAL RELEASE");
	#endif
#else
	logger.info("{} - Version {}", ProtocolStatus::SERVER_NAME, SERVER_RELEASE_VERSION);
#endif

	logger.info("Compiled with {}, on {} {}, for platform {}", getCompiler(), __DATE__, __TIME__, getPlatform());

	logger.info("Linked with {} for Lua support", getLuaRuntimeDisplayVersion());

	logger.info("A server developed by: {}", ProtocolStatus::SERVER_DEVELOPERS);
	logger.info("Visit our website for updates, support, and resources: "
	            "https://docs.opentibiabr.com/");
}

/**
 *It is preferable to keep the close button off as it closes the server without saving (this can cause the player to lose items from houses and others informations, since windows automatically closes the process in five seconds, when forcing the close)
 * Choose to use "CTROL + C" or "CTROL + BREAK" for security close
 * To activate/deactivate window;
 * \param MF_GRAYED Disable the "x" (force close) button
 * \param MF_ENABLED Enable the "x" (force close) button
 */
void CanaryServer::toggleForceCloseButton() {
#ifdef OS_WINDOWS
	const HWND hwnd = GetConsoleWindow();
	const HMENU hmenu = GetSystemMenu(hwnd, FALSE);
	EnableMenuItem(hmenu, SC_CLOSE, MF_GRAYED);
#endif
}

void CanaryServer::badAllocationHandler() {
	// Use functions that only use stack allocation
	g_logger().error("Allocation failed, server out of memory, "
	                 "decrease the size of your map or compile in 64 bits mode");

	if (isatty(STDIN_FILENO)) {
		getchar();
	}

	shutdown();
	exit(-1);
}

std::string CanaryServer::getPlatform() {
#if defined(__amd64__) || defined(_M_X64)
	return "x64";
#elif defined(__i386__) || defined(_M_IX86) || defined(_X86_)
	return "x86";
#elif defined(__arm__)
	return "ARM";
#else
	return "unknown";
#endif
}

std::string CanaryServer::getCompiler() {
	std::string compiler;
#if defined(__clang__)
	return compiler = fmt::format("Clang++ {}.{}.{}", __clang_major__, __clang_minor__, __clang_patchlevel__);
#elif defined(_MSC_VER)
	return compiler = fmt::format("Microsoft Visual Studio {}", _MSC_VER);
#elif defined(__GNUC__)
	return compiler = fmt::format("G++ {}.{}.{}", __GNUC__, __GNUC_MINOR__, __GNUC_PATCHLEVEL__);
#else
	return compiler = "unknown";
#endif
}

void CanaryServer::loadConfigLua() {
	std::string configName = "config.lua";
	// Check if config or config.dist exist
	std::ifstream c_test("./" + configName);
	if (!c_test.is_open()) {
		std::ifstream config_lua_dist(configName + ".dist");
		if (config_lua_dist.is_open()) {
			logger.info("Copying {}.dist to {}", configName, configName);
			std::ofstream config_lua(configName);
			config_lua << config_lua_dist.rdbuf();
			config_lua.close();
			config_lua_dist.close();
		}
	} else {
		c_test.close();
	}

	g_configManager().setConfigFileLua(configName);

	modulesLoadHelper(g_configManager().load(), g_configManager().getConfigFileLua());

#ifdef _WIN32
	const std::string &defaultPriority = g_configManager().getString(DEFAULT_PRIORITY);
	if (strcasecmp(defaultPriority.c_str(), "high") == 0) {
		SetPriorityClass(GetCurrentProcess(), HIGH_PRIORITY_CLASS);
	} else if (strcasecmp(defaultPriority.c_str(), "above-normal") == 0) {
		SetPriorityClass(GetCurrentProcess(), ABOVE_NORMAL_PRIORITY_CLASS);
	}
#endif
}

void CanaryServer::validateDatapack() {
	// If "USE_ANY_DATAPACK_FOLDER" is set to true then you can choose any datapack folder for your server
	const auto useAnyDatapack = g_configManager().getBoolean(USE_ANY_DATAPACK_FOLDER);
	const auto datapackName = g_configManager().getString(DATA_DIRECTORY);

	if (!useAnyDatapack && datapackName != "data-canary" && datapackName != "data-otservbr-global") {
		throw FailedToInitializeCanary(fmt::format("The datapack folder name '{}' is wrong. Valid names: 'data-canary', "
		                                           "'data-otservbr-global', or set USE_ANY_DATAPACK_FOLDER = true in config.lua.",
		                                           datapackName));
	}
}

void CanaryServer::initializeDatabase() {
	logger.info("Establishing database connection... ");
	if (!Database::getInstance().connect()) {
		throw FailedToInitializeCanary("Failed to connect to database!");
	}
	logger.info("MySQL Version: {}", Database::getClientVersion());

	logger.info("Running database manager...");
	if (!DatabaseManager::isDatabaseSetup()) {
		throw FailedToInitializeCanary(fmt::format("The database you have specified in {} is empty, please import the schema.sql to your database.", g_configManager().getConfigFileLua()));
	}

	DatabaseManager::updateDatabase();

	if (g_configManager().getBoolean(OPTIMIZE_DATABASE)
	    && !DatabaseManager::optimizeTables()) {
		logger.info("No tables were optimized");
	}
	g_logger().info("Database connection established!");
}

void CanaryServer::loadModules() {
	Benchmark modulesBenchmark;
	logger.info("Initializing lua environment...");
	if (!g_luaEnvironment().getLuaState()) {
		g_luaEnvironment().initState();
	}

	logger.info("Loading modules and scripts...");
	const auto startupLoadTelemetry = g_configManager().getBoolean(LUA_STARTUP_LOAD_TELEMETRY);
	const auto timedLoad = [this, startupLoadTelemetry](std::string moduleName, const auto &loader) {
		if (!startupLoadTelemetry) {
			if (!loader()) {
				modulesLoadHelper(false, std::move(moduleName));
			}
			return;
		}

		Benchmark benchmark;
		const bool loaded = loader();
		const auto duration = benchmark.duration();
		if (!loaded) {
			modulesLoadHelper(false, moduleName);
		}

		logger.info("Loaded {} in {:.3f} ms", moduleName, duration);
	};

	auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
	timedLoad("proficiencies.json", [] {
		return WeaponProficiency::loadFromJson();
	});
	// Load appearances.dat first
	timedLoad("appearances.dat", [&coreFolder] {
		return g_game().loadAppearanceProtobuf(coreFolder + "/items/appearances.dat") == ERROR_NONE;
	});

	// Load XML folder dependencies (order matters)
	timedLoad("XML/vocations.xml", [] {
		return g_vocations().loadFromXml();
	});
	timedLoad("XML/outfits.xml", [] {
		return Outfits::getInstance().loadFromXml();
	});
	timedLoad("XML/familiars.xml", [] {
		return Familiars::getInstance().loadFromXml();
	});
	timedLoad("XML/imbuements.xml", [] {
		return g_imbuements().loadFromXml();
	});
	timedLoad("XML/storages.xml", [] {
		return g_storages().loadFromXML();
	});

	timedLoad("items.xml", [] {
		return Item::items.loadFromXml();
	});

	const auto datapackFolder = g_configManager().getString(DATA_DIRECTORY);
	logger.info("Loading core scripts on folder: {}/", coreFolder);
	// Load first core Lua libs
	timedLoad("core.lua", [&coreFolder] {
		return g_luaEnvironment().loadFile(coreFolder + "/core.lua", "core.lua") == 0;
	});
	timedLoad(coreFolder + "/scripts/libs", [&coreFolder] {
		return g_scripts().loadScripts(coreFolder + "/scripts/lib", true, false);
	});
	timedLoad(coreFolder + "/scripts", [&coreFolder] {
		return g_scripts().loadScripts(coreFolder + "/scripts", false, false);
	});
	timedLoad("npclib", [] {
		return g_npcs().load(true, false);
	});

	timedLoad("events/events.xml", [] {
		return g_events().loadFromXml();
	});
	timedLoad("modules/modules.xml", [] {
		return g_modules().loadFromXml();
	});

	logger.info("Loading datapack scripts on folder: {}/", datapackFolder);
	timedLoad(datapackFolder + "/scripts/libs", [&datapackFolder] {
		return g_scripts().loadScripts(datapackFolder + "/scripts/lib", true, false);
	});
	// Load scripts
	timedLoad(datapackFolder + "/scripts", [&datapackFolder] {
		return g_scripts().loadScripts(datapackFolder + "/scripts", false, false);
	});
	// Load monsters
	timedLoad(datapackFolder + "/monster", [&datapackFolder] {
		return g_scripts().loadScripts(datapackFolder + "/monster", false, false);
	});
	timedLoad("npc", [] {
		return g_npcs().load(false, true);
	});

	// It needs to be loaded after the revscript is read in order to use the scripting interface.
	timedLoad("json/eventscheduler/events.json", [] {
		return g_eventsScheduler().loadScheduleEventFromJson();
	});

	g_game().loadBoostedCreature();
	g_ioBosstiary().loadBoostedBoss();
	g_ioprey().initializeTaskHuntOptions();
	g_game().logCyclopediaStats();

	if (startupLoadTelemetry) {
		logger.info("Loaded modules and scripts in {:.3f} seconds.", modulesBenchmark.duration() / 1000.0);
	}
}

void CanaryServer::modulesLoadHelper(bool loaded, std::string_view identifier) {
	logger.info("Loading {}", identifier);
	if (!loaded) {
		throw FailedToInitializeCanary(fmt::format("Cannot load: {}", identifier));
	}
}

void CanaryServer::shutdown() {
	g_database().createDatabaseBackup(true);
	g_dispatcher().shutdown();
	g_metrics().shutdown();
	g_threadPool().shutdown();
}
