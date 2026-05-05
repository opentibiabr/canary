#pragma once

#include <crow.h>
#include <string>
#include <regex>
#include <unordered_set>
#include "../models/responses.hpp"

class SecurityMiddleware {
public:
	struct context { };

	void before_handle(crow::request &req, crow::response &res, context &) const {
		try {
			addSecurityHeaders(res);

			// CSRF protection is unnecessary here: this API uses Bearer tokens, which are
			// not sent automatically by browsers. SameSite-cookie attacks don't apply.

			if (!sanitizeInput(req)) {
				res = APIResponse::badRequest("Dados de entrada contêm caracteres não permitidos");
				return;
			}

			if (!validateContentType(req)) {
				res = APIResponse::badRequest("Content-Type inválido");
			}
		} catch (const std::exception &e) {
			res = APIResponse::internalError("Erro ao processar requisição: " + std::string(e.what()));
		}
	}

	void after_handle(crow::request &, crow::response &res, context &) const {
		try {
			// Garante que os headers de segurança estejam presentes
			addSecurityHeaders(res);
		} catch (const std::exception &e) {
			// Log do erro, mas não modifica a resposta aqui
		}
	}

private:
	void addSecurityHeaders(crow::response &res) const {
		// Previne clickjacking
		res.add_header("X-Frame-Options", "DENY");

		// Habilita proteção XSS no navegador
		res.add_header("X-XSS-Protection", "1; mode=block");

		// Previne MIME sniffing
		res.add_header("X-Content-Type-Options", "nosniff");

		// Content Security Policy mais permissiva para desenvolvimento
		res.add_header("Content-Security-Policy", "default-src 'self' *; "
		                                          "script-src 'self' 'unsafe-inline' 'unsafe-eval'; "
		                                          "style-src 'self' 'unsafe-inline'; "
		                                          "img-src 'self' data: *; "
		                                          "connect-src 'self' * ws: wss:;");

		// Referrer Policy
		res.add_header("Referrer-Policy", "strict-origin-when-cross-origin");
	}

	bool sanitizeInput(const crow::request &req) const {
		try {
			// Lista de caracteres e padrões maliciosos
			static const std::vector<std::string> xssPatterns = {
				"<script[^>]*>.*?</script>",
				"javascript:",
				"onload=",
				"onerror=",
				"onclick="
			};

			// Verifica o body se for POST/PUT
			if (req.method == crow::HTTPMethod::Post || req.method == crow::HTTPMethod::Put) {
				const std::string &body = req.body;
				for (const auto &pattern : xssPatterns) {
					if (std::regex_search(body, std::regex(pattern, std::regex::icase))) {
						return false;
					}
				}
			}

			// Verifica parâmetros da URL
			for (const auto &param : req.url_params.keys()) {
				const std::string &value = req.url_params.get(param);
				for (const auto &pattern : xssPatterns) {
					if (std::regex_search(value, std::regex(pattern, std::regex::icase))) {
						return false;
					}
				}
			}

			return true;
		} catch (const std::exception &) {
			return false;
		}
	}

	bool validateContentType(const crow::request &req) const {
		if (req.method != crow::HTTPMethod::Post && req.method != crow::HTTPMethod::Put) {
			return true;
		}

		const auto contentType = req.get_header_value("Content-Type");
		if (contentType.empty()) {
			return false;
		}

		// Extrai o tipo base do Content-Type (antes do ;)
		std::string baseType = contentType;
		const size_t pos = baseType.find(';');
		if (pos != std::string::npos) {
			baseType = baseType.substr(0, pos);
		}

		// Remove espaços em branco
		baseType.erase(0, baseType.find_first_not_of(" \t"));
		baseType.erase(baseType.find_last_not_of(" \t") + 1);

		static const std::unordered_set<std::string> allowedTypes = {
			"application/json",
			"application/x-www-form-urlencoded",
			"multipart/form-data"
		};

		return allowedTypes.contains(baseType);
	}
};
