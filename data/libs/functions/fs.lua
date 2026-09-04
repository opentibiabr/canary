FS = {}

function FS.exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end
	return false
end

-- Validates a path so it cannot be used for shell command injection.
-- Only allows alphanumeric characters, underscores, dots, dashes,
-- slashes and backslashes, and must not contain any quote character.
function FS.isPathSafe(path)
	if type(path) ~= "string" or path == "" then
		return false
	end
	-- reject quotes, semicolons, pipes, ampersands, backticks, parentheses,
	-- dollar, greater/less-than, newlines and other shell metacharacters.
	if path:find("[%\"%';|&`$()<>%c]") then
		return false
	end
	return true
end

function FS.mkdir(path)
	if FS.exists(path) then
		return true
	end
	if not FS.isPathSafe(path) then
		return false, "unsafe path"
	end
	local cmd
	if package.config:sub(1, 1) == "\\" then
		-- Windows: use quoted path and /C to avoid leaking shell state
		cmd = 'cmd /c mkdir "' .. path .. '"'
	else
		cmd = 'mkdir "' .. path .. '"'
	end
	local success, err = os.execute(cmd)
	if not success then
		return false, err
	end
	return true
end

function FS.mkdir_p(path)
	if path == "" then
		return true
	end

	local components = {}
	for component in path:gmatch("[^/\\]+") do
		table.insert(components, component)
	end

	local currentPath = ""
	for i, component in ipairs(components) do
		currentPath = currentPath .. component

		if not FS.exists(currentPath) then
			local success, err = FS.mkdir(currentPath)
			if not success then
				return false, err
			end
		end

		if i < #components then
			currentPath = currentPath .. "/"
		end
	end

	return true
end
