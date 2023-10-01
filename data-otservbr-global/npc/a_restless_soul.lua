local internalNpcName = "A Restless Soul"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 48
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
	local playerId = player:getId()

	if player:getStorageValue(Storage.TheIceIslands.Questline) < 37 then
		npcHandler:setMessage(MESSAGE_GREET, "Uhhhh...")
		return false
	elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 37 then
		npcHandler:setMessage(MESSAGE_GREET, "Ahhhh! At last someone that can listen to my {story}!")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "story") then
		local player = Player(creature)
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 37 then
			npcHandler:say({
				"I was captured and tortured to death by the cultists here. They worship a being that they call Ghazbaran ...",
				"In his name they have claimed the mines and started to melt the ice to free an army of vile demons that have been frozen here for ages ...",
				"Their plan is to create a new demon army for their master to conquer the world. Hjaern and the other shamans must learn about it! Hurry before its too late."
			}, npc, creature)
			player:setStorageValue(Storage.TheIceIslands.Questline, 38)
			player:setStorageValue(Storage.TheIceIslands.Mission10, 2) -- Questlog The Ice Islands Quest, Formorgar Mines 2: Ghostwhisperer
			player:setStorageValue(Storage.TheIceIslands.Mission11, 1) -- Questlog The Ice Islands Quest, Formorgar Mines 3: The Secret
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
