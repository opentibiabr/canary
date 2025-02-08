#pragma once


using json = nlohmann::json;

class APIResponse {
public:
	static crow::response ok(const json &dados, const std::string &mensagem = "") {
		json response = {
			{ "sucesso", true },
			{ "dados", dados }
		};

		if (!mensagem.empty()) {
			response["mensagem"] = mensagem;
		}

		auto resp = crow::response(200, response.dump());
		resp.set_header("Content-Type", "application/json");
		return resp;
	}

	static crow::response erro(int codigo, const std::string &mensagem, const json &detalhes = nullptr) {
		json response = {
			{ "sucesso", false },
			{ "mensagem", mensagem }
		};

		if (detalhes != nullptr) {
			response["detalhes"] = detalhes;
		}

		auto resp = crow::response(codigo, response.dump());
		resp.set_header("Content-Type", "application/json");
		return resp;
	}

	// Respostas comuns
	static crow::response badRequest(const std::string &mensagem = "Requisição inválida") {
		return erro(400, mensagem);
	}

	static crow::response unauthorized(const std::string &mensagem = "Não autorizado") {
		return erro(401, mensagem);
	}

	static crow::response forbidden(const std::string &mensagem = "Acesso negado") {
		return erro(403, mensagem);
	}

	static crow::response notFound(const std::string &mensagem = "Recurso não encontrado") {
		return erro(404, mensagem);
	}

	static crow::response tooManyRequests(const std::string &mensagem = "Muitas requisições") {
		return erro(429, mensagem);
	}

	static crow::response internalError(const std::string &mensagem = "Erro interno do servidor") {
		return erro(500, mensagem);
	}
};
