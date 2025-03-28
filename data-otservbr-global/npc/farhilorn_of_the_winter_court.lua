local internalNpcName = "Farhilorn Of The Winter Court"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 990,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
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

	if MsgContains(message, "fight") then
		if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.Permission) < 1 and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.Main.TheWinterCourt) == 1 then
			npcHandler:say("We allow able champions of all races to fight for our cause against the challenges of the {arena}. So are you interested? I'm not interested in fancy'wordplay, so a simple {yes} or {no} will suffice!", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("You are now able to enter the teleport.", npc, creature)
			player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.Permission, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") then
		npcHandler:say("As you wish.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "arena") then
		npcHandler:say("This place has always been a site where the champions of summer and winter have clashed in battle. Over the centuries this spectacle has drawn many creatures here to watch, participate and indulge in less savory activities.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello fighter. I guess you are here to {fight} for our noble {cause}.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
