local internalNpcName = "Tired Tree"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 25405,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "*yawn*" },
	{ text = "I just want to sleep." },
	{ text = "Sooo tired." },
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
		if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.TiredTree) < 1 and player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.ToothFairy) == 2 then
			npcHandler:say("My siblings and I, we are so tired. We'd love to sleep and dream but there are strange and wicked disturbances that trouble nature itself. Thus, it is very hard to fall asleep. Would you help us?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
		if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.TiredTree) == 1 then
			npcHandler:say("Have you found a story that could help us to drit off to sleep?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Thank you very much, human being! Perhaps a bedtime story would help. We'd like to hear something about the dryads.", npc, creature)
		player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.TiredTree, 1)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say("I'm listening.", npc, creature)
		npcHandler:setTopic(playerId, 3)
	elseif MsgContains(message, "seeds of life") and npcHandler:getTopic(playerId) == 3 then
		npcHandler:say({
			"Oh what a beautiful story. ... *yawn* Here, take this map part. We have no need for it when we are slumbering. *yawn* Some of our siblings have the third part. They took over a couple of stones in the north of some high mountains. ...",
			"There are ... dwarves I guess. ... Zzzzzz ...",
		}, npc, creature)
		player:addItem(24944, 1)
		player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.TiredTree, 2)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "*yawn* Nature's blessings.")
npcHandler:setMessage(MESSAGE_FAREWELL, "*yawn* Nature's blessings.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
