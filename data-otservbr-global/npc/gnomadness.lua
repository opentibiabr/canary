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

local function greetCallback(npc, creature, message)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Reward.Hazard6) < 1 and player:getStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Hazard.Max) >= 6 then
		npcHandler:setMessage(MESSAGE_GREET, "Hello! Your defiance of hazards is astounding. Maybe an endemic {mount} will help you face even greater challenges.?")
	elseif player:getStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Reward.Hazard13) < 1 and player:getStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Hazard.Max) >= 13 then
		npcHandler:setMessage(MESSAGE_GREET, "You are pumped with hazard energy! I think this deserves a special {reward}!")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hello and welcome in the Gnomprona Gardens. If you want to change your {hazard} level, I'm who you're looking for.")
	end
	return true
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
	if MsgContains(message, 'mount') then
		if player:getStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Reward.Hazard6) < 1 and player:getStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Hazard.Max) >= 6 then
			player:addMount(202)
			player:setStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Reward.Hazard6, 1)
		npcHandler:say('In one of my experiments I surprisingly tamed a noxious ripptor which will be a good companion. Take care of him!', npc, creature)
		end
	elseif MsgContains(message, 'reward') then
		if player:getStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Reward.Hazard13) < 1 and player:getStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Hazard.Max) >= 13 then
			player:addItem(39546, 1)
			player:setStorageValue(Storage.Quest.U12_90.PrimalOrdeal.Reward.Hazard13, 1)
			npcHandler:say('Here, take this reward as a token of gratitude for helping in my experiments.', npc, creature)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
