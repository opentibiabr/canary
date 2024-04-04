/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Signals {
	asio::signal_set set;

public:
	explicit Signals(asio::io_service &service);

private:
	void asyncWait();
	static void dispatchSignalHandler(int signal);

	static void sigbreakHandler();
	static void sigintHandler();
	static void sighupHandler();
	static void sigtermHandler();
	static void sigusr1Handler();
};
