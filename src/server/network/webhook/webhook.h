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

#include "lib/thread/thread_pool.hpp"

class Webhook {
	public:
		Webhook(ThreadPool &threadPool);

		// Singleton - ensures we don't accidentally copy it
		Webhook(const Webhook &) = delete;
		void operator=(const Webhook &) = delete;

		static Webhook &getInstance();

		void requeueMessage(const std::string payload, std::string url);

		void sendMessage(const std::string payload, std::string url);
		void sendMessage(const std::string title, const std::string message, int color, std::string url = "");

	private:
		ThreadPool &threadPool;
		curl_slist* headers = nullptr;

		int sendRequest(const char* url, const char* payload, std::string* response_body);
		static size_t writeCallback(void* contents, size_t size, size_t nmemb, void* userp);
		std::string getPayload(const std::string title, const std::string message, int color);
};

constexpr auto g_webhook = Webhook::getInstance;

#endif // SRC_SERVER_NETWORK_WEBHOOK_WEBHOOK_H_
