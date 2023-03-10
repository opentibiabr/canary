local internalNpcName = "Testserver Assistant"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {
	amountMoney = 100, --1kk
	amountLevel = 100
}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 140,
	lookHead = 60,
	lookBody = 24,
	lookLegs = 38,
	lookFeet = 0,
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

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'money') or MsgContains(message, "gold") then
		npcHandler:say('There you have', npc, creature)
		player:addItem(3043, npcConfig.amountMoney)
	end

	if MsgContains(message, "exp") or MsgContains(message, "experience") then
		if player:getLevel() > 1000 then
			npcHandler:say('You can not take it anymore', npc, creature)
		else
			npcHandler:say('Here you are.', npc, creature)
			local level = npcConfig.amountLevel
			local experience = ((50 * level * level * level) - (150 * level * level) + (400 * level)) / 3
			player:addExperience(experience - player:getExperience())
		end
	end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Hey |PLAYERNAME|. I'm Testserver Assistant and I can give {money} and {experience} which will be useful for testing on "
	.. configManager.getString(configKeys.SERVER_NAME) .. " server.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
