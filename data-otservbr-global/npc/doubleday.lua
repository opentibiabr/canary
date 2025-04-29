local internalNpcName = "Doubleday"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 132,
	lookHead = 20,
	lookBody = 57,
	lookLegs = 39,
	lookFeet = 20,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "experiment") then
		if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.Probing.Mission) == -1 then
			npcHandler:say({
				"Yes, well I am working on something very time-consuming at the moment. You see, a lot of us don't have time to go out much, to converse even just to meet and talk about recent discoveries. ...",
				"So I thought about a device to help communication in this wonderful city. I already had a helper, he was easily... 'stressed' and quit. Didn't have time to find a new one. ...",
				"So, if you'd like to help - there is a lot to do for me to bring my plans to fruition - and if you help me, you will earn my {votes} for the {magistrate} in turn! Are you in?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Good! Quite good! You know, there are actually several things I want you to address. ...",
				"First, there is the problem with {communication}, second I need someone to {probe} part of the sewers and last - {combinatorics}!",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Very nice, there you go! Just bring me the printout from the probe after deploying it! You can request a new probing {device} or a new {detector} if you lose it - but it takes some time for me to get a new one ready so be careful with that stuff.", npc, creature)
			player:addItem(21192, 1)
			player:addItem(21208, 1)
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.Probing.Mission, 1)
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.Probing.MonoDetector, os.time() + 30 * 60)
			if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.QuestLine) < 1 then
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.QuestLine, 1)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("Hey, let's try to be reasonable here, alright? That's a bit too much for what you did, isn't it? It may seem that way but the number of votes I can offer isn't limitless.", npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif npcHandler:getTopic(playerId) == 8 then
			npcHandler:say("Good, you just gained 1 genuine votes in the magistrate!", npc, creature)
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.Probing.Mission, -1)
			local currentVotingPoints = player:getStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints)
			if currentVotingPoints == -1 then
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints, 1)
			else
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints, currentVotingPoints + 1)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 9 then
			npcHandler:say("Alright, there you go - please, try to be more careful with my equipment next time!", npc, creature)
			player:addItem(21192, 1)
			player:addItem(21208, 1)
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.Probing.MonoDetector, os.time() + 30 * 60)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "probe") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"Because of my {experiments} with the {glooth}, some things in the new sewers of Rathleton aren't exactly 'in order' anymore - if you follow me. A sort of mushroom has formed down there and some... 'things' now nest in the lower drainage areas. ...",
				"Could you please just go down there and check if this is caused by... my... version of the {glooth}? You know, just some experiments I did to alter the basic elemental structure of the {glooth}, nothing personal. ...",
				"If you'd just take this very tiny probing device I designed to analyse the {coloured glooth} and, you know, go down there and place it - oh, and I'll also give you this really tiny {detector}, modified to find a spot where to place the {probe} - so?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.Probing.Mission) == 2 then
			npcHandler:say({
				"Very good, these readings do tell me a lot - the coloured glooth may be instable but it has some... 'interesting' effects on its surroundings. Oh - no worries, you will be perfectly safe. I will also take back my detector now, thanks. ..",
				"Feel free to help me deploy more probes whenever you like.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.Probing.Mission, 3)
			player:setStorageValue(Storage.Quest.U10_50.DarkTrails.OramondTaskProbing, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "exchange") then
		if npcHandler:getTopic(playerId) == 6 then
			npcHandler:say("Well, let's see, you helped me 1 times before exchanging any votes - how many votes do you want me to give you in exchange?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.Probing.Mission) == 3 then
			npcHandler:say("Well, let's see, you helped me 1 times before exchanging any votes - how many votes do you want me to give you in {exchange}?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "2") then
		if npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("Alright then, that's 2 vote(s) you want - I won't take them back, are you sure?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "1") then
		if npcHandler:getTopic(playerId) == 7 then
			npcHandler:say("Alright then, that's 1 vote(s) you want - I won't take them back, are you sure?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		end
	elseif MsgContains(message, "mono detector") then
		if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.Probing.MonoDetector) <= os.time() then
			npcHandler:say({
				"To actually 'find' a suitable location to deploy the probing device for my measurements, you should use my mono detector. The device detects singular chemical structures of any material or fabric I feed it with and signals it! ...",
				"If you have lost your detector or your probing device, I can hand out another - it will take some time, however. Do you need a new one?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 9)
		else
			npcHandler:say("You must wait until the detector is ready again.", npc, creature)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello there, hmm just... just wait right there, I'll be with you in a second. Just getting this {experiment} done...")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
