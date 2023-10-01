local internalNpcName = "Hugo"
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
	lookHead = 14,
	lookBody = 81,
	lookLegs = 80,
	lookFeet = 0,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
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

local config = {
	['20 brown pieces of cloth'] = {
		itemId = 5913,
		count = 20,
		value = 1,
		messages = {
			done = 'Ghouls sometimes carry it with them. My assistant Irmana can also fabricate cloth from secondhand clothing.',
			deliever = 'Ah! Have you brought 20 pieces of brown cloth?',
			notEnough = 'Uh, that is not even enough cloth for a poor dwarf\'s look.',
			success = 'Yes, yes, that\'s it! Very well, now I need 50 pieces of minotaur leather to continue.'
		}
	},
	['50 minotaur leathers'] = {
		itemId = 5878,
		count = 50,
		value = 2,
		messages = {
			done = 'If you don\'t know how to obtain minotaur leather, ask my apprentice Kalvin. I\'m far too busy for these trivial matters.',
			deliever = 'Were you able to obtain 50 pieces of minotaur leather?',
			notEnough = 'Uh, that is not even enough leather for a poor dwarf\'s look.',
			success = 'Great! This leather will suffice. Now, please, the 10 bat wings.'
		}
	},
	['10 bat wings'] = {
		itemId = 5894,
		count = 10,
		value = 3,
		messages = {
			done = 'Well, what do you expect? Bat wings come from bats, of course.',
			deliever = 'Did you get me the 10 bat wings?',
			notEnough = 'No, no. I need more bat wings! I said, 10!',
			success = 'Hooray! These bat wings are ugly enough. Now the last thing: Please bring me 30 heaven blossoms to neutralise the ghoulish stench.'
		}
	},
	['30 heaven blossoms'] = {
		itemId = 5921,
		count = 30,
		value = 4,
		messages = {
			done = 'A flower favoured by almost all elves.',
			deliever = 'Is this the lovely smell of 30 heaven blossoms?',
			notEnough = 'These few flowers are not enough to neutralise the ghoulish stench.',
			success = 'This is it! I will immediately start to work on this outfit. Come back in a day or something... then my new creation will be born!'
		},
		lastItem = true
	}
}

local topic = {}

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	topic[playerId] = nil
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "uniforms") then
		if player:getStorageValue(Storage.Postman.Mission06) == 1 then
			npcHandler:say("A new uniform for the post officers? I am sorry but my dog ate the last dress pattern we used. You need to supply us with a new dress pattern.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "dress pattern") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("It was ... wonderous beyond wildest imaginations! I have no clue where Kevin Postner got it from. Better ask him.", npc, creature)
			player:setStorageValue(Storage.Postman.Mission06, 2)
		elseif player:getStorageValue(Storage.Postman.Mission06) == 11 then
			npcHandler:say("By the gods of fashion! Didn't it do that I fed the last dress pattern to my poor dog? Will this mocking of all which is taste and fashion never stop?? Ok, ok, you will get those ugly, stinking uniforms and now get lost, fashion terrorist.", npc, creature)
			player:setStorageValue(Storage.Postman.Mission06, 12)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, 'outfit') then
		if not player:isPremium() then
			npcHandler:say('Sorry, but my time is currently reserved for premium matters.', npc, creature)
			return true
		end

		if player:getStorageValue(Storage.OutfitQuest.BeggarOutfit) < 1 then
			npcHandler:say({
				'I think I\'m having an innovative vision! I feel that people are getting tired of attempting to look wealthy and of displaying their treasures. ...',
				'A really new and innovative look would be - the \'poor man\'s look\'! I can already see it in front of me... yes... a little ragged... but not too shabby! ...',
				'I need material right now! Argh - the vision starts to fade... please hurry, can you bring me some stuff?'
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.OutfitQuest.BeggarOutfit) > 0 and player:getStorageValue(Storage.OutfitQuest.BeggarOutfit) < 5 then
			npcHandler:say('I am so excited! This poor man\'s look will be an outfit like the world has never seen before.', npc, creature)
		elseif player:getStorageValue(Storage.OutfitQuest.BeggarOutfit) == 5 then
			if player:getStorageValue(Storage.OutfitQuest.BeggarOutfitTimer) > os.time() then
				npcHandler:say('Sorry, but I am not done with the outfit yet. Venore wasn\'t built in a day.', npc, creature)
			elseif player:getStorageValue(Storage.OutfitQuest.BeggarOutfitTimer) > 0 and player:getStorageValue(Storage.OutfitQuest.BeggarOutfitTimer) < os.time() then
				npcHandler:say('Eureka! Alas, the poor man\'s outfit is finished, but... to be honest... it turned out much less appealing than I expected. However, you can have it if you want, okay?', npc, creature)
				npcHandler:setTopic(playerId, 5)
			end
		elseif player:getStorageValue(Storage.OutfitQuest.BeggarOutfit) == 6 then
			npcHandler:say('I guess my vision wasn\'t that grand after all. I hope there are still people who enjoy it.', npc, creature)
		end
	elseif config[message:lower()] then
		local targetMessage = config[message:lower()]
		if player:getStorageValue(Storage.OutfitQuest.BeggarOutfit) ~= targetMessage.value then
			npcHandler:say(targetMessage.messages.done, npc, creature)
			return true
		end

		npcHandler:say(targetMessage.messages.deliever, npc, creature)
		npcHandler:setTopic(playerId, 4)
		topic[playerId] = targetMessage
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				'Good! Listen, I need the following material - first, 20 pieces of brown cloth, like the worn and ragged ghoul clothing. ...',
				'Secondly, 50 pieces of minotaur leather. Third, I need bat wings, maybe 10. And 30 heaven blossoms, the flowers elves cultivate. ...',
				'Have you noted down everything and will help me gather the material?'
			}, npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:getStorageValue(Storage.OutfitQuest.DefaultStart) ~= 1 then
				player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
			end
			player:setStorageValue(Storage.OutfitQuest.BeggarOutfit, 1)
			npcHandler:say('Terrific! What are you waiting for?! Start right away gathering 20 pieces of brown cloth and come back once you have them!', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 4 then
			local targetMessage = topic[playerId]
			if not player:removeItem(targetMessage.itemId, targetMessage.count) then
				npcHandler:say(targetMessage.messages.notEnough, npc, creature)
				return true
			end

			player:setStorageValue(Storage.OutfitQuest.BeggarOutfit, player:getStorageValue(Storage.OutfitQuest.BeggarOutfit) + 1)
			if targetMessage.lastItem then
				player:setStorageValue(Storage.OutfitQuest.BeggarOutfitTimer, os.time() + 86400)
			end
			npcHandler:say(targetMessage.messages.success, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			player:addOutfit(153)
			player:addOutfit(157)
			player:setStorageValue(Storage.OutfitQuest.BeggarOutfit, 6)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			npcHandler:say('Here you go. Maybe you enjoy if after all.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'no') then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say('Argh! I guess this awesome idea has to remain unimplemented. What a pity.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say('Do you want me to repeat the task requirements?', npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say('Hurry! I am at my creative peak right now!', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say('Well, if you should change your mind, just ask me for the beggar outfit.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
