/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_SERVER_NETWORK_WEBHOOK_WEBHOOK_H_
#define SRC_SERVER_NETWORK_WEBHOOK_WEBHOOK_H_

class WebHook {
	public:
#if defined(WIN32)
		static void closeConnection(HINTERNET hSession = nullptr, HINTERNET hConnect = nullptr, HINTERNET hRequest = nullptr);
#endif
		static void sendMessage(std::string title, std::string message, int color);
		static std::string getPayload(std::string title, std::string message, int color);
};

#endif // SRC_SERVER_NETWORK_WEBHOOK_WEBHOOK_H_
