string.split = function(str, sep)
	local res = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		res[#res + 1] = v
	end
	return res
end

string.trim = function(str)
	return str:match'^()%s*$' and '' or str:match'^%s*(.*%S)'
end

string.starts = function(str, substr)
	return string.sub(str, 1, #substr) == substr
end

string.titleCase = function(str)
	return str:gsub("(%a)([%w_']*)", function(first, rest) return first:upper() .. rest:lower() end)
end

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
