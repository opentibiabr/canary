local internalNpcName = "Gnomilly"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 507,
	lookHead = 14,
	lookBody = 15,
	lookLegs = 91,
	lookFeet = 92,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

local talkState = {}
local levels = {25, 49}
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
		return npcHandler:say('We are the only protectors of the world against the enemies below. With small stature comes great responsibilities, as they say.', npc, creature)
	end

	if MsgContains(message, 'area') then
		return npcHandler:say({
			"On these levels we found evidence of some monumental battle that has taken place here centuries ago. We also found some grave sites, but oddly enough no clues of any form of settlement. ...",
			"Some evidence we have found suggests that at least one of the battles here was fought for many, many years. People came here, lived here, fought here and died here. ...",
			"The battles continued until someone or something literally ploughed through the battlefields, turning everything upside down. All this killing and death soaked the area with negative energy. ...",
			"Necromantic forces are running wild all over the place and we are hard-pressed to drive all these undead, spirits and ghosts, away from the Spike. ...",
			"Unless we can secure that area somehow, the Spike operation is threatened to become crippled by the constant attacks of the undead. ...",
			"The whole growing downwards could come to a halt, leaving us exposed to even more attacks, counter attacks, and giving the enemy time to prepare their defences. There's a lot to do for aspiring adventurers."
		}, npc, creature)
	end

	if MsgContains(message, 'mission') then
		if player:getLevel() > levels[2] then
			npcHandler:say('Sorry, but no! Your expertise could be put to better use elsewhere. Here awaits you no challenge. You are desperately needed in the deeper levels of the Spike. Report there immediately. ', npc, creature)
		else
			npcHandler:say('I can offer you several missions: to recharge our ghost {pacifiers}, to {release} the spiritual anger, to {track} an evil presence and to {kill} some demon skeletons.', npc, creature)
		end
		return
	end

	if MsgContains(message, 'report') then
		talkState[playerId] = 'report'
		return npcHandler:say('What mission do you want to report about: recharging the ghost {pacifiers}, the {release} of the spiritual anger, about {tracking} an evil presence and the {killing} of demon skeletons?', npc, creature)
	end

	if talkState[playerId] == 'report' then
		if MsgContains(message, 'pacifiers') then
			if player:getStorageValue(SPIKE_UPPER_PACIFIER_MAIN) == -1 then
				npcHandler:say('You have not started that mission.', npc, creature)
			elseif player:getStorageValue(SPIKE_UPPER_PACIFIER_MAIN) == 7 then
				npcHandler:say('You have done well. Here, take your reward.', npc, creature)
				player:addFamePoint()
				player:addExperience(1000, true)
				player:setStorageValue(SPIKE_UPPER_PACIFIER_MAIN, -1)
				player:setStorageValue(SPIKE_UPPER_PACIFIER_DAILY, 86400)
			else
				npcHandler:say('Gnowful! Take the resonance charger and use it on seven of the pacifiers in the cave.', npc, creature)
			end
		elseif MsgContains(message, 'release') then
			if player:getStorageValue(SPIKE_UPPER_MOUND_MAIN) == -1 then
				npcHandler:say('You have not started that mission.', npc, creature)
			elseif player:getStorageValue(SPIKE_UPPER_MOUND_MAIN) == 4 then
				npcHandler:say('You have done well. Here, take your reward.', npc, creature)
				player:addFamePoint()
				player:addExperience(1000, true)
				player:setStorageValue(SPIKE_UPPER_MOUND_MAIN, -1)
				player:setStorageValue(SPIKE_UPPER_MOUND_DAILY, 86400)
			else
				npcHandler:say('Gnowful! Take the spirit shovel use it on four graves in the cave system.', npc, creature)
			end
		elseif MsgContains(message, 'tracking') then
			if player:getStorageValue(SPIKE_UPPER_TRACK_MAIN) == -1 then
				npcHandler:say('You have not started that mission.', npc, creature)
			elseif player:getStorageValue(SPIKE_UPPER_TRACK_MAIN) == 3 then
				npcHandler:say('You have done well. Here, take your reward.', npc, creature)
				player:addFamePoint()
				player:addExperience(1000, true)
				player:setStorageValue(SPIKE_UPPER_TRACK_MAIN, -1)
				player:setStorageValue(SPIKE_UPPER_TRACK_DAILY, 86400)
			else
				npcHandler:say('Gnowful! Take the tracking device in the caves and locate the residual spirit energy.', npc, creature)
			end
		elseif MsgContains(message, 'killing') then
			if player:getStorageValue(SPIKE_UPPER_KILL_MAIN) == -1 then
				npcHandler:say('You have not started that mission.', npc, creature)
			elseif player:getStorageValue(SPIKE_UPPER_KILL_MAIN) == 7 then
				npcHandler:say('You have done well. Here, take your reward.', npc, creature)
				player:addFamePoint()
				player:addExperience(1000, true)
				player:setStorageValue(SPIKE_UPPER_KILL_MAIN, -1)
				player:setStorageValue(SPIKE_UPPER_KILL_DAILY, 86400)
			else
				npcHandler:say('Gnowful! Just go out to the caves and kill at least seven demon skeletons.', npc, creature)
			end
		else
			npcHandler:say('That\'s not a valid mission name.', npc, creature)
		end
		talkState[playerId] = nil
		return
	end

	--[[///////////////////
	////GHOST PACIFIERS////
	/////////////////////]]
	if MsgContains(message, 'pacifiers') then
		if player:getStorageValue(SPIKE_UPPER_PACIFIER_DAILY) >= os.time() then
			return npcHandler:say('Sorry, you have to wait ' .. string.diff(player:getStorageValue(SPIKE_UPPER_PACIFIER_DAILY)-os.time()) .. ' before this task gets available again.', npc, creature)
		end

		if (player:getLevel() < levels[1]) or (player:getLevel() > levels[2]) then
			return npcHandler:say('Sorry, you are not on the required range of levels [' .. levels[1] ..'-' .. levels[2] ..'].', npc, creature)
		end

		if player:getStorageValue(SPIKE_UPPER_PACIFIER_MAIN) == -1 then
			npcHandler:say({'We need you to recharge our ghost pacifiers. They are placed at several strategic points in the caves around us and should be easy to find. Your mission would be to charge seven of them.', 'If you are interested, I can give you some more {information} about it. Are you willing to accept this mission?'}, npc, creature)
			talkState[playerId] = 'pacifiers'
		else
			npcHandler:say('You have already started that mission.', npc, creature)
		end
	end

	if talkState[playerId] == 'pacifiers' then
		if MsgContains(message, 'yes') then
			player:addItem(19204, 1)
			player:setStorageValue(SPIKE_UPPER_PACIFIER_MAIN, 0)
			npcHandler:say('Gnometastic! Take this resonance charger and use it on seven of the pacifiers in the cave. If you lose the charger, you\'ll have to bring your own. Gnomux sells all the equipment that is required for our missions.', npc, creature)
			talkState[playerId] = nil
		elseif MsgContains(message, 'no') then
			npcHandler:say('Ok then.', npc, creature)
			talkState[playerId] = nil
		end
	end

	--[[///////////////////
	////SPIRIT RELEASE/////
	/////////////////////]]
	if MsgContains(message, 'release') then
		if player:getStorageValue(SPIKE_UPPER_MOUND_DAILY) >= os.time() then
			return npcHandler:say('Sorry, you have to wait ' .. string.diff(player:getStorageValue(SPIKE_UPPER_MOUND_DAILY)-os.time()) .. ' before this task gets available again.', npc, creature)
		end

		if (player:getLevel() < levels[1]) or (player:getLevel() > levels[2]) then
			return npcHandler:say('Sorry, you are not on the required range of levels [' .. levels[1] ..'-' .. levels[2] ..'].', npc, creature)
		end

		if player:getStorageValue(SPIKE_UPPER_MOUND_MAIN) == -1 then
			npcHandler:say('Your task would be to use a spirit shovel to release some spirit\'s anger from graves that can be found all around here. If you are interested, I can give you some more information about it. Are you willing to accept this mission?', npc, creature)
			talkState[playerId] = 'release'
		else
			npcHandler:say('You have already started that mission.', npc, creature)
		end
	end

	if talkState[playerId] == 'release' then
		if MsgContains(message, 'yes') then
			player:addItem(19203, 1)
			player:setStorageValue(SPIKE_UPPER_MOUND_MAIN, 0)
			npcHandler:say('Gnometastic! Take this spirit shovel and use it on four graves in the cave system. If you lose the shovel you\'ll have to bring your own. Gnomux sells all the equipment that is required for our missions.', npc, creature)
			talkState[playerId] = nil
		elseif MsgContains(message, 'no') then
			npcHandler:say('Ok then.', npc, creature)
			talkState[playerId] = nil
		end
	end

	--[[/////////////////
	////TRACK GHOSTS/////
	///////////////////]]
	if MsgContains(message, 'track') then
		if player:getStorageValue(SPIKE_UPPER_TRACK_DAILY) >= os.time() then
			return npcHandler:say('Sorry, you have to wait ' .. string.diff(player:getStorageValue(SPIKE_UPPER_TRACK_DAILY)-os.time()) .. ' before this task gets available again.', npc, creature)
		end

		if (player:getLevel() < levels[1]) or (player:getLevel() > levels[2]) then
			return npcHandler:say('Sorry, you are not on the required range of levels [' .. levels[1] ..'-' .. levels[2] ..'].', npc, creature)
		end

		if player:getStorageValue(SPIKE_UPPER_TRACK_MAIN) == -1 then
			npcHandler:say({'You\'d be given the highly important task to track down an enormously malevolent spiritual presence in the cave system. Use your tracking device to find out how close you are to the presence.','Use that information to find the residual energy and use the tracker there. If you are interested, I can give you some more information about it. Are you willing to accept this mission?'}, npc, creature)
			talkState[playerId] = 'track'
		else
			npcHandler:say('You have already started that mission.', npc, creature)
		end
	end

	if talkState[playerId] == 'track' then
		if MsgContains(message, 'yes') then
			GHOST_DETECTOR_MAP[player:getGuid()] = Position.getFreeSand()
			player:addItem(19205, 1)
			player:setStorageValue(SPIKE_UPPER_TRACK_MAIN, 0)
			npcHandler:say('Gnometastic! Use this tracking device in the caves and locate the residual spirit energy. If you lose the tracking device, you\'ll have to bring your own. Gnomux sells all the equipment that is required for our missions.', npc, creature)
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
		if player:getStorageValue(SPIKE_UPPER_KILL_DAILY) >= os.time() then
			return npcHandler:say('Sorry, you have to wait ' .. string.diff(player:getStorageValue(SPIKE_UPPER_KILL_DAILY)-os.time()) .. ' before this task gets available again.', npc, creature)
		end

		if (player:getLevel() < levels[1]) or (player:getLevel() > levels[2]) then
			return npcHandler:say('Sorry, you are not on the required range of levels [' .. levels[1] ..'-' .. levels[2] ..'].', npc, creature)
		end

		if player:getStorageValue(SPIKE_UPPER_KILL_MAIN) == -1 then
			npcHandler:say('We need someone to reduce the steadily growing number of demon skeletons in the caves. If you are interested, I can give you some more information about it. Are you willing to accept this mission?', npc, creature)
			talkState[playerId] = 'kill'
		else
			npcHandler:say('You have already started that mission.', npc, creature)
		end
	end

	if talkState[playerId] == 'kill' then
		if MsgContains(message, 'yes') then
			player:setStorageValue(SPIKE_UPPER_KILL_MAIN, 0)
			npcHandler:say('Gnometastic! Just go out and kill them. You should find more of them than you like.', npc, creature)
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
