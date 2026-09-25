FS = {}

-- Private bridge to the native fsCreateDirectories() binding
-- (src/lua/functions/core/game/global_functions.cpp -> std::filesystem::create_directories).
-- Capture the native binding for these wrappers, but keep it registered:
-- core reload executes this file again in the same Lua environment, and
-- clearing the global here would leave that second execution capturing
-- nil, breaking FS.mkdir()/FS.mkdir_p() after every reload. Hiding a
-- binding behind a local is not an access-control boundary anyway --
-- preserving reload behavior matters more than removing this entry point.
local nativeCreateDirectories = fsCreateDirectories

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
