local internalNpcName = "Gnomission"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 41,
	lookBody = 115,
	lookLegs = 100,
	lookFeet = 95,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end


	if(MsgContains(message, "warzones")) then
		npcHandler:say({
			"There are three warzones. In each warzone you will find fearsome foes. At the end you'll find their mean master. The masters is well protected though. ...",
			"Make sure to talk to our gnomish agent in there for specifics of its' protection. ...",
			"Oh, and to be able to enter the second warzone you have to best the first. To enter the third you have to best the second. ...",
			"And you can enter each one only once every twenty hours. Your normal teleport crystals won't work on these teleporters. You will have to get {mission} crystals from Gnomally."
		}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif(MsgContains(message, "job")) then
		npcHandler:say("I am responsible for our war {missions}, to {trade} with seasoned soldiers and rewarding war {heroes}. You have to be rank 4 to enter the {warzones}.", npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif(MsgContains(message, "heroes")) then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"You can trade special spoils of war to get a permission to use the war teleporters to the area of the corresponding boss without need of mission crystals. ...",
				"Which one would you like to trade: the deathstrike's {snippet}, gnomevil's {hat} or the abyssador {lash}?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif(MsgContains(message, "snippet")) then
		if npcHandler:getTopic(playerId) == 3 then
			if player:getStorageValue(Storage.BigfootBurden.Rank) < 1440 then
				npcHandler:say("It seems you did not even set one big foot into the warzone, I am sorry.")
			else
				if player:getStorageValue(Storage.BigfootBurden.Warzone1Access) < 1 then
					if player:removeItem(16136, 1) then
						player:setStorageValue(Storage.BigfootBurden.Warzone1Access, 1)
						npcHandler:say("As a war hero you are allowed to use the warzone teleporter one for free!", npc, creature)
						npcHandler:setTopic(playerId, 0)
					else
						npcHandler:say("I can't let you enter the warzone teleporter one for free, unless you handle me a Deathstrike's snippet. But can still always use a red teleport crystal.", npc, creature)
					end
				else
					npcHandler:say("We've already talked about that.", npc, creature)
				end
			end
		end
	elseif(MsgContains(message, "lash")) then
		if npcHandler:getTopic(playerId) == 3 then
			if player:getStorageValue(Storage.BigfootBurden.Rank) < 1440 then
				npcHandler:say("It seems you did not even set one big foot into the warzone, I am sorry.")
			else
				if player:getStorageValue(Storage.BigfootBurden.Warzone3Access) < 1 then
					if player:getStorageValue(Storage.BigfootBurden.WarzoneStatus) >= 3 then
						if player:removeItem(16206, 1) then
							player:setStorageValue(Storage.BigfootBurden.Warzone3Access, 1)
							npcHandler:say("As a war hero you are allowed to use the warzone teleporter three for free!", npc, creature)
							npcHandler:setTopic(playerId, 0)
						else
							npcHandler:say("I can't let you enter the warzone teleporter two for free, unless you handle me an Abyssador's lash. But can still always use a red teleport crystal.", npc, creature)
						end
					else
						npcHandler:say("You need to defeat the first warzone boss to be able to get free access to the second warzone.", npc, creature)
					end
				else
					npcHandler:say("We've already talked about that.", npc, creature)
				end
			end
		end
	elseif(MsgContains(message, "hat")) then
		if npcHandler:getTopic(playerId) == 3 then
			if player:getStorageValue(Storage.BigfootBurden.Rank) < 1440 then
				npcHandler:say("It seems you did not even set one big foot into the warzone, I am sorry.")
			else
				if player:getStorageValue(Storage.BigfootBurden.Warzone2Access) < 1 then
					if player:getStorageValue(Storage.BigfootBurden.WarzoneStatus) >= 2 then
						if player:removeItem(16205, 1) then
							player:setStorageValue(Storage.BigfootBurden.Warzone2Access, 1)
							npcHandler:say("As a war hero you are allowed to use the warzone teleporter second for free!", npc, creature)
							npcHandler:setTopic(playerId, 0)
						else
							npcHandler:say("I can't let you enter the warzone teleporter three for free, unless you handle me a Gnomevil's hat. But can still always use a red teleport crystal.", npc, creature)
						end
					else
						npcHandler:say("You need to defeat the second warzone boss to be able to get free access to the third warzone.", npc, creature)
					end
				else
					npcHandler:say("We've already talked about that.", npc, creature)
				end
			end
		end
	elseif(MsgContains(message, "mission")) then
		if npcHandler:getTopic(playerId) == 1 then
			if player:getStorageValue(Storage.BigfootBurden.Rank) >= 1440 then
				if player:getStorageValue(Storage.BigfootBurden.WarzoneStatus) < 1 then
					npcHandler:say("Fine, I grant you the permission to enter the warzones. Be warned though, this will be not a picnic. Better bring some friends with you. Bringing a lot of them sounds like a good idea.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.WarzoneStatus, 1)
				else
					npcHandler:say("You have already accepted this mission.", npc, creature)
				end
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Sorry, you have not yet earned enough renown that we would risk your life in such a dangerous mission.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Hello |PLAYERNAME|. You are probably eager to enter the {warzones}.')

local function onTradeRequest(npc, creature)
	if Player(creature):getStorageValue(Storage.BigfootBurden.BossKills) < 20 then
		npcHandler:say('Only if you have killed 20 of our major enemies in the warzones I am allowed to trade with you.', npc, creature)
		return false
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "arbalest", clientId = 5803, sell = 42000 },
	{ itemName = "arcane staff", clientId = 3341, sell = 42000 },
	{ itemName = "baby seal doll", clientId = 7183, sell = 20000 },
	{ itemName = "bejeweled ship's telescope", clientId = 9616, sell = 20000 },
	{ itemName = "blade of corruption", clientId = 11693, sell = 60000 },
	{ itemName = "bloody edge", clientId = 7416, sell = 30000 },
	{ itemName = "blue legs", clientId = 645, sell = 15000 },
	{ itemName = "blue rose", clientId = 3659, sell = 250 },
	{ itemName = "bright sword", clientId = 3295, sell = 6000 },
	{ itemName = "ceremonial ankh", clientId = 6561, sell = 20000 },
	{ itemName = "claw of 'the noxious spawn'", clientId = 9392, sell = 15000 },
	{ itemName = "crystal wand", clientId = 3068, sell = 10000 },
	{ itemName = "demon helmet", clientId = 3387, sell = 40000 },
	{ itemName = "dragon robe", clientId = 8039, sell = 50000 },
	{ itemName = "dwarven axe", clientId = 3323, sell = 1500 },
	{ itemName = "dwarven legs", clientId = 3398, sell = 40000 },
	{ itemName = "egg of the many", clientId = 9606, sell = 15000 },
	{ itemName = "executioner", clientId = 7453, sell = 55000 },
	{ itemName = "frozen starlight", clientId = 3249, sell = 20000 },
	{ itemName = "golden amulet", clientId = 3013, sell = 2000 },
	{ itemName = "golden fafnar trophy", clientId = 9626, sell = 10000 },
	{ itemName = "golden sickle", clientId = 3306, sell = 1000 },
	{ itemName = "greenwood coat", clientId = 8041, sell = 50000 },
	{ itemName = "marlin trophy", clientId = 902, sell = 5000 },
	{ itemName = "modified crossbow", clientId = 8021, sell = 10000 },
	{ itemName = "mucus plug", clientId = 16102, sell = 500 },
	{ itemName = "mushroom pie", clientId = 16103, buy = 150 },
	{ itemName = "orichalcum pearl", clientId = 5021, sell = 40 },
	{ itemName = "ornamented shield", clientId = 3424, sell = 1500 },
	{ itemName = "panda teddy", clientId = 5080, sell = 30000 },
	{ itemName = "pet pig", clientId = 16165, sell = 1500 },
	{ itemName = "purple tome", clientId = 2848, sell = 2000 },
	{ itemName = "red tome", clientId = 2852, sell = 2000 },
	{ itemName = "runed sword", clientId = 7417, sell = 45000 },
	{ itemName = "sea serpent trophy", clientId = 9613, sell = 10000 },
	{ itemName = "silkweaver bow", clientId = 8029, sell = 12000 },
	{ itemName = "silver fafnar trophy", clientId = 9627, sell = 1000 },
	{ itemName = "silver rune emblem explosion", clientId = 11607, sell = 5000 },
	{ itemName = "silver rune emblem heavy magic missile", clientId = 11605, sell = 5000 },
	{ itemName = "silver rune emblem sudden death", clientId = 11609, sell = 5000 },
	{ itemName = "silver rune emblem ultimate healing", clientId = 11603, sell = 5000 },
	{ itemName = "souleater trophy", clientId = 11679, sell = 7500 },
	{ itemName = "star amulet", clientId = 3014, sell = 500 },
	{ itemName = "statue of abyssador", clientId = 16232, sell = 4000 },
	{ itemName = "statue of deathstrike", clientId = 16236, sell = 3000 },
	{ itemName = "statue of devovorga", clientId = 4065, sell = 1500 },
	{ itemName = "statue of gnomevil", clientId = 16240, sell = 2000 },
	{ itemName = "stuffed dragon", clientId = 5791, sell = 6000 },
	{ itemName = "the avenger", clientId = 6527, sell = 42000 },
	{ itemName = "the ironworker", clientId = 8025, sell = 50000 },
	{ itemName = "trophy of jaul", clientId = 14006, sell = 4000 },
	{ itemName = "trophy of obujos", clientId = 14002, sell = 3000 },
	{ itemName = "trophy of tanjis", clientId = 14004, sell = 2000 },
	{ itemName = "unholy book", clientId = 6103, sell = 30000 },
	{ itemName = "windborn colossus armor", clientId = 8055, sell = 50000 }
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
