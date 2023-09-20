local internalNpcName = "Gnomadness"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 110,
	lookBody = 65,
	lookLegs = 110,
	lookFeet = 110,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = " I'll have to write that idea down." },
	{ text = "So many ideas, so little time" },
	{ text = "Muhahaha!" },
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

	local hazard = Hazard.getByName("hazard.gnomprona-gardens")
	local current = hazard:getPlayerCurrentLevel(player)
	local maximum = hazard:getPlayerMaxLevel(player)

	if MsgContains(message, "hazard") then
		npcHandler:say("I can change your hazard level to spice up your hunt in the gardens. Your current level is set to " .. current .. ". And your maximum unlocked level is {" .. maximum .. "}. What level would you like to hunt in?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	else
		if npcHandler:getTopic(playerId) == 1 then
			local desiredLevel = getMoneyCount(message)
			if desiredLevel <= 0 then
				npcHandler:say("I'm sorry, I don't understand. What hazard level would you like to set?", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end
			if hazard:setPlayerCurrentLevel(player, desiredLevel) then
				npcHandler:say("Your hazard level has been set to " .. desiredLevel .. ". Good luck!", npc, creature)
			else
				npcHandler:say("You can't set your hazard level higher than your maximum unlocked level.", npc, creature)
			end
		end
	end
	return true
end

keywordHandler:addGreetKeyword({ "hi" }, { npcHandler = npcHandler, text = "Hello and welcome in the Gnomprona Gardens. If you want to change your {hazard} level, I 'm who you're looking for." })
keywordHandler:addAliasKeyword({ "hello" })

npcHandler:setMessage(MESSAGE_GREET, "Hello and welcome in the Gnomprona Gardens")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
