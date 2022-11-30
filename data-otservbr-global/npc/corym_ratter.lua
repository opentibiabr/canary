local internalNpcName = "Corym Ratter"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 533,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 115,
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

local HiddenThreats = Storage.Quest.U11_50.HiddenThreats
local function greetCallback(npc, creature, message)
	local player = Player(creature)

	if player:getStorageValue(HiddenThreats.QuestLine) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, {
			'Welcome stranger! You might be surprised that I don\'t attack you immediately. The point is, that I think you could be useful to me. What you see in front of you is a great mine of the corym! ...',
			'We dig up all what mother earth delivers to us, valuable natural resources. But the yield is getting worse and here I need your {help}.'
		})
	else
		npcHandler:setMessage(MESSAGE_GREET, 'We dig up all what mother earth delivers to us, valuable natural resources.')
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if(MsgContains(message, "help")) then
			npcHandler:say("Recently the amount of delivered ores is decreasing. Could you find out the reason, why the situation has become worse?", npc, creature)
			npcHandler:setTopic(playerId, 1)
	elseif(MsgContains(message, "yes")) then
		if(npcHandler:getTopic(playerId) == 1) then
			player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
			player:setStorageValue(HiddenThreats.QuestLine, 1)
			player:setStorageValue(HiddenThreats.RatterDoor, 1)
			npcHandler:say("Nice! I have opened the mine for you. But take care of you! The monsters of depth won't spare you.", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	end
	return true
end

-- Greeting message
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye, |PLAYERNAME|.')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
