local internalNpcName = "Grombur"
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
	lookHead = 114,
	lookBody = 77,
	lookLegs = 79,
	lookFeet = 114
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


	if MsgContains(message, "nokmir") then
		if player:getStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll) == 2 then
			npcHandler:say("Oh well, I liked Nokmir. He used to be a good dwarf until that day on which he stole the ring from {Rerun}.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "rerun") then
		if npcHandler:getTopic(playerId) == 1 then
			player:setStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll, 3)
			npcHandler:say("Yeah, he's the lucky guy in this whole story. I heard rumours that emperor Rehal had plans to promote Nokmir, but after this whole thievery story, he might pick Rerun instead.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "mission") then
		if player:getStorageValue(Storage.HiddenCityOfBeregar.TheGoodGuard) < 1 then
			npcHandler:say("Got any dwarven brown ale?? I DON'T THINK SO....and Bolfana, the tavern keeper, won't sell you anything. I'm sure about that...she doesn't like humans... I tell you what, if you get me a cask of dwarven brown ale, I allow you to enter the mine. Alright?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.HiddenCityOfBeregar.TheGoodGuard) == 1 and player:removeItem(8774, 1) then
			player:setStorageValue(Storage.HiddenCityOfBeregar.TheGoodGuard, 2)
			player:setStorageValue(Storage.HiddenCityOfBeregar.DoorSouthMine, 1)
			npcHandler:say("HOW?....WHERE?....AHHHH, I don't mind....SLUUUUUURP....tastes a little flat but I had worse. Thank you. Just don't tell anyone that I let you in.", npc, creature)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			player:setStorageValue(Storage.HiddenCityOfBeregar.TheGoodGuard, 1)
			player:setStorageValue(Storage.HiddenCityOfBeregar.DefaultStart, 1)
			npcHandler:say("Haha, fine! Don't waste time and get me the ale. See you.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "See you my friend.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you my friend.")
npcHandler:setMessage(MESSAGE_GREET, "STOP RIGHT THERE!..... Oh, just a human. What's up big guy?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
