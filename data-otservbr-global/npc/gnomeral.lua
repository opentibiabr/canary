local internalNpcName = "Gnomeral"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 1000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 78,
	lookBody = 57,
	lookLegs = 78,
	lookFeet = 76,
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

	if not player then
		return false
	end

	if(MsgContains(message, "mission") and player:getStorageValue(Storage.BigfootBurden.QuestLineComplete) >= 2) then
		if player:getStorageValue(Storage.BigfootBurden.Rank) >= 120 and player:getStorageValue(Storage.BigfootBurden.Rank) < 480 then
			npcHandler:say("For your rank there are two missions available: {matchmaker} and golem {repair}. You can undertake each mission, but you can turn in a specific mission only once every 20 hours. ", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.BigfootBurden.Rank) >= 480 then
			npcHandler:say("For your rank there are four missions available: {matchmaker}, golem {repair}, {spore} gathering and {grindstone} hunt. You can undertake each mission, but you can turn in a specific mission only once every 20 hours.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end

	--  Matchmaker
	elseif MsgContains(message, "matchmaker") then
		if player:getStorageValue(Storage.BigfootBurden.Rank) >= 120 then
			if player:getStorageValue(Storage.BigfootBurden.MissionMatchmaker) < 1 and player:getStorageValue(Storage.BigfootBurden.MatchmakerTimeout) < os.time() then
				npcHandler:say({
				"You will have to find a lonely crystal a perfect match. I don't understand the specifics but the gnomes told me that even crystals need a mate to produce offspring. ...",
				"Be that as it may, in this package you'll find a crystal. Take it out of the package and go to the crystal caves to find it a mate. Just look out for huge red crystals and try your luck. ...",
				"They should look like one of those seen in your soul melody test. You will find them in the crystal grounds. {Report} back to me when you are done."
			}, npc, creature)
				player:setStorageValue(Storage.BigfootBurden.MissionMatchmaker, 1)
				player:setStorageValue(Storage.BigfootBurden.MatchmakerStatus, 0)
				player:setStorageValue(Storage.BigfootBurden.MatchmakerIdNeeded, math.random(15809, 15815))
				player:addItem(15802, 1)   --- taking missions
			elseif player:getStorageValue(Storage.BigfootBurden.MatchmakerTimeout) > os.time() then  -- trying to take mission while in cooldown
				npcHandler:say("Sorry, you will have to wait before you can undertake this mission again.", npc, creature)
			elseif player:getStorageValue(Storage.BigfootBurden.MissionMatchmaker) > 0 then  -- reporting mission
				if player:getStorageValue(Storage.BigfootBurden.MatchmakerStatus) == 1 then -- can report missions
					player:setStorageValue(Storage.BigfootBurden.Rank, player:getStorageValue(Storage.BigfootBurden.Rank) + 10)
					player:addItem(16128, 2)
					player:addItem(15698, 1)
					player:setStorageValue(Storage.BigfootBurden.MissionMatchmaker, 0)
					player:setStorageValue(Storage.BigfootBurden.MatchmakerStatus, -1)
					player:setStorageValue(Storage.BigfootBurden.MatchmakerIdNeeded, -1)
					player:setStorageValue(Storage.BigfootBurden.MatchmakerTimeout, os.time() + 72000)
					player:addAchievement('Crystals in Love')
					player:checkGnomeRank()
					npcHandler:say("Gnomo arigato |PLAYERNAME|! You did well. That will help us a lot. Take your tokens and this gnomish supply package as a reward. ", npc, creature)
					npcHandler:setTopic(playerId, 0)
				else   -- haven't finished
					if npcHandler:getTopic(playerId) >= 1 then
						npcHandler:say("You are not done yet.", npc, creature) -- is reporting
					else
						npcHandler:say("You already have accepted this mission. Don't forget to {report} to me when you are done.", npc, creature) -- se nao tiver reportando
					end
					npcHandler:setTopic(playerId, 0)
				end
			end
		else
			npcHandler:say("Sorry, you do have not have the required rank to undertake this mission.", npc, creature)
		end
	-- Matchmaker

	-- Golem Repair
	elseif MsgContains(message, "repair") then
		if player:getStorageValue(Storage.BigfootBurden.Rank) >= 120 then
			if player:getStorageValue(Storage.BigfootBurden.MissionTinkersBell) < 1 and player:getStorageValue(Storage.BigfootBurden.TinkerBellTimeout) < os.time() then
				npcHandler:say("Our gnomish crystal golems sometimes go nuts. A recent earthquake has disrupted the entire production of a golem factory. ... ", npc, creature)
				npcHandler:say({
					"I'm no expert on how those golems work, but it seems that when the crystals of the golems get out of harmony, they do as they please and even sometimes become violent. The violent ones are lost. ...",
					"Don't bother with them, though you may decide to kill some to get rid of them. The others can be repaired, but to recall them to the workshops, the golems have to be put into a specific resonance. ...",
					"Use the bell I gave you on the golems, so the gnomes can recall them to their workshops. Getting four of them should be enough for now. Report back when you are ready."
				}, npc, creature)
				player:setStorageValue(Storage.BigfootBurden.MissionTinkersBell, 1)
				player:setStorageValue(Storage.BigfootBurden.GolemCount, 0)
				player:addItem(15832, 1)  --- taking missions
			elseif player:getStorageValue(Storage.BigfootBurden.TinkerBellTimeout) > os.time() then  -- trying to take mission while in cooldown
				npcHandler:say("Sorry, you will have to wait before you can undertake this mission again.", npc, creature)
			elseif player:getStorageValue(Storage.BigfootBurden.MissionTinkersBell) > 0 then  -- reporting mission
				if player:getStorageValue(Storage.BigfootBurden.GolemCount) >= 4 then -- can report missions
					player:removeItem(15832, 1)
					player:setStorageValue(Storage.BigfootBurden.Rank, player:getStorageValue(Storage.BigfootBurden.Rank) + 10)
					player:addItem(16128, 2)
					player:addItem(15698, 1)
					player:setStorageValue(Storage.BigfootBurden.MissionTinkersBell, 0)
					player:setStorageValue(Storage.BigfootBurden.GolemCount, -1)
					player:setStorageValue(Storage.BigfootBurden.TinkerBellTimeout, os.time() + 72000)
					player:addAchievement('Substitute Tinker')
					player:checkGnomeRank()
					npcHandler:say("Gnomo arigato |PLAYERNAME|! You did well. That will help us a lot. Take your tokens and this gnomish supply package as a reward. ", npc, creature)
					npcHandler:setTopic(playerId, 0)
				else   -- haven't finished
					if npcHandler:getTopic(playerId) >= 1 then
						npcHandler:say("You are not done yet.", npc, creature) -- is reporting
					else
						npcHandler:say("You already have accepted this mission. Don't forget to {report} to me when you are done.", npc, creature) -- se nao tiver reportando
					end
					npcHandler:setTopic(playerId, 0)
				end
			end
		else
			npcHandler:say("Sorry, you do have not have the required rank to undertake this mission.", npc, creature)
		end
	-- Golem Repair

	-- Spore Gathering
	elseif MsgContains(message, "spore") then
		if player:getStorageValue(Storage.BigfootBurden.Rank) >= 480 then
			if player:getStorageValue(Storage.BigfootBurden.MissionSporeGathering) < 1 and player:getStorageValue(Storage.BigfootBurden.SporeGatheringTimeout) < os.time() then
				npcHandler:say({
					"We gnomes want you to gather a special collection of spores. All you have to do is use a puffball mushroom and use the spore gathering kit I gave you to gather the spores. ...",
					"There is a catch though. You need to collect different spores in a specific sequence to fill your gathering kit. If you mix the spores in the wrong way, you ruin your collection and have to start over. ...",
					"You have to gather them in this sequence: red, green, blue and yellow. You can see on your kit what is required next."
				}, npc, creature)
				player:setStorageValue(Storage.BigfootBurden.MissionSporeGathering, 1)
				player:setStorageValue(Storage.BigfootBurden.SporeCount, 0)
				player:addItem(15817, 1)
				npcHandler:setTopic(playerId, 0)  --- taking missions
			elseif player:getStorageValue(Storage.BigfootBurden.SporeGatheringTimeout) > os.time() then  -- trying to take mission while in cooldown
				npcHandler:say("Sorry, you will have to wait before you can undertake this mission again.", npc, creature)
			elseif player:getStorageValue(Storage.BigfootBurden.MissionSporeGathering) > 0 then  -- reporting mission
				if player:getStorageValue(Storage.BigfootBurden.SporeCount) == 4 then -- can report missions
					player:removeItem(15821, 1)
					player:setStorageValue(Storage.BigfootBurden.Rank, player:getStorageValue(Storage.BigfootBurden.Rank) + 10)
					player:addItem(16128, 2)
					player:addItem(15698, 1)
					player:setStorageValue(Storage.BigfootBurden.MissionSporeGathering, 0)
					player:setStorageValue(Storage.BigfootBurden.SporeCount, -1)
					player:setStorageValue(Storage.BigfootBurden.SporeGatheringTimeout, os.time() + 72000)
					player:addAchievement('Spore Hunter')
					player:checkGnomeRank()
					npcHandler:say("Gnomo arigato |PLAYERNAME|! You did well. That will help us a lot. Take your tokens and this gnomish supply package as a reward. ", npc, creature)
					npcHandler:setTopic(playerId, 0)
				else   -- haven't finished
					if npcHandler:getTopic(playerId) >= 1 then
						npcHandler:say("You are not done yet.", npc, creature) -- is reporting
					else
						npcHandler:say("You already have accepted this mission. Don't forget to {report} to me when you are done.", npc, creature) -- se nao tiver reportando
					end
					npcHandler:setTopic(playerId, 0)
				end
			end
		else
			npcHandler:say("Sorry, you do have not have the required rank to undertake this mission.", npc, creature)
		end
	-- Spore Gathering

	-- Grindstone Hunt
	elseif MsgContains(message, "grindstone") then
		if player:getStorageValue(Storage.BigfootBurden.Rank) >= 480 then
			if player:getStorageValue(Storage.BigfootBurden.MissionGrindstoneHunt) < 1 and player:getStorageValue(Storage.BigfootBurden.GrindstoneTimeout) < os.time() then
				npcHandler:say({
					"We gnomes need some special grindstones to cut and polish specific crystals. The thing is, they can only be found in a quite dangerous lava cave full of vile monsters. You'll reach it via the hot spot teleporter. ...",
					"It will be your task to get one such grindstone and bring it back to me."
				}, npc, creature)
				player:setStorageValue(Storage.BigfootBurden.MissionGrindstoneHunt, 1)
				player:setStorageValue(Storage.BigfootBurden.GrindstoneStatus, 0)
				npcHandler:setTopic(playerId, 0) --- taking missions
			elseif player:getStorageValue(Storage.BigfootBurden.GrindstoneTimeout) > os.time() then  -- trying to take mission while in cooldown
				npcHandler:say("Sorry, you will have to wait before you can undertake this mission again.", npc, creature)
			elseif player:getStorageValue(Storage.BigfootBurden.MissionGrindstoneHunt) > 0 then  -- reporting mission
				if player:getStorageValue(Storage.BigfootBurden.GrindstoneStatus) == 1 then -- can report missions
					player:removeItem(15826, 1)
					player:setStorageValue(Storage.BigfootBurden.Rank, player:getStorageValue(Storage.BigfootBurden.Rank) + 10)
					player:addItem(16128, 2)
					player:addItem(15698, 1)
					player:setStorageValue(Storage.BigfootBurden.MissionGrindstoneHunt, 0)
					player:setStorageValue(Storage.BigfootBurden.GrindstoneStatus, -1)
					player:setStorageValue(Storage.BigfootBurden.GrindstoneTimeout, os.time() + 72000)
					player:addAchievement('Grinding Again')
					player:checkGnomeRank()
					npcHandler:say("Gnomo arigato |PLAYERNAME|! You did well. That will help us a lot. Take your tokens and this gnomish supply package as a reward. ", npc, creature)
					npcHandler:setTopic(playerId, 0)
				else   -- haven't finished
					if npcHandler:getTopic(playerId) >= 1 then
						npcHandler:say("You are not done yet.", npc, creature) -- is reporting
					else
						npcHandler:say("You already have accepted this mission. Don't forget to {report} to me when you are done.", npc, creature) -- se nao tiver reportando
					end
					npcHandler:setTopic(playerId, 0)
				end
			end
		else
			npcHandler:say("Sorry, you do have not have the required rank to undertake this mission.", npc, creature)
		end
	-- Grindstone Hunt

	elseif(MsgContains(message, "report")) then
		if player:getStorageValue(Storage.BigfootBurden.Rank) >= 120 and player:getStorageValue(Storage.BigfootBurden.Rank) < 480 then
			npcHandler:say("Which mission do you want to report: {matchmaker}, golem {repair}?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.BigfootBurden.Rank) >= 480 then
			npcHandler:say("Which mission do you want to report: {matchmaker}, golem {repair}, {spore} gathering or {grindstone} hunt?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Hello there recruit!')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
