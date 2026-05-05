#pragma once

#include "../models/responses.hpp"
#include "config/configmanager.hpp"
#include <jwt-cpp/jwt.h>

class AuthMiddleware {
public:
	struct context {
		uint32_t accountId = 0;
		uint8_t accountType = 0;
	};

	void before_handle(crow::request &req, crow::response &res, context &ctx) const {
		if (req.url == "/api/v1/login") {
			return;
		}

		std::string token = req.get_header_value("Authorization");
		if (token.starts_with("Bearer ")) {
			token = token.substr(7);
		}
		if (token.empty()) {
			res = APIResponse::unauthorized("Token de autorização não fornecido");
			res.end();
			return;
		}

		try {
			const auto decoded = jwt::decode(token);
			jwt::verify()
				.allow_algorithm(jwt::algorithm::hs256 { secret() })
				.with_issuer("canary-api")
				.with_audience("canary-client")
				.verify(decoded);

			ctx.accountId = static_cast<uint32_t>(std::stoul(decoded.get_subject()));
			if (decoded.has_payload_claim("acc_type")) {
				ctx.accountType = static_cast<uint8_t>(decoded.get_payload_claim("acc_type").as_int());
			}
		} catch (const std::exception &) {
			res = APIResponse::unauthorized("Token inválido ou expirado");
			res.end();
			return;
		}

		if (requiresAdmin(req.url, req.method) && ctx.accountType < minAdminType()) {
			res = APIResponse::forbidden("Permissão insuficiente para esta operação");
			res.end();
		}
	}

	void after_handle(crow::request &, crow::response &, context &) const { }

	static std::string generateToken(uint32_t accountId, uint8_t accountType) {
		return jwt::create()
			.set_issuer("canary-api")
			.set_audience("canary-client")
			.set_subject(std::to_string(accountId))
			.set_payload_claim("acc_type", jwt::claim(picojson::value(static_cast<int64_t>(accountType))))
			.set_issued_at(std::chrono::system_clock::now())
			.set_expires_at(std::chrono::system_clock::now() + std::chrono::hours(1))
			.sign(jwt::algorithm::hs256 { secret() });
	}

	static const std::string &secret() {
		static const std::string s = g_configManager().getString(API_JWT_SECRET);
		return s;
	}

private:
	static uint8_t minAdminType() {
		return static_cast<uint8_t>(g_configManager().getNumber(API_MIN_ADMIN_TYPE));
	}

	static bool requiresAdmin(const std::string &url, const crow::HTTPMethod method) {
		if (method == "GET"_method) {
			return false;
		}
		// Any non-GET on /api/v1/server/* or /api/v1/players/* (kick, ban, state, broadcast)
		return url.starts_with("/api/v1/server/") || url.starts_with("/api/v1/players/");
	}
};
