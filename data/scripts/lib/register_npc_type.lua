registerNpcType = {}
setmetatable(registerNpcType, {
	__call = function(self, npcType, mask)
		for _, parse in pairs(self) do
			parse(npcType, mask)
		end
	end,
})

NpcType.register = function(self, mask)
	return registerNpcType(self, mask)
end

registerNpcType.name = function(npcType, mask)
	if mask.name then
		npcType:name(mask.name)
	end
end

registerNpcType.description = function(npcType, mask)
	if mask.description then
		npcType:nameDescription(mask.description)
	end
end

registerNpcType.outfit = function(npcType, mask)
	if mask.outfit then
		npcType:outfit(mask.outfit)
	end
end

registerNpcType.maxHealth = function(npcType, mask)
	if mask.maxHealth then
		npcType:maxHealth(mask.maxHealth)
	end
end

registerNpcType.health = function(npcType, mask)
	if mask.health then
		npcType:health(mask.health)
	end
end

registerNpcType.race = function(npcType, mask)
	if mask.race then
		npcType:race(mask.race)
	end
end

registerNpcType.walkInterval = function(npcType, mask)
	if mask.walkInterval then
		npcType:walkInterval(mask.walkInterval)
	end
end

registerNpcType.walkRadius = function(npcType, mask)
	if mask.walkRadius then
		npcType:walkRadius(mask.walkRadius)
	end
end

registerNpcType.speed = function(npcType, mask)
	if mask.speed then
		npcType:baseSpeed(mask.speed)
	end
end

registerNpcType.flags = function(npcType, mask)
	if mask.flags then
		if mask.flags.floorchange ~= nil then
			npcType:floorChange(mask.flags.floorchange)
		end
		if mask.flags.canPushCreatures ~= nil then
			npcType:canPushCreatures(mask.flags.canPushCreatures)
		end
		if mask.flags.canPushItems ~= nil then
			npcType:canPushItems(mask.flags.canPushItems)
		end
		if mask.flags.pushable ~= nil then
			npcType:isPushable(mask.flags.pushable)
		end
	end
end

registerNpcType.light = function(npcType, mask)
	if mask.light then
		if mask.light.color then
			local color = mask.light.color
		end
		if mask.light.level then
			npcType:light(color, mask.light.level)
		end
	end
end

registerNpcType.respawnType = function(npcType, mask)
	if mask.respawnType then
		if mask.respawnType.period then
			npcType:respawnTypePeriod(mask.respawnType.period)
		end
		if mask.respawnType.underground then
			npcType:respawnTypeIsUnderground(mask.respawnType.underground)
		end
	end
end

registerNpcType.sounds = function(npcType, mask)
	if type(mask.sounds) == "table" then
		if mask.sounds.ticks and mask.sounds.chance and mask.sounds.ids and type(mask.sounds.ids) == "table" and #mask.sounds.ids > 0 then
			npcType:soundSpeedTicks(mask.sounds.ticks)
			npcType:soundChance(mask.sounds.chance)
			for _, v in pairs(mask.sounds.ids) do
				npcType:addSound(v)
			end
		end
	end
end

registerNpcType.voices = function(npcType, mask)
	if type(mask.voices) == "table" then
		local interval, chance
		if mask.voices.interval then
			interval = mask.voices.interval
		end
		if mask.voices.chance then
			chance = mask.voices.chance
		end
		for k, v in pairs(mask.voices) do
			if type(v) == "table" then
				npcType:addVoice(v.text, interval, chance, v.yell)
			end
		end
	end
end

registerNpcType.events = function(npcType, mask)
	if type(mask.events) == "table" then
		for k, v in pairs(mask.events) do
			npcType:registerEvent(v)
		end
	end
end

-- Global item tracker to track buy and sell prices across all NPCs
NpcPriceChecker = NpcPriceChecker or {}

registerNpcType.shop = function(npcType, mask)
	if type(mask.shop) == "table" then
		for _, shopItems in pairs(mask.shop) do
			local parent = Shop()
			local itemName = shopItems.itemName or shopItems.itemname
			local clientId = shopItems.clientId or shopItems.clientid
			local buyPrice = shopItems.buy
			local sellPrice = shopItems.sell
			local npcName = npcType:getName() -- Assuming `npcType` has a `getName` method to get the NPC's name

			if itemName then
				parent:setNameItem(itemName)
			end
			if clientId then
				parent:setId(clientId)
			end
			if shopItems.subType or shopItems.subtype or shopItems.count then
				parent:setCount(shopItems.subType or shopItems.subtype or shopItems.count)
			end
			if buyPrice then
				parent:setBuyPrice(buyPrice)
			end
			if sellPrice then
				parent:setSellPrice(sellPrice)
			end

			if clientId then
				if not NpcPriceChecker[clientId] then
					NpcPriceChecker[clientId] = { buy = nil, sell = nil, buyNpc = nil, sellNpc = nil }
				end

				if buyPrice then
					NpcPriceChecker[clientId].buy = buyPrice
					NpcPriceChecker[clientId].buyNpc = npcName
				end

				if sellPrice then
					NpcPriceChecker[clientId].sell = sellPrice
					NpcPriceChecker[clientId].sellNpc = npcName
				end

				if NpcPriceChecker[clientId].buy and NpcPriceChecker[clientId].sell then
					if NpcPriceChecker[clientId].sell > NpcPriceChecker[clientId].buy then
						logger.warn("The item {} ({}) is being sold for a value greater than the value it is purchased for by the NPCs. Buy NPC: {}, Sell NPC: {}", itemName, clientId, NpcPriceChecker[clientId].buyNpc, NpcPriceChecker[clientId].sellNpc)
					end
				end
			end

			if shopItems.storageKey or shopItems.storagekey then
				parent:setStorageKey(shopItems.storageKey or shopItems.storagekey)
			end
			if shopItems.storageValue or shopItems.storagevalue then
				parent:setStorageValue(shopItems.storageValue or shopItems.storagevalue)
			end
			if shopItems.child then
				for _, children in pairs(shopItems.child) do
					local child = Shop()
					if children.itemName or children.itemname then
						child:setNameItem(children.itemName or children.itemname)
					end
					if children.clientId or children.clientid then
						child:setId(children.clientId or children.clientid)
					end
					if children.subType or children.subtype or children.count then
						child:setCount(children.subType or children.subtype or children.count)
					end
					if children.buy then
						child:setBuyPrice(children.buy)
					end
					if children.sell then
						child:setSellPrice(children.sell)
					end
					if children.storageKey or children.storagekey then
						child:setStorageKey(children.storageKey or children.storagekey)
					end
					if children.storageValue or children.storagevalue then
						child:setStorageValue(children.storageValue or children.storagevalue)
					end
					parent:addChildShop(child)
				end
			end
			npcType:addShopItem(parent)
		end
	end
end

registerNpcType.currency = function(npcType, mask)
	if mask.currency then
		npcType:currency(mask.currency)
	end
end

registerNpcType.speechBubble = function(npcType, mask)
	if mask.speechBubble then
		npcType:speechBubble(mask.speechBubble)
	end
end
