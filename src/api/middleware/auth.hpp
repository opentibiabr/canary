#pragma once

#include "../models/responses.hpp"
#include <jwt-cpp/jwt.h>

class AuthMiddleware {
public:
	struct context { };

	void before_handle(crow::request &req, crow::response &res, context &) const {
		// Ignorar a verificação de token para o endpoint de login
		if (req.url == "/api/v1/login") {
			return;
		}

		auto token = req.get_header_value("Authorization");

		if (token.empty()) {
			auto response = APIResponse::unauthorized("Token de autorização não fornecido");
			res = std::move(response);
			res.end();
			return;
		}

		// Remove o prefixo "Bearer " se presente
		if (token.substr(0, 7) == "Bearer ") {
			token = token.substr(7);
		}

		if (!validateToken(token)) {
			auto response = APIResponse::unauthorized("Token inválido ou expirado");
			res = std::move(response);
			res.end();
		}
	}

	void after_handle(crow::request &, crow::response &, context &) const { }

private:
	bool validateToken(const std::string &token) const {
		try {
			const std::string key = "3x@mpl3S3cr3tK3y!Th1sIsS3cur3"; // Chave secreta
			const auto decoded = jwt::decode(token);

			// Verificação do token
			jwt::verify()
				.allow_algorithm(jwt::algorithm::hs256 { key })
				.with_issuer("meu_issuer") // Verifica se o emissor é válido
				.with_audience("meu_audience") // Verifica se o público é válido
				.with_subject(decoded.get_subject()) // Verifica se o subject é igual ao esperado
				.verify(decoded);

			return true; // Retornar verdadeiro se o token for válido
		} catch (const std::exception &e) {
			return false; // Retornar falso se houver qualquer erro na validação
		}
	}

	static std::string generateToken(const std::string &username) {
		const std::string key = "3x@mpl3S3cr3tK3y!Th1sIsS3cur3"; // Chave secreta
		auto token = jwt::create()
						 .set_issuer("meu_issuer") // O mesmo emissor
						 .set_audience("meu_audience") // O mesmo público
						 .set_subject(username)
						 .set_expires_at(std::chrono::system_clock::now() + std::chrono::hours(1))
						 .sign(jwt::algorithm::hs256 { key });

		return token;
	}

	friend class APIServer;
};
