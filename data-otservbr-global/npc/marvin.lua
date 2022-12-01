local internalNpcName = "Marvin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 132,
	lookHead = 38,
	lookBody = 109,
	lookLegs = 14,
	lookFeet = 57,
	lookAddons = 2
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

	if(MsgContains(message, "funding")) then
		if(player:setStorageValue(Storage.DarkTrails.Mission07) == 1) then
			npcHandler:say(
				{
					"So far you earned x votes. Each single vote can be spent on a different topic or you're also able to cast all your votes on one voting. ...",
					"Well in the topic b you have the possibility to vote for the funding of the {archives}, import of bug {milk} or street {repairs}."
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say("You cant vote yet.", npc, creature)
		end
	elseif(MsgContains(message, "archives")) then
		if(npcHandler:getTopic(playerId) == 1) then
			npcHandler:say("How many of your x votes do you want to cast?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif(MsgContains(message, "1")) then
		if(npcHandler:getTopic(playerId) == 2) then
			npcHandler:say("Did I get that right: You want to cast 1 of your votes on funding the {archives?}", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif(MsgContains(message, "yes")) then
		if(npcHandler:getTopic(playerId) == 3) then
			player:setStorageValue(Storage.DarkTrails.Mission08, 1)
			npcHandler:say("Thanks, you successfully cast your vote. Feel free to continue gathering votes by helping the city! Farewell.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
