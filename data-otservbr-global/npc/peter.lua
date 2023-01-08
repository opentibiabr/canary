local internalNpcName = "Peter"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 58,
	lookBody = 43,
	lookLegs = 38,
	lookFeet = 76,
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

	if(MsgContains(message, "report")) then
		if(player:getStorageValue(Storage.InServiceofYalahar.Questline) == 7 or player:getStorageValue(Storage.InServiceofYalahar.Questline) == 13) then
			npcHandler:say("A report? What do they think is happening here? <gives an angry and bitter report>. ", npc, creature)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, player:getStorageValue(Storage.InServiceofYalahar.Questline) + 1)
			player:setStorageValue(Storage.InServiceofYalahar.Mission02, player:getStorageValue(Storage.InServiceofYalahar.Mission02) + 1) -- StorageValue for Questlog "Mission 02: Watching the Watchmen"
			npcHandler:setTopic(playerId, 0)
		end
	elseif isInArray({"pass", "gate"}, message:lower()) then
		npcHandler:say("Pass the gate? If it must be. Are you headed for the {factory} or the former {trade} quarter?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif(MsgContains(message, "factory")) then
		if(npcHandler:getTopic(playerId) == 1) then
			local destination = Position(32859, 31302, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:setTopic(playerId, 0)
		end
	else
		npcHandler:say("Listen, I don't get paid enough to chat with citizens. Move on.", npc, creature)
	end
	return true
end

-- Travel without the need to say "pass", remove or comment this two lines if you want to keep the rpg
keywordHandler:addKeyword({'factory'}, StdModule.travel, {npcHandler = npcHandler, destination = Position(32859, 31302, 7)})
keywordHandler:addKeyword({'trade'}, StdModule.travel, {npcHandler = npcHandler, destination = Position(32854, 31302, 7)})

local function onTradeRequest(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()
	if(npcHandler:getTopic(playerId) == 1) then
		local destination = Position(32854, 31302, 7)
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
		npcHandler:setTopic(playerId, 0)
		npcHandler:say("Be on your guard. Some people are nice, some... aren't.", npc, creature)
	end
	return true
end
--Basic
keywordHandler:addKeyword({"alchemist quarter"}, StdModule.say, {npcHandler = npcHandler, text = "There it's even more smelly than in the factory quarter. Smells a bit like rotten eggs."})
keywordHandler:addKeyword({"arena quarter"}, StdModule.say, {npcHandler = npcHandler, text = "You don't look as if you would last one second there."})
keywordHandler:addKeyword({"augur"}, StdModule.say, {npcHandler = npcHandler, text = "One day I will walk into the office of my superior and announce my resignment. Probably not long from now."})
keywordHandler:addKeyword({"cemetery quarter"}, StdModule.say, {npcHandler = npcHandler, text = "Good idea. Go for a walk there. Preferably six feet down."})
keywordHandler:addKeyword({"factory quarter"}, StdModule.say, {npcHandler = npcHandler, text = "It's too noisy and smelly."})
keywordHandler:addKeyword({"foreign quarter"}, StdModule.say, {npcHandler = npcHandler, text = "Go there if you wanna get beaten up."})
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "Sergeant first class of the Yalaharian Guard Force. But I don't care about ranks and titles."})
keywordHandler:addAliasKeyword({"official"})
keywordHandler:addKeyword({"magician quarter"}, StdModule.say, {npcHandler = npcHandler, text = "I can't stand those arrogant fools."})
keywordHandler:addKeyword({"mission"}, StdModule.say, {npcHandler = npcHandler, text = "Leave me alone with your 'mission' unless you have precise orders from my superiors."})
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "Peter."})
keywordHandler:addKeyword({"sunken quarter"}, StdModule.say, {npcHandler = npcHandler, text = "That quara brood should be extinguished."})
keywordHandler:addKeyword({"trade quarter"}, StdModule.say, {npcHandler = npcHandler, text = "The leader of their pack is the biggest criminal among them all."})
keywordHandler:addKeyword({"quarter"}, StdModule.say, {npcHandler = npcHandler, text = "Count them yourself."})
keywordHandler:addKeyword({"yalahar"}, StdModule.say, {npcHandler = npcHandler, text = "You're here. So what?"})

npcHandler:setMessage(MESSAGE_FAREWELL, "Goodbye citizen!")
npcHandler:setMessage(MESSAGE_GREET, "Hello. Unless you have official business here or want to pass the gate, please move on.")
npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, false)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
