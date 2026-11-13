"""Execute the actual outfit/mount ownership bindings with LuaJIT and controlled Player state.

Run from an MSVC developer prompt with --lua-include and --lua-library pointing
to the maintained LuaJIT dependency cache. No server or database is started.
"""
import argparse
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[2]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lua-include", type=Path, required=True)
    parser.add_argument("--lua-library", type=Path, required=True)
    args = parser.parse_args()
    source = (ROOT / "src/lua/functions/creatures/player/player_functions.cpp").read_text(encoding="utf-8")
    start = source.index("int PlayerFunctions::luaPlayerHasOutfit(")
    end = source.index("\nint PlayerFunctions::", start + 1)
    binding = source[start:end]
    start = source.index("int PlayerFunctions::luaPlayerHasMount(")
    end = source.index("\nint PlayerFunctions::", start + 1)
    binding += source[start:end]
    harness = r'''
#include <algorithm>
#include <cstdint>
#include <memory>
#include <string>
#include <map>
#include <vector>
extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}
struct Entry { uint16_t lookType; uint8_t addons; };
constexpr uint32_t PSTRG_MOUNTS_RANGE_START = 100;
struct Mount { uint8_t id; };
struct Mounts {
    std::shared_ptr<Mount> getMountByID(uint8_t id) { return id ? std::make_shared<Mount>(Mount{id}) : nullptr; }
    std::shared_ptr<Mount> getMountByName(const std::string& name) { return name == "named" ? getMountByID(32) : nullptr; }
};
struct Game { std::shared_ptr<Mounts> mounts = std::make_shared<Mounts>(); };
Game& g_game() { static Game game; return game; }
struct Player {
    std::vector<Entry> outfits {{100, 1}, {200, 2}, {300, 0}};
    bool access = false;
    std::map<uint32_t, int32_t> storage {{100, (1 << 30) | 1}, {101, 1}, {102, 0}};
    int32_t getStorageValue(uint32_t key) const { const auto it = storage.find(key); return it == storage.end() ? -1 : it->second; }
    bool hasMount(const std::shared_ptr<Mount>&) const { return access; }
    const auto& getOutfits() const { return outfits; }
    bool canWear(uint16_t look, uint8_t addon) const {
        if (access) return true;
        return look == 100 && (outfits[0].addons & addon) == addon;
    }
};
std::shared_ptr<Player> current = std::make_shared<Player>();
namespace Lua {
bool isNumber(lua_State* state, int index) { return lua_isnumber(state, index) != 0; }
std::string getString(lua_State* state, int index) { const char* value = lua_tostring(state, index); return value ? value : ""; }
template<class T> std::shared_ptr<T> getUserdataShared(lua_State*, int, const char* = nullptr) { return current; }
template<class T> T getNumber(lua_State* state, int index, T fallback = T{}) {
    return lua_isnoneornil(state, index) ? fallback : static_cast<T>(lua_tointeger(state, index));
}
bool getBoolean(lua_State* state, int index, bool fallback) {
    return lua_isnoneornil(state, index) ? fallback : lua_toboolean(state, index) != 0;
}
void pushBoolean(lua_State* state, bool value) { lua_pushboolean(state, value); }
}
struct PlayerFunctions { static int luaPlayerHasOutfit(lua_State*); static int luaPlayerHasMount(lua_State*); };
'''
    harness += binding + r'''
int main() {
    lua_State* state = luaL_newstate(); luaL_openlibs(state);
    lua_pushcfunction(state, PlayerFunctions::luaPlayerHasOutfit); lua_setglobal(state, "hasOutfit");
    lua_pushcfunction(state, PlayerFunctions::luaPlayerHasMount); lua_setglobal(state, "hasMount");
    int result = luaL_dostring(state,
        "assert(hasOutfit({},100,1)); assert(not hasOutfit({},100,2));"
        "assert(not hasOutfit({},200,2)); assert(hasOutfit({},200,2,true));"
        "assert(not hasOutfit({},200,1,true)); assert(hasOutfit({},300,0,true));"
        "assert(not hasOutfit({},999,0,true)); assert(not hasOutfit({},200,2,false));");
    if (result) return 1;
    if (luaL_dostring(state,
        "assert(not hasMount({},1)); assert(hasMount({},1,true)); assert(hasMount({},31,true));"
        "assert(hasMount({},32,true)); assert(not hasMount({},33,true)); assert(not hasMount({},63,true));"
        "assert(not hasMount({},64,true)); assert(not hasMount({},94,true));"
        "assert(hasMount({},'named',true)); assert(hasMount({},'missing',true) == nil);")) return 4;
    current->access = true;
    if (luaL_dostring(state,"assert(hasMount({},33)); assert(not hasMount({},33,true));")) return 5;
    if (luaL_dostring(state,"assert(hasOutfit({},999,3)); assert(not hasOutfit({},999,3,true));")) return 2;
    current.reset();
    if (luaL_dostring(state,"assert(hasOutfit({},100,0,true) == nil); assert(hasMount({},1,true) == nil)")) return 3;
    lua_close(state); return 0;
}
'''
    with tempfile.TemporaryDirectory(prefix="canary-store-ownership-") as directory:
        folder = Path(directory)
        cpp, executable = folder / "ownership.cpp", folder / "ownership.exe"
        cpp.write_text(harness, encoding="utf-8")
        subprocess.run(["cl", "/nologo", "/std:c++20", "/EHsc", "/MT", str(cpp),
                        "/I" + str(args.lua_include), "/Fo" + str(folder / "ownership.obj"),
                        "/Fe" + str(executable), str(args.lua_library)], cwd=folder, check=True)
        subprocess.run([str(executable)], check=True)
    print("PASS: actual outfit/mount bindings preserve default access behavior and raw addon/mount ownership, including storage boundaries")


if __name__ == "__main__":
    main()
