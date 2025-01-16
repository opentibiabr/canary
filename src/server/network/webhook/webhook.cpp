/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "server/network/webhook/webhook.hpp"
#include "config/configmanager.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "utils/tools.hpp"
#include "lib/di/container.hpp"

Webhook::Webhook(ThreadPool &threadPool) :
	threadPool(threadPool) {
	if (curl_global_init(CURL_GLOBAL_ALL) != 0) {
		g_logger().error("Failed to init curl, no webhook messages may be sent");
		return;
	}

	headers = curl_slist_append(headers, "content-type: application/json");
	headers = curl_slist_append(headers, "accept: application/json");

	if (headers == NULL) {
		g_logger().error("Failed to init curl, appending request headers failed");
		return;
	}

	run();
}

Webhook &Webhook::getInstance() {
	return inject<Webhook>();
}

void Webhook::run() {
	threadPool.detach_task([this] { sendWebhook(); });
	g_dispatcher().scheduleEvent(
		g_configManager().getNumber(DISCORD_WEBHOOK_DELAY_MS, __FUNCTION__), [this] { run(); }, "Webhook::run"
	);
}

void Webhook::sendPayload(const std::string &payload, std::string url) {
	std::scoped_lock lock { taskLock };
	webhooks.push_back(std::make_shared<WebhookTask>(payload, url));
}

void Webhook::sendMessage(const std::string &title, const std::string &message, int color, std::string url, bool embed) {
	if (url.empty()) {
		url = g_configManager().getString(DISCORD_WEBHOOK_URL, __FUNCTION__);
	}

	if (url.empty() || title.empty() || message.empty()) {
		return;
	}

	sendPayload(getPayload(title, message, color, embed), url);
}

void Webhook::sendMessage(const std::string &message, std::string url) {
	if (url.empty()) {
		url = g_configManager().getString(DISCORD_WEBHOOK_URL, __FUNCTION__);
	}

	if (url.empty() || message.empty()) {
		return;
	}

	sendPayload(getPayload("", message, -1, false), url);
}

int Webhook::sendRequest(const char* url, const char* payload, std::string* response_body) const {
	CURL* curl = curl_easy_init();
	if (!curl) {
		g_logger().error("Failed to send webhook message; curl_easy_init failed");
		return -1;
	}

	curl_easy_setopt(curl, CURLOPT_URL, url);
	curl_easy_setopt(curl, CURLOPT_SSLVERSION, CURL_SSLVERSION_TLSv1_2);
	curl_easy_setopt(curl, CURLOPT_POST, 1L);
	curl_easy_setopt(curl, CURLOPT_POSTFIELDS, payload);
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, &Webhook::writeCallback);
	curl_easy_setopt(curl, CURLOPT_WRITEDATA, reinterpret_cast<void*>(response_body));
	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
	curl_easy_setopt(curl, CURLOPT_USERAGENT, "canary (https://github.com/opentibiabr/canary)");

	CURLcode res = curl_easy_perform(curl);

	if (res != CURLE_OK) {
		g_logger().error("Failed to send webhook message with the error: {}", curl_easy_strerror(res));
		curl_easy_cleanup(curl);

		return -1;
	}

	int response_code;

	curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
	curl_easy_cleanup(curl);

	return response_code;
}

size_t Webhook::writeCallback(void* contents, size_t size, size_t nmemb, void* userp) {
	size_t real_size = size * nmemb;
	auto* str = reinterpret_cast<std::string*>(userp);
	str->append(reinterpret_cast<char*>(contents), real_size);
	return real_size;
}

std::string Webhook::getPayload(const std::string &title, const std::string &message, int color, bool embed) const {
	std::time_t now = getTimeNow();
	std::string time_buf = formatDate(now);

	std::stringstream footer_text;
	footer_text
		<< g_configManager().getString(SERVER_NAME, __FUNCTION__) << " | "
		<< time_buf;

	std::stringstream payload;
	if (embed) {
		payload << "{ \"embeds\": [{ ";
		payload << "\"title\": \"" << title << "\", ";
		if (!message.empty()) {
			payload << "\"description\": \"" << message << "\", ";
		}
		if (g_configManager().getBoolean(DISCORD_SEND_FOOTER, __FUNCTION__)) {
			payload << "\"footer\": { \"text\": \"" << footer_text.str() << "\" }, ";
		}
		if (color >= 0) {
			payload << "\"color\": " << color;
		}
		payload << " }] }";
	} else {
		payload << "{ \"content\": \"" << (!message.empty() ? message : title) << "\" }";
	}

	return payload.str();
}

void Webhook::sendWebhook() {
	std::scoped_lock lock { taskLock };
	if (webhooks.empty()) {
		return;
	}

	auto task = webhooks.front();

	std::string response_body;
	auto response_code = sendRequest(task->url.c_str(), task->payload.c_str(), &response_body);

	if (response_code == -1) {
		return;
	}

	if (response_code == 429 || response_code == 504) {
		g_logger().warn("Webhook encountered error code {}, re-queueing task.", response_code);

		return;
	}

	webhooks.pop_front();

	if (response_code >= 300) {
		g_logger().error(
			"Failed to send webhook message, error code: {} response body: {} request body: {}",
			response_code,
			response_body,
			task->payload
		);

		return;
	}

	g_logger().debug("Webhook successfully sent to {}", task->url);
}
