local internalNpcName = "Imbuement Assistant"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 141,
	lookHead = 41,
	lookBody = 72,
	lookLegs = 39,
	lookFeet = 96,
	lookAddons = 3,
	lookMount = 688,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Hello adventurer, looking for Imbuement items? Just ask me!" },
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

keywordHandler:addKeyword({"imbuement packages"}, StdModule.say, {npcHandler = npcHandler, text = "Skill Increase: {Bash}, {Blockade}, {Chop}, {Epiphany}, {Precision}, {Slash}. Additional Attributes: {Featherweight}, {Strike}, {Swiftness}, {Vampirism}, {Vibrancy}, {Void}. Elemental Damage: {Electrify}, {Frost}, {Reap}, {Scorch}, {Venom}. Elemental Protection: {Cloud Fabric}, {Demon Presence}, {Dragon Hide}, {Lich Shroud}, {Quara Scale}, {Snake Skin}."})

function addItemsToShoppingBag(player, moneyRequired, itemList)
	if player:removeMoneyBank(moneyRequired) then
		local shoppingBag = player:addItem(2856, 1) -- present box
		for _, item in pairs(itemList) do
			shoppingBag:addItem(item.itemId, item.count)
		end
		return true
	end
	return false
end

local function purchaseItems(keyword, text, moneyRequired, itemList)
	local stoneKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to " .. text .. " for " .. moneyRequired .. " gold?"})
	stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
		function(player) return player:getMoney() + player:getBankBalance() >= moneyRequired end,
		function(player) return addItemsToShoppingBag(player, moneyRequired, itemList) end
	)
	stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})
end


function addKeywordForImbuement(keyword, description, cost, items)
	local stoneKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for " .. description .. " imbuement for " .. cost .. " gold?"})
	
	stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
		function(player) return player:getMoney() + player:getBankBalance() >= cost end,
		function(player)
			if player:removeMoneyBank(cost) then
				local shoppingBag = player:addItem(2856, 1) -- present box
				for itemID, itemCount in pairs(items) do
					shoppingBag:addItem(itemID, itemCount)
				end
			end
		end
	)
	
	stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})
end

-- Skill increase packages
purchaseItems("bash", "buy items for skill club imbuement", 6250, {
	{itemId = 9657, count = 20},
	{itemId = 22189, count = 15},
	{itemId = 10405, count = 10}
})

purchaseItems("blockade", "buy items for skill shield imbuement", 16150, {
	{itemId = 9641, count = 20},
	{itemId = 11703, count = 25},
	{itemId = 20199, count = 25}
})

purchaseItems("chop", "buy items for skill axe imbuement", 13050, {
	{itemId = 10196, count = 20},
	{itemId = 11447, count = 25},
	{itemId = 21200, count = 20}
})

purchaseItems("epiphany", "buy items for magic level imbuement", 10650, {
	{itemId = 9635, count = 25},
	{itemId = 11452, count = 15},
	{itemId = 10309, count = 15}
})

purchaseItems("precision", "buy items for skill distance imbuement", 6750, {
	{itemId = 11464, count = 25},
	{itemId = 18994, count = 20},
	{itemId = 10298, count = 10}
})

purchaseItems("slash", "buy items for skill sword imbuement", 6550, {
	{itemId = 9691, count = 25},
	{itemId = 21202, count = 25},
	{itemId = 9654, count = 5}
})

-- Additional attributes packages
addKeywordForImbuement("featherweight", "capacity increase", 12250, { [25694] = 20, [25702] = 10, [20205] = 5 })
addKeywordForImbuement("strike", "critical", 16700, { [11444] = 20, [10311] = 25, [22728] = 5 })
addKeywordForImbuement("swiftness", "speed", 5225, { [17458] = 15, [10302] = 25, [14081] = 20 })
addKeywordForImbuement("vampirism", "life leech", 10475, { [9685] = 25, [9633] = 15, [9663] = 5 })
addKeywordForImbuement("vibrancy", "paralysis removal", 15000, { [22053] = 20, [23507] = 15, [28567] = 5 })
addKeywordForImbuement("void", "mana leech", 17400, { [11492] = 25, [20200] = 25, [22730] = 5 })
-- Elemental damage packages
addKeywordForImbuement("electrify", "energy damage", 3770, { [18993] = 25, [21975] = 5, [23508] = 1 })
addKeywordForImbuement("frost", "ice damage", 9750, { [9661] = 25, [21801] = 10, [9650] = 5 })
addKeywordForImbuement("reap", "death damage", 3475, { [11484] = 25, [9647] = 20, [10420] = 5 })
addKeywordForImbuement("scorch", "fire damage", 15875, { [9636] = 25, [5920] = 5, [5954] = 5 })
addKeywordForImbuement("venom", "earth damage", 1820, { [9686] = 25, [9640] = 20, [21194] = 2 })
-- Elemental protection packages
addKeywordForImbuement("cloud fabric", "energy protection", 13775, { [9644] = 20, [14079] = 15, [9665] = 10 })
addKeywordForImbuement("demon presence", "holy protection", 20250, { [9639] = 25, [9638] = 25, [10304] = 20 })
addKeywordForImbuement("dragon hide", "fire protection", 10850, { [5877] = 20, [16131] = 10, [11658] = 5 })
addKeywordForImbuement("lich shroud", "death protection", 5650, { [11466] = 25, [22007] = 20, [9660] = 5 })
addKeywordForImbuement("quara scale", "ice protection", 3650, { [10295] = 25, [10307] = 15, [14012] = 10 })
addKeywordForImbuement("snake skin", "earth protection", 12550, { [17823] = 25, [9694] = 20, [11702] = 10 })

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME| say {imbuement packages} or {trade} for buy imbuement items.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "See you later |PLAYERNAME| come back soon.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you later |PLAYERNAME| come back soon.") 

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "battle stone", clientId = 11447, buy = 290 },
	{ itemName = "blazing bone", clientId = 16131, buy = 610 },
	{ itemName = "bloody pincers", clientId = 9633, buy = 100 },
	{ itemName = "brimstone fangs", clientId = 11702, buy = 380 },
	{ itemName = "brimstone shell", clientId = 11703, buy = 210 },
	{ itemName = "broken shamanic staff", clientId = 11452, buy = 35 },
	{ itemName = "compass", clientId = 10302, buy = 45 },
	{ itemName = "crawler head plating", clientId = 14079, buy = 210 },
	{ itemName = "crystallized anger", clientId = 23507, buy = 400 },
	{ itemName = "cultish mask", clientId = 9638, buy = 280 },
	{ itemName = "cultish robe", clientId = 9639, buy = 150 },
	{ itemName = "cyclops toe", clientId = 9657, buy = 55 },
	{ itemName = "damselfly wing", clientId = 17458, buy = 20 },
	{ itemName = "deepling warts", clientId = 14012, buy = 180 },
	{ itemName = "demon horn", clientId = 5954, buy = 1000 },
	{ itemName = "demonic skeletal hand", clientId = 9647, buy = 80 },
	{ itemName = "draken sulphur", clientId = 11658, buy = 550 },
	{ itemName = "elven hoof", clientId = 18994, buy = 115 },
	{ itemName = "elven scouting glass", clientId = 11464, buy = 50 },
	{ itemName = "elvish talisman", clientId = 9635, buy = 45 },
	{ itemName = "energy vein", clientId = 23508, buy = 270 },
	{ itemName = "fairy wings", clientId = 25694, buy = 200 },
	{ itemName = "fiery heart", clientId = 9636, buy = 375 },
	{ itemName = "flask of embalming fluid", clientId = 11466, buy = 30 },
	{ itemName = "frazzle skin", clientId = 20199, buy = 400 },
	{ itemName = "frosty heart", clientId = 9661, buy = 280 },
	{ itemName = "gloom wolf fur", clientId = 22007, buy = 70 },
	{ itemName = "goosebump leather", clientId = 20205, buy = 650 },
	{ itemName = "green dragon leather", clientId = 5877, buy = 100 },
	{ itemName = "green dragon scale", clientId = 5920, buy = 100 },
	{ itemName = "hellspawn tail", clientId = 10304, buy = 475 },
	{ itemName = "lion's mane", clientId = 9691, buy = 60 },
	{ itemName = "little bowl of myrrh", clientId = 25702, buy = 500 },
	{ itemName = "metal spike", clientId = 10298, buy = 320 },
	{ itemName = "mooh'tah shell", clientId = 21202, buy = 110 },
	{ itemName = "moohtant horn", clientId = 21200, buy = 140 },
	{ itemName = "mystical hourglass", clientId = 9660, buy = 700 },
	{ itemName = "ogre nose ring", clientId = 22189, buy = 210 },
	{ itemName = "orc tooth", clientId = 10196, buy = 150 },
	{ itemName = "peacock feather fan", clientId = 21975, buy = 350 },
	{ itemName = "petrified scream", clientId = 10420, buy = 250 },
	{ itemName = "piece of dead brain", clientId = 9663, buy = 420 },
	{ itemName = "piece of scarab shell", clientId = 9641, buy = 45 },
	{ itemName = "piece of swampling wood", clientId = 17823, buy = 30 },
	{ itemName = "pile of grave earth", clientId = 11484, buy = 25 },
	{ itemName = "poisonous slime", clientId = 9640, buy = 50 },
	{ itemName = "polar bear paw", clientId = 9650, buy = 30 },
	{ itemName = "protective charm", clientId = 11444, buy = 60 },
	{ itemName = "quill", clientId = 28567, buy = 1100 },
	{ itemName = "rope belt", clientId = 11492, buy = 66 },
	{ itemName = "rorc feather", clientId = 18993, buy = 70 },
	{ itemName = "sabretooth", clientId = 10311, buy = 400 },
	{ itemName = "seacrest hair", clientId = 21801, buy = 260 },
	{ itemName = "silencer claws", clientId = 20200, buy = 390 },
	{ itemName = "slime heart", clientId = 21194, buy = 160 },
	{ itemName = "snake skin", clientId = 9694, buy = 400 },
	{ itemName = "some grimeleech wings", clientId = 22730, buy = 1200 },
	{ itemName = "strand of medusa hair", clientId = 10309, buy = 600 },
	{ itemName = "swamp grass", clientId = 9686, buy = 20 },
	{ itemName = "thick fur", clientId = 10307, buy = 150 },
	{ itemName = "vampire teeth", clientId = 9685, buy = 275 },
	{ itemName = "vexclaw talon", clientId = 22728, buy = 1100 },
	{ itemName = "war crystal", clientId = 9654, buy = 460 },
	{ itemName = "warmaster's wristguards", clientId = 10405, buy = 200 },
	{ itemName = "waspoid wing", clientId = 14081, buy = 190 },
	{ itemName = "wereboar hooves", clientId = 22053, buy = 175 },
	{ itemName = "winter wolf fur", clientId = 10295, buy = 20 },
	{ itemName = "wyrm scale", clientId = 9665, buy = 400 },
	{ itemName = "wyvern talisman", clientId = 9644, buy = 265 },
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
