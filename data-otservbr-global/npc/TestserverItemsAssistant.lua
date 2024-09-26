local internalNpcName = "Testserver Items Assistant"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 325,
	lookHead = 97,
	lookBody = 0,
	lookLegs = 79,
	lookFeet = 98,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
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

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	 { itemName = "pair of soulstalkers", clientId = 34098, buy = 1 },
	{ itemName = "pair of soulwalkers", clientId = 34097, buy = 1 },
	{ itemName = "soulbastion", clientId = 34099, buy = 5 },
	{ itemName = "soulbiter", clientId = 34084, buy = 1 },
	{ itemName = "soulbleeder", clientId = 34088, buy = 1 },
	{ itemName = "soulcrusher", clientId = 34086, buy = 1 },
	{ itemName = "soulcutter", clientId = 34082, buy = 1 },
    { itemName = "souleater", clientId = 34085, buy = 1 },
	{ itemName = "soulhexer", clientId = 34091, buy = 1 },
	{ itemName = "soulmaimer", clientId = 34087, buy = 1 },
	{ itemName = "soulmantle", clientId = 34095, buy = 1 },
	{ itemName = "soulpiercer", clientId = 34089, buy = 1 },
	{ itemName = "soulshanks", clientId = 34092, buy = 1 },
	{ itemName = "soulshell", clientId = 34094, buy = 1 },
	{ itemName = "soulshredder", clientId = 34083, buy = 1 },
	{ itemName = "soulshroud", clientId = 34096, buy = 1 },
	{ itemName = "soulstrider", clientId = 34093, buy = 1 },
	{ itemName = "soultainter", clientId = 34090, buy = 1 },
	{ itemName = "alicorn headguard", clientId = 39149, buy = 1 },
	{ itemName = "alicorn quiver", clientId = 39150, buy = 1 },
	{ itemName = "charged spiritthorn ring", clientId = 39177, buy = 1 },
	{ itemName = "arboreal crown", clientId = 39153, buy = 1 },
	{ itemName = "charged arboreal ring", clientId = 39186, buy = 1 },
	{ itemName = "arboreal tome", clientId = 39154, buy = 1 },
	{ itemName = "arcanomancer folio", clientId = 39152, buy = 1 },
	{ itemName = "arcanomancer regalia", clientId = 39151, buy = 1 },
	{ itemName = "charged arcanomancer sigil", clientId = 39183, buy = 1 },
	{ itemName = "charged alicorn ring", clientId = 39180, buy = 1 },
	{ itemName = "spiritthorn helmet", clientId = 39148, buy = 1 },
	{ itemName = "spiritthorn armor", clientId = 39147, buy = 1 },
	{ itemName = "grand sanguine battleaxe", clientId = 43875, buy = 1 },
	{ itemName = "grand sanguine blade", clientId = 43865, buy = 1 },
	{ itemName = "grand sanguine bludgeon", clientId = 43873, buy = 1 },
	{ itemName = "grand sanguine cudgel", clientId = 43867, buy = 1 },
	{ itemName = "grand sanguine hatchet", clientId = 43869, buy = 1 },
	{ itemName = "grand sanguine razor", clientId = 43871, buy = 1 },
	{ itemName = "sanguine legs", clientId = 43876, buy = 1 },
	{ itemName = "grand sanguine bow", clientId = 43878, buy = 1 },
	{ itemName = "grand sanguine crossbow", clientId = 43880, buy = 1 },
	{ itemName = "sanguine greaves", clientId = 43881, buy = 1 },
	{ itemName = "grand sanguine rod", clientId = 43886, buy = 1 },
	{ itemName = "sanguine galoshes", clientId = 43887, buy = 1 },
	{ itemName = "grand sanguine coil", clientId = 43883, buy = 1 },
	{ itemName = "sanguine boots", clientId = 43884, buy = 1 },
	{ itemName = "collar of blue plasma", clientId = 23526, buy = 1 },
	{ itemName = "collar of red plasma", clientId = 23528, buy = 1 },
	{ itemName = "collar of green plasma", clientId = 23527, buy = 1 },
	{ itemName = "enchanted pendulet", clientId = 30344, buy = 1 },
	{ itemName = "enchanted sleep shawl", clientId = 30342, buy = 1 },
	{ itemName = "enchanted theurgic amulet", clientId = 30402, buy = 1 },
	{ itemName = "enchanted turtle amulet", clientId = 39234, buy = 1 },
	{ itemName = "gill necklace", clientId = 16108, buy = 1 },
	{ itemName = "glacier amulet", clientId = 815, buy = 1 },
	{ itemName = "lightning pendant", clientId = 816, buy = 1 },
	{ itemName = "magma amulet", clientId = 817, buy = 1 },
	{ itemName = "prismatic necklace", clientId = 16113, buy = 1 },
	{ itemName = "sacred tree amulet", clientId = 9302, buy = 800 },
	{ itemName = "shockwave amulet", clientId = 9304, buy = 1 },
	{ itemName = "terra amulet", clientId = 814, buy = 1 },
	{ itemName = "stone skin amulet", clientId = 3081, buy = 1 },
	{ itemName = "might ring", clientId = 3048, buy = 1 },
	{ itemName = "blueberry cupcake", clientId = 28484,buy = 1 },
	{ itemName = "straberry cupcake", clientId = 28485, buy = 1 },
	{ itemName = "pot of blackjack", clientId = 11586, buy = 1 },
	{ itemName = "rotworm stew", clientId = 9079, buy = 1 },
	{ itemName = "silver token", clientId = 22516, buy = 1 },
	{ itemName = "gold token", clientId = 22721, buy = 1 },
	{ itemName = "nebula cube", clientId = 31633, buy = 1 },
	{ itemName = "nebula ring", clientId = 12669, buy = 1 },
	{ itemName = "Veteran Badge", clientId = 5785, buy = 1 },
	{ itemName = "Fierce Trophy", clientId = 9209, buy = 1 },
	{ itemName = "Gold Medal", clientId = 9215, buy = 1 },
	{ itemName = "Silver Medal", clientId = 9216, buy = 1 },
	{ itemName = "Sharpshoot Badge", clientId = 9218, buy = 1 },
	{ itemName = "Arcane Badge", clientId = 9219, buy = 1 },
	{ itemName = "Blood Badge", clientId = 9220, buy = 1 },
	{ itemName = "Void Badge", clientId = 9222, buy = 1 },
	{ itemName = "Elder Badge", clientId = 9223, buy = 1 },
	{ itemName = "Sage Badge", clientId = 9221, buy = 1 },
	{ itemName = "Swift Badge", clientId = 23487, buy = 1},
	{ itemName = "Falcon Circlet", clientId = 28714, buy = 1},
	{ itemName = "Falcon Coif", clientId = 28715, buy = 1},
	{ itemName = "Falcon Rod", clientId = 28716, buy = 1},
	{ itemName = "Falcon Wand", clientId = 28717, buy = 1},
	{ itemName = "Falcon Bow", clientId = 28718, buy = 1},
	{ itemName = "Falcon Plate", clientId = 28719, buy = 1},
	{ itemName = "Falcon Greaves", clientId = 28720, buy = 1},
	{ itemName = "Falcon Shield", clientId = 28721, buy = 1},
	{ itemName = "Falcon Escutcheon", clientId = 28722, buy = 1},
	{ itemName = "Falcon Longsword", clientId = 28723, buy = 1},
	{ itemName = "Falcon Battleaxe", clientId = 28724, buy = 1},
	{ itemName = "Falcon Mace", clientId = 28725, buy = 1},
	{ itemName = "Lion Longbow", clientId = 34150, buy = 1},
	{ itemName = "Lion Rod", clientId = 34151, buy = 1},
	{ itemName = "Lion Wand", clientId = 34152, buy = 1},
	{ itemName = "Lion Spellbook", clientId = 34153, buy = 1},
	{ itemName = "Lion Longsword", clientId = 34155, buy = 1},
	{ itemName = "Lion Spangenhelm", clientId = 34156, buy = 1},
	{ itemName = "Lion Plate", clientId = 34157, buy = 1},
	{ itemName = "Lion Amulet", clientId = 34158, buy = 1},
	{ itemName = "Lion Hammer", clientId = 34254, buy = 1},
	{ itemName = "Lion Shield", clientId = 34154, buy = 1},
	{ itemName = "Lion Axe", clientId = 34253, buy = 1},
	{ itemName = "Gnome Helmet", clientId = 27647, buy = 1},
	{ itemName = "Gnome Armor", clientId = 27648, buy = 1},
	{ itemName = "Gnome Legs", clientId = 27649, buy = 1},
	{ itemName = "Gnome Shield", clientId = 27650, buy = 1},
	{ itemName = "Gnome Sword", clientId = 27651, buy = 1},
	{ itemName = "Cobra Crossbow", clientId = 30393, buy = 1},
	{ itemName = "Cobra Amulet", clientId = 31631, buy = 1},
	{ itemName = "Cobra Boots", clientId = 30394, buy = 1},
	{ itemName = "Cobra Club", clientId = 30395, buy = 1},
	{ itemName = "Cobra Axe", clientId = 30396, buy = 1},
	{ itemName = "Cobra Hood", clientId = 30397, buy = 1},
	{ itemName = "Cobra Sword", clientId = 30398, buy = 1},
	{ itemName = "Cobra Wand", clientId = 30399, buy = 1},
	{ itemName = "Cobra Rod", clientId = 30400, buy = 1},
	{ itemName = "Cobra Sword", clientId = 30393, buy = 1},
	{ itemName = "Blade of Destruction", clientId = 27449, buy = 1},
	{ itemName = "Slayer of Destruction", clientId = 27450, buy = 1},
	{ itemName = "Axe of Destruction", clientId = 27451, buy = 1},
	{ itemName = "Chopper of Destruction", clientId = 27452, buy = 1},
	{ itemName = "Mace of Destruction", clientId = 27453, buy = 1},
	{ itemName = "Hammer of Destruction", clientId = 27454, buy = 1},
	{ itemName = "Bow of Destruction", clientId = 27455, buy = 1},
	{ itemName = "Crossbow of Destruction", clientId = 27456, buy = 1},
	{ itemName = "Wand of Destruction", clientId = 27457, buy = 1},
	{ itemName = "Rod of Destruction", clientId = 27458, buy = 1},

	
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
