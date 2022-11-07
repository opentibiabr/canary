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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if (MsgContains(message, "mission")) then
		if player:getStorageValue(Storage.Oramond.PeppermoonBell) < 1 then
			npcHandler:say({
			"I am afraid my supplies of peppermoon bell powder have gone flat again. Please provide me with the pollen of this flower. ...",
			"It only blooms underground in a cavern to the northwest. I will need 15 units of pollen. Bring them to me and we shall conduct a séance."}, npc, creature)
			player:setStorageValue(Storage.Oramond.PeppermoonBell, 1)
			player:setStorageValue(Storage.Oramond.PeppermoonBellCount, 0)
			npcHandler:setTopic(playerId, 0)
			if player:getStorageValue(Storage.Oramond.QuestLine) < 1 then
				player:setStorageValue(Storage.Oramond.QuestLine, 1)
			end
		elseif player:getStorageValue(Storage.Oramond.PeppermoonBell) == 1 then
		npcHandler:say("Ah! Did you bring me the peppermoon bell pollen I asked for?", npc, creature)
		npcHandler:setTopic(playerId, 1)
		end
	end
	if (MsgContains(message, "yes")) then
		if npcHandler:getTopic(playerId) == 1 then
			if player:getStorageValue(Storage.Oramond.PeppermoonBellCount) >= 15 then
				if player:getStorageValue(Storage.DarkTrails.Mission15) == 1 then
					npcHandler:say("Ah! Well done! Now we shall proceed with the seance, yes?", npc, creature)
					player:setStorageValue(Storage.Oramond.PeppermoonBell, -1)
					player:setStorageValue(Storage.Oramond.PeppermoonBellCount, -15)
					player:setStorageValue(Storage.DarkTrails.Mission15, 2)
					player:removeItem(21089, 15)
					npcHandler:setTopic(playerId, 2)
				else
					npcHandler:say("Ah! Well done! These 15 doses will suffice for now. Here, take this vote for your effort.", npc, creature)
					player:setStorageValue(Storage.Oramond.PeppermoonBell, -1)
					player:setStorageValue(Storage.Oramond.PeppermoonBellCount, -15)
					player:setStorageValue(Storage.Oramond.VotingPoints, player:getStorageValue(Storage.Oramond.VotingPoints) + 1)
					player:removeItem(21089, 15)
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
			"Do you feel something?"}, npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("Yes, take care, the gate is opening! Can you see a bright light?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("Ahhhhhhhh! ", npc, creature)
			player:setStorageValue(Storage.DarkTrails.Mission15, 3)
			player:teleportTo(Position(33490, 32037, 8))
			player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
			npcHandler:setTopic(playerId, 0)
		end
		elseif (MsgContains(message, "seance")) then
			if player:getStorageValue(Storage.DarkTrails.Mission15) == 3 then
				npcHandler:say("Splendid. Let me make the final preparations... There. Are you ready, too?", npc, creature)
				npcHandler:setTopic(playerId, 3)
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
