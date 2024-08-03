Queue = {}

---@param initial table|Queue
---@param options table
---@return Queue
setmetatable(Queue, {
	__call = function(self)
		local set = setmetatable({
			head = 0,
			tail = -1,
			items = {},
		}, { __index = Queue })
		return set
	end,
})

function Queue:isEmpty()
	return self.head > self.tail
end

function Queue:enqueue(value)
	self.tail = self.tail + 1
	self.items[self.tail] = value
end

function Queue:dequeue()
	if self:isEmpty() then
		error("Queue is empty")
	end

	local value = self.items[self.head]
	self.items[self.head] = nil -- to allow garbage collection
	self.head = self.head + 1
	return value
end

function Queue:peek()
	if self:isEmpty() then
		error("Queue is empty")
	end

	return self.items[self.head]
end

function Queue:size()
	return self.tail - self.head + 1
end

RandomQueue = {}

setmetatable(RandomQueue, {
	__index = Queue,
	__call = function(self)
		local instance = setmetatable(Queue(), { __index = RandomQueue })
		return instance
	end,
})

function RandomQueue:dequeue()
	if self:isEmpty() then
		error("RandomQueue is empty")
	end

	local index = math.random(self.head, self.tail)
	local value = self.items[index]

	-- Move the last item to the place of the removed item to maintain contiguity
	self.items[index] = self.items[self.tail]
	self.items[self.tail] = nil -- to allow garbage collection
	self.tail = self.tail - 1

	return value
end
