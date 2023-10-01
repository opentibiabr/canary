local internalNpcName = "Klaus"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 96,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0
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

	if MsgContains(message, 'mission') then
		if player:getStorageValue(Storage.TheShatteredIsles.RaysMission4) == 1 then
			npcHandler:say(
				'Hmm, you look like a seasoned seadog. Kill Captain Ray Striker, \
				bring me his lucky pillow as a proof and you are our hero!',
			creature)
			player:setStorageValue(Storage.TheShatteredIsles.RaysMission4, 2)
		elseif player:getStorageValue(Storage.TheShatteredIsles.RaysMission4) == 3 then
			npcHandler:say("Do you have Striker's pillow?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, 'yes') then
		if player:getStorageValue(Storage.TheShatteredIsles.RaysMission4) == 3 then
			if npcHandler:getTopic(playerId) == 1 then
				if player:removeItem(6105, 1) then
					npcHandler:say('You DID it!!! Incredible! Boys, lets have a PAAAAAARTY!!!!', npc, creature)
					player:setStorageValue(Storage.TheShatteredIsles.RaysMission4, 4)
					npcHandler:setTopic(playerId, 0)
				else
					npcHandler:say('Come back when you have his lucky pillow.', npc, creature)
					npcHandler:setTopic(playerId, 0)
				end
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
