local internalNpcName = "Oswald"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 115,
	lookBody = 0,
	lookLegs = 67,
	lookFeet = 114,
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

keywordHandler:addKeyword({'gods'}, StdModule.say, {npcHandler = npcHandler, text = "I think the gods are too busy to care about us mortals, hmm... that makes me feel godlike, too."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am honored to be the assistant of the great, the illustrious, the magnificent {Durin}!"})
keywordHandler:addKeyword({'important'}, StdModule.say, {npcHandler = npcHandler, text = "I am honored to be the assistant of the great, the illustrious, the magnificent {Durin}!"})
keywordHandler:addKeyword({'assistant'}, StdModule.say, {npcHandler = npcHandler, text = "I have a job of great responsibility, mostly I keep annoying persons away from my boss."})
keywordHandler:addKeyword({'annoying'}, StdModule.say, {npcHandler = npcHandler, text = "You better don't ask, you wouldn't like the answer."})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = "Ah, yes, yes, hail to King {Tibianus}! Long live the king and so on..."})
keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = "I overheard a conversation of officials, that magic will be forbidden soon."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Oswald, but let's proceed, I am a very busy man."})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = "Hey, I am not a shopkeeper, I am an important man!"})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "It is nearly tea time, so please hurry!"})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = "It's rumoured that Sam does not forge all weapons himself, but buys them from his cousin, who is married to a cyclops."})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = " If you want to see dungeons just don't pay your taxes."})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = "It's beyond all doubt that certain sinister elements in our city have certain knowledge about this myth."})
keywordHandler:addKeyword({'necromants nectar'}, StdModule.say, {npcHandler = npcHandler, text = "You are not the first one to ask about that. Am I the only one that preferes wine to such disgusting stuff?"})
keywordHandler:addKeyword({'benjamin'}, StdModule.say, {npcHandler = npcHandler, text = "What do you expect from ex-soldiers? He is nuts! Hacked on the head far too often."})
keywordHandler:addKeyword({'bozo'}, StdModule.say, {npcHandler = npcHandler, text = "Isn't he the artist formerly known as the prince?"})
keywordHandler:addKeyword({'Chester Kahs'}, StdModule.say, {npcHandler = npcHandler, text = "I never found any rumour concerning him, isn't that odd?"})
keywordHandler:addKeyword({'elane'}, StdModule.say, {npcHandler = npcHandler, text = "They say she killed over a dozen husbands already."})
keywordHandler:addKeyword({'gamel'}, StdModule.say, {npcHandler = npcHandler, text = "This man lives in the darkness like a rat and is also as handsome as one of them. He surely is up to no good and often consorts with sinister strangers."})
keywordHandler:addKeyword({'sinister strangers'}, StdModule.say, {npcHandler = npcHandler, text = "Just last week a one eyed man, who had a room at Frodo's, met him in the middle of the night."})
keywordHandler:addKeyword({'gorn'}, StdModule.say, {npcHandler = npcHandler, text = "He sells his scrolls far too expensive."})
keywordHandler:addKeyword({'gregor'}, StdModule.say, {npcHandler = npcHandler, text = "I was told he lost a body part or two in duels... if you know what I mean."})
keywordHandler:addKeyword({'muriel'}, StdModule.say, {npcHandler = npcHandler, text = "He is rumoured to summon kinky demons to... well you know."})
keywordHandler:addKeyword({'rumours'}, StdModule.say, {npcHandler = npcHandler, text = "You know a rumour? TELL ME! TELL ME! TELL ME!"})
keywordHandler:addKeyword({'anything'}, StdModule.say, {npcHandler = npcHandler, text = "Fascinating! Absolutely fascinating!"})
keywordHandler:addKeyword({'quentin'}, StdModule.say, {npcHandler = npcHandler, text = "I heard he was a ladies' man in younger days. In our days he is rumoured to wear women clothes now and then."})
keywordHandler:addKeyword({'sam'}, StdModule.say, {npcHandler = npcHandler, text = "A simple shopkeeper with minor intelligence."})
keywordHandler:addKeyword({'goshnar'}, StdModule.say, {npcHandler = npcHandler, text = "They say he isn't truly dead. He was... or is a necromant after all."})
keywordHandler:addKeyword({'lugri'}, StdModule.say, {npcHandler = npcHandler, text = " Some say he is Ferumbras in disguise."})
keywordHandler:addKeyword({'partos'}, StdModule.say, {npcHandler = npcHandler, text = "What a shame. He claimed to be the king of thiefs and was caught stealing some fruit."})
keywordHandler:addKeyword({'durin'}, StdModule.say, {npcHandler = npcHandler, text = "Just between you and me, he can be quite a tyrant."})
keywordHandler:addKeyword({'monsters'}, StdModule.say, {npcHandler = npcHandler, text = "AHHHH!!! WHERE??? WHERE???"})

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end


	if MsgContains(message, 'invitation') then
		if player:getStorageValue(Storage.ThievesGuild.Mission03) == 1 then
			npcHandler:say('What? So why in the world should I give you an invitation? It\'s not as if you were someone important, are you?', npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say('Well, rich and generous people are always welcome in the palace.If you donate 1000 gold to a fund I oversee, I\'ll give you an invitation, ok?', npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeMoneyBank(1000) then
				player:addItem(7933, 1)
				player:setStorageValue(Storage.ThievesGuild.Mission03, 2)
				npcHandler:say('Excellent! Here is your invitation!', npc, creature)
			else
				npcHandler:say('You don\'t have enough money.', npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'gold') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say('Not that I am bribeable but I doubt that you own 1000 gold pieces. Or do you?', npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Oh, hello |PLAYERNAME|. What is it?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Finally!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye, and don't come back too soon.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
