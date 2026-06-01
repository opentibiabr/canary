local internalNpcName = "Gregor"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 38,
	lookBody = 38,
	lookLegs = 38,
	lookFeet = 38,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Gather around me, young knights! I'm going to teach you some spells!" },
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if player:getStorageValue(Storage.Quest.U7_6.TheApeCity.Questline) <= 15 then
		npcHandler:say("Sorry but I don't have anything for you at the moment.", npc, creature)
		return true
	end

	local addonProgress = player:getStorageValue(Storage.Quest.U7_8.KnightOutfits.AddonHelmet)
	if MsgContains(message, "task") then
		if not player:isPremium() then
			npcHandler:say("Sorry, but our tasks are only for premium warriors.", npc, creature)
			return true
		end

		if addonProgress < 1 then
			npcHandler:say("You mean you would like to prove that you deserve to wear such a helmet?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif addonProgress == 1 then
			npcHandler:say("Your current task is to bring me 100 perfect behemoth fangs, |PLAYERNAME|.", npc, creature)
		elseif addonProgress == 2 then
			npcHandler:say("Your current task is to retrieve the helmet of Ramsay the Reckless from Banuta, |PLAYERNAME|.", npc, creature)
		elseif addonProgress == 3 then
			npcHandler:say("Your current task is to obtain a flask of warrior's sweat, |PLAYERNAME|.", npc, creature)
		elseif addonProgress == 4 then
			npcHandler:say("Your current task is to bring me royal steel, |PLAYERNAME|.", npc, creature)
		elseif addonProgress == 5 then
			npcHandler:say("Please talk to Sam and tell him I sent you. I'm sure he will be glad to refine your helmet, |PLAYERNAME|.", npc, creature)
		else
			npcHandler:say("You've already completed the task and can consider yourself a mighty warrior, |PLAYERNAME|.", npc, creature)
		end
	elseif MsgContains(message, "behemoth fang") then
		if addonProgress == 1 then
			npcHandler:say("Have you really managed to fulfil the task and brought me 100 perfect behemoth fangs?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		else
			npcHandler:say("You're not serious asking that, are you? They come from behemoths, of course. Unless there are behemoth rabbits. Duh.", npc, creature)
		end
	elseif MsgContains(message, "ramsay the reckless helmet") then
		if addonProgress == 2 then
			npcHandler:say("Did you recover the helmet of Ramsay the Reckless?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		else
			npcHandler:say("These pesky apes steal everything they can get their dirty hands on.", npc, creature)
		end
	elseif MsgContains(message, "sweat") then
		if addonProgress == 3 then
			npcHandler:say("Were you able to get hold of a flask with pure warrior's sweat?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		else
			npcHandler:say("Warrior's sweat can be magically extracted from headgear worn by a true warrior, but only in small amounts. Djinns are said to be good at magical extractions.", npc, creature)
		end
	elseif MsgContains(message, "royal steel") then
		if addonProgress == 4 then
			npcHandler:say("Ah, have you brought the royal steel?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		else
			npcHandler:say("Royal steel can only be refined by very skilled smiths.", npc, creature)
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			npcHandler:say({
				"Well then, listen closely. First, you will have to prove that you are a fierce and restless warrior by bringing me 100 perfect behemoth fangs. ...",
				"Secondly, please retrieve a helmet for us which has been lost a long time ago. The famous Ramsay the Reckless wore it when exploring an ape settlement. ...",
				"Third, we need a new flask of warrior's sweat. We've run out of it recently, but we need a small amount for the show battles in our arena. ...",
				"Lastly, I will have our smith refine your helmet if you bring me royal steel, an especially noble metal. ...",
				"Did you understand everything I told you and are willing to handle this task?",
			}, npc, creature, 100)
			npcHandler:setTopic(playerId, 2)
		elseif MsgContains(message, "no") then
			npcHandler:say("Bah. Then you will have to wait for the day these helmets are sold in shops, but that will not happen before hell freezes over.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "yes") then
			player:setStorageValue(Storage.OutfitQuest.Ref, math.max(0, player:getStorageValue(Storage.OutfitQuest.Ref)) + 1)
			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.AddonHelmet, 1)
			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.MissionHelmet, 1)
			npcHandler:say("Alright then. Come back to me once you have collected 100 perfect behemoth fangs.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 3 then
		if MsgContains(message, "yes") then
			if not player:removeItem(5893, 100) then
				npcHandler:say("Lying is not exactly honourable, |PLAYERNAME|. Shame on you.", npc, creature)
				return true
			end

			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.AddonHelmet, 2)
			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.MissionHelmet, 2)
			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.RamsaysHelmetDoor, 1)
			npcHandler:say("I'm deeply impressed, brave Knight |PLAYERNAME|. I expected nothing less from you. Now, please retrieve Ramsay's helmet.", npc, creature)
		elseif MsgContains(message, "no") then
			npcHandler:say("There is no need to rush anyway.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif npcHandler:getTopic(playerId) == 4 then
		if MsgContains(message, "yes") then
			if not player:removeItem(5924, 1) then
				npcHandler:say("Lying is not exactly honourable, |PLAYERNAME|. Shame on you.", npc, creature)
				return true
			end

			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.AddonHelmet, 3)
			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.MissionHelmet, 3)
			npcHandler:say("Good work, brave Knight |PLAYERNAME|! Even though it is damaged, it has a lot of sentimental value. Now, please bring me warrior's sweat.", npc, creature)
		elseif MsgContains(message, "no") then
			npcHandler:say("There is no need to rush anyway.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif npcHandler:getTopic(playerId) == 5 then
		if MsgContains(message, "yes") then
			if not player:removeItem(5885, 1) then
				npcHandler:say("Lying is not exactly honourable, |PLAYERNAME|. Shame on you.", npc, creature)
				return true
			end

			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.AddonHelmet, 4)
			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.MissionHelmet, 4)
			npcHandler:say("Now that is a pleasant surprise, brave Knight |PLAYERNAME|! There is only one task left now: Obtain royal steel to have your helmet refined.", npc, creature)
		elseif MsgContains(message, "no") then
			npcHandler:say("There is no need to rush anyway.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif npcHandler:getTopic(playerId) == 6 then
		if MsgContains(message, "yes") then
			if not player:removeItem(5887, 1) then
				npcHandler:say("Lying is not exactly honourable, |PLAYERNAME|. Shame on you.", npc, creature)
				return true
			end

			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.AddonHelmet, 5)
			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.MissionHelmet, 5)
			npcHandler:say("You truly deserve to wear an adorned helmet, brave Knight |PLAYERNAME|. Please talk to Sam and tell him I sent you. I'm sure he will be glad to refine your helmet.", npc, creature)
		elseif MsgContains(message, "no") then
			npcHandler:say("There is no need to rush anyway.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

local node1 = keywordHandler:addKeyword({ "lesser front sweep" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {lesser front sweep} magic spell for free?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "lesser front sweep", vocation = { 4, 8 }, price = 0, level = 1 })

local node2 = keywordHandler:addKeyword({ "great light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great light} magic spell for 500 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 13 })

local node3 = keywordHandler:addKeyword({ "bruise bane" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {bruise bane} magic spell for free?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "bruise bane", vocation = { 4, 8 }, price = 0, level = 1 })

local node4 = keywordHandler:addKeyword({ "wound cleansing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {wound cleansing} magic spell for free?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "wound cleansing", vocation = { 4, 8 }, price = 0, level = 8 })

local node5 = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure poison} magic spell for 150 gold?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 150, level = 10 })

local node6 = keywordHandler:addKeyword({ "find fiend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find fiend} magic spell for 1000 gold?" })
node6:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find fiend", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 1000, level = 25 })

local node7 = keywordHandler:addKeyword({ "find person" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find person} magic spell for 80 gold?" })
node7:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find person", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 80, level = 8 })

local node8 = keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light} magic spell for free?" })
node8:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 0, level = 8 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {healing} spells and {support} spells. What kind of spell do you wish to learn? I can also tell you which spells are available at your {level}.",
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My healing spells are: {Bruise Bane}, {Cure Poison} and {Wound Cleansing}.",
})

keywordHandler:addKeyword({ "support" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My support spells are: {Find Fiend}, {Find Person}, {Great Light}, {Lesser Front Sweep} and {Light}.",
})

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "I have spells for level {1}, {8}, {10}, {13} and {25}.",
})

nodeLevels:addChildKeyword({ "25" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 25 I have {Find Fiend} for 1000 gold." })
nodeLevels:addChildKeyword({ "13" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 13 I have {Great Light} for 500 gold." })
nodeLevels:addChildKeyword({ "10" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 10 I have {Cure Poison} for 150 gold." })
nodeLevels:addChildKeyword({ "8" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 8 I have {Find Person} for 80 gold, {Light} for free and {Wound Cleansing} for free." })
nodeLevels:addChildKeyword({ "1" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 1 I have {Bruise Bane} for free and {Lesser Front Sweep} for free." })

keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the first knight. I trained some of the greatest heroes of Tibia." })
keywordHandler:addKeyword({ "heroes" }, StdModule.say, { npcHandler = npcHandler, text = "Of course, you heard of them. Knights are the best fighters in Tibia." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "Hail to our King!" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "You are joking, eh? Of course, you know me. I am Gregor, the first knight." })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "A great name, isn't it?" })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "Beautiful Tibia. And with our help everyone is save." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "It is time to join the Knights!" })
keywordHandler:addKeyword({ "knights" }, StdModule.say, { npcHandler = npcHandler, text = "Knights are the warriors of Tibia. Without us, no one would be safe. Every brave and strong man or woman can join us." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "Some day someone will make something happen to him..." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "A bow might be a fine weapon for someone not strong enough to wield a REAL weapon." })
keywordHandler:addKeyword({ "frodo" }, StdModule.say, { npcHandler = npcHandler, text = "I and my students often share a cask of beer or wine at Frodo's hut." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "Always concerned with his profit. What a loss! He was adventuring with baxter in the old days." })
keywordHandler:addKeyword({ "baxter" }, StdModule.say, { npcHandler = npcHandler, text = "He was an adventurer once." })
keywordHandler:addKeyword({ "lynda" }, StdModule.say, { npcHandler = npcHandler, text = "Before she became a priest she won the Miss Tibia contest three times in a row." })
keywordHandler:addKeyword({ "mcronald" }, StdModule.say, { npcHandler = npcHandler, text = "Peaceful farmers." })
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "A fine game to hunt. But be careful, he cheats!" })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "Bah, go away with these sorcerer tricks. Only cowards use tricks." })
keywordHandler:addKeyword({ "oswald" }, StdModule.say, { npcHandler = npcHandler, text = "What an idiot." })
keywordHandler:addKeyword({ "quentin" }, StdModule.say, { npcHandler = npcHandler, text = "I will never understand this peaceful monks and priests." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "He has the muscles, but lacks the guts." })
keywordHandler:addKeyword({ "tibianus" }, StdModule.say, { npcHandler = npcHandler, text = "Hail to our King!" })
keywordHandler:addKeyword({ "outfit" }, StdModule.say, { npcHandler = npcHandler, text = "Only the bravest warriors may wear adorned helmets. They are traditionally awarded after having completed a difficult task for our guild." })

npcHandler:setMessage(MESSAGE_GREET, "Greetings, |PLAYERNAME|. What do you want?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Be careful on your journeys.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Be careful on your journeys.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
