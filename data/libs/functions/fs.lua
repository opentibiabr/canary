FS = {}

function FS.exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end
	return false
end

-- Thin wrapper around the native fsCreateDirectories() binding
-- (src/lua/functions/core/game/global_functions.cpp -> std::filesystem::create_directories).
-- No shell is ever started, so there's no command-injection surface and no
-- denylist of "unsafe" path characters -- any path std::filesystem accepts
-- (including "%", quotes, parentheses, etc. in legitimate directory names)
-- works correctly. Also creates any missing parent directories, so this
-- alone now covers what FS.mkdir_p() used to do by walking components.
function FS.mkdir(path)
	if type(path) ~= "string" or path == "" then
		return false, "invalid path"
	end
	return fsCreateDirectories(path)
end

function FS.mkdir_p(path)
	if path == "" then
		return true
	end
	return FS.mkdir(path)
end
