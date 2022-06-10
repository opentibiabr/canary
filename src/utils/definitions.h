/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_UTILS_DEFINITIONS_H_
#define SRC_UTILS_DEFINITIONS_H_

static constexpr auto STATUS_SERVER_NAME = "Canary";
static constexpr auto STATUS_SERVER_VERSION = "1.3.1";
static constexpr auto STATUS_SERVER_DEVELOPERS = "OpenTibiaBR Organization and contributors";

static constexpr auto AUTHENTICATOR_DIGITS = 6U;
static constexpr auto AUTHENTICATOR_PERIOD = 30U;

static constexpr auto CLIENT_VERSION = 1286;
#define CLIENT_VERSION_UPPER (CLIENT_VERSION / 100)
#define CLIENT_VERSION_LOWER (CLIENT_VERSION % 100)

#define NONCOPYABLE(Type) Type(const Type&)=delete; Type& operator=(const Type&)=delete

/// Branch Prediction.  See the GCC Manual for more information.
 /// NB: These are used when speed is need most; do not use in normal
 /// code, they may slow down stuff.
#if defined(__clang__) || defined(__GNUC__)
#define likely(x)     __builtin_expect(!!(x), 1)
#define unlikely(x)    __builtin_expect(!!(x), 0)
#else
#define likely(x)    (x)
#define unlikely(x)    (x)
#endif

#ifndef __FUNCTION__
#define __FUNCTION__ __func__
#endif

#ifndef _CRT_SECURE_NO_WARNINGS
#define _CRT_SECURE_NO_WARNINGS
#endif

#ifndef _USE_MATH_DEFINES
#define _USE_MATH_DEFINES
#endif

#include <cmath>

#ifdef _WIN32
#ifndef NOMINMAX
#define NOMINMAX
#endif

#if defined(_WIN32) || defined(WIN32) || defined(__CYGWIN__) || defined(__MINGW32__) || defined(__BORLANDC__)
#define OS_WINDOWS
#endif

#define WIN32_LEAN_AND_MEAN

#ifdef _MSC_VER
#ifdef NDEBUG
#define _SECURE_SCL 0
#define HAS_ITERATOR_DEBUGGING 0
#endif

#pragma warning(disable:4127) // conditional expression is constant
#pragma warning(disable:4244) // 'argument' : conversion from 'type1' to 'type2', possible loss of data
#pragma warning(disable:4250) // 'class1' : inherits 'class2::member' via dominance
#pragma warning(disable:4267) // 'var' : conversion from 'size_t' to 'type', possible loss of data
#pragma warning(disable:4319) // '~': zero extending 'unsigned int' to 'lua_Number' of greater size
#pragma warning(disable:4458) // declaration hides class member
#pragma warning(disable:4101) // local variable not referenced
#pragma warning(disable:4996) // declaration std::fpos<_Mbstatet>::seekpos
#endif

#define strcasecmp _stricmp
#define strncasecmp _strnicmp

#ifndef _WIN32_WINNT
// 0x0602: Windows 7
#define _WIN32_WINNT 0x0602
#endif
#endif

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

typedef int error_t;

#endif  // SRC_UTILS_DEFINITIONS_H_
