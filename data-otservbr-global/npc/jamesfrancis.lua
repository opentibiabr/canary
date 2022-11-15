local internalNpcName = "Jamesfrancis"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 574,
	lookHead = 96,
	lookBody = 57,
	lookLegs = 38,
	lookFeet = 76,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

local function greetCallback(npc, creature)
	local playerId = creature:getId()

	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.CultsOfTibia.Minotaurs.Access) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Gerimor is right. As an expert for minotaurs I am researching these creatures for years. I thought I already knew a lot but the monsters in this cave are {different}. It's a big {mystery}.")
		npcHandler:setTopic(playerId, 1)
	elseif (player:getStorageValue(Storage.CultsOfTibia.Minotaurs.JamesfrancisTask) >= 0 and player:getStorageValue(Storage.CultsOfTibia.Minotaurs.JamesfrancisTask) <= 50)
	and player:getStorageValue(Storage.CultsOfTibia.Minotaurs.Mission) < 3 then
		npcHandler:setMessage(MESSAGE_GREET, "How is your {mission} going?")
		npcHandler:setTopic(playerId, 5)
	elseif player:getStorageValue(Storage.CultsOfTibia.Minotaurs.Mission) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, {"You say the minotaurs were controlled by a very powerful boss they worshipped. This explains why they had so much more power than the normal ones. ...",
		"I'm very thankful. Please go to the Druid of Crunor and tell him what you've seen. He might be interested in that."})
		player:setStorageValue(Storage.CultsOfTibia.Minotaurs.Mission, 5)
		npcHandler:setTopic(playerId, 10)
	end
	return true
end
npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'Don\'t enter this area if you are an inexperienced fighter! It would be your end!' }
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

	-- Start quest
	if MsgContains(message, "mystery") and npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({"The minotaurs I faced in the cave are much stronger than the normal ones. What I were able to see before I had to flee: all of them seem to belong to a cult worshipping their god. Could you do me a {favour}?"}, npc, creature)
			npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "favour") and npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({"I'd like to work in this cave researching the minotaurs. But right now there are too many of hem and what is more, they are too powerful for me. Could you enter the cave and kill at least 50 of these creatures?"}, npc, creature)
			npcHandler:setTopic(playerId, 3)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 3 then
		if player:getStorageValue(Storage.CultsOfTibia.Questline) < 1 then
			player:setStorageValue(Storage.CultsOfTibia.Questline, 1)
		end
		npcHandler:say({"Very nice. Return to me if you've finished your job."}, npc, creature)
		player:setStorageValue(Storage.CultsOfTibia.Minotaurs.Mission, 2)
		player:setStorageValue(Storage.CultsOfTibia.Minotaurs.JamesfrancisTask, 0)
		player:setStorageValue(Storage.CultsOfTibia.Minotaurs.EntranceAccessDoor, 1)
		npcHandler:setTopic(playerId, 0)
	-- Delivering the quest
	elseif MsgContains(message, "mission") and npcHandler:getTopic(playerId) == 5 then
		if player:getStorageValue(Storage.CultsOfTibia.Minotaurs.JamesfrancisTask) >= 50 then
			npcHandler:say({"Great job! You have killed at least 50 of these monsters. I give this key to you to open the door to the inner area. Go there and find out what's going on."}, npc, creature)
			player:setStorageValue(Storage.CultsOfTibia.Minotaurs.Mission, 3)
			player:setStorageValue(Storage.CultsOfTibia.Minotaurs.AccessDoor, 1)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say({"Come back when you have killed enough minotaurs."}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
