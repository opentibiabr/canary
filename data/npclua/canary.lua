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
	interval = 5000,
	chance = 20,
	{ text = "Welcome to the Canary Server!" }
}

npcConfig.flags = {
	floorchange = false
}

-- Npc shop
npcConfig.shop = {
	{clientId = 123, buy = 16000, sell = 16000, count = 1},
	{clientId = 130, buy = 100, count = 1},
	{clientId = 135, buy = 5000, count = 1},
	{clientId = 138, buy = 600, count = 1}
}
-- On buy npc shop message
npcType.onPlayerBuyItem = function(npc, player, itemId, subType, amount, inBackpacks, name, totalCost)
	npc:sellItem(player, itemId, amount, subType, true, inBackpacks, 1988)
	npc:talk(player, string.format("You've bought %i %s for %i gold coins.", amount, name, totalCost), npc, player)
end
-- On sell npc shop message
npcType.onPlayerSellItem = function(npc, player, amount, name, totalCost, clientId)
	npc:talk(player, string.format("You've sold %i %s for %i gold coins.", amount, name, totalCost))
end

-- Create keywordHandler and npcHandler
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

-- Function called by the callback "npcHandler:setCallback(CALLBACK_GREET, greetCallback)" in end of file
local function greetCallback(creature)
	npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, you need more info about {canary}?")
	return true
end

-- On creature say callback
local function creatureSayCallback(npc, creature, type, msg)
	local player = Player(creature)
	if not npcHandler:isFocused(creature) then
		return false
	end

	-- Open shop window
	if msgcontains(msg, "trade") then
		npc:openShopWindow(player)
	end

	if msgcontains(msg, "canary") then
		npcHandler:say({
			"The goal is for Canary to be an 'engine', that is, it will be \z
				a server with a 'clean' datapack, with as few things as possible, \z
				thus facilitating development and testing.",
			"See more on our {discord group}."
		}, npc, creature, false, true, 3000)
	elseif msgcontains(msg, "discord group") then
		npcHandler:say("This the our discord group link: {https://discordapp.com/invite/3NxYnyV}", npc, creature)
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

npcHandler:addModule(FocusModule:new())

-- onThink
npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

-- onAppear 
npcType.onAppear = function(npc, creature)
	npcHandler:onCreatureAppear(npc, creature)
end

-- onDisappear
npcType.onDisappear = function(npc, creature)
	npcHandler:onCreatureDisappear(npc, creature)
end

-- onMove
npcType.onMove = function(npc, creature, fromPosition, toPosition)
end

-- onSay
npcType.onSay = function(npc, creature, type, message)
	npcHandler:onCreatureSay(npc, creature, type, message)
end

-- Register npc
npcType:register(npcConfig)
