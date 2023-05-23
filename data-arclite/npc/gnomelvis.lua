local internalNpcName = "Gnomelvis"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 67,
	lookBody = 76,
	lookLegs = 105,
	lookFeet = 95,
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


	if MsgContains(message, "looking") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) >= 19 or player:getStorageValue(Storage.BigfootBurden.QuestLine) <= 22 then
			npcHandler:say("I'm the gnomish {musical} supervisor!", npc, creature)
		end

	elseif MsgContains(message, "musical") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 19 then
			npcHandler:say({
				"Ah well. Everyone has a very personal melody in his soul. Only if you know your soul melody then you know yourself. And only if you know yourself will you be admitted to the Bigfoot company. ...",
				"So what you have to do is to find your soul melody. Do you see the huge crystals in this room? Those are harmonic crystals. Use them to deduce your soul melody. Simply use them to create a sound sequence. ...",
				"Every soul melody consists of seven sound sequences. You will have to figure out your correct soul melody by trial and error. If you hit a wrong note, you will have to start over."
			}, npc, creature)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 21)
			player:setStorageValue(Storage.BigfootBurden.MelodyStatus, 1)
			if player:getStorageValue(Storage.BigfootBurden.MelodyTone1) < 1 then
				for i = 0, 6 do
					player:setStorageValue(Storage.BigfootBurden.MelodyTone1 + i, math.random(1, 4))
				end
			end
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) == 21 then
			npcHandler:say("What you have to do is to find your soul melody. Use the harmonic crystals to deduce your soul melody. Every soul melody consists of seven sound sequences. ...", npc, creature)
			npcHandler:say("You will have to figure out your correct soul melody by trial and error.", npc, creature)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) == 22 then
			npcHandler:say({
				"Congratulations on finding your soul melody. And a pretty one as far as I can tell. Now you are a true recruit of the Bigfoot company! Commander Stone might have some tasks for you to do! ...",
				"Look for him in the central chamber. I marked your map where you will find him."
			}, npc, creature)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 25)
			player:setStorageValue(Storage.BigfootBurden.QuestLineComplete, 2)
			player:setStorageValue(Storage.BigfootBurden.Rank)
			player:addAchievement('Becoming a Bigfoot')

		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) == 25 then
			npcHandler:say("Congratulations on finding your soul melody.", npc, creature)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello. Is it me you're {looking} for?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)