local internalNpcName = "Dermot"
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
	lookHead = 57,
	lookBody = 49,
	lookLegs = 19,
	lookFeet = 95,
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

	if MsgContains(message, "present") then
		if player:getStorageValue(Storage.Postman.Mission05) == 2 then
			npcHandler:say("You have a present for me?? Realy?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "key") then
		npcHandler:say("Do you want to buy the dungeon key for 2000 gold?", npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			if player:removeItem(3218, 1) then
				npcHandler:say("Thank you very much!", npc, creature)
				player:setStorageValue(Storage.Postman.Mission05, 3)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:removeMoneyBank(2000) then
				npcHandler:say("Here it is.", npc, creature)
				local key = player:addItem(2968, 1)
				if key then
					key:setActionId(3940)
				end
			else
				npcHandler:say("You don't have enough money.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the magistrate of this isle."})
keywordHandler:addKeyword({'magistrate'}, StdModule.say, {npcHandler = npcHandler, text = "Thats me."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I am Dermot, the magistrate of this isle."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "Time is not important on Fibula."})
keywordHandler:addKeyword({'fibula'}, StdModule.say, {npcHandler = npcHandler, text = "You are at Fibula. This isle is not very dangerous. Just the wolves bother outside the village."})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = "Oh, my god. In the dungeon of Fibula are a lot of monsters. That's why we have sealed it with a solid door."})
keywordHandler:addKeyword({'monsters'}, StdModule.say, {npcHandler = npcHandler, text = "Oh, my god. In the dungeon of Fibula are a lot of monsters. That's why we have sealed it with a solid door."})

npcHandler:setMessage(MESSAGE_GREET, "Hello, traveller |PLAYERNAME|. How can I help you?")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you again.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "See you again.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
