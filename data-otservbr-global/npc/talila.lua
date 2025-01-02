local internalNpcName = "Talila"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 982,
}

npcConfig.respawnType = {
	period = RESPAWNPERIOD_NIGHT,
	underground = false,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Are you interested in a trade?" },
	{ text = "Dont touch the wings, theyre delicate." },
	{ text = "Tralllalalla." },
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

npcHandler:setMessage(MESSAGE_GREET, "Greatings, mortal beigin.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Yes, i have some potions and runes if you are interested. Or do you want to buy only potions or only runes?oh if you want sell or buy gems, your may also ask me.")
npcHandler:setMessage(MESSAGE_FAREWELL, "May enlightenment be your path, |PLAYERNAME|.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "amber with a bug", clientId = 32624, sell = 41000 },
	{ itemName = "amber with a dragonfly", clientId = 32625, sell = 56000 },
	{ itemName = "amber", clientId = 32626, sell = 20000 },
	{ itemName = "ancient coin", clientId = 24390, sell = 350 },
	{ itemName = "animate dead rune", clientId = 3203, buy = 375 },
	{ itemName = "avalanche rune", clientId = 3161, buy = 64 },
	{ itemName = "bar of gold", clientId = 14112, sell = 10000 },
	{ itemName = "black pearl", clientId = 3027, buy = 560, sell = 280 },
	{ itemName = "blue crystal shard", clientId = 16119, sell = 1500 },
	{ itemName = "blue crystal splinter", clientId = 16124, sell = 400 },
	{ itemName = "blue rose", clientId = 3659, sell = 200 },
	{ itemName = "bronze goblet", clientId = 5807, buy = 2000 },
	{ itemName = "brown crystal splinter", clientId = 16123, sell = 400 },
	{ itemName = "brown giant shimmering pearl", clientId = 282, sell = 3000 },
	{ itemName = "butterfly ring", clientId = 25698, sell = 2000 },
	{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
	{ itemName = "colourful snail shell", clientId = 25696, sell = 250 },
	{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
	{ itemName = "coral brooch", clientId = 24391, sell = 750 },
	{ itemName = "crunor idol", clientId = 30055, sell = 30000 },
	{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
	{ itemName = "cyan crystal fragment", clientId = 16125, sell = 800 },
	{ itemName = "dandelion seeds", clientId = 25695, sell = 200 },
	{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
	{ itemName = "diamond", clientId = 32770, sell = 15000 },
	{ itemName = "disintegrate rune", clientId = 3197, buy = 26 },
	{ itemName = "dragon figurine", clientId = 30053, sell = 45000 },
	{ itemName = "dream blossom staff", clientId = 25700, sell = 5000 },
	{ itemName = "empty potion flask", clientId = 283, sell = 5 },
	{ itemName = "empty potion flask", clientId = 284, sell = 5 },
	{ itemName = "empty potion flask", clientId = 285, sell = 5 },
	{ itemName = "energy bomb rune", clientId = 3149, buy = 203 },
	{ itemName = "energy field rune", clientId = 3164, buy = 38 },
	{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
	{ itemName = "explosion rune", clientId = 3200, buy = 31 },
	{ itemName = "fairy wings", clientId = 25694, sell = 200 },
	{ itemName = "fern", clientId = 3737, sell = 20 },
	{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },
	{ itemName = "fire field rune", clientId = 3188, buy = 28 },
	{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
	{ itemName = "fireball rune", clientId = 3189, buy = 30 },
	{ itemName = "gemmed figurine", clientId = 24392, sell = 3500 },
	{ itemName = "giant amethyst", clientId = 32622, sell = 60000 },
	{ itemName = "giant emerald", clientId = 30060, sell = 90000 },
	{ itemName = "giant ruby", clientId = 30059, sell = 70000 },
	{ itemName = "giant sapphire", clientId = 30061, sell = 50000 },
	{ itemName = "giant topaz", clientId = 32623, sell = 80000 },
	{ itemName = "goat grass", clientId = 3674, sell = 50 },
	{ itemName = "gold ingot", clientId = 9058, sell = 5000 },
	{ itemName = "gold nugget", clientId = 3040, sell = 850 },
	{ itemName = "golden amulet", clientId = 3013, buy = 6600 },
	{ itemName = "golden figurine", clientId = 5799, sell = 3000 },
	{ itemName = "golden goblet", clientId = 5805, buy = 5000 },
	{ itemName = "great fireball rune", clientId = 3191, buy = 64 },
	{ itemName = "great health potion", clientId = 239, buy = 225 },
	{ itemName = "great mana potion", clientId = 238, buy = 158 },
	{ itemName = "great spirit potion", clientId = 7642, buy = 254 },
	{ itemName = "greater guardian gem", clientId = 44604, sell = 10000 },
	{ itemName = "greater marksman gem", clientId = 44607, sell = 10000 },
	{ itemName = "greater mystic gem", clientId = 44613, sell = 10000 },
	{ itemName = "greater sage gem", clientId = 44610, sell = 10000 },
	{ itemName = "green crystal fragment", clientId = 16127, sell = 800 },
	{ itemName = "green crystal shard", clientId = 16121, sell = 1500 },
	{ itemName = "green crystal splinter", clientId = 16122, sell = 400 },
	{ itemName = "green giant shimmering pearl", clientId = 281, sell = 3000 },
	{ itemName = "guardian gem", clientId = 44603, sell = 5000 },
	{ itemName = "health potion", clientId = 266, buy = 50 },
	{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
	{ itemName = "hexagonal ruby", clientId = 30180, sell = 30000 },
	{ itemName = "hibiscus dress", clientId = 8045, sell = 3000 },
	{ itemName = "holy missile rune", clientId = 3182, buy = 16 },
	{ itemName = "icicle rune", clientId = 3158, buy = 30 },
	{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
	{ itemName = "leaf star", clientId = 25735, sell = 50 },
	{ itemName = "lesser guardian gem", clientId = 44602, sell = 1000 },
	{ itemName = "lesser marksman gem", clientId = 44605, sell = 1000 },
	{ itemName = "lesser mystic gem", clientId = 44611, sell = 1000 },
	{ itemName = "lesser sage gem", clientId = 44608, sell = 1000 },
	{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
	{ itemName = "lion figurine", clientId = 33781, sell = 10000 },
	{ itemName = "magic wall rune", clientId = 3180, buy = 116 },
	{ itemName = "mana potion", clientId = 268, buy = 56 },
	{ itemName = "mandrake", clientId = 5014, sell = 5000 },
	{ itemName = "marksman gem", clientId = 44606, sell = 5000 },
	{ itemName = "moonstone", clientId = 32771, sell = 13000 },
	{ itemName = "mystic gem", clientId = 44612, sell = 5000 },
	{ itemName = "onyx chip", clientId = 22193, sell = 500 },
	{ itemName = "opal", clientId = 22194, sell = 500 },
	{ itemName = "ornate locket", clientId = 30056, sell = 18000 },
	{ itemName = "panpipes", clientId = 2953, sell = 150 },
	{ itemName = "paralyse rune", clientId = 3165, buy = 700 },
	{ itemName = "poison bomb rune", clientId = 3173, buy = 85 },
	{ itemName = "poison field rune", clientId = 3172, buy = 21 },
	{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
	{ itemName = "powder herb", clientId = 3739, sell = 10 },
	{ itemName = "prismatic quartz", clientId = 24962, sell = 450 },
	{ itemName = "rainbow quartz", clientId = 25737, sell = 500 },
	{ itemName = "red crystal fragment", clientId = 16126, sell = 800 },
	{ itemName = "red rose", clientId = 3658, sell = 10 },
	{ itemName = "ruby necklace", clientId = 3016, buy = 3560 },
	{ itemName = "sage gem", clientId = 44609, sell = 5000 },
	{ itemName = "shimmering beetles", clientId = 25693, sell = 150 },
	{ itemName = "silver goblet", clientId = 5806, buy = 3000 },
	{ itemName = "skull coin", clientId = 32583, sell = 12000 },
	{ itemName = "sling herb", clientId = 3738, sell = 10 },
	{ itemName = "small amethyst", clientId = 3033, buy = 400, sell = 200 },
	{ itemName = "small diamond", clientId = 3028, buy = 600, sell = 300 },
	{ itemName = "small emerald", clientId = 3032, buy = 500, sell = 250 },
	{ itemName = "small enchanted amethyst", clientId = 678, sell = 200 },
	{ itemName = "small enchanted emerald", clientId = 677, sell = 250 },
	{ itemName = "small enchanted ruby", clientId = 676, sell = 250 },
	{ itemName = "small enchanted sapphire", clientId = 675, sell = 250 },
	{ itemName = "small ruby", clientId = 3030, buy = 500, sell = 250 },
	{ itemName = "small sapphire", clientId = 3029, buy = 500, sell = 250 },
	{ itemName = "small topaz", clientId = 9057, sell = 200 },
	{ itemName = "soulfire rune", clientId = 3195, buy = 46 },
	{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
	{ itemName = "star herb", clientId = 3736, sell = 15 },
	{ itemName = "stone herb", clientId = 3735, sell = 20 },
	{ itemName = "stone shower rune", clientId = 3175, buy = 41 },
	{ itemName = "strong health potion", clientId = 236, buy = 115 },
	{ itemName = "strong mana potion", clientId = 237, buy = 108 },
	{ itemName = "sudden death rune", clientId = 3155, buy = 162 },
	{ itemName = "summer dress", clientId = 8046, sell = 1500 },
	{ itemName = "supreme health potion", clientId = 23375, buy = 650 },
	{ itemName = "thunderstorm rune", clientId = 3202, buy = 52 },
	{ itemName = "tiger eye", clientId = 24961, sell = 350 },
	{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
	{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
	{ itemName = "ultimate mana potion", clientId = 23373, buy = 488 },
	{ itemName = "ultimate spirit potion", clientId = 23374, buy = 488 },
	{ itemName = "unicorn figurine", clientId = 30054, sell = 50000 },
	{ itemName = "vial", clientId = 2874, sell = 5 },
	{ itemName = "violet crystal shard", clientId = 16120, sell = 1500 },
	{ itemName = "watering can", clientId = 650, buy = 50 },
	{ itemName = "watermelon tourmaline", clientId = 33779, sell = 30000 },
	{ itemName = "wedding ring", clientId = 3004, buy = 990, sell = 100 },
	{ itemName = "white Gem", clientId = 32769, sell = 12000 },
	{ itemName = "white pearl", clientId = 3026, buy = 320, sell = 160 },
	{ itemName = "white silk flower", clientId = 34008, sell = 9000 },
	{ itemName = "wild flowers", clientId = 25691, sell = 120 },
	{ itemName = "wild growth rune", clientId = 3156, buy = 160 },
	{ itemName = "wood cape", clientId = 3575, sell = 5000 },
	{ itemName = "wooden spellbook", clientId = 25699, sell = 12000 },
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

npcType:register(npcConfig)
