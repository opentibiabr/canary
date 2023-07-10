local internalNpcName = "Fiona"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 137,
	lookHead = 115,
	lookBody = 100,
	lookLegs = 95,
	lookFeet = 38,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'The Edron academy is always in need of magical ingredients!'}
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

keywordHandler:addKeyword({'magical ingredients'}, StdModule.say, {npcHandler = npcHandler, text = "Oof, there are too many to list. Magical ingredients can sometimes be found when you defeat a monster, for example bat wings. I buy many of these things if you don't want to use them for quests, just ask me for a {trade}."})

npcHandler:setMessage(MESSAGE_GREET, "Good day, |PLAYERNAME|. I hope you bring a lot of {magical ingredients} with you.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and please come back soon.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye and please come back soon.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Sure, take a look. Apart from those, I also buy some of the possessions from famous demonlords and bosses. Ask me about it if you found anything interesting.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "basalt fetish", clientId = 17856, sell = 210 },
	{ itemName = "basalt figurine", clientId = 17857, sell = 160 },
	{ itemName = "bat wing", clientId = 5894, sell = 50 },
	{ itemName = "behemoth claw", clientId = 5930, sell = 2000 },
	{ itemName = "berserk potion", clientId = 7439, sell = 500 },
	{ itemName = "blazing bone", clientId = 16131, sell = 610 },
	{ itemName = "blood tincture in a vial", clientId = 18928, sell = 360 },
	{ itemName = "bloody dwarven beard", clientId = 17827, sell = 110 },
	{ itemName = "bola", clientId = 17809, sell = 35 },
	{ itemName = "bone fetish", clientId = 17831, sell = 150 },
	{ itemName = "bonelord eye", clientId = 5898, sell = 80 },
	{ itemName = "bony tail", clientId = 10277, sell = 210 },
	{ itemName = "brimstone fangs", clientId = 11702, sell = 380 },
	{ itemName = "brimstone shell", clientId = 11703, sell = 210 },
	{ itemName = "broken throwing axe", clientId = 17851, sell = 230 },
	{ itemName = "bullseye potion", clientId = 7443, sell = 500 },
	{ itemName = "carrion worm fang", clientId = 10275, sell = 35 },
	{ itemName = "cheese cutter", clientId = 17817, sell = 50 },
	{ itemName = "chicken feather", clientId = 5890, sell = 30 },
	{ itemName = "deeptags", clientId = 14013, sell = 290 },
	{ itemName = "demon dust", clientId = 5906, sell = 300 },
	{ itemName = "demon horn", clientId = 5954, sell = 1000 },
	{ itemName = "demonic skeletal hand", clientId = 9647, sell = 80 },
	{ itemName = "dragon priests wandtip", clientId = 10444, sell = 175 },
	{ itemName = "dragons tail", clientId = 11457, sell = 100 },
	{ itemName = "draken sulphur", clientId = 11658, sell = 550 },
	{ itemName = "elder bonelord tentacle", clientId = 10276, sell = 150 },
	{ itemName = "elven astral observer", clientId = 11465, sell = 90 },
	{ itemName = "elven scouting glass", clientId = 11464, sell = 50 },
	{ itemName = "enchanted chicken wing", clientId = 5891, sell = 20000 },
	{ itemName = "fiery heart", clientId = 9636, sell = 375 },
	{ itemName = "fish fin", clientId = 5895, sell = 150 },
	{ itemName = "flask of warriors sweat", clientId = 5885, sell = 10000 },
	{ itemName = "frosty heart", clientId = 9661, sell = 280 },
	{ itemName = "gauze bandage", clientId = 9649, sell = 90 },
	{ itemName = "geomancers staff", clientId = 11463, sell = 120 },
	{ itemName = "giant eye", clientId = 10280, sell = 380 },
	{ itemName = "glob of acid slime", clientId = 9054, sell = 25 },
	{ itemName = "glob of mercury", clientId = 9053, sell = 20 },
	{ itemName = "glob of tar", clientId = 9055, sell = 30 },
	{ itemName = "green dragon scale", clientId = 5920, sell = 100 },
	{ itemName = "hardened bone", clientId = 5925, sell = 70 },
	{ itemName = "heaven blossom", clientId = 5921, sell = 50 },
	{ itemName = "hellspawn tail", clientId = 10304, sell = 475 },
	{ itemName = "hideous chunk", clientId = 16140, sell = 510 },
	{ itemName = "holy ash", clientId = 17850, sell = 160 },
	{ itemName = "holy orchid", clientId = 5922, sell = 90 },
	{ itemName = "honeycomb", clientId = 5902, sell = 40 },
	{ itemName = "humongous chunk", clientId = 16139, sell = 540 },
	{ itemName = "key to the drowned library", clientId = 14009, sell = 330 },
	{ itemName = "lizard scale", clientId = 5881, sell = 120 },
	{ itemName = "lost basher's spike", clientId = 17826, sell = 280 },
	{ itemName = "lost bracers", clientId = 17853, sell = 140 },
	{ itemName = "lost husher's staff", clientId = 17848, sell = 250 },
	{ itemName = "luminous orb", clientId = 11454, sell = 1000 },
	{ itemName = "mad froth", clientId = 17854, sell = 80 },
	{ itemName = "magic sulphur", clientId = 5904, sell = 8000 },
	{ itemName = "mastermind potion", clientId = 7440, sell = 500 },
	{ itemName = "miraculum", clientId = 11474, sell = 60 },
	{ itemName = "mystical hourglass", clientId = 9660, sell = 700 },
	{ itemName = "pair of hellflayer horns", clientId = 22729, sell = 1300 },
	{ itemName = "perfect behemoth fang", clientId = 5893, sell = 250 },
	{ itemName = "red dragon scale", clientId = 5882, sell = 200 },
	{ itemName = "red hair dye", clientId = 17855, sell = 40 },
	{ itemName = "scythe leg", clientId = 10312, sell = 450 },
	{ itemName = "sea serpent scale", clientId = 9666, sell = 520 },
	{ itemName = "skull shatterer", clientId = 17849, sell = 170 },
	{ itemName = "small flask of eyedrops", clientId = 11512, sell = 95 },
	{ itemName = "some grimeleech wings", clientId = 22730, sell = 1200 },
	{ itemName = "spellsinger's seal", clientId = 14008, sell = 280 },
	{ itemName = "spider silk", clientId = 5879, sell = 100 },
	{ itemName = "spirit container", clientId = 5884, sell = 40000 },
	{ itemName = "spooky blue eye", clientId = 9642, sell = 95 },
	{ itemName = "stone wing", clientId = 10278, sell = 120 },
	{ itemName = "turtle shell", clientId = 5899, sell = 90 },
	{ itemName = "vampire dust", clientId = 5905, sell = 100 },
	{ itemName = "vexclaw talon", clientId = 22728, sell = 1100 },
	{ itemName = "weaver's wandtip", clientId = 10397, sell = 250 },
	{ itemName = "wimp tooth chain", clientId = 17847, sell = 120 },
	{ itemName = "wyrm scale", clientId = 9665, sell = 400 },
	{ itemName = "wyvern talisman", clientId = 9644, sell = 265 }
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
