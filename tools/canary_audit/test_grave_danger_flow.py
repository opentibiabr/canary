"""Execute isolated Lua flow checks using the maintained LuaJIT static library.

Run from an MSVC developer environment. No server or database is loaded.
"""
from pathlib import Path
import subprocess
import tempfile
import sys

root = Path(__file__).resolve().parents[2]
cache = root / "build/windows-release/CMakeCache.txt"
installed = root / "build/windows-release/vcpkg_installed"
if cache.exists():
    for line in cache.read_text(encoding="utf-8-sig").splitlines():
        if line.startswith("VCPKG_INSTALLED_DIR:PATH="):
            installed = Path(line.split("=", 1)[1]); break
installed = installed / "x64-windows-static-release"
source = r'''
#include <cstdio>
extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}
int main(int argc,char** argv){lua_State* L=luaL_newstate();luaL_openlibs(L);
int error=luaL_dofile(L,argv[1]);if(error)std::fprintf(stderr,"%s\n",lua_tostring(L,-1));
lua_close(L);return error?1:0;}
'''
with tempfile.TemporaryDirectory(prefix="canary-grave-lua-test-") as folder:
    folder = Path(folder)
    cpp = folder / "runner.cpp"
    cpp.write_text(source)
    subprocess.run(["cl", "/nologo", "/EHsc", "/MT", str(cpp),
                    "/I" + str(installed / "include/luajit"),
                    "/Fo" + str(folder / "runner.obj"),
                    "/Fe" + str(folder / "runner.exe"), str(installed / "lib/lua51.lib")],
                   cwd=folder, check=True)
    subprocess.run([str(folder / "runner.exe"), sys.argv[1] if len(sys.argv) > 1 else "tools/canary_audit/test_grave_danger.lua"],
                   cwd=root, check=True)
