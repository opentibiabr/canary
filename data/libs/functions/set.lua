---@class Set
---@field values table
---@field options table
---@field options.insensitive boolean
---@method contains(key: any): boolean
---@method insert(key: any): void
---@method remove(key: any): void
---@method union(other: Set): Set
---@method intersection(other: Set): Set
---@method iter(): function
---@method __eq(other: Set): boolean
---@method __key(k: any): any
---@method __len(): number
---@method __tostring(): string
Set = {}

---@param initial table|Set
---@param options table
---@return Set
setmetatable(Set, {
	__call = function(self, initial, options)
		local set = setmetatable({
			values = {},
			options = options or {},
		}, { __index = Set })
		if Set.isSet(initial) then
			for k in initial:iter() do
				set:insert(k)
			end
		elseif type(initial) == "table" then
			for _, k in ipairs(initial) do
				set:insert(k)
			end
		end
		return set
	end,
})

function Set.isSet(t)
	local meta = getmetatable(t)
	return meta and (meta == Set or meta.__index == Set)
end

function Set:contains(key)
	key = self:__key(key)
	return self.values[key] ~= nil
end

function Set:insert(key)
	key = self:__key(key)
	self.values[key] = true
end

function Set:remove(key)
	if not self:contains(key) then
		return
	end
	key = self:__key(key)
	self.values[key] = nil
end

function Set:union(other)
	local set = Set(self, self.options)
	for k in Set(other, self.options):iter() do
		set:insert(k)
	end
	return set
end

function Set:intersection(other)
	local set = Set({}, self.options)
	for k in Set(other, self.options):iter() do
		if self:contains(k) then
			set:insert(k)
		end
	end
	return set
end

function Set:__eq(other)
	if #self ~= #other then
		return false
	end
	for k in pairs(self.values) do
		if not other:contains(k) then
			return false
		end
	end
	return true
end

function Set:__key(k)
	if self.options.insensitive then
		if type(k) ~= "string" then
			logger.error("key must be a string when insensitive option is enabled")
		end
		k = k:lower()
	end
	return k
end

function Set:iter()
	return pairs(self.values)
end

function Set:__len()
	return #self.values
end

function Set:__tostring()
	local t = {}
	for k in self:iter() do
		table.insert(t, k)
	end
	return "{ " .. table.concat(t, ", ") .. " }"
end

function Set:tostring()
	return self:__tostring()
end

-- Usage:
-- local s = Set({ 1, 2, 3 })
-- s:insert(4)
-- s:remove(2)
-- print(s:contains(1)) -- true
-- print(s:contains(2)) -- false
-- print(s:contains(3)) -- true
-- print(s:contains(4)) -- true
-- print(s:contains(5)) -- false
-- print(#s) -- 3
-- print(s) -- { 1, 3, 4 }
-- for k in s:iter() do
-- 	print(k)
-- end
-- local s2 = Set({ 3, 4, 5 })
-- print(s:union(s2)) -- { 1, 3, 4, 5 }
-- print(s2:union(s)) -- { 3, 4, 5, 1 }
-- print(s:union(s2) == s2:union(s)) -- true
--
-- Strings
-- local s = Set({}, { insensitive = true })
-- s:insert("a")
-- s:insert("B")
-- s:insert("c")
-- print(s) -- { a, b, c }
-- print(s:contains("a")) -- true
-- print(s:contains("A")) -- true
-- print(s:contains("b")) -- true
