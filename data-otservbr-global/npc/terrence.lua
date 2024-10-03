local internalNpcName = "Terrence"
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
	lookHead = 57,
	lookBody = 28,
	lookLegs = 28,
	lookFeet = 51,
	lookAddons = 1,
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

	if MsgContains(message, "manway") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission16) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission17) < 1 then
			npcHandler:say("I'm not allowed to let just anyone pass. If you have proven your willingness and effort to participate in the fighting, I'm allowed to let you pass.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say("Ahhhhhhhh! ", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "effort") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("You fought hard enough against the minotaurs. Since you've shown so much effort in our war, I'll let you pass through the gate.", npc, creature)
		player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission17, 1)
		player:setStorageValue(Storage.Quest.U10_50.DarkTrails.DoorHideout, 1)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, " Hey there, you are surely interested in helping the Rathleton city guard, right? Right - especially now since the dreaded minotaurs gain more ground every day.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
