local internalNpcName = "Grumpy Stone"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 25446,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "That's annoying!" },
	{ text = "Their backs are itching!" },
	{ text = "Grrr... We would need a pair of hands." },
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
		if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.GrumpyStone) < 1 then
			if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.TiredTree) == 2 then
				npcHandler:say({
					"As much as I dislike admiting it. I need help. WE need help. See, when we arrived in this part of the world, we quickly realised that we can't linger here while keeping our true forms. We need to take over animals, plants or stones. ...",
					"And we had to hurry. Some of my siblings were luckier than us and had the chance to take over animals like deer, birds or squirrels. We had to choose stones and now we are stuck here. ...",
					"I don't know for how long and with this issue you can't help us. I'm afriad. But there is something else, a trifle compared to our main problem. Nonetheless, it is annoying. ...",
					"As for myself I'm fine but my sisters and brothers surrounding us are not. Their backs are itching terribly and we don't have arms and hands to scratch ourselves. Would you help us and scratch my siblings' backs to bring them some relief?",
				}, npc, creature)
				npcHandler:setTopic(playerId, 1)
			end
		elseif player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.GrumpyStone) == 1 then
			if
				player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.Stone1) == 1
				and player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.Stone2) == 1
				and player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.Stone3) == 1
				and player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.Stone4) == 1
				and player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.Stone5) == 1
			then
				npcHandler:say({
					"Thank You! Their lamentation lapsed into silence. Thus, I assume you brought them some relief. Here, take this map part in return. I'm not interested in this treasure anymore. I just want to return to our hidden realm. ...",
					"Search for the last part somewhere in the Fields of Glory. It's hidden in a big fly agaric.",
				}, npc, creature)
				player:addItem(24945, 1)
				player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.GrumpyStone, 2)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You haven't tended to all the suffering stones yet.", npc, creature)
			end
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("No, this won't work. Your hands are too smooth. I guess you have to search for an apropiate tool. But no metal please! The sound of metal on stone is gruesome!", npc, creature)
		player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.GrumpyStone, 1)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name doesn't concern you." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Well, that's a rather stupid question." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Time is a peculiar concept. I never understood it." })
keywordHandler:addKeyword({ "fae" }, StdModule.say, { npcHandler = npcHandler, text = "Do I look like an encyclopaedia to you? Go do your own research." })
keywordHandler:addKeyword({ "elves" }, StdModule.say, { npcHandler = npcHandler, text = "They are inhabiting {Ab'Dendriel} and live in close touch with nature." })
keywordHandler:addKeyword({ "ab'dendriel" }, StdModule.say, { npcHandler = npcHandler, text = "It's a place full of life, huge trees, lush plants and various animals." })
keywordHandler:addKeyword({ "kazordoon" }, StdModule.say, { npcHandler = npcHandler, text = "It seems to be the place nearby where all those dwarves are living." })
keywordHandler:addKeyword({ "thais", "carlin", "venore" }, StdModule.say, { npcHandler = npcHandler, text = "It's a place full of stone buildings and people." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "This is the world we are living in - a quite annoying place at times." })
keywordHandler:addKeyword({ "problem" }, StdModule.say, { npcHandler = npcHandler, text = "The ground is far too cold for my liking. But I guess you can't help me with that." })

npcHandler:setMessage(MESSAGE_GREET, "Please don't bother me, human being. I have my own {problems}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Nature's blessing!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
