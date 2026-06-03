local internalNpcName = "Bounac Guard"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1071,
	lookHead = 38,
	lookBody = 19,
	lookLegs = 38,
	lookFeet = 19,
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

local destinationIn = Position(32397, 32480, 4)
local destinationOut = Position(32401, 32480, 4)

local function grantAccess(player, npc, creature)
	player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessEasternSide, 1)
	player:teleportTo(destinationIn)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	npcHandler:say("The citizens have spoken in your favour. You may enter. Stay out of trouble.", npc, creature)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if MsgContains(message, "pass") or MsgContains(message, "in") then
		if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessEasternSide) >= 1 then
			player:teleportTo(destinationIn)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:say("Right this way.", npc, creature)
		elseif player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust) >= 5 then
			grantAccess(player, npc, creature)
		else
			npcHandler:say({
				"Pass? Not so fast, outsider. ...",
				"The people of Bounac are cautious during these troubled times. Earn our trust and I may let you pass.",
			}, npc, creature)
		end
		return true
	end

	if MsgContains(message, "out") then
		if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessEasternSide) >= 1 then
			player:teleportTo(destinationOut)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:say("Safe travels, traveller.", npc, creature)
		else
			npcHandler:say("You are not even supposed to be in here.", npc, creature)
		end
		return true
	end

	if message:lower() == "yes" and npcHandler:getTopic(playerId) == 1 then
		if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust) >= 5 then
			grantAccess(player, npc, creature)
		else
			npcHandler:say({
				"I'm afraid not. The citizens haven't vouched for you yet. ...",
				"Earn their trust and come back.",
			}, npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
		return true
	end
end

npcHandler:setMessage(MESSAGE_GREET, "Halt! This area is restricted during the siege. State your business or turn back.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
