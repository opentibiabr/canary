local internalNpcName = "Gnomux"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 12,
	lookBody = 82,
	lookLegs = 39,
	lookFeet = 114,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.shop = {
	{ clientId = 19214, buy = 250, storageKey = SPIKE_MIDDLE_MUSHROOM_MAIN, storageValue = 4 },
	{ clientId = 19205, buy = 150, storageKey = SPIKE_UPPER_TRACK_MAIN, storageValue = 3 },
	{ clientId = 19219, buy = 100, storageKey = SPIKE_LOWER_PARCEL_MAIN, storageValue = 4 },
	{ clientId = 19207, buy = 250, storageKey = SPIKE_MIDDLE_CHARGE_MAIN, storageValue = 1 },
	{ clientId = 19203, buy = 150, storageKey = SPIKE_UPPER_MOUND_MAIN, storageValue = 4 },
	{ clientId = 19206, buy = 500, storageKey = SPIKE_LOWER_LAVA_MAIN, storageValue = 1 },
	{ clientId = 19204, buy = 150, storageKey = SPIKE_UPPER_PACIFIER_MAIN, storageValue = 7 }
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if MsgContains(message, 'job') then
		npcHandler:say("I'm responsible for resupplying foolish adventurers with equipment that they may have lost. If you're one of them, just ask me about a {trade}. ", npc, creature)
	end

	if MsgContains(message, 'gnome') then
		npcHandler:say("What could I say about gnomes that anyone would not know? I mean, we're interesting if not fascinating, after all.", npc, creature)
	end

	if MsgContains(message, 'spike') then
		npcHandler:say({"I came here as a crystal farmer and know the Spike all the way back to when it was a little baby crystal. I admit I feel a little fatherly pride in how big and healthy it has become.","When most other crystal experts left for new assignments, I decided to stay and help here a bit."}, npc, creature)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
