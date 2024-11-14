/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/libs/metrics_functions.hpp"
#include "lib/metrics/metrics.hpp"

void MetricsFunctions::init(lua_State* L) {
	registerTable(L, "metrics");
	registerMethod(L, "metrics", "addCounter", MetricsFunctions::luaMetricsAddCounter);
}

// Metrics
int MetricsFunctions::luaMetricsAddCounter(lua_State* L) {
	// metrics.addCounter(name, value, attributes)
	auto name = getString(L, 1);
	auto value = getNumber<double>(L, 2);
	auto attributes = getAttributes(L, 3);
	g_metrics().addCounter(name, value, attributes);
	return 1;
}

std::map<std::string, std::string> MetricsFunctions::getAttributes(lua_State* L, int32_t index) {
	std::map<std::string, std::string> attributes;
	if (isTable(L, index)) {
		lua_pushnil(L);
		while (lua_next(L, index) != 0) {
			attributes[getString(L, -2)] = getString(L, -1);
			lua_pop(L, 1);
		}
	}
	return attributes;
}
