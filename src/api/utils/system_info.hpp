#pragma once

class SystemInfo {
public:
	static nlohmann::json getSystemResources();

private:
	static constexpr size_t PROCESS_AVERAGE_WINDOW = 3;
	static constexpr size_t SYSTEM_AVERAGE_WINDOW = 3;
	static std::deque<double> cpuHistory;
	static std::deque<double> systemCpuHistory;
	#ifdef _WIN32
	static ULARGE_INTEGER lastSystemKernel, lastSystemUser, lastSystemIdle;
	#endif
	static std::string getCpuName();
	static bool firstCall;

	
};
