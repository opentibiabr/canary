// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found
// in the LICENSE file.

#ifndef HTTPCLIENT_H
#define HTTPCLIENT_H

#include "lua/functions/core/network/httpclient_functions.hpp"
#include "lib/thread/thread_pool.hpp"

namespace HttpClientLib {
class Request;
class HttpResponse;
using HttpResponse_ptr = std::shared_ptr<HttpResponse>;

enum HttpMethod
{
	HTTP_NONE,
	HTTP_CONNECT,
	HTTP_TRACE,
	HTTP_OPTIONS,
	HTTP_HEAD,
	HTTP_DELETE,
	HTTP_GET,
	HTTP_POST,
	HTTP_PATCH,
	HTTP_PUT
};

class HttpRequestCallbackData
{
public:
	std::function<void(const HttpResponse_ptr &)> callbackFunction;
	int32_t scriptId = -1;
	int32_t callbackId = -1;
	LuaScriptInterface *scriptInterface;

	bool isLuaCallback() { return scriptId != -1 && callbackId != -1; }
};

class HttpRequest
{
public:
	HttpMethod method;
	std::string url;
	std::string data;
	std::unordered_map<std::string, std::string> fields;

	uint32_t timeout = 0;
	HttpRequestCallbackData callbackData;

	HttpRequest() {}
};

using HttpRequest_ptr = std::shared_ptr<HttpRequest>;
} // namespace HttpClientLib

class HttpClient
{
public:
	HttpClient(ThreadPool& threadPool);
	void threadMain();
	void shutdown();

	void addRequest(const HttpClientLib::HttpRequest_ptr &request);

	static HttpClient& getInstance();

private:
	void clientRequestSuccessCallback(const HttpClientLib::HttpResponse_ptr &response);
	void luaClientRequestCallback(LuaScriptInterface *scriptInterface, HttpClientLib::HttpRequestCallbackData &callbackData);

	void clientRequestFailureCallback(const HttpClientLib::HttpResponse_ptr &response);

	void dispatchRequest(HttpClientLib::Request &requestsHandler, HttpClientLib::HttpRequest_ptr &request);
	void processResponse(const HttpClientLib::HttpResponse_ptr &response);

	void addResponse(const HttpClientLib::HttpResponse_ptr &response);

	std::list<HttpClientLib::HttpRequest_ptr> pendingRequests;
	std::list<HttpClientLib::HttpResponse_ptr> pendingResponses;

	std::mutex requestLock;
	std::condition_variable requestSignal;

	std::map<uint32_t, HttpClientLib::HttpRequest_ptr> requests;

	ThreadPool& threadPool;
};

constexpr auto g_http = HttpClient::getInstance;

#endif
