local internalNpcName = "Coltrayne"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 134,
	lookHead = 114,
	lookBody = 38,
	lookLegs = 124,
	lookFeet = 78,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = "Team up with others to defeat monsters!"},
	{text = "Get your gear and help us defend Dawnport against the monsters!"},
	{text = "Better weapons equal more damage - get yourself some gear right here!"},
	{text = "Gird youselves! Chain mail, bows, spears, swords - we've got it all!"},
	{text = "Skill comes with practice - get out there and kill some beasts!"}
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

keywordHandler:addKeyword({'name'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Coltrayne Daggard. Just ask me for a trade to see the latest in chain mail and weapons."
	}
)
keywordHandler:addKeyword({'job'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm a blacksmith by trade. Want to keep our lads and lasses safe and equipped with a sharp blade, me."
	}
)
keywordHandler:addKeyword({'rookgaard'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You mean to imply I am an inexperienced guardian? Get out of here."
	}
)
keywordHandler:addKeyword({'coltrayne'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = " Yes. You wish to trade I guess. At least, you look like you could use some good gear, kid."
	}
)
keywordHandler:addKeyword({'hamish'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Good at potions. Likes experimenting. Can kit you out with magical equipment for a hunt."
	}
)
keywordHandler:addKeyword({'inigo'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Gives newcomers hints how we do things here in Tibia. Don't know how to use something? Ask Inigo."
	}
)
keywordHandler:addKeyword({'garamond'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Don't have much to say about him. Barely know him. Seems a decent spell teacher for mages."
	}
)
keywordHandler:addKeyword({'ser tybald'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm sure I've seen his face before somewhere... \z
		never mind. Anyway, he's the knight and paladin spell teacher around here, letting you try them out for free. \z
		Don't underestimate the use of spells, even if you're not a mage."
	}
)
keywordHandler:addKeyword({'richard'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He's just in the next shop to the left, selling food and equipment \z
		like ropes and shovels and fishing rods and such."
	}
)
keywordHandler:addKeyword({'mr morris'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He had a plan, as usual. Came here, set up the outpost, managed everything. \z
		Looking for a task or quest? He's your man."
	}
)
keywordHandler:addKeyword({'oressa'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "She's our local healer. Downstairs in the temple and oracle room, that's where she is. \z
		Just say 'heal' or 'help' and she'll help ya if you really need it."
	}
)
keywordHandler:addKeyword({'plunderpurse'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Pirates and gold, you get the rest. Hoards gold now for young adventurers - \z
		keeps it safe while you go out hunting."
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Hey there. Need some armor or weapon? Then ask me for a {trade}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yeah, bye..")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "arrow", clientId = 3447, buy = 3 },
	{ itemName = "axe", clientId = 3274, buy = 20, sell = 7 },
	{ itemName = "bolt", clientId = 3446, buy = 4 },
	{ itemName = "bone club", clientId = 3337, sell = 5 },
	{ itemName = "brass helmet", clientId = 3354, sell = 22 },
	{ itemName = "brass shield", clientId = 3411, sell = 25 },
	{ itemName = "chain armor", clientId = 3358, sell = 40 },
	{ itemName = "chain helmet", clientId = 3352, buy = 52, sell = 12 },
	{ itemName = "coat", clientId = 3562, buy = 8 },
	{ itemName = "copper shield", clientId = 3430, sell = 50 },
	{ itemName = "crossbow", clientId = 3349, buy = 500 },
	{ itemName = "dagger", clientId = 3267, buy = 5, sell = 2 },
	{ itemName = "doublet", clientId = 3379, buy = 16, sell = 3 },
	{ itemName = "hand axe", clientId = 3268, buy = 8, sell = 4 },
	{ itemName = "hatchet", clientId = 3276, sell = 25 },
	{ itemName = "jacket", clientId = 3561, buy = 10 },
	{ itemName = "katana", clientId = 3300, sell = 35 },
	{ itemName = "leather armor", clientId = 3361, buy = 25, sell = 5 },
	{ itemName = "leather boots", clientId = 3552, sell = 2 },
	{ itemName = "leather helmet", clientId = 3355, buy = 12 },
	{ itemName = "leather legs", clientId = 3559, buy = 10 },
	{ itemName = "legion helmet", clientId = 3374, sell = 22 },
	{ itemName = "mace", clientId = 3286, sell = 30 },
	{ itemName = "machete", clientId = 3308, sell = 6 },
	{ itemName = "plate shield", clientId = 3410, sell = 40 },
	{ itemName = "rapier", clientId = 3272, buy = 15, sell = 5 },
	{ itemName = "sabre", clientId = 3273, buy = 25, sell = 12 },
	{ itemName = "scythe", clientId = 3453, buy = 12, sell = 3 },
	{ itemName = "short sword", clientId = 3294, buy = 30, sell = 10 },
	{ itemName = "sickle", clientId = 3293, buy = 8, sell = 2 },
	{ itemName = "spear", clientId = 3277, buy = 10, sell = 3 },
	{ itemName = "studded armor", clientId = 3378, sell = 10 },
	{ itemName = "studded helmet", clientId = 3376, buy = 63, sell = 20 },
	{ itemName = "studded legs", clientId = 3362, sell = 15 },
	{ itemName = "studded shield", clientId = 3426, buy = 50, sell = 16 },
	{ itemName = "sword", clientId = 3264, sell = 25 },
	{ itemName = "viking helmet", clientId = 3367, sell = 25 },
	{ itemName = "wooden shield", clientId = 3412, buy = 15 }
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
