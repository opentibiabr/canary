local internalNpcName = "Frafnar"
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
	lookHead = 58,
	lookBody = 119,
	lookLegs = 81,
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

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.HiddenCityOfBeregar.SweetAsChocolateCake) < 1 then
			npcHandler:say("There is indeed something you could do for me. You must know, I'm in love with Bolfana. I'm sure she'd have a beer with me if I got her a chocolate cake. Problem is that I can't leave this door as I'm on duty. Would you be so kind and help me?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.HiddenCityOfBeregar.SweetAsChocolateCake) == 2 then
			npcHandler:say("So did you tell her that the cake came from me?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			player:setStorageValue(Storage.HiddenCityOfBeregar.SweetAsChocolateCake, 1)
			player:setStorageValue(Storage.HiddenCityOfBeregar.DefaultStart, 1)
			npcHandler:say("Great! She works in the tavern of Beregar. It's situated in the western part of the city. Bring her a chocolate cake and tell her that it was me who sent it.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			player:setStorageValue(Storage.HiddenCityOfBeregar.SweetAsChocolateCake, 3)
			player:setStorageValue(Storage.HiddenCityOfBeregar.DoorWestMine, 1)
		npcHandler:say("Great! That's my breakthrough. Now she can't refuse to go out with me. I grant you access to the western part of the mine.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "See you my friend.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you my friend.")
npcHandler:setMessage(MESSAGE_GREET, "Don't you see that I'm trying to write a poem? <sighs> So what's the matter?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
