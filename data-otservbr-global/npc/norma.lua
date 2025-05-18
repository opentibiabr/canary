local internalNpcName = "Norma"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 136,
	lookHead = 78,
	lookBody = 76,
	lookLegs = 72,
	lookFeet = 96,
	lookAddons = 2,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Great drinks and snacks at fair prices!" },
	{ text = "You know you want a party after all that tiring hunting!" },
	{ text = "<sings> ... are a girl's best friieeend..." },
	{ text = "Sing and dance at my bar! Yeah!" },
	{ text = "Best place in town! Come to my bar!" },
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

--[[
addon
Pretty, isn't it? I made it myself, but I could teach you how to do that if you like. What do you say?
hat
13:44 Norma: Pretty, isn't it? I made it myself, but I could teach you how to do that if you like. What do you say?
yes
13:44 Norma: Okay, here we go, listen closely! I need a few things... a basic hat of course, maybe a legion helmet would do. Then about 100 chicken feathers... and 50 honeycombs as glue. That's it, come back to me once you gathered it!!
]]

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "addon") or MsgContains(message, "outfit") or MsgContains(message, "hat") then
		if player:getStorageValue(Storage.Quest.U7_8.CitizenOutfitsRook.AddonHatRook) == 1 then
			npcHandler:say("Oh, you're back already? Did you bring a legion helmet, 100 chicken feathers and 50 honeycombs?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.Quest.U7_8.CitizenOutfitsRook.MissionHatRookRook) < 1 then
			npcHandler:say("Pretty, isn't it? I made it myself, but I could teach you how to do that if you like. What do you say?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end

		return true
	end

	if npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			player:setStorageValue(Storage.Quest.U7_8.CitizenOutfitsRook.AddonHatRook, 1)
			player:setStorageValue(Storage.Quest.U7_8.CitizenOutfitsRook.MissionHatRook, 1)
			npcHandler:say("Okay, here we go, listen closely! I need a few things... a basic hat of course, maybe a legion helmet would do. Then about 100 chicken feathers... and 50 honeycombs as glue.That's it, come back to me once you gathered it!!", npc, creature)
		else
			npcHandler:say("Aw, I guess you don't like feather hats. No big deal.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "yes") then
			if player:getItemCount(3374) < 1 then
				npcHandler:say("Sorry, but I can't see a legion helmet.", npc, creature)
			elseif player:getItemCount(5890) < 100 then
				npcHandler:say("Sorry, but you don't enough chicken feathers.", npc, creature)
			elseif player:getItemCount(5902) < 50 then
				npcHandler:say("Sorry, but you don't have enough honeycombs.", npc, creature)
			else
				npcHandler:say("Great job! That must have taken a lot of work. Okay, you put it like this... then glue like this... here!", npc, creature)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:removeItem(3374, 1)
				player:removeItem(5902, 50)
				player:removeItem(5890, 100)
				player:addOutfitAddon(136, 2)
				player:addOutfitAddon(128, 2)
				player:setStorageValue(Storage.Quest.U7_8.CitizenOutfitsRook.MissionHatRook, 0)
				player:setStorageValue(Storage.Quest.U7_8.CitizenOutfitsRook.AddonHatRook, 2)
			end
		else
			npcHandler:say("Maybe another time.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

-- Basic keywords
keywordHandler:addKeyword({ "hint" }, StdModule.rookgaardHints, { npcHandler = npcHandler })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Well, my name is {Norma}." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I used to be a merchant, but being a barkeeper is so much more fun. It's been my dream since I was a little girl." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "It's about |TIME|. Time just flies, doesn't it?" })
keywordHandler:addKeyword({ "merchant" }, StdModule.say, { npcHandler = npcHandler, text = "To view the offers of a merchant, simply talk to him or her and ask for a {trade}. They will gladly show you their offers and also the things they buy from you." })
keywordHandler:addKeyword({ "how", "are", "you" }, StdModule.say, { npcHandler = npcHandler, text = "I've never been better! I love my new {job}!" })
keywordHandler:addKeyword({ "weapon" }, StdModule.say, { npcHandler = npcHandler, text = "No sorry, I'm out of that business. Please ask {Obi} or {Lee'Delle} if you need a weapon." })
keywordHandler:addKeyword({ "equipment" }, StdModule.say, { npcHandler = npcHandler, text = "As an adventurer, you should always have at least a {backpack}, a {rope}, a {shovel}, a {weapon}, an {armor} and a {shield}." })
keywordHandler:addKeyword({ "monster" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, the monsters are far away. Let's party now!" })
keywordHandler:addKeyword({ "dungeon" }, StdModule.say, { npcHandler = npcHandler, text = "If you really want to talk about dungeons, visit Dallheim on the bridge near my bar." })
keywordHandler:addKeyword({ "sewer" }, StdModule.say, { npcHandler = npcHandler, text = "Ewww, I don't even want to think about the smell from the sewers right now!" })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "Oooh, I wouldn't dare gossiping about the king. He might have his spies here somewhere, you know." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "This is the world we live in, oh-oh-oh, and these are the hands we're given, oh-oh... oh, I'm sorry, I got carried away!" })
keywordHandler:addKeyword({ "premium" }, StdModule.say, { npcHandler = npcHandler, text = "As a premium adventurer you have many advantages, you should check them out!" })
keywordHandler:addKeyword({ "drink" }, StdModule.say, { npcHandler = npcHandler, text = "I serve the best drinks in town! What's it gonna be, lemonade? Wine? Milk? Beer? Just ask me for a {trade}!" })
keywordHandler:addKeyword({ "temple" }, StdModule.say, { npcHandler = npcHandler, text = "The temple is a good place to visit if you're in urgent need for healing." })

keywordHandler:addKeyword({ "help" }, StdModule.say, { npcHandler = npcHandler, text = "Well, the only help I could give you are some general {hints}. And a delicious {drink} along with it." })
keywordHandler:addAliasKeyword({ "information" })

keywordHandler:addKeyword({ "backpack" }, StdModule.say, { npcHandler = npcHandler, text = "No sorry, I'm out of that business. Please ask {Al Dee} or {Lee'Delle} if you need equipment." })
keywordHandler:addAliasKeyword({ "rope" })
keywordHandler:addAliasKeyword({ "shovel" })
keywordHandler:addAliasKeyword({ "fishing" })

keywordHandler:addKeyword({ "armor" }, StdModule.say, { npcHandler = npcHandler, text = "No sorry, I'm out of that business. Please ask {Dixi} or {Lee'Delle} if you need equipment." })
keywordHandler:addAliasKeyword({ "shield" })

keywordHandler:addKeyword({ "offer" }, StdModule.say, { npcHandler = npcHandler, text = "Oh, would you like something to eat or drink? Ask me for a {trade} to see my offers!" })
keywordHandler:addAliasKeyword({ "sell" })
keywordHandler:addAliasKeyword({ "buy" })
keywordHandler:addAliasKeyword({ "wares" })
keywordHandler:addAliasKeyword({ "stuff" })

-- Names
keywordHandler:addKeyword({ "mary" }, StdModule.say, { npcHandler = npcHandler, text = "<gets a dreamy look in her eyes>" })
keywordHandler:addKeyword({ "al", "dee" }, StdModule.say, { npcHandler = npcHandler, text = "Al Dee treats his customers friendly, but he's badmouthing them once he had a few beers." })
keywordHandler:addKeyword({ "amber" }, StdModule.say, { npcHandler = npcHandler, text = "I'm curious about her adventures. She really should come here more often!" })
keywordHandler:addKeyword({ "billy" }, StdModule.say, { npcHandler = npcHandler, text = "He got lucky when Willie and him played a game of dice about who gets to farm on which side of the river. Ever since, Willie holds a grudge against him." })
keywordHandler:addKeyword({ "willie" }, StdModule.say, { npcHandler = npcHandler, text = "Hehe, that guy doesn't pretend to be anyone that he isn't. He is what he is - rude, but honest." })
keywordHandler:addKeyword({ "tom" }, StdModule.say, { npcHandler = npcHandler, text = "Oh shush! It's kinda disgusting when he walks in here with animal blood on his hands!" })
keywordHandler:addKeyword({ "seymour" }, StdModule.say, { npcHandler = npcHandler, text = "What Seymour doesn't teach you is how much fun you can have here!" })
keywordHandler:addKeyword({ "zirella" }, StdModule.say, { npcHandler = npcHandler, text = "I invited her to my bar, but she refused. Oh well, it was worth a try!" })
keywordHandler:addKeyword({ "santiago" }, StdModule.say, { npcHandler = npcHandler, text = "I think that poor guy never gets a break from work. At least he never comes here." })
keywordHandler:addKeyword({ "paulie" }, StdModule.say, { npcHandler = npcHandler, text = "That guy seriously needs some partying and a girlfriend." })
keywordHandler:addKeyword({ "oracle" }, StdModule.say, { npcHandler = npcHandler, text = "The oracle is on the top floor of the academy. You should go there once you are level 8 to leave this island." })
keywordHandler:addKeyword({ "obi" }, StdModule.say, { npcHandler = npcHandler, text = "I think it's rather strange that he lives here with his granddaughter. No one's ever seen the parents of {Dixi}." })
keywordHandler:addKeyword({ "norma" }, StdModule.say, { npcHandler = npcHandler, text = "I hate that name, it sounds so boring. Almost like 'normal'. I think I should change my name to something more exciting. Like... Marylin! Oh, what a glamorous sound!" })
keywordHandler:addKeyword({ "dixi" }, StdModule.say, { npcHandler = npcHandler, text = "She told me that she dreams of leaving this island to go on a big adventure." })
keywordHandler:addKeyword({ "loui" }, StdModule.say, { npcHandler = npcHandler, text = "They tell me strange stories about him and some monsters in a hole. Weird!" })
keywordHandler:addKeyword({ "lee'delle" }, StdModule.say, { npcHandler = npcHandler, text = "That girl thinks that she is soooo special and 'high society'. We used to be friends, but well, things change." })
keywordHandler:addKeyword({ "hyacinth" }, StdModule.say, { npcHandler = npcHandler, text = "That's probably someone I'll never see in my bar." })
keywordHandler:addKeyword({ "cipfried" }, StdModule.say, { npcHandler = npcHandler, text = "<giggles> That monk with his holier-than-thou attitude hasn't anything against a good mug of wine now and then." })
keywordHandler:addKeyword({ "dallheim" }, StdModule.say, { npcHandler = npcHandler, text = "If you listen to him, you could get the impression my little bar is the devil himself. He says he has more work now keeping drunken adventurers in than monsters out of the city. Such an exaggeration!" })
keywordHandler:addAliasKeyword({ "zerbrus" })

npcHandler:setMessage(MESSAGE_WALKAWAY, "Hey, where are you going? We've just started!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Come back soon!")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Take all the time you need to decide what you want!")
npcHandler:setMessage(MESSAGE_GREET, "Welcome, welcome! Have a seat! If you like a drink or something to eat, just ask me for a {trade}!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, buy = 3 },
	{ itemName = "cheese", clientId = 3607, buy = 5 },
	{ itemName = "egg", clientId = 3606, buy = 2 },
	{ itemName = "mug of beer", clientId = 2880, buy = 3, count = 3 },
	{ itemName = "mug of lemonade", clientId = 2880, buy = 2, count = 12 },
	{ itemName = "mug of milk", clientId = 2880, buy = 2, count = 6 },
	{ itemName = "mug of wine", clientId = 2880, buy = 3, count = 2 },
	{ itemName = "party cake", clientId = 6279, buy = 50 },
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
