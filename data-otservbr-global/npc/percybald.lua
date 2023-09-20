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
		if player:getStorageValue(Storage.ThievesGuild.TheatreScript) < 0 then
			npcHandler:say({
				"Hmpf. Why should I waste my time to help some amateur? I'm afraid I can only offer my assistance to actors that are as great as I am. ...",
				"Though, your futile attempt to prove your worthiness could be amusing. Grab a copy of a script from the prop room at the theatre cellar. Then talk to me again about your test!",
			}, npc, creature)
			player:setStorageValue(Storage.ThievesGuild.TheatreScript, 0)
		end
	elseif MsgContains(message, "test") then
		if player:getStorageValue(Storage.ThievesGuild.Mission04) == 5 then
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
			npcHandler:say("Grrr!", npc, creature)
			npcHandler:setTopic(playerId, 8)
		elseif npcHandler:getTopic(playerId) == 9 then
			npcHandler:say("You're such a monster!", npc, creature)
			npcHandler:setTopic(playerId, 10)
		elseif npcHandler:getTopic(playerId) == 11 then
			npcHandler:say("Ah well, I think you passed the test! Here is your disguise kit! Now get lost, fate awaits me!", npc, creature)
			player:setStorageValue(Storage.ThievesGuild.Mission04, 6)
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
		if MsgContains(message, "Ahhhhhh!") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", npc, creature)
			npcHandler:setTopic(playerId, 9)
		else
			npcHandler:say("No no no! That is not correct!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 10 then
		if MsgContains(message, "Hahaha! Now drop your weapons or else...") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", npc, creature)
			npcHandler:setTopic(playerId, 11)
		else
			npcHandler:say("No no no! That is not correct!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	
	if (MsgContains(message, "outfit")) or (MsgContains(message, "addon")) 
		or (MsgContains(message,"royal")) then
		npcHandler:say("In exchange for a truly generous donation of gold and silver tokens, I will offer a special outfit. Do you want to make a donation?", npc, creature)
		npcHandler:setTopic(playerId, 12)
	elseif MsgContains(message, "yes") then
		-- vamos tratar todas condições para YES aqui
		if npcHandler:getTopic(playerId) == 12 then
			-- para o primeiro Yes, o npc deve explicar como obter o outfit
			npcHandler:say({
				"Excellent! Now, let me explain. If you donate 30,000 silver tokens and 25,000 gold tokens, you will be entitled to wear a unique outfit. ...",
				"You will be entitled to wear the armor for 15,000 silver tokens and 12,500 gold tokens, and the shield and the crown for additional 7,500 silver tokens and 6,250 gold tokens each. ...",
				"What will it be?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 13)
			-- O NPC só vai oferecer os addons se o player já tiver escolhido.
		elseif npcHandler:getTopic(playerId) == 13 then
			-- caso o player repita o yes, resetamos o tópico para começar de novo?
			npcHandler:say("In that case, return to me once you made up your mind.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			-- Inicio do outfit
		elseif npcHandler:getTopic(playerId) == 14 then -- ARMOR/OUTFIT 1457
			if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) < 1 then
				if (player:removeItem(22516, 15000) and player:removeItem(22721, 12500)) then
					npcHandler:say("Take this armor as a token of great gratitude. Let us forever remember this day, my friend!", npc, creature)
					player:addOutfit(1457)
					player:addOutfit(1456)
					player:getPosition():sendMagicEffect(171)
					player:setStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit, 1)
				else
					npcHandler:say("You do not have enough tokens to donate that amount.", npc, creature)
				end
			else
				npcHandler:say("You alread have that addon.", npc, creature)
			end
			npcHandler:setTopic(playerId, 13)
			-- Fim do outfit
			-- Inicio do helmet
		elseif npcHandler:getTopic(playerId) == 15 then
			if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) == 1 then
				if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) < 2 then
					if (player:removeItem(22516, 7500) and player:removeItem(22721, 6250)) then
						npcHandler:say("Take this sheild as a token of great gratitude. Let us forever remember this day, my friend. ", npc, creature)
						player:addOutfitAddon(1457, 1)
						player:addOutfitAddon(1456, 1)
						player:getPosition():sendMagicEffect(171)
						player:setStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit, 2)
						npcHandler:setTopic(playerId, 13)
					else
						npcHandler:say("You do not have enough tokens to donate that amount.", npc, creature)
						npcHandler:setTopic(playerId, 13)
					end
				else
					npcHandler:say("You alread have that outfit.", npc, creature)
					npcHandler:setTopic(playerId, 13)
				end
			else
				npcHandler:say("You need to donate {armor} outfit first.", npc, creature)
				npcHandler:setTopic(playerId, 13)
			end
			npcHandler:setTopic(playerId, 13)
			-- Fim do helmet
			-- Inicio da boots
		elseif npcHandler:getTopic(playerId) == 16 then
			if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) == 2 then
				if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) < 3 then
					if (player:removeItem(22516, 7500) and player:removeItem(22721, 6250)) then
						npcHandler:say("Take this crown as a token of great gratitude. Let us forever remember this day, my friend. ", npc, creature)
						player:addOutfitAddon(1457, 2)
						player:addOutfitAddon(1456, 2)
						player:getPosition():sendMagicEffect(171)
						player:setStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit, 3)
						npcHandler:setTopic(playerId, 13)
					else
						npcHandler:say("You do not have enough tokens to donate that amount.", npc, creature)
						npcHandler:setTopic(playerId, 13)
					end
				else
					npcHandler:say("You alread have that outfit.", npc, creature)
					npcHandler:setTopic(playerId, 13)
				end
			else
				npcHandler:say("You need to donate {shield} addon first.", npc, creature)
				npcHandler:setTopic(playerId, 13)
			end
			-- Fim da boots
			npcHandler:setTopic(playerId, 13)
		end
		--inicio das opções armor/helmet/boots
		-- caso o player não diga YES, dirá alguma das seguintes palavras:
	elseif (MsgContains(message, "armor")) and npcHandler:getTopic(playerId) == 13 then
		npcHandler:say("So you would like to donate 15,000 silver tokens and 12,500 gold tokens, which in return will entitle you to wear a unique red armor?", npc, creature)
		npcHandler:setTopic(playerId, 14) -- alterando o tópico para que no próximo YES ele faça o outfit
	elseif (MsgContains(message, "shield")) and npcHandler:getTopic(playerId) == 13 then
		npcHandler:say("So you would like to donate 7,500 silver tokens and 6,250 gold tokens, which in return will entitle you to wear a unique shield?", npc, creature)
		npcHandler:setTopic(playerId, 15) -- alterando o tópico para que no próximo YES ele faça o helmet
	elseif (MsgContains(message, "crown")) and npcHandler:getTopic(playerId) == 13 then
		npcHandler:say("So you would like to donate 7,500 silver tokens and 6,250 gold tokens, which in return will entitle you to wear a crown?", npc, creature)
		npcHandler:setTopic(playerId, 16) -- alterando o tópico para que no próximo YES ele faça a boots
	end
	-- fim das opções armor/helmet/boots

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted |PLAYERNAME|!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
