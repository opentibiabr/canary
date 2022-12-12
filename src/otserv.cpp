/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "pch.hpp"

#ifdef OS_WINDOWS
	#include "conio.h"
#endif

#include "declarations.hpp"
#include "creatures/combat/spells.h"
#include "creatures/players/grouping/familiars.h"
#include "database/databasemanager.h"
#include "database/databasetasks.h"
#include "game/game.h"
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

#if __has_include("gitmetadata.h")
	#include "gitmetadata.h"
#endif

#include "core.hpp"

std::mutex g_loaderLock;
std::condition_variable g_loaderSignal;
std::unique_lock<std::mutex> g_loaderUniqueLock(g_loaderLock);

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

void startupErrorMessage() {
	SPDLOG_ERROR("The program will close after pressing the enter key...");
	getchar();
	g_loaderSignal.notify_all();
}

void mainLoader(int argc, char* argv[], ServiceManager* servicer);

void badAllocationHandler() {
	// Use functions that only use stack allocation
	SPDLOG_ERROR("Allocation failed, server out of memory, "
                 "decrease the size of your map or compile in 64 bits mode");
	getchar();
	exit(-1);
}

void modulesLoadHelper(bool loaded, std::string moduleName) {
	SPDLOG_INFO("Loading {}", moduleName);
	if (!loaded) {
		SPDLOG_ERROR("Cannot load: {}", moduleName);
		startupErrorMessage();
	}
}

void loadModules() {
	modulesLoadHelper(g_configManager().load(), g_configManager().getConfigFileLua());

	// If "USE_ANY_DATAPACK_FOLDER" is set to true then you can choose any datapack folder for your server
	auto useAnyDatapack = g_configManager().getBoolean(USE_ANY_DATAPACK_FOLDER);
	auto datapackName = g_configManager().getString(DATA_DIRECTORY);
	if (!useAnyDatapack && (datapackName != "data-canary" && datapackName != "data-otservbr-global" || datapackName != "data-otservbr-global" && datapackName != "data-canary")) {
		SPDLOG_ERROR("The datapack folder name '{}' is wrong, please select valid datapack name 'data-canary' or 'data-otservbr-global", datapackName);
		SPDLOG_ERROR("Or enable in config.lua to use any datapack folder", datapackName);
		startupErrorMessage();
	}

	SPDLOG_INFO("Server protocol: {}.{}",
		CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER);

	const char* p("14299623962416399520070177382898895550795403345466153217470516082934737582776038882967213386204600674145392845853859217990626450972452084065728686565928113");
	const char* q("7630979195970404721891201847792002125535401292779123937207447574596692788513647179235335529307251350570728407373705564708871762033017096809910315212884101");
	try {
		if (!g_RSA().loadPEM("key.pem")) {
			// file doesn't exist - switch to base10-hardcoded keys
			SPDLOG_ERROR("File key.pem not found or have problem on loading... Setting standard rsa key\n");
			g_RSA().setKey(p, q);
		}
	} catch (std::system_error const& e) {
		SPDLOG_ERROR("Loading RSA Key from key.pem failed with error: {}\n", e.what());
		SPDLOG_ERROR("Switching to a default key...");
		g_RSA().setKey(p, q);
	}

	// Database
	SPDLOG_INFO("Establishing database connection... ");
	if (!Database::getInstance().connect()) {
		SPDLOG_ERROR("Failed to connect to database!");
		startupErrorMessage();
	}
	SPDLOG_INFO("MySQL Version: {}", Database::getClientVersion());

	// Run database manager
	SPDLOG_INFO("Running database manager...");
	if (!DatabaseManager::isDatabaseSetup()) {
		SPDLOG_ERROR("The database you have specified in {} is empty, "
			"please import the schema.sql to your database.", g_configManager().getConfigFileLua());
		startupErrorMessage();
	}

	g_databaseTasks().start();
	DatabaseManager::updateDatabase();

	if (g_configManager().getBoolean(OPTIMIZE_DATABASE)
			&& !DatabaseManager::optimizeTables()) {
		SPDLOG_INFO("No tables were optimized");
	}

	// Core start
	auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
	modulesLoadHelper((g_game().loadAppearanceProtobuf(coreFolder + "/items/appearances.dat") == ERROR_NONE),
		"appearances.dat");
	modulesLoadHelper(Item::items.loadFromXml(),
		"items.xml");

	auto datapackFolder = g_configManager().getString(DATA_DIRECTORY);
	SPDLOG_INFO("Loading core scripts on folder: {}/", coreFolder);
	modulesLoadHelper((g_luaEnvironment.loadFile(coreFolder + "/core.lua") == 0),
		"core.lua");
	modulesLoadHelper((g_luaEnvironment.loadFile(coreFolder + "/scripts/talkactions.lua") == 0),
		"scripts/talkactions.lua");
	modulesLoadHelper(g_vocations().loadFromXml(),
		"XML/vocations.xml");
	modulesLoadHelper(g_eventsScheduler().loadScheduleEventFromXml(),
		"XML/events.xml");
	modulesLoadHelper(Outfits::getInstance().loadFromXml(),
		"XML/outfits.xml");
	modulesLoadHelper(Familiars::getInstance().loadFromXml(),
		"XML/familiars.xml");
	modulesLoadHelper(g_imbuements().loadFromXml(),
		"XML/imbuements.xml");
	modulesLoadHelper(g_modules().loadFromXml(),
		"modules/modules.xml");
	modulesLoadHelper(g_events().loadFromXml(),
		"events/events.xml");
	modulesLoadHelper((g_npc().load(true, false)),
		"npclib");

	SPDLOG_INFO("Loading datapack scripts on folder: {}/", datapackName);
	// Load libs first
	modulesLoadHelper(g_scripts().loadScripts("scripts/lib", true, false),
		"scripts/libs");
	// Load scripts
	modulesLoadHelper(g_scripts().loadScripts("scripts", false, false),
		"scripts");
	// Load monsters
	modulesLoadHelper(g_scripts().loadScripts("monster", false, false),
		"monster");
	modulesLoadHelper((g_npc().load(false, true)),
		"npc");

	g_game().loadBoostedCreature();
	g_ioprey().InitializeTaskHuntOptions();
}

#ifndef UNIT_TESTING
int main(int argc, char* argv[]) {
#ifdef DEBUG_LOG
	SPDLOG_DEBUG("[CANARY] SPDLOG LOG DEBUG ENABLED");
	spdlog::set_pattern("[%Y-%d-%m %H:%M:%S.%e] [file %@] [func %!] [thread %t] [%^%l%$] %v ");
#else
	spdlog::set_pattern("[%Y-%d-%m %H:%M:%S.%e] [%^%l%$] %v ");
#endif
	// Toggle force close button enabled/disabled
	toggleForceCloseButton();

	// Setup bad allocation handler
	std::set_new_handler(badAllocationHandler);

	ServiceManager serviceManager;

	g_dispatcher().start();
	g_scheduler().start();

	g_dispatcher().addTask(createTask(std::bind(mainLoader, argc, argv,
												&serviceManager)));

	g_loaderSignal.wait(g_loaderUniqueLock);

	if (serviceManager.is_running()) {
		SPDLOG_INFO("{} {}", g_configManager().getString(SERVER_NAME),
                    "server online!");
		serviceManager.run();
	} else {
		SPDLOG_ERROR("No services running. The server is NOT online!");
		g_databaseTasks().shutdown();
		g_dispatcher().shutdown();
		exit(-1);
	}

	g_scheduler().join();
	g_databaseTasks().join();
	g_dispatcher().join();
	return 0;
}
#endif

void mainLoader(int, char*[], ServiceManager* services) {
	// dispatcher thread
	g_game().setGameState(GAME_STATE_STARTUP);

	srand(static_cast<unsigned int>(OTSYS_TIME()));
#ifdef _WIN32
	SetConsoleTitle(STATUS_SERVER_NAME);
#endif
#if defined(GIT_RETRIEVED_STATE) && GIT_RETRIEVED_STATE
	SPDLOG_INFO("{} - Version [{}] dated [{}]",
                STATUS_SERVER_NAME, STATUS_SERVER_VERSION, GIT_COMMIT_DATE_ISO8601);
	#if GIT_IS_DIRTY
	SPDLOG_WARN("DIRTY - NOT OFFICIAL RELEASE");
	#endif
#else
	SPDLOG_INFO("{} - Version {}", STATUS_SERVER_NAME, STATUS_SERVER_VERSION);
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

	SPDLOG_INFO("Compiled with {}, on {} {}, for platform {}\n", BOOST_COMPILER, __DATE__, __TIME__, platform);

#if defined(LUAJIT_VERSION)
	SPDLOG_INFO("Linked with {} for Lua support", LUAJIT_VERSION);
#endif

	SPDLOG_INFO("A server developed by: {}", STATUS_SERVER_DEVELOPERS);
	SPDLOG_INFO("Visit our website for updates, support, and resources: "
		"https://docs.opentibiabr.org/");

	std::string configName = "config.lua";
	// Check if config or config.dist exist
	std::ifstream c_test("./" + configName);
	if (!c_test.is_open()) {
		std::ifstream config_lua_dist(configName + ".dist");
		if (config_lua_dist.is_open()) {
			SPDLOG_INFO("Copying {}.dist to {}", configName, configName);
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
	const std::string& defaultPriority = g_configManager().getString(DEFAULT_PRIORITY);
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
		SPDLOG_ERROR("Unknown world type: {}, valid world types are: pvp, no-pvp "
			"and pvp-enforced", g_configManager().getString(WORLD_TYPE));
		startupErrorMessage();
	}

	SPDLOG_INFO("World type set as {}", asUpperCaseString(worldType));

	SPDLOG_INFO("Loading map...");
	if (!g_game().loadMainMap(g_configManager().getString(MAP_NAME))) {
		SPDLOG_ERROR("Failed to load map");
		startupErrorMessage();
	}

	// If "mapCustomEnabled" is true on config.lua, then load the custom map
	if (g_configManager().getBoolean(TOGGLE_MAP_CUSTOM)) {
		SPDLOG_INFO("Loading custom map...");
		if (!g_game().loadCustomMap(g_configManager().getString(MAP_CUSTOM_NAME))) {
			SPDLOG_ERROR("Failed to load custom map");
			startupErrorMessage();
		}
	}

	SPDLOG_INFO("Initializing gamestate...");
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

	SPDLOG_INFO("Loaded all modules, server starting up...");

#ifndef _WIN32
	if (getuid() == 0 || geteuid() == 0) {
		SPDLOG_WARN("{} has been executed as root user, "
                    "please consider running it as a normal user",
                    STATUS_SERVER_NAME);
	}
#endif

	g_game().start(services);
	g_game().setGameState(GAME_STATE_NORMAL);

	webhook_init();

	std::string url = g_configManager().getString(DISCORD_WEBHOOK_URL);
	webhook_send_message("Server is now online", "Server has successfully started.", WEBHOOK_COLOR_ONLINE, url);

	g_loaderSignal.notify_all();
}
