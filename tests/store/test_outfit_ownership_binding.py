"""Execute the actual hasOutfit binding with LuaJIT and controlled Player state.

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
    harness = r'''
#include <algorithm>
#include <cstdint>
#include <memory>
#include <vector>
extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}
struct Entry { uint16_t lookType; uint8_t addons; };
struct Player {
    std::vector<Entry> outfits {{100, 1}, {200, 2}, {300, 0}};
    bool access = false;
    const auto& getOutfits() const { return outfits; }
    bool canWear(uint16_t look, uint8_t addon) const {
        if (access) return true;
        return look == 100 && (outfits[0].addons & addon) == addon;
    }
};
std::shared_ptr<Player> current = std::make_shared<Player>();
namespace Lua {
template<class T> std::shared_ptr<T> getUserdataShared(lua_State*, int, const char* = nullptr) { return current; }
template<class T> T getNumber(lua_State* state, int index, T fallback = T{}) {
    return lua_isnoneornil(state, index) ? fallback : static_cast<T>(lua_tointeger(state, index));
}
bool getBoolean(lua_State* state, int index, bool fallback) {
    return lua_isnoneornil(state, index) ? fallback : lua_toboolean(state, index) != 0;
}
void pushBoolean(lua_State* state, bool value) { lua_pushboolean(state, value); }
}
struct PlayerFunctions { static int luaPlayerHasOutfit(lua_State*); };
'''
    harness += binding + r'''
int main() {
    lua_State* state = luaL_newstate(); luaL_openlibs(state);
    lua_pushcfunction(state, PlayerFunctions::luaPlayerHasOutfit); lua_setglobal(state, "hasOutfit");
    int result = luaL_dostring(state,
        "assert(hasOutfit({},100,1)); assert(not hasOutfit({},100,2));"
        "assert(not hasOutfit({},200,2)); assert(hasOutfit({},200,2,true));"
        "assert(not hasOutfit({},200,1,true)); assert(hasOutfit({},300,0,true));"
        "assert(not hasOutfit({},999,0,true)); assert(not hasOutfit({},200,2,false));");
    if (result) return 1;
    current->access = true;
    if (luaL_dostring(state,"assert(hasOutfit({},999,3)); assert(not hasOutfit({},999,3,true));")) return 2;
    current.reset();
    if (luaL_dostring(state,"assert(hasOutfit({},100,0,true) == nil)")) return 3;
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
    print("PASS: actual binding preserves wearability defaults and reads opposite-sex/base/addon ownership without access bypass")


if __name__ == "__main__":
    main()
