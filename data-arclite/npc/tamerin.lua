local internalNpcName = "Tamerin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 153,
	lookHead = 58,
	lookBody = 119,
	lookLegs = 120,
	lookFeet = 121,
	lookAddons = 3
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

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.InServiceofYalahar.Questline) == 30 then
		npcHandler:setMessage(MESSAGE_GREET, "Have you the {animal cure}?")
	elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 31 then
		npcHandler:setMessage(MESSAGE_GREET, "Have you killed {morik}?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hello, what brings you here?")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.InServiceofYalahar.Questline) == 29 then
			npcHandler:say({
				"Why should I do something for another human being? I have been on my own for all those years. Hmm, but actually there is something I could need some assistance with. ... ",
				"If you help me to solve my problems, I will help you with your mission. Do you accept?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 32 then
			npcHandler:say("You have kept your promise. Now, it's time to fulfil my part of the bargain. What kind of animals shall I raise? {Warbeasts} or {cattle}?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "animal cure") then
		if player:getStorageValue(Storage.InServiceofYalahar.Questline) == 30 and player:removeItem(8819, 1) then
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 31)
			player:setStorageValue(Storage.InServiceofYalahar.MorikSummon, 0)
			player:setStorageValue(Storage.InServiceofYalahar.Mission05, 4) -- StorageValue for Questlog "Mission 05: Food or Fight"
			npcHandler:say("Thank you very much. As I said, as soon as you have helped me to solve both of my problems, we will talk about your mission. Have you killed {morik}?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Come back when you have the cure.", npc, creature)
		end
	elseif MsgContains(message, "cattle") then
		if npcHandler:getTopic(playerId) == 2 then
			player:setStorageValue(Storage.InServiceofYalahar.TamerinStatus, 1)
			player:setStorageValue(Storage.InServiceofYalahar.Mission05, 6) -- StorageValue for Questlog "Mission 05: Food or Fight"
			npcHandler:say("So be it!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "warbeast") then
		if npcHandler:getTopic(playerId) == 2 then
			player:setStorageValue(Storage.InServiceofYalahar.TamerinStatus, 2)
			player:setStorageValue(Storage.InServiceofYalahar.Mission05, 7) -- StorageValue for Questlog "Mission 05: Food or Fight"
			npcHandler:say("So be it!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "morik") then
		if player:getStorageValue(Storage.InServiceofYalahar.Questline) == 31 and player:removeItem(8820, 1) then
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 32)
			player:setStorageValue(Storage.InServiceofYalahar.Mission05, 5) -- StorageValue for Questlog "Mission 05: Food or Fight"
			npcHandler:say("So he finally got what he deserved. As I said, as soon as you have helped me to solve both of my problems, we will talk about your {mission}.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Come back when you got rid with Morik.", npc, creature)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 30)
			player:setStorageValue(Storage.InServiceofYalahar.Mission05, 3) -- StorageValue for Questlog "Mission 05: Food or Fight"
			npcHandler:say("I ask you for two things! For one thing, I need an animal cure and for another thing, I ask you to get rid of the gladiator Morik for me.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
