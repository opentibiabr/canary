#pragma once

#include <functional>
#include <string>
#include <unordered_map>
#include <optional>
#include "../models/responses.hpp"

class ValidationMiddleware {
public:
	struct context { };

	// Tipo de função para validação personalizada
	using ValidatorFunc = std::function<std::optional<std::string>(const crow::request &)>;

	void before_handle(crow::request &req, crow::response &res, context &) {
		const auto &route = req.url;

		// Verifica se existe um validador para esta rota
		const auto validator = getValidator(route);
		if (!validator) {
			return; // Sem validador, continua normalmente
		}

		// Executa a validação
		const auto error = (*validator)(req);
		if (error) {
			auto response = APIResponse::badRequest(*error);
			res = std::move(response);
			res.end();
		}
	}

	void after_handle(crow::request &, crow::response &, context &) const { }

	// Registra um validador para uma rota específica
	void setValidator(const std::string &route, ValidatorFunc validator) {
		validators[route] = std::move(validator);
	}

private:
	std::unordered_map<std::string, ValidatorFunc> validators;

	std::optional<ValidatorFunc> getValidator(const std::string &route) {
		const auto &it = validators.find(route);
		if (it != validators.end()) {
			return it->second;
		}
		return std::nullopt;
	}
};
