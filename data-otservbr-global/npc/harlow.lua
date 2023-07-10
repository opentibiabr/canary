local internalNpcName = "Harlow"
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
	lookHead = 116,
	lookBody = 77,
	lookLegs = 113,
	lookFeet = 0,
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
	if message then
		npcHandler:say("What the heck, stop bothering me with your questions.", npc, creature)
	end
end
--Travel
local travelNode = keywordHandler:addKeyword({'vengoth'}, StdModule.say, {npcHandler = npcHandler, text = "So you are saying you're looking for someone to take you to Vengoth?"}, function(player) return player:getStorageValue(BloodBrothers.VengothAccess) == 1 end)
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'Oh well.'})
	local travelNodeYes = travelNode:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = "I could do that, it's not far from here. I don't run a charity organisation, though. Tell you what. Give me 100 gold pieces, and me and my boat are yours for the trip. Okay?"})
		travelNodeYes:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, text = "Okay. Enjoy.", premium = false, cost = 100, destination = Position(32858, 31549, 7)})
		travelNodeYes:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'Oh well.'})
travelNode = keywordHandler:addKeyword({"transportation"}, StdModule.say, {npcHandler = npcHandler, text = "Want me to bring you to Vengoth again for 100 gold?"}, function(player) return player:getStorageValue(BloodBrothers.VengothAccess) == 1 end)
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, text = "Okay. Enjoy.", premium = false, cost = 100, destination = Position(32858, 31549, 7)})
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'Oh well.'})
--Basic
keywordHandler:addKeyword({"busy"}, StdModule.say, {npcHandler = npcHandler, text = "I have a {job}, you know?"})
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "Well, I'm kind of a delivery man I guess. I take on small {transportation} jobs with my boat."})


npcHandler:setMessage(MESSAGE_GREET, "What do you want, |PLAYERNAME|? I'm a {busy} man.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
