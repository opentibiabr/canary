local internalNpcName = "Elane"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 137,
	lookHead = 96,
	lookBody = 101,
	lookLegs = 120,
	lookFeet = 120,
	lookAddons = 3
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

	if MsgContains(message, "addon") or MsgContains(message, "outfit") then
		if player:getStorageValue(Storage.OutfitQuest.HunterHatAddon) < 1 then
			npcHandler:say("Oh, my winged tiara? Those are traditionally awarded after having completed a difficult {task} for our guild, only to female aspirants though. Male warriors will receive a hooded cloak.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "task") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("So you are saying that you would like to prove that you deserve to wear such a hooded cloak?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "crossbow") then
		if player:getStorageValue(Storage.OutfitQuest.HunterHatAddon) == 1 then
			npcHandler:say("I'm so excited! Have you really found my crossbow?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "leather") then
		if player:getStorageValue(Storage.OutfitQuest.HunterHatAddon) == 2 then
			npcHandler:say("Did you bring me 100 pieces of lizard leather and 100 pieces of red dragon leather?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "chicken wing") then
		if player:getStorageValue(Storage.OutfitQuest.HunterHatAddon) == 3 then
			npcHandler:say("Were you able to get hold of 5 enchanted chicken wings?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		end
	elseif MsgContains(message, "steel") then
		if player:getStorageValue(Storage.OutfitQuest.HunterHatAddon) == 4 then
			npcHandler:say("Ah, have you brought one piece of royal steel, draconian steel and hell steel each?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"Alright, I will give you a chance. Pay close attention to what I'm going to tell you now. ...",
				"Recently, one of our members moved to Liberty Bay out of nowhere, talking about some strange cult. That is not the problem, but he took my favourite crossbow with him. ...",
				"Please find my crossbow. It has my name engraved on it and is very special to me. ...",
				"Secondly, we need a lot of leather for new quivers. 100 pieces of lizard leather and 100 pieces of red dragon leather should suffice. ...",
				"Third, since we are giving out tiaras, we are always in need of enchanted chicken wings. Please bring me 5, that would help us tremendously. ...",
				"Lastly, for our arrow heads we need a lot of steel. Best would be one piece of royal steel, one piece of draconian steel and one piece of hell steel. ...",
				"Did you understand everything I told you and are willing to handle this task?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("That's the spirit! I hope you will find my crossbow, |PLAYERNAME|!", npc, creature)
			player:setStorageValue(Storage.OutfitQuest.HunterHatAddon, 1)
			player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:removeItem(5947, 1) then
				npcHandler:say("Yeah! I could kiss you right here and there! Besides, you're a handsome one. <giggles> Please bring me 100 pieces of lizard leather and 100 pieces of red dragon leather now!", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.HunterHatAddon, 2)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have it...", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:getItemCount(5876) >= 100 and player:getItemCount(5948) >= 100  then
				npcHandler:say("Good work, |PLAYERNAME|! That is enough leather for a lot of sturdy quivers. Now, please bring me 5 enchanted chicken wings.", npc, creature)
				player:removeItem(5876, 100)
				player:removeItem(5948, 100)
				player:setStorageValue(Storage.OutfitQuest.HunterHatAddon, 3)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have it...", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == 6 then
			if player:removeItem(5891, 5) then
				npcHandler:say("Great! Now we can create a few more Tiaras. If only they weren't that expensive... Well anyway, please obtain one piece of royal steel, draconian steel and hell steel each.", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.HunterHatAddon, 4)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have it...", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == 7 then
			if player:getItemCount(5887) >= 1 and player:getItemCount(5888) >= 1 and player:getItemCount(5889) >= 1  then
				npcHandler:say("Wow, I'm impressed, |PLAYERNAME|. Your really are a valuable member of our paladin guild. I shall grant you your reward now. Wear it proudly!", npc, creature)
				player:removeItem(5887, 1)
				player:removeItem(5888, 1)
				player:removeItem(5889, 1)
				player:setStorageValue(Storage.OutfitQuest.HunterHatAddon, 5)
				player:addOutfitAddon(129, 1)
				player:addOutfitAddon(137, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have it...", npc, creature)
			end
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) > 1 then
			npcHandler:say("Then no.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	return true
	end
end

-- Sniper Gloves
keywordHandler:addKeyword({'sniper gloves'}, StdModule.say, {npcHandler = npcHandler, text = 'We are always looking for sniper gloves. They are supposed to raise accuracy. If you find a pair, bring them here. Maybe I can offer you a nice trade.'}, function(player) return player:getItemCount(5875) == 0 end)

local function addGloveKeyword(text, condition, action)
	local gloveKeyword = keywordHandler:addKeyword({'sniper gloves'}, StdModule.say, {npcHandler = npcHandler, text = text[1]}, condition)
		gloveKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = text[2], reset = true}, function(player) return player:getItemCount(5875) == 0 end)
		gloveKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = text[3], reset = true}, nil, action)
		gloveKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = text[2], reset = true})
end

-- Free Account
addGloveKeyword({
		'You found sniper gloves?! Incredible! I would love to grant you the sniper gloves accessory, but I can only do that for premium warriors. However, I would pay you 2000 gold pieces for them. How about it?',
		'Maybe another time.',
		'Alright! Here is your money, thank you very much.'
	}, function(player) return not player:isPremium() end, function(player) player:removeItem(5875, 1) player:addMoney(2000) end
)

-- Premium account with addon
addGloveKeyword({
		'Did you find sniper gloves AGAIN?! Incredible! I cannot grant you other accessories, but would you like to sell them to me for 2000 gold pieces?',
		'Maybe another time.',
		'Alright! Here is your money, thank you very much.'
	}, function(player) return player:getStorageValue(Storage.OutfitQuest.Hunter.AddonGlove) == 1 end, function(player) player:removeItem(5875, 1) player:addMoney(2000) end
)

-- If you don't have the addon
addGloveKeyword({
		'You found sniper gloves?! Incredible! Listen, if you give them to me, I will grant you the right to wear the sniper gloves accessory. How about it?',
		'No problem, maybe another time.',
		'Great! I hereby grant you the right to wear the sniper gloves as an accessory. Congratulations!'
	}, function(player) return player:getStorageValue(Storage.OutfitQuest.Hunter.AddonGlove) == -1 end, function(player) player:removeItem(5875, 1) player:setStorageValue(Storage.OutfitQuest.Hunter.AddonGlove, 1) player:addOutfitAddon(129, 2) player:addOutfitAddon(137, 1) player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE) end
)

-- Basic
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = "I am the leader of the Paladins. I help our members."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the leader of the Paladins. I help our members."})
keywordHandler:addKeyword({'paladins'}, StdModule.say, {npcHandler = npcHandler, text = "Paladins are great warriors and magicians. Besides that we are excellent missile fighters. Many people in Tibia want to join us."})
keywordHandler:addKeyword({'warriors'}, StdModule.say, {npcHandler = npcHandler, text = "Of course, we aren't as strong as knights, but no druid or sorcerer will ever defeat a paladin with a sword."})
keywordHandler:addKeyword({'magicians'}, StdModule.say, {npcHandler = npcHandler, text = "There are many magic spells and runes paladins can use."})
keywordHandler:addKeyword({'missile'}, StdModule.say, {npcHandler = npcHandler, text = "Paladins are the best missile fighters in Tibia!"})
keywordHandler:addKeyword({'news'}, StdModule.say, {npcHandler = npcHandler, text = "I am a paladin, not a storyteller."})
keywordHandler:addKeyword({'members'}, StdModule.say, {npcHandler = npcHandler, text = "Every paladin profits from his vocation. It has many advantages to be a paladin."})
keywordHandler:addKeyword({'advantages'}, StdModule.say, {npcHandler = npcHandler, text = "We will help you to improve your skills. Besides I offer spells for paladins."})
keywordHandler:addKeyword({'general'}, StdModule.say, {npcHandler = npcHandler, text = "Harkath Bloodblade is the royal general."})
keywordHandler:addKeyword({'army'}, StdModule.say, {npcHandler = npcHandler, text = "Some paladins serve in the kings army."})
keywordHandler:addKeyword({'baxter'}, StdModule.say, {npcHandler = npcHandler, text = "He has some potential."})
keywordHandler:addKeyword({'bozo'}, StdModule.say, {npcHandler = npcHandler, text = "How spineless do you have to be to become a jester?"})
keywordHandler:addKeyword({'mcronald'}, StdModule.say, {npcHandler = npcHandler, text = "The McRonalds are simple farmers."})
keywordHandler:addKeyword({'eclesius'}, StdModule.say, {npcHandler = npcHandler, text = "He must have been skilled before he became the way he is now. Such a pity."})
keywordHandler:addKeyword({'elane'}, StdModule.say, {npcHandler = npcHandler, text = "Yes?"})
keywordHandler:addKeyword({'frodo'}, StdModule.say, {npcHandler = npcHandler, text = "The alcohol he sells shrouds the mind and the eye."})
keywordHandler:addKeyword({'galuna'}, StdModule.say, {npcHandler = npcHandler, text = "One of the most important members of our guild. She makes all the bows and arrows we need."})
keywordHandler:addKeyword({'gorn'}, StdModule.say, {npcHandler = npcHandler, text = "He sells a lot of useful equipment."})
keywordHandler:addKeyword({'gregor'}, StdModule.say, {npcHandler = npcHandler, text = "He and his guildfellows lack the grace of a true warrior."})
keywordHandler:addKeyword({'harkath bloodblade'}, StdModule.say, {npcHandler = npcHandler, text = "A fine warrior and a skilled general."})
keywordHandler:addKeyword({'king tibianus'}, StdModule.say, {npcHandler = npcHandler, text = "King Tibianus is a wise ruler."})
keywordHandler:addKeyword({'lugri'}, StdModule.say, {npcHandler = npcHandler, text = "A follower of evil that will get what he deserves one day."})
keywordHandler:addKeyword({'lynda'}, StdModule.say, {npcHandler = npcHandler, text = "Mhm, a little too nice for my taste. Still, it's amazing how she endures all those men stalking her, especially this creepy Oswald."})
keywordHandler:addKeyword({'marvik'}, StdModule.say, {npcHandler = npcHandler, text = "A skilled healer, that's for sure."})
keywordHandler:addKeyword({'muriel'}, StdModule.say, {npcHandler = npcHandler, text = "Just another arrogant sorcerer."})
keywordHandler:addKeyword({'oswald'}, StdModule.say, {npcHandler = npcHandler, text = "If there wouldn't be higher powers to protect him..."})
keywordHandler:addKeyword({'quentin'}, StdModule.say, {npcHandler = npcHandler, text = "A humble monk and a wise man."})
keywordHandler:addKeyword({'sam'}, StdModule.say, {npcHandler = npcHandler, text = "Strong man. But a little shy."})

npcHandler:setMessage(MESSAGE_GREET, "Welcome to the paladins' guild, |PLAYERNAME|! How can I help you?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "sniper gloves", clientId = 5875, sell = 2000 }
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
