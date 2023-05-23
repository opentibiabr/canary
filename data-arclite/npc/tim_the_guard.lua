local internalNpcName = "Tim, The Guard"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 0,
	lookBody = 19,
	lookLegs = 19,
	lookFeet = 19,
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
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "trouble") and player:getStorageValue(Storage.TheInquisition.TimGuard) < 1 and player:getStorageValue(Storage.TheInquisition.Mission01) ~= -1 then
		npcHandler:say("Ah, well. Just this morning my new toothbrush fell into the toilet.", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "authorities") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("What do you mean? Of course they will immediately send someone with extra long and thin arms to retrieve it! ", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "avoided") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Your humour might let end you up beaten in some dark alley, you know? No, I don't think someone could have prevented that accident! ", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "gods would allow") then
		if npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("It's not a drama!! I think there is just no god who's responsible for toothbrush safety, that's all ... ", npc, creature)
			npcHandler:setTopic(playerId, 0)
			if player:getStorageValue(Storage.TheInquisition.TimGuard) < 1 then
				player:setStorageValue(Storage.TheInquisition.TimGuard, 1)
				player:setStorageValue(Storage.TheInquisition.Mission01, player:getStorageValue(Storage.TheInquisition.Mission01) + 1) -- The Inquisition Questlog- "Mission 1: Interrogation"
				player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			end
		end
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "It's my duty to protect the city."})

npcHandler:setMessage(MESSAGE_GREET, "LONG LIVE THE KING!")
npcHandler:setMessage(MESSAGE_FAREWELL, "LONG LIVE THE KING!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "LONG LIVE THE KING!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
