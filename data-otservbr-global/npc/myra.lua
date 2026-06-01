local internalNpcName = "Myra"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 138,
	lookHead = 58,
	lookBody = 19,
	lookLegs = 0,
	lookFeet = 132,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
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

	if MsgContains(message, "outfit") then
		npcHandler:say("This Tiara is an award by the academy of Edron in recognition of my service here.", npc, creature)
		npcHandler:setTopic(playerId, 100)
	elseif MsgContains(message, "tiara") and player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) < 1 then
		if npcHandler:getTopic(playerId) ~= 100 then
			npcHandler:say("Please ask about the 'outfit' first.", npc, creature)
		else
			local storageValue = player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak)
			if storageValue == -1 then
				npcHandler:say("Well... maybe, if you help me a little, I could convince the academy of Edron that you are a valuable help here and deserve an award too. How about it?", npc, creature)
				npcHandler:setTopic(playerId, 1)
			elseif storageValue > 0 and storageValue < 10 then
				npcHandler:say("Before I can nominate you for an award, please complete your task.", npc, creature)
			elseif storageValue == 10 then
				npcHandler:say("Go to the academy in Edron and tell Zoltan that I sent you, |PLAYERNAME|.", npc, creature)
			elseif storageValue == 11 then
				npcHandler:say("I don't have any tasks for you right now, |PLAYERNAME|. You were of great help.", npc, creature)
			end
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			npcHandler:say({
				"Okay, great! You see, I need a few magical ingredients which I've run out of. First of all, please bring me 70 bat wings. ...",
				"Then, I urgently need a lot of red cloth. I think 20 pieces should suffice. ...",
				"Oh, and also, I could use a whole load of ape fur. Please bring me 40 pieces. ...",
				"After that, um, let me think... I'd like to have some holy orchids. Or no, many holy orchids, to be safe. Like 35. ...",
				"Then, 10 spools of spider silk yarn, 60 lizard scales and 40 red dragon scales. ...",
				"I know I'm forgetting something.. wait... ah yes, 15 ounces of magic sulphur and 30 ounces of vampire dust. ...",
				"That's it already! Easy task, isn't it? I'm sure you could get all of that within a short time. ...",
				"Did you understand everything I told you and are willing to handle this task?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif MsgContains(message, "no") then
			npcHandler:say("That's a pity.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "yes") then
			npcHandler:say("Fine! Let's start with the 70 bat wings. I really feel uncomfortable out there in the jungle.", npc, creature)
			player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak, 1)
			player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.MissionHatCloak, 1)
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "task") then
		local tasks = {
			[1] = "Your current task is to bring me 70 bat wings, |PLAYERNAME|.",
			[2] = "Your current task is to bring me 20 pieces of red cloth, |PLAYERNAME|.",
			[3] = "Your current task is to bring me 40 pieces of ape fur, |PLAYERNAME|.",
			[4] = "Your current task is to bring me 35 holy orchids, |PLAYERNAME|.",
			[5] = "Your current task is to bring me 10 spools of spider silk yarn, |PLAYERNAME|.",
			[6] = "Your current task is to bring me 60 lizard scales, |PLAYERNAME|.",
			[7] = "Your current task is to bring me 40 red dragon scales, |PLAYERNAME|.",
			[8] = "Your current task is to bring me 15 ounces of magic sulphur, |PLAYERNAME|.",
			[9] = "Your current task is to bring me 30 ounces of vampire dust, |PLAYERNAME|.",
			[10] = "Go to the academy in Edron and tell Zoltan that I sent you, |PLAYERNAME|.",
			[11] = "I don't have any tasks for you right now, |PLAYERNAME|. You were of great help.",
		}
		local taskMessage = tasks[player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak)]
		if taskMessage then
			npcHandler:say(taskMessage, npc, creature)
		end
	elseif MsgContains(message, "bat wing") then
		if player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 1 then
			npcHandler:say("Oh, did you bring the 70 bat wings for me?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "red cloth") then
		if player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 2 then
			npcHandler:say("Have you found 20 pieces of red cloth?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "ape fur") then
		if player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 3 then
			npcHandler:say("Were you able to retrieve 40 pieces of ape fur?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "holy orchid") then
		if player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 4 then
			npcHandler:say("Did you convince the elves to give you 35 holy orchids?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		end
	elseif MsgContains(message, "spider silk") then
		if player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 5 then
			npcHandler:say("Oh, did you bring 10 spools of spider silk yarn for me?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		end
	elseif MsgContains(message, "lizard scale") then
		if player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 6 then
			npcHandler:say("Have you found 60 lizard scales?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		end
	elseif MsgContains(message, "red dragon scale") then
		if player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 7 then
			npcHandler:say("Were you able to get all 40 red dragon scales?", npc, creature)
			npcHandler:setTopic(playerId, 9)
		end
	elseif MsgContains(message, "magic sulphur") then
		if player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 8 then
			npcHandler:say("Have you collected 15 ounces of magic sulphur?", npc, creature)
			npcHandler:setTopic(playerId, 10)
		end
	elseif MsgContains(message, "vampire dust") then
		if player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 9 then
			npcHandler:say("Have you gathered 30 ounces of vampire dust?", npc, creature)
			npcHandler:setTopic(playerId, 11)
		end
	elseif npcHandler:getTopic(playerId) == 3 then
		if MsgContains(message, "yes") then
			if player:getItemCount(5894) < 70 then
				npcHandler:say("No, no. That's not enough, I fear.", npc, creature)
			else
				npcHandler:say("Thank you! I really needed them for my anti-wrinkle lotion. Now, please bring me 20 pieces of red cloth.", npc, creature)
				player:removeItem(5894, 70)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak, 2)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.MissionHatCloak, 2)
			end
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 4 then
		if MsgContains(message, "yes") then
			if player:getItemCount(5911) < 20 then
				npcHandler:say("No, no. That's not enough, I fear.", npc, creature)
			else
				npcHandler:say("Great! This should be enough for my new dress. Don't forget to bring me 40 pieces of ape fur next!", npc, creature)
				player:removeItem(5911, 20)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak, 3)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.MissionHatCloak, 3)
			end
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 5 then
		if MsgContains(message, "yes") then
			if player:getItemCount(5883) < 40 then
				npcHandler:say("No, no. That's not enough, I fear.", npc, creature)
			else
				npcHandler:say("Nice job, player. You see, I'm testing a new depilation cream. I guess if it works on ape fur it's good quality. Next, please bring me 35 holy orchids.", npc, creature)
				player:removeItem(5883, 40)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak, 4)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.MissionHatCloak, 4)
			end
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 6 then
		if MsgContains(message, "yes") then
			if player:getItemCount(5922) < 35 then
				npcHandler:say("No, no. That's not enough, I fear.", npc, creature)
			else
				npcHandler:say("Thank god! The scent of holy orchids is simply the only possible solution against the horrible stench from the tavern latrine. Now, please bring me 10 rolls of spider silk yarn.", npc, creature)
				player:removeItem(5922, 35)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak, 5)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.MissionHatCloak, 5)
			end
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 7 then
		if MsgContains(message, "yes") then
			if player:getItemCount(5886) < 10 then
				npcHandler:say("No, no. That's not enough, I fear.", npc, creature)
			else
				npcHandler:say("I appreciate it. My pet doggie manages to bite through all sorts of leashes, which is why he is always gone. I'm sure this strong yarn will keep him. Now, go for the 60 lizard scales!", npc, creature)
				player:removeItem(5886, 10)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak, 6)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.MissionHatCloak, 6)
			end
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 8 then
		if MsgContains(message, "yes") then
			if player:getItemCount(5881) < 60 then
				npcHandler:say("No, no. That's not enough, I fear.", npc, creature)
			else
				npcHandler:say("Good job. They will look almost like sequins on my new dress. Please go for the 40 red dragon scales now.", npc, creature)
				player:removeItem(5881, 60)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak, 7)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.MissionHatCloak, 7)
			end
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 9 then
		if MsgContains(message, "yes") then
			if player:getItemCount(5882) < 40 then
				npcHandler:say("No, no. That's not enough, I fear.", npc, creature)
			else
				npcHandler:say("Thanks! They make a pretty decoration, don't you think? Please bring me 15 ounces of magic sulphur now!", npc, creature)
				player:removeItem(5882, 40)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak, 8)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.MissionHatCloak, 8)
			end
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 10 then
		if MsgContains(message, "yes") then
			if player:getItemCount(5904) < 15 then
				npcHandler:say("No, no. That's not enough, I fear.", npc, creature)
			else
				npcHandler:say("Ah, that's enough magic sulphur for my new peeling. You should try it once, your skin gets incredibly smooth. Now, the only thing I need is vampire dust. 30 ounces will suffice.", npc, creature)
				player:removeItem(5904, 15)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak, 9)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.MissionHatCloak, 9)
			end
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 11 then
		if MsgContains(message, "yes") then
			if player:getItemCount(5905) < 30 then
				npcHandler:say("No, no. That's not enough, I fear.", npc, creature)
			else
				npcHandler:say("Ah, great. Now I can finally finish the potion which the academy of Edron asked me to. I guess, now you want your reward, don't you?", npc, creature)
				player:removeItem(5905, 30)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak, 10)
				player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.MissionHatCloak, 10)
			end
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "addon") then
		if player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 10 then
			npcHandler:say("This Tiara is an award by the academy of Edron in recognition of my service here.", npc, creature)
			npcHandler:setTopic(playerId, 12)
		end
	elseif npcHandler:getTopic(playerId) == 12 then
		if MsgContains(message, "tiara") and player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 10 then
			npcHandler:say("Go to the academy in Edron and tell Zoltan that I sent you, |PLAYERNAME|.", npc, creature)
		end
	end

	return true
end

local node1 = keywordHandler:addKeyword({ "summon sorcerer familiar" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {summon sorcerer familiar} magic spell for 50000 gold?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "summon sorcerer familiar", vocation = { 1, 5 }, price = 50000, level = 200 })

local node2 = keywordHandler:addKeyword({ "restoration" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {restoration} magic spell for 500000 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "restoration", vocation = { 1, 2, 5, 6 }, price = 500000, level = 300 })

local node3 = keywordHandler:addKeyword({ "expose weakness" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {expose weakness} magic spell for 400000 gold?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "expose weakness", vocation = { 1, 5 }, price = 400000, level = 275 })

local node4 = keywordHandler:addKeyword({ "sap strength" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {sap strength} magic spell for 200000 gold?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "sap strength", vocation = { 1, 5 }, price = 200000, level = 175 })

local node5 = keywordHandler:addKeyword({ "strong energy strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong energy strike} magic spell for 7500 gold?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "strong energy strike", vocation = { 1, 5 }, price = 7500, level = 80 })

local node6 = keywordHandler:addKeyword({ "strong flame strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong flame strike} magic spell for 6000 gold?" })
node6:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "strong flame strike", vocation = { 1, 5 }, price = 6000, level = 70 })

local node7 = keywordHandler:addKeyword({ "strong haste" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong haste} magic spell for 1300 gold?" })
node7:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "strong haste", vocation = { 1, 2, 5, 6, 9, 10 }, price = 1300, level = 20 })

local node8 = keywordHandler:addKeyword({ "great energy beam" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great energy beam} magic spell for 1800 gold?" })
node8:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great energy beam", vocation = { 1, 5 }, price = 1800, level = 29 })

local node9 = keywordHandler:addKeyword({ "great fire wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great fire wave} magic spell for 25000 gold?" })
node9:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "great fire wave", vocation = { 1, 5 }, price = 25000, level = 38 })

local node10 = keywordHandler:addKeyword({ "great fireball" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Great Fireball} Rune spell for 1200 gold?" })
node10:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great fireball rune", vocation = { 1, 5 }, price = 1200, level = 30 })

local node11 = keywordHandler:addKeyword({ "great light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great light} magic spell for 500 gold?" })
node11:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 13 })

local node12 = keywordHandler:addKeyword({ "ultimate light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ultimate light} magic spell for 1600 gold?" })
node12:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "ultimate light", vocation = { 1, 2, 5, 6 }, price = 1600, level = 26 })

local node13 = keywordHandler:addKeyword({ "ultimate healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ultimate healing} magic spell for 1000 gold?" })
node13:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ultimate healing", vocation = { 1, 2, 5, 6 }, price = 1000, level = 30 })

local node14 = keywordHandler:addKeyword({ "intense healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {intense healing} magic spell for 350 gold?" })
node14:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 350, level = 20 })

local node15 = keywordHandler:addKeyword({ "light magic missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Light Magic Missile} Rune spell for 500 gold?" })
node15:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light magic missile rune", vocation = { 1, 2, 5, 6 }, price = 500, level = 15 })

local node16 = keywordHandler:addKeyword({ "heavy magic missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Heavy Magic Missile} Rune spell for 1500 gold?" })
node16:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "heavy magic missile rune", vocation = { 1, 2, 5, 6 }, price = 1500, level = 25 })

local node17 = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure poison} magic spell for 150 gold?" })
node17:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 150, level = 10 })

local node18 = keywordHandler:addKeyword({ "cancel magic shield" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cancel magic shield} magic spell for 450 gold?" })
node18:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "cancel magic shield", vocation = { 1, 2, 5, 6 }, price = 450, level = 14 })

local node19 = keywordHandler:addKeyword({ "magic wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Magic Wall} Rune spell for 2100 gold?" })
node19:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "magic wall rune", vocation = { 1, 5 }, price = 2100, level = 32 })

local node20 = keywordHandler:addKeyword({ "magic shield" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic shield} magic spell for 450 gold?" })
node20:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "magic shield", vocation = { 1, 2, 5, 6 }, price = 450, level = 14 })

local node21 = keywordHandler:addKeyword({ "magic rope" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic rope} magic spell for 200 gold?" })
node21:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic rope", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 200, level = 9 })

local node22 = keywordHandler:addKeyword({ "magic patch" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic patch} magic spell for free?" })
node22:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic patch", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 1 })

local node23 = keywordHandler:addKeyword({ "summon creature" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {summon creature} magic spell for 2000 gold?" })
node23:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "summon creature", vocation = { 1, 2, 5, 6 }, price = 2000, level = 25 })

local node24 = keywordHandler:addKeyword({ "energy bomb" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Energy Bomb} Rune spell for 2300 gold?" })
node24:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "energy bomb rune", vocation = { 1, 5 }, price = 2300, level = 37 })

local node25 = keywordHandler:addKeyword({ "energy wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Energy Wall} Rune spell for 2500 gold?" })
node25:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy wall rune", vocation = { 1, 2, 5, 6 }, price = 2500, level = 41 })

local node26 = keywordHandler:addKeyword({ "energy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Energy Field} Rune spell for 700 gold?" })
node26:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy field rune", vocation = { 1, 2, 5, 6 }, price = 700, level = 18 })

local node27 = keywordHandler:addKeyword({ "energy wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {energy wave} magic spell for 2500 gold?" })
node27:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy wave", vocation = { 1, 5 }, price = 2500, level = 38 })

local node28 = keywordHandler:addKeyword({ "energy beam" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {energy beam} magic spell for 1000 gold?" })
node28:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy beam", vocation = { 1, 5 }, price = 1000, level = 23 })

local node29 = keywordHandler:addKeyword({ "energy strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {energy strike} magic spell for 800 gold?" })
node29:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy strike", vocation = { 1, 2, 5, 6 }, price = 800, level = 12 })

local node30 = keywordHandler:addKeyword({ "fire bomb" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Bomb} Rune spell for 1500 gold?" })
node30:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire bomb rune", vocation = { 1, 2, 5, 6 }, price = 1500, level = 27 })

local node31 = keywordHandler:addKeyword({ "fire wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Wall} Rune spell for 2000 gold?" })
node31:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire wall rune", vocation = { 1, 2, 5, 6 }, price = 2000, level = 33 })

local node32 = keywordHandler:addKeyword({ "fire field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Field} Rune spell for 500 gold?" })
node32:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire field rune", vocation = { 1, 2, 5, 6 }, price = 500, level = 15 })

local node33 = keywordHandler:addKeyword({ "fire wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {fire wave} magic spell for 850 gold?" })
node33:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire wave", vocation = { 1, 5 }, price = 850, level = 18 })

local node34 = keywordHandler:addKeyword({ "fireball" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fireball} Rune spell for 1600 gold?" })
node34:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "fireball rune", vocation = { 1, 5 }, price = 1600, level = 27 })

local node35 = keywordHandler:addKeyword({ "flame strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {flame strike} magic spell for 800 gold?" })
node35:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "flame strike", vocation = { 1, 2, 5, 6 }, price = 800, level = 8 })

local node36 = keywordHandler:addKeyword({ "poison wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Poison Wall} Rune spell for 1600 gold?" })
node36:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "poison wall rune", vocation = { 1, 2, 5, 6 }, price = 1600, level = 29 })

local node37 = keywordHandler:addKeyword({ "poison field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Poison Field} Rune spell for 300 gold?" })
node37:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "poison field rune", vocation = { 1, 2, 5, 6 }, price = 300, level = 14 })

local node38 = keywordHandler:addKeyword({ "soulfire" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Soulfire} Rune spell for 1800 gold?" })
node38:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "soulfire rune", vocation = { 1, 2, 5, 6 }, price = 1800, level = 27 })

local node39 = keywordHandler:addKeyword({ "stalagmite" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Stalagmite} Rune spell for 1400 gold?" })
node39:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "stalagmite rune", vocation = { 1, 2, 5, 6 }, price = 1400, level = 24 })

local node40 = keywordHandler:addKeyword({ "thunderstorm" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Thunderstorm} Rune spell for 1100 gold?" })
node40:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "thunderstorm rune", vocation = { 1, 5 }, price = 1100, level = 28 })

local node41 = keywordHandler:addKeyword({ "explosion" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Explosion} Rune spell for 1800 gold?" })
node41:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "explosion rune", vocation = { 1, 2, 5, 6 }, price = 1800, level = 31 })

local node42 = keywordHandler:addKeyword({ "disintegrate" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Disintegrate} Rune spell for 900 gold?" })
node42:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "disintegrate rune", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 900, level = 21 })

local node43 = keywordHandler:addKeyword({ "destroy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Destroy Field} Rune spell for 700 gold?" })
node43:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "destroy field rune", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 700, level = 17 })

local node44 = keywordHandler:addKeyword({ "animate dead" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {animate dead} magic spell for 1200 gold?" })
node44:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "animate dead rune", vocation = { 1, 2, 5, 6 }, price = 1200, level = 27 })

local node45 = keywordHandler:addKeyword({ "creature illusion" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {creature illusion} magic spell for 1000 gold?" })
node45:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "creature illusion", vocation = { 1, 2, 5, 6 }, price = 1000, level = 23 })

local node46 = keywordHandler:addKeyword({ "curse" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {curse} magic spell for 6000 gold?" })
node46:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "curse", vocation = { 1, 5 }, price = 6000, level = 75 })

local node47 = keywordHandler:addKeyword({ "death strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {death strike} magic spell for 800 gold?" })
node47:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "death strike", vocation = { 1, 5 }, price = 800, level = 16 })

local node48 = keywordHandler:addKeyword({ "electrify" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {electrify} magic spell for 2500 gold?" })
node48:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "electrify", vocation = { 1, 5 }, price = 2500, level = 34 })

local node49 = keywordHandler:addKeyword({ "ice strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ice strike} magic spell for 800 gold?" })
node49:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ice strike", vocation = { 1, 2, 5, 6 }, price = 800, level = 8 })

local node50 = keywordHandler:addKeyword({ "ignite" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ignite} magic spell for 1500 gold?" })
node50:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "ignite", vocation = { 1, 5 }, price = 1500, level = 26 })

local node51 = keywordHandler:addKeyword({ "invisible" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {invisible} magic spell for 2000 gold?" })
node51:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "invisible", vocation = { 1, 2, 5, 6 }, price = 2000, level = 35 })

local node52 = keywordHandler:addKeyword({ "lightning" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {lightning} magic spell for 5000 gold?" })
node52:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "lightning", vocation = { 1, 5 }, price = 5000, level = 55 })

local node53 = keywordHandler:addKeyword({ "sudden death" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Sudden Death} Rune spell for 3000 gold?" })
node53:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "sudden death rune", vocation = { 1, 5 }, price = 3000, level = 45 })

local node54 = keywordHandler:addKeyword({ "terra strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {terra strike} magic spell for 800 gold?" })
node54:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "terra strike", vocation = { 1, 2, 5, 6 }, price = 800, level = 13 })

local node55 = keywordHandler:addKeyword({ "apprentice's strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {apprentice's strike} magic spell for free?" })
node55:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "apprentice's strike", vocation = { 1, 2, 5, 6 }, price = 0, level = 6 })

local node56 = keywordHandler:addKeyword({ "buzz" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {buzz} magic spell for free?" })
node56:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "buzz", vocation = { 1, 5 }, price = 0, level = 1 })

local node57 = keywordHandler:addKeyword({ "find fiend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find fiend} magic spell for 1000 gold?" })
node57:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find fiend", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 1000, level = 25 })

local node58 = keywordHandler:addKeyword({ "find person" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find person} magic spell for 80 gold?" })
node58:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find person", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 80, level = 8 })

local node59 = keywordHandler:addKeyword({ "haste" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {haste} magic spell for 600 gold?" })
node59:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "haste", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 600, level = 14 })

local node60 = keywordHandler:addKeyword({ "levitate" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {levitate} magic spell for 500 gold?" })
node60:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "levitate", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 12 })

local node61 = keywordHandler:addKeyword({ "light healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light healing} magic spell for free?" })
node61:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 8 })

local node62 = keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light} magic spell for free?" })
node62:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 0, level = 8 })

local node63 = keywordHandler:addKeyword({ "scorch" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {scorch} magic spell for free?" })
node63:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "scorch", vocation = { 1, 5 }, price = 0, level = 1 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {attack} spells, {healing} spells, {support} spells and spells for {runes}. What kind of spell do you wish to learn? I can also tell you which spells are available at your {level}.",
})

keywordHandler:addKeyword({ "attack" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My attack spells are: {Apprentice's Strike}, {Buzz}, {Creature Illusion}, {Curse}, {Death Strike}, {Electrify}, {Energy Beam}, {Energy Strike}, {Energy Wave}, {Fire Wave}, {Flame Strike}, {Great Energy Beam}, {Great Fire Wave}, {Ice Strike}, {Ignite}, {Invisible}, {Lightning}, {Scorch}, {Strong Energy Strike}, {Strong Flame Strike} and {Terra Strike}.",
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My healing spells are: {Cure Poison}, {Intense Healing}, {Light Healing}, {Magic Patch}, {Restoration} and {Ultimate Healing}.",
})

keywordHandler:addKeyword({ "support" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My support spells are: {Animate Dead}, {Cancel Magic Shield}, {Find Fiend}, {Find Person}, {Great Light}, {Haste}, {Levitate}, {Light}, {Magic Rope}, {Magic Shield}, {Strong Haste}, {Summon Creature}, {Summon Sorcerer Familiar} and {Ultimate Light}.",
})

keywordHandler:addKeyword({ "runes" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My rune spells are: {Destroy Field} Rune, {Disintegrate} Rune, {Energy Bomb} Rune, {Energy Field} Rune, {Energy Wall} Rune, {Explosion} Rune, {Fire Bomb} Rune, {Fire Field} Rune, {Fire Wall} Rune, {Fireball} Rune, {Great Fireball} Rune, {Heavy Magic Missile} Rune, {Light Magic Missile} Rune, {Poison Field} Rune, {Poison Wall} Rune, {Soulfire} Rune, {Stalagmite} Rune, {Sudden Death} Rune and {Thunderstorm} Rune.",
})

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "I have spells for level {1}, {8}, {9}, {10}, {12}, {13}, {14}, {15}, {16}, {17}, {18}, {20}, {21}, {23}, {24}, {25}, {26}, {27}, {28}, {29}, {30}, {31}, {32}, {33}, {34}, {35}, {37}, {38}, {41}, {45}, {55}, {70}, {75}, {80}, {175}, {200}, {275} and {300}.",
})

nodeLevels:addChildKeyword({ "300" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 300 I have {Restoration} for 500000 gold." })
nodeLevels:addChildKeyword({ "275" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 275 I have {Expose Weakness} for 400000 gold." })
nodeLevels:addChildKeyword({ "200" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 200 I have {Summon Sorcerer Familiar} for 50000 gold." })
nodeLevels:addChildKeyword({ "175" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 175 I have {Sap Strength} for 200000 gold." })
nodeLevels:addChildKeyword({ "80" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 80 I have {Strong Energy Strike} for 7500 gold." })
nodeLevels:addChildKeyword({ "75" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 75 I have {Curse} for 6000 gold." })
nodeLevels:addChildKeyword({ "70" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 70 I have {Strong Flame Strike} for 6000 gold." })
nodeLevels:addChildKeyword({ "55" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 55 I have {Lightning} for 5000 gold." })
nodeLevels:addChildKeyword({ "45" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 45 I have {Sudden Death} Rune for 3000 gold." })
nodeLevels:addChildKeyword({ "41" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 41 I have {Energy Wall} Rune for 2500 gold." })
nodeLevels:addChildKeyword({ "38" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 38 I have {Energy Wave} for 2500 gold and {Great Fire Wave} for 25000 gold." })
nodeLevels:addChildKeyword({ "37" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 37 I have {Energy Bomb} Rune for 2300 gold." })
nodeLevels:addChildKeyword({ "35" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 35 I have {Invisible} for 2000 gold." })
nodeLevels:addChildKeyword({ "34" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 34 I have {Electrify} for 2500 gold." })
nodeLevels:addChildKeyword({ "33" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 33 I have {Fire Wall} Rune for 2000 gold." })
nodeLevels:addChildKeyword({ "32" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 32 I have {Magic Wall} Rune for 2100 gold." })
nodeLevels:addChildKeyword({ "31" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 31 I have {Explosion} Rune for 1800 gold." })
nodeLevels:addChildKeyword({ "30" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 30 I have {Great Fireball} Rune for 1200 gold and {Ultimate Healing} for 1000 gold." })
nodeLevels:addChildKeyword({ "29" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 29 I have {Great Energy Beam} for 1800 gold and {Poison Wall} Rune for 1600 gold." })
nodeLevels:addChildKeyword({ "28" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 28 I have {Thunderstorm} Rune for 1100 gold." })
nodeLevels:addChildKeyword({ "27" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 27 I have {Animate Dead} for 1200 gold, {Fire Bomb} Rune for 1500 gold, {Fireball} Rune for 1600 gold and {Soulfire} Rune for 1800 gold." })
nodeLevels:addChildKeyword({ "26" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 26 I have {Ignite} for 1500 gold and {Ultimate Light} for 1600 gold." })
nodeLevels:addChildKeyword({ "25" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 25 I have {Find Fiend} for 1000 gold, {Heavy Magic Missile} Rune for 1500 gold and {Summon Creature} for 2000 gold." })
nodeLevels:addChildKeyword({ "24" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 24 I have {Stalagmite} Rune for 1400 gold." })
nodeLevels:addChildKeyword({ "23" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 23 I have {Creature Illusion} for 1000 gold and {Energy Beam} for 1000 gold." })
nodeLevels:addChildKeyword({ "21" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 21 I have {Disintegrate} Rune for 900 gold." })
nodeLevels:addChildKeyword({ "20" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 20 I have {Intense Healing} for 350 gold and {Strong Haste} for 1300 gold." })
nodeLevels:addChildKeyword({ "18" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 18 I have {Energy Field} Rune for 700 gold and {Fire Wave} for 850 gold." })
nodeLevels:addChildKeyword({ "17" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 17 I have {Destroy Field} Rune for 700 gold." })
nodeLevels:addChildKeyword({ "16" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 16 I have {Death Strike} for 800 gold." })
nodeLevels:addChildKeyword({ "15" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 15 I have {Fire Field} Rune for 500 gold, {Ice Strike} for 800 gold and {Light Magic Missile} Rune for 500 gold." })
nodeLevels:addChildKeyword({ "14" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 14 I have {Cancel Magic Shield} for 450 gold, {Flame Strike} for 800 gold, {Haste} for 600 gold, {Magic Shield} for 450 gold and {Poison Field} Rune for 300 gold." })
nodeLevels:addChildKeyword({ "13" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 13 I have {Great Light} for 500 gold and {Terra Strike} for 800 gold." })
nodeLevels:addChildKeyword({ "12" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 12 I have {Energy Strike} for 800 gold and {Levitate} for 500 gold." })
nodeLevels:addChildKeyword({ "10" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 10 I have {Cure Poison} for 150 gold." })
nodeLevels:addChildKeyword({ "9" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 9 I have {Magic Rope} for 200 gold." })
nodeLevels:addChildKeyword({ "8" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 8 I have {Apprentice's Strike} for free, {Find Person} for 80 gold, {Light} for free and {Light Healing} for free." })
nodeLevels:addChildKeyword({ "1" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 1 I have {Buzz} for free, {Magic Patch} for free and {Scorch} for free." })

npcHandler:setMessage(MESSAGE_GREET, "Greetings, |PLAYERNAME|. If you are looking for sorcerer {spells} don't hesitate to ask.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
