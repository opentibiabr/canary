local internalNpcName = "Markwin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 23,
}

npcConfig.flags = {
	floorchange = false,
	profession = "trader",
}
npcConfig.speechBubble = SPEECHBUBBLE_TRADE

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
condition:setParameter(CONDITION_PARAM_TICKS, 30 * 1000)
condition:setParameter(CONDITION_PARAM_MINVALUE, 30)
condition:setParameter(CONDITION_PARAM_TICKINTERVAL, 4000)

local guards = { "Minotaur Guard", "Minotaur Archer", "Minotaur Mage" }
local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.MarkwinGreeting) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Intruder! Guards, take him down!")
		player:setStorageValue(Storage.MarkwinGreeting, 1)
		local position
		for x = -1, 1 do
			for y = -1, 1 do
				position = Position(32418 + x, 32147 + y, 15)
				Game.createMonster(guards[math.random(3)], position)
				position:sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		npcHandler:say("No! The hornless have reached my city! BODYGUARDS TO ME!", npc, creature)
		return false
	elseif player:getStorageValue(Storage.MarkwinGreeting) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Well ... you defeated my guards! Now everything is over! I guess I will have to answer your questions now.")
		player:setStorageValue(Storage.MarkwinGreeting, 2)
	elseif player:getStorageValue(Storage.MarkwinGreeting) == 2 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh its you again. What du you want, hornless messenger?")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "letter") then
		if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission10) == 1 then
			if player:getItemCount(3220) > 0 then
				npcHandler:say("A letter from my Moohmy?? Do you have a letter from my Moohmy to me?", npc, creature)
				npcHandler:setTopic(playerId, 1)
			end
		end
	elseif MsgContains(message, "cookie") then
		if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Questline) == 31 and player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Markwin) ~= 1 then
			npcHandler:say("You bring me ... a cookie???", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Uhm, well thank you, hornless being.", npc, creature)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission10, 2)
			player:removeItem(3220, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			if not player:removeItem(130, 1) then
				npcHandler:say("You have no cookie that I'd like.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Markwin, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement("Allow Cookies?")
			end

			npc:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say("I understand this as a peace-offering, human ... UNGH ... THIS IS AN OUTRAGE! THIS MEANS WAR!!!", npc, creature)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(npc, creature)
		end
	elseif MsgContains(message, "bye") then
		npcHandler:say("Hm ... good bye.", npc, creature)
		player:addCondition(condition)
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc(npc, creature)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "second fellow" }, StdModule.say, { npcHandler = npcHandler, text = "Yeah - he has to step on a special tile and an entrance will appear at a very poisonous place!" })
keywordHandler:addKeyword({ "secret lab" }, StdModule.say, { npcHandler = npcHandler, text = "Hehe - you will never find a way to enter it. The outcast stole the key. You are too weak to conquer it. HARHARHAR." })
keywordHandler:addKeyword({ "mintwallin" }, StdModule.say, { npcHandler = npcHandler, text = "The former glorious city lies in the dirt. It is my home. I founded it about 180 years ago, when we found this lovely place." })
keywordHandler:addKeyword({ "minotaurs" }, StdModule.say, { npcHandler = npcHandler, text = "My fellows all are minotaurs. It is my folk. I am the king of all minos." })
keywordHandler:addKeyword({ "enter lab" }, StdModule.say, { npcHandler = npcHandler, text = "First of all you will need a second fellow to help you." })
keywordHandler:addKeyword({ "labyrinth" }, StdModule.say, { npcHandler = npcHandler, text = "It protected us for a long time. There are lots of traps in it. And many long tunnels. There haven't been many foes that found their way through it. Only that prisoner once arrived." })
keywordHandler:addKeyword({ "chronicle" }, StdModule.say, { npcHandler = npcHandler, text = "I am one of the minotaurs that are able to write. So I wrote most of the history of my beloved city Mintwallin in some books." })
keywordHandler:addKeyword({ "tibianus" }, StdModule.say, { npcHandler = npcHandler, text = "I am the real king of Mintwallin!" })
keywordHandler:addKeyword({ "prisoner" }, StdModule.say, { npcHandler = npcHandler, text = "He is totally mad. I don't know how he could find the way through the labyrinth. I arrested him in the prison." })
keywordHandler:addKeyword({ "palkars" }, StdModule.say, { npcHandler = npcHandler, text = "He is the leader of the outcast. In former times he was my best warrior, but now he is my worst enemy." })
keywordHandler:addKeyword({ "outcast" }, StdModule.say, { npcHandler = npcHandler, text = "Those are no minos any longer. They left the city and killed their brothers. And they stole the key to my secret lab." })
keywordHandler:addKeyword({ "surface" }, StdModule.say, { npcHandler = npcHandler, text = "I would like to see the light of the sun again, but you will probably kill me. Go away!" })
keywordHandler:addKeyword({ "answer" }, StdModule.say, { npcHandler = npcHandler, text = "I am the king of all minotaurs. I have been the king for more than 320 years." })
keywordHandler:addKeyword({ "kaplar" }, StdModule.say, { npcHandler = npcHandler, text = "I really don't know what it means. But ALL minos say it! Terrible!" })
keywordHandler:addKeyword({ "second" }, StdModule.say, { npcHandler = npcHandler, text = "After you entered the first area you will need the key from the outcasts." })
keywordHandler:addKeyword({ "riddle" }, StdModule.say, { npcHandler = npcHandler, text = "Riddle? I don't know riddles!" })
keywordHandler:addKeyword({ "minos" }, StdModule.say, { npcHandler = npcHandler, text = "My fellows all are minotaurs. It is my folk. I am the king of all minos." })
keywordHandler:addKeyword({ "enter" }, StdModule.say, { npcHandler = npcHandler, text = "To enter the laboratory is pretty difficult." })
keywordHandler:addKeyword({ "place" }, StdModule.say, { npcHandler = npcHandler, text = "The best protection for our city is secrecy and the labyrinth." })
keywordHandler:addKeyword({ "human" }, StdModule.say, { npcHandler = npcHandler, text = "I hate them all. Minotaurs have no own spelling, so I used the speech of the humans. Once I was a prisoner of them. Since then I hate them - and since then I can speak and write in their language." })
keywordHandler:addKeyword({ "books" }, StdModule.say, { npcHandler = npcHandler, text = "I am one of the minotaurs that are able to write. So I wrote most of the history of my beloved city Mintwallin in some books." })
keywordHandler:addKeyword({ "demon" }, StdModule.say, { npcHandler = npcHandler, text = "He was the beginning of our end. He is mighty and powerful. He killed many brave minos and after his arrival we weren't able to go up to the surface." })
keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, text = "I would like to see the light of the sun again, but you will probably kill me. Go away!" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Markwin, the old and real king of this city." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Don't ask me such stupid questions. My time is over right now." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "I am the real king of Mintwallin!" })
keywordHandler:addKeyword({ "real" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, I am the real king. Palkar is the leader of the outcasts." })
keywordHandler:addKeyword({ "city" }, StdModule.say, { npcHandler = npcHandler, text = "The former glorious city lies in the dirt. It is my home. I founded it about 180 years ago, when we found this lovely place." })
keywordHandler:addKeyword({ "milk" }, StdModule.say, { npcHandler = npcHandler, text = "No! I won't tell you the powers of our milk!" })
keywordHandler:addKeyword({ "karl" }, StdModule.say, { npcHandler = npcHandler, text = "The man who explored this part of the map first. Strange guy. He likes to be announced as hunter. I don't like him. He is a human." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the king of all minotaurs. I have been the king for more than 320 years." })
keywordHandler:addKeyword({ "key" }, StdModule.say, { npcHandler = npcHandler, text = "There are many keys. The outcast stole the key to our secret lab! They should burn!" })
keywordHandler:addKeyword({ "sun" }, StdModule.say, { npcHandler = npcHandler, text = "I would like to see the light of the sun again, but you will probably kill me. Go away!" })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
