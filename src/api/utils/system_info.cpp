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

	if (RegOpenKeyExA(HKEY_LOCAL_MACHINE, R"(HARDWARE\DESCRIPTION\System\CentralProcessor\0)", 0, KEY_READ, &hKey) == ERROR_SUCCESS) {
		if (RegQueryValueExA(hKey, "ProcessorNameString", nullptr, nullptr, reinterpret_cast<LPBYTE>(buffer), &bufferSize) == ERROR_SUCCESS) {
			RegCloseKey(hKey);
			return { buffer };
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
	#include <time.h>

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
		SYSTEM_INFO sysInfo;
		GetSystemInfo(&sysInfo);
		const int numCores = static_cast<int>(sysInfo.dwNumberOfProcessors);

		char processName[MAX_PATH] = "";
		if (GetModuleBaseNameA(GetCurrentProcess(), nullptr, processName, MAX_PATH)) {
			info["process"] = { { "name", std::string(processName) } };
		}

		PROCESS_MEMORY_COUNTERS_EX pmc;
		if (GetProcessMemoryInfo(GetCurrentProcess(), reinterpret_cast<PROCESS_MEMORY_COUNTERS*>(&pmc), sizeof(pmc))) {
			info["memory"] = {
				{ "working_set_mb", static_cast<int>(pmc.WorkingSetSize) / 1048576.0 },
				{ "private_usage_mb", static_cast<int>(pmc.PrivateUsage) / 1048576.0 },
				{ "page_fault_count", pmc.PageFaultCount },
				{ "peak_working_set_mb", static_cast<int>(pmc.PeakWorkingSetSize) / 1048576.0 },
				{ "quota_peak_paged_pool_mb", static_cast<int>(pmc.QuotaPeakPagedPoolUsage) / 1048576.0 },
				{ "quota_paged_pool_mb", static_cast<int>(pmc.QuotaPagedPoolUsage) / 1048576.0 }
			};
		}

		FILETIME idleTime, kernelTime, userTime;
		FILETIME processCreation, processExit, processKernel, processUser;
		if (GetSystemTimes(&idleTime, &kernelTime, &userTime) && GetProcessTimes(GetCurrentProcess(), &processCreation, &processExit, &processKernel, &processUser)) {

			static ULARGE_INTEGER lastProcessKernel { 0 }, lastProcessUser { 0 };
			ULARGE_INTEGER pk, pu, sk, su, si;
			pk.LowPart = processKernel.dwLowDateTime;
			pk.HighPart = processKernel.dwHighDateTime;
			pu.LowPart = processUser.dwLowDateTime;
			pu.HighPart = processUser.dwHighDateTime;
			sk.LowPart = kernelTime.dwLowDateTime;
			sk.HighPart = kernelTime.dwHighDateTime;
			su.LowPart = userTime.dwLowDateTime;
			su.HighPart = userTime.dwHighDateTime;
			si.LowPart = idleTime.dwLowDateTime;
			si.HighPart = idleTime.dwHighDateTime;

			if (!firstCall) {
				ULONGLONG pdiff = pk.QuadPart - lastProcessKernel.QuadPart + (pu.QuadPart - lastProcessUser.QuadPart);
				ULONGLONG sidle = si.QuadPart - lastSystemIdle.QuadPart;
				ULONGLONG sKernelNoIdle = (sk.QuadPart - lastSystemKernel.QuadPart) - sidle;
				ULONGLONG sUser = su.QuadPart - lastSystemUser.QuadPart;
				ULONGLONG sdiff = sKernelNoIdle + sUser + sidle;

				if (sdiff > 0) {
					double procCPU = std::min(100.0, std::max(0.0, (static_cast<double>(pdiff) * 100.0) / static_cast<double>(sdiff)));
					cpuHistory.push_back(procCPU);
					if (cpuHistory.size() > PROCESS_AVERAGE_WINDOW) {
						cpuHistory.pop_front();
					}
					double avgProc = std::accumulate(cpuHistory.begin(), cpuHistory.end(), 0.0) / static_cast<double>(cpuHistory.size());
					double kpercent = static_cast<double>(pk.QuadPart - lastProcessKernel.QuadPart) * 100.0 / static_cast<double>(pdiff);
					double upercent = static_cast<double>(pu.QuadPart - lastProcessUser.QuadPart) * 100.0 / static_cast<double>(pdiff);

					info["cpu"] = {
						{ "usage_percent", avgProc },
						{ "kernel_time_percent", kpercent },
						{ "user_time_percent", upercent }
					};

					double sysCPU = static_cast<double>(sKernelNoIdle + sUser) * 100.0 / static_cast<double>(sdiff);
					systemCpuHistory.push_back(sysCPU);
					if (systemCpuHistory.size() > SYSTEM_AVERAGE_WINDOW) {
						systemCpuHistory.pop_front();
					}
					double avgSys = std::accumulate(systemCpuHistory.begin(), systemCpuHistory.end(), 0.0) / static_cast<double>(systemCpuHistory.size());

					double skpercent = static_cast<double>(sKernelNoIdle) * 100.0 / static_cast<double>(sdiff);
					double supercent = static_cast<double>(sUser) * 100.0 / static_cast<double>(sdiff);
					double sipercent = static_cast<double>(sidle) * 100.0 / static_cast<double>(sdiff);

					info["system"]["cpu"] = {
						{ "usage_percent", avgSys },
						{ "kernel_time_percent", skpercent },
						{ "user_time_percent", supercent },
						{ "idle_time_percent", sipercent },
						{ "name", getCpuName() }
					};
				}
			}

			firstCall = false;
			lastProcessKernel = pk;
			lastProcessUser = pu;
			lastSystemKernel = sk;
			lastSystemUser = su;
			lastSystemIdle = si;
		}

		MEMORYSTATUSEX memInfo;
		memInfo.dwLength = sizeof(MEMORYSTATUSEX);
		if (GlobalMemoryStatusEx(&memInfo)) {
			double totalGB = static_cast<double>(memInfo.ullTotalPhys) / 1073741824.0;
			double availGB = static_cast<double>(memInfo.ullAvailPhys) / 1073741824.0;
			double usage = (totalGB - availGB) * 100.0 / totalGB;
			info["system"]["memory"] = {
				{ "total_gb", totalGB },
				{ "available_gb", availGB },
				{ "usage_percent", usage }
			};

			PERFORMANCE_INFORMATION pi;
			if (GetPerformanceInfo(&pi, sizeof(pi))) {
				double commit = static_cast<double>(pi.CommitTotal * pi.PageSize) / 1073741824.0;
				info["system"]["memory"]["performance"] = { { "commit", { { "total_gb", commit } } } };
			}
		}

		info["system"]["cpu_cores"] = numCores;
		info["system"]["architecture"] = sizeof(void*) * 8;
		info["system"]["processor"] = {
			{ "type", static_cast<int>(sysInfo.wProcessorArchitecture) },
			{ "level", static_cast<int>(sysInfo.wProcessorLevel) },
			{ "revision", static_cast<int>(sysInfo.wProcessorRevision) }
		};
#else
		char processName[1024];
		ssize_t len = readlink("/proc/self/exe", processName, sizeof(processName) - 1);
		if (len != -1) {
			processName[len] = '\0';
			const char* lastSlash = strrchr(processName, '/');
			info["process"] = {
				{ "name", lastSlash ? lastSlash + 1 : processName }
			};
		}

		long rss = 0, hwm = 0, vm_size = 0, minflt = 0, majflt = 0;
		long private_clean = 0, private_dirty = 0;

		std::ifstream statusFile("/proc/self/status");
		std::string line;
		while (std::getline(statusFile, line)) {
			if (line.starts_with("VmRSS:")) {
				std::istringstream(line.substr(6)) >> rss;
			} else if (line.starts_with("VmHWM:")) {
				std::istringstream(line.substr(6)) >> hwm;
			} else if (line.starts_with("VmSize:")) {
				std::istringstream(line.substr(7)) >> vm_size;
			}
		}

		std::ifstream statFile("/proc/self/stat");
		std::string statLine;
		if (std::getline(statFile, statLine)) {
			std::istringstream iss(statLine);
			std::vector<std::string> stats((std::istream_iterator<std::string>(iss)), {});
			if (stats.size() >= 24) {
				minflt = std::stol(stats[9]);
				majflt = std::stol(stats[11]);
			}
		}

		std::ifstream smapsFile("/proc/self/smaps");
		while (std::getline(smapsFile, line)) {
			if (line.starts_with("Private_Clean:")) {
				std::istringstream(line.substr(14)) >> private_clean;
			} else if (line.starts_with("Private_Dirty:")) {
				std::istringstream(line.substr(14)) >> private_dirty;
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

		static long last_utime = 0, last_stime = 0;
		static timespec last_time = { 0, 0 };
		timespec current_time;
		clock_gettime(CLOCK_MONOTONIC, &current_time);
		double time_diff = (current_time.tv_sec - last_time.tv_sec) + (current_time.tv_nsec - last_time.tv_nsec) / 1e9;

		long utime = 0, stime = 0;
		std::ifstream procStatFile("/proc/self/stat");
		std::string procStatLine;
		if (std::getline(procStatFile, procStatLine)) {
			std::istringstream iss(procStatLine);
			std::vector<std::string> stats((std::istream_iterator<std::string>(iss)), {});
			if (stats.size() >= 15) {
				utime = std::stol(stats[13]);
				stime = std::stol(stats[14]);
			}
		}

		if (time_diff > 0 && !firstCall) {
			long total_time = (utime + stime) - (last_utime + last_stime);
			double procCPU = (total_time / (time_diff * sysconf(_SC_CLK_TCK))) * 100.0;
			procCPU = std::min(100.0, std::max(0.0, procCPU));
			double user_percent = (utime - last_utime) * 100.0 / total_time;
			double kernel_percent = (stime - last_stime) * 100.0 / total_time;

			info["cpu"] = {
				{ "usage_percent", procCPU },
				{ "user_time_percent", user_percent },
				{ "kernel_time_percent", kernel_percent }
			};
		}

		last_utime = utime;
		last_stime = stime;
		last_time = current_time;

		std::ifstream sysStatFile("/proc/stat");
		std::string cpuLine;
		if (std::getline(sysStatFile, cpuLine) && cpuLine.starts_with("cpu ")) {
			std::istringstream iss(cpuLine.substr(5));
			u_int64_t user, nice, system, idle, iowait, irq, softirq, steal;
			iss >> user >> nice >> system >> idle >> iowait >> irq >> softirq >> steal;

			u_int64_t total_user = user + nice;
			u_int64_t total_system = system + irq + softirq;
			u_int64_t total_idle = idle + iowait;
			u_int64_t total = total_user + total_system + total_idle + steal;

			static u_int64_t last_user = 0, last_system = 0, last_idle = 0, last_total = 0;

			if (!firstCall) {
				u_int64_t user_diff = total_user - last_user;
				u_int64_t system_diff = total_system - last_system;
				u_int64_t idle_diff = total_idle - last_idle;
				u_int64_t total_diff = total - last_total;

				if (total_diff > 0) {
					double sys_cpu = (user_diff + system_diff) * 100.0 / total_diff;
					double user_percent = user_diff * 100.0 / total_diff;
					double system_percent = system_diff * 100.0 / total_diff;
					double idle_percent = idle_diff * 100.0 / total_diff;

					info["system"]["cpu"] = {
						{ "usage_percent", sys_cpu },
						{ "user_time_percent", user_percent },
						{ "kernel_time_percent", system_percent },
						{ "idle_time_percent", idle_percent },
						{ "name", getCpuName() }
					};
				}
			}

			last_user = total_user;
			last_system = total_system;
			last_idle = total_idle;
			last_total = total;
		}

		struct sysinfo memInfo;
		sysinfo(&memInfo);
		double totalGB = (memInfo.totalram * memInfo.mem_unit) / 1073741824.0;
		double availGB = (memInfo.freeram * memInfo.mem_unit) / 1073741824.0;
		double usage = (totalGB - availGB) * 100.0 / totalGB;
		info["system"]["memory"] = {
			{ "total_gb", totalGB },
			{ "available_gb", availGB },
			{ "usage_percent", usage }
		};

		info["system"]["cpu_cores"] = get_nprocs();
		info["system"]["architecture"] = sizeof(void*) * 8;
		struct utsname unameData;
		uname(&unameData);
		info["system"]["processor"]["type"] = unameData.machine;
#endif
	} catch (const std::exception &e) {
		info["error"] = e.what();
	}

	return info;
}
