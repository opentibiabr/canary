local internalNpcName = "Gareth"
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
	lookHead = 41,
	lookBody = 0,
	lookLegs = 39,
	lookFeet = 20,
	lookAddons = 2,
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

local function greetCallback(npc, creature)
	local playerId = creature:getId()

	local player = Player(creature)

	if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) < 1 or player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) > 14 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome to the wonderful and only recently opened Museum of Tibian Arts! Free entrance for everybody, but patrons of the arts are wanted and favoured.")
	elseif player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "The Druid of Crunor has sent you? He seems to know that this new museum shines like a diamond. Enjoy your stay! If you like to {support} this place, talk to me.")
	elseif player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) > 1 and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) < 14 then
		npcHandler:setMessage(MESSAGE_GREET, "How is your {mission} going?")
	elseif player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 14 then
		npcHandler:setMessage(MESSAGE_GREET, "You again? How could you flee from the last floor. The cultists should have 'dealt' with you! That beats me. You have to leave this place right now. There's nothing more to say.")
	end

	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local value = 10000

	if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) < 2 then
		if MsgContains(message, "patrons") then
			npcHandler:say("If you like to, you can pay some gold to become a patron of the arts for this wonderful museum. The price is 10,000 gold. Your personal gain will be priceless. Do you want to {pay}?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif MsgContains(message, "pay") and npcHandler:getTopic(playerId) == 2 then
			if (player:getMoney() + player:getBankBalance()) >= value then
				npcHandler:say({
					"This is a very wise decision. You won't regret it. Congratulations! As your first task I like you to investigate the crime scene of a theft wich occurred last night. ...",
					"A very varuable artefact has been stolen. I open the door for you. You can find the room on the same floor as we are right now.",
				}, npc, creature)
				player:removeMoneyBank(value)
				player:addItem(25689, 1)
				player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission, 2)
				player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.AccessDoorInvestigation, 1)
				npcHandler:setTopic(playerId, 3)
			else
				npcHandler:say("You don't have enough money.", npc, creature)
				npcHandler:setTopic(playerId, 1)
			end
		end
	elseif MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 3 then
		npcHandler:say("They want us to buy the picture back. Unfortunately this artefact is so important that I don't see an alternative. Please got to Iwar in Kazordoon and pay the money.", npc, creature)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission, 4)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 5 then
		npcHandler:say({
			"Nice! I'm really happy to have the picture back. First of all I have to check if everything's fine. Then I'll put it back on its place. For now, I'd like you to find out if some rumours about fake pictures in the MOTA are true. ...",
			"Some say one of the small pictures in the entrance hall here is fake. For this reason you have to go to my friend {Angelo} and ask him to get a {magnifier} for the investigation.",
			"Then do your job here in the museum and come back.",
		}, npc, creature)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission, 6)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 9 then
		npcHandler:say("So the rumours are true. How could this happen? I'll keep the picture at its place until we've got a replacement. Please fo to {Angelo} and ask him if he has a new artefact for our museum.", npc, creature)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission, 10)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 11 then
		npcHandler:say({
			"You're back, nice. Angelo's team hasn't found an artefact yet? I thought the progress would be faster. Anyway thanks for you efforts. ...",
			"I have no work for you right now. If you like to, you can have a look at the last floor. I open the door for you.",
		}, npc, creature)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission, 12)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.AccessDoorGareth, 1)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 8 then
		npcHandler:say("You didn't investigate the pictures yet. Do your job and then come back.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	if MsgContains(message, "extension") then
		if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline) == 6 then
			npcHandler:say({
				"You have found an inscription I would like to translate for you. The tibianus cipher was used: ...",
				"Those who are accorded the honour to visit this exclusive place will smash their blindness and face the truth. ...",
				"Astonishingly, Dedoras from Cormaya has recently asked me for these kinds of inscriptions. For sure he is able to bring light into the darkness. You should visit him. ",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, 7)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline) == 1 then
			npcHandler:say("It is planned to extend the MOTA. But this will take time, because our workers have faced a little {problem}.", npc, creature)
			npcHandler:setTopic(playerId, 11)
		end
	elseif MsgContains(message, "problem") and npcHandler:getTopic(playerId) == 11 then
		if npcHandler:getTopic(playerId) == 11 then
			npcHandler:say({
				"Well, the situation is this: We have explored a portal, I would say a very aggressive, capriciously and dangerous one. Through this gate monsters entered the construction site and attacked our workers. ...",
				"With enormous effort they could have been dispersed. When my fellows tried to fill up the portal, it appeared again and again. So the only thing they could do was to stop working for the moment. Are you eventually interested in further investigations?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 12)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 12 then
		if npcHandler:getTopic(playerId) == 12 then
			npcHandler:say("You are a true patron of the arts! I have opened the construction site for you. Start your work right now!", npc, creature)
			player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, 2)
			npcHandler:setTopic(playerId, 0)
		end
	end

	if MsgContains(message, "bone") and player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline) == 4 then
		npcHandler:say({
			"Hmm, interesting. Several years ago I have read some books dealing with strange locking mechanisms. I think what you have found here is a bone lever of category 3. ...",
			"Normally this is not used because it is not secure. The production failed and the lever can always be activated as follows: back, back, up, right, left. Just have a try, it should work.",
		}, npc, creature)
		player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, 5)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
