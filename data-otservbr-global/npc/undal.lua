local internalNpcName = "Undal"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1137,
	lookHead = 0,
	lookBody = 87,
	lookLegs = 49,
	lookFeet = 87,
	lookAddons = 0,
	lookMount = 0,
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

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

local outfits = { 1147, 1146 }

local function hasOutfit(player)
	for _, outfit in ipairs(outfits) do
		if player:hasOutfit(outfit) then
			return true
		end
	end
	return false
end

local function hasAddon(player, addon)
	for _, outfit in ipairs(outfits) do
		if player:hasOutfit(outfit, addon) then
			return true
		end
	end
	return false
end

local function hasKllledTheNightmareBeast(player)
	return player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.NightmareBeastKilled) == 1
end

local function checkAchievement(player)
	if hasAddon(player, 3) then
		player:addAchievement("Dream Warrior")
	end
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if npcHandler:getTopic(playerId) == 0 then
		if MsgContains(message, "task") or MsgContains(message, "outfit") then
			if hasOutfit(player) then
				npcHandler:say("You already have the Dream Warrior outfit.", npc, creature)
				return true
			end

			if not hasKllledTheNightmareBeast(player) then
				npcHandler:say("You need to kill the Nightmare Beast first.", npc, creature)
				return true
			end

			npcHandler:say("The Nightmare Beast is slain. You have done well. The Courts of Summer and Winter will be forever grateful. For your efforts I want to reward you with our traditional dream warrior outfit. May it suit you well!", npc, creature)
			for _, outfit in ipairs(outfits) do
				player:addOutfit(outfit, 0)
			end
			return true
		end

		if MsgContains(message, "addon") then
			if not hasOutfit(player) then
				npcHandler:say("You don't have the Dream Warrior outfit.", npc, creature)
				return true
			end
			npcHandler:say("Are you interested in one or two addons to your dream warrior outfit?", npc, creature)
			npcHandler:setTopic(playerId, 1)
			return true
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			npcHandler:say("I provide two addons. For the first one I need you to bring me five pomegranates. For the second addon you need an ice shield. Which one would you like? {Pomegranate} or {shield}?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		else
			npcHandler:say("Alright then. Come back if you change your mind.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "pomegranate") then
			if hasAddon(player, 1) then
				npcHandler:say("You already have this addon.", npc, creature)
				return true
			end
			if player:removeItem(30169, 5) then
				npcHandler:say("Great! Here is the addon.", npc, creature)
				for _, outfit in ipairs(outfits) do
					player:addOutfitAddon(outfit, 1)
				end
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				checkAchievement(player)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Sorry, you don't have the required items.", npc, creature)
			end
		elseif MsgContains(message, "shield") then
			if hasAddon(player, 2) then
				npcHandler:say("You already have this addon.", npc, creature)
				return true
			end
			if player:removeItem(30168, 1) then
				npcHandler:say("Great! Here is the addon.", npc, creature)
				for _, outfit in ipairs(outfits) do
					player:addOutfitAddon(outfit, 2)
				end
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				checkAchievement(player)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Sorry, you don't have the required items.", npc, creature)
			end
		else
			npcHandler:say("Sorry, I didn't understand.", npc, creature)
			return true
		end
	end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
