local internalNpcName = "Charos"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 133,
	lookHead = 60,
	lookBody = 94,
	lookLegs = 114,
	lookFeet = 115,
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

local config = {
	towns = {
		["venore"] = TOWNS_LIST.VENORE,
		["thais"] = TOWNS_LIST.THAIS,
		["kazordoon"] = TOWNS_LIST.KAZORDOON,
		["carlin"] = TOWNS_LIST.CARLAIN,
		["ab'dendriel"] = TOWNS_LIST.AB_DENDRIEL,
		["liberty bay"] = TOWNS_LIST.LIBERTY_BAY,
		["port hope"] = TOWNS_LIST.PORT_HOPE,
		["ankrahmun"] = TOWNS_LIST.ANKRAHMUN,
		["darashia"] = TOWNS_LIST.DARASHIA,
		["edron"] = TOWNS_LIST.EDRON
	}
}

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.AdventurersGuild.CharosTrav) > 6 then
		npcHandler:say("Sorry, you have traveled a lot.", npc, creature)
		npcHandler:resetNpc(creature)
		return false
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hello young friend! I can attune you to a city of your choice. \z
		If you step to the teleporter here you will not appear in the city you came from as usual, \z
		but the city of your choice. Is it what you wish?")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if npcHandler:getTopic(playerId) == 0 then
		if MsgContains(message, "yes") then
			npcHandler:say("Fine. You have ".. -player:getStorageValue(Storage.AdventurersGuild.CharosTrav)+7 .." \z
			attunements left. What is the new city of your choice? Thais, Carlin, Ab'Dendriel, Kazordoon, Venore, \z
			Ankrahmun, Edron, Darashia, Liberty Bay or Port Hope?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		local cityTable = config.towns[message:lower()]
		if cityTable then
			player:setStorageValue(Storage.AdventurersGuild.CharosTrav,
			player:getStorageValue(Storage.AdventurersGuild.CharosTrav)+1)
			player:setStorageValue(Storage.AdventurersGuild.Stone, cityTable)
			npcHandler:say("Goodbye traveler!", npc, creature)
		else
			npcHandler:say("Sorry, I don't know about this place.", npc, creature)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
