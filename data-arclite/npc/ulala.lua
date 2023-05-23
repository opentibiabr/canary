local internalNpcName = "Ulala"
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
	lookHead = 57,
	lookBody = 57,
	lookLegs = 57,
	lookFeet = 57
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

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.UnnaturalSelection.Questline) == 5 then
			npcHandler:say({
				"The great hunt! About to begin, but gods are not in favour of us yet. We need all help we get. We please Krunus with special nature dance. ...",
				"You seen Krunus altar south in camp, on mountain top? This is where dance is. If you do right steps Krunus will give you sign. If wrong, he not pleased. ...",
				"Do Krunus dance for us! Step and dance and turn around! You will know when you do good. Make {Krunus} happy and support our great hunt!"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.UnnaturalSelection.Questline) == 6 then
			npcHandler:say("Come back if you finished the dance.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.UnnaturalSelection.Questline) == 7 then
			npcHandler:say({
				"You born dancer! Krunus is pleased and support the great hunt. But he easy to please! Pandor much harder. We weak, so he sad about us. ...",
				"Maybe we can please with sacrifice of body parts of our enemies. But you need help us get it! We much too weak. ...",
				"If you bring us 5 teeth of green men, 5 skin of horned ones and 5 skin of snakemen that already be good. Please help tribe make Pandor happy!"
			}, npc, creature)
			player:setStorageValue(Storage.UnnaturalSelection.Questline, 8)
			player:setStorageValue(Storage.UnnaturalSelection.Mission04, 1) --Questlog, Unnatural Selection Quest "Mission 4: Bits and Pieces"
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.UnnaturalSelection.Questline) == 8 then
			npcHandler:say("Please help tribe make Pandor happy! Did you bring us what I asked?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.UnnaturalSelection.Questline) == 9 then
			npcHandler:say({
				"We need make sure Fasuon is on our side. There is laaaaaaaarge crystal on top of mountain. Don't know where come from, was there before us. Problem is - way is infested with creatures! ...",
				"Creatures from the other side of mountain. Bony! Scary! We too weak to go through there, can just run and hope to survive.. but you do better! ...",
				"Please find great crystal of Fasuon and pray there for his support!"
			}, npc, creature)
			player:setStorageValue(Storage.UnnaturalSelection.Questline, 10)
			player:setStorageValue(Storage.UnnaturalSelection.Mission05, 1) --Questlog, Unnatural Selection Quest "Mission 5: Ray of Light"
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.UnnaturalSelection.Questline) == 10 then
			npcHandler:say("Please find great crystal of Fasuon and pray there for his support!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.UnnaturalSelection.Questline) == 11 then
			npcHandler:say("You prayed to Fasuon! Me saw ray of lights on mountain top! Beautiful it was. Me thank you for your help. Great hunt almost can't go wrong now!", npc, creature)
			player:setStorageValue(Storage.UnnaturalSelection.Questline, 12)
			player:setStorageValue(Storage.UnnaturalSelection.Mission05, 3) --Questlog, Unnatural Selection Quest "Mission 5: Ray of Light"
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.UnnaturalSelection.Questline) == 12 then
			npcHandler:say({
				"Uzroth very easy to anger. You been great help so far but me think that need to pray to Uzroth meself. Only me understand what he wants at time and he is veeeeeery moody. Cannot risk to make angry! ...",
				"So me will do when you gone. But me thank you very much. Go speak Lazaran and tell the gods are pleased now."
			}, npc, creature)
			player:setStorageValue(Storage.UnnaturalSelection.Questline, 13)
			player:setStorageValue(Storage.UnnaturalSelection.Mission06, 1) --Questlog, Unnatural Selection Quest "Mission 6: Firewater Burn"
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "krunus") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Krunus is God for plants and birth. He hidden in all that grows.", npc, creature)
			player:setStorageValue(Storage.UnnaturalSelection.Questline, 6)
			player:setStorageValue(Storage.UnnaturalSelection.Mission03, 2) --Questlog, Unnatural Selection Quest "Mission 3: Dance Dance Evolution"
			player:setStorageValue(Storage.UnnaturalSelection.DanceStatus, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			if player:getItemCount(10196) >= 5 and player:getItemCount(5878) >= 5 and player:getItemCount(5876) >= 5 then
				player:removeItem(10196, 5)
				player:removeItem(5878, 5)
				player:removeItem(5876, 5)
				npcHandler:say("Me thank you! Me will bring sacrifice for Pandor. He surely be pleased with our work. Well your work, but me won't tell him. Teehee.", npc, creature)
				player:setStorageValue(Storage.UnnaturalSelection.Questline, 9)
				player:setStorageValue(Storage.UnnaturalSelection.Mission04, 2) --Questlog, Unnatural Selection Quest "Mission 4: Bits and Pieces"
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You do not have these things!", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
