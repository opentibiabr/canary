/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "server/network/webhook/webhook.h"
#include "config/configmanager.h"

Webhook::Webhook() = default;
Webhook::~Webhook() = default;

void Webhook::init() {
	if (curl_global_init(CURL_GLOBAL_ALL) != 0) {
		SPDLOG_ERROR("Failed to init curl, no webhook messages may be sent");
		return;
	}

	headers = curl_slist_append(headers, "content-type: application/json");
	headers = curl_slist_append(headers, "accept: application/json");
	if (headers == NULL) {
		SPDLOG_ERROR("Failed to init curl, appending request headers failed");
		return;
	}

	isInitialized = true;
}

void Webhook::sendMessage(const std::string title, const std::string message, int color, std::string url) {
	if (url.empty()) {
		url = g_configManager().getString(DISCORD_WEBHOOK_URL);
	}
	if (url.empty() || title.empty() || message.empty() || !isInitialized) {
		return;
	}

	Task task { title, message, color, url };
	{
		std::lock_guard<std::mutex> lock(taskLock);
		taskQueue.push(std::move(task));
	}
	taskSignal.notify_one();
}

int Webhook::sendRequest(const char* url, const char* payload, std::string* response_body) {
	CURL* curl = curl_easy_init();
	if (!curl) {
		SPDLOG_ERROR("Failed to send webhook message; curl_easy_init failed");
		return -1;
	}

	curl_easy_setopt(curl, CURLOPT_URL, url);
	curl_easy_setopt(curl, CURLOPT_SSLVERSION, CURL_SSLVERSION_TLSv1_2);
	curl_easy_setopt(curl, CURLOPT_POST, 1L);
	curl_easy_setopt(curl, CURLOPT_POSTFIELDS, payload);
	curl_easy_setopt(curl, CURLOPT_WRITEDATA, reinterpret_cast<void*>(response_body));
	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
	curl_easy_setopt(curl, CURLOPT_USERAGENT, "canary (https://github.com/Hydractify/canary)");

	CURLcode res = curl_easy_perform(curl);

	int response_code = -1;
	if (res == CURLE_OK) {
		curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
	} else {
		SPDLOG_ERROR("Failed to send webhook message with the error: {}", curl_easy_strerror(res));
	}

	curl_easy_cleanup(curl);

	return response_code;
}

std::string Webhook::getPayload(const std::string title, const std::string message, int color) {
	time_t now;
	time(&now);
	struct tm tm;

#ifdef _MSC_VER
	gmtime_s(&tm, &now);
#else
	gmtime_r(&now, &tm);
#endif

	char time_buf[sizeof "00:00"];
	strftime(time_buf, sizeof time_buf, "%R", &tm);

	std::stringstream footer_text;
	footer_text
		<< g_configManager().getString(IP) << ":"
		<< g_configManager().getNumber(GAME_PORT) << " | "
		<< time_buf << " UTC";

	std::stringstream payload;
	payload << "{ \"embeds\": [{ ";
	payload << "\"title\": \"" << title << "\", ";
	payload << "\"description\": \"" << message << "\", ";
	payload << "\"footer\": { \"text\": \"" << footer_text.str() << "\" }, ";
	if (color >= 0) {
		payload << "\"color\": " << color;
	}
	payload << " }] }";

	return payload.str();
}

void Webhook::threadMain() {
	while (getState() != THREAD_STATE_TERMINATED) {
		std::unique_lock<std::mutex> taskLockUnique(taskLock);
		taskSignal.wait(taskLockUnique, [this] { return !taskQueue.empty() || getState() == THREAD_STATE_TERMINATED; });

		if (getState() == THREAD_STATE_TERMINATED)
			break;

		Task task;
		{
			task = std::move(taskQueue.front());
			taskQueue.pop();
		}
		taskLockUnique.unlock();

		std::string payload = getPayload(task.title, task.message, task.color);
		std::string response_body = "";
		auto response_code = sendRequest(task.url.c_str(), payload.c_str(), &response_body);
		if (response_code != 204 && response_code != -1) {
			SPDLOG_ERROR("Failed to send webhook message; "
						 "HTTP request failed with code: {}"
						 "response body: {} request body: {}",
						 response_code, response_body, payload);
		}

		// Adds half a second of time to execute the next webhook, ensuring that the server doesn't have any overhead, because discord only receives a webhook more or less in this time
		std::this_thread::sleep_for(std::chrono::milliseconds(500));
	}
}

void Webhook::shutdown() {
	std::lock_guard<std::mutex> taskLockGuard(taskLock);
	setState(THREAD_STATE_TERMINATED);
	taskSignal.notify_all();
}
