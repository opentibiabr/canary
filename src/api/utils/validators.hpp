#pragma once

namespace Validators {
	// Função para decodificar URL
	inline std::string urlDecode(const std::string &encoded) {
		std::string decoded;
		decoded.reserve(encoded.length());

		for (size_t i = 0; i < encoded.length(); ++i) {
			if (encoded[i] == '%' && i + 2 < encoded.length()) {
				int value;
				std::sscanf(encoded.substr(i + 1, 2).c_str(), "%x", &value);
				decoded += static_cast<char>(value);
				i += 2;
			} else if (encoded[i] == '+') {
				decoded += ' ';
			} else {
				decoded += encoded[i];
			}
		}

		return decoded;
	}

	// Verifica se o corpo da requisição é um JSON válido
	[[nodiscard]] inline std::optional<std::string> validateJson(const crow::request &req) {
		try {
			auto json = nlohmann::json::parse(req.body);
			return std::nullopt;
		} catch (const nlohmann::json::parse_error &e) {
			return "JSON inválido: " + std::string(e.what());
		}
	}

	// Verifica se um campo específico existe no JSON
	[[nodiscard]] inline std::optional<std::string> validateJsonField(const crow::request &req, const std::string &field) {
		try {
			const auto json = nlohmann::json::parse(req.body);
			if (!json.contains(field)) {
				return "Campo obrigatório ausente: " + field;
			}
			return std::nullopt;
		} catch (const nlohmann::json::parse_error &e) {
			return "JSON inválido: " + std::string(e.what());
		}
	}

	// Valida o formato de nome do jogador
	[[nodiscard]] inline std::optional<std::string> validatePlayerName(const std::string &encodedName) {
		try {
			const std::string name = urlDecode(encodedName);

			if (name.empty()) {
				return "Nome do jogador não pode estar vazio";
			}
			if (name.length() < 3 || name.length() > 20) {
				return "Nome do jogador deve ter entre 3 e 20 caracteres";
			}

			// Verifica caracteres válidos (letras, espaços e hífens)
			for (const char c : name) {
				if (!std::isalpha(c) && c != ' ' && c != '-') {
					return "Nome do jogador contém caracteres inválidos";
				}
			}
			return std::nullopt;
		} catch (const std::exception &e) {
			return "Erro ao validar nome do jogador: " + std::string(e.what());
		}
	}

	// Valida o ID do jogador
	[[nodiscard]] inline std::optional<std::string> validatePlayerId(const std::string &id) {
		try {
			const auto numId = std::stoi(id);
			if (numId <= 0) {
				return "ID do jogador deve ser positivo";
			}
			return std::nullopt;
		} catch (...) {
			return "ID do jogador inválido";
		}
	}

	// Valida parâmetros de paginação
	[[nodiscard]] inline std::optional<std::string> validatePagination(const crow::request &req) {
		try {
			const auto page = req.url_params.get("page");
			const auto limit = req.url_params.get("limit");

			if (page) {
				const auto pageNum = std::stoi(page);
				if (pageNum < 1) {
					return "Número da página deve ser maior que zero";
				}
			}

			if (limit) {
				const auto limitNum = std::stoi(limit);
				if (limitNum < 1 || limitNum > 100) {
					return "Limite deve estar entre 1 e 100";
				}
			}

			return std::nullopt;
		} catch (...) {
			return "Parâmetros de paginação inválidos";
		}
	}
}
