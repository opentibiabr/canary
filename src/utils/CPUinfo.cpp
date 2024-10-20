/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "utils/CPUinfo.hpp"
#include "lib/di/container.hpp"
#include <cpuinfo.h>

CPUInfo &CPUInfo::getInstance() {
	return inject<CPUInfo>();
}

CPUInfo::CPUInfo() :
	processorName("Unknown"), vendorName("Unknown"), architectureTypeName("Unknown"), coreCount(0), threadCount(0),
	l1CacheSize(0), l2CacheSize(0), l3CacheSize(0), hasAVXSupport(false), hasAVX2Support(false), hasAVX512FSupport(false),
	hasSSESupport(false), hasSSE2Support(false), hasSSE3Support(false), hasSSSE3Support(false), hasSSE41Support(false), hasSSE42Support(false),
	hasNEONSupport(false), hasFMASupport(false), hasSHASupport(false), hasBMI1Support(false), hasBMI2Support(false) {
	if (!cpuinfo_initialize()) {
		std::cerr << "Failed to initialize CPUinfo." << std::endl;
		return;
	}

	const struct cpuinfo_processor* processor = cpuinfo_get_processor(0);
	if (processor) {
		if (cpuinfo_get_packages_count() > 0) {
			const cpuinfo_package* package = cpuinfo_get_package(0);
			if (package) {
				processorName = package->name ? package->name : "Unknown";
				vendorName = "Unknown";

				struct VendorInfo {
					const char* keyword;
					const char* name;
				};

				static constexpr VendorInfo vendors[] = {
					{ "Intel", "Intel" },
					{ "AMD", "AMD" },
					{ "Apple", "Apple" },
					{ "ARM", "ARM" }
				};

				for (const auto &[keyword, name] : vendors) {
					if (strstr(package->name, keyword)) {
						vendorName = name;
						break;
					}
				}

				if (vendorName == "Apple" && (strstr(package->name, "M1") || strstr(package->name, "M2"))) {
					processorName = "Apple Silicon (M1/M2)";
				}
			}
		}

		if (cpuinfo_has_x86_avx() || cpuinfo_has_x86_sse()) {
			architectureTypeName = "x86";
			if (sizeof(void*) == 8) {
				architectureTypeName = "x64";
			}
		} else if (cpuinfo_has_arm_neon()) {
			architectureTypeName = "ARM";
			if (vendorName == "Apple") {
				architectureTypeName = "Apple Silicon";
			}
		} else {
			architectureTypeName = "Unknown";
		}

		coreCount = cpuinfo_get_cores_count();
		threadCount = cpuinfo_get_processors_count();

		const struct cpuinfo_cache* l1 = cpuinfo_get_l1d_cache(0);
		if (l1) {
			l1CacheSize = l1->size;
		}
		const struct cpuinfo_cache* l2 = cpuinfo_get_l2_cache(0);
		if (l2) {
			l2CacheSize = l2->size;
		}
		const struct cpuinfo_cache* l3 = cpuinfo_get_l3_cache(0);
		if (l3) {
			l3CacheSize = l3->size;
		}

		hasAVXSupport = cpuinfo_has_x86_avx();
		hasAVX2Support = cpuinfo_has_x86_avx2();
		hasAVX512FSupport = cpuinfo_has_x86_avx512f();
		hasSSESupport = cpuinfo_has_x86_sse();
		hasSSE2Support = cpuinfo_has_x86_sse2();
		hasSSE3Support = cpuinfo_has_x86_sse3();
		hasSSSE3Support = cpuinfo_has_x86_ssse3();
		hasSSE41Support = cpuinfo_has_x86_sse4_1();
		hasSSE42Support = cpuinfo_has_x86_sse4_2();
		hasNEONSupport = cpuinfo_has_arm_neon();
		hasFMASupport = cpuinfo_has_x86_fma3();
		hasSHASupport = cpuinfo_has_x86_sha();
		hasBMI1Support = cpuinfo_has_x86_bmi();
		hasBMI2Support = cpuinfo_has_x86_bmi2();
	} else {
		std::cerr << "Failed to detect CPU architecture." << std::endl;
	}
}

CPUInfo::~CPUInfo() {
	cpuinfo_deinitialize();
}
