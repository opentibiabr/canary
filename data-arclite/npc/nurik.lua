local internalNpcName = "Nurik"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 132,
	lookHead = 79,
	lookBody = 85,
	lookLegs = 86,
	lookFeet = 90,
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

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.ThievesGuild.Mission04) ~= 6 or player:getOutfit().lookType ~= 66 then
		npcHandler:say('Excuse me, but I\'m waiting for someone important!', npc, creature)
		return false
	end

	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'dwarven bridge') then
		npcHandler:say('Wait a minute! Do I get that right? You\'re the owner of the dwarven bridge and you are willing to sell it to me??', npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				'That\'s just incredible! I\'ve dreamed about acquiring the dwarven bridge since I was a child! Now my dream will finally become true. ...',
				'And you are sure you want to sell it? I mean really, really sure?'
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say('How splendid! Do you have the necessary documents with you?', npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say('Oh my, oh my. I\'m so excited! So let\'s seal this deal as fast as possible so I can visit my very own dwarven bridge. Are you ready for the transaction?', npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif npcHandler:getTopic(playerId) == 4 then
			local player = Player(creature)
			if player:removeItem(7866, 1) then
				player:addItem(7871, 1)
				player:setStorageValue(Storage.ThievesGuild.Mission04, 7)
				npcHandler:say({
					'Excellent! Here is the painting you requested. It\'s quite precious to my father, but imagine his joy when I tell him about my clever deal! ...',
					'Now leave me alone please. I have to prepare for my departure. Now my family will not call me a squandering fool anymore!'
				}, npc, creature)
				npcHandler:removeInteraction(npc, creature)
				npcHandler:resetNpc(creature)
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'It\'s .. It\'s YOU! At last!! So what\'s this special proposal you would like to make, my friend?')
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
