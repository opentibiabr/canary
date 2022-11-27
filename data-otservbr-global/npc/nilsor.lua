local internalNpcName = "Nilsor"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 154,
	lookHead = 41,
	lookBody = 116,
	lookLegs = 95,
	lookFeet = 114,
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

	if MsgContains(message, "svargrond") or MsgContains(message, "passage") then
		npcHandler:say("Do you want to travel to Svargrond?", npc, creature)
		npcHandler:setTopic(playerId, 10)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 10 then
			player:teleportTo(Position(32312, 31074, 7))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:setTopic(playerId, 0)
		end
	end

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 20 then
			npcHandler:say({
				"I am in dire need of help. A plague has befallen my dogs. I even called a druid of Carlin for help but all he could do was to recommend some strong medicine ...",
				"The thing is the ingredients of the medicine are extremely rare and some only exist in far away and distant lands. If you could help me collecting the ingredients, I would be eternally grateful ...",
				"Are you willing to help me?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 28 then
			npcHandler:say({
				"Thank you. Now I have all necessary ingredients. As a reward I grant you the use of our dog sled, which is located to the east of here. ...",
				"The dogs can be a bit moody, but if you always carry some ham with you there shouldnt be any problems. Oh, and Hjaern might have a mission for you. So maybe you go and talk to him."
			}, npc, creature)
			player:setStorageValue(Storage.TheIceIslands.Questline, 29)
			player:setStorageValue(Storage.TheIceIslands.Mission07, 1) -- Questlog The Ice Islands Quest, The Secret of Helheim
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) > 20 and player:getStorageValue(Storage.TheIceIslands.Questline) < 28 then
			npcHandler:say("What for ingredient do you have?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("I have now no mission for you.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "waterskin") then
		npcHandler:say("Do you want to buy a waterskin for 25 gold?", npc, creature)
		npcHandler:setTopic(playerId, 2)

	elseif MsgContains(message, "cactus") then
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 21 then
			npcHandler:say("You will find this kind of cactus at places that are called deserts. Only an ordinary kitchen knife will be precise enough to produce the ingredient weneed. Do you have a part of that cactus with you?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "water") then
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 22 then
			npcHandler:say({
				"You will need a specially prepared waterskin to collect the water. You can buy one from me ...",
				"Use it on a geyser that is NOT active. The water of active geysers is far too hot. You can find inactive geysers on Okolnir. Do you have some geyser water with you?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "sulphur") then
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 23 then
			npcHandler:say("I need fine sulphur of an inactive lava hole. No other sulphur will do. Use an ordinary kitchen spoon on an inactive lava hole. Do you have fine sulphur with you?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "herb") then
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 24 then
			npcHandler:say("The frostbite herb is a local plant but its quite rare. You can find it on mountain peaks. You will need to cut it with a fine kitchen knife. Do you have a frostbite herb with you?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		end
	elseif MsgContains(message, "blossom") then
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 25 then
			npcHandler:say("The purple kiss is a plant that grows in a place called jungle. You will have to use a kitchen knife to harvest its blossom. Do you have a blossom of a purple kiss with you?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		end
	elseif MsgContains(message, "hydra tongue") then
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 26 then
			npcHandler:say("The hydra tongue is a common pest plant in warmer regions. You might find one in a shop. Do you have a hydra tongue with you?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		end
	elseif MsgContains(message, "spores") then
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 27 then
			npcHandler:say("The giant glimmercap mushroom exists in caves and other preferably warm and humid places. Use an ordinary kitchen spoon on a mushroom to collectits spores. Do you have the glimmercap spores?", npc, creature)
			npcHandler:setTopic(playerId, 9)
		end

	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"A thousand thanks in advance. I need no less than 7 ingredients for the cure. You can ask me about each specifically ...",
				"I need a part of the sun adorer cactus, a vial of geyser water, sulphur of a lava hole, a frostbite herb, a blossom of a purple kiss, a hydra tongue and spores of a giant glimmercap mushroom ...",
				"Turn them in individually by talking about them to me. As soon as I obtained them all, talk to me about the medicine. First time bring a Part of the Sun Adorer {Cactus}."
			}, npc, creature)
			player:setStorageValue(Storage.TheIceIslands.Questline, 21)
			player:setStorageValue(Storage.TheIceIslands.Mission06, 1) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:getMoney() + player:getBankBalance() >= 25 then
				player:removeMoneyBank(25)
				npcHandler:say("Here you are. A waterskin!", npc, creature)
				player:addItem(7286, 1)
			else
				npcHandler:say("You don't have enough money.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)

		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(7245, 1) then
				npcHandler:say("Thank you for this ingredient. Now bring me Geyser {Water} in a Waterskin. ", npc, creature)
				player:setStorageValue(Storage.TheIceIslands.Questline, 22)
				player:setStorageValue(Storage.TheIceIslands.Mission06, 2) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				npcHandler:say("Come back when you have the ingredient.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:removeItem(7246, 1) then
				npcHandler:say("Thank you for this ingredient. Now bring me Fine {Sulphur}.", npc, creature)
				player:setStorageValue(Storage.TheIceIslands.Questline, 23)
				player:setStorageValue(Storage.TheIceIslands.Mission06, 3) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				npcHandler:say("Come back when you have the ingredient.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:removeItem(7247, 1) then
				npcHandler:say("Thank you for this ingredient. Now bring me the Frostbite {Herb}", npc, creature)
				player:setStorageValue(Storage.TheIceIslands.Questline, 24)
				player:setStorageValue(Storage.TheIceIslands.Mission06, 4) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				npcHandler:say("Come back when you have the ingredient.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 6 then
			if player:removeItem(7248, 1) then
				npcHandler:say("Thank you for this ingredient Now bring me Purple Kiss {Blossom}.", npc, creature)
				player:setStorageValue(Storage.TheIceIslands.Questline, 25)
				player:setStorageValue(Storage.TheIceIslands.Mission06, 5) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				npcHandler:say("Come back when you have the ingredient.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 7 then
			if player:removeItem(7249, 1) then
				npcHandler:say("Thank you for this ingredient. Now bring me the {Hydra Tongue}", npc, creature)
				player:setStorageValue(Storage.TheIceIslands.Questline, 26)
				player:setStorageValue(Storage.TheIceIslands.Mission06, 6) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				npcHandler:say("Come back when you have the ingredient. ", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 8 then
			if player:removeItem(7250, 1) then
				npcHandler:say("Thank you for this ingredient. Now bring me {Spores} of a Giant Glimmercap Mushroom.", npc, creature)
				player:setStorageValue(Storage.TheIceIslands.Questline, 27)
				player:setStorageValue(Storage.TheIceIslands.Mission06, 7) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				npcHandler:say("Come back when you have the ingredient.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 9 then
			if player:removeItem(7251, 1) then
				npcHandler:say("Thank you for this ingredient. Now you finish your {mission}", npc, creature)
				player:setStorageValue(Storage.TheIceIslands.Questline, 28)
				player:setStorageValue(Storage.TheIceIslands.Mission06, 8) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				npcHandler:say("Come back when you have the ingredient.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) >= 2 then
			npcHandler:say("Then come back when you have the ingredient.", npc, creature)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveller |PLAYERNAME|. Is there anything I can {do for you}?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
