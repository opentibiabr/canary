FS = {}

function FS.exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end
	return false
end

function FS.mkdir(path)
	if FS.exists(path) then
		return true
	end
	local success, err = os.execute('mkdir "' .. path .. '"')
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
