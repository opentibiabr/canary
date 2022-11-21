local internalNpcName = "Angelo"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 145,
	lookHead = 96,
	lookBody = 114,
	lookLegs = 120,
	lookFeet = 101,
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

local function greetCallback(npc, creature)
	local playerId = creature:getId()

	local player = Player(creature)

	-- Se estiver na 1º missão
	if player:getStorageValue(Storage.CultsOfTibia.Life.Mission) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "The Druid of Crunor? He told you that a new cave appeared here? That's right. I'm the head of a {project} that tries to find out more about this new {area}.")
	elseif player:getStorageValue(Storage.CultsOfTibia.Life.Mission) == 9 then
		npcHandler:setMessage(MESSAGE_GREET, "Just get out of my way! You killed this beautiful creature. I have nothing more to say. Damn druid of Crunor!")
	-- Se já tiver após a 1º missão
	elseif player:getStorageValue(Storage.CultsOfTibia.Life.Mission) > 1 then
		npcHandler:setMessage(MESSAGE_GREET, "How is your {mission} going?")
	end
	return true
end
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end


-- Sequência para pegar a quest
	if MsgContains(message, "project") then
		npcHandler:say({"The project is called 'Sandy {Cave} Project' and is funded by the {MoTA}. Its goal is the investigation of this {cave}."}, npc, creature)
		npcHandler:setTopic(playerId, 2)

	elseif npcHandler:getTopic(playerId) == 2 and MsgContains(message, "mota") then
		npcHandler:say({"MoTA is short for the recently founded Museum of Tibian Arts. We work together in close collaboration. New {results} are communicated to the museum instantly."}, npc, creature)
		npcHandler:setTopic(playerId, 3)

	elseif npcHandler:getTopic(playerId) == 3 and MsgContains(message, "results") then
		npcHandler:say({"We have no scientific results so far to reach our {goal}, because my workers aren't back yet. Should I be {worried}?"}, npc, creature)
		npcHandler:setTopic(playerId, 4)

	elseif npcHandler:getTopic(playerId) == 4 and MsgContains(message, "yes") then
		npcHandler:say({"Alright. I have to find out why they don't return. But I'm old and my back aches. Would you like to go there and look for my workers?"}, npc, creature)
		npcHandler:setTopic(playerId, 5)

	elseif npcHandler:getTopic(playerId) == 5 and MsgContains(message, "yes") then
		npcHandler:say({"Fantastic! Go there and then tell me what you've seen. I've oppened the door for you. Take care of yourself!"}, npc, creature)
		player:setStorageValue(Storage.CultsOfTibia.Life.Mission, 2)
		player:setStorageValue(Storage.CultsOfTibia.Life.AccessDoor, 1)
		npcHandler:setTopic(playerId, 0)

	-- Inútil
	elseif npcHandler:getTopic(playerId) == 2 and MsgContains(message, "cave") then
		npcHandler:say({"We don't know exactly why this cave has now exposed an entry via the {dark pyramid}. It seems that the cave already existed for a long time, however, without a connection to our world. Maybe some smaller earth movements have changed the situation."}, npc, creature)
		npcHandler:setTopic(playerId, 11)

	elseif npcHandler:getTopic(playerId) == 11 and MsgContains(message, "dark pyramid") then
		npcHandler:say({"We don't know yet to wich extent the cave and the dark pyramid belong together. Thisi s what we try to find out. Maybe the history of this place has to be rewritten."}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	-- Depois de encontrar o Oasis
	if player:getStorageValue(Storage.CultsOfTibia.Life.Mission) == 3 then
		if MsgContains(message, "mission") then
			npcHandler:say({"The scientists are still missing? You just found some strange green shining mummies and a big oasis? I give you this analysis tool for the water of the oasis. Maybe that's the key. Could you bring me a sample of this water?"}, npc, creature)
			npcHandler:setTopic(playerId, 15)
		elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 15 then
			npcHandler:say({"Very good. Hopefully analysing this sample will get us closer to the solution of this mistery."}, npc, creature)
			player:addItem(25305, 1)
			player:setStorageValue(Storage.CultsOfTibia.Life.Mission, 4)
		end
	end

-- Depois de usar o analyzing tool
	if player:getStorageValue(Storage.CultsOfTibia.Life.Mission) == 5 then
		if MsgContains(message, "mission") then
			npcHandler:say({"Do you have the sample I asked you for?"}, npc, creature)
			npcHandler:setTopic(playerId, 16)
		elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 16 then
			npcHandler:say({"Thanks a lot. Let me check the result. Well, I think you need the counteragent. Please apply it to the oasis!"}, npc, creature)
			player:addItem(25304, 1)
			player:setStorageValue(Storage.CultsOfTibia.Life.Mission, 6)
		end
	end

-- Depois de usar o conteragent
	if player:getStorageValue(Storage.CultsOfTibia.Life.Mission) == 7 then
		if MsgContains(message, "mission") then
			npcHandler:say({"What has happened? You applied the counteragent to the oasis and then it was destroyed by a sandstorm? Keep on investigating the place."}, npc, creature)
			npcHandler:setTopic(playerId, 17)
		end
	end

-- after killing the boss the sandking
	if player:getStorageValue(Storage.CultsOfTibia.Life.Mission) == 8 then
		npcHandler:say("Just get out of my way! You killed this beautiful creature. I have nothing more to say. Damn druid of Crunor!", npc, creature)
		player:setStorageValue(Storage.CultsOfTibia.Life.Mission, 9)
	end
----------------------------------------- MOTA -------------------------------
	-- Pedindo o Magnifier de Gareth
	if player:getStorageValue(Storage.CultsOfTibia.MotA.Mission) == 6 then
		if MsgContains(message, "magnifier") then
			npcHandler:say({"{Gareth} told you that there are rumours about fake artefacts in the MoTA? And it is your task to check that with a magnifier? I see. I don't need one right now, so you can have one of mine. You find one in the crate over there."}, npc, creature)
			player:setStorageValue(Storage.CultsOfTibia.MotA.Mission, 7)
		end
	end

	-- Pedindo a pintura de Gareth para Angelo
	if player:getStorageValue(Storage.CultsOfTibia.MotA.Mission) == 10 then
		if MsgContains(message, "picture") then
			npcHandler:say({"So you found out that one artefact in the MoTA is fake? And {Gareth} sent you to me to get a new artefact as a replacement? Sorry, I hardly know you so I don't trust you. I won't help you with that!"}, npc, creature)
			player:setStorageValue(Storage.CultsOfTibia.MotA.Mission, 11)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
