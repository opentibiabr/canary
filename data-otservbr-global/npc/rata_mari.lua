local internalNpcName = "Rata'Mari"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 21
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

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	if Player(creature):getStorageValue(Storage.DjinnWar.MaridFaction.Mission02) == -1 then
		return false
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'spy report') then
		local reportProgress = player:getStorageValue(Storage.DjinnWar.MaridFaction.RataMari)
		if reportProgress < 1 then
			npcHandler:say({
				'You have come for the report? Great! I have been working hard on it during the last months. And nobody came to pick it up. I thought everybody had forgotten about me! ...',
				'Do you have any idea how difficult it is to hold a pen when you have claws instead of hands? ...',
				'But - you know - now I have worked so hard on this report I somehow don\'t want to part with it. At least not without some decent payment. ...',
				'All right - listen - I know Fa\'hradin would not approve of this, but I can\'t help it. I need some cheese! I need it now! ...',
				'And I will not give the report to you until you get me some! Meep!'
			}, npc, creature)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.RataMari, 1)

		elseif reportProgress == 1 then
			npcHandler:say('Ok, have you brought me the cheese, I\'ve asked for?', npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say('I already gave you the report. I\'m not going to write another one!', npc, creature)
		end

	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, 'yes') then
			if not player:removeItem(3607, 1) then
				npcHandler:say('No cheese - no report.', npc, creature)
				return true
			end
			player:setStorageValue(Storage.DjinnWar.MaridFaction.RataMari, 2)
			player:addItem(3232, 1)
			npcHandler:say('Meep! Meep! Great! Here is the spyreport for you!', npc, creature)
		else
			npcHandler:say('No cheese - no report.', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

keywordHandler:addKeyword({'rat'}, StdModule.say, {npcHandler = npcHandler, text = 'Your power of observation is stunning. Yes, I\'m a rat.'})

-- Greeting message
keywordHandler:addGreetKeyword({"piedpiper"}, {npcHandler = npcHandler, text = "Meep? I mean - hello! Sorry, |PLAYERNAME|... Being a {rat} has kind of grown on me."})

npcHandler:setMessage(MESSAGE_GREET, "Meep? I mean - hello! Sorry, |PLAYERNAME|... Being a {rat} has kind of grown on me.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Meep!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Meep!")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
