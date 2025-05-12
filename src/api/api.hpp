#pragma once

#include <crow.h>
#include <crow/middlewares/cors.h>
#include "middleware/auth.hpp"
#include "middleware/logging.hpp"
#include "middleware/rate_limit.hpp"
#include "middleware/validation.hpp"
#include "middleware/security.hpp"

class ThreadPool;

struct VersionInfo {
    std::string version;
    std::string url;
    std::string changelog;
    bool required;
};

class APIServer {
public:
    explicit APIServer(ThreadPool &threadPool);

    ~APIServer() = default;
    APIServer(const APIServer &) = delete;
    APIServer &operator=(const APIServer &) = delete;

    static APIServer &getInstance();

    void initialize(uint16_t port = 8081);
    void start();
    void stop();

private:
    crow::App<
        crow::CORSHandler,
        SecurityMiddleware,
        AuthMiddleware,
        LoggingMiddleware,
        RateLimitMiddleware,
        ValidationMiddleware>
        app {};

	ThreadPool &threadPool;
    std::atomic<bool> running{false};
    static std::mutex shutdownMutex;

    void setupRoutes();
    void setupWebSocket();
    void setupValidators();
	[[nodiscard]] static bool isNewerVersion(const std::string &current, const std::string &new_version) ;
	static std::map<std::string, std::vector<VersionInfo>> availableVersions;
};

constexpr auto g_api = APIServer::getInstance;
