local internalNpcName = "Carlos"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 132,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 86,
	lookFeet = 114,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'Hmm, we should do something about your outfit.' },
	{ text = 'Ah, another adventurer. Let\'s talk a little.' },
	{ text = 'Psst! Come over here for a little trade.' },
	{ text = 'Hello, hello! Don\'t be shy, I don\'t bite.' },
	{ text = 'By the way, if you want to look at old hints again, find the \'Help\' button near your inventory and select \'Tutorial Hints\'.' }
}

-- Npc shop
npcConfig.shop = {
	{ itemName = "ham", clientId = 3582, sell = 2, count = 1 },
	{ itemName = "meat", clientId = 3577, sell = 2, count = 1 }
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

local storeTalkCid = {}

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Be greeted, |PLAYERNAME|! As a tailor and merchant I have to say - we need to do something about your {outfit}, shall we?")
		player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage, 1)
		player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosQuestLog, 1)
		storeTalkCid[playerId] = 1
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Hey, I thought you were going to run away, but luckily you came back. I'll show you how to change your {outfit}, okay?")
		storeTalkCid[playerId] = 1
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage) == 2 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back! You know, after providing my little outfit service, I like to ask a little favour of you. Can you {help} me?")
		storeTalkCid[playerId] = 2
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage) == 3 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh hey |PLAYERNAME|, you didn't answer my question yet - could you help me get some {food}? I'll even give you some gold for it.")
		storeTalkCid[playerId] = 3
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back |PLAYERNAME|, I hope you changed your mind and will bring me some {meat}? I'll even give you some gold for it.")
		storeTalkCid[playerId] = 4
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage) == 5 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back, |PLAYERNAME|! Did you have a successful hunt and carry a piece of {meat} or ham with you?")
		storeTalkCid[playerId] = 5
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage) == 6 then
		if player:getItemCount(3577) > 0 or player:getItemCount(3582) > 0 then
			npcHandler:setMessage(MESSAGE_GREET, "Welcome back, Isleth Eagonst! Do you still have that piece of meat or ham? If so, please ask me for a {trade} and I'll give you some gold for it.")
			storeTalkCid[playerId] = 6
		else
			npcHandler:setMessage(MESSAGE_GREET, "Welcome back, |PLAYERNAME|! Where did you put that delicious piece of food? Did you eat it yourself? Well, if you find another one, please come back.")
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		end
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage) == 7 then
		npcHandler:setMessage(MESSAGE_GREET, "Hey there, |PLAYERNAME|! Well, that's how trading with NPCs like me works. I think you are ready now to cross the bridge to Rookgaard! Take care!")
		player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosQuestLog, 7)
		player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage, 8)
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc(creature)
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage) == 8 then
		npcHandler:setMessage(MESSAGE_GREET, "Hello again, |PLAYERNAME|! What are you still doing here? You should head over the bridge to Rookgaard village now!")
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc(creature)
	end
	return true
end

local function releasePlayer(npc, creature)
	if not Player(creature) then
		return
	end

	npcHandler:removeInteraction(npc, creature)
	npcHandler:resetNpc(creature)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if isInArray({"yes", "help", "ok"}, message) then
		if storeTalkCid[playerId] == 1 then
			npcHandler:say("Very well. Just choose an outfit and a colour combination that suits you. You can open this dialogue anytime by right-clicking on yourself and selecting 'Set Outfit'. Just try it and then talk to me again!", npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage, 2)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosQuestLog, 2)
			player:sendTutorial(12)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		elseif storeTalkCid[playerId] == 2 then
			npcHandler:say("You see, I'm quite hungry from standing here all day. Could you get me some {food}?", npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage, 3)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosQuestLog, 3)
			storeTalkCid[playerId] = 3
		elseif storeTalkCid[playerId] == 3 then
			npcHandler:say("Thank you! I would do it myself, but I don't have a weapon. Just kill a few rabbits or deer, loot food from them and bring me one piece of {meat} or ham, will you?", npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage, 4)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosQuestLog, 4)
			storeTalkCid[playerId] = 4
		elseif storeTalkCid[playerId] == 4 then
			npcHandler:say("Splendid. I'll be awaiting your return eagerly. Don't forget that you can click on the 'Chase Opponent' button to run after those fast creatures. Good {bye} for now!", npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage, 5)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosQuestLog, 5)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		elseif storeTalkCid[playerId] == 5 then
			if player:getItemCount(3577) > 0 or player:getItemCount(3582) > 0 then
				npcHandler:say("What's that delicious smell? That must be a piece of meat! Please hurry, simply ask me for a {trade} and I'll give you two gold pieces for it!", npc, creature)
				player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosQuestLog, 6)
				player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage, 6)
				player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcTradeStorage, 1)
				storeTalkCid[playerId] = 6
			else
				npcHandler:say("Hmm. No, I don't think you have something with you that I'd like to eat. Please come back once you looted a piece of meat or a piece of ham from a rabbit or deer.", npc, creature)
				npcHandler:removeInteraction(npc, creature)
				npcHandler:resetNpc(creature)
			end
		elseif storeTalkCid[playerId] == 7 then
			npcHandler:say({
				"Well, that's how trading with NPCs like me works. I think you are ready now to cross the bridge to Rookgaard, just follow the path to the northwest. Good luck, |PLAYERNAME|! ...",
				"And by the way: if you thought all of this was boring and you'd rather skip the tutorial with your next character, just say 'skip tutorial' to Santiago. ...",
				"Then you'll miss out on those nice items and experience though. Hehehe! It's your choice. Well, take care for now!"
			}, npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosQuestLog, 7)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage, 8)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		end
	elseif MsgContains(message, "outfit") then
		if storeTalkCid[playerId] == 1 then
			npcHandler:say({
				"Well, that's how trading with NPCs like me works. I think you are ready now to cross the bridge to Rookgaard, just follow the path to the northwest. Good luck, |PLAYERNAME|! ...",
				"And by the way: if you thought all of this was boring and you'd rather skip the tutorial with your next character, just say 'skip tutorial' to Santiago. ...",
				"Then you'll miss out on those nice items and experience though. Hehehe! It's your choice. Well, take care for now!"
			}, npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosQuestLog, 7)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage, 8)
			addEvent(function()
				releasePlayer(npc, creature)
			end, 1000)
		end
	elseif MsgContains(message, "ready") then
		if storeTalkCid[playerId] == 7 then
			npcHandler:say({
				"Well, that's how trading with NPCs like me works. I think you are ready now to cross the bridge to Rookgaard, just follow the path to the northwest. Good luck, |PLAYERNAME|! ...",
				"And by the way: if you thought all of this was boring and you'd rather skip the tutorial with your next character, just say 'skip tutorial' to Santiago. ...",
				"Then you'll miss out on those nice items and experience though. Hehehe! It's your choice. Well, take care for now!"
			}, npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosQuestLog, 7)
			player:setStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcGreetStorage, 8)
			addEvent(function()
				releasePlayer(npc, creature)
			end, 5000)
		end
	end
	return true
end

local function onTradeRequest(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.RookgaardTutorialIsland.CarlosNpcTradeStorage) ~= 1 then
		return false
	end

	return true
end

local function onReleaseFocus(npc, creature)
	local playerId = creature:getId()
	storeTalkCid[playerId] = nil
end

npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:setMessage(MESSAGE_SENDTRADE, "Very nice! Food for me! Sell it to me, fast! Once you sold your food to me, just say {ready} to let me know you are done.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye |PLAYERNAME|!.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye traveller and enjoy your stay on Rookgaard.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
