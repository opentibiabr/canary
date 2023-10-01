local internalNpcName = "Chavis"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 96,
	lookBody = 43,
	lookLegs = 20,
	lookFeet = 76,
	lookAddons = 2
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

	-- START TASK
	if MsgContains(message, "food") then
		if player:getStorageValue(Storage.Oramond.MissionToTakeRoots) <= 0 then
			npcHandler:say({
				"Hey there, just to let you know - I am not a man of many words. I prefer 'deeds', you see? The poor of this city will not feed themselves. ...",
				"So in case you've got nothing better to do - and it sure looks that way judging by how long you\'re already loitering around in front of my nose - please help us. ...",
				"If you can find some of the nutritious, juicy {roots} in the outskirts of Rathleton, bring them here. We will gladly take bundles of five roots each, and hey - helping us, helps you in the long term, trust me."
			}, npc, creature, 10)
			if player:getStorageValue(Storage.Oramond.QuestLine) <= 0 then
				player:setStorageValue(Storage.Oramond.QuestLine, 1)
			end
			player:setStorageValue(Storage.Oramond.MissionToTakeRoots, 1)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Oramond.MissionToTakeRoots) == 1 then
			if player:getStorageValue(Storage.Oramond.HarvestedRootCount) < 5 then
				npcHandler:say("I am sorry, you didn't harvest enough roots. You need to harvest a bundle of at least five roots - and please try doing it yourself.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			elseif player:getStorageValue(Storage.Oramond.HarvestedRootCount) >= 5 then
				npcHandler:say("Yes? You brought some juicy roots? How nice of you - that's one additional voice in the {magistrate} of {Rathleton} for you! ...", npc, creature)
				npcHandler:setTopic(playerId, 1)
			end
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Spend it wisely, though, put in a word for the poor, will ye? Sure you will.", npc, creature)
		player:setStorageValue(Storage.Oramond.VotingPoints,
			player:getStorageValue(Storage.Oramond.VotingPoints) + 1)

		player:setStorageValue(Storage.Oramond.HarvestedRootCount,
			player:getStorageValue(Storage.Oramond.HarvestedRootCount) - 5)
		player:removeItem(21291, 5)

		player:setStorageValue(Storage.Oramond.MissionToTakeRoots, 0)
		player:setStorageValue(Storage.Oramond.DoorBeggarKing, 1)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "root") then
		npcHandler:say("They are nutritious, cost nothing and are good for the body hair. If you can bring us bundles of five juicy roots each - we will make it worth your while for the {magistrate}.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "magistrate") then
		npcHandler:say("They act so important but it is us common people who keep things going. There is a lot you can do in this city to earn a right to vote in the magistrate, though. So keep an eye out for everyone who needs help.", npc, creature)
	elseif MsgContains(message, "rathleton") then
		npcHandler:say({
			"Don't be fooled, we have here masters and servants like everywhere else. The whole system is a scam to subdue the masses, to fool them about what is really happening. ...",
			"The system only ensures that the rich have a better control and the labourers are only used."
		}, npc, creature, 10)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Hey there! You don\'t happen to have some {food} on you, you\'re willing to share? Well, where are my manners, a warm welcome for now.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Take care out there!')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
