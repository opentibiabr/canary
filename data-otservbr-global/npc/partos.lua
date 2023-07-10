local internalNpcName = "Partos"
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
	lookHead = 116,
	lookBody = 56,
	lookLegs = 95,
	lookFeet = 121,
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

	if MsgContains(message, 'supplies') then
		if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission01) == 1 then
			npcHandler:say({
				'What!? I bet, Baa\'leal sent you! ...',
				'I won\'t tell you anything! Shove off!'
			}, npc, creature)
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission01, 2)
		else
			npcHandler:say('I won\'t talk about that.', npc, creature)
		end

	elseif MsgContains(message, 'ankrahmun') then
		npcHandler:say({
			'Yes, I\'ve lived in Ankrahmun for quite some time. Ahh, good old times! ...',
			'Unfortunately I had to relocate. <sigh> ...',
			'Business reasons - you know.'
		}, npc, creature)
	end
	return true
end

keywordHandler:addKeyword({'prison'}, StdModule.say, {npcHandler = npcHandler, text = 'You mean that\'s a JAIL? They told me it\'s the finest hotel in town! THAT explains the lousy roomservice!'})
keywordHandler:addKeyword({'jail'}, StdModule.say, {npcHandler = npcHandler, text = 'You mean that\'s a JAIL? They told me it\'s the finest hotel in town! THAT explains the lousy roomservice!'})
keywordHandler:addKeyword({'cell'}, StdModule.say, {npcHandler = npcHandler, text = 'You mean that\'s a JAIL? They told me it\'s the finest hotel in town! THAT explains the lousy roomservice!'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome to my little kingdom, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye, visit me again. I will be here, promised.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye, visit me again. I will be here, promised.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
