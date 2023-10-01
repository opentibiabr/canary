local internalNpcName = "Maryza"
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
	lookHead = 41,
	lookBody = 51,
	lookLegs = 70,
	lookFeet = 95
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


	if MsgContains(message, 'cookbook') then
		if player:getStorageValue(Storage.MaryzaCookbook) ~= 1 then
			npcHandler:say('The cookbook of the famous dwarven kitchen. You\'re lucky. I have a few copies on sale. Do you like one for 150 gold?', npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say('I\'m sorry but I sell only one copy to each customer. Otherwise they would have been sold out a long time ago.', npc, creature)
		end

	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, 'yes') then
			if not player:removeMoneyBank(150) then
				npcHandler:say('No gold, no sale, that\'s it.', npc, creature)
				return true
			end

			npcHandler:say('Here you are. Happy cooking!', npc, creature)
			player:setStorageValue(Storage.MaryzaCookbook, 1)
			player:addItem(3234, 1)
		elseif MsgContains(message, 'no') then
			npcHandler:say('I have but a few copies, anyway.', npc, creature)
		end
	end
	return true
end

-- Greeting message
keywordHandler:addGreetKeyword({"maryza"}, {npcHandler = npcHandler, text = "Welcome to the Jolly Axeman, |PLAYERNAME|. Have a good time and eat some food!"})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome to the Jolly Axeman, |PLAYERNAME|. Have a good time and eat some food!')
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, buy = 4 },
	{ itemName = "brown bread", clientId = 3602, buy = 3 },
	{ itemName = "cheese", clientId = 3607, buy = 6 },
	{ itemName = "cookie", clientId = 3598, buy = 2 },
	{ itemName = "ham", clientId = 3582, buy = 8 },
	{ itemName = "meat", clientId = 3577, buy = 5 },
	{ itemName = "roll", clientId = 3601, buy = 2 }
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
