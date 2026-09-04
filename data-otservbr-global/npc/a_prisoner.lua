local internalNpcName = "A Prisoner"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 81,
	lookBody = 21,
	lookLegs = 54,
	lookFeet = 94,
	lookAddons = 0,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	-- Mad mage room quest
	if MsgContains(message, "riddle") then
		if player:getStorageValue(Storage.Quest.U7_24.MadMageRoom.APrisoner) ~= 1 then
			npcHandler:say(
				"Great riddle, isn't it? If you can tell me the correct answer, \z
				I will give you something. Hehehe!",
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "PD-D-KS-P-PD") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Hurray! For that I will give you my key for - hmm - let's say ... some apples. Interested?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			if player:removeItem(3585, 7) then
				npcHandler:say("Mnjam - excellent apples. Now - about that key. You are sure want it?", npc, creature)
				npcHandler:setTopic(playerId, 3)
			else
				npcHandler:say("Get some more apples first!", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Really, really?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("Really, really, really, really?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif npcHandler:getTopic(playerId) == 5 then
			player:setStorageValue(Storage.Quest.U7_24.MadMageRoom.APrisoner, 1)
			npcHandler:say("Then take it and get happy - or die, hehe.", npc, creature)
			local key = player:addItem(2969, 1)
			if key then
				key:setActionId(Storage.Quest.Key.ID3666)
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") then
		npcHandler:say("Then go away!", npc, creature)
	end
	-- The paradox tower quest
	if MsgContains(message, "math") then
		if player:getStorageValue(Storage.Quest.U7_24.TheParadoxTower.Mathemagics) < 1 then
			npcHandler:say(
				"My surreal numbers are based on astonishing facts. \z
				Are you interested in learning the secret of mathemagics?",
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 6)
		else
			npcHandler:say("You already know the secrets of mathemagics! Now go and use them to learn.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 6 then
		npcHandler:say("But first tell me your favourite colour please!", npc, creature)
		npcHandler:setTopic(playerId, 7)
	elseif MsgContains(message, "green") and npcHandler:getTopic(playerId) == 7 then
		npcHandler:say("Very interesting. So are you ready to proceed in your lesson in mathemagics?", npc, creature)
		npcHandler:setTopic(playerId, 8)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 8 then
		if player:getStorageValue(Storage.Quest.U7_24.TheParadoxTower.Mathemagics) < 1 then
			player:setStorageValue(Storage.Quest.U7_24.TheParadoxTower.Mathemagics, 1)
			player:addAchievement("Mathemagician")
			npcHandler:say("So know that everything is based on the simple fact that 1 + 1 = 1!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say(" I think you are not in touch with yourself, come back if you have tuned in on your own feelings.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Wait! Don't leave! I want to tell you about my surreal numbers.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye! Don't forget about the secrets of mathemagics.")
npcHandler:setMessage(MESSAGE_GREET, "Huh? What? I can see! Wow! A non-mino. Did they {capture} you as well?")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "something" }, StdModule.say, { npcHandler = npcHandler, text = "No! I won't tell you. Shame coz it would be useful for you - hehehe." })
keywordHandler:addKeyword({ "labyrinth" }, StdModule.say, { npcHandler = npcHandler, text = "It's easy to find your way through it! Just follow the pools of mud. Hehe - useful hint, isn't it?" })
keywordHandler:addKeyword({ "mad mage" }, StdModule.say, { npcHandler = npcHandler, text = "Hey! That's me! You got it! Thanks mate - now I remember my name!" })
keywordHandler:addKeyword({ "sorcerer" }, StdModule.say, { npcHandler = npcHandler, text = "I am the mightiest sorcerer from here to there! Yeah!" })
keywordHandler:addKeyword({ "capture" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, they capture people. I guess that's their job." })
keywordHandler:addKeyword({ "markwin" }, StdModule.say, { npcHandler = npcHandler, text = "He is the worst of them all! He is the king of the minos! May he burn in hell!" })
keywordHandler:addKeyword({ "conjure" }, StdModule.say, { npcHandler = npcHandler, text = "Yeah! There are many monsters guarding my home. Only the bravest hero will be able to slay them!" })
keywordHandler:addKeyword({ "monster" }, StdModule.say, { npcHandler = npcHandler, text = "Yeah! There are many monsters guarding my home. Only the bravest hero will be able to slay them!" })
keywordHandler:addKeyword({ "escape" }, StdModule.say, { npcHandler = npcHandler, text = "How could I escape? They only give me rotten food here. I can't regain my powers because I have no mana!" })
keywordHandler:addKeyword({ "palkar" }, StdModule.say, { npcHandler = npcHandler, text = "He is the leader of the outcasts. I hope he will never conquer the city of Mintwallin. That would be the end of me!" })
keywordHandler:addKeyword({ "vanish" }, StdModule.say, { npcHandler = npcHandler, text = "Wait! Don't leave! I want to tell you about my surreal numbers." })
keywordHandler:addKeyword({ "power" }, StdModule.say, { npcHandler = npcHandler, text = "Power. Hmmm. Once while we were crossing the mountains together a man named Aureus said to me that parcels are equal to power. Any idea what that meant?" })
keywordHandler:addKeyword({ "books" }, StdModule.say, { npcHandler = npcHandler, text = "I have many books in my home. But only powerful people can read them. I bet you will only see three dots after the headline! Hehehe! Hahaha! Excellent!" })
keywordHandler:addKeyword({ "demon" }, StdModule.say, { npcHandler = npcHandler, text = "The only monster I cannot conjure. But soon I will be powerful enough!" })
keywordHandler:addKeyword({ "apple" }, StdModule.say, { npcHandler = npcHandler, text = "Apples! Real apples! Man I love them! Can I have one? Oh please say yes!" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is - uhm - hang on? I knew it yesterday, didn't I? Doesn't matter!" })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Better save time than comitting a crime. I am a poet and I know it!" })
keywordHandler:addKeyword({ "mino" }, StdModule.say, { npcHandler = npcHandler, text = "They are trying to capture me! Or hang on! Haven't they already captured me? Hmmm - I will have to think about this." })
keywordHandler:addKeyword({ "karl" }, StdModule.say, { npcHandler = npcHandler, text = "Tataah!" })
keywordHandler:addKeyword({ "home" }, StdModule.say, { npcHandler = npcHandler, text = "Yeah! There are many monsters guarding my home. Only the bravest hero will be able to slay them!" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Job? JOB? Hey man - I am in prison! But you know - once upon a time - I was a powerful mage! A mage ... come to think of it .., what is that - a mage?" })
keywordHandler:addKeyword({ "key" }, StdModule.say, { npcHandler = npcHandler, text = "Sure I have the key! Hehehe! Perhaps I will give it to you. IF you can solve my riddle." })
keywordHandler:addKeyword({ "way" }, StdModule.say, { npcHandler = npcHandler, text = "It's easy to find your way through it! Just follow the pools of mud. Hehe - useful hint, isn't it?" })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
