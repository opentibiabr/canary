local internalNpcName = "Gnombold"
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
	lookHead = 40,
	lookBody = 81,
	lookLegs = 101,
	lookFeet = 57,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

local talkState = {}
local levels = {50, 79}
npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if MsgContains(message, 'job') then
		return npcHandler:say('I\'m the officer responsible for this area. I give out missions, accept mission reports and oversee our defences.', npc, creature)
	end

	if MsgContains(message, 'gnome') then
		return npcHandler:say('Gnomes have lived autonomous for so long that it still feels odd to work with strangers for many of us.', npc, creature)
	end

	if MsgContains(message, 'area') then
		return npcHandler:say({
			"The levels around us are... well, they are strange. We are still not entirely sure how they were created. It seems obvious that they are artificial, but they seem not to be burrowed or the like. ... ",
			"We found strange stone formations that were not found on other layers around the Spike, but there is no clue at all if they are as natural as they look. It seems someone used some geomantic force to move the earth. ...",
			"For what reason this has been done we can't tell as we found no clues of colonisation. ...",
			"There are theories that the caves are some kind of burrow of some extinct creature or even creatures that are still around us, but exist as some form of invisible energy; but those theories are far-fetched and not supported by any discoveries. ...",
			"Be that as it may, whatever those caves were meant for, these days they are crawling with creatures of different kinds and all are hostile towards us. The competition for food is great down here, and everything is seen as prey by the cave dwellers. ...",
			"Some would like to feast on the crystal of the Spike, others would prefer a diet of gnomes. What they have in common is that they are a threat. If we can't keep them under control their constant attacks and raids on the Spike will wear us down. ...",
			"That's where adventurers fit in to save the day. ",
		}, npc, creature)
	end

	if MsgContains(message, 'mission') then
		if player:getLevel() > levels[2] then
			npcHandler:say('Sorry, but no! Your expertise could be put to better use elsewhere. Here awaits you no challenge. You are desperately needed in the deeper levels of the Spike. Report there immediately. ', npc, creature)
		else
			npcHandler:say(' I can offer you several missions: to gather geomantic {charges}, to {fertilise} the mushroom caves, to destroy monster {nests} and to {kill} some crystal crushers.', npc, creature)
		end
		return
	end

	if MsgContains(message, 'report') then
		talkState[playerId] = 'report'
		return npcHandler:say('What mission do you want to report about: gathering the geomantic {charges}, the {fertilisation} of the mushroom caves, about destroying monster {nests} and the {killing} of crystal crushers?', npc, creature)
	end

	if talkState[playerId] == 'report' then
		if MsgContains(message, 'charges') then
			if player:getStorageValue(SPIKE_MIDDLE_CHARGE_MAIN) == -1 then
				npcHandler:say('You have not started that mission.', npc, creature)
			elseif player:getStorageValue(SPIKE_MIDDLE_CHARGE_MAIN) == 2 then
				npcHandler:say('You have done well. Here, take your reward.', npc, creature)
				player:addFamePoint()
				player:addExperience(2000, true)
				player:setStorageValue(SPIKE_MIDDLE_CHARGE_MAIN, -1)
				player:setStorageValue(SPIKE_MIDDLE_CHARGE_DAILY, 86400)
			else
				npcHandler:say('Gnowful! Charge this magnet at three monoliths in the cave system. With three charges, the magnet will disintegrate and charge you with its gathered energies. Step on the magnetic extractor here to deliver the charge to us, then report to me.', npc, creature)
			end
		elseif MsgContains(message, 'fertilisation') then
			if player:getStorageValue(SPIKE_MIDDLE_MUSHROOM_MAIN) == -1 then
				npcHandler:say('You have not started that mission.', npc, creature)
			elseif player:getStorageValue(SPIKE_MIDDLE_MUSHROOM_MAIN) == 4 then
				npcHandler:say('You have done well. Here, take your reward.', npc, creature)
				player:addFamePoint()
				player:addExperience(2000, true)
				player:setStorageValue(SPIKE_MIDDLE_MUSHROOM_MAIN, -1)
				player:setStorageValue(SPIKE_MIDDLE_MUSHROOM_DAILY, 86400)
			else
				npcHandler:say('Gnowful! Use the fertiliser on four gardener mushroom in the caves.', npc, creature)
			end
		elseif MsgContains(message, 'nests') then
			if player:getStorageValue(SPIKE_MIDDLE_NEST_MAIN) == -1 then
				npcHandler:say('You have not started that mission.', npc, creature)
			elseif player:getStorageValue(SPIKE_MIDDLE_NEST_MAIN) == 8 then
				npcHandler:say('You have done well. Here, take your reward.', npc, creature)
				player:addFamePoint()
				player:addExperience(2000, true)
				player:setStorageValue(SPIKE_MIDDLE_NEST_MAIN, -1)
				player:setStorageValue(SPIKE_MIDDLE_NEST_DAILY, 86400)
			else
				npcHandler:say('Gnowful! Step into the transformer and destroy eight monster nests.', npc, creature)
			end
		elseif MsgContains(message, 'killing') then
			if player:getStorageValue(SPIKE_MIDDLE_KILL_MAIN) == -1 then
				npcHandler:say('You have not started that mission.', npc, creature)
			elseif player:getStorageValue(SPIKE_MIDDLE_KILL_MAIN) == 7 then
				npcHandler:say('You have done well. Here, take your reward.', npc, creature)
				player:addFamePoint()
				player:addExperience(2000, true)
				player:setStorageValue(SPIKE_MIDDLE_KILL_MAIN, -1)
				player:setStorageValue(SPIKE_MIDDLE_KILL_DAILY, 86400)
			else
				npcHandler:say('Gnowful! Just go out to the caves and kill at least seven crystalcrushers.', npc, creature)
			end
		else
			npcHandler:say('That\'s not a valid mission name.', npc, creature)
		end
		talkState[playerId] = nil
		return
	end

	--[[/////////////////////
	////GEOMANTIC CHARGES////
	///////////////////////]]
	if MsgContains(message, 'charges') then
		if player:getStorageValue(SPIKE_MIDDLE_CHARGE_DAILY) >= os.time() then
			return npcHandler:say('Sorry, you have to wait ' .. string.diff(player:getStorageValue(SPIKE_MIDDLE_CHARGE_DAILY)-os.time()) .. ' before this task gets available again.', npc, creature)
		end

		if (player:getLevel() < levels[1]) or (player:getLevel() > levels[2]) then
			return npcHandler:say('Sorry, you are not on the required range of levels [' .. levels[1] ..'-' .. levels[2] ..'].', npc, creature)
		end

		if player:getStorageValue(SPIKE_MIDDLE_CHARGE_MAIN) == -1 then
			npcHandler:say({'Our mission for you is to use a magnet on three different monoliths in the cave system here. After the magnet evaporates on the last charge, enter the magnetic extractor here to deliver your charge.', 'If you are interested, I can give you some more {information} about it. Are you willing to accept this mission?'}, npc, creature)
			talkState[playerId] = 'charges'
		else
			npcHandler:say('You have already started that mission.', npc, creature)
		end
	end

	if talkState[playerId] == 'charges' then
		if MsgContains(message, 'yes') then
			player:addItem(19207, 1)
			player:setStorageValue(SPIKE_MIDDLE_CHARGE_MAIN, 0)
			npcHandler:say({'Gnometastic! Charge this magnet at three monoliths in the cave system. With three charges, the magnet will disintegrate and charge you with its gathered energies. Step on the magnetic extractor here to deliver the charge to us, then report to me.','If you lose the magnet you\'ll have to bring your own. Gnomux sells all the equipment that is required for our missions.'}, npc, creature)
			talkState[playerId] = nil
		elseif MsgContains(message, 'no') then
			npcHandler:say('Ok then.', npc, creature)
			talkState[playerId] = nil
		end
	end

	--[[/////////////
	////FERTILISE////
	///////////////]]
	if MsgContains(message, 'fertilise') then
		if player:getStorageValue(SPIKE_MIDDLE_MUSHROOM_DAILY) >= os.time() then
			return npcHandler:say('Sorry, you have to wait ' .. string.diff(player:getStorageValue(SPIKE_MIDDLE_MUSHROOM_DAILY)-os.time()) .. ' before this task gets available again.', npc, creature)
		end

		if (player:getLevel() < levels[1]) or (player:getLevel() > levels[2]) then
			return npcHandler:say('Sorry, you are not on the required range of levels [' .. levels[1] ..'-' .. levels[2] ..'].', npc, creature)
		end

		if player:getStorageValue(SPIKE_MIDDLE_MUSHROOM_MAIN) == -1 then
			npcHandler:say('Your mission would be to seek out gardener mushrooms in the caves and use some fertiliser on them. If you are interested, I can give you some more information about it. Are you willing to accept this mission?', npc, creature)
			talkState[playerId] = 'fertilise'
		else
			npcHandler:say('You have already started that mission.', npc, creature)
		end
	end

	if talkState[playerId] == 'fertilise' then
		if MsgContains(message, 'yes') then
			player:addItem(19214)
			player:setStorageValue(SPIKE_MIDDLE_MUSHROOM_MAIN, 0)
			npcHandler:say('Gnometastic! And here is your fertiliser - use it on four gardener mushroom in the caves. If you lose the fertiliser you\'ll have to bring your own. Gnomux sells all the equipment that is required for our missions.', npc, creature)
			talkState[playerId] = nil
		elseif MsgContains(message, 'no') then
			npcHandler:say('Ok then.', npc, creature)
			talkState[playerId] = nil
		end
	end

	--[[//////////////////
	////DESTROY NESTS/////
	////////////////////]]
	if MsgContains(message, 'nests') then
		if player:getStorageValue(SPIKE_MIDDLE_NEST_DAILY) >= os.time() then
			return npcHandler:say('Sorry, you have to wait ' .. string.diff(player:getStorageValue(SPIKE_MIDDLE_NEST_DAILY)-os.time()) .. ' before this task gets available again.', npc, creature)
		end

		if (player:getLevel() < levels[1]) or (player:getLevel() > levels[2]) then
			return npcHandler:say('Sorry, you are not on the required range of levels [' .. levels[1] ..'-' .. levels[2] ..'].', npc, creature)
		end

		if player:getStorageValue(SPIKE_MIDDLE_NEST_MAIN) == -1 then
			npcHandler:say('Our mission for you is to step into the gnomish transformer and then destroy eight monster nests in the caves. If you are interested, I can give you some more information about it. Are you willing to accept this mission?', npc, creature)
			talkState[playerId] = 'nests'
		else
			npcHandler:say('You have already started that mission.', npc, creature)
		end
	end

	if talkState[playerId] == 'nests' then
		if MsgContains(message, 'yes') then
			player:setStorageValue(SPIKE_MIDDLE_NEST_MAIN, 0)
			npcHandler:say('Gnometastic! Don\'t forget to step into the transformer before you go out and destroy five monster nests. If your transformation runs out, return to the transformer to get another illusion.', npc, creature)
			talkState[playerId] = nil
		elseif MsgContains(message, 'no') then
			npcHandler:say('Ok then.', npc, creature)
			talkState[playerId] = nil
		end
	end

	--[[/////////
	////KILL/////
	///////////]]
	if MsgContains(message, 'kill') then
		if player:getStorageValue(SPIKE_MIDDLE_KILL_DAILY) >= os.time() then
			return npcHandler:say('Sorry, you have to wait ' .. string.diff(player:getStorageValue(SPIKE_MIDDLE_KILL_DAILY)-os.time()) .. ' before this task gets available again.', npc, creature)
		end

		if (player:getLevel() < levels[1]) or (player:getLevel() > levels[2]) then
			return npcHandler:say('Sorry, you are not on the required range of levels [' .. levels[1] ..'-' .. levels[2] ..'].', npc, creature)
		end

		if player:getStorageValue(SPIKE_MIDDLE_KILL_MAIN) == -1 then
			npcHandler:say('This mission will require you to kill some crystal crushers for us. If you are interested, I can give you some more information about it. Are you willing to accept this mission?', npc, creature)
			talkState[playerId] = 'kill'
		else
			npcHandler:say('You have already started that mission.', npc, creature)
		end
	end

	if talkState[playerId] == 'kill' then
		if MsgContains(message, 'yes') then
			player:setStorageValue(SPIKE_MIDDLE_KILL_MAIN, 0)
			npcHandler:say('Gnometastic! You should have no trouble to find enough crystal crushers. Killing seven of them should be enough.', npc, creature)
			talkState[playerId] = nil
		elseif MsgContains(message, 'no') then
			npcHandler:say('Ok then.', npc, creature)
			talkState[playerId] = nil
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
