/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <optional>
	#include <string>
	#include <string_view>
#endif

namespace MapDownload {

	struct CanaryReleaseTagDiff {
		std::string configuredTag;
		std::string currentTag;
	};

	[[nodiscard]] std::optional<std::string> extractMapDownloadUrl(std::string_view luaConfig);
	[[nodiscard]] std::optional<std::string> extractCanaryReleaseTag(std::string_view mapDownloadUrl);
	[[nodiscard]] std::optional<CanaryReleaseTagDiff> compareCanaryReleaseTags(std::string_view configuredMapDownloadUrl, std::string_view currentMapDownloadUrl);

	void warnIfOutdatedMapDownloadUrl(const std::string &configuredMapDownloadUrl);

} // namespace MapDownload
