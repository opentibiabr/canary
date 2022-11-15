local internalNpcName = "Haroun"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 80
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

	if isInArray({"enchanted chicken wing", "boots of haste"}, message) then
		npcHandler:say('Do you want to trade Boots of haste for Enchanted Chicken Wing?', npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif isInArray({"warrior sweat", "warrior helmet"}, message) then
		npcHandler:say('Do you want to trade 4 Warrior Helmet for Warrior Sweat?', npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif isInArray({"fighting spirit", "royal helmet"}, message) then
		npcHandler:say('Do you want to trade 2 Royal Helmet for Fighting Spirit', npc, creature)
		npcHandler:setTopic(playerId, 3)
	elseif isInArray({"magic sulphur", "fire sword"}, message) then
		npcHandler:say('Do you want to trade 3 Fire Sword for Magic Sulphur', npc, creature)
		npcHandler:setTopic(playerId, 4)
	elseif isInArray({"job", "items"}, message) then
		npcHandler:say('I trade Enchanted Chicken Wing for Boots of Haste, Warrior Sweat for 4 Warrior Helmets, Fighting Spirit for 2 Royal Helmet Magic Sulphur for 3 Fire Swords', npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message,'yes') and npcHandler:getTopic(playerId) <= 4 and npcHandler:getTopic(playerId) >= 1 then
		local trade = {
				{ NeedItem = 3079, Ncount = 1, GiveItem = 5891, Gcount = 1}, -- Enchanted Chicken Wing
				{ NeedItem = 3369, Ncount = 4, GiveItem = 5885, Gcount = 1}, -- Flask of Warrior's Sweat
				{ NeedItem = 3392, Ncount = 2, GiveItem = 5884, Gcount = 1}, -- Spirit Container
				{ NeedItem = 3280, Ncount = 3, GiveItem = 5904, Gcount = 1}  -- Magic Sulphur
		}
		if player:getItemCount(trade[npcHandler:getTopic(playerId)].NeedItem) >= trade[npcHandler:getTopic(playerId)].Ncount then
			player:removeItem(trade[npcHandler:getTopic(playerId)].NeedItem, trade[npcHandler:getTopic(playerId)].Ncount)
			player:addItem(trade[npcHandler:getTopic(playerId)].GiveItem, trade[npcHandler:getTopic(playerId)].Gcount)
			return npcHandler:say('Here you are.', npc, creature)
		else
			npcHandler:say('Sorry but you don\'t have the item.', npc, creature)
		end
	elseif MsgContains(message,'no') and (npcHandler:getTopic(playerId) >= 1 and npcHandler:getTopic(playerId) <= 5) then
		npcHandler:say('Ok then.', npc, creature)
		npcHandler:setTopic(playerId, 0)
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc(creature)
	end
	return true
end

local function onTradeRequest(npc, creature)
	local player = Player(creature)

	if player:getStorageValue(Storage.DjinnWar.MaridFaction.Mission03) ~= 3 then
		npcHandler:say('I\'m sorry, human. But you need Gabel\'s permission to trade with me.', npc, creature)
		return false
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, human |PLAYERNAME|. How can a humble djinn be of service?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell! May the serene light of the enlightened one rest shine on your travels.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell, human.")
npcHandler:setMessage(MESSAGE_SENDTRADE, 'At your service, just browse through my wares.')

npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "axe ring", clientId = 3092, buy = 500, sell = 100 },
	{ itemName = "bronze amulet", clientId = 3056, buy = 100, sell = 50, count = 200 },
	{ itemName = "club ring", clientId = 3093, buy = 500, sell = 100 },
	{ itemName = "elven amulet", clientId = 3082, buy = 500, sell = 100, count = 50 },
	{ itemName = "garlic necklace", clientId = 3083, buy = 100, sell = 50 },
	{ itemName = "life crystal", clientId = 4840, sell = 50 },
	{ itemName = "magic light wand", clientId = 3046, buy = 120, sell = 35 },
	{ itemName = "mind stone", clientId = 3062, sell = 100 },
	{ itemName = "orb", clientId = 3060, sell = 750 },
	{ itemName = "power ring", clientId = 3050, buy = 100, sell = 50 },
	{ itemName = "stealth ring", clientId = 3049, buy = 5000, sell = 200 },
	{ itemName = "stone skin amulet", clientId = 3081, buy = 5000, sell = 500, count = 5 },
	{ itemName = "sword ring", clientId = 3091, buy = 500, sell = 100 },
	{ itemName = "wand of cosmic energy", clientId = 3073, sell = 2000 },
	{ itemName = "wand of cosmic energy", clientId = 3073, sell = 2000 },
	{ itemName = "wand of decay", clientId = 3072, sell = 1000 },
	{ itemName = "wand of defiance", clientId = 16096, sell = 6500 },
	{ itemName = "wand of draconia", clientId = 8093, sell = 1500 },
	{ itemName = "wand of dragonbreath", clientId = 3075, sell = 200 },
	{ itemName = "wand of everblazing", clientId = 16115, sell = 6000 },
	{ itemName = "wand of inferno", clientId = 3071, sell = 3000 },
	{ itemName = "wand of starstorm", clientId = 8092, sell = 3600 },
	{ itemName = "wand of voodoo", clientId = 8094, sell = 4400 },
	{ itemName = "wand of vortex", clientId = 3074, sell = 100 }
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
