local internalNpcName = "Ubaid"
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

local function greetCallback(npc, creature, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not MsgContains(message, "djanni'hah") and player:getStorageValue(Storage.DjinnWar.Faction.EfreetDoor) ~= 1 then
		npcHandler:say('Shove off, little one! Humans are not welcome here, |PLAYERNAME|!', npc, creature)
		return false
	end

	if player:getStorageValue(Storage.DjinnWar.Faction.Greeting) == -1 then
		npcHandler:say({
			'Hahahaha! ...',
			'|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!'
		}, npc, creature)
		return false
	end

	if player:getStorageValue(Storage.DjinnWar.Faction.EfreetDoor) ~= 1 then
		npcHandler:setMessage(MESSAGE_GREET, 'What? You know the word, |PLAYERNAME|? All right then - I won\'t kill you. At least, not now.  What brings you {here}?')
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Still alive, |PLAYERNAME|? What brings you {here}?')
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end


	-- To Appease the Mighty Quest
	if MsgContains(message, "mission") and player:getStorageValue(Storage.TibiaTales.ToAppeaseTheMightyQuest) == 2 then
			npcHandler:say({
				'You have the smell of the Marid on you. Tell me who sent you?'}, npc, creature)
			npcHandler:setTopic(playerId, 9)
			elseif MsgContains(message, "kazzan") and npcHandler:getTopic(playerId) == 9 then
			npcHandler:say({
				'And he is sending a worm like you to us!?! The mighty Efreet!! Tell him that we won\'t be part in his \'great\' plans and now LEAVE!! ...',
				'...or do you want to join us and fight those stinking Marid who claim themselves to be noble and righteous?!? Just let me know.'}, npc, creature)
			player:setStorageValue(Storage.TibiaTales.ToAppeaseTheMightyQuest, player:getStorageValue(Storage.TibiaTales.ToAppeaseTheMightyQuest) + 1)
	end

	if MsgContains(message, 'passage') then
		if player:getStorageValue(Storage.DjinnWar.Faction.EfreetDoor) ~= 1 then
			npcHandler:say({
				'Only the mighty Efreet, the true djinn of Tibia, may enter Mal\'ouquah! ...',
				'All Marid and little worms like yourself should leave now or something bad may happen. Am I right?'
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say('You already pledged loyalty to king Malor!', npc, creature)
		end

	elseif MsgContains(message, 'here') then
			npcHandler:say({
				'Only the mighty Efreet, the true djinn of Tibia, may enter Mal\'ouquah! ...',
				'All Marid and little worms like yourself should leave now or something bad may happen. Am I right?'
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)

	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, 'yes') then
			npcHandler:say('Of course. Then don\'t waste my time and shove off.', npc, creature)
			npcHandler:setTopic(playerId, 0)

		elseif MsgContains(message, 'no') then
			if player:getStorageValue(Storage.DjinnWar.Faction.MaridDoor) == 1 then
				npcHandler:say('Who do you think you are? A Marid? Shove off you worm!', npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say({
					'Of cour... Huh!? No!? I can\'t believe it! ...',
					'You... you got some nerves... Hmm. ...',
					'Maybe we have some use for someone like you. Would you be interested in working for us. Helping to fight the Marid?'
				}, npc, creature)
				npcHandler:setTopic(playerId, 2)
			end
		end

	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, 'yes') then
			npcHandler:say('So you pledge loyalty to king Malor and you are willing to never ever set foot on Marid\'s territory, unless you want to kill them? Yes?', npc, creature)
			npcHandler:setTopic(playerId, 3)

		elseif MsgContains(message, 'no') then
			npcHandler:say('Of course. Then don\'t waste my time and shove off.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end

	elseif npcHandler:getTopic(playerId) == 3 then
		if MsgContains(message, 'yes') then
			npcHandler:say({
				'Well then - welcome to Mal\'ouquah. ...',
				'Go now to general Baa\'leal and don\'t forget to greet him correctly! ...',
				'And don\'t touch anything!'
			}, npc, creature)
			player:setStorageValue(Storage.DjinnWar.Faction.EfreetDoor, 1)
			player:setStorageValue(Storage.DjinnWar.Faction.Greeting, 0)

		elseif MsgContains(message, 'no') then
			npcHandler:say('Of course. Then don\'t waste my time and shove off.', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

-- Greeting
keywordHandler:addGreetKeyword({"djanni'hah"}, {npcHandler = npcHandler, text = "Shove off, little one! Humans are not welcome here, |PLAYERNAME|"})

npcHandler:setMessage(MESSAGE_FAREWELL, 'Farewell human!')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Farewell human!')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
