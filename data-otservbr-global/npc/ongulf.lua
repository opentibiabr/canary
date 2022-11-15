local internalNpcName = "Ongulf"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 19,
	lookBody = 53,
	lookLegs = 15,
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

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()
	
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end
	
	-- The New Frontier
	if MsgContains(message, "farmine") and player:getStorageValue(TheNewFrontier.Questline) == 14 then
		if player:getStorageValue(TheNewFrontier.Mission05.Leeland) == 1 then
			npcHandler:say(
			"Oh yes, that project the whole dwarven community is so excited about. I guess I already know why you are here, but speak up.",
			npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say(
			"Oh yes, that project the whole dwarven community is so excited about. I guess I already know why you are here, but speak up. Do you want to try again?",
			npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "impress") or MsgContains(message, "plea") and
	player:getStorageValue(TheNewFrontier.Mission05.LeelandKeyword) <= 2 and
	player:getStorageValue(TheNewFrontier.Mission05.Leeland) == 1 then
		if npcHandler:getTopic(playerId) == 1 then
			if player:getStorageValue(TheNewFrontier.Mission05.LeelandKeyword) == 1 then
				npcHandler:say(
				"Your pathetic whimpering amuses me. For this I grant you my assistance. But listen, one day I'll ask you to return this favour. From now on, you owe me one.",
				npc, creature)
				player:setStorageValue(TheNewFrontier.Mission05.Leeland, 3)
			else
				npcHandler:say("Wrong Word.", npc, creature)
				player:setStorageValue(TheNewFrontier.Mission05.LeelandKeyword, math.random(3, 4))
				player:setStorageValue(TheNewFrontier.Mission05.Leeland, 2)
			end
		end
	elseif MsgContains(message, "reason") or MsgContains(message, "flatter") and
	player:getStorageValue(TheNewFrontier.Mission05.LeelandKeyword) > 2 and
	player:getStorageValue(TheNewFrontier.Mission05.LeelandKeyword) <= 4 and
	player:getStorageValue(TheNewFrontier.Mission05.Leeland) == 1 then
		if npcHandler:getTopic(playerId) == 1 then
			if MsgContains(message, "reason") and player:getStorageValue(TheNewFrontier.Mission05.LeelandKeyword) == 3 then
				npcHandler:say(
				"The idea of a promising market and new resources suits us quite well. I think it is reasonable to send some assistance.",
				npc, creature)
				player:setStorageValue(TheNewFrontier.Mission05.Leeland, 3)
			elseif MsgContains(message, "flatter") and player:getStorageValue(TheNewFrontier.Mission05.LeelandKeyword) == 4 then
				npcHandler:say(
				"Oh yes, that project the whole dwarven community is so excited about. I guess I already know why you are here, but speak up.",
				npc, creature)
				player:setStorageValue(TheNewFrontier.Mission05.Leeland, 3)
			else
				player:setStorageValue(TheNewFrontier.Mission05.Leeland, 2)
			end
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(TheNewFrontier.Questline) == 14 and
			player:getStorageValue(TheNewFrontier.Mission05.Leeland) == 2 and player:removeItem(10028, 1) then
				npcHandler:say(
				"Oh yes, that project the whole dwarven community is so excited about. I guess I already know why you are here, but speak up.",
				npc, creature)
				player:setStorageValue(TheNewFrontier.Mission05.Leeland, 1)
				npcHandler:setTopic(playerId, 1)
			end
		end
	else
		if player:getStorageValue(TheNewFrontier.Questline) == 14 and
		player:getStorageValue(TheNewFrontier.Mission05.Leeland) == 1 then
			npcHandler:say("Wrong Word.", npc, creature)
			player:setStorageValue(TheNewFrontier.Mission05.Leeland, 2)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
