return function(api)
	local diagnostics = {}
	api.diagnostics = diagnostics

	local actionNames = {}
	for name, action in pairs(api.action or {}) do
		actionNames[action] = name
	end

	local function write(level, stage, message, ...)
		if not api.config or api.config.runtimeDiagnostics ~= true then
			return
		end

		local runtimeLogger = rawget(_G, "logger")
		local sink = runtimeLogger and runtimeLogger[level]
		if type(sink) == "function" then
			pcall(sink, "[Taskboard][" .. stage .. "] " .. message, ...)
		end
	end

	function diagnostics.info(stage, message, ...)
		write("info", stage, message, ...)
	end

	function diagnostics.warn(stage, message, ...)
		write("warn", stage, message, ...)
	end

	function diagnostics.playerName(player)
		if player and type(player.getName) == "function" then
			local ok, name = pcall(player.getName, player)
			if ok and name then
				return tostring(name)
			end
		end
		return "<unknown>"
	end

	function diagnostics.client(player)
		local client
		if player and type(player.getClient) == "function" then
			local ok, value = pcall(player.getClient, player)
			if ok then
				client = value
			end
		end
		return tonumber(client and client.version) or 0, tostring(client and client.versionString or "")
	end

	function diagnostics.unreadBytes(msg)
		if not msg or type(msg.getUnreadBytes) ~= "function" then
			return -1
		end
		local ok, unread = pcall(msg.getUnreadBytes, msg)
		return ok and tonumber(unread) or -1
	end

	function diagnostics.actionName(action)
		return actionNames[action] or "unknown"
	end

	function diagnostics.hexByte(value)
		value = math.max(0, math.min(0xFF, math.floor(tonumber(value) or 0)))
		return string.format("%02X", value)
	end

	function diagnostics.payload(payload)
		if type(payload) ~= "table" or #payload == 0 then
			return "-"
		end
		local values = {}
		for index, value in ipairs(payload) do
			values[index] = tostring(value)
		end
		return table.concat(values, ",")
	end
end
