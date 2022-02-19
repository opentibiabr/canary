registerNpcType = {}
setmetatable(registerNpcType,
{
	__call =
	function(self, npcType, mask)
		for _,parse in pairs(self) do
			parse(npcType, mask)
		end
	end
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

registerNpcType.speechBubble = function(npcType, mask)
	local speechBubble = npcType:speechBubble()
	if mask.speechBubble then
		npcType:speechBubble(mask.speechBubble)
	elseif speechBubble == 3 then
		npcType:speechBubble(4)
	elseif speechBubble < 1 then
		npcType:speechBubble(1)
	else
		npcType:speechBubble(2)
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

registerNpcType.shop = function(npcType, mask)
	if type(mask.shop) == "table" then
		for _, shopItem in pairs(mask.shop) do
			npcType:addShopItem(shopItem)
		end
	end
end

registerNpcType.currency = function(npcType, mask)
	if mask.currency then
		npcType:currency(mask.currency)
	end
end
