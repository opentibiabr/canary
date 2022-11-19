local internalNpcName = "Eleonore"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 140,
	lookHead = 114,
	lookBody = 66,
	lookLegs = 34,
	lookFeet = 53,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "ring") or MsgContains(message, "mission") then
		if player:getStorageValue(Storage.TheShatteredIsles.TheGovernorDaughter) < 1 then
			npcHandler:say({
				"My ring was stolen by a parrot, directly from my dressing table near the window. It flew to the nearby mountains and I fear my ring will be lost forever. Whoever returns it to me will be rewarded generously. ...",
				"I guess that evil parrot hid the ring somewhere on a high tree or a rock so that you might need a rake to get it."
			}, npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.DefaultStart, 1)
			player:setStorageValue(Storage.TheShatteredIsles.TheGovernorDaughter, 1)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.TheShatteredIsles.TheGovernorDaughter) == 2 then
			npcHandler:say("Oh, my beloved ring! Have you found it and want to return it to me?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.TheShatteredIsles.TheGovernorDaughter) == 3 and player:getStorageValue(Storage.TheShatteredIsles.TheErrand) < 1 then
			npcHandler:say("I would need some help in another matter. It is only a small errand. Are you interested?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "errand") then
		if player:getStorageValue(Storage.TheShatteredIsles.TheErrand) == 2 then
			npcHandler:say("Great, thank you! As promised, here are your 5 gold pieces. Is there ... anything left that you might want to discuss with me?", npc, creature)
			player:addMoney(5)
			player:setStorageValue(Storage.TheShatteredIsles.TheErrand, 3)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "peg leg") then
		if player:getStorageValue(Storage.TheShatteredIsles.TheErrand) == 3 then
			npcHandler:say("You have returned my ring and proven yourself as trustworthy. There is something I have to discuss with you. Are you willing to listen?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "raymond striker") then
		if player:getStorageValue(Storage.TheShatteredIsles.AccessToLagunaIsland) == 1 then
			npcHandler:say("<blushes> Oh, he is so wonderful. A very special man with a special place in my heart.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "mermaid") then
		if player:getStorageValue(Storage.TheShatteredIsles.AccessToLagunaIsland) == 1 then
			npcHandler:say("I can't thank you enough for freeing my beloved Ray from that evil spell. I am still shocked that a mermaid could steal his love that easily.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			if player:removeItem(6093, 1) then
				player:addMoney(150)
				npcHandler:say("Oh, thank you so much! Take this gold as a reward. ... which reminds me, I would need some help in another matter. It is only a small errand. Are you interested?", npc, creature)
				player:setStorageValue(Storage.TheShatteredIsles.TheGovernorDaughter, 3)
				npcHandler:setTopic(playerId, 2)
			else
				player:addMoney(150)
				npcHandler:say({
					"Ahh, now I understand... One of my suitors - a real chicken-heart - just brought back my ring. I was really surprised. Suddenly he shows brave attitude. But... It seems you lost it and he tries to take advantage. ...",
					"Thanks a lot anyways and take this gold as a reward. By the way, I would need some help in another matter. It is only a small errand. Are you interested?"
				}, npc, creature)
				player:setStorageValue(Storage.TheShatteredIsles.TheGovernorDaughter, 3)
				npcHandler:setTopic(playerId, 2)
			end
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Thank you! It is not a difficult matter but a rather urgent one. I need to send some money to a person in town. Would you be willing to run this small errand for me?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			player:addMoney(200)
			npcHandler:say("I was hoping that you'd agree. Please deliver these 200 gold pieces to the herbalist Charlotta in the south-western part of the town. If you return from this errand, I will grant you 5 gold pieces as reward for your efforts.", npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.TheErrand, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say({
				"I am glad to hear that. So please listen: Due to circumstances too complicated to explain now, I met Captain Ray Striker. He is ... a freedom fighter and would not find my father's acceptance, but we fell in love ...",
				"Even though he had to hide for a while, we have stayed in contact for a long time now. And our love grew even further against all odds ...",
				"However, recently we lost contact. I don't know what has happened to him and fear the worst ...",
				"We always have been aware that something terrible might happen to him due to his lifestyle. But perhaps there is a harmless explanation for the absence of messages <holds her tears back>. I have arranged a passage for you to Ray's hiding place ...",
				"Contact Captain Waverider, the old fisherman, and tell him the secret word 'peg leg'. He will make sure that you arrive safely ...",
				"Please look for Ray and find out what happened to him and why he was not able to answer. Return to me as soon as you have found something out. I wish you a good journey."
			}, npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.TheErrand, 4)
			player:setStorageValue(Storage.TheShatteredIsles.AccessToMeriana, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) >= 1 then
			npcHandler:say("Then no.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted. What brings you {here}?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh well.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
