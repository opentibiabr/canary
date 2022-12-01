local internalNpcName = "Humgolf"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 69
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

	if MsgContains(message, "farmine") then
		if player:getStorageValue(TheNewFrontier.Questline) == 14 then
			if player:getStorageValue(TheNewFrontier.Mission05.Humgolf) == 1 then
				npcHandler:say(
				"Bah, Farmine here, Farmine there. Is there nothing else than Farmine to talk about these days? Hrmpf, whatever. So what do you want?",
				npc, creature)
				npcHandler:setTopic(playerId, 1)
			elseif player:getStorageValue(TheNewFrontier.Mission05.Humgolf) == 2 then
				npcHandler:say(
				"You are here to apologise? Have you got anything that would make me reconsider my decision never to talk to you again about this subject?",
				npc, creature)
				npcHandler:setTopic(playerId, 2)
			end
		end
	elseif MsgContains(message, "flatter") and npcHandler:getTopic(playerId) == 1 then
		if player:getStorageValue(TheNewFrontier.Mission05.Humgolf) == 1 and
		player:getStorageValue(TheNewFrontier.Mission05.HumgolfKeyword) == 1 then
			npcHandler:say(
			"Yeah, of course they can't do without my worms. Mining and worms go hand in hand. Well, in the case of the worms it is only an imaginary hand of course. I'll send them some of my finest worms.",
			npc, creature)
			player:setStorageValue(TheNewFrontier.Mission05.Humgolf, 3)
		end
	elseif MsgContains(message, "threaten") and npcHandler:getTopic(playerId) == 1 then
		if player:getStorageValue(TheNewFrontier.Mission05.Humgolf) == 1 and
		player:getStorageValue(TheNewFrontier.Mission05.HumgolfKeyword) == 2 then
			npcHandler:say(
			"Hah! Now you talk like a dwarf! That's the spirit! Of course you can have some of my worms. I'll send a bunch to Farmine as soon as possible.",
			npc, creature)
			player:setStorageValue(TheNewFrontier.Mission05.Humgolf, 3)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 and player:getStorageValue(TheNewFrontier.Mission05.Humgolf) == 2 and
		player:removeItem(10026, 1) then
			npcHandler:say(
			"Uh, how cute! Look how he's snapping for my fingers! You really know how to make an old dwarf happy! Well, so let's try again. Why do you think I should send my precious worms to Farmine?",
			npc, creature)
			player:setStorageValue(TheNewFrontier.Mission05.Humgolf, 1)
			npcHandler:setTopic(playerId, 1)
		end
	else
		if player:getStorageValue(TheNewFrontier.Questline) == 14 and
		player:getStorageValue(TheNewFrontier.Mission05.Humgolf) == 1 then
			npcHandler:say("Wrong Word.", npc, creature)
			player:setStorageValue(TheNewFrontier.Mission05.Humgolf, 2)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, '|PLAYERNAME|, good day .. or night, whatever.')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
