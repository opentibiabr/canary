table.append = table.insert
table.empty = function(t)
	return next(t) == nil
end

table.find = function(table, value)
	for i, v in pairs(table) do
		if v == value then
			return i
		end
	end

	return nil
end

table.contains = function(array, value)
	for _, targetColumn in pairs(array) do
		if targetColumn == value then
			return true
		end
	end
	return false
end

table.count = function(table, item)
	local count = 0
	for i, n in pairs(table) do
		if item == n then
			count = count + 1
		end
	end

	return count
end
table.countElements = table.count

table.getCombinations = function(table, num)
	local a, number, select, newlist = {}, #table, num, {}
	for i = 1, select do
		a[#a + 1] = i
	end

	local newthing = {}
	while true do
		local newrow = {}
		for i = 1, select do
			newrow[#newrow + 1] = table[a[i]]
		end

		newlist[#newlist + 1] = newrow
		i = select
		while a[i] == (number - select + i) do
			i = i - 1
		end

		if i < 1 then
			break
		end

		a[i] = a[i] + 1
		for j = i, select do
			a[j] = a[i] + j - i
		end
	end

	return newlist
end

function table.serialize(x, recur)
	local t = type(x)
	recur = recur or {}

	if t == nil then
		return "nil"
	elseif t == "string" then
		return string.format("%q", x)
	elseif t == "number" then
		return tostring(x)
	elseif t == "boolean" then
		return t and "true" or "false"
	elseif getmetatable(x) then
		error("Can not serialize a table that has a metatable associated with it.")
	elseif t == "table" then
		if table.find(recur, x) then
			error("Can not serialize recursive tables.")
		end
		table.append(recur, x)

		local s = "{"
		for k, v in pairs(x) do
			s = s .. "[" .. table.serialize(k, recur) .. "]"
			s = s .. " = " .. table.serialize(v, recur) .. ","
		end
		s = s .. "}"
		return s
	else
		error("Can not serialize value of type '" .. t .. "'.")
	end
end

function table.unserialize(str)
	if type(str) ~= "string" then
		return nil
	end

	-- Only allow safe characters: tables, strings, numbers, booleans, nil, and structural punctuation.
	-- Reject any letter sequences that are not "true", "false" or "nil" to prevent function calls.
	local sanitized = str:gsub("%s", "")
	if sanitized == "" then
		return nil
	end

	local function parseValue(s, i)
		local c = s:sub(i, i)

		-- nil
		local word = s:match("^([%a]+)", i)
		if word == "nil" then
			return nil, i + 3
		elseif word == "true" then
			return true, i + 4
		elseif word == "false" then
			return false, i + 5
		end

		-- number (int / float, optional leading sign)
		local numStr, nextIdx = s:match("^([%-%d%.eE+]+)()", i)
		if numStr and numStr:match("^[%-]?%d") then
			local n = tonumber(numStr)
			if n then
				return n, nextIdx
			end
		end

		-- string (double or single quoted, with escapes)
		if c == '"' or c == "'" then
			local quote = c
			local j = i + 1
			local out = {}
			while j <= #s do
				local ch = s:sub(j, j)
				if ch == "\\" then
					local esc = s:sub(j + 1, j + 1)
					if esc == "n" then
						out[#out + 1] = "\n"
					elseif esc == "t" then
						out[#out + 1] = "\t"
					elseif esc == "r" then
						out[#out + 1] = "\r"
					else
						out[#out + 1] = esc
					end
					j = j + 2
				elseif ch == quote then
					j = j + 1
					break
				else
					out[#out + 1] = ch
					j = j + 1
				end
			end
			return table.concat(out), j
		end

		-- table
		if c == "{" then
			local t = {}
			i = i + 1
			while i <= #s do
				-- skip commas
				while s:sub(i, i) == "," do
					i = i + 1
				end
				if s:sub(i, i) == "}" then
					i = i + 1
					break
				end

				-- key
				local key
				if s:sub(i, i) == "[" then
					-- bracketed key
					local closeIdx = s:find("%]", i + 1)
					if not closeIdx then
						return nil, i
					end
					local keyStr = s:sub(i + 1, closeIdx - 1)
					local parsedKey = keyStr:match("^%d+$") and tonumber(keyStr) or keyStr:match('^"(.*)"$') or keyStr:match("^'(.*)'$")
					if not parsedKey then
						return nil, i
					end
					key = parsedKey
					i = closeIdx + 1
					-- expect '='
					if s:sub(i, i) ~= "=" then
						return nil, i
					end
					i = i + 1
				else
					-- implicit array index
					key = #t + 1
				end

				-- value
				local value, newIdx = parseValue(s, i)
				t[key] = value
				i = newIdx
			end
			return t, i
		end

		return nil, i
	end

	local result, _ = parseValue(sanitized, 1)
	return result
end

function table.shallowCopy(oldTable)
	local newTable = {}
	for k, v in pairs(oldTable) do
		newTable[k] = v
	end
	return newTable
end

function pairsByKeys(t, f)
	local a = {}
	for n in pairs(t) do
		table.insert(a, n)
	end
	table.sort(a, f)
	local i = 0 -- iterator variable
	local iter = function() -- iterator function
		i = i + 1
		if a[i] == nil then
			return nil
		else
			return a[i], t[a[i]]
		end
	end
	return iter
end
