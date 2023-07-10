local internalNpcName = "Servant Sentry"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 396
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'Heed. Your. Will. We. Will.' },
	{ text = 'Intruder. Intrude. Must. Explain.' },
	{ text = 'Ssssttttoooopppp.' }
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

keywordHandler:addKeyword({'master'}, StdModule.say, {npcHandler = npcHandler, text = "Our. Master. Is. Gone. You. Can. Not. Visit. Him! We. Stand. {Sentry}!"})
keywordHandler:addKeyword({'sentry'}, StdModule.say, {npcHandler = npcHandler, text = "{Master}. Conducted. Experiments. Great. Problems. You. Must. Go!"})
keywordHandler:addKeyword({'slime'}, StdModule.say, {npcHandler = npcHandler, text = "{Slime}. Dangerous. We. Have. It. Under. Control. ... We. Will. Stand. {Sentry}."}, function(player) return player:getStorageValue(Storage.TheirMastersVoice.SlimeGobblerReceived) == 1 end)

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.TheirMastersVoice.SlimeGobblerReceived) < 1 then
		npcHandler:say("The. {Slime}. Has. Entered. Our. {Master}. Has. Left! We. Must. {Help}.", npc, creature)
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "help") then
			npcHandler:say("Defeat. {Slime}. We. Will. Why. Did. You. Kill. Us? Do. You. Want. To. Rectify. And. Help?", npc, creature)
			npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			player:setStorageValue(Storage.TheirMastersVoice.SlimeGobblerReceived, 1)
			player:addItem(12077, 1)
			npcHandler:say("Then. Take. This. Gobbler. Always. Hungry. Eats. Slime. Fungus. Go.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "The. Slime. Has. Entered. Our. Master. Has. Left! We. Must. Help.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Goodbye. Human. Being!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Goodbye. Human. Being!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
