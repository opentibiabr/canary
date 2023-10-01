local internalNpcName = "Ezebeth"
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
	lookHead = 96,
	lookBody = 31,
	lookLegs = 34,
	lookFeet = 94,
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

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.DarkTrails.Mission01) == -1 then
			npcHandler:say("Well, there is little where we need help beyond the normal tasks you can do for the city. However, there is one thing out of the ordinary where some {assistance} would be appreciated.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say("You already asked for a mission, go to the next.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "assistance") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say(" It's nothing really important, so no one has yet found the time to look it up. It concerns the towns beggars that have started to behave {strange} lately.", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "strange") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("They usually know better than to show up in the streets and harass our citizens, but lately they've grown more bold or desperate or whatever. I ask you to investigate what they are up to. If necessary, you may scare them away a bit.", npc, creature)
			player:setStorageValue(Storage.DarkTrails.Mission01, 1) -- Mission 1 start
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "outfit") then
		if player:getStorageValue(Storage.DarkTrails.Mission18) == 1 then
			npcHandler:say("Nice work, take your outfit.", npc, creature)
			player:setStorageValue(Storage.DarkTrails.Outfit, 1)
			doPlayerAddOutfit(610, 1)
			doPlayerAddOutfit(618, 1)
			npcHandler:setTopic(playerId, 0)
	elseif player:getStorageValue(Storage.DarkTrails.Outfit) == 1 then
			npcHandler:say("You already have the outfit.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello! I guess you are here for a {mission}.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
