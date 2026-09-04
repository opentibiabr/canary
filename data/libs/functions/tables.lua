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

-- Recursive-descent parser for the exact grammar table.serialize() produces:
-- nil, booleans, numbers, single/double-quoted strings (with \n \t \r and
-- \ddd escapes), and nested tables with bracketed keys. Every branch returns
-- an explicit (ok, value, nextIndex) triple instead of relying on nil as a
-- "parse failed" sentinel -- a legitimately-serialized nil value and a parse
-- failure both look like nil otherwise, and that ambiguity previously let the
-- table-parsing loop keep retrying without ever advancing its cursor on
-- malformed input, hanging forever. Whitespace is only skipped between
-- tokens (never inside a quoted string), so round-tripping a string or
-- string key that contains spaces no longer corrupts it.
local function parseSerializedValue(s, i, len)
	while i <= len do
		local c = s:sub(i, i)
		if c == " " or c == "\t" or c == "\n" or c == "\r" then
			i = i + 1
		else
			break
		end
	end
	if i > len then
		return false
	end

	local word = s:match("^(%a+)", i)
	if word == "nil" then
		return true, nil, i + 3
	elseif word == "true" then
		return true, true, i + 4
	elseif word == "false" then
		return true, false, i + 5
	end

	local numStr, afterNum = s:match("^([%-%d%.eE+]+)()", i)
	if numStr and numStr:match("^[%-]?%d") then
		local n = tonumber(numStr)
		if n then
			return true, n, afterNum
		end
	end

	local c = s:sub(i, i)
	if c == '"' or c == "'" then
		local quote = c
		local j = i + 1
		local out = {}
		while j <= len do
			local ch = s:sub(j, j)
			if ch == "\\" then
				local esc = s:sub(j + 1, j + 1)
				if esc == "" then
					return false
				elseif esc:match("%d") then
					local digits = s:match("^%d%d?%d?", j + 1)
					local code = tonumber(digits)
					if not code or code > 255 then
						return false
					end
					out[#out + 1] = string.char(code)
					j = j + 1 + #digits
				elseif esc == "n" then
					out[#out + 1] = "\n"
					j = j + 2
				elseif esc == "t" then
					out[#out + 1] = "\t"
					j = j + 2
				elseif esc == "r" then
					out[#out + 1] = "\r"
					j = j + 2
				else
					out[#out + 1] = esc
					j = j + 2
				end
			elseif ch == quote then
				return true, table.concat(out), j + 1
			else
				out[#out + 1] = ch
				j = j + 1
			end
		end
		return false
	end

	if c == "{" then
		local t = {}
		local arrayIndex = 1
		i = i + 1
		while i <= len and s:sub(i, i):match("%s") do
			i = i + 1
		end
		if s:sub(i, i) == "}" then
			return true, t, i + 1
		end

		while true do
			while i <= len do
				local ch = s:sub(i, i)
				if ch == "," or ch:match("%s") then
					i = i + 1
				else
					break
				end
			end
			if s:sub(i, i) == "}" then
				return true, t, i + 1
			end

			local key
			if s:sub(i, i) == "[" then
				local okKey, parsedKey, afterKey = parseSerializedValue(s, i + 1, len)
				if not okKey then
					return false
				end
				i = afterKey
				while i <= len and s:sub(i, i):match("%s") do
					i = i + 1
				end
				if s:sub(i, i) ~= "]" then
					return false
				end
				i = i + 1
				while i <= len and s:sub(i, i):match("%s") do
					i = i + 1
				end
				if s:sub(i, i) ~= "=" then
					return false
				end
				i = i + 1
				if parsedKey == nil then
					return false
				end
				key = parsedKey
			else
				key = arrayIndex
				arrayIndex = arrayIndex + 1
			end

			while i <= len and s:sub(i, i):match("%s") do
				i = i + 1
			end
			local okVal, val, afterVal = parseSerializedValue(s, i, len)
			if not okVal then
				return false
			end
			t[key] = val
			i = afterVal

			while i <= len and s:sub(i, i):match("%s") do
				i = i + 1
			end
			local nextCh = s:sub(i, i)
			if nextCh == "}" then
				return true, t, i + 1
			elseif nextCh == "," then
				i = i + 1
			else
				return false
			end
		end
	end

	return false
end

function table.unserialize(str)
	if type(str) ~= "string" or str:match("^%s*$") then
		return nil
	end

	local len = #str
	local ok, result, nextIndex = parseSerializedValue(str, 1, len)
	if not ok then
		return nil
	end

	while nextIndex <= len and str:sub(nextIndex, nextIndex):match("%s") do
		nextIndex = nextIndex + 1
	end
	if nextIndex ~= len + 1 then
		return nil
	end

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
