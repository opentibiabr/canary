local internalNpcName = "Karl"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 58,
	lookBody = 49,
	lookLegs = 70,
	lookFeet = 115,
	lookAddons = 0
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


	if MsgContains(message, 'barrel') then
		if player:getStorageValue(Storage.SecretService.AVINMission03) == 2 then
			npcHandler:say('Do you bring me a barrel of beer??', npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, 'whisper beer') then
		if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 11 then
			npcHandler:say('Do you want to buy a bottle of our finest whisper beer for 80 gold?', npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			if player:removeItem(404, 1) then
				player:setStorageValue(Storage.SecretService.AVINMission03, 3)
				npcHandler:say('Three cheers for the noble |PLAYERNAME|.', npc, creature)
			else
				npcHandler:say("You don't have any barrel of beer!", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 11 then
				if player:removeMoneyBank(80) then
					npcHandler:say("Here. Don't take it into the city though.", npc, creature)
					player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 12)
					player:addItem(6106, 1)
					npcHandler:setTopic(playerId, 0)
				else
					npcHandler:say("You don't have enough money.", npc, creature)
				end
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back, but don't tell others.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back, but don't tell others.")
npcHandler:setMessage(MESSAGE_GREET, 'Pshhhht! Not that loud ... but welcome.')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bottle of whisper beer", clientId = 6106, buy = 80 },
	{ itemName = "mug of beer", clientId = 2880, buy = 20, count = 3 }
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
