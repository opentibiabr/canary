local internalNpcName = "Mr. West"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 151,
	lookHead = 58,
	lookBody = 25,
	lookLegs = 29,
	lookFeet = 114,
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
	local player = Player(creature)
	local playerId = player:getId()

	if(player:getStorageValue(Storage.InServiceofYalahar.MrWestDoor) == 1) then
		npcHandler:setMessage(MESSAGE_GREET, "Wh .. What? How did you get here? Where are all the guards? You .. you could have killed me but yet you chose to talk? What a relief! ... So what brings you here my friend, if I might call you like that? ")
	elseif(player:getStorageValue(Storage.InServiceofYalahar.MrWestDoor) == 2) then
		npcHandler:setMessage(MESSAGE_GREET, "Murderer! But .. I give in, you won! ... Dictate me your conditions but please, I beg you, spare my life. What do you want?")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if(MsgContains(message, "mission")) then
		if(player:getStorageValue(Storage.InServiceofYalahar.Questline) == 24) then
			if(player:getStorageValue(Storage.InServiceofYalahar.MrWestDoor) == 1) then
				npcHandler:say("Indeed, I can see the benefits of a mutual agreement. I will later read the details and send a letter to your superior. ", npc, creature)
				player:setStorageValue(Storage.InServiceofYalahar.Questline, 25)
				player:setStorageValue(Storage.InServiceofYalahar.Mission04, 3) -- StorageValue for Questlog "Mission 04: Good to be Kingpin"
				player:setStorageValue(Storage.InServiceofYalahar.MrWestStatus, 1)
				npcHandler:setTopic(playerId, 0)
			elseif(player:getStorageValue(Storage.InServiceofYalahar.MrWestDoor) == 2) then
				npcHandler:say("Yes, for the sake of my life I'll accept those terms. I know when I have lost. Tell your master I will comply with his orders. ", npc, creature)
				player:setStorageValue(Storage.InServiceofYalahar.Questline, 25)
				player:setStorageValue(Storage.InServiceofYalahar.Mission04, 4) -- StorageValue for Questlog "Mission 04: Good to be Kingpin"
				player:setStorageValue(Storage.InServiceofYalahar.MrWestStatus, 2)
				npcHandler:setTopic(playerId, 0)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
