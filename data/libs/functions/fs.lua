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
	local success, err = os.execute("mkdir " .. path)
	if not success then
		return false, err
	end
	return true
end

function FS.mkdir_p(path)
	if path == "" then
		return true
	end
	if FS.exists(path) then
		return true
	end
	FS.mkdir_p(path:match("(.*[/\\])"))
	return FS.mkdir(path)
end
