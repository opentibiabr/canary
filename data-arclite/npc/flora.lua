local internalNpcName = "Flora"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 148,
	lookHead = 114,
	lookBody = 81,
	lookLegs = 20,
	lookFeet = 3,
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

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	npcHandler:setMessage(MESSAGE_GREET, "Greetings, " .. Player(creature):getName() .. ". Well, we all know what time it is. Always when we meet, the citizens of rathleton voted for the {Glooth Fairy}! ... Well, the rules are as simples as always. Ask me for a {fight} and I\'ll teleport you into the room with the lever, therefore I\'ll charge one voting right. ... From this room there is no way back to me. Pull the trigger and after one minute you and your buddies will face the {Glooth Fairy}.")
	npcHandler:setTopic(playerId, 0)
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if(MsgContains(message, "fight")) then
		npcHandler:say("Do you really want to enter the Glooth Fairy\'s hideout. There is no chickening out and I also have to charge one voting right! {Yes} or {no}?", npc, creature)
			npcHandler:setTopic(playerId, 1)
	elseif(MsgContains(message, "yes")) then
		if(npcHandler:getTopic(playerId) == 1) then
			npcHandler:say("Here you go!", npc, creature)
			local pos = {x=33660, y=31936, z=9}
			doTeleportThing(creature, pos)
			doSendMagicEffect(pos, CONST_ME_TELEPORT)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "no")) then
		if(npcHandler:getTopic(playerId) == 1) then
			npcHandler:say("Okay...", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, 'Come back soon.')
npcHandler:setMessage(MESSAGE_WALKAWAY, '')
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
