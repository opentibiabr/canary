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
	#include <memory>
	#include <string>
#endif

class Logger;

class RsaBackend {
public:
	virtual ~RsaBackend() = default;
	virtual bool loadPEM(const std::string &filename) = 0;
	virtual void setKey(const char* pString, const char* qString, int base) = 0;
	virtual void decrypt(char* msg) const = 0;
};

std::unique_ptr<RsaBackend> createMbedTlsRsaBackend(Logger &logger);
