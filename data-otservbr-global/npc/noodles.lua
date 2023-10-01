local internalNpcName = "Noodles"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 32
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'Grrrrrrr.' },
	{ text = '<wiggles>' },
	{ text = '<sniff>' },
	{ text = 'Woof! Woof!' },
	{ text = 'Wooof!' }
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

	if MsgContains(message, "banana skin") then
		if player:getStorageValue(Storage.Postman.Mission06) == 7 then
			if player:getItemCount(3104) > 0 then
				npcHandler:say("<sniff><sniff>", npc, creature)
				npcHandler:setTopic(playerId, 1)
			end
		end
	elseif MsgContains(message, "dirty fur") then
		if player:getStorageValue(Storage.Postman.Mission06) == 8 then
			if player:getItemCount(3105) > 0 then
				npcHandler:say("<sniff><sniff>", npc, creature)
				npcHandler:setTopic(playerId, 2)
			end
		end
	elseif MsgContains(message, "mouldy cheese") then
		if player:getStorageValue(Storage.Postman.Mission06) == 9 then
			if player:getItemCount(3120) > 0 then
				npcHandler:say("<sniff><sniff>", npc, creature)
				npcHandler:setTopic(playerId, 3)
			end
		end
	elseif MsgContains(message, "like") then
		if npcHandler:getTopic(playerId) == 1  then
			npcHandler:say("Woof!", npc, creature)
			player:setStorageValue(Storage.Postman.Mission06, 8)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Woof!", npc, creature)
			player:setStorageValue(Storage.Postman.Mission06, 9)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Meeep! Grrrrr! <spits>", npc, creature)
			player:setStorageValue(Storage.Postman.Mission06, 10)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "<sniff> Woof! <sniff>")
npcHandler:setMessage(MESSAGE_FAREWELL, "Woof! <wiggle>")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Woof! <wiggle>")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
