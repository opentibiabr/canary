local internalNpcName = "Enpa-Deia Pema"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1817,
	lookHead = 40,
	lookBody = 9,
	lookLegs = 63,
	lookFeet = 63,
	lookAddons = 1,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 0,
	{
		text = "",
	},
}

npcConfig.shop = { -- Sellable items
	{ itemName = "boots of enlightenment", clientId = 50267, buy = 8000, sell = 80 },
	{ itemName = "coned hat of enlightenment", clientId = 50274, buy = 70000, sell = 700 },
	{ itemName = "fists of enlightenment", clientId = 50271, buy = 20000, sell = 200 },
	{ itemName = "harmony amulet", clientId = 50195, buy = 1000 },
	{ itemName = "jo staff", clientId = 50171, buy = 500 },
	{ itemName = "legs of enlightenment", clientId = 50269, buy = 40000, sell = 400 },
	{ itemName = "nunchaku of enlightenment", clientId = 50273, buy = 50000, sell = 500 },
	{ itemName = "plain monk robe", clientId = 50257, buy = 450 },
	{ itemName = "robe of enlightenment", clientId = 50268, buy = 150000, sell = 150 },
	{ itemName = "sais of enlightenment", clientId = 50272, buy = 100000, sell = 100 },
}

-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end

-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

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

	if MsgContains(message, "healing") then
		npcHandler:say("You do not need any healing right now.", npc, creature)
	elseif MsgContains(message, "pilgrimage") then
		local shrinesCount = player:getStorageValue(Storage.Quest.U14_15.TheWayOfTheMonk.ShrinesCount)
		-- Normalize shrinesCount: if nil or negative, set to 0
		if shrinesCount < 0 then
			shrinesCount = 0
		end
		
		if shrinesCount >= #TheWayOfTheMonkShrines then
			npcHandler:say("You are a monk of the Merudri, enlightened and beyond the Three-Fold Path. You have visited all of our ancestral shrines and embraced eternity. The Enpa will see you now.", npc, creature)
		elseif shrinesCount > 0 and shrinesCount < #TheWayOfTheMonkShrines then
			local currentShrine = TheWayOfTheMonkShrines[shrinesCount]
			local nextShrine = TheWayOfTheMonkShrines[shrinesCount + 1]
			local ordinals = {"first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth"}
			local ordinal = ordinals[shrinesCount] or tostring(shrinesCount)
			npcHandler:say(string.format("You are an initiate of the Merudri, inducted and on the Three-Fold Path. You have visited the %s of the shrines and embraced '%s'. ...", ordinal, currentShrine.name), npc, creature)
			npcHandler:say(string.format("The next step, embracing '%s', will lead you to the south of Thais, away from the city.", nextShrine.name), npc, creature)
		else
			-- shrinesCount is 0, player hasn't started yet
			local firstShrine = TheWayOfTheMonkShrines[1]
			if firstShrine then
				npcHandler:say(string.format("You are an initiate of the Merudri, ready to begin the Three-Fold Path. Your first step is to embrace '%s'.", firstShrine.name), npc, creature)
			end
		end
	end
	return true
end

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()
	npcHandler:setMessage(MESSAGE_GREET, "Harmony, friend. Allow me to welcome you in the {Blue Valley}. I offer guidance for the {pilgrimage} and can provide {healing}. Or can I help you otherwise?")
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:setMessage(MESSAGE_FAREWELL, "Harmony and balance on your travels, friend.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Safe and insightful travels, friend.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
