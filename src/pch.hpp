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

#include <algorithm>
#include <bitset>
#include <chrono>
#include <cstdint>
#include <condition_variable>
#include <ctime>
#include <csignal>
#include <deque>
#include <fstream>
#include <forward_list>
#include <functional>
#include <iomanip>
#include <iostream>
#include <limits>
#include <list>
#include <map>
#include <memory>
#include <mutex>
#include <mysql.h>
#include <random>
#include <regex>
#include <set>
#include <stack>
#include <sstream>
#include <string>
#include <thread>
#include <typeinfo>
#include <utility>
#include <unordered_map>
#include <unordered_set>
#include <queue>
#include <vector>

#include <boost/asio.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/filesystem.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/iostreams/device/mapped_file.hpp>
#include <boost/range/adaptor/reversed.hpp>
#include <boost/variant.hpp>
#include <curl/curl.h>
#include <json/json.h>
#include <magic_enum.hpp>
#include <mysql/errmsg.h>
#include <spdlog/spdlog.h>
#include <parallel_hashmap/phmap.h>
#include <pugixml.hpp>
#include <zlib.h>

#endif  // SRC_PCH_HPP_
