local internalNpcName = "Sholley"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 140,
	lookHead = 79,
	lookBody = 86,
	lookLegs = 12,
	lookFeet = 92,
	lookAddons = 1
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

	if(MsgContains(message, "friend")) then
		if player:getStorageValue(Storage.DarkTrails.Mission12) == 1 then
			npcHandler:say("So you have proven yourself a true friend of our city. It's hard to believe but I think your words only give substance to suspicions my heart had harboured since quite a while. ...", npc, creature)
			npcHandler:say("So Harsin is probably not the person he appeared to be. Actually I haven't heard from him for quite a while. He was resident in the local bed and breakfast hotel. You should be able to find him there or at least to learn about his whereabouts.", npc, creature)
			player:setStorageValue(Storage.DarkTrails.Mission13, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "quandon")) then
		if player:setStorageValue(Storage.DarkTrails.Mission14) == 2 then
			npcHandler:say("A transporter dead? This is more then alarming. It seems Harsin is up to something and whatever it is, it's nothing good at all. But not all is lost. A local medium, Barnabas, has truly the gift to speak to the dead. ...", npc, creature)
			npcHandler:say("I'll mark his home on your map. He should be able to get the information you need to locate Harsin.", npc, creature)
			player:setStorageValue(Storage.DarkTrails.Mission15, 1)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Already clicked the body on the house Roswitha ?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
