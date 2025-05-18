local internalNpcName = "A Dragon Mother"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 39,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
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
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.BabyDragon) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Greetings humans! Consider yourselfs lucky, I'm in need of {help}.")
		npcHandler:setTopic(playerId, 1)
		return true
	elseif player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AccessMachine) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Grrr.")
		return true
	elseif player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.HorrorKilled) >= 1 then
		npcHandler:setMessage(MESSAGE_GREET, "You have done me a favour and the knowledge you are seeking shall be yours. I melted the ice for you, you can pass now.")
		player:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AccessMachine, 1)
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "help") then
		npcHandler:say("I'm aware what you are looking for. Usually I would rather devour you, but due to unfortunate circumstances, I need your {assistance}.", npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "assistance") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"Wretched creatures of ice have stolen my egg that was close to hatching. ...",
				" Since I'm to huge to enter those lower Tunnels I have to ask you to take care of my {egg}. Will you do this?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	end

	if MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 3 then
			npcHandler:say({
				"So return to the upper tunnels where cultists and ice golems dwell. Somewhere in these tunnels you will find a small prison haunted by a ghost. South of this prison cell there is a tunnel that will lead you eastwards. ...",
				"Follow the tunnel until you reach a small cave. Step down and down until you see a blue energy field. It will lead you to my egg. It is sealed so that not everyone may enter the room. But you have the permission now.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.BabyDragon, 1)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 3 then
			npcHandler:say({
				"Grrr.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	end

	if MsgContains(message, "egg") then
		if npcHandler:getTopic(playerId) == 4 then
			npcHandler:say({
				"As I told you, fiendish ice creatures dragged my egg into the lower caves. ...",
				" Without enough heat the egg will die soon. Venture there and save my hatchling and the knowledge you seeek shall be yours!",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.BabyDragon, 1)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
