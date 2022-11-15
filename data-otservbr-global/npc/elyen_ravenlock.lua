local internalNpcName = "Elyen Ravenlock"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 58
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = '<hums a dark tune>' },
	{ text = '<chants> Re Ha, Omrah, Tan Ra...' },
	{ text = 'The rats... the rats in the walls...' }
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

	if(MsgContains(message, 'scroll') or MsgContains(message, 'mission')) and player:getStorageValue(Storage.GravediggerOfDrefia.Mission60) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission61) < 1 then
		npcHandler:say("Hello, brother. You come with a question to me, I believe?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, 'yes') and npcHandler:getTopic(playerId) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission60) == 1 then
		npcHandler:say("And what is it you want? Do you bring news from the undead, or do you seek a dark {artefact}?", npc, creature)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission45, 1)
		npcHandler:setTopic(playerId, 2)
	elseif(MsgContains(message, 'artefact') or MsgContains(message, 'yes')) and npcHandler:getTopic(playerId) == 2 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission60) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission61) < 1 then
		npcHandler:say({
			"The scroll piece there? The symbols look promising, but it is incomplete. ...",
			"It is of little use to us. But it seems to be of interest to you ...",
			"In exchange for the scroll piece, you must assist me with something. {Agreed}?"
		}, npc, creature)
		npcHandler:setTopic(playerId, 3)
	elseif(MsgContains(message, 'agreed') or MsgContains(message, 'yes')) and npcHandler:getTopic(playerId) == 3 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission60) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission61) < 1 then
		npcHandler:say({
			"I would have to sing to the Dark Shrines, but I cannot. ...",
			"I... cannot bear Urgith's breed. Everywhere, I hear them - scrabbling, squeaking ...",
			"Take this bone flute and play it in front of the five Dark Shrines so that they answer with song in return. You will find them in the Gardens of Night. ...",
			"If you have done that, you may have the scroll piece. Now go."
		}, npc, creature)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission61, 1)
		player:addItem(18932, 1)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, 'mission') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission66) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission67) < 1 then
		npcHandler:say("Hello, brother. You have finished the dance?", npc, creature)
		npcHandler:setTopic(playerId, 4)
	elseif(MsgContains(message, 'yes')) and npcHandler:getTopic(playerId) == 4 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission66) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission67) < 1 then
		npcHandler:say({
			"You have indeed. The shrines have sung back to you. Well done, brother. Not many men take such an interest in our art. ...",
			"I will take the flute back. Our bargain stands. You may take the scroll."
		}, npc, creature)
		player:removeItem(18932, 1)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission67, 1)
		npcHandler:setTopic(playerId, 0)
		else npcHandler:say({"Time is money, hurry."}, npc, creature)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "A shadow preceded you. You wish a {scroll} or a {mission}?")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
