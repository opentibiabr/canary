local npcName = "Canary"

local npcType = Game.createNpcType(npcName)
local npcConfig = {}

npcConfig.name = npcName
npcConfig.description = npcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 10

npcConfig.outfit = {
	lookType = 128,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 2,
	lookMount = 42
}

npcConfig.voices = {
	interval = 15000,
	chance = 20,
	{ text = "Welcome to the Canary Server!" }
}

npcConfig.flags = {
	floorchange = false
}

-- Npc shop
npcConfig.shop = {
	{ clientId = 123, buy = 32000, sell = 16000, count = 1 },
	{ clientId = 130, buy = 100, count = 1 },
	{ clientId = 135, buy = 5000, count = 1 },
	{ clientId = 138, buy = 600, count = 1 }
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

-- Create keywordHandler and npcHandler
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

-- onThink
npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

-- onAppear 
npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

-- onDisappear
npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

-- onMove
npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

-- onSay
npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

-- Function called by the callback "npcHandler:setCallback(CALLBACK_GREET, greetCallback)" in end of file
local function greetCallback(npc, creature)
	local playerId = creature:getId()
	npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, you need more info about {canary}?")
	return true
end

-- On creature say callback
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "canary") then
		npcHandler:say({
			"The goal is for Canary to be an 'engine', that is, it will be \z
				a server with a 'clean' datapack, with as few things as possible, \z
				thus facilitating development and testing.",
			"See more on our {discord group}."
		}, npc, creature, 3000)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "discord group") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("This the our discord group link: {https://discordapp.com/invite/3NxYnyV}", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

-- Set to local function "greetCallback"
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
-- Set to local function "creatureSayCallback"
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Bye message
npcHandler:setMessage(MESSAGE_FAREWELL, "Yeah, good bye and don't come again!")
-- Walkaway message
npcHandler:setMessage(MESSAGE_WALKAWAY, "You not have education?")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- Register npc
npcType:register(npcConfig)

