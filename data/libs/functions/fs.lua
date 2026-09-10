FS = {}

-- Private bridge to the native fsCreateDirectories() binding
-- (src/lua/functions/core/game/global_functions.cpp -> std::filesystem::create_directories).
-- lua_register() has no narrower scope than the global table, so it's
-- captured into a local here and immediately removed from _G -- otherwise
-- it would sit alongside FS.mkdir() as a second, undocumented global entry
-- point (no Lua API docgen coverage, no path validation of its own) instead
-- of being purely implementation plumbing for FS.mkdir()/FS.mkdir_p(). This
-- file loads as part of the core library bootstrap (data/core.lua ->
-- libs/libs.lua), before any datapack/custom script runs, so nothing else
-- ever observes the global existing.
local nativeCreateDirectories = fsCreateDirectories
fsCreateDirectories = nil

function FS.exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end
	return false
end

-- No shell is ever started, so there's no command-injection surface and no
-- denylist of "unsafe" path characters -- any path std::filesystem accepts
-- (including "%", quotes, parentheses, etc. in legitimate directory names)
-- works correctly. Also creates any missing parent directories, so this
-- alone now covers what FS.mkdir_p() used to do by walking components.
function FS.mkdir(path)
	if type(path) ~= "string" or path == "" then
		return false, "invalid path"
	end
	return nativeCreateDirectories(path)
end

function FS.mkdir_p(path)
	if path == "" then
		return true
	end
	return FS.mkdir(path)
end
