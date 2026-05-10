local internalNpcName = "Test Server"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1875,
	lookHead = 58,
	lookBody = 68,
	lookLegs = 109,
	lookFeet = 115,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome to Test Server")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back from time to time.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back from time to time.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

local function buildEquipmentShopFromItemsXml()
	local xmlPath = "data/items/items.xml"
	local file = io.open(xmlPath, "r")
	if not file then
		print(string.format("[Test Server NPC] Could not open %s", xmlPath))
		return {}
	end

	local xmlContent = file:read("*a")
	file:close()

	local validSlots = {
		head = true, -- helmet
		armor = true, -- armor
		legs = true, -- legs
		feet = true, -- boots
		ring = true, -- rings
		necklace = true, -- amulets
		shield = true, -- shields
		ammo = true, -- trinkets
	}

	local slotOrder = {
		head = 1,
		armor = 2,
		legs = 3,
		feet = 4,
		ring = 5,
		necklace = 6,
		shield = 7,
		ammo = 8,
	}

	local entries = {}
	local seenNames = {}
	local excludedItems = {
		["crystal bolt"] = true,
	}

	for itemAttributes, itemBody in xmlContent:gmatch("<item%s+([^>]-)%s*>(.-)</item>") do
		-- Ignore self-closing tags (<item .../>) to avoid leaking the next item's body.
		if itemAttributes:sub(-1) == "/" then
			goto continue
		end

		local paddedAttributes = " " .. itemAttributes
		local itemId = paddedAttributes:match('%sid="(%d+)"')
		local itemName = paddedAttributes:match('%sname="([^"]+)"')
		if itemId and itemName then
			local hasStat = itemBody:find('key="armor"') or itemBody:find('key="attack"') or itemBody:find('key="defense"')
			if hasStat then
				local selectedSlot = nil
				for slot in itemBody:gmatch('<attribute%s+key="slot"%s+value="([^"]+)"[^>]*>') do
					if validSlots[slot] then
						selectedSlot = slot
						break
					end
				end

				local normalizedName = itemName:lower()
				if selectedSlot and not excludedItems[normalizedName] and not seenNames[normalizedName] then
					seenNames[normalizedName] = true
					entries[#entries + 1] = {
						itemName = itemName,
						clientId = tonumber(itemId),
						buy = 1,
						_slotOrder = slotOrder[selectedSlot] or 99,
					}
				end
			end
		end

		::continue::
	end

	-- Mandatory test server items.
	local forcedItems = {
		{ itemName = "crystal coin", clientId = 3043, buy = 1, _slotOrder = 0 },
	}

	for _, forcedItem in ipairs(forcedItems) do
		local normalizedName = forcedItem.itemName:lower()
		if not seenNames[normalizedName] then
			seenNames[normalizedName] = true
			entries[#entries + 1] = forcedItem
		end
	end

	table.sort(entries, function(a, b)
		if a._slotOrder == b._slotOrder then
			return a.itemName < b.itemName
		end
		return a._slotOrder < b._slotOrder
	end)

	for index = 1, #entries do
		entries[index]._slotOrder = nil
	end

	return entries
end

npcConfig.shop = buildEquipmentShopFromItemsXml()
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
