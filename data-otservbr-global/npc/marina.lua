local internalNpcName = "Marina"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 5811
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

	if MsgContains(message, "silk") or MsgContains(message, "yarn") or MsgContains(message, "silk yarn") or MsgContains(message, "spool of yarn") then
		if player:getStorageValue(Storage.FriendsandTraders.TheMermaidMarina) < 1 then
			npcHandler:say("Um. You mean, you really want me to touch that gooey spider silk just because you need yarn? Well... do you think that I'm pretty?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.FriendsandTraders.TheMermaidMarina) == 2 then
			npcHandler:say("Okay... a deal is a deal, would you like me to create a {spool of yarn} from {10 pieces of spider silk}?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "honey") or MsgContains(message, "honeycomb") or MsgContains(message, "50 honeycombs") then
		if player:getStorageValue(Storage.FriendsandTraders.TheMermaidMarina) == 1 then
			npcHandler:say("Did you bring me the 50 honeycombs I requested and do you absolutely admire my beauty?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "raymond striker") then
		if player:getStorageValue(Storage.TheShatteredIsles.APoemForTheMermaid) == 1 then
			npcHandler:say("<giggles> I think he has a crush on me. Well, silly man, it is only for his own good. This way he can get accustomed to TRUE beauty. And I won't give him up anymore now that he is mine.", npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.APoemForTheMermaid, 2)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "date") then
		if player:getStorageValue(Storage.TheShatteredIsles.ADjinnInLove) == 1 then
			npcHandler:say("Is that the best you can do? A true Djinn would have done something more poetic.", npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.ADjinnInLove, 2)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.TheShatteredIsles.ADjinnInLove) == 4 then
			npcHandler:say({
				"This lovely, exotic Djinn is a true poet. And he is asking me for a date? Excellent. Now I can finaly dump this human pirate. He was growing to be boring more and more with each day ...",
				"As a little reward for your efforts I allow you to ride my sea turtles. Just look around at the shores and you will find them."
			}, npc, creature)
			player:addAchievement('Matchmaker')
			player:setStorageValue(Storage.TheShatteredIsles.ADjinnInLove, 5)
			player:setStorageValue(Storage.TheShatteredIsles.AccessToLagunaIsland, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Well, everyone would say that in your position. Do you think that I'm really, absolutely the most stunning being that you have ever seen?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"<giggles> It's funny how easy it is to get humans to say what you want. Now, proving it will be even more fun! ...",
				"You want me to touch something gooey, so you have to touch something gooey for me too. <giggles> ...",
				"I love honey and I haven't eaten it in a while, so bring me 50 honeycombs and worship my beauty a little more, then we will see."
			}, npc, creature)
			player:setStorageValue(Storage.FriendsandTraders.TheMermaidMarina, 1)
			player:setStorageValue(Storage.FriendsandTraders.DefaultStart, 1)
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:removeItem(5902, 50) then
				npcHandler:say("Oh goodie! Thank you! Okay... I guess since my fingers are sticky now anyway, I will help you. From now on, if you bring me {10 pieces of spider silk}, I will create one {spool of yarn}.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				player:setStorageValue(Storage.FriendsandTraders.TheMermaidMarina, 2)
			else
				npcHandler:say("You don't have enough honey.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:removeItem(5879, 10) then
				player:addItem(5886, 1)
				npcHandler:say("Ew... gooey... there you go.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have the required items.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	end
	return true
end

keywordHandler:addKeyword({'comb'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I don\'t have a spare comb. I lost my favourite one when diving around in Calassa.'})
keywordHandler:addKeyword({'mermaid comb'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I don\'t have a spare comb. I lost my favourite one when diving around in Calassa.'})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
