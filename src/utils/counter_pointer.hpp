#pragma once

#include <iostream>
#include <memory>
#include <unordered_map>
#include <string>
#include "lib/di/container.hpp"

class SharedPtrManager {
public:
	SharedPtrManager() = default;
	~SharedPtrManager() = default;

	// Singleton - ensures we don't accidentally copy it.
	SharedPtrManager(const SharedPtrManager &) = delete;
	SharedPtrManager &operator=(const SharedPtrManager &) = delete;

	static SharedPtrManager &getInstance() {
		return inject<SharedPtrManager>();
	}

	// Função para armazenar o shared_ptr
	template <typename T>
	void store(const std::string &name, const std::shared_ptr<T> &ptr) {
		sharedPtrMap[name] = ptr;
	}

	// Função para contar as referências de todos os shared_ptr armazenados e limpar os destruídos
	void countAllReferencesAndClean() {
		for (auto it = sharedPtrMap.begin(); it != sharedPtrMap.end();) {
			const auto &sptr = it->second.lock();
			if (sptr) {
				std::cout << "Contagem de referências do shared_ptr (" << it->first << "): "
						  << sptr.use_count() << std::endl;
				++it;
			} else {
				std::cout << "Objeto " << it->first << " foi destruído e será removido do mapa." << std::endl;
				it = sharedPtrMap.erase(it); // Remove o item do mapa e avança o iterador
			}
		}
	}

private:
	std::unordered_map<std::string, std::weak_ptr<void>> sharedPtrMap;
};

constexpr auto g_beats = SharedPtrManager::getInstance;
