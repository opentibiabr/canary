#pragma once

#include <memory>

struct lua_State;
struct WorldObjectToken;
namespace world_layers {
	struct BehaviorBinding;
	struct BehaviorDescriptor;
}

class WorldFunctions {
public:
	static void init(lua_State* L);
	static void pushContext(lua_State* L, const WorldObjectToken &object, const world_layers::BehaviorBinding &binding, const world_layers::BehaviorDescriptor &descriptor, const std::shared_ptr<bool> &invocation);

private:
	static int luaWorldGet(lua_State* L);
	static int luaWorldResolve(lua_State* L);
	static int luaWorldFromItem(lua_State* L);
	static int luaWorldObjectGetItem(lua_State* L);
	static int luaWorldObjectGetPosition(lua_State* L);
	static int luaWorldObjectGetInitialItemId(lua_State* L);
	static int luaWorldObjectToken(lua_State* L);
	static int luaWorldContextObject(lua_State* L);
	static int luaWorldContextParameter(lua_State* L);
	static int luaWorldContextRelation(lua_State* L);
	static int luaWorldReferenceGetObject(lua_State* L);
	static int luaWorldReferenceGetPosition(lua_State* L);
	static int luaCreateWorldBehavior(lua_State* L);
	static int luaWorldBehaviorRegister(lua_State* L);
	static int luaWorldBehaviorNewIndex(lua_State* L);
};
