local internalNpcName = "Juliet"
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

	if table.contains({ "Joel", "Hunting Tasks", "Hunting", "Tasks" }, message) then
		if player:getStorageValue(Storage.HuntingTasks.Steps.LearningTheTruth) == 2 then
			npcHandler:say("The Time machine on our left may give you a daily hunting task. I recommend you to accept everyday. \n The Hunting Tasks are divided in three stages, and I recommend you to start on the left portal.", npc, creature)
			player:setStorageValue(Storage.HuntingTasks.Steps.LearningTheTruth, 3)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		elseif player:getStorageValue(Storage.HuntingTasks.Steps.LearningTheTruth) == 3 then
			pcHandler:say("Happy Hunting!", npc, creature)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		else
			npcHandler:say("Go away, you have no business here.", npc, creature)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
			return false
		end
    end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Hello, |PLAYERNAME|! What are you doing here? Oh yes, {Joel} must have sent you here...")
npcHandler:setMessage(MESSAGE_FAREWELL, "Happy Hunting!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Wait! Take care while hunting!!")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
