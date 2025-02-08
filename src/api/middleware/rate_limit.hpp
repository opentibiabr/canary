#pragma once

#include "../models/responses.hpp"

class RateLimitMiddleware {
public:
	struct context { };

	struct RateLimit {
		int requests;
		int windowSeconds;
	};

	void before_handle(crow::request &req, crow::response &res, context &) {
		const auto ip = req.remote_ip_address;
		const auto &route = req.url;

		if (isRateLimited(ip, route)) {
			auto response = APIResponse::tooManyRequests(
				"Limite de requisições excedido. Tente novamente em alguns segundos."
			);
			res = std::move(response);
			res.end();
			return;
		}

		recordRequest(ip, route);
	}

	void after_handle(crow::request &, crow::response &, context &) const { }

	// Método para configurar limites específicos por rota
	void setRouteLimit(const std::string &route, int maxRequests, int windowSeconds) {
		std::lock_guard lock(configMtx);
		routeLimits[route] = RateLimit{maxRequests, windowSeconds};
	}

private:
	struct RateInfo {
		std::chrono::system_clock::time_point lastReset;
		std::unordered_map<std::string, int> routeCounts; // Contadores por rota
	};

	// Limites padrão
	static constexpr int DEFAULT_MAX_REQUESTS = 100000000;
	static constexpr int DEFAULT_WINDOW_SECONDS = 60;

	std::mutex mtx;
	std::mutex configMtx;
	std::unordered_map<std::string, RateInfo> ipLimits;
	std::unordered_map<std::string, RateLimit> routeLimits;

	RateLimit getRouteLimit(const std::string &route) {
		std::lock_guard lock(configMtx);
		const auto it = routeLimits.find(route);
		if (it != routeLimits.end()) {
			return it->second;
		}
		return RateLimit{DEFAULT_MAX_REQUESTS, DEFAULT_WINDOW_SECONDS};
	}

	bool isRateLimited(const std::string &ip, const std::string &route) {
		std::lock_guard lock(mtx);

		const auto now = std::chrono::system_clock::now();
		const auto it = ipLimits.find(ip);

		if (it == ipLimits.end()) {
			return false;
		}

		auto &info = it->second;
		const auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(
			now - info.lastReset
		).count();

		auto [requests, windowSeconds] = getRouteLimit(route);

		if (elapsed >= windowSeconds) {
			info = RateInfo { now, {} };
			return false;
		}

		const auto routeCount = info.routeCounts[route];
		return routeCount >= requests;
	}

	void recordRequest(const std::string &ip, const std::string &route) {
		std::lock_guard<std::mutex> lock(mtx);

		const auto now = std::chrono::system_clock::now();
		auto &info = ipLimits[ip];

		auto [requests, windowSeconds] = getRouteLimit(route);
		const auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(
			now - info.lastReset
		).count();

		if (elapsed >= windowSeconds) {
			info = RateInfo{now, {}};
		}
		
		info.routeCounts[route]++;
	}
};
