-- Advanced NPC System by Jiddo

if KeywordHandler == nil then

	KeywordNode = {
		keywords = nil,
		callback = nil,
		parameters = nil,
		children = nil,
		parent = nil,
		condition = nil,
		action = nil
	}

	-- Created a new keywordnode with the given keywords, callback function and parameters and without any childNodes.
	function KeywordNode:new(keys, func, param, condition, action)
		local obj = {}
		obj.keywords = keys
		obj.callback = func
		obj.parameters = param
		obj.children = {}
		obj.condition = condition
		obj.action = action
		setmetatable(obj, self)
		self.__index = self
		return obj
	end

	-- Calls the underlying callback function if it is not nil.
	function KeywordNode:processMessage(cid, message)
		return (self.callback == nil or self.callback(cid, message, self.keywords, self.parameters, self))
	end

	function KeywordNode:processAction(cid, message)
		if not self.action then
			return
		end

		local player = Player(cid)
		if not player then
			return
		end

		self.action(player, self.parameters.npcHandler, message)
	end

	-- Returns true if message contains all patterns/strings found in keywords.
	function KeywordNode:checkMessage(cid, message)
		if self.keywords.callback ~= nil then
			local ret, data = self.keywords.callback(self.keywords, message)
			if not ret then
				return false
			end

			if self.condition and not self.condition(Player(cid), data) then
				return false
			end
			return true
		end

		local data = {}
		local last = 0
		for _, keyword in ipairs(self.keywords) do
			if type(keyword) == 'string' then
				local a, b = string.find(message, keyword)
				if a == nil or b == nil or a < last then
					return false
				end
				if keyword:sub(1, 1) == '%' then
					data[#data + 1] = tonumber(message:sub(a, b)) or nil
				end
				last = a
			end
		end

		if self.condition and not self.condition(Player(cid), data) then
			return false
		end
		return true
	end

	-- Returns the parent of this node or nil if no such node exists.
	function KeywordNode:getParent()
		return self.parent
	end

	-- Returns an array of the callback function parameters assosiated with this node.
	function KeywordNode:getParameters()
		return self.parameters
	end

	-- Returns an array of the triggering keywords assosiated with this node.
	function KeywordNode:getKeywords()
		return self.keywords
	end

	-- Adds a childNode to this node. Creates the childNode based on the parameters (k = keywords, c = callback, p = parameters)
	function KeywordNode:addChildKeyword(keywords, callback, parameters, condition, action)
		local new = KeywordNode:new(keywords, callback, parameters, condition, action)
		return self:addChildKeywordNode(new)
	end

	function KeywordNode:addAliasKeyword(keywords)
		if #self.children == 0 then
			Spdlog.error('[KeywordNode:addAliasKeyword] - No previous node found')
			return false
		end

		local prevNode = self.children[#self.children]
		local new = KeywordNode:new(keywords, prevNode.callback, prevNode.parameters, prevNode.condition, prevNode.action)
		for i = 1, #prevNode.children do
			new:addChildKeywordNode(prevNode.children[i])
		end
		return self:addChildKeywordNode(new)
	end

	-- Adds a pre-created childNode to this node. Should be used for example if several nodes should have a common child.
	function KeywordNode:addChildKeywordNode(childNode)
		self.children[#self.children + 1] = childNode
		childNode.parent = self
		return childNode
	end

	KeywordHandler = {
		root = nil,
		lastNode = nil
	}

	-- Creates a new keywordhandler with an empty rootnode.
	function KeywordHandler:new()
		local obj = {}
		obj.root = KeywordNode:new(nil, nil, nil)
		obj.lastNode = {}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end

	-- Resets the lastNode field, and this resetting the current position in the node hierarchy to root.
	function KeywordHandler:reset(cid)
		if self.lastNode[cid] then
			self.lastNode[cid] = nil
		end
	end

	-- Makes sure the correct childNode of lastNode gets a chance to process the message.
	function KeywordHandler:processMessage(cid, message)
		local node = self:getLastNode(cid)
		if node == nil then
			error('No root node found.')
			return false
		end

		local ret = self:processNodeMessage(node, cid, message)
		if ret then
			return true
		end

		if node:getParent() then
			node = node:getParent() -- Search through the parent.
			local ret = self:processNodeMessage(node, cid, message)
			if ret then
				return true
			end
		end

		if node ~= self:getRoot() then
			node = self:getRoot() -- Search through the root.
			local ret = self:processNodeMessage(node, cid, message)
			if ret then
				return true
			end
		end
		return false
	end

	-- Tries to process the given message using the node parameter's children and calls the node's callback function if found.
	--	Returns the childNode which processed the message or nil if no such node was found.
	function KeywordHandler:processNodeMessage(node, cid, message)
		local messageLower = message:lower()
		for _, childNode in pairs(node.children) do
			if childNode:checkMessage(cid, messageLower) then
				local oldLast = self.lastNode[cid]
				self.lastNode[cid] = childNode
				childNode.parent = node -- Make sure node is the parent of childNode (as one node can be parent to several nodes).
				if childNode:processMessage(cid, message) then
					childNode:processAction(cid, message)
					return true
				end
				self.lastNode[cid] = oldLast
			end
		end
		return false
	end

	-- Returns the root keywordnode
	function KeywordHandler:getRoot()
		return self.root
	end

	-- Returns the last processed keywordnode or root if no last node is found.
	function KeywordHandler:getLastNode(cid)
		return self.lastNode[cid] or self:getRoot()
	end

	-- Adds a new keyword to the root keywordnode. Returns the new node.
	function KeywordHandler:addKeyword(keys, callback, parameters, condition, action)
		return self:getRoot():addChildKeyword(keys, callback, parameters, condition, action)
	end

	-- Adds an alias keyword for the previous node.
	function KeywordHandler:addAliasKeyword(keys)
		return self:getRoot():addAliasKeyword(keys)
	end

	-- Moves the current position in the keyword hierarchy count steps upwards. Count defalut value = 1.
	--	This function MIGHT not work properly yet. Use at your own risk.
	function KeywordHandler:moveUp(cid, steps)
		if steps == nil or type(steps) ~= "number" then
			steps = 1
		end
		for i = 1, steps do
			if self.lastNode[cid] == nil then
				return nil
			end
			self.lastNode[cid] = self.lastNode[cid]:getParent() or self:getRoot()
		end
		return self.lastNode[cid]
	end
end
