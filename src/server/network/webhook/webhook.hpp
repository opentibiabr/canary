/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lib/thread/thread_pool.hpp"

struct WebhookTask {
	std::string payload;
	std::string url;

	WebhookTask(std::string p, std::string u) :
		payload(std::move(p)), url(std::move(u)) { }
};

class Webhook {
public:
	static constexpr size_t DEFAULT_DELAY_MS = 1000;

	explicit Webhook(ThreadPool &threadPool);

	// Singleton - ensures we don't accidentally copy it
	Webhook(const Webhook &) = delete;
	void operator=(const Webhook &) = delete;

	static Webhook &getInstance();

	void run();

	void sendPayload(const std::string &payload, const std::string &url);
	void sendMessage(const std::string &title, const std::string &message, int color, std::string url = "", bool embed = true);
	void sendMessage(const std::string &message, std::string url = "");

private:
	std::mutex taskLock;
	ThreadPool &threadPool;
	std::deque<std::shared_ptr<WebhookTask>> webhooks;
	curl_slist* headers = nullptr;

	void sendWebhook();

	int sendRequest(const char* url, const char* payload, std::string* response_body) const;
	static size_t writeCallback(void* contents, size_t size, size_t nmemb, void* userp);
	std::string getPayload(const std::string &title, const std::string &message, int color, bool embed = true) const;
};

constexpr auto g_webhook = Webhook::getInstance;
