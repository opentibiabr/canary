dofile(DATA_DIRECTORY .. "/npc/alesar_functions.lua")

local internalNpcName = "Alesar"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 80,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.shop = {
	{ itemName = "ancient shield", clientId = 3432, buy = 5000, sell = 900 },
	{ itemName = "black shield", clientId = 3429, sell = 800 },
	{ itemName = "bonebreaker", clientId = 7428, sell = 10000 },
	{ itemName = "dark armor", clientId = 3383, buy = 1500, sell = 400 },
	{ itemName = "dark helmet", clientId = 3384, buy = 1000, sell = 250 },
	{ itemName = "dragon hammer", clientId = 3322, sell = 2000 },
	{ itemName = "dreaded cleaver", clientId = 7419, sell = 15000 },
	{ itemName = "giant sword", clientId = 3281, sell = 17000 },
	{ itemName = "haunted blade", clientId = 7407, sell = 8000 },
	{ itemName = "ice rapier", clientId = 3284, buy = 5000 },
	{ itemName = "knight armor", clientId = 3370, sell = 5000 },
	{ itemName = "knight axe", clientId = 3318, sell = 2000 },
	{ itemName = "knight legs", clientId = 3371, sell = 5000 },
	{ itemName = "mystic turban", clientId = 3574, sell = 150 },
	{ itemName = "onyx flail", clientId = 7421, sell = 22000 },
	{ itemName = "ornamented axe", clientId = 7411, sell = 20000 },
	{ itemName = "poison dagger", clientId = 3299, sell = 50 },
	{ itemName = "scimitar", clientId = 3307, sell = 150 },
	{ itemName = "serpent sword", clientId = 3297, buy = 6000, sell = 900 },
	{ itemName = "skull staff", clientId = 3324, sell = 6000 },
	{ itemName = "strange helmet", clientId = 3373, sell = 500 },
	{ itemName = "titan axe", clientId = 7413, sell = 4000 },
	{ itemName = "tower shield", clientId = 3428, sell = 8000 },
	{ itemName = "vampire shield", clientId = 3434, sell = 15000 },
	{ itemName = "warrior helmet", clientId = 3369, sell = 5000 },
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

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

local function endConversationWithDelay(npcHandler, npc, creature)
	addEvent(function()
		npcHandler:unGreet(npc, creature)
	end, 1000)
end

local function greetCallback(npc, creature, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not MsgContains(message, "djanni'hah") then
		npcHandler:say("Shove off, little one! Humans are not welcome here, |PLAYERNAME|!", npc, creature)
		endConversationWithDelay(npcHandler, npc, creature)
		return false
	end

	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.MaridFaction.Start) == 1 then
		npcHandler:say({
			"Hahahaha! ...",
			"|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!",
		}, npc, creature)
		endConversationWithDelay(npcHandler, npc, creature)
		return false
	end

	npcHandler:say("What do you want from me, |PLAYERNAME|?", npc, creature)
	npcHandler:setInteraction(npc, creature)

	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local missionProgress = player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission02)
	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission01) == 3 then
			if missionProgress < 1 then
				npcHandler:say({
					"So Baa'leal thinks you are up to do a mission for us? ...",
					"I think he is getting old, entrusting human scum such as you are with an important mission like that. ...",
					"Personally, I don't understand why you haven't been slaughtered right at the gates. ...",
					"Anyway. Are you prepared to embark on a dangerous mission for us?",
				}, npc, creature)
				npcHandler:setTopic(playerId, 1)
			elseif isInArray({ 1, 2 }, missionProgress) then
				npcHandler:say("Did you find the tear of Daraman?", npc, creature)
				npcHandler:setTopic(playerId, 2)
			else
				npcHandler:say("Don't forget to talk to Malor concerning your next mission.", npc, creature)
			end
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			npcHandler:say({
				"All right then, human. Have you ever heard of the {'Tears of Daraman'}? ...",
				"They are precious gemstones made of some unknown blue mineral and possess enormous magical power. ...",
				"If you want to learn more about these gemstones don't forget to visit our library. ...",
				"Anyway, one of them is enough to create thousands of our mighty djinn blades. ...",
				"Unfortunately my last gemstone broke and therefore I'm not able to create new blades anymore. ...",
				"To my knowledge there is only one place where you can find these gemstones - I know for a fact that the Marid have at least one of them. ...",
				"Well... to cut a long story short, your mission is to sneak into Ashta'daramai and to steal it. ...",
				"Needless to say, the Marid won't be too eager to part with it. Try not to get killed until you have delivered the stone to me.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission02, 1)
			player:setStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.DoorToMaridTerritory, 1)
		elseif MsgContains(message, "no") then
			npcHandler:say("Then not.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "yes") then
			if player:getItemCount(3233) == 0 or missionProgress ~= 2 then
				npcHandler:say("As I expected. You haven't got the stone. Shall I explain your mission again?", npc, creature)
				npcHandler:setTopic(playerId, 1)
			else
				npcHandler:say({
					"So you have made it? You have really managed to steal a Tear of Daraman? ...",
					"Amazing how you humans are just impossible to get rid of. Incidentally, you have this character trait in common with many insects and with other vermin. ...",
					"Nevermind. I hate to say it, but it you have done us a favour, human. That gemstone will serve us well. ...",
					"Baa'leal, wants you to talk to Malor concerning some new mission. ...",
					"Looks like you have managed to extended your life expectancy - for just a bit longer.",
				}, npc, creature)
				player:removeItem(3233, 1)
				player:setStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission02, 3)
				npcHandler:setTopic(playerId, 0)
			end
		elseif MsgContains(message, "no") then
			npcHandler:say("As I expected. You haven't got the stone. Shall I explain your mission again?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	end

	return true
end

local function onTradeRequest(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission03) ~= 3 then
		npcHandler:say("I'm sorry, but you don't have Malor's permission to trade with me.", npc, creature)
		return false
	end

	return true
end

keywordHandler:addCustomGreetKeyword({ "djanni'hah" }, greetCallback, { npcHandler = npcHandler })

npcHandler:setMessage(MESSAGE_FAREWELL, "Finally.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Finally.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "At your service, just browse through my wares.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
