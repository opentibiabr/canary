/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class CPUInfo {
public:
	CPUInfo();
	~CPUInfo();

	CPUInfo(const CPUInfo &) = delete;
	CPUInfo &operator=(const CPUInfo &) = delete;

	static CPUInfo &getInstance();

	// Getters
	const std::string &getArchitecture() const {
		return processorName;
	}
	const std::string &getVendor() const {
		return vendorName;
	}
	const std::string &getArchitectureType() const {
		return architectureTypeName;
	}
	int getCores() const {
		return coreCount;
	}
	int getThreads() const {
		return threadCount;
	}
	size_t getL1Cache() const {
		return l1CacheSize;
	}
	size_t getL2Cache() const {
		return l2CacheSize;
	}
	size_t getL3Cache() const {
		return l3CacheSize;
	}
	bool hasAVX() const {
		return hasAVXSupport;
	}
	bool hasAVX2() const {
		return hasAVX2Support;
	}
	bool hasAVX512F() const {
		return hasAVX512FSupport;
	}
	bool hasSSE() const {
		return hasSSESupport;
	}
	bool hasSSE2() const {
		return hasSSE2Support;
	}
	bool hasSSE3() const {
		return hasSSE3Support;
	}
	bool hasSSSE3() const {
		return hasSSSE3Support;
	}
	bool hasSSE4_1() const {
		return hasSSE41Support;
	}
	bool hasSSE4_2() const {
		return hasSSE42Support;
	}
	bool hasNEON() const {
		return hasNEONSupport;
	}
	bool hasFMA() const {
		return hasFMASupport;
	}
	bool hasSHA() const {
		return hasSHASupport;
	}
	bool hasBMI1() const {
		return hasBMI1Support;
	}
	bool hasBMI2() const {
		return hasBMI2Support;
	}

private:
	// Member variables
	std::string processorName {};
	std::string vendorName {};
	std::string architectureTypeName {};
	int coreCount;
	int threadCount;
	size_t l1CacheSize;
	size_t l2CacheSize;
	size_t l3CacheSize;
	bool hasAVXSupport;
	bool hasAVX2Support;
	bool hasAVX512FSupport;
	bool hasSSESupport;
	bool hasSSE2Support;
	bool hasSSE3Support;
	bool hasSSSE3Support;
	bool hasSSE41Support;
	bool hasSSE42Support;
	bool hasNEONSupport;
	bool hasFMASupport;
	bool hasSHASupport;
	bool hasBMI1Support;
	bool hasBMI2Support;
};

constexpr auto g_cpuinfo = CPUInfo::getInstance;
