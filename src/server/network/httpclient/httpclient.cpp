/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "server/network/httpclient/httpclient.hpp"
#include "server/network/httpclient/httpclientlib.h"
#include "game/scheduling/dispatcher.hpp"
#include "lib/thread/thread_pool.hpp"
#include "lib/di/container.hpp"

//#include "tasks.h"
//extern Dispatcher g_dispatcher;

HttpClient::HttpClient(ThreadPool& threadPool) :
	threadPool(threadPool) {

	requestsHandler = new HttpClientLib::Request(
			[this](const HttpClientLib::HttpResponse_ptr &response) { clientRequestSuccessCallback(response); },
			[this](const HttpClientLib::HttpResponse_ptr &response) { clientRequestFailureCallback(response); });
}

HttpClient::~HttpClient() {
	delete requestsHandler;
}

HttpClient& HttpClient::getInstance() {
	return inject<HttpClient>();
}

void HttpClient::clientRequestSuccessCallback(const HttpClientLib::HttpResponse_ptr &response)
{
	// std::cout << std::string("HTTP Response received: " +
	// std::to_string(response->statusCode) + " (" +
	// std::to_string(response->responseTimeMs) + "ms) id " +
	// std::to_string(response->requestId)) << std::endl;
	addResponse(response);

	//std::string headerStr(reinterpret_cast<char *>(response->headerData.data()), response->headerData.size());
	//std::string bodyStr(reinterpret_cast<char *>(response->bodyData.data()), response->bodyData.size());

	// Print the string to the console
	// std::cout << headerStr << std::endl;
	// std::cout << bodyStr << std::endl;
}

void HttpClient::clientRequestFailureCallback(const HttpClientLib::HttpResponse_ptr &response)
{
	std::cout << std::string("HTTP Response failed (" + response->errorMessage + ")") << std::endl;
	addResponse(response);
}

void HttpClient::luaClientRequestCallback(LuaScriptInterface *scriptInterface, HttpClientLib::HttpRequestCallbackData &callbackData)
{
	lua_State *luaState = scriptInterface->getLuaState();
	if (!luaState) {
		return;
	}

	int32_t callbackId = callbackData.callbackId;
	if (callbackId > 0) {
		callbackData.callbackFunction = [callbackId, scriptInterface](const HttpClientLib::HttpResponse_ptr &response) {
			lua_State *luaState = scriptInterface->getLuaState();
			if (!luaState) {
				return;
			}

			if (!LuaScriptInterface::reserveScriptEnv()) {
				luaL_unref(luaState, LUA_REGISTRYINDEX, callbackId);
				std::cout << "[Error - HttpClient::luaClientRequestCallback] Call stack overflow" << std::endl;
				return;
			}

			// push function
			lua_rawgeti(luaState, LUA_REGISTRYINDEX, callbackId);

			// push parameters
			lua_createtable(luaState, 0, 11);

			LuaScriptInterface::setField(luaState, "requestId", response->requestId);
			LuaScriptInterface::setField(luaState, "version", response->version);
			LuaScriptInterface::setField(luaState, "statusCode", response->statusCode);
			LuaScriptInterface::setField(luaState, "location", response->location);
			LuaScriptInterface::setField(luaState, "contentType", response->contentType);
			LuaScriptInterface::setField(luaState, "responseTimeMs", response->responseTimeMs);
			LuaScriptInterface::setField(luaState, "headerData", response->headerData);
			LuaScriptInterface::setField(luaState, "bodySize", response->bodySize);
			LuaScriptInterface::setField(luaState, "bodyData", response->bodyData);
			LuaScriptInterface::setField(luaState, "success", response->success);
			LuaScriptInterface::setField(luaState, "errorMessage", response->errorMessage);

			LuaScriptInterface::setMetatable(luaState, -1, "HttpResponse");

			int parameter = luaL_ref(luaState, LUA_REGISTRYINDEX);
			lua_rawgeti(luaState, LUA_REGISTRYINDEX, parameter);

			ScriptEnvironment *env = scriptInterface->getScriptEnv();
			auto scriptId = env->getScriptId();
			env->setScriptId(scriptId, scriptInterface);

			scriptInterface->callFunction(1); // callFunction already reset the reserved
			                                  // script env (resetScriptEnv)

			// free resources
			luaL_unref(luaState, LUA_REGISTRYINDEX, callbackId);
			luaL_unref(luaState, LUA_REGISTRYINDEX, parameter);
		};
	}
}

void HttpClient::addResponse(const HttpClientLib::HttpResponse_ptr& response)
{
	threadPool.addLoad([this, response]() {
		const auto httpRequestIt = this->requests.find(response->requestId);
		if (httpRequestIt == this->requests.end()) {
			return;
		}

		const HttpClientLib::HttpRequest_ptr& httpRequest = httpRequestIt->second;

		if (httpRequest->callbackData.isLuaCallback()) {
			luaClientRequestCallback(httpRequest->callbackData.scriptInterface, httpRequest->callbackData);
		}

		if (httpRequest->callbackData.callbackFunction) {
			g_dispatcher().addEvent([httpRequest, response]() { httpRequest->callbackData.callbackFunction(response); }, "HttpClient::processResponse");
		}

		this->requests.erase(response->requestId);
	});
}

void HttpClient::addRequest(const HttpClientLib::HttpRequest_ptr &request)
{
	threadPool.addLoad([this, request]() {

		if (!requestsHandler) {
			return;
		}

		bool succesfullyDispatched = false;
		switch (request->method) {
		case HttpClientLib::HttpMethod::HTTP_CONNECT:
			requestsHandler->setTimeout(request->timeout);
			succesfullyDispatched = requestsHandler->connect(request->url, request->fields);
			break;

		case HttpClientLib::HttpMethod::HTTP_TRACE:
			requestsHandler->setTimeout(request->timeout);
			succesfullyDispatched = requestsHandler->trace(request->url, request->fields);
			break;

		case HttpClientLib::HttpMethod::HTTP_OPTIONS:
			requestsHandler->setTimeout(request->timeout);
			succesfullyDispatched = requestsHandler->options(request->url, request->fields);
			break;

		case HttpClientLib::HttpMethod::HTTP_HEAD:
			requestsHandler->setTimeout(request->timeout);
			succesfullyDispatched = requestsHandler->head(request->url, request->fields);
			break;

		case HttpClientLib::HttpMethod::HTTP_DELETE:
			requestsHandler->setTimeout(request->timeout);
			succesfullyDispatched = requestsHandler->delete_(request->url, request->fields);
			break;

		case HttpClientLib::HttpMethod::HTTP_GET:
			requestsHandler->setTimeout(request->timeout);
			succesfullyDispatched = requestsHandler->get(request->url, request->fields);
			break;

		case HttpClientLib::HttpMethod::HTTP_POST:
			requestsHandler->setTimeout(request->timeout);
			succesfullyDispatched = requestsHandler->post(request->url, request->data, request->fields);
			break;

		case HttpClientLib::HttpMethod::HTTP_PATCH:
			requestsHandler->setTimeout(request->timeout);
			succesfullyDispatched = requestsHandler->patch(request->url, request->data, request->fields);
			break;

		case HttpClientLib::HttpMethod::HTTP_PUT:
			requestsHandler->setTimeout(request->timeout);
			succesfullyDispatched = requestsHandler->put(request->url, request->data, request->fields);
			break;

		case HttpClientLib::HttpMethod::HTTP_NONE:
		default:
			break;
		}

		if (request->method != HttpClientLib::HTTP_NONE && succesfullyDispatched) {
			requests.emplace(std::make_pair(requestsHandler->getRequestId(), std::move(request)));
		}
	});
}

