local internalNpcName = "Corym Worker"
local npcType = Game.createNpcType("Corym Worker (4)")
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 533,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 115,
	lookFeet = 0,
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

local HiddenThreats = Storage.Quest.U11_50.HiddenThreats
local function greetCallback(npc, creature, message)
	local player = Player(creature)

	if player:getStorageValue(HiddenThreats.corymRescued06) < 0 then
		npcHandler:setMessage(MESSAGE_GREET, {
			'Every man is the architect of his own fortune. I want to see the daylight again! Just smell fresh air.'
		})
		player:setStorageValue(HiddenThreats.corymRescueMission, player:getStorageValue(HiddenThreats.corymRescueMission) +1 )
		player:setStorageValue(HiddenThreats.corymRescued06, 1 )
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Every man is the architect of his own fortune. I want to see the daylight again! Just smell fresh air.')
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	--local player = Player(creature)

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end
	return true
end

-- Greeting message
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye, |PLAYERNAME|.')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
