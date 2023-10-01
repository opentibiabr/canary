local internalNpcName = "Daniel Steelsoul"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 73
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
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(14, 1000, -10)

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if isInArray({"fuck", "idiot", "asshole", "ass", "fag", "stupid", "tyrant", "shit", "lunatic"}, message) then
		npcHandler:say("Take this!", npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
		player:addCondition(condition)
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc(creature)
	elseif MsgContains(message, "mission") then
		if player:getStorageValue(Storage.TibiaTales.AgainstTheSpiderCult) < 1 then
			npcHandler:setTopic(playerId, 1)
			npcHandler:say("Very good, we need heroes like you to go on a suici.....er....to earn respect of the authorities here AND in addition get a great reward for it. Are you interested in the job?", npc, creature)
		elseif player:getStorageValue(Storage.TibiaTales.AgainstTheSpiderCult) == 5 then
			player:setStorageValue(Storage.TibiaTales.AgainstTheSpiderCult, 6)
			npcHandler:setTopic(playerId, 0)
			player:addItem(814, 1)
			npcHandler:say("What? YOU DID IT?!?! That's...that's...er....<drops a piece of paper. You see the headline 'death certificate'> like I expected!! Here is your reward.", npc, creature)
		end
	elseif MsgContains(message, "task") then
		if player:getStorageValue(Storage.KillingInTheNameOf.TrollTask) == 0 then
			if player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.TrollCount) >= 100 then
				npcHandler:say("Very nice, |PLAYERNAME|. That will push the trolls' forces back a little. Here is your reward!", npc, creature)
				player:addExperience(200, true)
				player:addMoney(200)
				player:setStorageValue(Storage.KillingInTheNameOf.TrollTask, 1)
				return true
			else
				npcHandler:say("Your current task is to kill 100 trolls. You have already killed "..player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.TrollCount).." of them. Keep going!", npc, creature)
				return true
			end
		elseif player:getStorageValue(Storage.KillingInTheNameOf.GoblinTask) == 0 then
			if player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.GoblinCount) >= 150 then
				npcHandler:say("Congratulations, you've fought well against the goblin plague. Thank you! Here is your reward!", npc, creature)
				player:addExperience(300, true)
				player:addMoney(250)
				player:setStorageValue(Storage.KillingInTheNameOf.GoblinTask, 1)
				return true
			else
				npcHandler:say("Your current task is to kill 150 goblins. You have already killed "..player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.GoblinCount).." of them. Keep going!", npc, creature)
				return true
			end
		elseif player:getStorageValue(Storage.KillingInTheNameOf.RotwormTask) == 0 then
			if player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.RotwormCount) >= 300 then
				npcHandler:say("Well done! Thanks to you the city is a bit safer. Here's your reward!", npc, creature)
				player:addExperience(1000, true)
				player:addMoney(400)
				player:setStorageValue(Storage.KillingInTheNameOf.RotwormTask, 1)
				return true
			else
				npcHandler:say("Your current task is to kill 300 rotworms. You have already killed "..player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.RotwormCount).." of them. Keep going!", npc, creature)
				return true
			end
		elseif player:getStorageValue(Storage.KillingInTheNameOf.CyclopsTask) == 0 then
			if player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.CyclopsCount) >= 500 then
				npcHandler:say("Very good job, |PLAYERNAME|. You've been a great help. Here's your reward!", npc, creature)
				player:addExperience(3000, true)
				player:addMoney(800)
				player:setStorageValue(Storage.KillingInTheNameOf.CyclopsTask, 1)
				return true
			else
				npcHandler:say("Your current task is to kill 500 cyclops. You have already killed "..player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.CyclopsCount).." of them. Keep going!", npc, creature)
				return true
			end
		end
		if player:getLevel() < 20 then
			if player:getStorageValue(Storage.KillingInTheNameOf.TrollTask) < 0 then
				npcHandler:say({
					"The trolls living west of our city have become quite a nuisance lately. Not that they are really dangerous to us, but still, we must show them that there's a line they shouldn't cross. ...",
					"I want you to kill 100 of them. If you succeed, I'll provide you some pretty coins and experience. Are you willing to take on this task?"}, npc, creature)
				npcHandler:setTopic(playerId, 2)
			elseif player:getStorageValue(Storage.KillingInTheNameOf.TrollTask) == 1 and player:getStorageValue(Storage.KillingInTheNameOf.GoblinTask) == 1 then
				npcHandler:say("Currently there is no new task I could entrust you with. However, you can repeat killing {goblins} or {trolls}. Which would you prefer?", npc, creature)
				npcHandler:setTopic(playerId, 4)
			elseif player:getStorageValue(Storage.KillingInTheNameOf.TrollTask) == 1 then
				npcHandler:say({
						"It's not only the trolls invading from the west coast. <sighs> Goblins also have a lair there where they constantly prepare for their next attack. ...",
						"If you could kill 150 goblins for us, that'd be a good start. Would you be willing to help us in this matter?"}, npc, creature)
				npcHandler:setTopic(playerId, 3)
			end
		end
		if player:getLevel() >= 30 and player:getLevel() < 60 then
			if player:getStorageValue(Storage.KillingInTheNameOf.CyclopsTask) < 0 or player:getStorageValue(Storage.KillingInTheNameOf.CyclopsTask) == 1 then
				npcHandler:say({
				"We've successfully driven the minotaurs off this island, but the underground city of the cyclopes - Cyclopolis - is still standing. ...",
				"We're always looking for adventurers who'd help us decimate the number of cyclopes. Will you assist the city of Edron by killing 500 of them?"}, npc, creature)
				npcHandler:setTopic(playerId, 6)
				return true
			end
		end
		if player:getLevel() >= 20 and player:getLevel() < 40 then
			if player:getStorageValue(Storage.KillingInTheNameOf.RotwormTask) < 0 or player:getStorageValue(Storage.KillingInTheNameOf.RotwormTask) == 1 then
				npcHandler:say("Maybe you have noticed the numerous rotworms that burrowed under Edron. They're quite a pest. You look strong enough to be able to vanquish a few for us. Do you think you can kill 300 rotworms?", npc, creature)
				npcHandler:setTopic(playerId, 5)
				return true
			end
		end
	elseif MsgContains(message, "trolls") and npcHandler:getTopic(playerId) == 4 then
		npcHandler:say("I'm pleased with your eagerness. To reach your goal, you have to kill the brown trolls and troll champions. Good luck!", npc, creature)
		player:setStorageValue(JOIN_STOR, 1)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.TrollCount, 0)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.TrollCount, 0)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.TrollChampionCount, 0)
		player:setStorageValue(Storage.KillingInTheNameOf.TrollTask, 0)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "goblins") and npcHandler:getTopic(playerId) == 4 then
		npcHandler:say("Fine then! You can kill normal goblins as well as scavengers and assassins on the lower levels, but beware, they are a bit harder. Have a good hunt!", npc, creature)
		player:setStorageValue(JOIN_STOR, 1)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.GoblinCount, 0)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GoblinCount, 0)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GoblinScavengerCount, 0)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GoblinAssassinCount, 0)
		player:setStorageValue(Storage.KillingInTheNameOf.GoblinTask, 0)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
			player:setStorageValue(Storage.TibiaTales.AgainstTheSpiderCult, 1)
			npcHandler:say({
				"Very well, maybe you know that the orcs here in Edron learnt to raise giant spiders. It is going to become a serious threat. ...",
				"The mission is simple: go to the orcs and destroy all spider eggs that are hatched by the giant spider they have managed to catch. The orcs are located in the south of the western part of the island."}, npc, creature)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("I'm pleased with your eagerness. To help you find the trolls' den, I mark both the entrance to the passage and their lair on your map. To reach your goal, you have to kill the normal brown trolls, but troll champions count too. Good luck!", npc, creature)
			player:setStorageValue(JOIN_STOR, 1)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.TrollCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.TrollCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.TrollChampionCount, 0)
			player:setStorageValue(Storage.KillingInTheNameOf.TrollTask, 0)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Fine then! I'll show you the Goblin den on your map, here. Use the same passage you did when hunting for trolls. You can kill normal goblins as well as scavengers and assassins on the lower levels, but beware, they are a bit harder.", npc, creature)
			player:setStorageValue(JOIN_STOR, 1)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.GoblinCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GoblinCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GoblinScavengerCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GoblinAssassinCount, 0)
			player:setStorageValue(Storage.KillingInTheNameOf.GoblinTask, 0)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say({
				"Great! You can find rotworms south of the city, for example. Take a rope and shovel and look for loose stone piles to dig open. ...",
				"You can kill normal rotworms as well as their larger brothers, the carrion worms, to fulfil your task. Be careful and good luck!"}, npc, creature)
			player:setStorageValue(JOIN_STOR, 1)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.RotwormCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.RotwormCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.CarrionWormnCount, 0)
			player:setStorageValue(Storage.KillingInTheNameOf.RotwormTask, 0)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 6 then
			npcHandler:say({
				"I'm impressed with your dedication and courage. I can't show you the exact location of cyclopolis on the map though. It is somewhere north of Edron city. ...",
				"Exit the city and go through a mountain passage leading to the west, then keep on heading north. The entrance is marked by large, obelisk-like stones arranged in a circle. ...",
				"You can kill normal cyclopes as well as drones and smiths to reach your goal. Good hunting!"}, npc, creature)
			player:setStorageValue(JOIN_STOR, 1)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.CyclopsCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.CyclopsCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.CyclopsDroneCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.CyclopsSmithCount, 0)
			player:setStorageValue(Storage.KillingInTheNameOf.CyclopsTask, 0)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Another option if you want to do a task for Edron would be to killing 150 goblins. Would that suit your taste better?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Another option if you want to do a task for Edron would be to repeat killing 100 trolls. Would that suit your taste better?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 5 and player:getLevel() >= 30 then
			if player:getStorageValue(Storage.KillingInTheNameOf.CyclopsTask) < 0 then
				npcHandler:say("Another option if you want to do a task for Edron would be to killing 500 cyclops. Would that suit your taste better?", npc, creature)
				npcHandler:setTopic(playerId, 6)
			end
		elseif npcHandler:getTopic(playerId) == 6 and player:getLevel() < 40 then
			if player:getStorageValue(Storage.KillingInTheNameOf.RotwormTask) < 0 or player:getStorageValue(Storage.KillingInTheNameOf.RotwormTask) == 1 then
				npcHandler:say("Another option if you want to do a task for Edron would be to killing 300 rotworms. Would that suit your taste better?", npc, creature)
				npcHandler:setTopic(playerId, 5)
			end
		end
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the governor of this isle, Edron, and grandmaster of the Knights of Banor's Blood."})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = "LONG LIVE THE KING!"})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Greetings and {Banor} be with you, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_FAREWELL, "PRAISE TO BANOR!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "PRAISE TO BANOR!")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
