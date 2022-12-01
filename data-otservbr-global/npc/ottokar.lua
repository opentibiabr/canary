local internalNpcName = "Ottokar"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 153,
	lookHead = 132,
	lookBody = 121,
	lookLegs = 120,
	lookFeet = 114,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'belongings of deceasead') or MsgContains(message, 'medicine') then
		if player:getItemCount(12517) > 0 then
			npcHandler:say('Did you bring me the medicine pouch?', npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say('I need a {medicine pouch}, to give you the {belongings of deceased}. Come back when you have them.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'yes') and npcHandler:getTopic(playerId) == 1 then
		if player:removeItem(12517, 1) then
			player:addItem(12413, 1)
			player:addAchievementProgress('Doctor! Doctor!', 100)
			npcHandler:say('Here you are', npc, creature)
		else
			npcHandler:say('You do not have the required items.', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
