/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/appearance/mounts/mounts.h"
#include "database/databasetasks.h"
#include "game/game.h"
#include "game/scheduling/scheduler.h"
#include "game/scheduling/dispatcher.hpp"
#include "lua/creature/events.h"
#include "lua/creature/raids.h"
#include "lua/scripts/lua_environment.hpp"
#include "server/signals.h"

Signals::Signals(asio::io_service &service) :
	set(service) {
	set.add(SIGINT);
	set.add(SIGTERM);
#ifndef _WIN32
	set.add(SIGUSR1);
	set.add(SIGHUP);
#else
	// This must be a blocking call as Windows calls it in a new thread and terminates
	// the process when the handler returns (or after 5 seconds, whichever is earlier).
	// On Windows it is called in a new thread.
	signal(SIGBREAK, dispatchSignalHandler);
#endif

	asyncWait();
}

void Signals::asyncWait() {
	set.async_wait([this](std::error_code err, int signal) {
		if (err) {
			g_logger().error("[Signals::asyncWait] - "
							 "Signal handling error: {}",
							 err.message());
			return;
		}
		dispatchSignalHandler(signal);
		asyncWait();
	});
}

// On Windows this function does not need to be signal-safe,
// as it is called in a new thread.
// https://github.com/otland/forgottenserver/pull/2473
void Signals::dispatchSignalHandler(int signal) {
	switch (signal) {
		case SIGINT: // Shuts the server down
			g_dispatcher().addTask(sigintHandler);
			break;
		case SIGTERM: // Shuts the server down
			g_dispatcher().addTask(sigtermHandler);
			break;
#ifndef _WIN32
		case SIGHUP: // Reload config/data
			g_dispatcher().addTask(sighupHandler);
			break;
		case SIGUSR1: // Saves game state
			g_dispatcher().addTask(sigusr1Handler);
			break;
#else
		case SIGBREAK: // Shuts the server down
			g_dispatcher().addTask(sigbreakHandler);
			// hold the thread until other threads end
			g_scheduler().join();
			g_databaseTasks().join();
			g_dispatcher().join();
			break;
#endif
		default:
			break;
	}
}

void Signals::sigbreakHandler() {
	// Dispatcher thread
	g_logger().info("SIGBREAK received, shutting game server down...");
	g_game().setGameState(GAME_STATE_SHUTDOWN);
}

void Signals::sigtermHandler() {
	// Dispatcher thread
	g_logger().info("SIGTERM received, shutting game server down...");
	g_game().setGameState(GAME_STATE_SHUTDOWN);
}

void Signals::sigusr1Handler() {
	// Dispatcher thread
	g_logger().info("SIGUSR1 received, saving the game state...");
	g_game().saveGameState();
}

void Signals::sighupHandler() {
	// Dispatcher thread
	g_logger().info("SIGHUP received, reloading config files...");

	g_configManager().reload();
	g_logger().info("Reloaded config");

	g_game().raids.reload();
	g_game().raids.startup();
	g_logger().info("Reloaded raids");

	Item::items.reload();
	g_logger().info("Reloaded items");

	g_game().mounts.reload();
	g_logger().info("Reloaded mounts");

	g_events().loadFromXml();
	g_logger().info("Reloaded events");

	g_chat().load();
	g_logger().info("Reloaded chatchannels");

	g_luaEnvironment().loadFile(g_configManager().getString(CORE_DIRECTORY) + "/core.lua", "core.lua");
	g_logger().info("Reloaded core.lua");

	lua_gc(g_luaEnvironment().getLuaState(), LUA_GCCOLLECT, 0);
}

void Signals::sigintHandler() {
	// Dispatcher thread
	g_logger().info("SIGINT received, shutting game server down...");
	g_game().setGameState(GAME_STATE_SHUTDOWN);
}
