local internalNpcName = "Eustacio"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 471,
	lookHead = 97,
	lookBody = 110,
	lookLegs = 71,
	lookFeet = 116,
	lookAddons = 2,
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

local function greetCallback(npc, creature)
	local player = Player(creature)

	if player:getStorageValue(Storage.Quest.U12_60.APiratesTail.RascacoonShortcut) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, {
			"Hello my friend. What a delight to see you, even on a {busy} day. I see you already talked to my agent. I'm willing to lend you my boat if you want to take a {shortcut}. ...",
		})
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hello my friend. What a delight to see you, even on a busy day. You can check your status or ask me about the location of ongoing raids.")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end
	if MsgContains(message, "name") then
		npcHandler:say("I am Eustacio. At your service.", npc, creature)
	elseif MsgContains(message, "time") then
		npcHandler:say("It's just the time to make a fortune.", npc, creature)
	elseif MsgContains(message, "busy") or MsgContains(message, "job") then
		npcHandler:say(" I am an aspiring businessman, who thrives to climb the ladder of success in the Venorean society.", npc, creature)
	elseif MsgContains(message, "shortcut") then
		if player:getStorageValue(Storage.Quest.U12_60.APiratesTail.RascacoonShortcut) == 1 then
			npcHandler:say({
				"You are trustworthy enough to take my boat. My agent made sure it takes me to their island. Do you want to take it?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			creature:teleportTo(Position(33774, 31347, 7))
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
