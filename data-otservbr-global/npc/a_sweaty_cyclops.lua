local internalNpcName = "A Sweaty Cyclops"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 22
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'Hum hum, huhum' },
	{ text = 'Silly lil\' human' }
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

	if MsgContains(message, "melt") then
		npcHandler:say("Can melt gold ingot for lil' one. You want?", npc, creature)
		npcHandler:setTopic(playerId, 10)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 10 then
		if player:removeItem(9058,1) then
			npcHandler:say("whoooosh There!", npc, creature)
			player:addItem(12804, 1)
		else
			npcHandler:say("There is no gold ingot with you.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end

	if MsgContains(message, "amulet") then
		if player:getStorageValue(Storage.SweetyCyclops.AmuletStatus) < 1 then
			npcHandler:say("Me can do unbroken but Big Ben want gold 5000 and Big Ben need a lil' time to make it unbroken. Yes or no??", npc, creature)
			npcHandler:setTopic(playerId, 9)
		elseif player:getStorageValue(Storage.SweetyCyclops.AmuletStatus) == 1 then
			npcHandler:say("Ahh, lil' one wants amulet. Here! Have it! Mighty, mighty amulet lil' one has. Don't know what but mighty, mighty it is!!!", npc, creature)
			player:addItem(7532, 1)
			player:setStorageValue(Storage.SweetyCyclops.AmuletStatus, 2)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Wait. Me work no cheap is. Do favour for me first, yes?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Me need gift for woman. We dance, so me want to give her bast skirt. But she big is. So I need many to make big one. Bring three okay? Me wait.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.FriendsandTraders.DefaultStart, 1)
			player:setStorageValue(Storage.FriendsandTraders.TheSweatyCyclops, 1)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(3560, 3) then
				npcHandler:say("Good good! Woman happy will be. Now me happy too and help you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				player:setStorageValue(Storage.FriendsandTraders.TheSweatyCyclops, 2)
			end
		-- Crown Armor
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:removeItem(3381, 1) then
				npcHandler:say("Cling clang!", npc, creature)
				npcHandler:setTopic(playerId, 0)
				player:addItem(5887, 1)
			end
		-- Dragon Shield
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:removeItem(3416, 1) then
				npcHandler:say("Cling clang!", npc, creature)
				npcHandler:setTopic(playerId, 0)
				player:addItem(5889, 1)
			end
		-- Devil Helmet
		elseif npcHandler:getTopic(playerId) == 6 then
			if player:removeItem(3356, 1) then
				npcHandler:say("Cling clang!", npc, creature)
				npcHandler:setTopic(playerId, 0)
				player:addItem(5888, 1)
			end
		-- Giant Sword
		elseif npcHandler:getTopic(playerId) == 7 then
			if player:removeItem(3281, 1) then
				npcHandler:say("Cling clang!", npc, creature)
				npcHandler:setTopic(playerId, 0)
				player:addItem(5892, 1)
			end
		-- Soul Orb
		elseif npcHandler:getTopic(playerId) == 8 then
			if player:getItemCount(5944) > 0 then
				local count = player:getItemCount(5944)
				for i = 1, count do
					if math.random(100) <= 1 then
						player:addItem(6528, 6)
						player:removeItem(5944, 1)
					else
						player:addItem(6528, 3)
						player:removeItem(5944, 1)
					end
				end
				npcHandler:say("Cling clang!", npc, creature)
				npcHandler:setTopic(playerId, 0)
				else
				npcHandler:say("You dont have soul orbs!", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 9 then
			if player:getItemCount(7528) > 0 and player:getItemCount(7529) > 0 and player:getItemCount(7530) > 0 and player:getItemCount(7531) > 0 and player:getMoney() + player:getBankBalance() >= 5000 then
				player:removeItem(7528, 1)
				player:removeItem(7529, 1)
				player:removeItem(7530, 1)
				player:removeItem(7531, 1)
				player:removeMoneyBank(5000)
				player:setStorageValue(Storage.SweetyCyclops.AmuletTimer, os.time())
				player:setStorageValue(Storage.SweetyCyclops.AmuletStatus, 1)
				npcHandler:say("Well, well, I do that! Big Ben makes lil' amulet unbroken with big hammer in big hands! No worry! Come back after sun hits the horizon 24 times and ask me for amulet.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 11 then
			if player:removeItem(5880, 1) then
				player:setStorageValue(Storage.HiddenCityOfBeregar.GearWheel, player:getStorageValue(Storage.HiddenCityOfBeregar.GearWheel) + 1)
				player:addItem(8775, 1)
				npcHandler:say("Cling clang!", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Lil' one does not have any iron ores.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end

	-- Crown Armor
	elseif MsgContains(message, "uth'kean") then
		if player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			npcHandler:say("Very noble. Shiny. Me like. But breaks so fast. Me can make from shiny armour. Lil' one want to trade?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			npcHandler:say("Lil' one bring three bast skirts?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Very noble. Shiny. Me like. But breaks so fast. Me can make from shiny armour. Lil' one want to trade?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	-- Dragon Shield
	elseif MsgContains(message, "uth'lokr") then
		if player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			npcHandler:say("Firy steel it is. Need green ones' breath to melt. Or red even better. Me can make from shield. Lil' one want to trade?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			npcHandler:say("Lil' one bring three bast skirts?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Firy steel it is. Need green ones' breath to melt. Or red even better. Me can make from shield. Lil' one want to trade?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	-- Devil Helmet
	elseif MsgContains(message, "za'ralator") then
		if player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			npcHandler:say("Hellsteel is. Cursed and evil. Dangerous to work with. Me can make from evil helmet. Lil' one want to trade?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			npcHandler:say("Lil' one bring three bast skirts?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Hellsteel is. Cursed and evil. Dangerous to work with. Me can make from evil helmet. Lil' one want to trade?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		end
	-- Giant Sword
	elseif MsgContains(message, "uth'prta") then
		if player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			npcHandler:say("Good iron is. Me friends use it much for fight. Me can make from weapon. Lil' one want to trade?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			npcHandler:say("Lil' one bring three bast skirts?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Good iron is. Me friends use it much for fight. Me can make from weapon. Lil' one want to trade?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		end
	-- Soul Orb
	elseif MsgContains(message, "soul orb") then
		if player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			npcHandler:say("Uh. Me can make some nasty lil' bolt from soul orbs. Lil' one want to trade all?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			npcHandler:say("Lil' one bring three bast skirts?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Uh. Me can make some nasty lil' bolt from soul orbs. Lil' one want to trade all?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		end
	elseif MsgContains(message, "gear wheel") then
		if player:getStorageValue(Storage.HiddenCityOfBeregar.GoingDown) > 0 and player:getStorageValue(Storage.HiddenCityOfBeregar.GearWheel) > 3 then
			npcHandler:say("Uh. Me can make some gear wheel from iron ores. Lil' one want to trade?", npc, creature)
			npcHandler:setTopic(playerId, 11)
		end
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am smith."})
keywordHandler:addKeyword({'smith'}, StdModule.say, {npcHandler = npcHandler, text = "Working steel is my profession."})
keywordHandler:addKeyword({'steel'}, StdModule.say, {npcHandler = npcHandler, text = "Manny kinds of. Like {Mesh Kaha Rogh'}, {Za'Kalortith}, {Uth'Byth}, {Uth'Morc}, {Uth'Amon}, {Uth'Maer}, {Uth'Doon}, and {Zatragil}."})
keywordHandler:addKeyword({'zatragil'}, StdModule.say, {npcHandler = npcHandler, text = "Most ancients use dream silver for different stuff. Now ancients most gone. Most not know about."})
keywordHandler:addKeyword({'uth\'doon'}, StdModule.say, {npcHandler = npcHandler, text = "It's high steel called. Only lil' lil' ones know how make."})
keywordHandler:addKeyword({'za\'kalortith'}, StdModule.say, {npcHandler = npcHandler, text = "It's evil. Demon iron is. No good cyclops goes where you can find and need evil flame to melt."})
keywordHandler:addKeyword({'mesh kaha rogh'}, StdModule.say, {npcHandler = npcHandler, text = "Steel that is singing when forged. No one knows where find today."})
keywordHandler:addKeyword({'uth\'byth'}, StdModule.say, {npcHandler = npcHandler, text = "Not good to make stuff off. Bad steel it is. But eating magic, so useful is."})
keywordHandler:addKeyword({'uth\'maer'}, StdModule.say, {npcHandler = npcHandler, text = "Brightsteel is. Much art made with it. Sorcerers too lazy and afraid to enchant much."})
keywordHandler:addKeyword({'uth\'amon'}, StdModule.say, {npcHandler = npcHandler, text = "Heartiron from heart of big old mountain, found very deep. Lil' lil ones fiercely defend. Not wanting to have it used for stuff but holy stuff."})
keywordHandler:addKeyword({'ab\'dendriel'}, StdModule.say, {npcHandler = npcHandler, text = "Me parents live here before town was. Me not care about lil' ones."})
keywordHandler:addKeyword({'lil\' lil\''}, StdModule.say, {npcHandler = npcHandler, text = "Lil' lil' ones are so fun. We often chat."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "One day I'll go and look."})
keywordHandler:addKeyword({'teshial'}, StdModule.say, {npcHandler = npcHandler, text = "Is one of elven family or such thing. Me not understand lil' ones and their business."})
keywordHandler:addKeyword({'cenath'}, StdModule.say, {npcHandler = npcHandler, text = "Is one of elven family or such thing. Me not understand lil' ones and their business."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I called Bencthyclthrtrprr by me people. Lil' ones me call Big Ben."})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = "You shut up. Me not want to hear."})
keywordHandler:addKeyword({'fire sword'}, StdModule.say, {npcHandler = npcHandler, text = "Do lil' one want to trade a fire sword?"})
keywordHandler:addKeyword({'dragon shield'}, StdModule.say, {npcHandler = npcHandler, text = "Do lil' one want to trade a dragon shield?"})
keywordHandler:addKeyword({'sword of valor'}, StdModule.say, {npcHandler = npcHandler, text = "Do lil' one want to trade a sword of valor?"})
keywordHandler:addKeyword({'warlord sword'}, StdModule.say, {npcHandler = npcHandler, text = "Do lil' one want to trade a warlord sword?"})
keywordHandler:addKeyword({'minotaurs'}, StdModule.say, {npcHandler = npcHandler, text = "They were friend with me parents. Long before elves here, they often made visit. No longer come here."})
keywordHandler:addKeyword({'elves'}, StdModule.say, {npcHandler = npcHandler, text = "Me not fight them, they not fight me."})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = "Me wish I could make weapon like it."})
keywordHandler:addKeyword({'cyclops'}, StdModule.say, {npcHandler = npcHandler, text = "Me people not live here much. Most are far away."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "Hum Humm! Welcume lil' |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye lil' one.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
