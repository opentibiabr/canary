local internalNpcName = "Buddel"
local npcType = Game.createNpcType("Buddel (Okolnir)")
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 143,
	lookHead = 19,
	lookBody = 57,
	lookLegs = 22,
	lookFeet = 20,
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

-- Travel
local function addTravelKeyword(keyword, text, destination, randomDestination, randomNumber, condition, ringCheck, ringRemove, helheimAccess)
	if condition then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'No, no, no, you even are no barb....barba...er.. one of us!!!! Talk to the Jarl first!'}, condition)
	end
	if helheimAccess then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = text}, helheimAccess)
	end
	if ringCheck then
		local ring = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = "Ohh, you got a nice ring there! Ya don't have to pay if you gimme the ring and I promise you I will bring you to the correct spot!*HICKS* Alright?"}, ringCheck)
			ring:addChildKeyword({"yes"}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = 0, destination = destination}, ringRemove)
		local normalTravel = ring:addChildKeyword({"no"}, StdModule.say, {npcHandler = npcHandler, text = "Give me 50 gold and I bring you to "..keyword..". 'kay?"})
			normalTravel:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = "You shouldn't miss the experience.", reset = true})
		if randomNumber then
			normalTravel:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = 50, discount = 'postman', destination = destination}, randomNumber)
		end
			normalTravel:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = 50, discount = 'postman', destination = randomDestination}, randomNumber)
	end
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = text, cost = 50, discount = 'postman'})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = "You shouldn't miss the experience.", reset = true})
	if randomNumber then
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = 50, discount = 'postman', destination = destination}, randomNumber)
	end
	travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = 50, discount = 'postman', destination = randomDestination}, randomNumber)
end

local randomDestination = {Position(32255, 31197, 7), Position(32462, 31174, 7), Position(32333, 31227, 7), Position(32021, 31294, 7)}
addTravelKeyword('svargrond', "You know a town nicer than this? NICER DICER! Apropos, don't play dice when you are drunk ...", Position(32255, 31197, 7),
	function() return randomDestination[math.random(#randomDestination)] end,
	function() return math.random(5) > 1 end,
	function(player) return player:getStorageValue(Storage.BarbarianTest.Questline) < 8 end,
	function(player) return player:getItemCount(3097) > 0 end,
	function(player) return player:removeItem(3097, 1) end)
addTravelKeyword('camp', 'Both of you look like you could defend yourself! If you want to go there, ask me for a passage.', Position(32021, 31294, 7),
	function() return randomDestination[math.random(#randomDestination)] end,
	function() return math.random(5) > 1 end,
	function(player) return player:getStorageValue(Storage.BarbarianTest.Questline) < 8 end,
	function(player) return player:getItemCount(3097) > 0 end,
	function(player) return player:removeItem(3097, 1) end)
addTravelKeyword('helheim', "T'at is a small island to the east.", Position(32462, 31174, 7),
	function() return randomDestination[math.random(#randomDestination)] end,
	function() return math.random(5) > 1 end,
	function(player) return player:getStorageValue(Storage.BarbarianTest.Questline) < 8 end,
	function(player) return player:getItemCount(3097) > 0 end,
	function(player) return player:removeItem(3097, 1) end,
	function(player) return player:getStorageValue(Storage.TheIceIslands.Questline) < 30 end)
addTravelKeyword('tyrsung', '*HICKS* Big, big island east of here. Venorian hunters settled there ..... I could bring you north of their camp.', Position(32333, 31227, 7),
	function() return randomDestination[math.random(#randomDestination)] end,
	function() return math.random(5) > 1 end,
	function(player) return player:getStorageValue(Storage.BarbarianTest.Questline) < 8 end,
	function(player) return player:getItemCount(3097) > 0 end,
	function(player) return player:removeItem(3097, 1) end)
-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, text = "Get out o' here!*HICKS*", destination = {Position(32228, 31386, 7)}})

keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = "Where are we at the moment? Is this Svargrond? Ahh yes!*HICKS* Where do you want to go?"})
keywordHandler:addAliasKeyword({"trip"})
keywordHandler:addAliasKeyword({"go"})
keywordHandler:addAliasKeyword({"sail"})

npcHandler:setMessage(MESSAGE_GREET, "Where are we at the moment? Is this {Svargrond}? NO,*HICKS* it's Okolnir! Anyway, where do you want to go?")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "compass", clientId = 10302, sell = 45 }
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
