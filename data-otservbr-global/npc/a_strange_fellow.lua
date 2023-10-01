local internalNpcName = "A Strange Fellow"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 95,
	lookBody = 118,
	lookLegs = 57,
	lookFeet = 95,
	lookAddons = 2
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

	if player:getStorageValue(Storage.Postman.Mission03) ~= 1 then
		return true
	end
	if MsgContains(message, "bill") then
		if	npcHandler:getTopic(playerId) == 6 then
			npcHandler:say("A bill? Oh boy so you are delivering another bill to poor me?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		end
	elseif MsgContains(message, "yes") then
		if	player:removeItem(3216, 1)	and	npcHandler:getTopic(playerId) == 7 then
			npcHandler:say("Ok, ok, I'll take it. I guess I have no other choice anyways. And now leave me alone in my misery please.", npc, creature)
			player:setStorageValue(Storage.Postman.Mission03, 2)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "hat") then
		if	npcHandler:getTopic(playerId) < 1 then
			npcHandler:say("Uh? What do you want?!", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("What? My hat?? Theres... nothing special about it!", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Stop bugging me about that hat, do you listen?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("Hey! Don't touch that hat! Leave it alone!!! Don't do this!!!!", npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif npcHandler:getTopic(playerId) == 5 then
			for i = 1, 5 do
				Game.createMonster("Rabbit", npc:getPosition())
			end
			npcHandler:say("Noooooo! Argh, ok, ok, I guess I can't deny it anymore, I am David Brassacres, the magnificent, so what do you want?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
