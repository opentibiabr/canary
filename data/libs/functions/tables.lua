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

-- Bounds how much work a single parse can do: a depth cap (guards the C
-- stack against deeply-nested crafted input, e.g. a string of thousands of
-- nested "{[1]={[1]={...") and a total-node cap (guards CPU/memory against
-- a huge flat table). Both are generous relative to anything table.serialize()
-- itself would ever produce for real game data.
local function reserveParsedValue(budget, depth)
	if depth > budget.maxDepth or budget.remainingValues <= 0 then
		return false
	end

	budget.remainingValues = budget.remainingValues - 1
	return true
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
local function parseSerializedValue(s, i, len, depth, budget)
	if not reserveParsedValue(budget, depth) then
		return false
	end

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
		-- Fast path: scan once for the first backslash, matching quote, or raw
		-- CR/LF. An unescaped string (the common case) is returned as a single
		-- slice with no per-character buffer at all. A raw newline before any
		-- escape/quote is rejected here -- string.format("%q", x) always
		-- escapes a literal newline as backslash + the newline byte, so an
		-- un-escaped one can't be genuine %q output. No terminator found at
		-- all means an unterminated string.
		local firstSpecial = s:find(quote == '"' and '[\\"\r\n]' or "[\\'\r\n]", i + 1)
		if not firstSpecial then
			return false
		end

		local special = s:sub(firstSpecial, firstSpecial)
		if special == quote then
			return true, s:sub(i + 1, firstSpecial - 1), firstSpecial + 1
		end
		if special ~= "\\" then
			return false
		end

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
				elseif esc == "\\" or esc == '"' or esc == "'" then
					-- Only the escapes string.format("%q", x) itself emits are
					-- accepted; anything else (e.g. \x41, \a, \q) previously
					-- fell through to a catch-all that silently kept just the
					-- character after the backslash, quietly turning "\x41"
					-- into "x41" instead of rejecting it as malformed.
					out[#out + 1] = esc
					j = j + 2
				elseif esc == "\n" or esc == "\r" then
					-- %q's own line-continuation escape: backslash immediately
					-- followed by a literal newline byte (optionally paired
					-- with its CR/LF counterpart), representing one logical \n.
					local following = s:sub(j + 2, j + 2)
					out[#out + 1] = "\n"
					j = j + 2
					if (esc == "\r" and following == "\n") or (esc == "\n" and following == "\r") then
						j = j + 1
					end
				else
					return false
				end
			elseif ch == quote then
				return true, table.concat(out), j + 1
			elseif ch == "\n" or ch == "\r" then
				return false
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
			-- Only whitespace is skipped here -- the single separating comma
			-- after each value is already consumed below, so a comma
			-- reappearing at this point (leading or repeated, e.g. "{,}" or
			-- "{[1]=1,,[2]=2}") is malformed and must fall through to the
			-- value parser to be rejected, not be silently swallowed.
			while i <= len do
				local ch = s:sub(i, i)
				if ch:match("%s") then
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
				local okKey, parsedKey, afterKey = parseSerializedValue(s, i + 1, len, depth + 1, budget)
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
			local okVal, val, afterVal = parseSerializedValue(s, i, len, depth + 1, budget)
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
	-- maxDepth and remainingValues are generous relative to anything
	-- table.serialize() itself produces for real game data -- they exist to
	-- bound work on adversarial input, not to constrain legitimate saves.
	local budget = { maxDepth = 64, remainingValues = 200000 }
	local ok, result, nextIndex = parseSerializedValue(str, 1, len, 1, budget)
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
