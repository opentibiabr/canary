local internalNpcName = "Talphion"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 160,
	lookHead = 27,
	lookBody = 86,
	lookLegs = 126,
	lookFeet = 127
}

npcConfig.flags = {
	floorchange = false
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "dress pattern") then
		if player:getStorageValue(Storage.Postman.Mission06) == 3 then
			if npcHandler:getTopic(playerId) < 1 then
				npcHandler:say("DRESS FLATTEN? WHO WANTS ME TO FLATTEN A DRESS?", npc, creature)
				npcHandler:setTopic(playerId, 1)
			elseif npcHandler:getTopic(playerId) == 1 then
				npcHandler:say("A PRESS LANTERN? NEVER HEARD ABOUT IT!", npc, creature)
				npcHandler:setTopic(playerId, 2)
			elseif npcHandler:getTopic(playerId) == 2 then
				npcHandler:say("CHESS? I DONT PLAY CHESS!", npc, creature)
				npcHandler:setTopic(playerId, 3)
			elseif npcHandler:getTopic(playerId) == 3 then
				npcHandler:say("A PATTERN IN THIS MESS?? HEY DON'T INSULT MY MACHINEHALL!", npc, creature)
				npcHandler:setTopic(playerId, 4)
			elseif npcHandler:getTopic(playerId) == 4 then
				npcHandler:say("AH YES! I WORKED ON THE DRESS PATTERN FOR THOSE UNIFORMS. STAINLESS TROUSERES, STEAM DRIVEN BOOTS! ANOTHERMARVEL TO BEHOLD! I'LL SENT A COPY TO KEVIN IMEDIATELY!", npc, creature)
				player:setStorageValue(Storage.Postman.Mission06, 4)
				npcHandler:setTopic(playerId, 0)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bolt", clientId = 3446, buy = 5 },
	{ itemName = "crossbow", clientId = 3349, buy = 1150 }
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

npcType:register(npcConfig)
