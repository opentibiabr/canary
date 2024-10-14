local internalNpcName = "Percybald"
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
	lookHead = 3,
	lookBody = 21,
	lookLegs = 21,
	lookFeet = 38,
	lookAddons = 0,
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

	if MsgContains(message, "disguise") then
		if player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.TheatreScript) < 0 then
			npcHandler:say({
				"Hmpf. Why should I waste my time to help some amateur? I'm afraid I can only offer my assistance to actors that are as great as I am. ...",
				"Though, your futile attempt to prove your worthiness could be amusing. Grab a copy of a script from the prop room at the theatre cellar. Then talk to me again about your test!",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.TheatreScript, 0)
		end
	elseif MsgContains(message, "test") then
		if player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission04) == 5 then
			npcHandler:say("I hope you learnt your role! I'll tell you a line from the script and you'll have to answer with the corresponding line! Ready?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("How dare you? Are you mad? I hold the princess hostage and you drop your weapons. You're all lost!", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Too late puny knight. You can't stop my master plan anymore!", npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("What's this? Behind the doctor?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say("Haha! You may not fear for your own life, but how about hers!?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		elseif npcHandler:getTopic(playerId) == 9 then
			npcHandler:say("Grrr!", npc, creature)
			npcHandler:setTopic(playerId, 10)
		elseif npcHandler:getTopic(playerId) == 11 then
			npcHandler:say("You're such a monster!", npc, creature)
			npcHandler:setTopic(playerId, 12)
		elseif npcHandler:getTopic(playerId) == 13 then
			npcHandler:say("Ah well, I think you passed the test! Here is your disguise kit! Now get lost, fate awaits me!", npc, creature)
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission04, 6)
			player:addItem(7865, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "I don't think so, dear doctor!") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		else
			npcHandler:say("No no no! That is not correct!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 4 then
		if MsgContains(message, "Watch out! It's a trap!") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		else
			npcHandler:say("No no no! That is not correct!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 6 then
		if MsgContains(message, "Look! It's Lucky, the wonder dog!") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		else
			npcHandler:say("No no no! That is not correct!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 8 then
		if MsgContains(message, "Oh no! Look! It's Princess Buttercup! He's holding her hostage!") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", npc, creature)
			npcHandler:setTopic(playerId, 9)
		else
			npcHandler:say("No no no! That is not correct!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 10 then
		if MsgContains(message, "Ahhhhhh!") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", npc, creature)
			npcHandler:setTopic(playerId, 11)
		else
			npcHandler:say("No no no! That is not correct!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 12 then
		if MsgContains(message, "Hahaha! Now drop your weapons or else...") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", npc, creature)
			npcHandler:setTopic(playerId, 13)
		else
			npcHandler:say("No no no! That is not correct!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end

	-- Additional dialogue options related to outfits
	if MsgContains(message, "outfit") or MsgContains(message, "addon") or MsgContains(message, "royal") then
		npcHandler:say("In exchange for a generous donation of gold and silver tokens, I can offer you a special outfit. Would you like to donate?", npc, creature)
		npcHandler:setTopic(playerId, 14)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 14 then
			npcHandler:say({
				"Great! To clarify, donating 30,000 silver tokens and 25,000 gold tokens will entitle you to a unique outfit. ...",
				"For 15,000 silver tokens and 12,500 gold tokens, you will receive the {armor}. For an additional 7,500 silver tokens and 6,250 gold tokens each, you can also receive the {shield} and {crown}. ...",
				"What will you choose?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 15)
		elseif npcHandler:getTopic(playerId) == 15 then
			npcHandler:say("If you haven't made up your mind, please come back when you are ready.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 16 then
			if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) < 1 then
				if player:removeItem(22516, 15000) and player:removeItem(22721, 12500) then
					npcHandler:say("Take this armor as a token of great gratitude. Let us forever remember this day, my friend!", npc, creature)
					player:addOutfit(1457)
					player:addOutfit(1456)
					player:getPosition():sendMagicEffect(171)
					player:setStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit, 1)
				else
					npcHandler:say("You do not have enough tokens to donate that amount.", npc, creature)
				end
			else
				npcHandler:say("You already have that addon.", npc, creature)
			end
			npcHandler:setTopic(playerId, 15)
		elseif npcHandler:getTopic(playerId) == 17 then
			if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) == 1 then
				if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) < 2 then
					if player:removeItem(22516, 7500) and player:removeItem(22721, 6250) then
						npcHandler:say("Take this shield as a token of great gratitude. Let us forever remember this day, my friend.", npc, creature)
						player:addOutfitAddon(1457, 1)
						player:addOutfitAddon(1456, 1)
						player:getPosition():sendMagicEffect(171)
						player:setStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit, 2)
					else
						npcHandler:say("You do not have enough tokens to donate that amount.", npc, creature)
					end
				else
					npcHandler:say("You already have that outfit.", npc, creature)
				end
			else
				npcHandler:say("You need to donate the {armor} outfit first.", npc, creature)
			end
			npcHandler:setTopic(playerId, 15)
		elseif npcHandler:getTopic(playerId) == 18 then
			if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) == 2 then
				if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) < 3 then
					if player:removeItem(22516, 7500) and player:removeItem(22721, 6250) then
						npcHandler:say("Take this crown as a token of great gratitude. Let us forever remember this day, my friend.", npc, creature)
						player:addOutfitAddon(1457, 2)
						player:addOutfitAddon(1456, 2)
						player:getPosition():sendMagicEffect(171)
						player:setStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit, 3)
					else
						npcHandler:say("You do not have enough tokens to donate that amount.", npc, creature)
					end
				else
					npcHandler:say("You already have that outfit.", npc, creature)
				end
			else
				npcHandler:say("You need to donate the {shield} addon first.", npc, creature)
			end
			npcHandler:setTopic(playerId, 15)
		end
	elseif MsgContains(message, "armor") and npcHandler:getTopic(playerId) == 15 then
		npcHandler:say("Would you like to donate 15,000 silver tokens and 12,500 gold tokens for a unique red armor?", npc, creature)
		npcHandler:setTopic(playerId, 16)
	elseif MsgContains(message, "shield") and npcHandler:getTopic(playerId) == 15 then
		npcHandler:say("Would you like to donate 7,500 silver tokens and 6,250 gold tokens for a unique shield?", npc, creature)
		npcHandler:setTopic(playerId, 17)
	elseif MsgContains(message, "crown") and npcHandler:getTopic(playerId) == 15 then
		npcHandler:say("Would you like to donate 7,500 silver tokens and 6,250 gold tokens for a unique crown?", npc, creature)
		npcHandler:setTopic(playerId, 18)
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted |PLAYERNAME|!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
