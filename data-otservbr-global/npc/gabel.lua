local internalNpcName = "Gabel"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 80
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

	local missionProgress = player:getStorageValue(Storage.DjinnWar.MaridFaction.Mission03)
	if MsgContains(message, 'mission') then
		if player:getStorageValue(Storage.DjinnWar.MaridFaction.Mission02) ~= 2 then
			npcHandler:say({
				'So you would like to fight for us, would you. Hmm. ...',
				'That is a noble resolution you have made there, human, but I\'m afraid I cannot accept your generous offer at this point of time. ...',
				'Do not get me wrong, but I am not the kind of guy to send an inexperienced soldier into certain death! So you might ask around here for a more suitable mission.'
			}, npc, creature)

		elseif missionProgress < 1 then
			npcHandler:say({
				'Sooo. Fa\'hradin has told me about your extraordinary exploit, and I must say I am impressed. ...',
				'Your fragile human form belies your courage and your fighting spirit. ...',
				'I hardly dare to ask you because you have already done so much for us, but there is a task to be done, and I cannot think of anybody else who would be better suited to fulfill it than you. ...',
				'Think carefully, human, for this mission will bring you into real danger. Are you prepared to do us that final favour?'
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)

		elseif missionProgress == 1 then
			npcHandler:say('You haven\'t finished your final mission yet. Shall I explain it again to you?', npc, creature)
			npcHandler:setTopic(playerId, 1)

		elseif missionProgress == 2 then
			npcHandler:say('Have you found Fa\'hradin\'s lamp and placed it in Malor\'s personal chambers?', npc, creature)
			npcHandler:setTopic(playerId, 2)
		else
			npcHandler:say('There\'s no mission left for you, friend of the Marid. However, I have a task for you.', npc, creature)
		end

	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, 'yes') then
			npcHandler:say({
				'All right. Listen! Thanks to Rata\'mari\'s report we now know what Malor is up to: he wants to do to me what I have done to him - he wants to imprison me in Fa\'hradin\'s lamp! ...',
				'Of course, that won\'t happen. Now, we know his plans. ...',
				'But I am aiming at something different. We have learnt one important thing: At this point of time, Malor does not have the lamp yet, which means it is still where he left it. We need that lamp! If we get it back we can imprison him again! ...',
				'From all we know the lamp is still in the Orc King\'s possession! Therefore I want to ask you to enter thewell guarded halls over at Ulderek\'s Rock and find the lamp. ...',
				'Once you have acquired the lamp you must enter Mal\'ouquah again. Sneak into Malor\'s personal chambersand exchange his sleeping lamp with Fa\'hradin\'s lamp! ...',
				'If you succeed, the war could be over one night later! I and all djinn will be in your debt forever! May Daraman watch over you!'
			}, npc, creature)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission03, 1)

		elseif MsgContains(message, 'no') then
			npcHandler:say('As you wish.', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)

	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, 'yes') then
			npcHandler:say({
				'Daraman shall bless you and all humans! You have done us all a huge service! Soon, this awful war will be over! ...',
				'Know, that from now on you are considered one of us and are welcome to trade with Haroun and Nah\'bob whenever you want to!'
			}, npc, creature)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission03, 3)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.DoorToEfreetTerritory, 1)
			player:addAchievement('Marid Ally')

		elseif MsgContains(message, 'no') then
			npcHandler:say('Don\'t give up! May Daraman watch over you!', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "task") and player:getStorageValue(Storage.DjinnWar.MaridFaction.Mission03) == 3 then
		if player:getStorageValue(Storage.KillingInTheNameOf.GreenDjinnTask) < 0 or player:getStorageValue(Storage.KillingInTheNameOf.GreenDjinnTask) == 3 then
			npcHandler:say({
				"You've proven to be an experienced soldier, human. Though I still hope the war to be over soon, the Efreet are still threatening our tower. ...",
				"Thus we need your help in killing the green ones. If you kill 500 green djinns or Efreet for us, I'll reward you with bonus experience and some extra gold pieces. Do you agree?"}, npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.KillingInTheNameOf.GreenDjinnTask) == 0 then
			if player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.GreenDjinnCount) >= 500 then
				npcHandler:say({
					"You've done it, human! Daraman be praised! Take this for your efforts. ...",
					"What's left to do now is seek out Merikh the Slaughterer, an especially cruel Efreet. He hides somewhere in Yalahar. I don't know if you can kill him, but you should at least try."}, npc, creature)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.MerikhCount, 0)
				player:setStorageValue(Storage.KillingInTheNameOf.GreenDjinnTask, 1)
			else
				npcHandler:say("Come back when you kill 500 green djinns or Efreet.", npc, creature)
			end
		elseif player:getStorageValue(Storage.KillingInTheNameOf.GreenDjinnTask) == 2 then
			npcHandler:say({
				"So you've been there and faced Merikh the Slaughterer! Whether you killed him or not, I hope your presence at least scared him. He is so mighty that we can only hope to truly defeat him one day. ...",
				"When you've recovered from your fight and would like to kill green djinns in our service again, just talk to me about that task."}, npc, creature)
			player:setStorageValue(Storage.KillingInTheNameOf.GreenDjinnTask, 3)
			player:addExperience(10000, true)
			player:addMoney(5000)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 3 then
		npcHandler:say("All right. May Daraman bless your hunt, human.", npc, creature)
		player:setStorageValue(JOIN_STOR, 1)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.GreenDjinnCount, 0)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GreenDjinnCount, 0)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.EfreetCount, 0)
		player:setStorageValue(Storage.KillingInTheNameOf.GreenDjinnTask, 0)
	end
	return true
end

-- Greeting
keywordHandler:addGreetKeyword({"djanni'hah"}, {npcHandler = npcHandler, text = "Welcome, human |PLAYERNAME|, to our humble abode."})

npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, stranger. May Uman open your minds and your hearts to Daraman's wisdom!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell, stranger. May Uman open your minds and your hearts to Daraman's wisdom!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
