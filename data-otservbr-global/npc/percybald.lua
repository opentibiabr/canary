local internalNpcName = "Percybald"
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
	lookHead = 3,
	lookBody = 21,
	lookLegs = 21,
	lookFeet = 38,
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

	if MsgContains(message, 'disguise') then
		if player:getStorageValue(Storage.ThievesGuild.TheatreScript) < 0 then
			npcHandler:say({
				'Hmpf. Why should I waste my time to help some amateur? I\'m afraid I can only offer my assistance to actors that are as great as I am. ...',
				'Though, your futile attempt to prove your worthiness could be amusing. Grab a copy of a script from the prop room at the theatre cellar. Then talk to me again about your test!'
			}, npc, creature)
			player:setStorageValue(Storage.ThievesGuild.TheatreScript, 0)
		end
	elseif MsgContains(message, 'test') then
		if player:getStorageValue(Storage.ThievesGuild.Mission04) == 5 then
			npcHandler:say('I hope you learnt your role! I\'ll tell you a line from the script and you\'ll have to answer with the corresponding line! Ready?', npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say('How dare you? Are you mad? I hold the princess hostage and you drop your weapons. You\'re all lost!', npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say('Too late puny knight. You can\'t stop my master plan anymore!', npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say('What\'s this? Behind the doctor?', npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say('Grrr!', npc, creature)
			npcHandler:setTopic(playerId, 8)
		elseif npcHandler:getTopic(playerId) == 9 then
			npcHandler:say('You\'re such a monster!', npc, creature)
			npcHandler:setTopic(playerId, 10)
		elseif npcHandler:getTopic(playerId) == 11 then
			npcHandler:say('Ah well, I think you passed the test! Here is your disguise kit! Now get lost, fate awaits me!', npc, creature)
			player:setStorageValue(Storage.ThievesGuild.Mission04, 6)
			player:addItem(7865, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, 'I don\'t think so, dear doctor!') then
			npcHandler:say('Ok, ok. You\'ve got this one right! Ready for the next one?', npc, creature)
			npcHandler:setTopic(playerId, 3)
		else
			npcHandler:say('No no no! That is not correct!', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 4 then
		if MsgContains(message, 'Watch out! It\'s a trap!') then
			npcHandler:say('Ok, ok. You\'ve got this one right! Ready for the next one?', npc, creature)
			npcHandler:setTopic(playerId, 5)
		else
			npcHandler:say('No no no! That is not correct!', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 6 then
		if MsgContains(message, 'Look! It\'s Lucky, the wonder dog!') then
			npcHandler:say('Ok, ok. You\'ve got this one right! Ready for the next one?', npc, creature)
			npcHandler:setTopic(playerId, 7)
		else
			npcHandler:say('No no no! That is not correct!', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 8 then
		if MsgContains(message, 'Ahhhhhh!') then
			npcHandler:say('Ok, ok. You\'ve got this one right! Ready for the next one?', npc, creature)
			npcHandler:setTopic(playerId, 9)
		else
			npcHandler:say('No no no! That is not correct!', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 10 then
		if MsgContains(message, 'Hahaha! Now drop your weapons or else...') then
			npcHandler:say('Ok, ok. You\'ve got this one right! Ready for the next one?', npc, creature)
			npcHandler:setTopic(playerId, 11)
		else
			npcHandler:say('No no no! That is not correct!', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted |PLAYERNAME|!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
