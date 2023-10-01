local internalNpcName = "Dedoras"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 146,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 78,
	lookFeet = 77,
	lookAddons = 2
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

	if player:getStorageValue(Storage.Kilmaresh.First.Access) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		npcHandler:setTopic(playerId, 1)
	elseif (player:getStorageValue(Storage.Kilmaresh.First.JamesfrancisTask) >= 0 and player:getStorageValue(Storage.Kilmaresh.First.JamesfrancisTask) <= 50)
	and player:getStorageValue(Storage.Kilmaresh.First.Mission) < 3 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		npcHandler:setTopic(playerId, 15)
	elseif player:getStorageValue(Storage.Kilmaresh.First.Mission) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		player:setStorageValue(Storage.Kilmaresh.First.Mission, 5)
		npcHandler:setTopic(playerId, 20)
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	
	if MsgContains(message, "report") and player:getStorageValue(Storage.TheSecretLibrary.PinkTel) == 1 then
		npcHandler:say({"Talk to Captain Charles in Port Hope. He told me that he once ran ashore on a small island where he discovered a small ruin. The architecture was like nothing he had seen before."}, npc, creature)
		player:setStorageValue(Storage.TheSecretLibrary.PinkTel, 2)
		npcHandler:setTopic(playerId, 1)
		npcHandler:setTopic(playerId, 1)
	end
	
	if MsgContains(message, "check") and player:getStorageValue(Storage.TheSecretLibrary.HighDry) == 5 then
		npcHandler:say({"Marvellous! With this information combined we have all that's needed! ...",
			"So let me see. ...",
			"Hmm, interesting. And we shouldn't forget about the chant! Yes, excellent! ...",
			"So listen: To enter the veiled library, travel to the white raven monastery on the Isle of Kings and enter its main altar room. ...",
			"There, use an ordinary scythe on the right of the two monuments, while concentrating on this glyph here and chant the words: Chamek Athra Thull Zathroth ...",
			"Oh, and one other thing. For your efforts I want to reward you with one of my old outfits, back from my adventuring days. May it suit you well! ...",
		"Hurry now my friend. Time is of essence!"}, npc, creature)
		player:setStorageValue(Storage.TheSecretLibrary.HighDry, 6)
		npcHandler:setTopic(playerId, 1)
		npcHandler:setTopic(playerId, 1)
	end
	
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')
npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
