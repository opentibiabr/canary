local internalNpcName = "Black Bert"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 151,
	lookHead = 0,
	lookBody = 38,
	lookLegs = 19,
	lookFeet = 76,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.shop = {
	{ itemname = "almanac of magic", clientid = 10025, buy = 600 },
	{ itemname = "animal fetish", clientid = 9236, buy = 10000 },
	{ itemname = "baby rotworm", clientid = 10026, buy = 600 },
	{ itemname = "bag with naga eggs", clientid = 39577, buy = 10000 },
	{ itemname = "bale of white cloth", clientid = 142, buy = 6000 },
	{ itemname = "beer bottle", clientid = 136, buy = 600 },
	{ itemname = "bill", clientid = 3216, buy = 8000 },
	{ itemname = "blood crystal", clientid = 8453, buy = 50000 },
	{ itemname = "bloodkiss flower", clientid = 9241, buy = 10000 },
	{ itemname = "book with old legends", clientid = 25239, buy = 2000 },
	{ itemname = "bundle of rags", clientid = 9191, buy = 5000 },
	{ itemname = "butterfly conservation kit", clientid = 39340, buy = 40000 },
	{ itemname = "carrying device", clientid = 9698, buy = 1000 },
	{ itemname = "case of rust bugs", clientid = 350, buy = 7000 },
	{ itemname = "cask of brown ale", clientid = 8774, buy = 7000 },
	{ itemname = "celestial chart", clientid = 39136, buy = 10000 },
	{ itemname = "cigar", clientid = 141, buy = 2000 },
	{ itemname = "conch shell", clientid = 43861, buy = 10000 },
	{ itemname = "cookbook", clientid = 3234, buy = 1000 },
	{ itemname = "copied research notes", clientid = 40515, buy = 5000 },
	{ itemname = "crate", clientid = 117, buy = 1000 },
	{ itemname = "crimson nightshade blossoms", clientid = 27465, buy = 7000 },
	{ itemname = "damaged logbook", clientid = 6124, buy = 40000 },
	{ itemname = "dark essence", clientid = 9238, buy = 17000 },
	{ itemname = "dark moon mirror", clientid = 25729, buy = 5000 },
	{ itemname = "dark sun catcher", clientid = 25733, buy = 5000 },
	{ itemname = "deep crystal", clientid = 9240, buy = 13000 },
	{ itemname = "dragha's spellbook", clientid = 6120, buy = 16000 },
	{ itemname = "elemental crystal", clientid = 9251, buy = 8000 },
	{ itemname = "empty starlight vial", clientid = 25731, buy = 5000 },
	{ itemname = "exploding cookie", clientid = 130, buy = 100 },
	{ itemname = "exquisite silk", clientid = 11545, buy = 4000 },
	{ itemname = "exquisite wood", clientid = 11547, buy = 4000 },
	{ itemname = "faded last will", clientid = 11544, buy = 600 },
	{ itemname = "fae talisman", clientid = 25295, buy = 5000 },
	{ itemname = "family brooch", clientid = 4834, buy = 1000 },
	{ itemname = "family signet ring", clientid = 406, buy = 15000 },
	{ itemname = "fan club membership card", clientid = 9391, buy = 10000 },
	{ itemname = "filled carrying device", clientid = 9699, buy = 1000 },
	{ itemname = "fishnapped goldfish", clientid = 7936, buy = 7000 },
	{ itemname = "flask of crown polisher", clientid = 10009, buy = 700 },
	{ itemname = "flask of extra greasy oil", clientid = 10189, buy = 1000 },
	{ itemname = "flask of poison", clientid = 10183, buy = 1000 },
	{ itemname = "flexible dragon scale", clientid = 11550, buy = 4000 },
	{ itemname = "formula for a memory potion", clientid = 9188, buy = 5000 },
	{ itemname = "funeral urn", clientid = 4847, buy = 6000 },
	{ itemname = "fur of a wolf whelp", clientid = 25238, buy = 5000 },
	{ itemname = "ghost charm", clientid = 8822, buy = 20000 },
	{ itemname = "ghost's tear", clientid = 8746, buy = 50000 },
	{ itemname = "ghostsilver lantern", clientid = 23734, buy = 20000 },
	{ itemname = "giant ape's hair", clientid = 4832, buy = 24000 },
	{ itemname = "golden symbol of suon", clientid = 27499, buy = 10000 },
	{ itemname = "gold nuggets", clientid = 27444, buy = 10000 },
	{ itemname = "golem blueprint", clientid = 9247, buy = 13500 },
	{ itemname = "golem head", clientid = 9255, buy = 25000 },
	{ itemname = "hastily scribbled note", clientid = 27370, buy = 3000 },
	{ itemname = "headache pill", clientid = 9537, buy = 350 },
	{ itemname = "heliodor's scrolls", clientid = 43969, buy = 50000 },
	{ itemname = "icicle chisel", clientid = 39578, buy = 12000 },
	{ itemname = "incantation fragment", clientid = 18933, buy = 4000 },
	{ itemname = "ivory lyre", clientid = 31447, buy = 50000 },
	{ itemname = "julius' map", clientid = 8200, buy = 25000 },
	{ itemname = "letterbag", clientid = 3217, buy = 8000 },
	{ itemname = "letter to markwin", clientid = 3220, buy = 8000 },
	{ itemname = "lump of clay", clientid = 1000, buy = 1000 },
	{ itemname = "machine crate", clientid = 9390, buy = 8500 },
	{ itemname = "magic crystal", clientid = 11552, buy = 4000 },
	{ itemname = "mago mechanic core", clientid = 9249, buy = 13000 },
	{ itemname = "map to the unknown", clientid = 10011, buy = 650 },
	{ itemname = "memory crystal", clientid = 7281, buy = 500 },
	{ itemname = "memory stone", clientid = 4841, buy = 3000 },
	{ itemname = "monk's diary", clientid = 3212, buy = 3000 },
	{ itemname = "morik's helmet", clientid = 8820, buy = 8000 },
	{ itemname = "mystic root", clientid = 11551, buy = 4000 },
	{ itemname = "nautical map", clientid = 9308, buy = 5250 },
	{ itemname = "nightshade distillate", clientid = 27461, buy = 15000 },
	{ itemname = "old iron", clientid = 11549, buy = 4000 },
	{ itemname = "old map", clientid = 24947, buy = 2000 },
	{ itemname = "old power core", clientid = 9252, buy = 13000 },
	{ itemname = "part of an old map", clientid = 24943, buy = 2000 },
	{ itemname = "part of an old map", clientid = 24944, buy = 2000 },
	{ itemname = "part of an old map", clientid = 24945, buy = 2000 },
	{ itemname = "piece of parchment", clientid = 27372, buy = 1500 },
	{ itemname = "piece of parchment", clientid = 27443, buy = 1500 },
	{ itemname = "piece of parchment", clientid = 27371, buy = 1500 },
	{ itemname = "plans for a strange device", clientid = 9696, buy = 1000 },
	{ itemname = "poison salt crystal", clientid = 22694, buy = 20000 },
	{ itemname = "present", clientid = 3218, buy = 16000 },
	{ itemname = "rare crystal", clientid = 9697, buy = 1000 },
	{ itemname = "research notes", clientid = 8764, buy = 3000 },
	{ itemname = "sacred earth", clientid = 11341, buy = 1000 },
	{ itemname = "sceptre of sun and sea", clientid = 31414, buy = 50000 },
	{ itemname = "secret letter", clientid = 402, buy = 1000 },
	{ itemname = "shadow orb", clientid = 9237, buy = 12500 },
	{ itemname = "sheet of tracing paper", clientid = 4843, buy = 500 },
	{ itemname = "sheet of tracing paper", clientid = 4842, buy = 500 },
	{ itemname = "silver nuggets", clientid = 27445, buy = 7000 },
	{ itemname = "snake destroyer", clientid = 4835, buy = 8000 },
	{ itemname = "soul contract", clientid = 10028, buy = 666 },
	{ itemname = "special flask", clientid = 100, buy = 5000 },
	{ itemname = "spectral cloth", clientid = 11546, buy = 4000 },
	{ itemname = "spectral dress", clientid = 4836, buy = 15000 },
	{ itemname = "stabilizer", clientid = 9248, buy = 12500 },
	{ itemname = "stone tablet with ley lines", clientid = 27464, buy = 8000 },
	{ itemname = "strange powder", clientid = 4838, buy = 5000 },
	{ itemname = "striker's favourite pillow", clientid = 6105, buy = 16000 },
	{ itemname = "strong sinew", clientid = 11548, buy = 4000 },
	{ itemname = "suspicious documents", clientid = 400, buy = 2000 },
	{ itemname = "suspicious signet ring", clientid = 349, buy = 15000 },
	{ itemname = "tattered swan feather", clientid = 25244, buy = 2000 },
	{ itemname = "tear of daraman", clientid = 3233, buy = 16000 },
	{ itemname = "technomancer beard", clientid = 396, buy = 5000 },
	{ itemname = "the alchemists' formulas", clientid = 8818, buy = 8000 },
	{ itemname = "the dust of arthei", clientid = 8720, buy = 4000 },
	{ itemname = "the dust of boreth", clientid = 8717, buy = 20000 },
	{ itemname = "the dust of lersatio", clientid = 8718, buy = 25000 },
	{ itemname = "the dust of marziel", clientid = 8719, buy = 30000 },
	{ itemname = "the ring of the count", clientid = 7924, buy = 10000 },
	{ itemname = "the witches' grimoire", clientid = 7874, buy = 25000 },
	{ itemname = "toy mouse", clientid = 123, buy = 16000 },
	{ itemname = "universal tool", clientid = 10027, buy = 550 },
	{ itemname = "unworked sacred wood", clientid = 11339, buy = 1000 },
	{ itemname = "waldo's post horn", clientid = 3219, buy = 2000 },
	{ itemname = "whisper moss", clientid = 4827, buy = 18000 },
	{ itemname = "whoopee cushion", clientid = 121, buy = 2000 },
	{ itemname = "wolf tooth chain", clientid = 5940, buy = 10000 },
	{ itemname = "worm queen tooth", clientid = 9239, buy = 12500 },
	{ itemname = "wrinkled parchment", clientid = 4846, buy = 4000 },
	{ itemname = "xodet's first wand", clientid = 9187, buy = 5000 },
}

-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
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

npcHandler:setMessage(MESSAGE_GREET, "Hi there, |PLAYERNAME|! You look like you are eager to {trade}!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye, |PLAYERNAME|")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
