local internalNpcName = "The Orc King"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 238
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

local creatures = { 'Slime', 'Slime', 'Slime', 'Orc Warlord', 'Orc Warlord', 'Orc Leader', 'Orc Leader', 'Orc Leader' }
local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.OrcKingGreeting) ~= 1 then
		player:setStorageValue(Storage.OrcKingGreeting, 1)
		for i = 1, #creatures do
			Game.createMonster(creatures[i], npc:getPosition())
		end
		npcHandler:say('Arrrrgh! A dirty paleskin! To me my children! Kill them my guards!', TALKTYPE_SAY)
		return false
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Harrrrk! You think you are strong now? You shall never escape my wrath! I am immortal!')
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local efreet, marid = player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission03), player:getStorageValue(Storage.DjinnWar.MaridFaction.Mission03)
	-- Mission 3 - Orc Fortress
	if MsgContains(message, 'lamp') then
		if efreet == 1 or marid == 1 then
			if player:getStorageValue(Storage.DjinnWar.ReceivedLamp) ~= 1 then
				npcHandler:say({
					'I can sense your evil intentions to imprison a djinn! You are longing for the lamp, which I still possess. ...',
					'Who do you want to trap in this cursed lamp?'
				}, npc, creature)
				npcHandler:setTopic(playerId, 1)
			else
				npcHandler:say('For eons he was trapped in an enchanted lamp by some ancient race. Now he\'s free to roam the world again. Although he cheated me I appreciate what he and his brethren will do to this world, now it\'s the time of the Djinn again!', npc, creature)
			end
		end

	elseif MsgContains(message, 'cookie') then
		if player:getStorageValue(Storage.WhatAFoolish.Questline) == 31 and player:getStorageValue(Storage.WhatAFoolish.CookieDelivery.OrcKing) ~= 1 then
			npcHandler:say('You bring me a stinking cookie???', npc, creature)
			npcHandler:setTopic(playerId, 2)
		end

	-- Mission 3 - Orc Fortress
	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, 'malor') then
			if efreet == 1 then
				player:setStorageValue(Storage.DjinnWar.EfreetFaction.DoorToLamp, 1)

			elseif marid == 1 then
				player:setStorageValue(Storage.DjinnWar.MaridFaction.DoorToLamp, 1)
			end

			player:setStorageValue(Storage.DjinnWar.ReceivedLamp, 1)
			player:addItem(3231, 1)
			npcHandler:say('I was waiting for this day! Take the lamp and let Malor feel my wrath!', npc, creature)
		else
			npcHandler:say('I don\'t know your enemy, paleskin! Begone!', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)

	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, 'yes') then
			if not player:removeItem(130, 1) then
				npcHandler:say('You have no cookie that I\'d like.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:setStorageValue(Storage.WhatAFoolish.CookieDelivery.OrcKing, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement('Allow Cookies?')
			end

			npc:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say('Well, I hope it stinks a lot. I like stinking cookies best ... BY MY THOUSAND SONS! YOU ARE SO DEAD HUMAN! DEAD!', npc, creature)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)

		elseif MsgContains(message, 'no') then
			npcHandler:say('I see.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

keywordHandler:addKeyword({'immortal'}, StdModule.say, {npcHandler = npcHandler, text = 'I am Charkahn the Slayer! The immortal father of the {orcs} and master of this {hive}.'})
keywordHandler:addKeyword({'orcs'}, StdModule.say, {npcHandler = npcHandler, text = 'The orcs are the bearers of Blogs rage. This makes us the ultimate fighters and the most powerful of all races.'})
keywordHandler:addKeyword({'divine'}, StdModule.say, {npcHandler = npcHandler, text = 'The orcs are the bearers of Blogs rage. This makes us the ultimate fighters and the most powerful of all races.'})
keywordHandler:addKeyword({'hive'}, StdModule.say, {npcHandler = npcHandler, text = 'I can sense the presence and the feelings of my underlings and {minions}. I embrace the rage of the horde.'})
keywordHandler:addKeyword({'minions'}, StdModule.say, {npcHandler = npcHandler, text = 'The orcish horde of this hive is under my control. I sense their emotions and their needs and provide them with the leadership they need to focus their hate and rage'})
keywordHandler:addKeyword({'hate'}, StdModule.say, {npcHandler = npcHandler, text = 'Hate and rage are the true blessings of Blog, since they are powerful weapons. They give the hive strength. I provide them with direction and focus.'})
keywordHandler:addKeyword({'blog'}, StdModule.say, {npcHandler = npcHandler, text = 'The Raging One blessed us with his burning hate. We are truly his children and therefore {divine}.'})
keywordHandler:addKeyword({'direction'}, StdModule.say, {npcHandler = npcHandler, text = 'To conquer, to destroy and to dominate. Orcs are born to rule the {world}.'})
keywordHandler:addKeyword({'world'}, StdModule.say, {npcHandler = npcHandler, text = 'One day I will rule the world, even when turned into a {slime}.'})
keywordHandler:addKeyword({'slime'}, StdModule.say, {npcHandler = npcHandler, text = 'Pah! Don\'t mock me, mortal! This shape is a curse which the evil {djinn} bestowed upon me!'})
keywordHandler:addKeyword({'djinn'}, StdModule.say, {npcHandler = npcHandler, text = 'This cursed djinn king! I set him free from an enchanted {lamp}, and he {cheated} me!'})
keywordHandler:addKeyword({'cheated'}, StdModule.say, {npcHandler = npcHandler, text = 'Because I freed him he granted me three wishes. He was true to his word in the first two {wishes}.'})
keywordHandler:addKeyword({'wishes'}, StdModule.say, {npcHandler = npcHandler, text = 'He built this fortress over Uldrek\'s grave within a single night. Also, he granted me my second wish and gave me immortality. Test it and try to kill me if you want. Har Har!'})
keywordHandler:addKeyword({'third'}, StdModule.say, {npcHandler = npcHandler, text = 'I wished to father more healthy and fertile children as any orc has ever done. But the djinn cheated me and made me a slime! Then he laughed at me and left for his abandoned fortress in the {Deathwish} Mountains.'})
keywordHandler:addKeyword({'deathwish'}, StdModule.say, {npcHandler = npcHandler, text = 'His ancient fortress on Darama was deserted as the evil Djinn fled this world after his imprisonment. Now the time has come for the evil Djinns to return to their master although this will certainly awaken the {good Djinn} too.'})
keywordHandler:addKeyword({'good djinn'}, StdModule.say, {npcHandler = npcHandler, text = 'I will not share anything more about that topic with you {paleskins}.'})
keywordHandler:addKeyword({'paleskins'}, StdModule.say, {npcHandler = npcHandler, text = 'You are as ugly as maggots, although not quite as as tasty.'})
keywordHandler:addKeyword({'malor'}, StdModule.say, {npcHandler = npcHandler, text = 'This cursed djinn king! I set him free from an enchanted lamp, and he cheated me!'}, function(player) return player:getStorageValue(Storage.DjinnWar.ReceivedLamp) == 1 end)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
