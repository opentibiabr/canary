local internalNpcName = "Umar"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 80,
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

local function endConversationWithDelay(npcHandler, npc, creature)
	addEvent(function()
		npcHandler:unGreet(npc, creature)
	end, 1000)
end

local function greetCallback(npc, creature, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not MsgContains(message, "djanni'hah") then
		npcHandler:say("Whoa! A human! This is no place for you, |PLAYERNAME|. Go and play somewhere else.", npc, creature)
		endConversationWithDelay(npcHandler, npc, creature)
		return false
	end

	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Start) == 1 then
		npcHandler:say({
			"Hahahaha! ...",
			"|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!",
		}, npc, creature)
		endConversationWithDelay(npcHandler, npc, creature)
		return false
	end

	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.Greeting) == -1 then
		npcHandler:say({
			"Hahahaha! ...",
			"|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!",
		}, npc, creature)
		endConversationWithDelay(npcHandler, npc, creature)
		return false
	end

	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.MaridDoor) ~= 1 then
		npcHandler:say({
			"Whoa? You know the word! Amazing, |PLAYERNAME|! ...",
			"I should go and tell Fa'hradin. ...",
			"Well. Why are you here anyway, |PLAYERNAME|?",
		}, npc, creature)
	else
		npcHandler:say("|PLAYERNAME|! How's it going these days? What brings you {here}?", npc, creature)
	end

	npcHandler:setInteraction(npc, creature)

	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	-- To Appease the Mighty Quest
	if MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest) == 1 then
		npcHandler:say({
			"I should go and tell Fa'hradin. ...",
			"I am impressed you know our address of welcome! I honour that. So tell me who sent you on a mission to our fortress?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 9)
	elseif MsgContains(message, "kazzan") and npcHandler:getTopic(playerId) == 9 then
		npcHandler:say({
			"How dare you lie to me?!? The caliph should choose his envoys more carefully. We will not accept his peace-offering ...",
			"...but we are always looking for support in our fight against the evil Efreets. Tell me if you would like to join our fight.",
		}, npc, creature)
		player:setStorageValue(Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest, player:getStorageValue(Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest) + 1)
	end

	if MsgContains(message, "passage") then
		if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.MaridDoor) ~= 1 then
			npcHandler:say({
				"If you want to enter our fortress you have to become one of us and fight the Efreet. ...",
				"So, are you willing to do so?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say("You already have the permission to enter Ashta'daramai.", npc, creature)
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.EfreetDoor) ~= 1 then
				npcHandler:say("Are you sure? You pledge loyalty to king Gabel, who is... you know. And you are willing to never ever set foot on Efreets' territory, unless you want to kill them? Yes?", npc, creature)
				npcHandler:setTopic(playerId, 2)
			else
				npcHandler:say("I don't believe you! You better go now.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif MsgContains(message, "no") then
			npcHandler:say("This isn't your war anyway, human.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "yes") then
			npcHandler:say({
				"Oh. Ok. Welcome then. You may pass. ...",
				"And don't forget to kill some Efreets, now and then.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.MaridDoor, 1)
			player:setStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.Greeting, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("This isn't your war anyway, human.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

-- Greeting
keywordHandler:addCustomGreetKeyword({ "djanni'hah" }, greetCallback, { npcHandler = npcHandler })

npcHandler:setMessage(MESSAGE_FAREWELL, "<salutes>Aaaa -tention!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "<salutes>Aaaa -tention!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
