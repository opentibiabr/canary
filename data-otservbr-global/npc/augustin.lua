local internalNpcName = "Augustin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1316,
	lookHead = 57,
	lookBody = 38,
	lookLegs = 21,
	lookFeet = 21,
	lookAddons = 0,
	lookMount = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Gems and jewellery! Best prices in town!" },
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

keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am a jeweler. Maybe you want to have a look at my wonderful offers." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Augustin." })

npcHandler:setMessage(MESSAGE_GREET, "Oh, please come in, |PLAYERNAME|. What do you need? Have a look at my wonderful {offers} in gems and jewellery.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "alptramun's toothbrush", clientId = 29943, sell = 270000 },
	{ itemName = "amber", clientId = 32626, sell = 20000 },
	{ itemName = "amber with a bug", clientId = 32624, sell = 41000 },
	{ itemName = "amber with a dragonfly", clientId = 32625, sell = 56000 },
	{ itemName = "ancient coin", clientId = 24390, sell = 350 },
	{ itemName = "ancient lich bone", clientId = 31588, sell = 28000 },
	{ itemName = "angel figurine", clientId = 32589, sell = 36000 },
	{ itemName = "bar of gold", clientId = 14112, sell = 10000 },
	{ itemName = "beast's nightmare-cushion", clientId = 29946, sell = 630000 },
	{ itemName = "black pearl", clientId = 3027, buy = 560, sell = 280 },
	{ itemName = "blue crystal shard", clientId = 16119, sell = 1500 },
	{ itemName = "blue crystal splinter", clientId = 16124, sell = 400 },
	{ itemName = "blue gem", clientId = 3041, sell = 5000 },
	{ itemName = "broken longbow", clientId = 34161, sell = 130 },
	{ itemName = "broken ring of ending", clientId = 12737, sell = 4000 },
	{ itemName = "broken visor", clientId = 20184, sell = 1900 },
	{ itemName = "bronze goblet", clientId = 5807, buy = 2000 },
	{ itemName = "brown crystal splinter", clientId = 16123, sell = 400 },
	{ itemName = "carnisylvan bark", clientId = 36806, sell = 230 },
	{ itemName = "carnisylvan finger", clientId = 36805, sell = 250 },
	{ itemName = "cobra crest", clientId = 31678, sell = 650 },
	{ itemName = "coral brooch", clientId = 24391, sell = 750 },
	{ itemName = "crunor idol", clientId = 30055, sell = 30000 },
	{ itemName = "cyan crystal fragment", clientId = 16125, sell = 800 },
	{ itemName = "damaged armor plates", clientId = 28822, sell = 280 },
	{ itemName = "demonic essence", clientId = 6499, sell = 1000 },
	{ itemName = "diamond", clientId = 32770, sell = 15000 },
	{ itemName = "dragon figurine", clientId = 30053, sell = 45000 },
	{ itemname = "eldritch crystal", clientid = 36835, sell = 48000 },
	{ itemname = "falcon crest", clientid = 28823, sell = 650 },
	{ itemname = "falcon crest", clientid = 28823, sell = 650 },
	{ itemname = "fiery tear", clientid = 39040, sell = 1070000 },
	{ itemname = "fur shred", clientid = 34164, sell = 200 },
	{ itemname = "gemmed figurine", clientid = 24392, sell = 3500 },
	{ itemname = "giant amethyst", clientid = 32622, sell = 60000 },
	{ itemname = "giant emerald", clientid = 30060, sell = 90000 },
	{ itemname = "giant ruby", clientid = 30059, sell = 70000 },
	{ itemname = "giant sapphire", clientid = 30061, sell = 50000 },
	{ itemname = "giant shimmering pearl", clientid = 281, sell = 3000 }, -- green
	{ itemname = "giant shimmering pearl", clientid = 282, sell = 3000 }, -- brown
	{ itemname = "giant topaz", clientid = 32623, sell = 80000 },
	{ itemname = "gold ingot", clientid = 9058, sell = 5000 },
	{ itemname = "gold nugget", clientid = 3040, sell = 850 },
	{ itemname = "golden figurine", clientid = 5799, sell = 3000 },
	{ itemname = "golden sickle", clientid = 3306, sell = 1000 },
	{ itemname = "grant of arms", clientid = 28824, buy = 950 },
	{ itemname = "golden amulet", clientid = 3013, buy = 6600 },
	{ itemname = "golden goblet", clientid = 5805, buy = 5000 },
	{ itemname = "green crystal fragment", clientid = 16127, sell = 800 },
	{ itemname = "green crystal shard", clientid = 16121, sell = 1500 },
	{ itemname = "green crystal splinter", clientid = 16122, sell = 400 },
	{ itemname = "green gem", clientid = 3038, sell = 5000 },
	{ itemname = "hexagonal ruby", clientid = 30180, sell = 30000 },
	{ itemname = "human teeth", clientid = 36807, sell = 2000 },
	{ itemname = "izcandar's snow globe", clientid = 29944, sell = 180000 },
	{ itemname = "izcandar's sundial", clientid = 29945, sell = 225000 },
	{ itemname = "lion cloak patch", clientid = 34162, sell = 190 },
	{ itemname = "lion crest", clientid = 34160, sell = 270 },
	{ itemname = "lion figurine", clientid = 33781, sell = 10000 },
	{ itemname = "lion seal", clientid = 34163, sell = 210 },
	{ itemname = "malofur's lunchbox", clientid = 30088, sell = 240000 },
	{ itemname = "maxxenius head", clientid = 29942, sell = 500000 },
	{ itemname = "moonstone", clientid = 32771, sell = 13000 },
	{ itemname = "onyx chip", clientid = 22193, sell = 500 },
	{ itemname = "opal", clientid = 22194, sell = 500 },
	{ itemname = "orichalcum pearl", clientid = 5021, sell = 40 },
	{ itemname = "ornate locket", clientid = 30056, sell = 18000 },
	{ itemname = "plagueroot offshoot", clientid = 30087, sell = 280000 },
	{ itemname = "poisonous slime", clientid = 9640, sell = 50 },
	{ itemname = "prismatic quartz", clientid = 24962, sell = 450 },
	{ itemname = "purple tome", clientid = 2848, sell = 2000 },
	{ itemname = "rainbow quartz", clientid = 25737, sell = 500 },
	{ itemname = "red crystal fragment", clientid = 16126, sell = 800 },
	{ itemname = "red gem", clientid = 3039, sell = 1000 },
	{ itemname = "Rotten Heart", clientid = 31589, sell = 74000 },
	{ itemname = "Royal Almandine", clientid = 39038, sell = 460000 },
	{ itemname = "Sight of Surrender's Eye", clientid = 20183, sell = 3000 },
	{ itemName = "ruby necklace", clientId = 3016, buy = 3560 },
	{ itemName = "silver goblet", clientId = 5806, buy = 3000 },
	{ itemName = "skull coin", clientId = 32583, sell = 12000 },
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
	{ itemName = "Soul Orb", clientId = 5944, sell = 25 },
	{ itemName = "Talon", clientId = 3034, sell = 320 },
	{ itemName = "tiger eye", clientId = 24961, sell = 350 },
	{ itemName = "unicorn figurine", clientId = 30054, sell = 50000 },
	{ itemName = "violet crystal shard", clientId = 16120, sell = 1500 },
	{ itemName = "Violet Gem", clientId = 3036, sell = 10000 },
	{ itemName = "Watermelon Tourmaline", clientId = 33780, sell = 230000 },
	{ itemName = "Watermelon Tourmaline", clientId = 33779, sell = 30000 },
	{ itemName = "white silk flower", clientId = 34008, sell = 9000 },
	{ itemName = "wedding ring", clientId = 3004, buy = 990, sell = 100 },
	{ itemName = "White Gem", clientId = 32769, sell = 12000 },
	{ itemName = "white pearl", clientId = 3026, buy = 320, sell = 160 },
	{ itemName = "White Silk Flower", clientId = 34008, sell = 9000 },
	{ itemName = "Yellow Gem", clientId = 3037, sell = 1000 },
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
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
