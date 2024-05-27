local internalNpcName = "Cheaty"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1378,
	lookHead = 78,
	lookBody = 78,
	lookLegs = 90,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
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
	local questline = player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine)

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end
	if MsgContains(message, "name") or MsgContains(message, "cheaty") then
		npcHandler:say("I am Cheaty Chief, just call me Cheaty, no need for formalities like calling me Miss. <chuckles>", npc, creature)
	elseif MsgContains(message, "draccoon") then
		npcHandler:say("The Draccoon is a magnificent creature, somewhat like a rascoohan, somewhat like a dragon. ...", npc, creature)
		npcHandler:say("He taught me my first few spells when I was a little cub.", npc, creature, 2000)
	elseif MsgContains(message, "venore") then
		npcHandler:say("Ah, good old Venore, the city of trash.", npc, creature)
	elseif MsgContains(message, "talk") then
		player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 0)
		npcHandler:say("The Draccoon has just returned after a longer inconvenient absence. He could use the help of some talented individuals and has a mission for them. Are you interested, {yes} or {no}?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 and questline < 1 then
			npcHandler:say("Search for the entrance to the secret lair of the {Draccoon} at the Venore dumpster!", npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 1)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Oh, well, if you change your mind, you know where to find me!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, |PLAYERNAME|! My friend, the Draccoon, wants to have a {talk} with you!")

npcHandler:setMessage(MESSAGE_FAREWELL, "Bye, bye, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
