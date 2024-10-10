local internalNpcName = "Elliott"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 574,
	lookHead = 114,
	lookBody = 114,
	lookLegs = 114,
	lookFeet = 114,
	lookAddons = 3,
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

	if MsgContains(message, "abandoned sewers") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission05) == 1 then
			npcHandler:say("I'm glad to see you back alive and healthy. Did you find anything interesting that you want to {report}?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) < 22 then
			npcHandler:say({
				"You want to enter the abandoned sewers? That's rather dangerous and not a good idea, man. That part of the sewers was not sealed off for nothing, you know? ...",
				"But hey, it's your life, bro. So here's the deal. I'll let you into the abandoned sewers if you help me with our {mission}.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 22 then
			npcHandler:say({
				"Wow, you already did it, that's fast. I'm used to a more laid-back attitude from most people. It's a shame to risk losing you to some collapsing tunnels, but a deal is a deal. ...",
				"I hereby grant you the permission to enter the abandoned part of the sewers. Take care, man! ...",
				"If you find something interesting, come back to talk about the {abandoned sewers}.",
			}, npc, creature)
			if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission04) < 1 then
				player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission04, 1)
			end
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, -1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "mission") then
		if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) < 1 then
			npcHandler:say("The sewers need repair. You in?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) < 22 then
			npcHandler:say("Elliott's keeps calling it that. It's just another job! You fixed some broken pipes and stuff? Let me check, {ok}?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Good. Broken pipe and generator pieces, there's smoke evading. That's how you recognise them. See how you can fix them using your hands. Need about, oh, twenty of them at least repaired. Report to me or Jacob", npc, creature)
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 1)
			if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Door) < 1 then
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Door, 1)
			end
			if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.QuestLine) < 1 then
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.QuestLine, 1)
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "ok") then
		if npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Good. Thanks, man. That's one vote you got for helping us with this. If you want to redo this task just say {abandoned sewers} to repeat it.", npc, creature)
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 22)
			local currentVotingPoints = player:getStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints)
			if currentVotingPoints == -1 then
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints, 1)
			else
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints, currentVotingPoints + 1)
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "report") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission05) == 1 then
			if npcHandler:getTopic(playerId) == 7 then
				npcHandler:say({
					"A sacrificial site? Damn, sounds like some freakish cult or something. Just great. And this ancient structure you talked about that's not part of the sewers? You'd better see the local historian about that, man. ...",
					"He can make more sense of what you found there. His name is Barazbaz. He should be in the magistrate building.",
				}, npc, creature)
				player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission06, 1) -- Start mission 6
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You already reported this mission, go to the next.", npc, creature)
			end
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "<nods>")
npcHandler:setMessage(MESSAGE_FAREWELL, "<nods> Yeah.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
