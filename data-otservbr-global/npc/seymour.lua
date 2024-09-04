local internalNpcName = "Seymour"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1331,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 94,
	lookFeet = 114,
	lookAddons = 3,
	lookMount = 0,
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

keywordHandler:addKeyword(
	{ "pack imbuement" },
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Do you want to buy for Skill increase {Bash}, {Blockade}, {Chop}, {Epiphany}, {Precision}, {Slash}. Additional Attributes {Featherweight}, {Strike}, {Swiftness}, {Vampirism}, {Vibrancy}, {Void}. Elemental Damage {Electrify}, {Frost}, {Reap}, {Scorch}, {Venom}. Elemental Protection {Cloud Fabric}, {Demon Presence}, {Dragon Hide}, {Lich Shroud}, {Quara Scale}, {Snake Skin}?",
	}
)

-- Skill Pack

local stoneKeyword = keywordHandler:addKeyword({ "bash" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for skill club imbuement for 750000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 750000
end, function(player)
	if player:removeMoneyBank(750000) then
		player:addItem(9657, 20)
		player:addItem(22189, 15)
		player:addItem(10405, 10)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "blockade" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for skill shield imbuement for 1050000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 1050000
end, function(player)
	if player:removeMoneyBank(1050000) then
		player:addItem(18994, 20)
		player:addItem(11703, 25)
		player:addItem(20199, 25)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "chop" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for skill axe imbuement for 975000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 975000
end, function(player)
	if player:removeMoneyBank(975000) then
		player:addItem(10196, 20)
		player:addItem(11447, 25)
		player:addItem(21200, 20)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "epiphany" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for magic level imbuement for 825000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 825000
end, function(player)
	if player:removeMoneyBank(825000) then
		player:addItem(9635, 25)
		player:addItem(11452, 15)
		player:addItem(10309, 15)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "precision" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for skill distance imbuement for 825000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 825000
end, function(player)
	if player:removeMoneyBank(825000) then
		player:addItem(11464, 25)
		player:addItem(18994, 20)
		player:addItem(10298, 10)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "slash" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for skill sword imbuement for 825000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 825000
end, function(player)
	if player:removeMoneyBank(825000) then
		player:addItem(9691, 25)
		player:addItem(9640, 20)
		player:addItem(9654, 5)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

-- Additional Attributes

local stoneKeyword = keywordHandler:addKeyword({ "featherweight" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for capacity increase imbuement for 525000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 525000
end, function(player)
	if player:removeMoneyBank(525000) then
		player:addItem(25694, 20)
		player:addItem(25702, 10)
		player:addItem(20205, 5)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "strike" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for critical imbuement for 1000000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 1000000
end, function(player)
	if player:removeMoneyBank(1000000) then
		player:addItem(11444, 25)
		player:addItem(10311, 25)
		player:addItem(22728, 5)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "swiftness" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for speed imbuement for 1000000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 1000000
end, function(player)
	if player:removeMoneyBank(1000000) then
		player:addItem(17458, 15)
		player:addItem(10302, 25)
		player:addItem(14081, 20)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "vampirism" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for lifetime leech imbuement for 1000000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 1000000
end, function(player)
	if player:removeMoneyBank(1000000) then
		player:addItem(9685, 25)
		player:addItem(9633, 15)
		player:addItem(9663, 5)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "vibrancy" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for paralysis removal imbuement for 600000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 600000
end, function(player)
	if player:removeMoneyBank(600000) then
		player:addItem(22053, 20)
		player:addItem(23507, 15)
		player:addItem(28567, 5)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "void" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for mana leech imbuement for 1000000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 1000000
end, function(player)
	if player:removeMoneyBank(1000000) then
		player:addItem(11492, 25)
		player:addItem(20200, 25)
		player:addItem(22730, 5)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

-- Elemental Damage

local stoneKeyword = keywordHandler:addKeyword({ "electrify" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for energy damage imbuement for 465000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 465000
end, function(player)
	if player:removeMoneyBank(465000) then
		player:addItem(18993, 25)
		player:addItem(21975, 5)
		player:addItem(23508, 1)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "frost" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for ice damage imbuement for 600000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 600000
end, function(player)
	if player:removeMoneyBank(600000) then
		player:addItem(9661, 25)
		player:addItem(21801, 10)
		player:addItem(9650, 5)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "reap" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for death damage imbuement for 465000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 465000
end, function(player)
	if player:removeMoneyBank(465000) then
		player:addItem(11484, 25)
		player:addItem(9647, 20)
		player:addItem(10420, 5)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "scorch" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for fire damage imbuement for 525000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 525000
end, function(player)
	if player:removeMoneyBank(525000) then
		player:addItem(9636, 25)
		player:addItem(5920, 5)
		player:addItem(5954, 5)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "venom" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for energy damage imbuement for 705000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 705000
end, function(player)
	if player:removeMoneyBank(705000) then
		player:addItem(9686, 25)
		player:addItem(11703, 25)
		player:addItem(21194, 2)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

-- Elemental Protection

local stoneKeyword = keywordHandler:addKeyword({ "cloud fabric" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for energy protection imbuement for 6750000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 6750000
end, function(player)
	if player:removeMoneyBank(6750000) then
		player:addItem(9644, 25)
		player:addItem(14079, 15)
		player:addItem(9665, 10)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "demon presence" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for holy protection imbuement for 1050000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 1050000
end, function(player)
	if player:removeMoneyBank(1050000) then
		player:addItem(9639, 25)
		player:addItem(9638, 25)
		player:addItem(10304, 20)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "dragon hide" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for fire protection imbuement for 525000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 525000
end, function(player)
	if player:removeMoneyBank(525000) then
		player:addItem(5877, 20)
		player:addItem(16131, 10)
		player:addItem(11658, 5)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "lich shroud" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for death protection imbuement for 750000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 750000
end, function(player)
	if player:removeMoneyBank(750000) then
		player:addItem(11466, 25)
		player:addItem(22007, 20)
		player:addItem(9660, 5)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "quara scale" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for ice protection imbuement for 6750000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 6750000
end, function(player)
	if player:removeMoneyBank(6750000) then
		player:addItem(10295, 25)
		player:addItem(10307, 15)
		player:addItem(14012, 10)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "snake skin" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to buy items for earth protection imbuement for 825000 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 825000
end, function(player)
	if player:removeMoneyBank(825000) then
		player:addItem(17823, 25)
		player:addItem(9694, 20)
		player:addItem(11702, 10)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })

-- Basic

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME| say {pack imbuement} or {trade} for buy imbuement items.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "See you later |PLAYERNAME| come back soon.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you later |PLAYERNAME| come back soon.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "battle stone", clientId = 11447, buy = 15000 },
	{ itemName = "blazing bone", clientId = 16131, buy = 15000 },
	{ itemName = "bloody pincers", clientId = 9633, buy = 20000 },
	{ itemName = "brimstone fangs", clientId = 11702, buy = 15000 },
	{ itemName = "brimstone shell", clientId = 11703, buy = 15000 },
	{ itemName = "broken shamanic staff", clientId = 11452, buy = 15000 },
	{ itemName = "compass", clientId = 10302, buy = 15000 },
	{ itemName = "crawler head plating", clientId = 14079, buy = 15000 },
	{ itemName = "crystallized anger", clientId = 23507, buy = 15000 },
	{ itemName = "cultish mask", clientId = 9638, buy = 15000 },
	{ itemName = "cultish robe", clientId = 9639, buy = 15000 },
	{ itemName = "cyclops toe", clientId = 9657, buy = 15000 },
	{ itemName = "damselfly wing", clientId = 17458, buy = 15000 },
	{ itemName = "deepling warts", clientId = 14012, buy = 15000 },
	{ itemName = "demon horn", clientId = 5954, buy = 15000 },
	{ itemName = "demonic skeletal hand", clientId = 9647, buy = 15000 },
	{ itemName = "draken sulphur", clientId = 11658, buy = 15000 },
	{ itemName = "elven hoof", clientId = 18994, buy = 15000 },
	{ itemName = "elven scouting glass", clientId = 11464, buy = 15000 },
	{ itemName = "elvish talisman", clientId = 9635, buy = 15000 },
	{ itemName = "energy vein", clientId = 23508, buy = 15000 },
	{ itemName = "fairy wings", clientId = 25694, buy = 15000 },
	{ itemName = "fiery heart", clientId = 9636, buy = 15000 },
	{ itemName = "flask of embalming fluid", clientId = 11466, buy = 15000 },
	{ itemName = "frazzle skin", clientId = 20199, buy = 15000 },
	{ itemName = "frosty heart", clientId = 9661, buy = 15000 },
	{ itemName = "gloom wolf fur", clientId = 22007, buy = 15000 },
	{ itemName = "goosebump leather", clientId = 20205, buy = 15000 },
	{ itemName = "green dragon leather", clientId = 5877, buy = 15000 },
	{ itemName = "green dragon scale", clientId = 5920, buy = 15000 },
	{ itemName = "hellspawn tail", clientId = 10304, buy = 15000 },
	{ itemName = "lion's mane", clientId = 9691, buy = 15000 },
	{ itemName = "little bowl of myrrh", clientId = 25702, buy = 15000 },
	{ itemName = "metal spike", clientId = 10298, buy = 15000 },
	{ itemName = "mooh'tah shell", clientId = 21202, buy = 15000 },
	{ itemName = "moohtant horn", clientId = 21200, buy = 15000 },
	{ itemName = "mystical hourglass", clientId = 9660, buy = 15000 },
	{ itemName = "ogre nose ring", clientId = 22189, buy = 15000 },
	{ itemName = "orc tooth", clientId = 10196, buy = 15000 },
	{ itemName = "peacock feather fan", clientId = 21975, buy = 15000 },
	{ itemName = "petrified scream", clientId = 10420, buy = 15000 },
	{ itemName = "piece of dead brain", clientId = 9663, buy = 15000 },
	{ itemName = "piece of scarab shell", clientId = 9641, buy = 15000 },
	{ itemName = "piece of swampling wood", clientId = 17823, buy = 15000 },
	{ itemName = "pile of grave earth", clientId = 11484, buy = 15000 },
	{ itemName = "poisonous slime", clientId = 9640, buy = 15000 },
	{ itemName = "polar bear paw", clientId = 9650, buy = 15000 },
	{ itemName = "protective charm", clientId = 11444, buy = 20000 },
	{ itemName = "quill", clientId = 28567, buy = 15000 },
	{ itemName = "rope belt", clientId = 11492, buy = 15000 },
	{ itemName = "rorc feather", clientId = 18993, buy = 15000 },
	{ itemName = "sabretooth", clientId = 10311, buy = 20000 },
	{ itemName = "seacrest hair", clientId = 21801, buy = 15000 },
	{ itemName = "silencer claws", clientId = 20200, buy = 20000 },
	{ itemName = "slime heart", clientId = 21194, buy = 15000 },
	{ itemName = "snake skin", clientId = 9694, buy = 15000 },
	{ itemName = "some grimeleech wings", clientId = 22730, buy = 20000 },
	{ itemName = "strand of medusa hair", clientId = 10309, buy = 15000 },
	{ itemName = "swamp grass", clientId = 9686, buy = 15000 },
	{ itemName = "thick fur", clientId = 10307, buy = 15000 },
	{ itemName = "vampire teeth", clientId = 9685, buy = 20000 },
	{ itemName = "vexclaw talon", clientId = 22728, buy = 20000 },
	{ itemName = "war crystal", clientId = 9654, buy = 15000 },
	{ itemName = "warmaster's wristguards", clientId = 10405, buy = 15000 },
	{ itemName = "waspoid wing", clientId = 14081, buy = 15000 },
	{ itemName = "wereboar hooves", clientId = 22053, buy = 15000 },
	{ itemName = "winter wolf fur", clientId = 10295, buy = 15000 },
	{ itemName = "wyrm scale", clientId = 9665, buy = 15000 },
	{ itemName = "wyvern talisman", clientId = 9644, buy = 15000 },
	{ itemName = "warmaster's wristguards", clientId = 10405, buy = 15000 },
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
