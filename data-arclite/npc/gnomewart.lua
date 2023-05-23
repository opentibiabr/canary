local internalNpcName = "Gnomewart"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 41,
	lookBody = 100,
	lookLegs = 100,
	lookFeet = 95,
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

	if MsgContains(message, "endurance") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 15 then
			npcHandler:say({
				"Ah, the test is a piece of mushroomcake! Just take the teleporter over there in the south and follow the hallway. ...",
				"You'll need to run quite a bit. It is important that you don't give up! Just keep running and running and running and ... I guess you got the idea. ...",
				"At the end of the hallway you'll find a teleporter. Step on it and you are done! I'm sure you'll do a true gnomerun! Afterwards talk to me."
			}, npc, creature)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 17)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) == 17 then
			npcHandler:say("Just take the teleporter over there to the south and follow the hallway. At the end of the hallway you'll find a teleporter. Step on it and you are done!", npc, creature)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) == 18 then
			npcHandler:say("You have passed the test and are ready to create your soul melody. Talk to Gnomelvis in the east about it.", npc, creature)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 19)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) < 15 then
			npcHandler:say("Your endurance will be tested here when the time comes. For the moment please continue with the other phases of your recruitment.", npc, creature)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) >= 19 then
			npcHandler:say("You have passed the test. If you consider what huge feet you have to move it's quite impressive.", npc, creature)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Oh! Hi there! I guess you are here for the {endurance} test!')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
