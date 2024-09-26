local internalNpcName = "Cambio Items por Old Cape"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 160,
	lookHead = 96,
	lookBody = 60,
	lookLegs = 97,
	lookFeet = 116,
}

npcConfig.flags = {
	floorchange = false,
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

	if MsgContains(message, "old cape") then
		npcHandler:say("You bringing me exquisite silk, old iron, strong sinew, magic crystal, exquisite wood, spectral cloth, mystic root and flexible dragon scale?", npc, creature)
	elseif MsgContains(message, "yes") then
		if player:getItemCount(11545) >= 1 and player:getItemCount(11548) >= 1 and player:getItemCount(11546) >= 1 and player:getItemCount(11552) >= 1 and player:getItemCount(11550) >= 1 and player:getItemCount(11547) >= 1 and player:getItemCount(11549) >= 1 and player:getItemCount(11551) >= 1 then
			if player:removeItem(11545, 1) and player:removeItem(11548, 1) and player:removeItem(11546, 1) and player:removeItem(11552, 1) and player:removeItem(11550, 1) and player:removeItem(11547, 1) and player:removeItem(11549, 1) and player:removeItem(11551, 1) then
				npcHandler:say("Here you have it.", npc, creature)
				player:addItem(11701, 1)
			end
		else
			npcHandler:say("You don't have these items.", npc, creature)
		end
	end
	end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

	
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

npcType:register(npcConfig)