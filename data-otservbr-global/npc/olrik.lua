local internalNpcName = "Olrik"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 115,
	lookBody = 79,
	lookLegs = 117,
	lookFeet = 76,
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

	if MsgContains(message, "measurements") then
		if player:getStorageValue(Storage.Postman.Mission07) >= 1 and	player:getStorageValue(Storage.Postman.MeasurementsOlrik) ~= 1 then
			npcHandler:say("My measurements? Listen, lets make that a bit more exciting ... No, no, not what you think! I mean let's gamble. I will roll a dice. If I roll a 6 you win and I'll tell you what you need to know, else I win and get 5 gold. Deal? ", npc, creature)
			npcHandler:setTopic(playerId, 1)
	else
			npcHandler:say("...", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if player:getMoney() + player:getBankBalance() >= 5 then
			player:removeMoneyBank(5)
			local number = math.random(6)
			if number ~= 6 then
				npcHandler:say("Ok, here we go ... " .. number .. "! You lose! Try again.", npc, creature)
			else
				npcHandler:say("Ok, here we go ... " .. number .. "! You have won! How lucky you are! So listen ...<tells you what you need to know> ", npc, creature)
				player:setStorageValue(Storage.Postman.Mission07, player:getStorageValue(Storage.Postman.Mission07) + 1)
				player:setStorageValue(Storage.Postman.MeasurementsOlrik, 1)
				npcHandler:setTopic(playerId, 0)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Hello. How may I help you |PLAYERNAME|? Ask me for a {trade} if you want to buy something. I can also explain the {mail} system.")
npcHandler:setMessage(MESSAGE_FAREWELL, "It was a pleasure to help you, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Here. Don't forget that you need to buy a label too if you want to send a parcel. Always write the name of the {receiver} in the first line.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "label", clientId = 3507, buy = 1 },
	{ itemName = "letter", clientId = 3505, buy = 8 },
	{ itemName = "parcel", clientId = 3503, buy = 15 }
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
