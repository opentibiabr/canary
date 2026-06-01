/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "map/map_download.hpp"

TEST(MapDownloadTest, ExtractsDoubleQuotedMapDownloadUrl) {
	const auto mapDownloadUrl = MapDownload::extractMapDownloadUrl(R"(
		toggleDownloadMap = true
		mapDownloadUrl = "https://github.com/opentibiabr/canary/releases/download/v3.5.0/otservbr.otbm"
	)");

	ASSERT_TRUE(mapDownloadUrl);
	EXPECT_EQ("https://github.com/opentibiabr/canary/releases/download/v3.5.0/otservbr.otbm", *mapDownloadUrl);
}

TEST(MapDownloadTest, ExtractsSingleQuotedMapDownloadUrl) {
	const auto mapDownloadUrl = MapDownload::extractMapDownloadUrl(R"(
		mapDownloadUrl = 'https://github.com/opentibiabr/canary/releases/download/v3.4.0/otservbr.otbm'
	)");

	ASSERT_TRUE(mapDownloadUrl);
	EXPECT_EQ("https://github.com/opentibiabr/canary/releases/download/v3.4.0/otservbr.otbm", *mapDownloadUrl);
}

TEST(MapDownloadTest, ExtractsCanaryReleaseTag) {
	const auto releaseTag = MapDownload::extractCanaryReleaseTag("https://github.com/opentibiabr/canary/releases/download/v3.5.0/otservbr.otbm");

	ASSERT_TRUE(releaseTag);
	EXPECT_EQ("v3.5.0", *releaseTag);
}

TEST(MapDownloadTest, IgnoresCustomDownloadUrlWhenExtractingCanaryReleaseTag) {
	EXPECT_FALSE(MapDownload::extractCanaryReleaseTag("https://example.org/maps/otservbr.otbm"));
}

TEST(MapDownloadTest, DetectsDifferentCanaryReleaseTags) {
	const auto releaseTagDiff = MapDownload::compareCanaryReleaseTags(
		"https://github.com/opentibiabr/canary/releases/download/v3.4.0/otservbr.otbm",
		"https://github.com/opentibiabr/canary/releases/download/v3.5.0/otservbr.otbm"
	);

	ASSERT_TRUE(releaseTagDiff);
	EXPECT_EQ("v3.4.0", releaseTagDiff->configuredTag);
	EXPECT_EQ("v3.5.0", releaseTagDiff->currentTag);
}

TEST(MapDownloadTest, IgnoresMatchingCanaryReleaseTags) {
	EXPECT_FALSE(MapDownload::compareCanaryReleaseTags("https://github.com/opentibiabr/canary/releases/download/v3.5.0/otservbr.otbm", "https://github.com/opentibiabr/canary/releases/download/v3.5.0/otservbr.otbm"));
}
