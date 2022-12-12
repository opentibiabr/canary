local internalNpcName = "Walter, The Guard"
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
	lookHead = 19,
	lookBody = 19,
	lookLegs = 38,
	lookFeet = 38,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if(MsgContains(message, "trouble") and player:getStorageValue(Storage.TheInquisition.WalterGuard) < 1 and player:getStorageValue(Storage.TheInquisition.Mission01) ~= -1) then
		npcHandler:say("I think there is a pickpocket in town.", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif(MsgContains(message, "authorities")) then
		if(npcHandler:getTopic(playerId) == 1) then
			npcHandler:say("Well, sooner or later we will get hold of that delinquent. That's for sure.", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif(MsgContains(message, "avoided")) then
		if(npcHandler:getTopic(playerId) == 2) then
			npcHandler:say("You can't tell by a person's appearance who is a pickpocket and who isn't. You simply can't close the city gates for everyone.", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif(MsgContains(message, "gods would allow")) then
		if(npcHandler:getTopic(playerId) == 3) then
			npcHandler:say("If the gods had created the world a paradise, no one had to steal at all.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			if(player:getStorageValue(Storage.TheInquisition.WalterGuard) < 1) then
				player:setStorageValue(Storage.TheInquisition.WalterGuard, 1)
				player:setStorageValue(Storage.TheInquisition.Mission01, player:getStorageValue(Storage.TheInquisition.Mission01) + 1) -- The Inquisition Questlog- "Mission 1: Interrogation"
				player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
