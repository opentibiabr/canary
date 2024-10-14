local internalNpcName = "Barnabas Dee"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 432,
	lookHead = 0,
	lookBody = 95,
	lookLegs = 117,
	lookFeet = 98,
	lookAddons = 1,
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

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.ThePowderOfTheStars.Mission) == 1 then
			npcHandler:say("Do you already have 15 units of blue pollen with you?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.ThePowderOfTheStars.Mission) < 1 then
			npcHandler:say({
				"I am afraid my supplies of peppermoon bell powder have gone flat again. Please provide me with the pollen of this flower. ...",
				"It only blooms underground in a cavern to the northwest. I will need 15 units of pollen. Bring them to me and we shall conduct a seance.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.ThePowderOfTheStars.Mission, 1)
			if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.QuestLine) < 1 then
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.QuestLine, 1)
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "seance") and player:getStorageValue(Storage.Quest.U10_50.OramondQuest.ThePowderOfTheStars.Mission) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission16) < 1 then
		npcHandler:say("Ah! Did you bring me the peppermoon bell pollen I asked for?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			if player:getItemCount(21089) >= 15 then
				if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission15) == 1 then
					npcHandler:say("Ah! Well done! Now we shall proceed with the seance, yes?", npc, creature)
					player:setStorageValue(Storage.Quest.U10_50.OramondQuest.ThePowderOfTheStars.Mission, -1)
					player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission15, 2)
					player:removeItem(21089, 15)
					npcHandler:setTopic(playerId, 2)
				else
					npcHandler:say("Ah! Well done! These 15 doses will suffice for now. Here, take this vote for your effort.", npc, creature)
					player:setStorageValue(Storage.Quest.U10_50.OramondQuest.ThePowderOfTheStars.Mission, -1)
					player:removeItem(21089, 15)
					local currentVotingPoints = player:getStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints)
					if currentVotingPoints == -1 then
						player:setStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints, 1)
					else
						player:setStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints, currentVotingPoints + 1)
					end
					npcHandler:setTopic(playerId, 0)
				end
			else
				npcHandler:say("No no no, I need 15 doses of freshly harvested pollen! Please, harvest those 15 doses yourself, to make absolutely sure you have first-rate quality. I am afraid nothing less will do.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Splendid. Let me make the final preparations... There. Are you ready, too?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say({
				"So let us begin. Please concentrate with me. Concentrate! ...",
				"Concentrate! ...",
				"Concentrate! ...",
				"Concentrate! ...",
				"Concentrate! ...",
				"Do you feel something?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("Yes, take care, the gate is opening! Can you see a bright light?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("Ahhhhhhhh! ", npc, creature)
			player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission15, 3)
			player:teleportTo(Position(33467, 32048, 8))
			player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
			npcHandler:setTopic(playerId, 0)
		end
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "Welcome to my humble abode. If you come for new sorcerer {spells}, you have come to the right place.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care, child")
npcHandler:setMessage(MESSAGE_WALKAWAY, "'The impetuosity of youth', as my friend Mordecai would say.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
