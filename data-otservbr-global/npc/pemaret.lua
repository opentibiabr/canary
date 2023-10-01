local internalNpcName = "Pemaret"
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
	lookHead = 79,
	lookBody = 10,
	lookLegs = 126,
	lookFeet = 126,
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

	if MsgContains(message, "marlin") then
		if player:getItemCount(901) > 0 then
			npcHandler:say("WOW! You have a marlin!! I could make a nice decoration for your wall from it. May I have it?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		if player:removeItem(901, 1) then
			npcHandler:say("Yeah! Now let's see... <fumble fumble> There you go, I hope you like it!", npc, creature)
			player:addItem(902, 1)
		else
			npcHandler:say("You don't have the fish.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	if MsgContains(message, "no") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Then no.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

-- Travel
local function addTravelKeyword(keyword, text, cost, destination)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Maybe later.', reset = true})
end

addTravelKeyword('edron', 'Do you want to get to Edron for |TRAVELCOST|?', 20, Position(33176, 31764, 6))
addTravelKeyword('eremo', 'Oh, you know the good old sage Eremo. I can bring you to his little island. Do you want me to do that?', 0, Position(33314, 31883, 7))

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(33293, 31957, 6), Position(33294, 31955, 6), Position(33294, 31958, 6)}})

-- Basic
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a fisherman and I take along people to Edron. You can also buy some fresh fish.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a fisherman and I take along people to Edron. You can also buy some fresh fish.'})
keywordHandler:addKeyword({'fish'}, StdModule.say, {npcHandler = npcHandler, text = 'My fish is of the finest quality you could find. Ask me for a trade to check for yourself.'})
keywordHandler:addKeyword({'cormaya'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s a lovely and peaceful isle. Did you already visit the nice sandy beach?'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Pemaret, the fisherman.'})

npcHandler:setMessage(MESSAGE_GREET, "Greetings, young man. Looking for a passage or some fish, |PLAYERNAME|?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "fish", clientId = 3578, buy = 5 },
	{ itemName = "green perch", clientId = 7159, sell = 100 },
	{ itemName = "marlin", clientId = 901, sell = 800 },
	{ itemName = "northern pike", clientId = 3580, sell = 100 },
	{ itemName = "rainbow trout", clientId = 7158, sell = 100 },
	{ itemName = "shimmer swimmer", clientId = 12557, sell = 3000 }
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
