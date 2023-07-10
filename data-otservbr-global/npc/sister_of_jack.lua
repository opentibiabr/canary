local internalNpcName = "Sister Of Jack"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 136,
	lookHead = 77,
	lookBody = 128,
	lookLegs = 110,
	lookFeet = 115,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = "Where did I put my broom? Mother?"},
	{text = "Mother?! Oh no, now I have to do this all over again"},
	{text = "Mhmhmhmhm."},
	{text = "Lalala..."}
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

	if MsgContains(message, "jack") then
		if (player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 5) then
			if
				(player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Mother == 1) and
					(player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Sister)) < 1)
			 then
				npcHandler:say("Why are you asking, he didn't get himself into something again did he?", npc, creature)
				npcHandler:setTopic(playerId, 1)
			end
		end
	elseif MsgContains(message, "spectulus") then
		if (npcHandler:getTopic(playerId) == 3) then
			npcHandler:say(
				"Spelltolust?! That sounds awfully nasty! What was he doing there - are you telling \z
				me he lived an alternate life and he didn't even tell {mother}?",
			npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "yes") then
		if (npcHandler:getTopic(playerId) == 1) then
			npcHandler:say(
				{
					"I knew it! He likes taking extended walks outside, leaving all the cleaning to me - \z
					especially when he is working on this sculpture, this... 'thing' he tries to create. ...",
					"What did he do? Since you look like a guy from the city, I bet he went to Edron in \z
						secrecy or something like that, didn't he? And you are here because of that?"
				},
			npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif (npcHandler:getTopic(playerId) == 2) then
			npcHandler:say("What?! And what did he do there? Who did he visit there?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif (npcHandler:getTopic(playerId) == 4) then
			npcHandler:say(
				{
					"Yesss! So this time he will get it for a change! And he lived there...? He helped whom? \z
					Ha! He won't get away this time! What did he do there? I see... interesting! ...",
					"Wait till mother hears that! Oh he will be in for a surprise, I can tell you that. Ma!! Maaaaa!!"
				},
			npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.TibiaTales.JackFutureQuest.Sister, 1)
			player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, 6)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Mh hello there. What can I do for you?")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
