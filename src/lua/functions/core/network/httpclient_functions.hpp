/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class HttpClientFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {

		registerClass(L, "HttpClientRequest", "", HttpClientFunctions::luaCreateHttpClientRequest);
		registerMetaMethod(L, "HttpClientRequest", "__eq", HttpClientFunctions::luaUserdataCompare);
		registerMetaMethod(L, "HttpClientRequest", "__gc", HttpClientFunctions::luaDeleteHttpClientRequest);
		registerMethod(L, "HttpClientRequest", "setTimeout", HttpClientFunctions::luaHttpClientRequestSetTimeout);
		registerMethod(L, "HttpClientRequest", "connect", HttpClientFunctions::luaHttpClientRequestConnect);
		registerMethod(L, "HttpClientRequest", "trace", HttpClientFunctions::luaHttpClientRequestTrace);
		registerMethod(L, "HttpClientRequest", "options", HttpClientFunctions::luaHttpClientRequestOptions);
		registerMethod(L, "HttpClientRequest", "head", HttpClientFunctions::luaHttpClientRequestHead);
		registerMethod(L, "HttpClientRequest", "delete", HttpClientFunctions::luaHttpClientRequestDelete);
		registerMethod(L, "HttpClientRequest", "get", HttpClientFunctions::luaHttpClientRequestGet);
		registerMethod(L, "HttpClientRequest", "post", HttpClientFunctions::luaHttpClientRequestPost);
		registerMethod(L, "HttpClientRequest", "patch", HttpClientFunctions::luaHttpClientRequestPatch);
		registerMethod(L, "HttpClientRequest", "put", HttpClientFunctions::luaHttpClientRequestPut);
	}

private:
	static int luaCreateHttpClientRequest(lua_State* L);
	static int luaDeleteHttpClientRequest(lua_State* L);
	static void luaHttpClientBuildRequest(lua_State* L, HttpClientLib::HttpRequest_ptr& httpRequest);
	static bool luaHttpClientRetrieveParameters(lua_State* L, std::string& url, int32_t& callbackId,
	                                            std::unordered_map<std::string, std::string>& headerFields,
	                                            std::string& data);
	static int luaHttpClientRequestSetTimeout(lua_State* L);
	static int luaHttpClientRequestConnect(lua_State* L);
	static int luaHttpClientRequestTrace(lua_State* L);
	static int luaHttpClientRequestOptions(lua_State* L);
	static int luaHttpClientRequestHead(lua_State* L);
	static int luaHttpClientRequestDelete(lua_State* L);
	static int luaHttpClientRequestGet(lua_State* L);
	static int luaHttpClientRequestPost(lua_State* L);
	static int luaHttpClientRequestPatch(lua_State* L);
	static int luaHttpClientRequestPut(lua_State* L);
};
