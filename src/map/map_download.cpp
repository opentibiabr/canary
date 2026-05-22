/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "map/map_download.hpp"

#include "core.hpp"
#include "lib/logging/log_with_spd_log.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <regex>
#endif

#include <curl/curl.h>

namespace {

	constexpr auto MAIN_CONFIG_DIST_URL = "https://raw.githubusercontent.com/opentibiabr/canary/main/config.lua.dist";
	constexpr auto CANARY_RELEASE_MAP_URL_PREFIX = "https://github.com/opentibiabr/canary/releases/download/";

	size_t writeResponseBody(char* contents, size_t size, size_t nmemb, void* userp) { // NOSONAR
		const size_t realSize = size * nmemb;
		auto* responseBody = static_cast<std::string*>(userp);
		static_cast<void>(responseBody->append(contents, realSize));
		return realSize;
	}

	std::optional<std::string> fetchTextUrl(const std::string_view url) {
		CURL* curl = curl_easy_init();
		if (!curl) {
			g_logger().debug("Failed to fetch {}, curl_easy_init failed", url);
			return std::nullopt;
		}

		const std::string requestUrl { url };
		std::string responseBody;
		curl_easy_setopt(curl, CURLOPT_URL, requestUrl.c_str());
		curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
		curl_easy_setopt(curl, CURLOPT_FAILONERROR, 1L);
		curl_easy_setopt(curl, CURLOPT_SSLVERSION, CURL_SSLVERSION_TLSv1_2);
		curl_easy_setopt(curl, CURLOPT_CONNECTTIMEOUT_MS, 3000L);
		curl_easy_setopt(curl, CURLOPT_TIMEOUT_MS, 5000L);
		curl_easy_setopt(curl, CURLOPT_NOSIGNAL, 1L);
		curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeResponseBody);
		curl_easy_setopt(curl, CURLOPT_WRITEDATA, &responseBody);
		curl_easy_setopt(curl, CURLOPT_USERAGENT, "canary (https://github.com/opentibiabr/canary)");

		const CURLcode result = curl_easy_perform(curl);
		if (result != CURLE_OK) {
			g_logger().debug("Failed to fetch {}, error: {}", url, curl_easy_strerror(result));
			curl_easy_cleanup(curl);
			return std::nullopt;
		}

		long responseCode = 0;
		curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &responseCode);
		curl_easy_cleanup(curl);

		if (responseCode != 200) {
			g_logger().debug("Failed to fetch {}, HTTP status code: {}", url, responseCode);
			return std::nullopt;
		}

		return responseBody;
	}

	std::string getReleaseConfigDistUrl() {
		return "https://raw.githubusercontent.com/opentibiabr/canary/v" + std::string(SERVER_RELEASE_VERSION) + "/config.lua.dist";
	}

	std::optional<std::string> fetchCurrentConfigDistMapDownloadUrl() {
		const std::array configDistUrls {
			getReleaseConfigDistUrl(),
			std::string(MAIN_CONFIG_DIST_URL),
		};

		for (const auto &configDistUrl : configDistUrls) {
			const auto currentConfigDist = fetchTextUrl(configDistUrl);
			if (!currentConfigDist) {
				continue;
			}

			const auto mapDownloadUrl = MapDownload::extractMapDownloadUrl(*currentConfigDist);
			if (mapDownloadUrl) {
				return mapDownloadUrl;
			}
		}

		return std::nullopt;
	}

} // namespace

namespace MapDownload {

	std::optional<std::string> extractMapDownloadUrl(const std::string_view luaConfig) {
		static const std::regex doubleQuotedMapDownloadUrl(R"lua(\bmapDownloadUrl\s*=\s*"([^"\r\n]*)")lua");
		static const std::regex singleQuotedMapDownloadUrl(R"(\bmapDownloadUrl\s*=\s*'([^'\r\n]*)')");

		std::match_results<std::string_view::const_iterator> match;
		if (std::regex_search(luaConfig.begin(), luaConfig.end(), match, doubleQuotedMapDownloadUrl) && match.size() > 1) {
			return match[1].str();
		}

		if (std::regex_search(luaConfig.begin(), luaConfig.end(), match, singleQuotedMapDownloadUrl) && match.size() > 1) {
			return match[1].str();
		}

		return std::nullopt;
	}

	std::optional<std::string> extractCanaryReleaseTag(const std::string_view mapDownloadUrl) {
		const auto tagStart = mapDownloadUrl.find(CANARY_RELEASE_MAP_URL_PREFIX);
		if (tagStart == std::string_view::npos) {
			return std::nullopt;
		}

		const auto tagValueStart = tagStart + std::string_view(CANARY_RELEASE_MAP_URL_PREFIX).size();
		const auto tagValueEnd = mapDownloadUrl.find('/', tagValueStart);
		if (tagValueEnd == std::string_view::npos || tagValueEnd == tagValueStart) {
			return std::nullopt;
		}

		return std::string(mapDownloadUrl.substr(tagValueStart, tagValueEnd - tagValueStart));
	}

	std::optional<CanaryReleaseTagDiff> compareCanaryReleaseTags(const std::string_view configuredMapDownloadUrl, const std::string_view currentMapDownloadUrl) {
		const auto configuredTag = extractCanaryReleaseTag(configuredMapDownloadUrl);
		const auto currentTag = extractCanaryReleaseTag(currentMapDownloadUrl);
		if (!configuredTag || !currentTag || configuredTag == currentTag) {
			return std::nullopt;
		}

		return CanaryReleaseTagDiff {
			.configuredTag = *configuredTag,
			.currentTag = *currentTag,
		};
	}

	void warnIfOutdatedMapDownloadUrl(const std::string &configuredMapDownloadUrl) {
		if (!extractCanaryReleaseTag(configuredMapDownloadUrl)) {
			return;
		}

		const auto currentMapDownloadUrl = fetchCurrentConfigDistMapDownloadUrl();
		if (!currentMapDownloadUrl) {
			return;
		}

		const auto releaseTagDiff = compareCanaryReleaseTags(configuredMapDownloadUrl, *currentMapDownloadUrl);
		if (!releaseTagDiff) {
			return;
		}

		g_logger().warn(
			"mapDownloadUrl points to Canary release {}, but the current config.lua.dist points to {}. "
			"Update mapDownloadUrl to '{}' before downloading the main map, otherwise a map from a different release may be used.",
			releaseTagDiff->configuredTag,
			releaseTagDiff->currentTag,
			*currentMapDownloadUrl
		);
	}

} // namespace MapDownload
