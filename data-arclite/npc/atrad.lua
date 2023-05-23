local internalNpcName = "Atrad"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 152,
	lookHead = 77,
	lookBody = 113,
	lookLegs = 132,
	lookFeet = 94,
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

local function greetCallback(npc, creature)
	local player = Player(creature)
	local fire = player:getCondition(CONDITION_FIRE)
	
	if fire and (player:hasOutfit(156) or player:hasOutfit(152)) then
		return true
	end
	return false
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if(MsgContains(message, "addon") or MsgContains(message, "outfit")) then
		if(getPlayerStorageValue(creature, Storage.Atrad) < 1) then
			npcHandler:say("You managed to deceive Erayo? Impressive. Well, I guess, since you have come that far, I might as well give you a task too, eh?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif(MsgContains(message, "nose ring") or MsgContains(message, "ring")) then
		if(getPlayerStorageValue(creature, Storage.Atrad) == 1) then
			if(getPlayerItemCount(creature, 5804) >= 1) and getPlayerItemCount(creature, 5930) >= 1 then
				npcHandler:say("I see you brought my stuff. Good. I'll keep my promise: Here's katana in return.", npc, creature)
				doPlayerRemoveItem(creature, 5804, 1)
				doPlayerRemoveItem(creature, 5930, 1)
				doPlayerAddOutfit(creature, getPlayerSex(creature) == 0 and 156 or 152, 2)
				setPlayerStorageValue(creature, Storage.Atrad, 2) -- exaust
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have it...", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif(MsgContains(message, "yes")) then
		if(npcHandler:getTopic(playerId) == 2) then
			npcHandler:say("Okay, listen up. I don't have a list of stupid objects, I just want two things. A behemoth claw and a nose ring. Got that?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif(npcHandler:getTopic(playerId) == 3) then
			npcHandler:say("Good. Come back then you have BOTH. Should be clear where to get a behemoth claw from. There's a horned fox who wears a nose ring. Good luck.", npc, creature)
			setPlayerStorageValue(creature, Storage.Atrad, 1)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "assassin star", clientId = 7368, buy = 100 }
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
