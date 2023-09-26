local internalNpcName = "Lorenzo"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 22,
	lookBody = 22,
	lookLegs = 22,
	lookFeet = 57,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 7000,
	chance = 50,
	{ text = "Drome fighters! You can trade your hard earned drome points here!" },
	{ text = "Fighters from the old arena still visit me to exchange their hard earned badges! Earned in blood that is... mostly." },
}

npcConfig.currency =

npcConfig.shop = {
	{ itemName = "arena badge replica", clientId = 36833, buy = 293 },
	{ itemName = "black pit demon", clientId = 23492, buy = 80 },
	{ itemName = "blue pit demon", clientId = 23491 buy = 25 },
	{ itemName = "brown pit demon", clientId = 23489 buy = 20 },
	{ itemName = "drome cube", clientId = 36827 buy = 15 },
	{ itemName = "green pit demon", clientId = 23490 buy = 16 },
	{ itemName = "ogre rowdy doll", clientId = 32944, buy = 66 },
	{ itemName = "plushie of a domestikion", clientId = 36869, buy = 85 },
	{ itemName = "plushie of a hoodinion", clientId = 36867, buy = 85 },
	{ itemName = "plushie of a mearidion", clientId = 36868, buy = 85 },
	{ itemName = "plushie of a murmillion", clientId = 36865, buy = 85 },
	{ itemName = "plushie of a scissorion", clientId = 36866, buy = 85 },
	{ itemName = "red pit demon", clientId = 23493, buy = 85 },
	{ itemName = "retching horror doll", clientId = 32945, buy = 85 },
	{ itemName = "tournament accolade", clientId = 31470, buy = 85 },
	{ itemName = "sublime tournament accolade", clientId = 31472, buy = 85 },
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

-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end

-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

local function creatureSayCallback(npc, creature, type, message)

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "attires") then
		npcHandler:say("You're interested in the Lion of War attire? That would be a well-invested 12500 drome points. Sound good to you?", npc, creature)
	elseif MsgContains(message, "Phants") then
		npcHandler:say("So, you're interested in one of our beloved Phants! Well, that is 8000 drome points well-spent. What do you say?", npc, creature)
	elseif MsgContains(message, "talk") then
		npcHandler:say("Well, I guess you'd like to know what I'm {doing} here.", npc, creature)
	elseif MsgContains(message, "doing") then
		npcHandler:say("I specialised in trading potions in exchange for arena badges. Actually my whole family earns their living this way, you can meet my brothers and sisters by visiting the other arenas. ...", npc, creature)
		npcHandler:say("Maybe you'll even get to know my whole family someday!", npc, creature)
	end
end

npcHandler:setMessage(MESSAGE_FAREWELL, "Take care and come back soon!")
npcHandler:setMessage(MESSAGE_GREET, "Hello, brave fighter! What can I do for you? Do you want {information}, to {trade} drome points, {talk} about the old days or take a look at our famous {Phants} and {attires}?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
