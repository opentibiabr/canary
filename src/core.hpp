/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

static constexpr auto STATUS_SERVER_NAME = "Canary";
// STATUS_SERVER_VERSION is used for external display purposes, such as listings on otlist.
// This version should generally only show the major version to avoid frequent changes in otlist categories.
static constexpr auto STATUS_SERVER_VERSION = "3.0";

static constexpr auto STATUS_SERVER_DEVELOPERS = "OpenTibiaBR Organization";

static constexpr auto AUTHENTICATOR_DIGITS = 6U;
static constexpr auto AUTHENTICATOR_PERIOD = 30U;

// SERVER_MAJOR_VERSION is the actual full version of the server, including minor and patch numbers.
// This is intended for internal use to identify the exact state of the server (release) software.
static constexpr auto SERVER_RELEASE_VERSION = "3.0.0";
static constexpr auto CLIENT_VERSION = 1321;

#define CLIENT_VERSION_UPPER (CLIENT_VERSION / 100)
#define CLIENT_VERSION_LOWER (CLIENT_VERSION % 100)
