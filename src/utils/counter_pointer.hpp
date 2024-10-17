/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class SharedPtrManager {
public:
	SharedPtrManager() = default;
	~SharedPtrManager() = default;

	// Singleton - ensures we don't accidentally copy it.
	SharedPtrManager(const SharedPtrManager &) = delete;
	SharedPtrManager &operator=(const SharedPtrManager &) = delete;

	static SharedPtrManager &getInstance();

	template <typename T>
	void store(const std::string &name, const std::shared_ptr<T> &ptr) {
		m_sharedPtrMap[name] = ptr;
	}

	void countAllReferencesAndClean();

private:
	std::unordered_map<std::string, std::weak_ptr<void>> m_sharedPtrMap;
};

constexpr auto g_counterPointer = SharedPtrManager::getInstance;
