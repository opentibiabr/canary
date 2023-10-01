local internalNpcName = "Maris"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 151,
	lookHead = 78,
	lookBody = 51,
	lookLegs = 85,
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

local BloodBrothers = Storage.Quest.U8_4.BloodBrothers
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()
	if message == "cookie" then
		if player:getStorageValue(BloodBrothers.Mission02) == 1 and player:getItemCount(8199) > 0 and player:getStorageValue(BloodBrothers.Cookies.Maris) < 0 then
			npcHandler:say("The good thing about cookies is that they last for a long time. So they are well suited for a boat trip. I'll take some of those, okay?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say("It'd be better for you to leave now.", npc, creature)
		end
	elseif message == "yes" then
		if npcHandler:getTopic(playerId) == 1 and player:removeItem(8199, 1) then -- garlic cookie
			npcHandler:say("Let's try that stuff first - ARRRRRRHH! <coughs> That must have been the worst cookie I've ever eaten. Get off my ship.", npc, creature)
			player:setStorageValue(BloodBrothers.Cookies.Maris, 1)
			npcHandler:setTopic(playerId, 0)
		end
	end
end
-- Travel
local function addTravelKeyword(keyword, cost, destination)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you want go to the ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Alright then!', reset = true})
end

addTravelKeyword('fenrock', 100, Position(32563, 31313, 7))
addTravelKeyword('mistrock', 100, Position(32640, 31439, 7))

-- Basic
keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, text = 'I can take you to {Fenrock} and {Mistrock}!'})
keywordHandler:addAliasKeyword({"passage"})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am Maris, Captain of this ship.'})
keywordHandler:addAliasKeyword({"captain"})
keywordHandler:addKeyword({"alori mort"}, StdModule.say, {npcHandler = npcHandler, text = "Stop mumbling and don't bug me."}, function(player) return player:getStorageValue(BloodBrothers.Mission03) == 1 end)

npcHandler:setMessage(MESSAGE_GREET, "I hope you have a good reason to step near my {ship}, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yeah, bye or whatever.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
