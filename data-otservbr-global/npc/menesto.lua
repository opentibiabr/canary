local internalNpcName = "Menesto"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 114,
	lookBody = 38,
	lookLegs = 78,
	lookFeet = 114,
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

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.Tutorial) < 1 then
		npcHandler:say(
			{
				"Finally, reinforcements - oh but no, you came through the crystal portal, like the others! \z
					I am ser Menesto, I guard the portal. That beast caught me by surprise, I lost my dagger and had to retreat. ...",
				"... ...",
				"Hmm. ...",
				"You look hungry, you should eat regularly to reagain your strength! \z
					See what you can find while hunting. Or buy food in a city shop. \z
					Here, have some of my rations, I'll take my dagger. Tell me when you're {ready}."
			},
		npc, creature, 10)
		player:addItem(3577, 1)
		player:setStorageValue(Storage.Dawnport.Tutorial, 1)
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "ready") then
		if player:getStorageValue(Storage.Dawnport.Tutorial) == 1 then
			npcHandler:say(
				{
					"I'll stay here till reinforcements come. Go up the ladder to reach the surface. \z
						You'll need a rope for the ropestot that comes after the ladder - here, take my spare equipment. ...",
					"And remember: Tibia is a world with many dangers and mysteries, so be careful! Farewell, friend."
				},
			npc, creature, 10)
			player:setStorageValue(Storage.Dawnport.Tutorial, 2)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
