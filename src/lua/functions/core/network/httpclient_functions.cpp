/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/functions/core/network/httpclient_functions.hpp"
#include "server/network/httpclient/httpclient.hpp"


// HttpClient
int HttpClientFunctions::luaCreateHttpClientRequest(lua_State* L)
{
	// HttpClientRequest()
	HttpClientLib::HttpRequest_ptr httpRequest = std::make_shared<HttpClientLib::HttpRequest>();

	httpRequest->callbackData.scriptInterface = getScriptEnv()->getScriptInterface();
	//pushUserData<HttpClientLib::HttpRequest>(L, httpRequest);
	pushSharedPtr(L, httpRequest);
	setMetatable(L, -1, "HttpClientRequest");
	return 1;
}

int HttpClientFunctions::luaDeleteHttpClientRequest(lua_State* L)
{
	HttpClientLib::HttpRequest_ptr httpRequest = getUserdataShared<HttpClientLib::HttpRequest>(L, 1);

	if (httpRequest) {
		httpRequest.reset();
	}
	return 0;
}

int HttpClientFunctions::luaHttpClientRequestSetTimeout(lua_State* L)
{
	HttpClientLib::HttpRequest_ptr httpRequest = getUserdataShared<HttpClientLib::HttpRequest>(L, 1);

	if (!httpRequest) {
		lua_pushnil(L);
		return 1;
	}

	httpRequest->timeout = getNumber<uint32_t>(L, -1);

	pushBoolean(L, true);
	return 1;
}

int HttpClientFunctions::luaHttpClientRequestConnect(lua_State* L)
{
	HttpClientLib::HttpRequest_ptr httpRequest = getUserdataShared<HttpClientLib::HttpRequest>(L, 1);

	if (!httpRequest) {
		lua_pushnil(L);
		return 1;
	}

	luaHttpClientBuildRequest(L, httpRequest);
	httpRequest->method = HttpClientLib::HTTP_CONNECT;

	g_http().addRequest(httpRequest);

	pushBoolean(L, true);
	return 1;
}

int HttpClientFunctions::luaHttpClientRequestTrace(lua_State* L)
{
	HttpClientLib::HttpRequest_ptr httpRequest = getUserdataShared<HttpClientLib::HttpRequest>(L, 1);

	if (!httpRequest) {
		lua_pushnil(L);
		return 1;
	}

	luaHttpClientBuildRequest(L, httpRequest);
	httpRequest->method = HttpClientLib::HTTP_TRACE;

	g_http().addRequest(httpRequest);

	pushBoolean(L, true);
	return 1;
}

int HttpClientFunctions::luaHttpClientRequestOptions(lua_State* L)
{
	HttpClientLib::HttpRequest_ptr httpRequest = getUserdataShared<HttpClientLib::HttpRequest>(L, 1);

	if (!httpRequest) {
		lua_pushnil(L);
		return 1;
	}

	luaHttpClientBuildRequest(L, httpRequest);
	httpRequest->method = HttpClientLib::HTTP_OPTIONS;

	g_http().addRequest(httpRequest);

	pushBoolean(L, true);
	return 1;
}

int HttpClientFunctions::luaHttpClientRequestHead(lua_State* L)
{
	HttpClientLib::HttpRequest_ptr httpRequest = getUserdataShared<HttpClientLib::HttpRequest>(L, 1);

	if (!httpRequest) {
		lua_pushnil(L);
		return 1;
	}

	luaHttpClientBuildRequest(L, httpRequest);
	httpRequest->method = HttpClientLib::HTTP_HEAD;

	g_http().addRequest(httpRequest);

	pushBoolean(L, true);
	return 1;
}

int HttpClientFunctions::luaHttpClientRequestDelete(lua_State* L)
{
	HttpClientLib::HttpRequest_ptr httpRequest = getUserdataShared<HttpClientLib::HttpRequest>(L, 1);

	if (!httpRequest) {
		lua_pushnil(L);
		return 1;
	}

	luaHttpClientBuildRequest(L, httpRequest);
	httpRequest->method = HttpClientLib::HTTP_DELETE;

	g_http().addRequest(httpRequest);

	pushBoolean(L, true);
	return 1;
}

int HttpClientFunctions::luaHttpClientRequestGet(lua_State* L)
{
	HttpClientLib::HttpRequest_ptr httpRequest = getUserdataShared<HttpClientLib::HttpRequest>(L, 1);

	if (!httpRequest) {
		lua_pushnil(L);
		return 1;
	}

	luaHttpClientBuildRequest(L, httpRequest);
	httpRequest->method = HttpClientLib::HTTP_GET;

	g_http().addRequest(httpRequest);

	pushBoolean(L, true);
	return 1;
}

int HttpClientFunctions::luaHttpClientRequestPost(lua_State* L)
{
	HttpClientLib::HttpRequest_ptr httpRequest = getUserdataShared<HttpClientLib::HttpRequest>(L, 1);

	if (!httpRequest) {
		lua_pushnil(L);
		return 1;
	}

	luaHttpClientBuildRequest(L, httpRequest);
	httpRequest->method = HttpClientLib::HTTP_POST;

	g_http().addRequest(httpRequest);

	pushBoolean(L, true);
	return 1;
}

int HttpClientFunctions::luaHttpClientRequestPatch(lua_State* L)
{
	HttpClientLib::HttpRequest_ptr httpRequest = getUserdataShared<HttpClientLib::HttpRequest>(L, 1);

	if (!httpRequest) {
		lua_pushnil(L);
		return 1;
	}

	luaHttpClientBuildRequest(L, httpRequest);
	httpRequest->method = HttpClientLib::HTTP_PATCH;

	g_http().addRequest(httpRequest);

	pushBoolean(L, true);
	return 1;
}

int HttpClientFunctions::luaHttpClientRequestPut(lua_State* L)
{
	HttpClientLib::HttpRequest_ptr httpRequest = getUserdataShared<HttpClientLib::HttpRequest>(L, 1);

	if (!httpRequest) {
		lua_pushnil(L);
		return 1;
	}

	luaHttpClientBuildRequest(L, httpRequest);
	httpRequest->method = HttpClientLib::HTTP_PUT;

	g_http().addRequest(httpRequest);

	pushBoolean(L, true);
	return 1;
}

void HttpClientFunctions::luaHttpClientBuildRequest(lua_State* L, HttpClientLib::HttpRequest_ptr& httpRequest)
{
	std::string url;
	int32_t callbackId = -1;
	std::unordered_map<std::string, std::string> headerFields;
	std::string data;

	luaHttpClientRetrieveParameters(L, url, callbackId, headerFields, data);

	httpRequest->url = url;
	httpRequest->fields = headerFields;
	httpRequest->data = data;

	httpRequest->callbackData.scriptId = getScriptEnv()->getScriptId();
	httpRequest->callbackData.callbackId = callbackId;
}

bool HttpClientFunctions::luaHttpClientRetrieveParameters(lua_State* L, std::string& url, int32_t& callbackId,
	std::unordered_map<std::string, std::string>& headerFields,
	std::string& data)
{
	int parameters = lua_gettop(L);
	if (parameters < 2) {
		reportErrorFunc("httpClient: expecting at least two arguments: url, callback");
		pushBoolean(L, false);
		return false;
	}

	if (!isString(L, 2)) {
		reportErrorFunc("httpClient: url parameter should be a string.");
		pushBoolean(L, false);
		return false;
	}

	if (!isFunction(L, 3) && !isNil(L, 3)) {
		reportErrorFunc("httpClient: callback parameter should be a function or a nil value.");
		pushBoolean(L, false);
		return false;
	}

	if (parameters >= 5) {
		if (!isString(L, 5)) {
			reportErrorFunc("httpClient: data parameter should be a string.");
			pushBoolean(L, false);
			return false;
		}

		data = getString(L, 5);
		lua_pop(L, 1);
	}

	if (parameters >= 4) {
		if (!isTable(L, 4)) {
			reportErrorFunc("httpClient: Invalid fields table.");
			pushBoolean(L, false);
			return false;
		}

		lua_pushnil(L);
		while (lua_next(L, 4) != 0) {
			if (lua_isstring(L, -2) && lua_isstring(L, -1)) {
				std::string key = getString(L, -2);
				std::string value = getString(L, -1);
				headerFields[key] = value;

				// Removes the value, keeps the key for the next iteration
				lua_pop(L, 1);
			}
		}
		lua_pop(L, 1);
	}

	callbackId = luaL_ref(L, LUA_REGISTRYINDEX);

	url = getString(L, 2);
	lua_pop(L, 1);

	// pop HttpClientRequest class
	lua_pop(L, 1);

	return true;
}
