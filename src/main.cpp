/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "canary_server.hpp"
#include "lib/di/container.hpp"
// Define um conceito para garantir que a função só aceite contêineres de números
template <typename T>
concept NumberContainer = requires(T a) {
	typename T::value_type;
	requires std::integral<typename T::value_type> || std::floating_point<typename T::value_type>;
};

// Função que calcula a média de um contêiner de números
auto calculateAverage(const NumberContainer auto &container) {
	// Utiliza ranges e std::views para processar o contêiner
	return std::accumulate(container.begin(), container.end(), 0.0) / std::ranges::distance(container);
}

int main() {
	std::vector<int> numbers = { 1, 2, 3, 4, 5 };

	// Calcula a média usando a função com suporte a C++23
	double average = calculateAverage(numbers);

	std::cout << "Average: " << average << std::endl;

	return inject<CanaryServer>().run();
}
