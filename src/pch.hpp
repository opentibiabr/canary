/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

// --------------------
// Internal Includes
// --------------------

// Utils
#include "utils/benchmark.hpp"
#include "utils/definitions.hpp"
#include "utils/simd.hpp"
#include "utils/vectorset.hpp"
#include "utils/arraylist.hpp"
#include "utils/vectorsort.hpp"

// --------------------
// STL Includes
// --------------------

#include <bitset>
#include <charconv>
#include <filesystem>
#include <fstream>
#include <forward_list>
#include <list>
#include <map>
#include <unordered_set>
#include <queue>
#include <random>
#include <ranges>
#include <regex>
#include <set>
#include <thread>
#include <vector>
#include <variant>

// --------------------
// System Includes
// --------------------

#ifdef _WIN32
	#include <io.h> // For _isatty() on Windows
	#define isatty _isatty
	#define STDIN_FILENO _fileno(stdin)
#else
	#include <unistd.h> // For isatty() on Linux and other POSIX systems
#endif

#ifdef OS_WINDOWS
	#include <conio.h>
#endif

// --------------------
// Third Party Includes
// --------------------

// ABSL
#include <absl/numeric/int128.h>

// ARGON2
#include <argon2.h>

// ASIO
#include <asio.hpp>

// CURL
#include <curl/curl.h>

// FMT
#include <fmt/chrono.h>
#include <fmt/core.h>
#include <fmt/format.h>
#include <fmt/args.h>

// GMP
#include <gmp.h>

// JSON
#include <json/json.h>

// LUA
#if __has_include("luajit/lua.hpp")
	#include <luajit/lua.hpp>
#else
	#include <lua.hpp>
#endif

#include "lua/global/shared_object.hpp"

// Magic Enum
#include <magic_enum.hpp>

// Memory Mapped File
#include <mio/mmap.hpp>

// MySQL
#if __has_include("<mysql.h>")
	#include <mysql.h>
#else
	#include <mysql/mysql.h>
#endif

#include <mysql/errmsg.h>

// Parallel Hash Map
#include <parallel_hashmap/phmap.h>
#include <parallel_hashmap/btree.h>

// PugiXML
#include <pugixml.hpp>

// Zlib
#include <zlib.h>

#include <boost/di.hpp>

// -------------------------
// GIT Metadata Includes
// -------------------------

#if __has_include("gitmetadata.h")
	#include "gitmetadata.h"
#endif

// ---------------------
// Standard STL Includes
// ---------------------

#include <string>
#include <iostream>

/**
 * Static custom libraries that can be pre-compiled like DI and messaging
 */
#include "lib/messaging/message.hpp"
#include "lib/messaging/command.hpp"
#include "lib/messaging/event.hpp"

#include <eventpp/utilities/scopedremover.h>
#include <eventpp/eventdispatcher.h>

#include "lua/global/shared_object.hpp"
