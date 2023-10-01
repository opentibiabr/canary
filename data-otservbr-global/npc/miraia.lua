local internalNpcName = "Miraia"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 150,
	lookHead = 114,
	lookBody = 0,
	lookLegs = 7,
	lookFeet = 132,
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

local topic = {}

local config = {
	['ape fur'] = {
		itemId = 5883,
		count = 100,
		storageValue = 1,
		text = {
			'Have you really managed to fulfil the task and brought me 100 pieces of ape fur?',
			'Only ape fur is good enough to touch the feet of our Caliph.',
			'Ahhh, this softness! I\'m impressed, |PLAYERNAME|. You\'re on the best way to earn that turban. Now, please retrieve 100 fish fins.'
		}
	},
	['fish fins'] = {
		itemId = 5895,
		count = 100,
		storageValue = 2,
		text = {
			'Were you able to discover the undersea race and retrieved 100 fish fins?',
			'I really wonder what the explorer society is up to. Actually I have no idea how they managed to dive unterwater.',
			'I never thought you\'d make it, |PLAYERNAME|. Now we only need two enchanted chicken wings to start our waterwalking test!'
		}
	},
	['enchanted chicken wings'] = {
		itemId = 5891,
		count = 2,
		storageValue = 3,
		text = {
			'Were you able to get hold of two enchanted chicken wings?',
			'Enchanted chicken wings are actually used to make boots of haste, so they could be magically extracted again. Djinns are said to be good at that.',
			'Great, thank you very much. Just bring me 100 pieces of blue cloth now and I will happily show you how to make a turban.'
		}
	},
	['blue cloth'] = {
		itemId = 5912,
		count = 100,
		storageValue = 4,
		text = {
			'Ah, have you brought the 100 pieces of blue cloth?',
			'It\'s a great material for turbans.',
			'Ah! Congratulations - I hope this veil will turn out as beautiful as you are. Here, I\'ll do it for you.'
		}
	}
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'outfit') then
		npcHandler:say(player:getSex() == PLAYERSEX_FEMALE and 'Hehe, would you like to wear a pretty veil like I do? Well... I could help you, but you would have to complete a task first.' or 'My veil? No, I will definitely not lift it for you! If you are looking for an addon, go talk to Razan.', npc, creature)
	elseif MsgContains(message, 'task') then
		if player:getSex() == PLAYERSEX_MALE then
			npcHandler:say('Uh... I don\'t think that I have work for you right now. If you need a job, go talk to Razan.', npc, creature)
			return true
		end
		if player:getStorageValue(Storage.OutfitQuest.secondOrientalAddon) < 1 then
			npcHandler:say('You mean, you would like to prove that you deserve to wear such a veil?', npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif config[message] and npcHandler:getTopic(playerId) == 0 then
		if player:getStorageValue(Storage.OutfitQuest.secondOrientalAddon) == config[message].storageValue then
			npcHandler:say(config[message].text[1], npc, creature)
			npcHandler:setTopic(playerId, 3)
			topic[playerId] = message
		else
			npcHandler:say(config[message].text[2], npc, creature)
		end
	elseif MsgContains(message, 'scarab cheese') then
		if player:getStorageValue(Storage.TravellingTrader.Mission03) == 1 then
			npcHandler:say('Let me cover my nose before I get this for you... Would you REALLY like to buy scarab cheese for 100 gold?', npc, creature)
		elseif player:getStorageValue(Storage.TravellingTrader.Mission03) == 2 then
			npcHandler:say('Oh the last cheese molded? Would you like to buy another one for 100 gold?', npc, creature)
		end
		npcHandler:setTopic(playerId, 4)
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				'Alright, then listen to the following requirements. We are currently in dire need of ape fur since the Caliph has requested a new bathroom carpet. ...',
				'Thus, please bring me 100 pieces of ape fur. Secondly, it came to our ears that the explorer society has discovered a new undersea race of fishmen. ...',
				'Their fins are said to allow humans to walk on water! Please bring us 100 of these fish fin. ...',
				'Third, if the plan of walking on water should fail, we need enchanted chicken wings to prevent the testers from drowning. Please bring me two. ...',
				'Last but not least, just drop by with 100 pieces of blue cloth and I will happily show you how to make a turban. ...',
				'Did you understand everything I told you and are willing to handle this task?'
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(Storage.OutfitQuest.DefaultStart) ~= 1 then
				player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
			end
			player:setStorageValue(Storage.OutfitQuest.secondOrientalAddon, 1)
			npcHandler:say('Excellent! Come back to me once you have collected 100 pieces of ape fur.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			local targetMessage = config[topic[playerId]]
			if not player:removeItem(targetMessage.itemId, targetMessage.count) then
				npcHandler:say('That is a shameless lie.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end
			player:setStorageValue(Storage.OutfitQuest.secondOrientalAddon, player:getStorageValue(Storage.OutfitQuest.secondOrientalAddon) + 1)
			if player:getStorageValue(Storage.OutfitQuest.secondOrientalAddon) == 5 then
				player:addOutfitAddon(146, 2)
				player:addOutfitAddon(150, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			end
			npcHandler:say(targetMessage.text[3], npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:getMoney() + player:getBankBalance() >= 100 then
				player:setStorageValue(Storage.TravellingTrader.Mission03, 2)
				player:addItem(169, 1)
				player:removeMoneyBank(100)
				npcHandler:say('Here it is.', npc, creature)
			else
				npcHandler:say('You don\'t have enough money.', npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'no') and npcHandler:getTopic(playerId) ~= 0 then
		npcHandler:say('What a pity.', npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

local function onReleaseFocus(npc, creature)
	local playerId = creature:getId()
	topic[playerId] = nil
end

keywordHandler:addKeyword({'drink'}, StdModule.say, {npcHandler = npcHandler, text = 'I can offer you lemonade, camel milk, and water. If you\'d like to see my offers, ask me for a {trade}.'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Are you looking for food? I have bread, cheese, ham, and meat. If you\'d like to see my offers, ask me for a {trade}.'})

npcHandler:setMessage(MESSAGE_GREET, 'Daraman\'s blessings, |PLAYERNAME|. Welcome to the Enlightened Oasis. Sit down, have a {drink} or some {food}!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Daraman\'s blessings. Come back soon.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, buy = 4 },
	{ itemName = "cheese", clientId = 3607, buy = 6 },
	{ itemName = "ham", clientId = 3582, buy = 8 },
	{ itemName = "ice cube", clientId = 7441, sell = 250 },
	{ itemName = "meat", clientId = 3577, buy = 5 },
	{ itemName = "mug of lemonade", clientId = 2880, buy = 3, count = 12 },
	{ itemName = "mug of milk", clientId = 2880, buy = 5, count = 9 },
	{ itemName = "mug of water", clientId = 2880, buy = 2, count = 1 },
	{ itemName = "scarab cheese", clientId = 169, buy = 100 }
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
