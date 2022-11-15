local internalNpcName = "Zarifan"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 560
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = '<sigh> lost... word...' },
	{ text = '<sigh> ohhhh.... memories...' },
	{ text = 'The secrets... too many... sleep...' },
	{ text = 'Loneliness...' }
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

	if MsgContains(message, "magic") and player:getStorageValue(12902) < 1 then
	npcHandler:say("...Tell me...the first... magic word.", npc, creature)
	player:setStorageValue(12902, 1)
	else npcHandler:say("...continue with your mission...", npc, creature)
	end

	end
keywordHandler:addKeyword({'mission'}, StdModule.say, {npcHandler = npcHandler, text = '..what about {magic}..'})
keywordHandler:addKeyword({'friendship'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes... YES... friendship... now... second word?'})
keywordHandler:addKeyword({'lives'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes... YES... friendship... lives... now third word?'})
keywordHandler:addKeyword({'forever'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes... YES... friendship... lives... FOREVER ... And say hello... to... my old friend... Omrabas. '})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
