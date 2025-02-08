

#include "pch.hpp"
#include "api/utils/system_info.hpp"

std::deque<double> SystemInfo::cpuHistory;
std::deque<double> SystemInfo::systemCpuHistory;
bool SystemInfo::firstCall = true;

#ifdef _WIN32
	#include <windows.h>
	#include <psapi.h>
	#include <winreg.h>
	#pragma comment(lib, "pdh.lib")

ULARGE_INTEGER SystemInfo::lastSystemKernel { 0 };
ULARGE_INTEGER SystemInfo::lastSystemUser { 0 };
ULARGE_INTEGER SystemInfo::lastSystemIdle { 0 };

std::string SystemInfo::getCpuName() {
	char buffer[256] = { 0 };
	DWORD bufferSize = sizeof(buffer);
	HKEY hKey;

	if (RegOpenKeyExA(HKEY_LOCAL_MACHINE, "HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0", 0, KEY_READ, &hKey) == ERROR_SUCCESS) {
		if (RegQueryValueExA(hKey, "ProcessorNameString", nullptr, nullptr, reinterpret_cast<LPBYTE>(buffer), &bufferSize) == ERROR_SUCCESS) {
			RegCloseKey(hKey);
			return std::string(buffer);
		}
		RegCloseKey(hKey);
	}
	return "Unknown";
}
#else
	#include <sys/resource.h>
	#include <sys/sysinfo.h>
	#include <sys/utsname.h>
	#include <unistd.h>
	#include <fstream>
	#include <sstream>
	#include <vector>

std::string SystemInfo::getCpuName() {
	std::ifstream cpuinfo("/proc/cpuinfo");
	std::string line;
	while (std::getline(cpuinfo, line)) {
		if (line.find("model name") != std::string::npos) {
			size_t colon = line.find(':');
			if (colon != std::string::npos) {
				std::string name = line.substr(colon + 1);
				name.erase(0, name.find_first_not_of(" \t"));
				name.erase(name.find_last_not_of(" \t") + 1);
				return name;
			}
		}
	}
	return "Unknown";
}
#endif

nlohmann::json SystemInfo::getSystemResources() {
	nlohmann::json info;

	try {
#ifdef _WIN32
		// Nome do processo
		char processName[MAX_PATH] = "";
		if (GetModuleBaseNameA(GetCurrentProcess(), nullptr, processName, MAX_PATH)) {
			info["process"] = {
				{ "name", std::string(processName) }
			};
		}

		// Informações detalhadas de memória do processo
		PROCESS_MEMORY_COUNTERS_EX pmc;
		if (GetProcessMemoryInfo(GetCurrentProcess(), reinterpret_cast<PROCESS_MEMORY_COUNTERS*>(&pmc), sizeof(pmc))) {
			double workingSetMB = pmc.WorkingSetSize / (1024.0 * 1024.0);
			double privateUsageMB = pmc.PrivateUsage / (1024.0 * 1024.0);
			double pageFaultCount = pmc.PageFaultCount;
			double peakWorkingSetMB = pmc.PeakWorkingSetSize / (1024.0 * 1024.0);
			double quotaPeakPagedPoolUsageMB = pmc.QuotaPeakPagedPoolUsage / (1024.0 * 1024.0);
			double quotaPagedPoolUsageMB = pmc.QuotaPagedPoolUsage / (1024.0 * 1024.0);

			info["memory"] = {
				{ "working_set_mb", workingSetMB },
				{ "private_usage_mb", privateUsageMB },
				{ "page_fault_count", pageFaultCount },
				{ "peak_working_set_mb", peakWorkingSetMB },
				{ "quota_peak_paged_pool_mb", quotaPeakPagedPoolUsageMB },
				{ "quota_paged_pool_mb", quotaPagedPoolUsageMB }
			};
		}

		// CPU usando GetSystemTimes e GetProcessTimes
		FILETIME idleTime, kernelTime, userTime;
		FILETIME processCreation, processExit, processKernel, processUser;

		if (GetSystemTimes(&idleTime, &kernelTime, &userTime) && GetProcessTimes(GetCurrentProcess(), &processCreation, &processExit, &processKernel, &processUser)) {

			static ULARGE_INTEGER lastProcessKernel { 0 }, lastProcessUser { 0 };

			ULARGE_INTEGER processKernelTime, processUserTime;
			processKernelTime.LowPart = processKernel.dwLowDateTime;
			processKernelTime.HighPart = processKernel.dwHighDateTime;
			processUserTime.LowPart = processUser.dwLowDateTime;
			processUserTime.HighPart = processUser.dwHighDateTime;

			ULARGE_INTEGER systemKernelTime, systemUserTime, systemIdleTime;
			systemKernelTime.LowPart = kernelTime.dwLowDateTime;
			systemKernelTime.HighPart = kernelTime.dwHighDateTime;
			systemUserTime.LowPart = userTime.dwLowDateTime;
			systemUserTime.HighPart = userTime.dwHighDateTime;
			systemIdleTime.LowPart = idleTime.dwLowDateTime;
			systemIdleTime.HighPart = idleTime.dwHighDateTime;

			if (!firstCall) {
				// Calcula deltas do processo
				ULONGLONG processKernelDiff = processKernelTime.QuadPart - lastProcessKernel.QuadPart;
				ULONGLONG processUserDiff = processUserTime.QuadPart - lastProcessUser.QuadPart;
				ULONGLONG processTotalDiff = processKernelDiff + processUserDiff;

				// Calcula deltas do sistema
				ULONGLONG systemKernelDiff = systemKernelTime.QuadPart - lastSystemKernel.QuadPart;
				ULONGLONG systemUserDiff = systemUserTime.QuadPart - lastSystemUser.QuadPart;
				ULONGLONG systemIdleDiff = systemIdleTime.QuadPart - lastSystemIdle.QuadPart;
				ULONGLONG systemTotalDiff = systemKernelDiff + systemUserDiff;

				if (systemTotalDiff > 0) {
					// Calcula uso de CPU do processo
					double cpuUsage = (processTotalDiff * 100.0) / systemTotalDiff;
					cpuHistory.push_back(cpuUsage);
					if (cpuHistory.size() > PROCESS_AVERAGE_WINDOW) {
						cpuHistory.pop_front();
					}

					double avgCpuUsage = 0;
					if (!cpuHistory.empty()) {
						avgCpuUsage = std::accumulate(cpuHistory.begin(), cpuHistory.end(), 0.0) / cpuHistory.size();
					}

					// Calcula tempos em kernel e user mode
					double kernelTimePercent = (processKernelDiff * 100.0) / processTotalDiff;
					double userTimePercent = (processUserDiff * 100.0) / processTotalDiff;

					info["cpu"] = {
						{ "usage_percent", std::min(100.0, std::max(0.0, avgCpuUsage * 2)) },
						{ "kernel_time_percent", kernelTimePercent },
						{ "user_time_percent", userTimePercent }
					};

					// Calcula uso total de CPU do sistema
					double systemCpuUsage = 100.0 - ((systemIdleDiff * 100.0) / systemTotalDiff);

					// Remove valores muito discrepantes
					if (!systemCpuHistory.empty()) {
						double currentAvg = std::accumulate(systemCpuHistory.begin(), systemCpuHistory.end(), 0.0) / systemCpuHistory.size();
						if (std::abs(systemCpuUsage - currentAvg) > (currentAvg * 0.5)) {
							systemCpuUsage = currentAvg;
						}
					}

					systemCpuHistory.push_back(systemCpuUsage);
					if (systemCpuHistory.size() > SYSTEM_AVERAGE_WINDOW) {
						systemCpuHistory.pop_front();
					}

					double avgSystemCpuUsage = 0;
					if (!systemCpuHistory.empty()) {
						avgSystemCpuUsage = std::accumulate(systemCpuHistory.begin(), systemCpuHistory.end(), 0.0) / systemCpuHistory.size();
					}

					// Calcula tempos do sistema
					double systemKernelTimePercent = (systemKernelDiff * 100.0) / systemTotalDiff;
					double systemUserTimePercent = (systemUserDiff * 100.0) / systemTotalDiff;
					double systemIdleTimePercent = (systemIdleDiff * 100.0) / systemTotalDiff;

					info["system"]["cpu"] = {
						{ "usage_percent", std::min(100.0, std::max(0.0, avgSystemCpuUsage * 1.8)) },
						{ "kernel_time_percent", systemKernelTimePercent },
						{ "user_time_percent", systemUserTimePercent },
						{ "idle_time_percent", systemIdleTimePercent },
						{ "name", getCpuName() }
					};
				}
			}

			firstCall = false;
			lastProcessKernel = processKernelTime;
			lastProcessUser = processUserTime;
			lastSystemKernel = systemKernelTime;
			lastSystemUser = systemUserTime;
			lastSystemIdle = systemIdleTime;
		}

		// Informações do sistema
		SYSTEM_INFO sysInfo;
		GetSystemInfo(&sysInfo);

		// Informações detalhadas de memória do sistema
		MEMORYSTATUSEX memInfo;
		memInfo.dwLength = sizeof(MEMORYSTATUSEX);
		if (GlobalMemoryStatusEx(&memInfo)) {
			double totalPhysicalMemGB = memInfo.ullTotalPhys / (1024.0 * 1024.0 * 1024.0);
			double availPhysicalMemGB = memInfo.ullAvailPhys / (1024.0 * 1024.0 * 1024.0);
			double totalVirtualMemGB = memInfo.ullTotalVirtual / (1024.0 * 1024.0 * 1024.0);
			double availVirtualMemGB = memInfo.ullAvailVirtual / (1024.0 * 1024.0 * 1024.0);
			double totalPageFileGB = memInfo.ullTotalPageFile / (1024.0 * 1024.0 * 1024.0);
			double availPageFileGB = memInfo.ullAvailPageFile / (1024.0 * 1024.0 * 1024.0);
			double memoryUsagePercent = memInfo.dwMemoryLoad;

			info["system"]["memory"] = nlohmann::json {
				{ "total_gb", totalPhysicalMemGB },
				{ "available_gb", availPhysicalMemGB },
				{ "usage_percent", memoryUsagePercent }
			};

			info["system"]["memory"]["virtual"] = nlohmann::json {
				{ "total_gb", totalVirtualMemGB },
				{ "available_gb", availVirtualMemGB }
			};

			info["system"]["memory"]["page_file"] = nlohmann::json {
				{ "total_gb", totalPageFileGB },
				{ "available_gb", availPageFileGB }
			};

			// Performance information
			PERFORMANCE_INFORMATION perfInfo;
			if (GetPerformanceInfo(&perfInfo, sizeof(perfInfo))) {
				double commitTotalGB = (perfInfo.CommitTotal * perfInfo.PageSize) / (1024.0 * 1024.0 * 1024.0);
				double commitLimitGB = (perfInfo.CommitLimit * perfInfo.PageSize) / (1024.0 * 1024.0 * 1024.0);
				double commitPeakGB = (perfInfo.CommitPeak * perfInfo.PageSize) / (1024.0 * 1024.0 * 1024.0);
				double systemCacheGB = (perfInfo.SystemCache * perfInfo.PageSize) / (1024.0 * 1024.0 * 1024.0);
				double kernelTotalGB = (perfInfo.KernelTotal * perfInfo.PageSize) / (1024.0 * 1024.0 * 1024.0);
				double kernelPagedGB = (perfInfo.KernelPaged * perfInfo.PageSize) / (1024.0 * 1024.0 * 1024.0);
				double kernelNonpagedGB = (perfInfo.KernelNonpaged * perfInfo.PageSize) / (1024.0 * 1024.0 * 1024.0);

				info["system"]["memory"]["performance"] = nlohmann::json {
					{ "commit", nlohmann::json { { "total_gb", commitTotalGB }, { "limit_gb", commitLimitGB }, { "peak_gb", commitPeakGB } } },
					{ "system_cache_gb", systemCacheGB },
					{ "kernel", nlohmann::json { { "total_gb", kernelTotalGB }, { "paged_gb", kernelPagedGB }, { "nonpaged_gb", kernelNonpagedGB } } },
					{ "page_size", perfInfo.PageSize },
					{ "handle_count", perfInfo.HandleCount },
					{ "process_count", perfInfo.ProcessCount },
					{ "thread_count", perfInfo.ThreadCount }
				};
			}
		}

		info["system"]["cpu_cores"] = static_cast<int>(sysInfo.dwNumberOfProcessors);
		info["system"]["architecture"] = sizeof(void*) * 8;
		info["system"]["processor"] = nlohmann::json {
			{ "type", static_cast<int>(sysInfo.wProcessorArchitecture) },
			{ "level", static_cast<int>(sysInfo.wProcessorLevel) },
			{ "revision", static_cast<int>(sysInfo.wProcessorRevision) }
		};

#else
		// Nome do processo
		char processName[1024];
		ssize_t len = readlink("/proc/self/exe", processName, sizeof(processName) - 1);
		if (len != -1) {
			processName[len] = '\0';
			const char* lastSlash = strrchr(processName, '/');
			info["process"] = {
				{ "name", lastSlash ? lastSlash + 1 : processName }
			};
		}

		// Memória do processo
		long rss = 0, hwm = 0, vm_size = 0, minflt = 0, majflt = 0;
		long private_clean = 0, private_dirty = 0;

		std::ifstream statusFile("/proc/self/status");
		std::string line;
		while (std::getline(statusFile, line)) {
			if (line.starts_with("VmRSS:")) {
				std::istringstream iss(line.substr(6));
				iss >> rss;
			} else if (line.starts_with("VmHWM:")) {
				std::istringstream iss(line.substr(6));
				iss >> hwm;
			} else if (line.starts_with("VmSize:")) {
				std::istringstream iss(line.substr(7));
				iss >> vm_size;
			}
		}

		std::ifstream statFile("/proc/self/stat");
		std::string statLine;
		if (std::getline(statFile, statLine)) {
			std::istringstream iss(statLine);
			std::vector<std::string> stats;
			std::string token;
			while (iss >> token) {
				stats.push_back(token);
			}
			if (stats.size() >= 24) {
				minflt = std::stol(stats[9]);
				majflt = std::stol(stats[11]);
			}
		}

		std::ifstream smapsFile("/proc/self/smaps");
		std::string smapsLine;
		while (std::getline(smapsFile, smapsLine)) {
			if (smapsLine.starts_with("Private_Clean:")) {
				std::istringstream iss(smapsLine.substr(14));
				iss >> private_clean;
			} else if (smapsLine.starts_with("Private_Dirty:")) {
				std::istringstream iss(smapsLine.substr(14));
				iss >> private_dirty;
			}
		}

		double working_set_mb = rss / 1024.0;
		double peak_working_set_mb = hwm / 1024.0;
		double private_usage_mb = (private_clean + private_dirty) / 1024.0;
		long page_faults = minflt + majflt;

		info["memory"] = {
			{ "working_set_mb", working_set_mb },
			{ "private_usage_mb", private_usage_mb },
			{ "page_fault_count", page_faults },
			{ "peak_working_set_mb", peak_working_set_mb },
			{ "quota_peak_paged_pool_mb", 0.0 },
			{ "quota_paged_pool_mb", 0.0 }
		};

		// CPU do processo
		static long last_utime = 0, last_stime = 0;
		static time_t last_time = time(NULL);
		long utime = 0, stime = 0;

		std::ifstream procStatFile("/proc/self/stat");
		std::string procStatLine;
		if (std::getline(procStatFile, procStatLine)) {
			std::istringstream iss(procStatLine);
			std::vector<std::string> stats;
			std::string token;
			while (iss >> token) {
				stats.push_back(token);
			}
			if (stats.size() >= 14) {
				utime = std::stol(stats[13]);
				stime = std::stol(stats[14]);
			}
		}

		time_t current_time = time(NULL);
		double time_diff = difftime(current_time, last_time);

		if (time_diff > 0 && !firstCall) {
			long total_time = (utime + stime) - (last_utime + last_stime);
			double cpu_usage = (total_time / (time_diff * sysconf(_SC_CLK_TCK))) * 100.0;
			cpu_usage = std::min(100.0, std::max(0.0, cpu_usage));

			cpuHistory.push_back(cpu_usage);
			if (cpuHistory.size() > PROCESS_AVERAGE_WINDOW) {
				cpuHistory.pop_front();
			}

			double avgCpuUsage = 0;
			if (!cpuHistory.empty()) {
				avgCpuUsage = std::accumulate(cpuHistory.begin(), cpuHistory.end(), 0.0) / cpuHistory.size();
			}

			double user_time_diff = utime - last_utime;
			double kernel_time_diff = stime - last_stime;
			double total_time_diff = user_time_diff + kernel_time_diff;

			double user_percent = (total_time_diff > 0) ? (user_time_diff * 100.0 / total_time_diff) : 0;
			double kernel_percent = (total_time_diff > 0) ? (kernel_time_diff * 100.0 / total_time_diff) : 0;

			info["cpu"] = {
				{ "usage_percent", avgCpuUsage },
				{ "user_time_percent", user_percent },
				{ "kernel_time_percent", kernel_percent }
			};
		}

		last_utime = utime;
		last_stime = stime;
		last_time = current_time;

		// CPU do sistema
		static uint64_t last_total_user = 0, last_total_system = 0, last_total_idle = 0;
		std::ifstream sysStatFile("/proc/stat");
		std::string cpuLine;
		if (std::getline(sysStatFile, cpuLine) && cpuLine.starts_with("cpu ")) {
			std::istringstream iss(cpuLine.substr(5));
			uint64_t user, nice, system, idle, iowait, irq, softirq;
			iss >> user >> nice >> system >> idle >> iowait >> irq >> softirq;

			uint64_t total_user = user + nice;
			uint64_t total_system = system + irq + softirq;
			uint64_t total_idle = idle + iowait;

			if (!firstCall) {
				uint64_t user_diff = total_user - last_total_user;
				uint64_t system_diff = total_system - last_total_system;
				uint64_t idle_diff = total_idle - last_total_idle;
				uint64_t total_diff = user_diff + system_diff + idle_diff;

				if (total_diff > 0) {
					double system_cpu_usage = (user_diff + system_diff) * 100.0 / total_diff;

					systemCpuHistory.push_back(system_cpu_usage);
					if (systemCpuHistory.size() > SYSTEM_AVERAGE_WINDOW) {
						systemCpuHistory.pop_front();
					}

					double avg_system_cpu = systemCpuHistory.empty() ? 0 : std::accumulate(systemCpuHistory.begin(), systemCpuHistory.end(), 0.0) / systemCpuHistory.size();

					double user_percent = (user_diff * 100.0) / total_diff;
					double system_percent = (system_diff * 100.0) / total_diff;
					double idle_percent = (idle_diff * 100.0) / total_diff;

					info["system"]["cpu"] = {
						{ "usage_percent", avg_system_cpu },
						{ "user_time_percent", user_percent },
						{ "kernel_time_percent", system_percent },
						{ "idle_time_percent", idle_percent },
						{ "name", getCpuName() }
					};
				}
			}

			last_total_user = total_user;
			last_total_system = total_system;
			last_total_idle = total_idle;
		}

		// Memória do sistema
		struct sysinfo memInfo;
		sysinfo(&memInfo);

		// Usar uint64_t para evitar overflow
		uint64_t total_ram = memInfo.totalram * memInfo.mem_unit;
		uint64_t free_ram = memInfo.freeram * memInfo.mem_unit;
		uint64_t total_swap = memInfo.totalswap * memInfo.mem_unit;
		uint64_t free_swap = memInfo.freeswap * memInfo.mem_unit;

		// Converter para GB
		double totalPhysicalMemGB = total_ram / (1024.0 * 1024.0 * 1024.0);
		double availPhysicalMemGB = free_ram / (1024.0 * 1024.0 * 1024.0);
		double memoryUsagePercent = ((total_ram - free_ram) / (double)total_ram) * 100.0;

		info["system"]["memory"] = {
			{ "total_gb", totalPhysicalMemGB },
			{ "available_gb", availPhysicalMemGB },
			{ "usage_percent", memoryUsagePercent }
		};

		// Memória virtual (RAM + Swap) mesmo se swap for 0
		double totalVirtualMemGB = (total_ram + total_swap) / (1024.0 * 1024.0 * 1024.0);
		double availVirtualMemGB = (free_ram + free_swap) / (1024.0 * 1024.0 * 1024.0);
		info["system"]["memory"]["virtual"] = {
			{ "total_gb", totalVirtualMemGB },
			{ "available_gb", availVirtualMemGB }
		};

		// Page file (Swap)
		double totalPageFileGB = total_swap / (1024.0 * 1024.0 * 1024.0);
		double availPageFileGB = free_swap / (1024.0 * 1024.0 * 1024.0);
		info["system"]["memory"]["page_file"] = {
			{ "total_gb", totalPageFileGB },
			{ "available_gb", availPageFileGB }
		};

		// Informações de desempenho
		uint64_t committed_as = 0, commit_limit = 0, cached = 0;
		std::ifstream meminfoFile("/proc/meminfo");
		std::string memLine;
		while (std::getline(meminfoFile, memLine)) {
			if (memLine.starts_with("Committed_AS:")) {
				std::istringstream iss(memLine.substr(13));
				iss >> committed_as;
			} else if (memLine.starts_with("CommitLimit:")) {
				std::istringstream iss(memLine.substr(12));
				iss >> commit_limit;
			} else if (memLine.starts_with("Cached:")) {
				std::istringstream iss(memLine.substr(7));
				iss >> cached;
			}
		}

		info["system"]["memory"]["performance"] = {
			{ "commit", { { "total_gb", committed_as / 1048576.0 }, // Convertendo kB para GB
			              { "limit_gb", commit_limit / 1048576.0 },
			              { "peak_gb", 0.0 } } },
			{ "system_cache_gb", cached / 1048576.0 },
			{ "kernel", { { "total_gb", 0.0 }, { "paged_gb", 0.0 }, { "nonpaged_gb", 0.0 } } },
			{ "page_size", sysconf(_SC_PAGESIZE) },
			{ "handle_count", 0 },
			{ "process_count", memInfo.procs },
			{ "thread_count", 0 }
		};

		// Informações do sistema
		info["system"]["cpu_cores"] = get_nprocs();
		info["system"]["architecture"] = sizeof(void*) * 8;

		struct utsname unameData;
		uname(&unameData);
		info["system"]["processor"]["type"] = unameData.machine; // Exemplo: "x86_64"

		// Obtém informações detalhadas do /proc/cpuinfo
		std::ifstream cpuInfoFile("/proc/cpuinfo");
		int cpuFamily = 0, model = 0, stepping = 0;

		if (cpuInfoFile) {
			while (std::getline(cpuInfoFile, line)) {
				if (line.find("cpu family") != std::string::npos) {
					sscanf(line.c_str(), "cpu family : %d", &cpuFamily);
				} else if (line.find("model") != std::string::npos) {
					sscanf(line.c_str(), "model : %d", &model);
				} else if (line.find("stepping") != std::string::npos) {
					sscanf(line.c_str(), "stepping : %d", &stepping);
				}
			}
			cpuInfoFile.close();
		}

		info["system"]["processor"]["level"] = cpuFamily;
		info["system"]["processor"]["revision"] = (model << 4) | stepping; // Mesma lógica do Windows
		firstCall = false;
#endif

	} catch (const std::exception &e) {
		info["error"] = e.what();
	}

	return info;
}
