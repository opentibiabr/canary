local internalNpcName = "Huntsman"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 129,
	lookHead = 95,
	lookBody = 40,
	lookLegs = 40,
	lookFeet = 57,
	lookAddons = 1
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


	if MsgContains(message, "huntsman") then
		npcHandler:say("I hunt game of all sorts to earn a living. I respect the {balance} of nature though and take only as much as I need.", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "balance") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"To be honest, I don't care too much about that spiritual balance thing. Better talk to {Benevola} about such things. ...",
				"As a matter of fact though, if too many animals are killed, things might rapidly change for the worse. ...",
				"So it's only practical thinking to keep the balance in mind as long as I can afford it."
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	
	elseif MsgContains(message, "benevola") then
		if npcHandler:getTopic(playerId) == 2 then
			player:addMapMark(Position(32596, 31746, 7), MAPMARK_FLAG, "Benevola's Hut")
			npcHandler:say("She is a bit overly concerned about that nature and balance stuff but she has a good heart. She is living in the woods between Carlin and Ab'Dendriel. I'll mark her hut on your map.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end  

	elseif MsgContains(message, "white deer") then
		npcHandler:say("The white deer are somewhat sacred to the elves. Though their fur and antlers are rumoured to earn a decent amount of {gold} on the market, it's probably not worth the trouble.", npc, creature)
		npcHandler:setTopic(playerId, 3)
		
	elseif MsgContains(message, "gold") then
		if npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Just between you and me, I heard a guy named {Cruleo} is offering some handsome cash for the trophies of a white deer.", npc, creature)
			npcHandler:setTopic(playerId, 4) 
		end	
	elseif MsgContains(message, "cruleo") then
		if npcHandler:getTopic(playerId) == 4 then		   
			player:addMapMark(Position(32723, 31793, 7), MAPMARK_FLAG, "Cruleo's Hut")
			npcHandler:say("He has a house in the wilderness. Just between Ab'Dendriel and the orcland. I'll mark his hut on your map.", npc, creature)
			npcHandler:setTopic(playerId, 0)		   
		end 
	end
	
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m just a simple {huntsman}.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I don\'t think telling a stranger your name is a smart thing to do.'})

npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye. Take care.")
npcHandler:setMessage(MESSAGE_FAREWELL, "I can still see you.")
npcHandler:setMessage(MESSAGE_GREET, "Howdy partner.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
