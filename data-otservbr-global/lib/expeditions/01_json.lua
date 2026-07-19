-- Minimal JSON encode/decode for expedition protocol payloads.
ExpeditionJson = ExpeditionJson or {}

local function escapeString(s)
	s = s:gsub("\\", "\\\\")
	s = s:gsub('"', '\\"')
	s = s:gsub("\n", "\\n")
	s = s:gsub("\r", "\\r")
	s = s:gsub("\t", "\\t")
	return '"' .. s .. '"'
end

function ExpeditionJson.encode(value)
	local t = type(value)
	if t == "nil" then
		return "null"
	elseif t == "boolean" then
		return value and "true" or "false"
	elseif t == "number" then
		return tostring(value)
	elseif t == "string" then
		return escapeString(value)
	elseif t == "table" then
		local isArray = true
		local maxIndex = 0
		for k, _ in pairs(value) do
			if type(k) ~= "number" or k < 1 or math.floor(k) ~= k then
				isArray = false
				break
			end
			if k > maxIndex then
				maxIndex = k
			end
		end
		if isArray then
			local parts = {}
			for i = 1, maxIndex do
				parts[#parts + 1] = ExpeditionJson.encode(value[i])
			end
			return "[" .. table.concat(parts, ",") .. "]"
		end
		local parts = {}
		for k, v in pairs(value) do
			parts[#parts + 1] = escapeString(tostring(k)) .. ":" .. ExpeditionJson.encode(v)
		end
		return "{" .. table.concat(parts, ",") .. "}"
	end
	return "null"
end

local function skipWs(s, i)
	while i <= #s and s:sub(i, i):match("%s") do
		i = i + 1
	end
	return i
end

local function parseValue(s, i)
	i = skipWs(s, i)
	local c = s:sub(i, i)
	if c == '"' then
		local j = i + 1
		local out = {}
		while j <= #s do
			local ch = s:sub(j, j)
			if ch == "\\" then
				local next = s:sub(j + 1, j + 1)
				if next == "n" then
					out[#out + 1] = "\n"
				elseif next == "r" then
					out[#out + 1] = "\r"
				elseif next == "t" then
					out[#out + 1] = "\t"
				else
					out[#out + 1] = next
				end
				j = j + 2
			elseif ch == '"' then
				return table.concat(out), j + 1
			else
				out[#out + 1] = ch
				j = j + 1
			end
		end
		error("unterminated string")
	elseif c == "{" then
		local obj = {}
		i = i + 1
		i = skipWs(s, i)
		if s:sub(i, i) == "}" then
			return obj, i + 1
		end
		while true do
			local key
			key, i = parseValue(s, i)
			i = skipWs(s, i)
			if s:sub(i, i) ~= ":" then
				error("expected :")
			end
			i = i + 1
			local val
			val, i = parseValue(s, i)
			obj[key] = val
			i = skipWs(s, i)
			local sep = s:sub(i, i)
			if sep == "}" then
				return obj, i + 1
			elseif sep == "," then
				i = i + 1
			else
				error("expected , or }")
			end
		end
	elseif c == "[" then
		local arr = {}
		i = i + 1
		i = skipWs(s, i)
		if s:sub(i, i) == "]" then
			return arr, i + 1
		end
		while true do
			local val
			val, i = parseValue(s, i)
			arr[#arr + 1] = val
			i = skipWs(s, i)
			local sep = s:sub(i, i)
			if sep == "]" then
				return arr, i + 1
			elseif sep == "," then
				i = i + 1
			else
				error("expected , or ]")
			end
		end
	elseif s:sub(i, i + 3) == "true" then
		return true, i + 4
	elseif s:sub(i, i + 4) == "false" then
		return false, i + 5
	elseif s:sub(i, i + 3) == "null" then
		return nil, i + 4
	else
		local j = i
		while j <= #s and s:sub(j, j):match("[%d%.%-%+eE]") do
			j = j + 1
		end
		return tonumber(s:sub(i, j - 1)), j
	end
end

function ExpeditionJson.decode(s)
	if type(s) ~= "string" or s == "" then
		return nil
	end
	local ok, value = pcall(function()
		local v, _ = parseValue(s, 1)
		return v
	end)
	if not ok then
		return nil
	end
	return value
end
