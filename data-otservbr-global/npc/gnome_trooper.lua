local internalNpcName = "Gnome Trooper"
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
	lookHead = 59,
	lookBody = 20,
	lookLegs = 39,
	lookFeet = 95,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

if not DELIVERED_PARCELS then
	DELIVERED_PARCELS = {}
end

local response = {
	[0] = "It's a pipe! What can be more relaxing for a gnome than to smoke his pipe after a day of duty at the front. At least it's a chance to do something really dangerous after all!",
	[1] = "Ah, a letter from home! Oh - I had no idea she felt that way! This is most interesting!",
	[2] = "It's a model of the gnomebase Alpha! For self-assembly! With toothpicks...! Yeeaah...! I guess.",
	[3] = "A medal of honour! At last they saw my true worth!",
}

local function initializeParcelDelivery(player)
	local playerGuid = player:getGuid()
	if not DELIVERED_PARCELS[playerGuid] then
		DELIVERED_PARCELS[playerGuid] = {}
	end

	return DELIVERED_PARCELS[playerGuid]
end

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerGuid = player:getGuid()
	local deliveredParcels = initializeParcelDelivery(player)
	local parcelStatus = player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Main)

	if table.contains({ -1, 4 }, parcelStatus) or table.contains(deliveredParcels, npc:getId()) then
		return false
	end

	npcHandler:setMessage(MESSAGE_GREET, "Do you have something to deliver?")
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerGuid = player:getGuid()
	local deliveredParcels = initializeParcelDelivery(player)
	local parcelStatus = player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Main)

	if MsgContains(message, "something") and not table.contains({ -1, 4 }, parcelStatus) then
		if table.contains(deliveredParcels, npc:getId()) then
			return true
		end

		if not player:removeItem(19219, 1) then
			npcHandler:say("But you don't have it...", npc, creature)
			return npcHandler:removeInteraction(npc, creature)
		end

		npcHandler:say(response[parcelStatus], npc, creature)
		player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Main, parcelStatus + 1)
		table.insert(deliveredParcels, npc:getId())
		npcHandler:removeInteraction(npc, creature)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
