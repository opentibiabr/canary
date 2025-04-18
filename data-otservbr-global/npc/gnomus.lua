local internalNpcName = "Gnomus"
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
	lookBody = 67,
	lookLegs = 67,
	lookFeet = 76,
	lookAddons = 0,
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

local amount = {}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local time = 20 * 60 * 60 -- 20 hours

	if MsgContains(message, "measurements") then
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Measurements) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.TimeTaskMeasurements) > 0 then
			npcHandler:say("I don't need your help for now. Come back later.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Measurements) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.TimeTaskMeasurements) <= 0 then
			npcHandler:say({
				"The heat down here is not the only problem we have but one of our greatest concerns. Not only is it almost unbearable for us, it also seems to be rising. ...",
				"We need to find out if this is true and what that means for this place - and for us gnomes. You can help us do this by grabbing one of our trignometres and collecting as much as data from the heat in this area as possible. ...",
				"We'd need at least 5 measurements. Are you willing to do this?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Measurements) < 1 then
			npcHandler:say({
				"The heat down here is not the only problem we have but one of our greatest concerns. Not only is it almost unbearable for us, it also seems to be rising. ...",
				"We need to find out if this is true and what that means for this place - and for us gnomes. You can help us do this by grabbing one of our trignometres and collecting as much as data from the heat in this area as possible. ...",
				"We'd need at least 5 measurements. Are you willing to do this?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Measurements) == 1) and (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationCount) < 5) then
			npcHandler:say("Come back when you have finished your job.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Measurements) == 1 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationCount) == 5 then
			npcHandler:say({
				"Excellent, you returned with more data! Let me see... hmm. ...",
				"Well, we need more data on this but first I will have to show this to our grand horticulturist. Thank you for getting this for us!",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.TimeTaskMeasurements, os.time() + time)
			player:addItem(27654, 1)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points) + 1)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Measurements, 2)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 2 and MsgContains(message, "yes") then
		npcHandler:say({
			"How fortunate! There are some trignometres lying around next to that device behind me. Take one and hold it next to high temperature heat sources. ...",
			"If you gathered enough data, you will actually smell it from the device. ...",
			"Return to me with the results afterwards. Best of luck, we count on you!",
		}, npc, creature)
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Measurements, 1)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.GnomeChartChest, 1)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationCount, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationA, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationB, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationC, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationD, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationE, 0)
		npcHandler:setTopic(playerId, 1)
	end

	if MsgContains(message, "ordnance") then
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance) == 3 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.TimeTaskOrdnance) > 0 then
			npcHandler:say("I don't need your help for now. Come back later.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance) == 3 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.TimeTaskOrdnance) <= 0 then
			npcHandler:say({
				"I am constantly waiting for ordnance to arrive. A lot of gnomes intend to travel out here to help us but the main access path to our base is not safe anymore. ...",
				"Tragically we lost several gnomes after an outbreak of what I can only describe as a force from below. We were completely surprised by their onslaught and retreated to this outpost. ...",
				"All our reinforcements arrive at the crystal teleporter to the east of the cave system. We need someone to navigate the new arrivals through the hazards of the dangerous caves. ...",
				"Hideous creatures and hot lava makes travelling extremely dangerous. And on top of that there is also the constant danger from falling rocks in the area. ...",
				"Are you willing to help?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 22)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance) < 1 then
			npcHandler:say({
				"I am constantly waiting for ordnance to arrive. A lot of gnomes intend to travel out here to help us but the main access path to our base is not safe anymore. ...",
				"Tragically we lost several gnomes after an outbreak of what I can only describe as a force from below. We were completely surprised by their onslaught and retreated to this outpost. ...",
				"All our reinforcements arrive at the crystal teleporter to the east of the cave system. We need someone to navigate the new arrivals through the hazards of the dangerous caves. ...",
				"Hideous creatures and hot lava makes travelling extremely dangerous. And on top of that there is also the constant danger from falling rocks in the area. ...",
				"Are you willing to help?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 22)
		elseif (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance) == 1) or (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.GnomesCount) < 5) then
			npcHandler:say("Come back when you have finished your job.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.GnomesCount) >= 5 then
			if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.CrawlersCount) >= 3 then
				npcHandler:say({
					"AMAZING! Not only did you salve all our friends - you also rescued the animals! Here is your reward and bonus! ...",
					"The other are already telling stories about you. Please return to me later if you want to help out some more!",
				}, npc, creature)
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.TimeTaskOrdnance, os.time() + time)
				player:addItem(27654, 2)
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points) + 2)
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance, 3)
			else
				npcHandler:say("The other are already telling stories about you. Please return to me later if you want to help out some more!", npc, creature)
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.TimeTaskOrdnance, os.time() + time)
				player:addItem(27654, 1)
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points) + 1)
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance, 3)
			end
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 22 and MsgContains(message, "yes") then
		npcHandler:say({
			"Excellent, just follow the path to east until you reach a dead end, there is a hole that leads to a small cave underneath which will bring you right to the old trail. ...",
			"Help whoever you can and return them to the save cave exit - oh, and while you're at it... some of them will have pack animals. If you can rescue those as well, I'll hand you a bonus. Good luck!",
		}, npc, creature)
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance, 1)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.GnomesCount, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.CrawlersCount, 0)
		npcHandler:setTopic(playerId, 1)
	end

	if MsgContains(message, "charting") then
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Charting) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.TimeTaskCharting) > 0 then
			npcHandler:say("I don't need your help for now. Come back later.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Charting) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.TimeTaskCharting) <= 0 then
			npcHandler:say({
				"While exploring these caves to find places to collect spores and grow mushrooms, we found several strange structures. I am convinced that this system was once home to intelligent beings. ...",
				"However, the creatures from below are now disturbing our research as well as some particularly pesky dwarves who just would not leave us alone. ...",
				"As we have our hands full with a lot of things right now, we could need someone to chart the unknown parts of this underground labyrinth ...",
				"I am especially interested in the scattered dark structures around these parts. Would you do that?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 33)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Charting) < 1 then
			npcHandler:say({
				"While exploring these caves to find places to collect spores and grow mushrooms, we found several strange structures. I am convinced that this system was once home to intelligent beings. ...",
				"However, the creatures from below are now disturbing our research as well as some particularly pesky dwarves who just would not leave us alone. ...",
				"As we have our hands full with a lot of things right now, we could need someone to chart the unknown parts of this underground labyrinth ...",
				"I am especially interested in the scattered dark structures around these parts. Would you do that?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 33)
		elseif (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Charting) == 1) and (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.ChartingCount) < 3) then
			npcHandler:say("Come back when you have finished your job.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Charting) == 1 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.ChartingCount) >= 3 then
			npcHandler:say("Thank you very much! With those structures mapped out we will be able to complete the puzzle in no time!", npc, creature)
			if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.ChartingCount) == 6 then
				player:addItem(27654, 2)
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points) + 2)
			else
				player:addItem(27654, 1)
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points) + 1)
			end
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Charting, 2)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.TimeTaskCharting, os.time() + time)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 33 and MsgContains(message, "yes") then
		npcHandler:say({
			"Very good. We prepared a lot of maps as the complete mapping of this system will probably take a lot of research. ...",
			"Take one from the stack here next to me and map as many structures as possible. However, we need at least three locations to make any sense of this ancient layout at all. ...",
			"If you manage to map one of each structure around these parts - I assume there must be at least two times as many around here - I will hand you a bonus!",
		}, npc, creature)
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Charting, 1)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.ChartingCount, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.GnomeChartPaper, 1)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.OldGate, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.TheGaze, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LostRuin, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Outpost, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Bastion, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.BrokenTower, 0)
		npcHandler:setTopic(playerId, 1)
	end

	local plural = ""

	if MsgContains(message, "suspicious devices") or MsgContains(message, "suspicious device") then
		npcHandler:say("If you bring me any suspicious devices on creatures you slay down here, I'll make it worth your while by telling the others of your generosity. How many do you want to offer? ", npc, creature)
		npcHandler:setTopic(playerId, 55)
	elseif npcHandler:getTopic(playerId) == 55 then
		amount[playerId] = tonumber(message)
		if amount[playerId] then
			if amount[playerId] > 1 then
				plural = plural .. "s"
			end
			npcHandler:say("You want to offer " .. amount[playerId] .. " suspicious device" .. plural .. ". Which leader shall have it, (Gnomus) of the {gnomes}, (Klom Stonecutter) of the {dwarves} or the {scouts} (Lardoc Bashsmite)?", npc, creature)
			npcHandler:setTopic(playerId, 56)
		else
			npcHandler:say("Don't waste my time.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "gnomes") and npcHandler:getTopic(playerId) == 56 then
		if player:getItemCount(27653) >= amount[playerId] then
			npcHandler:say("Done.", npc, creature)
			if amount[playerId] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned " .. amount[playerId] .. " point" .. plural .. " on the gnomes mission.")
			player:removeItem(27653, amount[playerId])
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points) + amount[playerId])
		else
			npcHandler:say("You don't have enough suspicious devices.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "dwarves") and npcHandler:getTopic(playerId) == 56 then
		if player:getItemCount(27653) >= amount[playerId] then
			npcHandler:say("Done.", npc, creature)
			if amount[playerId] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned " .. amount[playerId] .. " point" .. plural .. " on the dwarves mission.")
			player:removeItem(27653, amount[playerId])
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Points) + amount[playerId])
		else
			npcHandler:say("You don't have enough suspicious devices.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "scouts") and npcHandler:getTopic(playerId) == 56 then
		if player:getItemCount(27653) >= amount[playerId] then
			npcHandler:say("Done.", npc, creature)
			if amount[playerId] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned " .. amount[playerId] .. " point" .. plural .. " on the scouts mission.")
			player:removeItem(27653, amount[playerId])
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Points) + amount[playerId])
		else
			npcHandler:say("You don't have enough suspicious devices.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	end

	if MsgContains(message, "status") then
		npcHandler:say("So you want to know what we all think about your deeds? What leader's opinion are you interested in, the {gnomes} (Gnomus), the {dwarves} (Klom Stonecutter) or the {scouts} (Lardoc Bashsmite)?", npc, creature)
		npcHandler:setTopic(playerId, 5)
	elseif MsgContains(message, "gnomes") and npcHandler:getTopic(playerId) == 5 then
		npcHandler:say("The gnomes are still in need of your help, member of Bigfoot's Brigade. Prove your worth by answering their calls! (" .. math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points), 0) .. "/10)", npc, creature)
	elseif MsgContains(message, "dwarves") and npcHandler:getTopic(playerId) == 5 then
		npcHandler:say("The dwarves are still in need of your help, member of Bigfoot's Brigade. Prove your worth by answering their calls! (" .. math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Points), 0) .. "/10)", npc, creature)
	elseif MsgContains(message, "scouts") and npcHandler:getTopic(playerId) == 5 then
		npcHandler:say("The scouts are still in need of your help, member of Bigfoot's Brigade. Prove your worth by answering their calls! (" .. math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Points), 0) .. "/10)", npc, creature)
	end

	return true
end

keywordHandler:addKeyword({ "help" }, StdModule.say, { npcHandler = npcHandler, text = "If you're willing to help us, we could need an escort for arriving {ordnance}, help with {charting} the cave system and someone needs to get some heat {measurements} fast." })
keywordHandler:addKeyword({ "worthy" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"You're already known amongst the gnomes, member of the Bigfoot Brigade. I will make sure that the alliance learns of your deeds but you'll still need to help the dwarves and gnomes of this outpost to show your worth. ...",
		"We also found {suspicious devices} carried by all kinds of creatures down here. Down here, they are of extreme worth to us since they could contain the key to what's happening all around us. ...",
		"If you can aquire any, return them to me and I make sure to tell the others of your generosity. Return to me afterwards to check on your current {status}.",
	},
})
keywordHandler:addKeyword({ "base" }, StdModule.say, { npcHandler = npcHandler, text = {
	"Gnomish supplies and ingenuity have helped to establish and fortify this outpost. ...",
	"Our knowledge of the enemy and it's tactics would be of more use if the dwarves would listen to us somewhat more. But gnomes have learned to live with the imperfection of the other races.",
} })
keywordHandler:addKeyword({ "efforts" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Our surveys of the area showed us some spikes in heat and seismic activity at very specific places. ...",
		"We conclude this is no coincidence and the enemy is using devices to pump up the lava to flood the area. We have seen it before and had to retreat each time. ...",
		"This time though we might have a counter prepared - given me manage to pierce their defences.",
	},
})
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Gnomus." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'm the main gnomish contact for this base. I coordinate our efforts with those of the dwarves to ensure everything is running smoothly." })

npcHandler:setMessage(MESSAGE_GREET, "Greetings, member of the Bigfoot Brigade. We could really use some {help} from you right now. You should prove {worthy} to our alliance.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
