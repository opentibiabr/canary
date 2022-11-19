local internalNpcName = "Robson"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 66
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = '<mumbles>' },
	{ text = 'Just great. Getting stranded on a remote underground isle was not that bad but now I\'m becoming a tourist attraction!' }
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

	if MsgContains(message, 'parcel') then
		npcHandler:say('Do you want to buy a parcel for 15 gold?', npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, 'label') then
		npcHandler:say('Do you want to buy a label for 1 gold?', npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, 'yes') then
		local player = Player(creature)
		if npcHandler:getTopic(playerId) == 1 then
			if not player:removeMoneyBank(15) then
				npcHandler:say('Sorry, that\'s only dust in your purse.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:addItem(3503, 1)
			npcHandler:say('Fine.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			if not player:removeMoneyBank(1) then
				npcHandler:say('Sorry, that\'s only dust in your purse.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:addItem(3507, 1)
			npcHandler:say('Fine.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'no') then
		if isInArray({1, 2}, npcHandler:getTopic(playerId)) then
			npcHandler:say('I knew I would be stuck with that stuff.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hrmpf, I'd say welcome if I felt like lying.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you next time!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "No patience at all!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
