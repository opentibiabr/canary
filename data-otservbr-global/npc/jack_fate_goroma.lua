local internalNpcName = "Jack Fate"
local npcType = Game.createNpcType("Jack Fate (Goroma)")
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 129,
	lookHead = 19,
	lookBody = 69,
	lookLegs = 88,
	lookFeet = 69,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if (message) then
		message = message:lower()
	end

	if isInArray({"sail", "passage", "wreck", "liberty bay", "ship"}, message) then
		if player:getStorageValue(Storage.TheShatteredIsles.AccessToGoroma) ~= 1 then
			if player:getStorageValue(Storage.TheShatteredIsles.Shipwrecked) < 1 then
				npcHandler:say('I\'d love to bring you back to Liberty Bay, but as you can see, my ship is ruined. I also hurt my leg and can barely move. Can you help me?', npc, creature)
				npcHandler:setTopic(playerId, 1)
			elseif player:getStorageValue(Storage.TheShatteredIsles.Shipwrecked) == 1 then
				npcHandler:say('Have you brought 30 pieces of wood so that I can repair the ship?', npc, creature)
				npcHandler:setTopic(playerId, 3)
			end
		else
			npcHandler:say('Do you want to travel back to Liberty Bay?', npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Thank you. Luckily the damage my ship has taken looks more severe than it is, so I will only need a few wooden boards. ...",
				"I saw some lousy trolls running away with some parts of the ship. It might be a good idea to follow them and check if they have some more wood. ...",
				"We will need 30 pieces of wood, no more, no less. Did you understand everything?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say('Good! Please return once you have gathered 30 pieces of wood.', npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.DefaultStart, 1)
			player:setStorageValue(Storage.TheShatteredIsles.Shipwrecked, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(5901, 30) then
				npcHandler:say("Excellent! Now we can leave this godforsaken place. Thank you for your help. Should you ever want to return to this island, ask me for a passage to Goroma.", npc, creature)
				player:setStorageValue(Storage.TheShatteredIsles.Shipwrecked, 2)
				player:setStorageValue(Storage.TheShatteredIsles.AccessToGoroma, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have enough...", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == 4 then
			player:teleportTo(Position(32285, 32892, 6), false)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:say('Set the sails!', npc, creature)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Jack Fate from the Royal Tibia Line.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the captain of this - well, wreck. Argh.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the captain of this - well, wreck. Argh'})
keywordHandler:addKeyword({'goroma'}, StdModule.say, {npcHandler = npcHandler, text = 'This is where we are... the volcano island Goroma. There are many rumours about this place.'})

npcHandler:setMessage(MESSAGE_GREET, "Hello, Sir |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
