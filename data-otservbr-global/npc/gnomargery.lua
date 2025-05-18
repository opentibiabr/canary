local internalNpcName = "Gnomargery"
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
	lookHead = 96,
	lookBody = 92,
	lookLegs = 96,
	lookFeet = 114,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

local talkState = {}
local level = 80
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

	if MsgContains(message, "job") then
		return npcHandler:say("I'm the officer responsible for this area. I give out missions, accept mission reports and oversee our defences.", npc, creature)
	end

	if MsgContains(message, "gnome") then
		return npcHandler:say("It's good to be a gnome for sure!", npc, creature)
	end

	if MsgContains(message, "area") then
		return npcHandler:say({
			"On the levels outside, we encountered the first serious resistance of our true enemy. As evidenced by the unnatural heat in an area with little volcanic activity, there is 'something' strange going on here. ...",
			"Even the lava pools we have found here are not actually lava, but rock that was molten pretty much recently without any reasonable connection to some natural heat source. And for all we can tell, the heat is growing, slowly but steadily. ...",
			"This is the first time ever that we can witness our enemy at work. Here we can learn a lot about its operations. ...",
			"How they work, and possibly how to stop them. But therefore expeditions into the depths are necessary. The areas around us are highly dangerous, and a lethal threat to us and the Spike as a whole. ... ",
			"Our first object is to divert the forces of the enemy and weaken them as good as we can while gathering as much information as possible about them and their movements. Only highly skilled adventurers stand a chance to help us down here. ...",
		}, npc, creature)
	end

	if MsgContains(message, "spike") then
		return npcHandler:say("Now that's gnomish ingenuity given shape! Who but a gnome would come up with such a plan to defeat our enemies. ", npc, creature)
	end

	if MsgContains(message, "mission") then
		if player:getLevel() < level then
			npcHandler:say("Sorry, but no! Your expertise could be put to better use elsewhere. You are desperately needed in the upper levels of the Spike. Report there immediately. ", npc, creature)
		else
			npcHandler:say("I can offer you several missions: to {deliver} parcels to our boys and girls in the battlefield, to get reports from our {undercover} gnomes, to do some {temperature} measuring and to {kill} some drillworms.", npc, creature)
		end
		return
	end

	if MsgContains(message, "report") then
		talkState[playerId] = "report"
		return npcHandler:say(" What mission do you want to report about: the {delivery} of parcels, the {undercover} reports, the {temperature} measuring or {kill} of drillworms?", npc, creature)
	end

	if talkState[playerId] == "report" then
		if MsgContains(message, "delivery") then
			if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Main) == -1 then
				npcHandler:say("You have not started that mission.", npc, creature)
			elseif player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Main) == 4 then
				npcHandler:say("You have done well. Here, take your reward.", npc, creature)
				player:addFamePoint()
				player:addExperience(3500, true)
				player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Main, -1)
				player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Daily, os.time() + 72000)
			else
				npcHandler:say("Gnowful! Deliver the four parcels to some of our far away outposts in the caverns.", npc, creature)
			end
		elseif MsgContains(message, "undercover") then
			if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Undercover_Main) == -1 then
				npcHandler:say("You have not started that mission.", npc, creature)
			elseif player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Undercover_Main) == 3 then
				npcHandler:say("You have done well. Here, take your reward.", npc, creature)
				player:addFamePoint()
				player:addExperience(3500, true)
				player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Undercover_Main, -1)
				player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Undercover_Daily, os.time() + 72000)
			else
				npcHandler:say("Gnowful! Get three reports from our undercover agents posing as monsters in the caves around us.", npc, creature)
			end
		elseif MsgContains(message, "temperature") then
			if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Lava_Main) == -1 then
				npcHandler:say("You have not started that mission.", npc, creature)
			elseif player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Lava_Main) == 1 then
				npcHandler:say("You have done well. Here, take your reward.", npc, creature)
				player:addFamePoint()
				player:addExperience(3500, true)
				player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Lava_Main, -1)
				player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Lava_Daily, os.time() + 72000)
			else
				npcHandler:say("Gnowful! Use the gnomish temperature measurement device to locate the hottest spot at the lava pools in the cave.", npc, creature)
			end
		elseif MsgContains(message, "kill") then
			if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Kill_Main) == -1 then
				npcHandler:say("You have not started that mission.", npc, creature)
			elseif player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Kill_Main) == 7 then
				npcHandler:say("You have done well. Here, take your reward.", npc, creature)
				player:addFamePoint()
				player:addExperience(3500, true)
				player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Kill_Main, -1)
				player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Kill_Daily, os.time() + 72000)
			else
				npcHandler:say("Gnowful! Just go out to the caves and kill at least seven drillworms.", npc, creature)
			end
		else
			npcHandler:say("That's not a valid mission name.", npc, creature)
		end
		talkState[playerId] = nil
		return
	end

	--[[///////////////////
	////PARCEL DELIVERY////
	/////////////////////]]
	if MsgContains(message, "deliver") then
		if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Daily) >= os.time() then
			return npcHandler:say("Sorry, you have to wait " .. string.diff(player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Daily) - os.time()) .. " before this task gets available again.", npc, creature)
		end

		if player:getLevel() < level then
			return npcHandler:say("Sorry, you are not on the required minimum level [" .. level .. "].", npc, creature)
		end

		if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Main) == -1 then
			npcHandler:say("We need someone to bring four parcels to some of our far away outposts in the caverns. If you are interested, I can give you some more {information} about it. Are you willing to accept this mission?", npc, creature)
			talkState[playerId] = "delivery"
		else
			npcHandler:say("You have already started that mission.", npc, creature)
		end
	end

	if talkState[playerId] == "delivery" then
		if MsgContains(message, "yes") then
			player:addItem(19219, 4)
			player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Main, 0)
			npcHandler:say({ "Gnometastic! Here are the parcels. Regrettably, the labels got lost during transport; but I guess those lonely gnomes won't mind as long as they get ANY parcel at all.", "If you lose the parcels, you'll have to get new ones. Gnomux sells all the equipment that is required for our missions." }, npc, creature)
			talkState[playerId] = nil
		elseif MsgContains(message, "no") then
			npcHandler:say("Ok then.", npc, creature)
			talkState[playerId] = nil
		end
	end

	--[[//////////////
	////UNDERCOVER////
	////////////////]]
	if MsgContains(message, "undercover") then
		if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Undercover_Daily) >= os.time() then
			return npcHandler:say("Sorry, you have to wait " .. string.diff(player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Undercover_Daily) - os.time()) .. " before this task gets available again.", npc, creature)
		end

		if player:getLevel() < level then
			return npcHandler:say("Sorry, you are not on the required minimum level [" .. level .. "].", npc, creature)
		end

		if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Undercover_Main) == -1 then
			npcHandler:say("Someone is needed to get three reports from our undercover agents posing as monsters in the caves around us. If you are interested, I can give you some more {information} about it. Are you willing to accept this mission?", npc, creature)
			talkState[playerId] = "undercover"
		else
			npcHandler:say("You have already started that mission.", npc, creature)
		end
	end

	if talkState[playerId] == "undercover" then
		if MsgContains(message, "yes") then
			player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Undercover_Main, 0)
			npcHandler:say("Gnometastic! Get three reports from our agents. You can find them anywhere in the caves around us. Just keep looking for monsters that behave strangely and give you a wink.", npc, creature)
			talkState[playerId] = nil
		elseif MsgContains(message, "no") then
			npcHandler:say("Ok then.", npc, creature)
			talkState[playerId] = nil
		end
	end

	--[[////////////////
	////TEMPERATURE/////
	//////////////////]]
	if MsgContains(message, "temperature") then
		if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Lava_Daily) >= os.time() then
			return npcHandler:say("Sorry, you have to wait " .. string.diff(player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Lava_Daily) - os.time()) .. " before this task gets available again.", npc, creature)
		end

		if player:getLevel() < level then
			return npcHandler:say("Sorry, you are not on the required minimum level [" .. level .. "].", npc, creature)
		end

		if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Lava_Main) == -1 then
			npcHandler:say("Your task would be to use a gnomish temperature measurement device - short GTMD - to locate the hottest spot at the lava pools in the caves. If you are interested, I can give you some more information about it. Are you willing to accept this mission?", npc, creature)
			talkState[playerId] = "temperature"
		else
			npcHandler:say("You have already started that mission.", npc, creature)
		end
	end

	if talkState[playerId] == "temperature" then
		if MsgContains(message, "yes") then
			player:addItem(19206, 1)
			player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Lava_Main, 0)
			npcHandler:say("Gnometastic! Find the hottest spot of the lava pools in the caves. If you lose the GTMD before you find the hot spot, you'll have to get yourself a new one. Gnomux sells all the equipment that is required for our missions.", npc, creature)
			talkState[playerId] = nil
		elseif MsgContains(message, "no") then
			npcHandler:say("Ok then.", npc, creature)
			talkState[playerId] = nil
		end
	end

	--[[/////////
	////KILL/////
	///////////]]
	if MsgContains(message, "kill") then
		if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Kill_Daily) >= os.time() then
			return npcHandler:say("Sorry, you have to wait " .. string.diff(player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Kill_Daily) - os.time()) .. " before this task gets available again.", npc, creature)
		end

		if player:getLevel() < level then
			return npcHandler:say("Sorry, you are not on the required minimum level [" .. level .. "].", npc, creature)
		end

		if player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Kill_Main) == -1 then
			npcHandler:say("This mission will require you to kill some drillworms for us. If you are interested, I can give you some more {information} about it. Are you willing to accept this mission?", npc, creature)
			talkState[playerId] = "kill"
		else
			npcHandler:say("You have already started that mission.", npc, creature)
		end
	end

	if talkState[playerId] == "kill" then
		if MsgContains(message, "yes") then
			player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Kill_Main, 0)
			npcHandler:say("Gnometastic! You should have no trouble finding enough drillworms.", npc, creature)
			talkState[playerId] = nil
		elseif MsgContains(message, "no") then
			npcHandler:say("Ok then.", npc, creature)
			talkState[playerId] = nil
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hi!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
