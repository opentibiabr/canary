local internalNpcName = "Zurak"
local npcType = Game.createNpcType("Zurak (Arena)")
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 114
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

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "trip") or MsgContains(message, "passage") then
		if player:getStorageValue(TheNewFrontier.Questline) >= 24 then
			npcHandler:say("You want trip to Izzle of Zzao?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say("You need permission to travel to.", npc, creature)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("It'zz done your travel to.", npc, creature)
			local destination = Position(33158, 31227, 7)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Zzoftzzkinzz zzo full of fear.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'hurry') or MsgContains(message, 'job')  then
		npcHandler:say('Me zzimple ferryman. I arrange {trip} to Zzao.', npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
