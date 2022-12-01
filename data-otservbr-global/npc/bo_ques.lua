local internalNpcName = "Bo'Ques"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 80
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'Now, where was I...'}
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

	local missionProgress = player:getStorageValue(Storage.DjinnWar.MaridFaction.Mission01)
	if MsgContains(message, 'recipe') or MsgContains(message, 'mission') then
		if missionProgress < 1 then
			npcHandler:say({
				'My collection of recipes is almost complete. There are only but a few that are missing. ...',
				'Hmmm... now that we talk about it. There is something you could help me with. Are you interested?'
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say('I already told you about the recipes I am missing, now please try to find a cookbook of the dwarven kitchen.', npc, creature)
		end

	elseif MsgContains(message, 'cookbook') then
		if missionProgress == -1 then
			npcHandler:say({
				'I\'m preparing the food for all djinns in Ashta\'daramai. ...',
				'Therefore, I\'m what is commonly called a cook, although I do not like that word too much. It is vulgar. I prefer to call myself \'chef\'.'
			}, npc, creature)
		elseif missionProgress == 1 then
			npcHandler:say('Do you have the cookbook of the dwarven kitchen with you? Can I have it?', npc, creature)
			npcHandler:setTopic(playerId, 2)
		else
			npcHandler:say('Thanks again, for bringing me that book!', npc, creature)
		end

	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, 'yes') then
			npcHandler:say({
				'Fine! Even though I know so many recipes, I\'m looking for the description of some dwarven meals. ...',
				'So, if you could bring me a cookbook of the dwarven kitchen, I\'ll reward you well.'
			}, npc, creature)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Start, 1)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission01, 1)

		elseif MsgContains(message, 'no') then
			npcHandler:say('Well, too bad.', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)

	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, 'yes') then
			if not player:removeItem(3234, 1) then
				npcHandler:say('Too bad. I must have this book.', npc, creature)
				return true
			end

			npcHandler:say({
				'The book! You have it! Let me see! <browses the book> ...',
				'Dragon Egg Omelette, Dwarven beer sauce... it\'s all there. This is great! Here is your well-deserved reward. ...',
				'Incidentally, I have talked to Fa\'hradin about you during dinner. I think he might have some work for you. Why don\'t you talk to him about it?'
			}, npc, creature)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission01, 2)
			player:addItem(3029, 3)

		elseif MsgContains(message, 'no') then
			npcHandler:say('Too bad. I must have this book.', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

-- Greeting
keywordHandler:addGreetKeyword({"djanni'hah"}, {npcHandler = npcHandler, text = "Hey! A human! What are you doing in my kitchen, |PLAYERNAME|?"})

npcHandler:setMessage(MESSAGE_FAREWELL, 'Goodbye. I am sure you will come back for more. They all do.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Goodbye. I am sure you will come back for more. They all do.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
