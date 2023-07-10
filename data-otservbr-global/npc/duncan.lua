local internalNpcName = "Duncan"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 151,
	lookHead = 38,
	lookBody = 23,
	lookLegs = 0,
	lookFeet = 116,
	lookAddons = 1
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local storage = Storage.OutfitQuest.PirateSabreAddon

	if isInArray({'outfit', 'addon'}, message) and player:getStorageValue(Storage.OutfitQuest.PirateBaseOutfit) == 1 then
		npcHandler:say(
			"You're talking about my sabre? Well, even though you earned our trust, \
			you'd have to fulfill a task first before you are granted to wear such a sabre.",
		creature)
	elseif MsgContains(message, 'mission') then
		if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 6 then
			npcHandler:say(
				'I need a new quality atlas for our captains. Only one of the best will do it. \
				I heard the explorers society sells the best, but only to members of a certain rank. \
				You will have to get this rank or ask a high ranking member to buy it for you.',
			creature)
			player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 7)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 7 then
			npcHandler:say('Did you get an atlas of the explorers society as I requested?', npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif
			player:getStorageValue(Storage.TheShatteredIsles.RaysMission2) > 0 and
				player:getStorageValue(Storage.TheShatteredIsles.TortoiseEggNargorDoor) < 0
		 then
			npcHandler:say(
				'You did some impressive things. I think people here start considering you as one of us. \
				But these are dire times and everyone of us is expected to give his best and even exceed himself. \
				Do you think you can handle that?',
				creature)
			npcHandler:setTopic(playerId, 7)
		elseif player:getStorageValue(Storage.TheShatteredIsles.TortoiseEggNargorDoor) == 1 then
			npcHandler:say('Did you rescue one of those poor soon-to-be baby tortoises from Nargor?', npc, creature)
			npcHandler:setTopic(playerId, 8)
		end
	elseif MsgContains(message, 'task') then
		if player:getStorageValue(storage) < 1 then
			npcHandler:say(
				"Are you up to the task which I'm going to give you and willing to prove you're worthy of wearing such a sabre?",
				creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, 'eye patches') then
		if player:getStorageValue(storage) == 1 then
			npcHandler:say('Have you gathered 100 eye patches?', npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, 'peg legs') then
		if player:getStorageValue(storage) == 2 then
			npcHandler:say('Have you gathered 100 peg legs?', npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, 'hooks') then
		if player:getStorageValue(storage) == 3 then
			npcHandler:say('Have you gathered 100 hooks?', npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say(
				{
					'Listen, the task is not that hard. Simply prove that you are with us and not with the \
					pirates from Nargor by bringingme some of their belongings. ...',
					'Bring me 100 of their eye patches, 100 of their peg legs and 100 of their hooks, in that order. ...',
					'Have you understood everything I told you and are willing to handle this task?'
				},
				creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			player:setStorageValue(storage, 1)
			player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			npcHandler:say('Good! Come back to me once you have gathered 100 eye patches.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(6098, 100) then
				player:setStorageValue(storage, 2)
				npcHandler:say('Good job. Alright, now bring me 100 peg legs.', npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have it...", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:removeItem(6126, 100) then
				player:setStorageValue(storage, 3)
				npcHandler:say('Nice. Lastly, bring me 100 pirate hooks. That should be enough to earn your sabre.', npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have it...", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:removeItem(6097, 100) then
				player:setStorageValue(storage, 4)
				npcHandler:say(
					"I see, I see. Well done. Go to Morgan and tell him this codeword: 'firebird'. He'll know what to do.",
				creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have it...", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == 6 then
			if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 7 then
				if player:removeItem(6108, 1) then
					npcHandler:say('Indeed, what a fine work... the book I mean. Your work was acceptable all in all.', npc, creature)
					player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 8)
					npcHandler:setTopic(playerId, 0)
				else
					npcHandler:say("You don't have it...", npc, creature)
					npcHandler:setTopic(playerId, 0)
				end
			end
		elseif npcHandler:getTopic(playerId) == 7 then
			if player:getStorageValue(Storage.TheShatteredIsles.TortoiseEggNargorDoor) < 0 then
				npcHandler:say(
					{
						'I am glad to hear this. Please listen. The pirates on Nargor are breeding tortoises. \
						They think eating tortoises makes a hard man even harder. ...',
						"However I am quite fond of tortoises and can't stand the thought of them being eaten. \
						So I convinced Captain Striker that I can train them to help us. As a substitute for rafts and such ...",
						'All I need is one tortoise egg from Nargor. \
						This is the opportunity to save a tortoise from a gruesome fate! ...',
						'I will ask Sebastian to bring you there. \
						Travel to Nargor, find their tortoise eggs and bring me at least one of them.'
					},
				creature)
				player:setStorageValue(Storage.TheShatteredIsles.TortoiseEggNargorDoor, 1)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 8 then
			if player:getStorageValue(Storage.TheShatteredIsles.TortoiseEggNargorDoor) == 1 then
				if player:removeItem(6125, 1) then
					npcHandler:say('A real tortoise egg ... I guess you are more accustomed to rescue some \z
						noblewoman in distress but you did something goodtoday.', npc, creature)
					player:setStorageValue(Storage.TheShatteredIsles.TortoiseEggNargorDoor, 2)
					player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 16)
					if player:getStorageValue(Storage.TheIceIslands.Questline) >= 9 then
						player:addAchievement('Animal Activist')
					end
					npcHandler:setTopic(playerId, 0)
				else
					npcHandler:say("You don't have it...", npc, creature)
					npcHandler:setTopic(playerId, 0)
				end
			end
		end
	elseif MsgContains(message, 'no') then
		if npcHandler:getTopic(playerId) >= 1 then
			npcHandler:say('Then no.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "pirate tapestry", clientId = 5615, buy = 40 }
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
