local internalNpcName = "Sinclair"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 133,
	lookHead = 21,
	lookBody = 38,
	lookLegs = 19,
	lookFeet = 95,
	lookAddons = 1,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Indeed, there has to be some other way." },
	{ text = "Mmh, interesting." },
	{ text = "Yes indeed, all of the equipment should be checked and calibrated regularly." },
	{ text = "No, we have to give this another go." },
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

	if MsgContains(message, "mission") then
		local qStorage = player:getStorageValue(Storage.Quest.U8_7.SpiritHunters.Mission01)
		if qStorage == 3 then
			npcHandler:say("So, did you find anything worth examining? Did you actually catch a ghost?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif qStorage == 2 then
			npcHandler:say({ "So you have passed Spectulus' acceptance test. Well, I'm sure you will live up to that. ...", "We are trying to get this business up and running and need any help we can get. Did he tell you about the spirit cage?" }, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif qStorage > 2 then
			npcHandler:say("You already done this quest.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif qStorage < 2 then
			npcHandler:say("Talk research with spectulus to take some mission.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Excellent. Now we need to concentrate on testing that thing. The spirit cage has been calibrated based on some tests we made - as well as your recent findings over at the graveyard. ...",
				"Using the device on the remains of a ghost right after its defeat should capture it inside this trap. We could then transfer it into our spirit chamber which is in fact a magical barrier. ..",
				"At first, however, we need you to find a specimen and bring it here for us to test the capacity of the device. Are you ready for this?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Good, now all you need to do is find a ghost, defeat it and catch its very essence with the cage. Once you have it, return to me and Spectulus and I will move it into our chamber device. Good luck, return to me as soon as you are prepared.", npc, creature)
			player:setStorageValue(Storage.Quest.U8_7.SpiritHunters.Mission01, 3)
			player:addItem(4050, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:getStorageValue(Storage.Quest.U8_7.SpiritHunters.CharmUse) == 1 then
				npcHandler:say({
					"Fascinating, let me see. ...",
					"Amazing! I will transfer this to our spirit chamber right about - now! ...",
					"Alright, the device is holding it. The magical barrier should be able to contain nearly 20 times the current load. That's a complete success! Spectulus, are you seeing this? We did it! ...",
					"Well, you did! You really helped us pulling this off. Thank you Lord Stalks! ...",
					"I doubt we will have much time to hunt for new specimens ourselves in the near future. If you like, you can continue helping us by finding and capturing more and different ghosts. Just talk to me to receive a new task.",
				}, npc, creature)
				player:setStorageValue(Storage.Quest.U8_7.SpiritHunters.Mission01, 4)
				player:addExperience(500, true)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Go and use the machine in a dead ghost!", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say({
				"Magnificent! Alright, we will at least need 5 caught ghosts. We will pay some more if you can catch 5 nightstalkers. Of course you will earn some more if you bring us 5 souleaters. ...",
				"I heard they dwell somewhere in that new continent - Zao? Well anyway, if you feel you've got enough, just return with what you've got and we will see. Good luck! ...",
				"Keep in mind that the specimens are only of any worth to us if the exact amount of 5 per specimen is reached. ...",
				"Furhtermore, to successfully bind Nightstalkers to the cage, you will need to have caught at least 5 Ghosts. To bind Souleaters, you will need at least 5 Ghosts and 5 Nightstalkers. ...",
				"The higher the amount of spirit energy in the cage, the higher its effective capacity. Oh and always come back and tell me if you lose your spirit cage.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U8_7.SpiritHunters.Mission01, 5)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("Good, of course you will also receive an additional monetary reward for your troubles. Are you fine with that?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif npcHandler:getTopic(playerId) == 6 then
			local nightstalkers, souleaters, ghost = player:getStorageValue(Storage.Quest.U8_7.SpiritHunters.NightstalkerUse), player:getStorageValue(Storage.Quest.U8_7.SpiritHunters.SouleaterUse), player:getStorageValue(Storage.Quest.U8_7.SpiritHunters.GhostUse)
			if nightstalkers >= 4 and souleaters >= 4 and ghost >= 4 then
				npcHandler:say("Alright, let us see how many ghosts you caught!", npc, creature)
				player:setStorageValue(Storage.Quest.U8_7.SpiritHunters.Mission01, 6)
				player:addExperience(10000, true)
				player:addItem(3035, 60)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You didnt catch the ghost pieces.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif MsgContains(message, "research") then
		local qStorage = player:getStorageValue(Storage.Quest.U8_7.SpiritHunters.Mission01)
		if qStorage == 4 then
			npcHandler:say({
				"We are still in need of more research concerning environmental as well as psychic ecto-magical influences. Besides more common ghosts we also need some of the harder to come by nightstalkers and - if you're really hardboiled - souleaters. ...",
				"We will of course pay for every ghost you catch. You will receive more if you hunt for some of the tougher fellows - but don't overdue it. What do you say?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif qStorage == 5 then
			npcHandler:say(" Alright you found something! Are you really finished hunting out there?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings |PLAYERNAME|. I have - very - little time, please make it as short as possible. I may be able to help you if you are here to help us with any of our tasks or missions.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Goodbye and good luck |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Goodbye and good luck |PLAYERNAME|.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcType:register(npcConfig)
