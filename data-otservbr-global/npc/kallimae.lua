local internalNpcName = "Kallimae"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1199,
	lookHead = 95,
	lookBody = 52,
	lookLegs = 0,
	lookFeet = 71,
	lookAddons = 1,
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

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.Access) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		npcHandler:setTopic(playerId, 1)
	elseif (player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.JamesfrancisTask) >= 0 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.JamesfrancisTask) <= 50) and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.Mission) < 3 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		npcHandler:setTopic(playerId, 15)
	elseif player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.Mission) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.Mission, 5)
		npcHandler:setTopic(playerId, 20)
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) == 11 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) == 11 then
			npcHandler:say({ "Some residents are in need of ingredients to finish a ritual. You can help?" }, npc, creature) -- It needs to be revised, it's not the same as the global
			npcHandler:setTopic(playerId, 1)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) == 11 then
			npcHandler:say({ "Search for the NPCs Yonan, Narsai, Shimun and Tefrit." }, npc, creature) -- It needs to be revised, it's not the same as the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Set.Ritual, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Set.Yonan, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Set.Narsai, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Set.Shimun, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Set.Tefrit, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor, 12)
			npcHandler:setTopic(playerId, 2)
			npcHandler:setTopic(playerId, 2)
		else
			npcHandler:say({ "Sorry." }, npc, creature) -- It needs to be revised, it's not the same as the global
		end
	end
	if MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Yonan) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Shimun) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Tefrit) == 3 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Yonan) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Shimun) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Tefrit) == 3 then
			npcHandler:say({ "Did you help some residents with ingredients?" }, npc, creature) -- It needs to be revised, it's not the same as the global
			npcHandler:setTopic(playerId, 3)
			npcHandler:setTopic(playerId, 3)
		end
	elseif
		MsgContains(message, "yes")
		and npcHandler:getTopic(playerId) == 3
		and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Yonan) == 3
		and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 3
		and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Shimun) == 3
		and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Tefrit) == 3
	then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Yonan) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Shimun) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Tefrit) == 3 then
			npcHandler:say({ "Thanks. I need you to go to 4 places indicated by Goddess Bastesh." }, npc, creature) -- It needs to be revised, it's not the same as the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Nine.Owl, 1)
			npcHandler:setTopic(playerId, 4)
			npcHandler:setTopic(playerId, 4)
		else
			npcHandler:say({ "Sorry." }, npc, creature) -- It needs to be revised, it's not the same as the global
		end
	end
	if MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eleven.Basin) == 1 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eleven.Basin) == 1 then
			npcHandler:say({ "Did you check all the points and bring the Symbol of Sun and Sea?" }, npc, creature) -- It needs to be revised, it's not the same as the global
			npcHandler:setTopic(playerId, 5)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 5 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eleven.Basin) == 1 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eleven.Basin) == 1 and player:getItemById(31431, 1) then
			player:addItem(31572, 1)
			npcHandler:say({ "Thanks. Here is your reward." }, npc, creature) -- It needs to be revised, it's not the same as the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eleven.Basin, 2)
			npcHandler:setTopic(playerId, 6)
			npcHandler:setTopic(playerId, 6)
		else
			npcHandler:say({ "Sorry." }, npc, creature) -- It needs to be revised, it's not the same as the global
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")
npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
