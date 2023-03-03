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
#include "core.hpp"

#if defined(WIN32)
void WebHook::closeConnection(HINTERNET hSession /* = nullptr*/, HINTERNET hConnect /* = nullptr*/, HINTERNET hRequest /* = nullptr*/) {
	InternetCloseHandle(hSession);
	InternetCloseHandle(hConnect);
	InternetCloseHandle(hRequest);
}
#endif

void WebHook::sendMessage(std::string title, std::string message, int color) {
	std::string webhookUrl = g_configManager().getString(DISCORD_WEBHOOK_URL);
	std::string payload = getPayload(title, message, color);
	// Break empty informations
	if (title.empty() || message.empty() || webhookUrl.empty() || payload.empty()) {
		return;
	}

#if defined(WIN32)
	HINTERNET hSession = InternetOpenA((LPCSTR)STATUS_SERVER_NAME, INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, 0);
	if (!hSession) {
		SPDLOG_ERROR("Failed to create WinHTTP session");
		return;
	}

	HINTERNET hConnect = InternetConnectA(hSession, "discordapp.com", INTERNET_DEFAULT_HTTPS_PORT, 0, 0, INTERNET_SERVICE_HTTP, 0, 0);
	if (!hConnect) {
		closeConnection(hSession);
		SPDLOG_ERROR("[WebHook] Failed to connect to Discord");
		return;
	}

	HINTERNET hRequest = HttpOpenRequestA(hConnect, "POST", webhookUrl.c_str(), 0, 0, 0, INTERNET_FLAG_SECURE, 0);
	if (!hRequest) {
		closeConnection(hSession, hConnect);
		SPDLOG_ERROR("[WebHook] Failed to create HTTP request");
		return;
	}

	std::string contentTypeHeader = "Content-Type: application/json";
	if (!HttpAddRequestHeadersA(hRequest, contentTypeHeader.c_str(), contentTypeHeader.length(), HTTP_ADDREQ_FLAG_REPLACE)) {
		closeConnection(hSession, hConnect, hRequest);
		SPDLOG_ERROR("[WebHook] Failed to set request headers");
		return;
	}

	// Try to send message
	DWORD dataSize = static_cast<DWORD>(payload.length());
	if (!HttpSendRequestA(hRequest, 0, 0, (LPVOID)payload.c_str(), dataSize)) {
		closeConnection(hSession, hConnect, hRequest);
		SPDLOG_ERROR("[WebHook] Failed to send HTTP request");
		return;
	}

	DWORD statusCode = 0;
	DWORD statusCodeSize = sizeof(statusCode);
	HttpQueryInfoA(hRequest, HTTP_QUERY_STATUS_CODE | HTTP_QUERY_FLAG_NUMBER, &statusCode, &statusCodeSize, 0);

	if (statusCode < 200 || statusCode >= 300) {
		closeConnection(hSession, hConnect, hRequest);
		SPDLOG_ERROR("[WebHook] Received unsuccessful HTTP status code {}", statusCode);
		return;
	}

	closeConnection(hSession, hConnect, hRequest);
#else
	dpp::cluster bot("");
 
	bot.on_log(dpp::utility::cout_logger());
 
	// Construct a webhook object using the URL you got from Discord 
	dpp::webhook wh("https://discord.com/" + webhookUrl);
 
	// Send a message with this webhook
	bot.execute_webhook_sync(wh, dpp::message(payload));
#endif
}

std::string WebHook::getPayload(std::string title, std::string message, int color) {
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

	Json::Value footer(Json::objectValue);
	footer["text"] = Json::Value(footer_text.str());

	Json::Value embed(Json::objectValue);
	embed["title"] = Json::Value(title);
	embed["description"] = Json::Value(message);
	embed["footer"] = footer;
	if (color >= 0) {
		embed["color"] = color;
	}

	Json::Value embeds(Json::arrayValue);
	embeds.append(embed);

	Json::Value payload(Json::objectValue);
	payload["embeds"] = embeds;

	Json::StreamWriterBuilder builder;
	builder["commentSyle"] = "None";
	builder["indentation"] = "";

	std::unique_ptr<Json::StreamWriter> writer(builder.newStreamWriter());
	std::stringstream out;
	writer->write(payload, &out);
	return out.str();
}
