local internalNpcName = "A Fading Memory"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

local KALA_COOLDOWN_STORAGE = 154226

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 138,
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

npcHandler:setMessage(MESSAGE_GREET, "Ohh...")

local function hasCooldown(npc, player)
	local lastUse = player:getStorageValue(KALA_COOLDOWN_STORAGE)
	if lastUse <= 0 then
		return false
	end

	local currentTime = os.time()
	local hoursPassed = (currentTime - lastUse) / 3600

	if hoursPassed >= 20 then
		player:setStorageValue(KALA_COOLDOWN_STORAGE, 0)
		return false
	end

	npcHandler:say("... I'm sorry... my tears are not ready yet... my soul needs time to grieve...", npc, player)
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission10) >= 2 then
		return false
	end

	if message == "kala" then
		npcHandler:say("... yes! That's my name... how come you know that?", npc, creature)
		npcHandler:setTopic(playerId, 1)
		return true
	end
	if message == "diary" and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("... you... read Marziel's diary and know our story...?", npc, creature)
		npcHandler:setTopic(playerId, 2)
		return true
	end
	if message == "yes" and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say("... then... tell me... I'm so sad... was it my fault? Why did he leave me... Arthei..?", npc, creature)
		npcHandler:setTopic(playerId, 3)
		return true
	end
	if message == "vampire" and npcHandler:getTopic(playerId) == 3 then
		npcHandler:say("... so there is nothing I could have done...? He's a vampire now... what can we do...", npc, creature)
		npcHandler:setTopic(playerId, 4)
		return true
	end
	if message == "free soul" and npcHandler:getTopic(playerId) == 4 then
		npcHandler:say("... he can't be freed from his curse that easily... he must be awaken first...", npc, creature)
		npcHandler:setTopic(playerId, 5)
		return true
	end
	if message == "awaken" and npcHandler:getTopic(playerId) == 5 then
		if hasCooldown(npc, player) then
			npcHandler:setTopic(playerId, 0)
			return true
		end

		npcHandler:say("... to awake him... I don't know but... he once truly loved me... maybe there is still something left... somewhere... here... take this from me....and thank you for listening...", npc, creature)
		player:addItem(8746, 1)
		player:setStorageValue(KALA_COOLDOWN_STORAGE, os.time())
		npcHandler:setTopic(playerId, 0)
		return true
	end
	return false
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
