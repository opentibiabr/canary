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

npcHandler:setMessage(MESSAGE_GREET, "Greetings, |PLAYERNAME|. If you are looking for sorcerer {spells} don't hesitate to ask.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
