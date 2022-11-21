local internalNpcName = "Malunga"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 149,
	lookHead = 95,
	lookBody = 78,
	lookLegs = 19,
	lookFeet = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = '<mumble>'}
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

npcHandler:setMessage(MESSAGE_GREET, "Greetings. I have only little time to {spare}, so the conversation will be short. I teach sorcerer {spells} and buy a few magical {ingredients}.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "boggy dreads", clientId = 9667, sell = 200 },
	{ itemName = "bonecarving knife", clientId = 17830, sell = 140 },
	{ itemName = "centipede leg", clientId = 10301, sell = 28 },
	{ itemName = "cliff strider claw", clientId = 16134, sell = 800 },
	{ itemName = "cobra tongue", clientId = 9634, sell = 15 },
	{ itemName = "compound eye", clientId = 14083, sell = 150 },
	{ itemName = "crawler head plating", clientId = 14079, sell = 210 },
	{ itemName = "damselfly eye", clientId = 17463, sell = 25 },
	{ itemName = "damselfly wing", clientId = 17458, sell = 20 },
	{ itemName = "deepling breaktime snack", clientId = 14011, sell = 90 },
	{ itemName = "deepling claw", clientId = 14044, sell = 430 },
	{ itemName = "deepling ridge", clientId = 14041, sell = 360 },
	{ itemName = "deepling scales", clientId = 14017, sell = 80 },
	{ itemName = "deepling warts", clientId = 14012, sell = 180 },
	{ itemName = "demonic finger", clientId = 12541, sell = 1000 },
	{ itemName = "dowser", clientId = 19110, sell = 35 },
	{ itemName = "essence of a bad dream", clientId = 10306, sell = 360 },
	{ itemName = "eye of a deepling", clientId = 12730, sell = 150 },
	{ itemName = "eye of a weeper", clientId = 16132, sell = 650 },
	{ itemName = "eye of corruption", clientId = 11671, sell = 390 },
	{ itemName = "fir cone", clientId = 19111, sell = 25 },
	{ itemName = "ghastly dragon head", clientId = 10449, sell = 700 },
	{ itemName = "ghoul snack", clientId = 11467, sell = 60 },
	{ itemName = "gland", clientId = 8143, sell = 500 },
	{ itemName = "hair of a banshee", clientId = 11446, sell = 350 },
	{ itemName = "half-digested piece of meat", clientId = 10283, sell = 55 },
	{ itemName = "half-eaten brain", clientId = 9659, sell = 85 },
	{ itemName = "hatched rorc egg", clientId = 18997, sell = 30 },
	{ itemName = "haunted piece of wood", clientId = 9683, sell = 115 },
	{ itemName = "hellhound slobber", clientId = 9637, sell = 500 },
	{ itemName = "horoscope", clientId = 18926, sell = 40 },
	{ itemName = "incantation notes", clientId = 18929, sell = 90 },
	{ itemName = "lancet", clientId = 18925, sell = 90 },
	{ itemName = "lizard essence", clientId = 11680, sell = 300 },
	{ itemName = "mutated flesh", clientId = 10308, sell = 50 },
	{ itemName = "mutated rat tail", clientId = 9668, sell = 150 },
	{ itemName = "necromantic robe", clientId = 11475, sell = 250 },
	{ itemName = "pelvis bone", clientId = 11481, sell = 30 },
	{ itemName = "petrified scream", clientId = 10420, sell = 250 },
	{ itemName = "piece of dead brain", clientId = 9663, sell = 420 },
	{ itemName = "piece of scarab shell", clientId = 9641, sell = 45 },
	{ itemName = "piece of swampling wood", clientId = 17823, sell = 30 },
	{ itemName = "pieces of magic chalk", clientId = 18930, sell = 210 },
	{ itemName = "pig foot", clientId = 9693, sell = 10 },
	{ itemName = "pile of grave earth", clientId = 11484, sell = 25 },
	{ itemName = "poison spider shell", clientId = 11485, sell = 10 },
	{ itemName = "poisonous slime", clientId = 9640, sell = 50 },
	{ itemName = "rorc egg", clientId = 18996, sell = 120 },
	{ itemName = "rotten piece of cloth", clientId = 10291, sell = 30 },
	{ itemName = "scale of corruption", clientId = 11673, sell = 680 },
	{ itemName = "scorpion tail", clientId = 9651, sell = 25 },
	{ itemName = "slime mould", clientId = 12601, sell = 175 },
	{ itemName = "small pitchfork", clientId = 11513, sell = 70 },
	{ itemName = "spider fangs", clientId = 8031, sell = 10 },
	{ itemName = "spidris mandible", clientId = 14082, sell = 450 },
	{ itemName = "spitter nose", clientId = 14078, sell = 340 },
	{ itemName = "strand of medusa hair", clientId = 10309, sell = 600 },
	{ itemName = "swampling moss", clientId = 17822, sell = 20 },
	{ itemName = "swarmer antenna", clientId = 14076, sell = 130 },
	{ itemName = "tail of corruption", clientId = 11672, sell = 240 },
	{ itemName = "tarantula egg", clientId = 10281, sell = 80 },
	{ itemName = "tentacle piece", clientId = 11666, sell = 5000 },
	{ itemName = "thorn", clientId = 9643, sell = 100 },
	{ itemName = "tooth file", clientId = 18924, sell = 60 },
	{ itemName = "undead heart", clientId = 10450, sell = 200 },
	{ itemName = "vampire's cape chain", clientId = 18927, sell = 150 },
	{ itemName = "venison", clientId = 18995, sell = 55 },
	{ itemName = "waspoid claw", clientId = 14080, sell = 320 },
	{ itemName = "waspoid wing", clientId = 14081, sell = 190 },
	{ itemName = "widow's mandibles", clientId = 10411, sell = 110 },
	{ itemName = "winged tail", clientId = 10313, sell = 800 },
	{ itemName = "yielocks", clientId = 12805, sell = 600 },
	{ itemName = "yielowax", clientId = 12742, sell = 600 }
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

npcType:register(npcConfig)
