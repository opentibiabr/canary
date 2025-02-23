local internalNpcName = "Alyxo"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 330,
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

	-- Mission 3 Steal The Ambassador Ring
	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss) == 1 then
			npcHandler:setTopic(playerId, 1)
		end
		npcHandler:say({ "Could you kill 3 bosses for me?" }, npc, creature) -- needs review, this is not the speech of the global
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss) == 1 then
			npcHandler:say({ "Come back as soon as you kill all 3 bosses." }, npc, creature) -- needs review, this is not the speech of the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss, 2)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Bragrumol, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Mozradek, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Xogixath, 1)
			npcHandler:setTopic(playerId, 2)
		else
			npcHandler:say({ "Sorry, you do not have access." }, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	-- Mission 3 Steal The Ambassador Ring
	if MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss) == 2 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss) == 2 then
			npcHandler:say({ "Did you manage to face all 3 bosses?" }, npc, creature) -- needs review, this is not the speech of the global
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss) == 2 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Bragrumol) == 2 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Mozradek) == 2 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Xogixath) == 2 then
			npcHandler:say({ "I am very satisfied." }, npc, creature) -- needs review, this is not the speech of the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss, 3)
			npcHandler:setTopic(playerId, 4)
		else
			npcHandler:say({ "Sorry." }, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	if MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss) == 3 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss) == 3 then
			npcHandler:say({ "Could you help me with some more work?" }, npc, creature) -- needs review, this is not the speech of the global
			npcHandler:setTopic(playerId, 5)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 5 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss) == 3 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss) == 3 then
			npcHandler:say({ "Kill 300 members of the Fafnar cult, help me find Ivory Lyre and help me find an animal to stone." }, npc, creature) -- needs review, this is not the speech of the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss, 4)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Fafnar, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Lyre, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Presente, 1)
			npcHandler:setTopic(playerId, 6)
		else
			npcHandler:say({ "Sorry." }, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	if MsgContains(message, "report") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Fafnar) == 300 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Fafnar) == 300 then
			npcHandler:say({ "Have you finished killing the 300 members of Fafnar's cult?" }, npc, creature) -- needs review, this is not the speech of the global
			npcHandler:setTopic(playerId, 7)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 7 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Fafnar) == 300 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Fafnar) == 300 then
			npcHandler:say({ "Thanks. You killed the 300 members of the Fafnar cult." }, npc, creature) -- needs review, this is not the speech of the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Fafnar, 301)
			npcHandler:setTopic(playerId, 8)
		else
			npcHandler:say({ "Sorry." }, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	if MsgContains(message, "report") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Lyre) == 3 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Lyre) == 3 then
			npcHandler:say({ "Did you manage to find Lyre?" }, npc, creature) -- needs review, this is not the speech of the global
			npcHandler:setTopic(playerId, 9)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 9 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Lyre) == 3 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Lyre) == 3 and player:getItemById(31447, 1) then
			player:removeItem(31447, 1)
			npcHandler:say({ "Thanks. I was looking for Lyre for a long time." }, npc, creature) -- needs review, this is not the speech of the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Lyre, 4)
		else
			npcHandler:say({ "Sorry." }, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	if MsgContains(message, "report") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Presente) == 2 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Presente) == 2 then
			npcHandler:say({ "Did you manage to find Small Tortoise?" }, npc, creature) -- needs review, this is not the speech of the global
			npcHandler:setTopic(playerId, 11)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 11 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Presente) == 2 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Presente) == 2 and player:getItemById(31445, 1) then
			player:removeItem(31445, 1)
			npcHandler:say({ "Thanks. I was looking for Small Tortoise." }, npc, creature) -- needs review, this is not the speech of the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Presente, 3)
			npcHandler:setTopic(playerId, 12)
		else
			npcHandler:say({ "Sorry." }, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	if MsgContains(message, "small tortoise") then
		if player:getItemById(31445, 1) then
			npcHandler:say({ "Do you want me to stone a small tortoise?" }, npc, creature) -- needs review, this is not the speech of the global
			npcHandler:setTopic(playerId, 15)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 15 then
		if player:getItemById(31445, 1) then
			player:removeItem(31445, 1)
			player:addItem(31446, 1)
			npcHandler:say({ "Here's your Small Petrified Tortoise." }, npc, creature) -- needs review, this is not the speech of the global
			npcHandler:setTopic(playerId, 16)
		else
			npcHandler:say({ "Sorry." }, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	if MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Fafnar) == 301 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Fafnar) == 301 then
			npcHandler:say({ "Did you finish the 3 jobs I gave you?" }, npc, creature) -- needs review, this is not the speech of the global
			npcHandler:setTopic(playerId, 13)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 13 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Fafnar) == 301 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Fafnar) == 301 then
			player:addAchievement("Sculptor Apprentice", 'Congratulations! You earned the achievement "Sculptor Apprentice".')
			player:addItem(31574, 1)
			npcHandler:say({ "Congratulations, you have completed the 3 jobs I gave you." }, npc, creature) -- needs review, this is not the speech of the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourteen.Remains, 1)
			npcHandler:setTopic(playerId, 14)
		else
			npcHandler:say({ "Sorry." }, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
