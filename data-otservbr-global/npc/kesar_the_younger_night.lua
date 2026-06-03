local internalNpcName = "Kesar the Younger"
local npcType = Game.createNpcType("Kesar the Younger (Night)")
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 2,
}

npcConfig.respawnType = {
	period = RESPAWNPERIOD_NIGHT,
	underground = false,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {}

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

	if MsgContains(message, "siege") then
		local mission = player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.KesarMission)

		if mission == 4 then
			npcHandler:say("Will you escort me to the camp of the usurpers?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say("The night is restless, traveller. Let us speak of this when the sun rises.", npc, creature)
		end
	elseif message:lower() == "yes" and npcHandler:getTopic(playerId) == 1 then
		if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.KesarMission) == 4 then
			npcHandler:say("Alright, let us go then. And thank you.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
end

npcHandler:setMessage(MESSAGE_GREET, "Hail, traveller. The night holds many dangers. Stay close.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
