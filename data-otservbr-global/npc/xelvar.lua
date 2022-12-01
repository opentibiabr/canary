local internalNpcName = "Xelvar"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 70
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

	if not player then
		return false
	end

	if MsgContains(message, "adventures") or MsgContains(message, "join") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) < 1 then
			npcHandler:say({
				"I am glad to hear that. In the spirit of our own foreign legion we suggested the gnomes might hire heroes like you to build some kind of troop. They gave me that strange crystal to allow people passage to their realm. ...",
				"I hereby grant you permission to use the basic gnomish teleporters. I also give you four gnomish teleport crystals. One will be used up each time you use the teleporter. ...",
				"You can stock up your supply by buying more from me. Just ask me for a {trade}. Gnomette in the teleport chamber of the gnome outpost will sell them too. ...",
				"The teleporter here will transport you to one of the bigger gnomish outposts. ...",
				"There you will meet Gnomerik, the recruitment officer of the Gnomes. If you are lost, Gnomette in the teleport chamber might be able to help you with directions. ...",
				"Good luck to you and don't embarrass your race down there! Keep in mind that you are a representative of the big people."
			}, npc, creature)

			player:setStorageValue(Storage.BigfootBurden.QuestLine, 1)
			player:addItem(16167, 4)

			--npcHandler:say("Right now I am sort of {recruiting} people.", npc, creature)
			npcHandler:setTopic(playerId, 1)
			else npcHandler:say("You already talked with me.", npc, creature)
		end
	elseif MsgContains(message, "recruiting") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Ok, so listen. Your help is needed. That is if you're the hero type. Our ... {partners} need some help in urgent matters.", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "partners") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("I guess the time of secrecy is over now. Well, we have an old alliance with another underground dwelling race, the {gnomes}.", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "gnomes") then
		if npcHandler:getTopic(playerId) == 3 then
			npcHandler:say({
				"The gnomes preferred to keep our alliance and their whole {existence} a secret. They are a bit distrustful of others. ...",
				"They are quite self-sufficient and the fact that they are actually accepting some help is more than alarming. The gnomes are in real trouble and I am kind of an ambassador to find some people willing to {help}."
			}, npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "help") then
		if npcHandler:getTopic(playerId) == 4 then
			npcHandler:say({
				"The gnomes are locked in a war with an enemy that thins out their resources but foremost their manpower. We have suggested that people like you could be just the specialists they are looking for. ...",
				"If you are interested to {join} the gnomish cause I can arrange a meeting with their recruiter."
			}, npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "join") then
		if npcHandler:getTopic(playerId) == 5 then
			npcHandler:say({
				"I am glad to hear that. In the spirit of our own foreign legion we suggested the gnomes might hire heroes like you to build some kind of troop. They gave me that strange crystal to allow people passage to their realm. ...",
				"I hereby grant you permission to use the basic gnomish teleporters. I also give you four gnomish teleport crystals. One will be used up each time you use the teleporter. ...",
				"You can stock up your supply by buying more from me. Just ask me for a {trade}. Gnomette in the teleport chamber of the gnome outpost will sell them too. ...",
				"The teleporter here will transport you to one of the bigger gnomish outposts. ...",
				"There you will meet Gnomerik, the recruitment officer of the Gnomes. If you are lost, Gnomette in the teleport chamber might be able to help you with directions. ...",
				"Good luck to you and don't embarrass your race down there! Keep in mind that you are a representative of the big people."
			}, npc, creature)

			player:setStorageValue(Storage.BigfootBurden.QuestLine, 1)
			player:addItem(16167, 4)
			npcHandler:setTopic(playerId, 0)
		end

	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "teleport crystal", clientId = 16167, buy = 150 }
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
