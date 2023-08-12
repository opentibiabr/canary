/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "declarations.hpp"
#include "creatures/players/grouping/familiars.h"
#include "creatures/players/storages/storages.hpp"
#include "database/databasemanager.h"
#include "database/databasetasks.h"
#include "game/game.h"
#include "game/scheduling/dispatcher.hpp"
#include "game/scheduling/scheduler.h"
#include "game/scheduling/events_scheduler.hpp"
#include "io/iomarket.h"
#include "lua/creature/events.h"
#include "lua/modules/modules.h"
#include "lua/scripts/lua_environment.hpp"
#include "lua/scripts/scripts.h"
#include "security/rsa.h"
#include "server/network/protocol/protocollogin.h"
#include "server/network/protocol/protocolstatus.h"
#include "server/network/webhook/webhook.h"
#include "server/server.h"
#include "io/ioprey.h"
#include "io/io_bosstiary.hpp"

#include "core.hpp"

std::mutex g_loaderLock;
std::condition_variable g_loaderSignal;
std::unique_lock<std::mutex> g_loaderUniqueLock(g_loaderLock);
bool g_loaderDone = false;

/**
 *It is preferable to keep the close button off as it closes the server without saving (this can cause the player to lose items from houses and others informations, since windows automatically closes the process in five seconds, when forcing the close)
 * Choose to use "CTROL + C" or "CTROL + BREAK" for security close
 * To activate/desactivate window;
 * \param MF_GRAYED Disable the "x" (force close) button
 * \param MF_ENABLED Enable the "x" (force close) button
 */
void toggleForceCloseButton() {
#ifdef OS_WINDOWS
	HWND hwnd = GetConsoleWindow();
	HMENU hmenu = GetSystemMenu(hwnd, FALSE);
	EnableMenuItem(hmenu, SC_CLOSE, MF_GRAYED);
#endif
}

std::string getCompiler() {
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

void shutdown() {
	g_scheduler().shutdown();
	g_databaseTasks().shutdown();
	g_dispatcher().shutdown();
}

void startupErrorMessage() {
	g_logger().error("The program will close after pressing the enter key...");

	if (isatty(STDIN_FILENO)) {
		getchar();
	}

	g_loaderSignal.notify_all();

	shutdown();
	exit(-1);
}

void mainLoader(int argc, char* argv[], ServiceManager* servicer);

void badAllocationHandler() {
	// Use functions that only use stack allocation
	g_logger().error("Allocation failed, server out of memory, "
					 "decrease the size of your map or compile in 64 bits mode");
	if (isatty(STDIN_FILENO)) {
		getchar();
	}

	shutdown();
	exit(-1);
}

void modulesLoadHelper(bool loaded, std::string moduleName) {
	g_logger().info("Loading {}", moduleName);
	if (!loaded) {
		g_logger().error("Cannot load: {}", moduleName);
		startupErrorMessage();
	}
}

void loadModules() {
	modulesLoadHelper(g_configManager().load(), g_configManager().getConfigFileLua());

	g_logger().info("Server protocol: {}.{}{}", CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER, g_configManager().getBoolean(OLD_PROTOCOL) ? " and 10x allowed!" : "");
	// If "USE_ANY_DATAPACK_FOLDER" is set to true then you can choose any datapack folder for your server
	auto useAnyDatapack = g_configManager().getBoolean(USE_ANY_DATAPACK_FOLDER);
	auto datapackName = g_configManager().getString(DATA_DIRECTORY);
	if (!useAnyDatapack && (datapackName != "data-canary" && datapackName != "data-otservbr-global" || datapackName != "data-otservbr-global" && datapackName != "data-canary")) {
		g_logger().error("The datapack folder name '{}' is wrong, please select valid datapack name 'data-canary' or 'data-otservbr-global", datapackName);
		g_logger().error("Or enable in config.lua to use any datapack folder", datapackName);
		startupErrorMessage();
	}

	const char* p("14299623962416399520070177382898895550795403345466153217470516082934737582776038882967213386204600674145392845853859217990626450972452084065728686565928113");
	const char* q("7630979195970404721891201847792002125535401292779123937207447574596692788513647179235335529307251350570728407373705564708871762033017096809910315212884101");
	try {
		if (!g_RSA().loadPEM("key.pem")) {
			// file doesn't exist - switch to base10-hardcoded keys
			g_logger().error("File key.pem not found or have problem on loading... Setting standard rsa key\n");
			g_RSA().setKey(p, q);
		}
	} catch (const std::system_error &e) {
		g_logger().error("Loading RSA Key from key.pem failed with error: {}\n", e.what());
		g_logger().error("Switching to a default key...");
		g_RSA().setKey(p, q);
	}

	// Database
	g_logger().info("Establishing database connection... ");
	if (!Database::getInstance().connect()) {
		g_logger().error("Failed to connect to database!");
		startupErrorMessage();
	}
	g_logger().info("MySQL Version: {}", Database::getClientVersion());

	// Run database manager
	g_logger().info("Running database manager...");
	if (!DatabaseManager::isDatabaseSetup()) {
		g_logger().error("The database you have specified in {} is empty, "
						 "please import the schema.sql to your database.",
						 g_configManager().getConfigFileLua());
		startupErrorMessage();
	}

	g_databaseTasks().start();
	DatabaseManager::updateDatabase();

	if (g_configManager().getBoolean(OPTIMIZE_DATABASE)
		&& !DatabaseManager::optimizeTables()) {
		g_logger().info("No tables were optimized");
	}

	g_logger().info("Initializing lua environment...");
	if (!g_luaEnvironment().getLuaState()) {
		g_luaEnvironment().initState();
	}

	auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
	// Load items dependencies
	modulesLoadHelper((g_game().loadAppearanceProtobuf(coreFolder + "/items/appearances.dat") == ERROR_NONE), "appearances.dat");
	modulesLoadHelper(Item::items.loadFromXml(), "items.xml");

	auto datapackFolder = g_configManager().getString(DATA_DIRECTORY);
	g_logger().info("Loading core scripts on folder: {}/", coreFolder);
	// Load first core Lua libs
	modulesLoadHelper((g_luaEnvironment().loadFile(coreFolder + "/core.lua", "core.lua") == 0), "core.lua");
	modulesLoadHelper(g_scripts().loadScripts(coreFolder + "/scripts", false, false), "/data/scripts");

	// Second XML scripts
	modulesLoadHelper(g_vocations().loadFromXml(), "XML/vocations.xml");
	modulesLoadHelper(g_eventsScheduler().loadScheduleEventFromXml(), "XML/events.xml");
	modulesLoadHelper(Outfits::getInstance().loadFromXml(), "XML/outfits.xml");
	modulesLoadHelper(Familiars::getInstance().loadFromXml(), "XML/familiars.xml");
	modulesLoadHelper(g_imbuements().loadFromXml(), "XML/imbuements.xml");
	modulesLoadHelper(g_storages().loadFromXML(), "XML/storages.xml");
	modulesLoadHelper(g_modules().loadFromXml(), "modules/modules.xml");
	modulesLoadHelper(g_events().loadFromXml(), "events/events.xml");
	modulesLoadHelper((g_npcs().load(true, false)), "npclib");

	g_logger().info("Loading datapack scripts on folder: {}/", datapackName);
	modulesLoadHelper(g_scripts().loadScripts(datapackFolder + "/scripts/lib", true, false), datapackFolder + "/scripts/libs");
	// Load scripts
	modulesLoadHelper(g_scripts().loadScripts(datapackFolder + "/scripts", false, false), datapackFolder + "/scripts");
	// Load monsters
	modulesLoadHelper(g_scripts().loadScripts(datapackFolder + "/monster", false, false), datapackFolder + "/monster");
	modulesLoadHelper((g_npcs().load(false, true)), "npc");

	g_game().loadBoostedCreature();
	g_ioBosstiary().loadBoostedBoss();
	g_ioprey().InitializeTaskHuntOptions();
}

#ifndef UNIT_TESTING
int main(int argc, char* argv[]) {
	// Toggle force close button enabled/disabled
	toggleForceCloseButton();

	// Setup bad allocation handler
	std::set_new_handler(badAllocationHandler);

	ServiceManager serviceManager;

	g_dispatcher().start();
	g_scheduler().start();

	g_dispatcher().addTask(std::bind(mainLoader, argc, argv, &serviceManager));

	g_loaderSignal.wait(g_loaderUniqueLock, [] {
		return g_loaderDone;
	});

	if (!serviceManager.is_running()) {
		g_logger().error("No services running. The server is NOT online!");
		shutdown();
		exit(-1);
	}

	g_logger().info("{} {}", g_configManager().getString(SERVER_NAME), "server online!");

	serviceManager.run();

	shutdown();
	return 0;
}
#endif

void mainLoader(int, char*[], ServiceManager* services) {
	// dispatcher thread
	g_game().setGameState(GAME_STATE_STARTUP);

	srand(static_cast<unsigned int>(OTSYS_TIME()));
#ifdef _WIN32
	SetConsoleTitleA(STATUS_SERVER_NAME);
#endif
#if defined(GIT_RETRIEVED_STATE) && GIT_RETRIEVED_STATE
	g_logger().info("{} - Version [{}] dated [{}]", STATUS_SERVER_NAME, STATUS_SERVER_VERSION, GIT_COMMIT_DATE_ISO8601);
	#if GIT_IS_DIRTY
	g_logger().warn("DIRTY - NOT OFFICIAL RELEASE");
	#endif
#else
	g_logger().info("{} - Version {}", STATUS_SERVER_NAME, STATUS_SERVER_VERSION);
#endif

	std::string platform;
#if defined(__amd64__) || defined(_M_X64)
	platform = "x64";
#elif defined(__i386__) || defined(_M_IX86) || defined(_X86_)
	platform = "x86";
#elif defined(__arm__)
	platform = "ARM";
#else
	platform = "unknown";
#endif

	g_logger().info("Compiled with {}, on {} {}, for platform {}\n", getCompiler(), __DATE__, __TIME__, platform);

#if defined(LUAJIT_VERSION)
	g_logger().info("Linked with {} for Lua support", LUAJIT_VERSION);
#endif

	g_logger().info("A server developed by: {}", STATUS_SERVER_DEVELOPERS);
	g_logger().info("Visit our website for updates, support, and resources: "
					"https://docs.opentibiabr.com/");

	std::string configName = "config.lua";
	// Check if config or config.dist exist
	std::ifstream c_test("./" + configName);
	if (!c_test.is_open()) {
		std::ifstream config_lua_dist(configName + ".dist");
		if (config_lua_dist.is_open()) {
			g_logger().info("Copying {}.dist to {}", configName, configName);
			std::ofstream config_lua(configName);
			config_lua << config_lua_dist.rdbuf();
			config_lua.close();
			config_lua_dist.close();
		}
	} else {
		c_test.close();
	}

	g_configManager().setConfigFileLua(configName);

	// Init and load modules
	loadModules();

#ifdef _WIN32
	const std::string &defaultPriority = g_configManager().getString(DEFAULT_PRIORITY);
	if (strcasecmp(defaultPriority.c_str(), "high") == 0) {
		SetPriorityClass(GetCurrentProcess(), HIGH_PRIORITY_CLASS);
	} else if (strcasecmp(defaultPriority.c_str(), "above-normal") == 0) {
		SetPriorityClass(GetCurrentProcess(), ABOVE_NORMAL_PRIORITY_CLASS);
	}
#endif

	std::string worldType = asLowerCaseString(g_configManager().getString(WORLD_TYPE));
	if (worldType == "pvp") {
		g_game().setWorldType(WORLD_TYPE_PVP);
	} else if (worldType == "no-pvp") {
		g_game().setWorldType(WORLD_TYPE_NO_PVP);
	} else if (worldType == "pvp-enforced") {
		g_game().setWorldType(WORLD_TYPE_PVP_ENFORCED);
	} else {
		g_logger().error("Unknown world type: {}, valid world types are: pvp, no-pvp "
						 "and pvp-enforced",
						 g_configManager().getString(WORLD_TYPE));
		startupErrorMessage();
	}

	g_logger().info("World type set as {}", asUpperCaseString(worldType));

	g_logger().info("Loading main map...");
	if (!g_game().loadMainMap(g_configManager().getString(MAP_NAME))) {
		g_logger().error("Failed to load main map");
		startupErrorMessage();
	}

	// If "mapCustomEnabled" is true on config.lua, then load the custom map
	if (g_configManager().getBoolean(TOGGLE_MAP_CUSTOM)) {
		g_logger().info("Loading custom maps...");
		std::string customMapPath = g_configManager().getString(DATA_DIRECTORY) + "/world/custom/";
		if (!g_game().loadCustomMaps(customMapPath)) {
			g_logger().error("Failed to load custom maps");
			startupErrorMessage();
		}
	}

	g_logger().info("Initializing gamestate...");
	g_game().setGameState(GAME_STATE_INIT);

	// Game client protocols
	services->add<ProtocolGame>(static_cast<uint16_t>(g_configManager().getNumber(GAME_PORT)));
	services->add<ProtocolLogin>(static_cast<uint16_t>(g_configManager().getNumber(LOGIN_PORT)));
	// OT protocols
	services->add<ProtocolStatus>(static_cast<uint16_t>(g_configManager().getNumber(STATUS_PORT)));

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

	IOMarket::checkExpiredOffers();
	IOMarket::getInstance().updateStatistics();

	g_logger().info("Loaded all modules, server starting up...");

#ifndef _WIN32
	if (getuid() == 0 || geteuid() == 0) {
		g_logger().warn("{} has been executed as root user, "
						"please consider running it as a normal user",
						STATUS_SERVER_NAME);
	}
#endif

	g_game().start(services);
	g_game().setGameState(GAME_STATE_NORMAL);

	webhook_init();

	std::string url = g_configManager().getString(DISCORD_WEBHOOK_URL);
	webhook_send_message("Server is now online", "Server has successfully started.", WEBHOOK_COLOR_ONLINE, url);

	g_loaderDone = true;

	g_loaderSignal.notify_all();
}
