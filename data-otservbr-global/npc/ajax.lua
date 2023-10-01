local internalNpcName = "Ajax"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 143,
	lookHead = 78,
	lookBody = 101,
	lookLegs = 120,
	lookFeet = 94,
	lookAddons = 1
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

	if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 1 or player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) > 3 then
		npcHandler:setMessage(MESSAGE_GREET, "Whatcha do in my place?")
	elseif player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 2 and player:getStorageValue(Storage.OutfitQuest.BarbarianAddonWaitTimer) < os.time() then
		npcHandler:setMessage(MESSAGE_GREET, "You back. You know, you right. Brother is right. Fist not always good. Tell him that!")
		player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 3)
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	-- PREQUEST
	if MsgContains(message, "mine") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 1 then
			npcHandler:say("YOURS? WHAT IS YOURS! NOTHING IS YOURS! IS MINE! GO AWAY, YES?!", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("YOU STUPID! STUBBORN! I KILL YOU! WILL LEAVE NOW?!", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("ARRRRRRRRRR! YOU ME DRIVE MAD! HOW I MAKE YOU GO??", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("I GIVE YOU NO!", npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "please") then
		if npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("Please? What you mean please? Like I say please you say bye? Please?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	-- OUTFIT
	elseif MsgContains(message, "gelagos") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 4 then
			npcHandler:say("Annoying kid. Bro hates him, but talking no help. Bro needs {fighting spirit}!", npc, creature)
			npcHandler:setTopic(playerId, 6)
		end
	elseif MsgContains(message, "fighting spirit") then
		if npcHandler:getTopic(playerId) == 6 then
			npcHandler:say("If you want to help bro, bring him fighting spirit. Magic fighting spirit. Ask Djinn.", npc, creature)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 5)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "present") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 11 then
			npcHandler:say("Bron gave me present. Ugly, but nice from him. Me want to give present too. You help me?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		end
	elseif MsgContains(message, "ore") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 12 then
			npcHandler:say("You bring 100 iron ore?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		end
	elseif MsgContains(message, "iron") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 13 then
			npcHandler:say("You bring crude iron?", npc, creature)
			npcHandler:setTopic(playerId, 9)
		end
	elseif MsgContains(message, "fangs") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 14 then
			npcHandler:say("You bring 50 behemoth fangs?", npc, creature)
			npcHandler:setTopic(playerId, 10)
		end
	elseif MsgContains(message, "leather") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 15 then
			npcHandler:say("You bring 50 lizard leather?", npc, creature)
			npcHandler:setTopic(playerId, 11)
		end
	elseif MsgContains(message, "axe") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 16 and player:getStorageValue(Storage.OutfitQuest.BarbarianAddonWaitTimer) < os.time() then
			npcHandler:say("Axe is done! For you. Take. Wear like me.", npc, creature)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 17)
			player:addOutfitAddon(147, 1)
			player:addOutfitAddon(143, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:addAchievement('Brutal Politeness')
		else
			npcHandler:say("Axe is not done yet!", npc, creature)
		end
	-- OUTFIT
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("Oh. Easy. Okay. Please is good. Now don't say anything. Head aches. ", npc, creature)
			local condition = Condition(CONDITION_FIRE)
			condition:setParameter(CONDITION_PARAM_DELAYED, 1)
			condition:addDamage(10, 2000, -10)
			player:addCondition(condition)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 2)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddonWaitTimer, os.time() + 60 * 60) -- 1 hour
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		elseif npcHandler:getTopic(playerId) == 6 then
			npcHandler:say({
				"Good! Me make shiny weapon. If you help me, I make one for you too. Like axe I wear. I need stuff. Listen. ...",
				"Me need 100 iron ore. Then need crude iron. Then after that 50 behemoth fangs. And 50 lizard leather. You understand?",
				"Help me yes or no?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say("Good. You get 100 iron ore first. Come back.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 12)
		elseif npcHandler:getTopic(playerId) == 8 then
			if player:removeItem(5880, 100) then
				npcHandler:say("Good! Now bring crude iron.", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 13)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 9 then
			if player:removeItem(5892, 1) then
				npcHandler:say("Good! Now bring 50 behemoth fangs.", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 14)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 10 then
			if player:removeItem(5893, 50) then
				npcHandler:say("Good! Now bring 50 lizard leather.", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 15)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 11 then
			if player:removeItem(5876, 50) then
				npcHandler:say("Ah! All stuff there. I will start making axes now. Come later and ask me for axe.", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 16)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddonWaitTimer, os.time() + 2 * 60 * 60) -- 2 hours
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
