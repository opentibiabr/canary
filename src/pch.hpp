/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_PCH_HPP_
#define SRC_PCH_HPP_

// Definitions should be global.
#include "utils/definitions.h"
#include "utils/simd.hpp"

#include <bitset>
#include <charconv>
#include <filesystem>
#include <fstream>
#include <forward_list>
#include <list>
#include <map>
#include <random>
#include <ranges>
#include <regex>
#include <set>
#include <queue>
#include <vector>
#include <variant>

#ifdef _WIN32
	#include <io.h> // Para _isatty() no Windows
	#define isatty _isatty
	#define STDIN_FILENO _fileno(stdin)
#else
	#include <unistd.h> // Para isatty() no Linux e outros sistemas POSIX
#endif

#ifdef OS_WINDOWS
	#include "conio.h"
#endif

#if __has_include("gitmetadata.h")
	#include "gitmetadata.h"
#endif

#include <asio.hpp>
#include <curl/curl.h>
#include <fmt/chrono.h>
#include <gmp.h>
#include <gsl/gsl-lite.hpp>
#include <json/json.h>
#if __has_include("luajit/lua.hpp")
	#include <luajit/lua.hpp>
#else
	#include <lua.hpp>
#endif
#include <magic_enum.hpp>
#include <mio/mmap.hpp>
#if __has_include("<mysql.h>")
	#include <mysql.h>
#else
	#include <mysql/mysql.h>
#endif
#include <mysql/errmsg.h>
#include <spdlog/spdlog.h>
#include <parallel_hashmap/phmap.h>
#include <pugixml.hpp>
#include <zlib.h>

#endif // SRC_PCH_HPP_
