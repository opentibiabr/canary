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

#include "utils/thread_holder_base.h"

class Webhook : public ThreadHolder<Webhook> {
	private:
		Webhook();
		~Webhook();

		// Singleton - ensures we don't accidentally copy it
		Webhook(const Webhook &) = delete;
		void operator=(const Webhook &) = delete;

		struct Task {
				std::string title;
				std::string message;
				int color;
				std::string url;
		};

		std::mutex taskLock;
		std::condition_variable taskSignal;
		std::deque<Task> taskDeque;
		bool isInitialized = false;
		curl_slist* headers = nullptr;
		CURL* curl;

	public:
		static Webhook &getInstance() {
			// Guaranteed to be destroyed
			static Webhook instance;
			// Instantiated on first use
			return instance;
		}

		void init();
		void sendMessage(const std::string title, const std::string message, int color, std::string url = "");
		int sendRequest(const char* url, const char* payload, std::string* response_body);
		static size_t writeCallback(void* contents, size_t size, size_t nmemb, void* userp);
		std::string getPayload(const std::string title, const std::string message, int color);
		void threadMain();
		void shutdown();
};

constexpr auto g_webhook = &Webhook::getInstance;

#endif // SRC_SERVER_NETWORK_WEBHOOK_WEBHOOK_H_
