local internalNpcName = "Joel the Hunter"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1095,
	lookHead = 94,
	lookBody = 94,
	lookLegs = 107,
	lookFeet = 94,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
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

	if table.contains({ "yes", "Hunting Tasks", "Hunting", "Tasks" }, message) then
		if player:getStorageValue(Storage.HuntingTasks.Steps.LearningTheTruth) == 1 then
			npcHandler:say("Since the shadows are growing in darkness, we need all help possible to stop them!", npc, creature)
        	npcHandler:say("Please go through the teleports and talk with Juliet, she will explain better.", npc, creature)
			player:setStorageValue(Storage.HuntingTasks.Steps.LearningTheTruth, 2)
        	npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		else
			npcHandler:say("You already know what to do. Go now.", npc, creature)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		end
    end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Hello, |PLAYERNAME|! Have you heard about the {Hunting Tasks}?")
npcHandler:setMessage(MESSAGE_FAREWELL, "That the gods bless you! Good luck.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Wait! This world needs your help...")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
