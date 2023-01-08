local internalNpcName = "The Blind Prophet"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 117,
	lookHead = 10,
	lookBody = 20,
	lookLegs = 30,
	lookFeet = 40,
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

-- Don't forget npcHandler = npcHandler in the parameters. It is required for all StdModule functions!
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Me put name away name long ago. Now only blind prophet of ape people are.'})
keywordHandler:addKeyword({'blind prophet'}, StdModule.say, {npcHandler = npcHandler, text = 'Me is who in dreams speak to holy banana. Me divine the will of banana.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'Me {prophet} and {guardian} is.'})
keywordHandler:addKeyword({'prophet'}, StdModule.say, {npcHandler = npcHandler, text = 'Me is who in dreams speak to holy banana. Me divine the will of banana.'})
keywordHandler:addKeyword({'guardian'}, StdModule.say, {npcHandler = npcHandler, text = 'Me guard the forbidden land behind the great palisade. If any want to enter, he must ask me for transport.'})
keywordHandler:addKeyword({'forbidden land'}, StdModule.say, {npcHandler = npcHandler, text = 'Me guard the forbidden land behind the great palisade. If any want to enter, he must ask me for transport.'})
keywordHandler:addKeyword({'hairycles'}, StdModule.say, {npcHandler = npcHandler, text = 'Good ape he is. Has to work hard to make other apes listen but you helped a lot.'})
keywordHandler:addKeyword({'bong'}, StdModule.say, {npcHandler = npcHandler, text = ' Our holy ancestor he is. Big as mountain. Lizards say they built palisade to keep him but we not believe ... We think Bong palisade built to have peace from pesky lizards. We respect peace of Bong, keep people away from forbidden land.'})
keywordHandler:addKeyword({'lizards'}, StdModule.say, {npcHandler = npcHandler, text = ' The lizards evil and vengeful are. Ape people on guard must be.'})
keywordHandler:addKeyword({'ape'}, StdModule.say, {npcHandler = npcHandler, text = 'Our people a lot to learn have. One day we might live in peace with you hairless apes, who knows.'})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = 'Me not know. Me seldom have visions of not banana related objects.'})
keywordHandler:addKeyword({'port hope'}, StdModule.say, {npcHandler = npcHandler, text = 'Hairless apes strange people are. '})

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	npcHandler:setMessage(MESSAGE_GREET, "Be greeted, friend of the apes.")
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "transport") or MsgContains(message, "passage") then
		npcHandler:say("You want me to transport you to forbidden land?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, 'yes') then
			npcHandler:say("Take care!", npc, creature)
			local destination = Position(33025, 32580, 6)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
		elseif MsgContains(message, 'no') then
			npcHandler:say("Wise decision maybe.", npc, creature)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
