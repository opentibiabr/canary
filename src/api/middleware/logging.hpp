#pragma once

class LoggingMiddleware {
public:
	struct context {
		std::chrono::system_clock::time_point start_time;
		std::string request_id;
	};

	void before_handle(crow::request &req, crow::response &res, context &ctx) const {
		ctx.start_time = std::chrono::system_clock::now();
		ctx.request_id = generateRequestId();

		// Convertendo HTTPMethod para string antes de formatar
		std::string method = method_name(req.method);

		// Log inicial da requisição
		g_logger().debug("[{}] Iniciando {} {} de {}", ctx.request_id, method, req.url, req.remote_ip_address);

		// Log do corpo da requisição se presente
		if (!req.body.empty()) {
			g_logger().debug("[{}] Corpo da requisição: {}", ctx.request_id, req.body.length() > 1000 ? req.body.substr(0, 1000) + "..." : req.body);
		}
	}

	void after_handle(crow::request &req, crow::response &res, context &ctx) const {
		const auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(
			std::chrono::system_clock::now() - ctx.start_time
		);

		// Convertendo HTTPMethod para string antes de formatar
		std::string method = crow::method_name(req.method);

		// Log do resultado da requisição
		g_logger().debug("[{}] Completado {} {} - Status: {} - Duração: {}ms", ctx.request_id, method, req.url, res.code, duration.count());

		// Log detalhado em caso de erro
		if (res.code >= 400) {
			g_logger().warn("[{}] Erro na requisição: Status {} - Corpo: {}", ctx.request_id, res.code, res.body);
		}
	}

private:
	std::string generateRequestId() const {
		static std::atomic<uint64_t> counter { 0 };
		std::stringstream ss;
		ss << std::hex << std::chrono::system_clock::now().time_since_epoch().count()
		   << "-" << counter++;
		return ss.str();
	}
};
