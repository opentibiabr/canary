local internalNpcName = "Elvith"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 159,
	lookHead = 76,
	lookBody = 3,
	lookLegs = 0,
	lookFeet = 76
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
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I sell musical instruments of many kinds.'})
keywordHandler:addKeyword({'instruments'}, StdModule.say, {npcHandler = npcHandler, text = 'I sell lyres, lutes, drums, and simple fanfares.'})
keywordHandler:addKeyword({'music'}, StdModule.say, {npcHandler = npcHandler, text = 'Music is an attempt to condensate emotions in harmonies and save them for the times to come.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'Time has its own song. Close your eyes and listen to the symphony of the seasons.'})
keywordHandler:addKeyword({'song'}, StdModule.say, {npcHandler = npcHandler, text = 'Everything is a song. Life, death, history ... everything. To listen to the song of something is the first step to understand it.'})
keywordHandler:addKeyword({'melody'}, StdModule.say, {npcHandler = npcHandler, text = 'Everything is a song. Life, death, history ... everything. To listen to the song of something is the first step to understand it.'})
keywordHandler:addKeyword({'elf'}, StdModule.say, {npcHandler = npcHandler, text = 'We are the most graceful of all races. We feel the music of the universe in our hearts and souls.'})
keywordHandler:addKeyword({'kuridai'}, StdModule.say, {npcHandler = npcHandler, text = 'They could dig some halls for a big musical event, but they won\'t listen to me about that matter.'})
keywordHandler:addKeyword({'teshial'}, StdModule.say, {npcHandler = npcHandler, text = 'I bet they were great musicians.'})
keywordHandler:addKeyword({'crunor'}, StdModule.say, {npcHandler = npcHandler, text = 'That is some god the humans worship. Our pople are not interested in this gods anymore.'})
keywordHandler:addKeyword({'human'}, StdModule.say, {npcHandler = npcHandler, text = 'They are too loud and don\'t even understand the concept of a melody.'})
keywordHandler:addKeyword({'deraisim'}, StdModule.say, {npcHandler = npcHandler, text = 'The other deraisim are too much concerned with mastering the nature so they don\'t listen to its music anymore.'})
keywordHandler:addKeyword({'cenath'}, StdModule.say, {npcHandler = npcHandler, text = 'The Cenath think they know the \'art\' but the only true art is the music.'})
keywordHandler:addKeyword({'troll'}, StdModule.say, {npcHandler = npcHandler, text = 'I went down to the mines and tried to lighten up their spirit, the foolish creatures did not listen to my songs, though.'})
keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I don\'t feel like teaching magic today.'})
keywordHandler:addKeyword({'hellgate'}, StdModule.say, {npcHandler = npcHandler, text = 'For the worst of crimes, criminals are cast into hellgate. It is said no one can return from there. Since it is not actually forbidden to enter hellgate, you might convince Elathriel to grant you entrance.'})

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'songs of the forest') then
		npcHandler:say({
			'The last issue I had was bought by Randor Swiftfinger. He was banished through the hellgate and probably took the book with him ...',
			'I would not recommend seeking him or the book there, but of course it is possible.'
		}, npc, creature)
	elseif MsgContains(message, 'love poem') then
		npcHandler:say('Do you want to buy a poem scroll for 200 gold?', npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:setTopic(playerId, 0)
			local player = Player(creature)
			if not player:removeMoneyBank(200) then
				npcHandler:say('You don\'t have enough money.', npc, creature)
				return true
			end

			player:addItem(6119, 1)
			npcHandler:say('Here it is.', npc, creature)
		end
	end
	return true
end

-- Greeting message
keywordHandler:addGreetKeyword({"ashari"}, {npcHandler = npcHandler, text = "Ashari, |PLAYERNAME|."})
--Farewell message
keywordHandler:addFarewellKeyword({"asgha thrazi"}, {npcHandler = npcHandler, text = "Asha Thrazi, |PLAYERNAME|."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, 'Ashari |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Asha Thrazi, |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Asha Thrazi, |PLAYERNAME|!')

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "drum", clientId = 14253, buy = 140 },
	{ itemName = "lute", clientId = 2950, buy = 195 },
	{ itemName = "lyre", clientId = 2949, buy = 120 },
	{ itemName = "poem scroll", clientId = 6119, buy = 200 },
	{ itemName = "simple fanfare", clientId = 2954, buy = 150 }
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

npcType:register(npcConfig)
