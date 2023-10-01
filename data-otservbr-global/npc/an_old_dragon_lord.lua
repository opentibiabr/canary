local internalNpcName = "An Old Dragonlord"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 39
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'AHHHH THE PAIN OF AGESSS! THE PAIN!'}
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
	if not (MsgContains(message, 'hi') or MsgContains(message, 'hello')) then
		npcHandler:say('LEAVE THE DRAGONS\' CEMETERY AT ONCE!', npc, creature)
	end
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.Dragonfetish) == 1 then
		npcHandler:say('LEAVE THE DRAGONS\' CEMETERY AT ONCE!', npc, creature)
		return false
	end

	if not player:removeItem(3723, 1) then
		npcHandler:say('AHHHH THE PAIN OF AGESSS! I NEED MUSSSSHRROOOMSSS TO EASSSE MY PAIN! BRRRING ME MUSHRRROOOMSSS!', npc, creature)
		return false
	end

	player:setStorageValue(Storage.Dragonfetish, 1)
	player:addItem(3206, 1)
	npcHandler:say('AHHH MUSHRRROOOMSSS! NOW MY PAIN WILL BE EASSSED FOR A WHILE! TAKE THISS AND LEAVE THE DRAGONSSS\' CEMETERY AT ONCE!', npc, creature)
	return false
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
