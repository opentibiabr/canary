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

// Defines a concept to ensure the function only accepts containers of numbers
template <typename T>
concept NumberContainer = requires(T a) {
	typename T::value_type;
	requires std::integral<typename T::value_type> || std::floating_point<typename T::value_type>;
};

// Function that calculates the average of a container of numbers
auto calculateAverage(const NumberContainer auto &container) {
	// Uses ranges and std::views to process the container
	return std::accumulate(container.begin(), container.end(), 0.0) / std::ranges::distance(container);
}

int main() {
	std::vector<int> numbers = { 1, 2, 3, 4, 5 };

	// Calculates the average using the function with support for C++23
	double average = calculateAverage(numbers);

	g_logger().trace("Average: {}", average);

	return inject<CanaryServer>().run();
}
