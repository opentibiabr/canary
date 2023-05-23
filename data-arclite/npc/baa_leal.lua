local internalNpcName = "Baa'Leal"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 51
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

local condition = Condition(CONDITION_FIRE)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(150, 2000, -10)

local function greetCallback(npc, creature, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not player:getCondition(CONDITION_FIRE) and not MsgContains(message, "djanni'hah") then
		player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
		player:addCondition(condition)
		npcHandler:say('Take this!', npc, creature)
		return false
	end

	if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission01) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, 'You know the code human! Very well then... What do you want, |PLAYERNAME|?')
	else
		npcHandler:setMessage(MESSAGE_GREET, 'You are still alive, |PLAYERNAME|? Well, what do you want?')
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local missionProgress = player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission01)
	if MsgContains(message, 'mission') then
		if missionProgress < 1 then
			npcHandler:say({
				'Each mission and operation is a crucial step towards our victory! ...',
				'Now that we speak of it ...',
				'Since you are no djinn, there is something you could help us with. Are you interested, human?'
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)

		elseif isInArray({1, 2}, missionProgress) then
			npcHandler:say('Did you find the thief of our supplies?', npc, creature)
			npcHandler:setTopic(playerId, 2)
		else
			npcHandler:say('Did you already talk to Alesar? He has another mission for you!', npc, creature)
		end

	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, 'yes') then
			npcHandler:say({
				'Well ... All right. You may only be a human, but you do seem to have the right spirit. ...',
				'Listen! Since our base of operations is set in this isolated spot we depend on supplies from outside. These supplies are crucial for us to win the war. ...',
				'Unfortunately, it has happened that some of our supplies have disappeared on their way to this fortress. At first we thought it was the Marid, but intelligence reports suggest a different explanation. ...',
				'We now believe that a human was behind the theft! ...',
				'His identity is still unknown but we have been told that the thief fled to the human settlement called Carlin. I want you to find him and report back to me. Nobody messes with the Efreet and lives to tell the tale! ...',
				'Now go! Travel to the northern city Carlin! Keep your eyes open and look around for something that might give you a clue!'
			}, npc, creature)
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.Start, 1)
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission01, 1)

		elseif MsgContains(message, 'no') then
			npcHandler:say('After all, you\'re just a human.', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)

	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, 'yes') then
			npcHandler:say('Finally! What is his name then?', npc, creature)
			npcHandler:setTopic(playerId, 3)

		elseif MsgContains(message, 'no') then
			npcHandler:say('Then go to Carlin and search for him! Look for something that might give you a clue!', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end

	elseif npcHandler:getTopic(playerId) == 3 then
		if MsgContains(message, 'partos') then
			if missionProgress ~= 2 then
				npcHandler:say('Hmmm... I don\'t think so. Return to Thais and continue your search!', npc, creature)
			else
				npcHandler:say({
					'You found the thief! Excellent work, soldier! You are doing well - for a human, that is. Here - take this as a reward. ...',
					'Since you have proven to be a capable soldier, we have another mission for you. ...',
					'If you are interested go to Alesar and ask him about it.'
				}, npc, creature)
				player:addMoney(600)
				player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission01, 3)
			end

		else
			npcHandler:say('Hmmm... I don\'t think so. Return to Thais and continue your search!', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

-- Greeting message
keywordHandler:addGreetKeyword({"djanni'hah"}, {npcHandler = npcHandler, text = "What do you want from me, |PLAYERNAME|?"})

npcHandler:setMessage(MESSAGE_FAREWELL, 'Stand down, soldier!')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
