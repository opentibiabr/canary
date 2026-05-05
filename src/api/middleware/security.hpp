#pragma once

#include <crow.h>
#include <algorithm>
#include <array>
#include <cctype>
#include <regex>
#include <string>
#include <string_view>
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

	// Defense-in-depth filter for XSS-shaped payloads. The API itself returns JSON, but
	// downstream consumers (e.g. an admin web panel) may render fields as HTML, so we
	// reject obviously hostile inputs at the boundary.
	//
	// Cheap substrings are matched case-insensitively without regex; only the <script>
	// pair, which needs grouping, uses a single statically-compiled std::regex.
	bool sanitizeInput(const crow::request &req) const {
		try {
			static const std::regex scriptTagRe(R"(<script[^>]*>.*?</script>)", std::regex::icase | std::regex::optimize);
			static constexpr std::array<std::string_view, 4> substrPatterns {
				"javascript:",
				"onload=",
				"onerror=",
				"onclick=",
			};

			const auto containsHostile = [](const std::string &input) {
				if (input.empty()) {
					return false;
				}
				for (const auto pat : substrPatterns) {
					if (containsCaseInsensitive(input, pat)) {
						return true;
					}
				}
				return std::regex_search(input, scriptTagRe);
			};

			if (req.method == crow::HTTPMethod::Post || req.method == crow::HTTPMethod::Put) {
				if (containsHostile(req.body)) {
					return false;
				}
			}

			for (const auto &param : req.url_params.keys()) {
				const std::string &value = req.url_params.get(param);
				if (containsHostile(value)) {
					return false;
				}
			}

			return true;
		} catch (const std::exception &) {
			return false;
		}
	}

	static bool containsCaseInsensitive(const std::string &haystack, std::string_view needle) {
		if (needle.size() > haystack.size()) {
			return false;
		}
		const auto it = std::search(
			haystack.begin(), haystack.end(),
			needle.begin(), needle.end(),
			[](unsigned char a, unsigned char b) { return std::tolower(a) == std::tolower(b); }
		);
		return it != haystack.end();
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
