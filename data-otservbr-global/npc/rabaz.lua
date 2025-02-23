local internalNpcName = "Rabaz"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 39,
	lookBody = 38,
	lookLegs = 1,
	lookFeet = 1,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
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
		{ itemName = "supreme health potion", clientId = 23375, buy = 650 },
		{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
		{ itemName = "ultimate mana potion", clientId = 23373, buy = 488 },
		{ itemName = "ultimate spirit potion", clientId = 23374, buy = 488 },
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
		{ itemName = "hailstorm rod", clientId = 3067, buy = 15000 },
		{ itemName = "moonlight rod", clientId = 3070, buy = 1000 },
		{ itemName = "necrotic rod", clientId = 3069, buy = 5000 },
		{ itemName = "northwind rod", clientId = 8083, buy = 7500 },
		{ itemName = "snakebite rod", clientId = 3066, buy = 500 },
		{ itemName = "springsprout rod", clientId = 8084, buy = 18000 },
		{ itemName = "terra rod", clientId = 3065, buy = 10000 },
		{ itemName = "underworld rod", clientId = 8082, buy = 22000 },
		{ itemName = "wand of cosmic energy", clientId = 3073, buy = 10000 },
		{ itemName = "wand of decay", clientId = 3072, buy = 5000 },
		{ itemName = "wand of draconia", clientId = 8093, buy = 7500 },
		{ itemName = "wand of dragonbreath", clientId = 3075, buy = 1000 },
		{ itemName = "wand of inferno", clientId = 3071, buy = 15000 },
		{ itemName = "wand of starstorm", clientId = 8092, buy = 18000 },
		{ itemName = "wand of voodoo", clientId = 8094, buy = 22000 },
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local categoryTable = itemsTable[message:lower()]
	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.Quest.U8_6.AnInterestInBotany.Questline) < 1 then
			npcHandler:setTopic(playerId, 1)
			npcHandler:say({
				"Why yes, there is indeed some minor issue I could need your help with. I was always a friend of nature and it was not recently I discovered the joys of plants, growths, of all the flora around us. ...",
				"Botany my friend. The study of plants is of great importance for our future. Many of the potions we often depend on are made of plants you know. Plants can help us tending our wounds, cure us from illness or injury. ...",
				"I am currently writing an excessive compilation of all the knowledge I have gathered during my time here in Farmine and soon hope to publish it as 'Rabaz' Unabridged Almanach Of Botany'. ...",
				"However, to actually complete my botanical epitome concerning Zao, I would need someone to enter these dangerous lands. Someone able to get closer to the specimens than I can. ...",
				"And this is where you come in. There are two extremely rare species I need samples from. Typically not easy to come by but it should not be necessary to venture too far into Zao to find them. ...",
				"Explore the anterior outskirts of Zao, use my almanach and find the two specimens with missing samples on their pages. The almanach can be found in a chest in my storage, next to my shop. It's the door over there. ...",
				"If you lose it I will have to write a new one and put it in there again - which will undoubtedly take me a while. So keep an eye on it on your travels. ...",
				"Once you find what I need, best use a knife to carefully cut and gather a leaf or a scrap of their integument and press it directly under their appropriate entry into my botanical almanach. ...",
				"Simply return to me after you have done that and we will discuss your reward. What do you say, are you in?",
			}, npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_6.AnInterestInBotany.Questline) == 3 then
			npcHandler:setTopic(playerId, 2)
			npcHandler:say("Well fantastic work, you gathered both samples! Now I can continue my work on the almanach, thank you very much for your help indeed. Can I take a look at my book please?", npc, creature)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.DefaultStart, 1)
			player:setStorageValue(Storage.Quest.U8_6.AnInterestInBotany.Questline, 1)
			player:setStorageValue(Storage.Quest.U8_6.AnInterestInBotany.ChestDoor, 0)
			npcHandler:say("Yes? Yes! That's the enthusiasm I need! Remember to bring a sharp knife to gather the samples, plants - even mutated deformed plants - are very sensitive you know. Off you go and be careful out there, Zao is no place for the feint hearted mind you.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:removeItem(11699, 1) then
				player:addItem(11700, 1)
				player:addItem(3035, 10)
				player:addExperience(3000, true)
				player:setStorageValue(Storage.Quest.U8_6.AnInterestInBotany.Questline, 4)
				npcHandler:say({
					"Ah, thank you. Now look at that texture and fine colour, simply marvellous. ...",
					"I hope the sun in the steppe did not exhaust you too much? Shellshock. A dangerous foe in the world of field science and exploration. ...",
					"Here, I always wore this comfortable hat when travelling, take it. It may be of use for you on further reconnaissances in Zao. Again you have my thanks, friend.",
				}, npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Oh, you don't have my book.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif categoryTable then
		local remainingCategories = npc:getRemainingShopCategories(message:lower(), itemsTable)
		npcHandler:say("Of course, just browse through my wares. You can also look at " .. remainingCategories .. ".", npc, player)
		npc:openShopWindowTable(player, categoryTable)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Ah, a customer! Please feel free to browse my wares, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Have a look. But perhaps you just want to see my " .. GetFormattedShopCategoryNames(itemsTable) .. ".")
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
