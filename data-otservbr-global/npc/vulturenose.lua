local internalNpcName = "Vulturenose"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 96
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

	if MsgContains(message, 'enter') then
		if player:getStorageValue(Storage.TheShatteredIsles.RaysMission3) == 1
		and player:getStorageValue(Storage.TheShatteredIsles.YavernDoor) < 0 then
			local headItem = player:getSlotItem(CONST_SLOT_HEAD)
			local armorItem = player:getSlotItem(CONST_SLOT_ARMOR)
			local legsItem = player:getSlotItem(CONST_SLOT_LEGS)
			local feetItem = player:getSlotItem(CONST_SLOT_FEET)
			if headItem and headItem.itemid == 6096 and armorItem and armorItem.itemid == 6095
			and legsItem and legsItem.itemid == 5918 and feetItem and feetItem.itemid == 5461 then
				npcHandler:say('Hey, I rarely see a dashing pirate like you! Get in, matey!', npc, creature)
				player:setStorageValue(Storage.TheShatteredIsles.YavernDoor, 1)
			else
				npcHandler:say("YOU WILL NOT PASS! Erm ... \
				I mean you don't look like a true pirate to me. You won't get in.", npc, creature)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
