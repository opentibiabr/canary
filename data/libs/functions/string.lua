-- Function that splits a string into parts using a separator
-- Parameters: str (string) - the string to be split, sep (string) - the separator to be used
-- Returns: a table containing the separated parts of the string
string.split = function(str, sep)
	local res = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		res[#res + 1] = v
	end
	return res
end

-- Function that removes whitespace from the beginning and end of a string
-- Parameters: str (string) - the string to be modified
-- Returns: the string without whitespace at the beginning and end
string.trim = function(str)
	return str:match'^()%s*$' and '' or str:match'^%s*(.*%S)'
end

-- Function that checks if a string starts with a specific substring
-- Parameters: str (string) - the string to be checked, substr (string) - the substring to be searched for
-- Returns: true if the string starts with the substring, false otherwise
string.starts = function(str, substr)
	return string.sub(str, 1, #substr) == substr
end

-- Function that converts a string where each word starts with an uppercase letter
-- Parameters: str (string) - the string to be modified
-- Returns: the string with each word starting with an uppercase letter
string.titleCase = function(str)
	return str:gsub("(%a)([%w_']*)", function(first, rest) return first:upper() .. rest:lower() end)
end

-- Function that converts a time interval into a human-readable format
-- Parameters: diff (number) - the time interval in seconds
-- Returns: a string representing the time interval in a readable format
string.diff = function(diff)
	local format = {
		{'day', diff / 60 / 60 / 24},
		{'hour', diff / 60 / 60 % 24},
		{'minute', diff / 60 % 60},
		{'second', diff % 60}
	}

	local out = {}
	for k, t in ipairs(format) do
		local v = math.floor(t[2])
		if(v > 0) then
			table.insert(out, (k < #format and (#out > 0 and ', ' or '') or ' and ') .. v .. ' ' .. t[1] .. (v ~= 1 and 's' or ''))
		end
	end
	local ret = table.concat(out)
	if ret:len() < 16 and ret:find('second') then
		local a, b = ret:find(' and ')
		ret = ret:sub(b+1)
	end
	return ret
end

-- Function that removes whitespace from the beginning and end of a string
-- Parameters: str (string) - the string to be modified
-- Returns: the string without whitespace at the beginning and end
string.trimSpace = function(str)
	return str:gsub("^%s*(.-)%s*$", "%1")
end

-- Function that splits a string into parts using a separator
-- Parameters: str (string) - the string to be split, sep (string) - the separator to be used
-- Returns: a table containing the separated parts of the string
string.split = function(str, sep)
	local res = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		res[#res + 1] = v
	end
	return res
end

-- Function that splits a string into parts using a separator, and trims whitespace from each part
-- Parameters: str (string) - the string to be split, sep (string) - the separator to be used
-- Returns: a table containing the separated parts of the string with whitespace removed from each part
string.splitTrimmed = function(str, sep)
	local res = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		res[#res + 1] = v:trim()
	end
	return res
end

-- Function that removes whitespace from the beginning and end of a string
-- Parameters: str (string) - the string to be modified
-- Returns: the string without whitespace at the beginning and end
string.trim = function(str)
	return str:match('^%s*(.*%S)') or ''
end

-- Function to format a string with a table of arguments
-- Parameters: str (string) - the string to be formatted, args (table) - the table of arguments to be used
-- Returns: the formatted string
-- Example: string.formatNamed("Hello ${name}!", {name = "World"}) -> "Hello World!"
string.formatNamed = function(str, args)
	return (str:gsub('($%b{})', function(w) return args[w:sub(3, -2)] or w end))
end
