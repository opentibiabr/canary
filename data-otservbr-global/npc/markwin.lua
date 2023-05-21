local internalNpcName = "Markwin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 23
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

local condition = Condition(CONDITION_FIRE)
condition:setParameter(CONDITION_PARAM_TICKS, 30 * 1000)
condition:setParameter(CONDITION_PARAM_MINVALUE, 30)
condition:setParameter(CONDITION_PARAM_TICKINTERVAL, 4000)

local guards = { "Minotaur Guard", "Minotaur Archer", "Minotaur Mage" }
local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.MarkwinGreeting) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Intruder! Guards, take him down!")
		player:setStorageValue(Storage.MarkwinGreeting, 1)
		local position
		for x = -1, 1 do
			for y = -1, 1 do
				position = Position(32418 + x, 32147 + y, 15)
				Game.createMonster(guards[math.random(3)], position)
				position:sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		return false
	elseif player:getStorageValue(Storage.MarkwinGreeting) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Well ... you defeated my guards! Now everything is over! I guess I will have to answer your questions now.")
		player:setStorageValue(Storage.MarkwinGreeting, 2)
	elseif player:getStorageValue(Storage.MarkwinGreeting) == 2 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh its you again. What du you want, hornless messenger?")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "letter") then
		if player:getStorageValue(Storage.Postman.Mission10) == 1 then
			if player:getItemCount(3220) > 0 then
				npcHandler:say("A letter from my Moohmy?? Do you have a letter from my Moohmy to me?", npc, creature)
				npcHandler:setTopic(playerId, 1)
			end
		end
	elseif MsgContains(message, 'cookie') then
		if player:getStorageValue(Storage.WhatAFoolish.Questline) == 31
				and player:getStorageValue(Storage.WhatAFoolish.CookieDelivery.Markwin) ~= 1 then
			npcHandler:say('You bring me ... a cookie???', npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Uhm, well thank you, hornless being.", npc, creature)
			player:setStorageValue(Storage.Postman.Mission10, 2)
			player:removeItem(3220, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			if not player:removeItem(130, 1) then
				npcHandler:say('You have no cookie that I\'d like.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:setStorageValue(Storage.WhatAFoolish.CookieDelivery.Markwin, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement('Allow Cookies?')
			end

			npc:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say('I understand this as a peace-offering, human ... UNGH ... THIS IS AN OUTRAGE! THIS MEANS WAR!!!', npc, creature)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		end
	elseif MsgContains(message, "bye") then
		npcHandler:say("Hm ... good bye.", npc, creature)
		player:addCondition(condition)
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc(creature)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
