/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_PCH_HPP_
#define SRC_PCH_HPP_

// Definitions should be global.
#include "utils/definitions.h"
#include "utils/simd.hpp"

#include <bitset>
#include <filesystem>
#include <fstream>
#include <forward_list>
#include <list>
#include <map>
#include <random>
#include <regex>
#include <set>
#include <queue>
#include <vector>

#include <asio.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/range/adaptor/reversed.hpp>
#include <curl/curl.h>
#include <fmt/chrono.h>
#include <gmp.h>
#include <json/json.h>
#include <luajit/lua.hpp>
#include <magic_enum.hpp>
#include <mio/mmap.hpp>
#include <mysql.h>
#include <mysql/errmsg.h>
#include <spdlog/spdlog.h>
#include <parallel_hashmap/phmap.h>
#include <pugixml.hpp>
#include <zlib.h>

#endif  // SRC_PCH_HPP_
