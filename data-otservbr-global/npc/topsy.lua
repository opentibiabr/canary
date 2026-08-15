local internalNpcName = "Topsy"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 139,
	lookHead = 78,
	lookBody = 52,
	lookLegs = 100,
	lookFeet = 115,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "trader",
}
npcConfig.speechBubble = SPEECHBUBBLE_TRADE

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Runes, wands, rods, health and mana potions! Have a look!" },
}

local itemsTable = {
	["potions"] = {
		{ itemName = "empty potion flask", clientId = 283, sell = 5 },
		{ itemName = "empty potion flask", clientId = 284, sell = 5 },
		{ itemName = "empty potion flask", clientId = 285, sell = 5 },
		{ itemName = "great health potion", clientId = 239, buy = 225 },
		{ itemName = "great mana potion", clientId = 238, buy = 158 },
		{ itemName = "great spirit potion", clientId = 7642, buy = 254 },
		{ itemName = "health potion", clientId = 266, buy = 50 },
		{ itemName = "mana potion", clientId = 268, buy = 56 },
		{ itemName = "strong health potion", clientId = 236, buy = 115 },
		{ itemName = "strong mana potion", clientId = 237, buy = 108 },
		{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
		{ itemName = "vial", clientId = 2874, sell = 5 },
	},
	["runes"] = {
		{ itemName = "avalanche rune", clientId = 3161, buy = 64 },
		{ itemName = "blank rune", clientId = 3147, buy = 10 },
		{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
		{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
		{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
		{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
		{ itemName = "energy field rune", clientId = 3164, buy = 38 },
		{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
		{ itemName = "explosion rune", clientId = 3200, buy = 31 },
		{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },
		{ itemName = "fire field rune", clientId = 3188, buy = 28 },
		{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
		{ itemName = "great fireball rune", clientId = 3191, buy = 64 },
		{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
		{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
		{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
		{ itemName = "poison field rune", clientId = 3172, buy = 21 },
		{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
		{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
		{ itemName = "sudden death rune", clientId = 3155, buy = 162 },
		{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
	},
	["wands"] = {
		{ itemName = "moonlight rod", clientId = 3070, buy = 1000 },
		{ itemName = "necrotic rod", clientId = 3069, buy = 5000 },
		{ itemName = "snakebite rod", clientId = 3066, buy = 500 },
		{ itemName = "springsprout rod", clientId = 8084, buy = 18000 },
		{ itemName = "terra rod", clientId = 3065, buy = 10000 },
		{ itemName = "wand of cosmic energy", clientId = 3073, buy = 10000 },
		{ itemName = "wand of decay", clientId = 3072, buy = 5000 },
		{ itemName = "wand of dragonbreath", clientId = 3075, buy = 1000 },
		{ itemName = "wand of vortex", clientId = 3074, buy = 500 },
	},
	["exercise weapons"] = {
		{ itemName = "durable exercise rod", clientId = 35283, buy = 1250000, count = 1800 },
		{ itemName = "durable exercise wand", clientId = 35284, buy = 1250000, count = 1800 },
		{ itemName = "exercise rod", clientId = 28556, buy = 347222, count = 500 },
		{ itemName = "exercise wand", clientId = 28557, buy = 347222, count = 500 },
		{ itemName = "lasting exercise rod", clientId = 35289, buy = 10000000, count = 14400 },
		{ itemName = "lasting exercise wand", clientId = 35290, buy = 10000000, count = 14400 },
	},
	["others"] = {
		{ itemName = "spellwand", clientId = 651, sell = 299 },
	},
	["shields"] = {
		{ itemName = "spellbook", clientId = 3059, buy = 150 },
	},
}

npcConfig.shop = {}
for _, categoryTable in pairs(itemsTable) do
	for _, itemTable in ipairs(categoryTable) do
		table.insert(npcConfig.shop, itemTable)
	end
end

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

local items = {
	[VOCATION.BASE_ID.SORCERER] = 3074,
	[VOCATION.BASE_ID.DRUID] = 3066,
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local categoryTable = itemsTable[message:lower()]
	local itemId = items[player:getVocation():getBaseId()]
	if MsgContains(message, "first rod") or MsgContains(message, "first wand") then
		if player:isMage() then
			if player:getStorageValue(Storage.FirstMageWeapon) == -1 then
				npcHandler:say("So you ask me for a {" .. ItemType(itemId):getName() .. "} to begin your adventure?", npc, creature)
				npcHandler:setTopic(playerId, 1)
			else
				npcHandler:say("What? I have already gave you one {" .. ItemType(itemId):getName() .. "}!", npc, creature)
			end
		else
			npcHandler:say("Sorry, you aren't a druid either a sorcerer.", npc, creature)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			player:addItem(itemId, 1)
			npcHandler:say("Here you are young adept, take care yourself.", npc, creature)
			player:setStorageValue(Storage.FirstMageWeapon, 1)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Ok then.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif categoryTable then
		local remainingCategories = npc:getRemainingShopCategories(message:lower(), itemsTable)
		npcHandler:say("Of course, just browse through my wares. You can also look at " .. remainingCategories .. ".", npc, player)
		npc:openShopWindowTable(player, categoryTable)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(
	MESSAGE_GREET,
	"Hello, dear |PLAYERNAME|. How can I help you? \z
	If you need magical equipment such as {runes} or {wands}, just ask me for a {trade}."
)
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares. Or do you want to look only at " .. GetFormattedShopCategoryNames(itemsTable) .. ".")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|. Do come again!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye, |PLAYERNAME|. Do come again!")
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "animate dead rune" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, but runes of this type can't be purchased here." })
keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "I'm just wonderful - thank you for asking." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "If you want to find out about excalibug you should ask the more sinister characters in Thais, not a respectable woman like myself!" })
keywordHandler:addKeyword({ "rebellion" }, StdModule.say, { npcHandler = npcHandler, text = "There is talk of a rebellion in Venore to gain independence from the Oppressor... I mean, King - of Thais. It can only help business." })
keywordHandler:addKeyword({ "benjamin" }, StdModule.say, { npcHandler = npcHandler, text = "Bless him, he stood, he fought, and then left his sanity on the battlefield." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "I heard that he left the city because he couldn't bear the shame of being rejected as courtmage. But that's just a gossip." })
keywordHandler:addKeyword({ "dungeon" }, StdModule.say, { npcHandler = npcHandler, text = "Dungeons - dank cold places if you ask me. They lead to rusty armor, severe colds and death ... on the other hand you use a lot of runes there ... so just think about the treasures you'll surely find there." })
keywordHandler:addKeyword({ "monster" }, StdModule.say, { npcHandler = npcHandler, text = "Better buy and charge a lot of runes before facing any monster." })
keywordHandler:addKeyword({ "quentin" }, StdModule.say, { npcHandler = npcHandler, text = "I can't tell much about that old monk." })
keywordHandler:addKeyword({ "chester" }, StdModule.say, { npcHandler = npcHandler, text = "I've never seen him at all. I only heard he's kind of the townsguards' chief or some such." })
keywordHandler:addKeyword({ "venore" }, StdModule.say, { npcHandler = npcHandler, text = "A marvellous city! Modern! Prosperous! Thais could learn a thing or two from Venore." })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "I went there on holiday once. Just goes to show that women are much better at running a place than men. King Tibianus could learn a thing or two from Queen Eloise." })
keywordHandler:addKeyword({ "spells" }, StdModule.say, { npcHandler = npcHandler, text = "You never know when you run out of mana. All the more reason to buy some good runes or potions." })
keywordHandler:addKeyword({ "partos" }, StdModule.say, { npcHandler = npcHandler, text = "I heard he was a thief. Good thing he was caught." })
keywordHandler:addKeyword({ "gossip" }, StdModule.say, { npcHandler = npcHandler, text = "I'm all ears." })
keywordHandler:addKeyword({ "rumour" }, StdModule.say, { npcHandler = npcHandler, text = "I'm all ears." })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, Knights ... can't expect much from those guys." })
keywordHandler:addKeyword({ "marvik" }, StdModule.say, { npcHandler = npcHandler, text = "Who knows what the old man is up to in his hideout when no one is watching?" })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "You should ask this guy Oswald about him ... or other pointless rumors." })
keywordHandler:addKeyword({ "sewer" }, StdModule.say, { npcHandler = npcHandler, text = "The Thais sewerage system is a model of modern rat breeding and for some reason is very popular with young adventurers such as yourself." })
keywordHandler:addKeyword({ "gamon" }, StdModule.say, { npcHandler = npcHandler, text = "I think he is a spy ... so I smile at him the whole day. He won't get anything out of me!" })
keywordHandler:addKeyword({ "magic" }, StdModule.say, { npcHandler = npcHandler, text = "Magic will only protect you - a rune and some magic potions." })
keywordHandler:addKeyword({ "power" }, StdModule.say, { npcHandler = npcHandler, text = "There is a power struggle between Venore and Thais." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "Some call her the preying mantis - apparently she has killed over a dozen husbands already." })
keywordHandler:addKeyword({ "fluid" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, we removed the old life and mana fluids from our assortment. However, we offer health, spirit and mana potions in up to four sizes, just ask me for a trade." })
keywordHandler:addKeyword({ "gamel" }, StdModule.say, { npcHandler = npcHandler, text = "He hung around with that Partos a lot. I wouldn't be surprised if he's a thief too. He is not allowed to enter our markethall." })
keywordHandler:addKeyword({ "lugri" }, StdModule.say, { npcHandler = npcHandler, text = "I only heard rumours about him - isn't he a hermit somewhere in the north?" })
keywordHandler:addKeyword({ "boss" }, StdModule.say, { npcHandler = npcHandler, text = "I had one once. He should have bought better armor. Actually - he's upstairs." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "<mutters> Here we go again ... Hail to King Tibianus! ... Don't make me do that again!" })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Time waits for no one! Not even you, sweetheart, so please do hurry up." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Topsy." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "He wanted to be the court jester but got upset when people laughed at him." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "Ah yes ... Gorn ... the used-cart salesman of scrolls." })
keywordHandler:addKeyword({ "god" }, StdModule.say, { npcHandler = npcHandler, text = "Gods - if we didn't have them, we would have invented them." })
keywordHandler:addKeyword({ "new" }, StdModule.say, { npcHandler = npcHandler, text = "I'm all ears." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, such a sweetie. A simple man, with simple tastes and a simple mind." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I sell runes as well as spirit, health and mana potions - your best friends in any dungeon!" })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

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
