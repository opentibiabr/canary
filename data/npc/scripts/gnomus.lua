	local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

local playerTopic = {}
local quantidade = {}

local function greetCallback(cid)
	local player = Player(cid)
	if player then
		npcHandler:setMessage(MESSAGE_GREET, {"Greetings, member of the Bigfoot Brigade. We could really use some {help} from you right now. You should prove {worthy} to our alliance."})
		playerTopic[cid] = 1
	end
	npcHandler:addFocus(cid)
	return true
end

keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'If you\'re willing to help us, we could need an escort for arriving {ordnance}, help with {charting} the cave system and someone needs to get some heat {measurements} fast.'})
keywordHandler:addKeyword({'worthy'}, StdModule.say, {npcHandler = npcHandler, text = {'You\'re already known amongst the gnomes, member of the Bigfoot Brigade. I will make sure that the alliance learns of your deeds but you\'ll still need to help the dwarves and gnomes of this outpost to show your worth. ...',
																					   'We also found {suspicious devices} carried by all kinds of creatures down here. Down here, they are of extreme worth to us since they could contain the key to what\'s happening all around us. ...',
																					   'If you can aquire any, return them to me and I make sure to tell the others of your generosity. Return to me afterwards to check on your current {status}.'}})
keywordHandler:addKeyword({'base'}, StdModule.say, {npcHandler = npcHandler, text = {'Gnomish supplies and ingenuity have helped to establish and fortify this outpost. ...',
																					 'Our knowledge of the enemy and it\'s tactics would be of more use if the dwarves would listen to us somewhat more. But gnomes have learned to live with the imperfection of the other races.'}})
keywordHandler:addKeyword({'efforts'}, StdModule.say, {npcHandler = npcHandler, text = {'Our surveys of the area showed us some spikes in heat and seismic activity at very specific places. ...',
																				    'We conclude this is no coincidence and the enemy is using devices to pump up the lava to flood the area. We have seen it before and had to retreat each time. ...',
																				    'This time though we might have a counter prepared - given me manage to pierce their defences.'}})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Gnomus.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the main gnomish contact for this base. I coordinate our efforts with those of the dwarves to ensure everything is running smoothly.'})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	npcHandler.topic[cid] = playerTopic[cid]
	local player = Player(cid)
	npc = Npc(cid)

	local tempo = 20*60*60

	-- missão measurements
	if msgcontains(msg, "measurements") and npcHandler.topic[cid] == 1 then
		if player:getStorageValue(Storage.DangerousDepths.Gnomes.Measurements ) == 2 and player:getStorageValue(Storage.DangerousDepths.Gnomes.TimeTaskMeasurements) > 0 then -- Ainda não se passaram as 20h
			npcHandler:say({"I don't need your help for now. Come back later."}, cid)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
		if player:getStorageValue(Storage.DangerousDepths.Gnomes.Measurements) == 2 and player:getStorageValue(Storage.DangerousDepths.Gnomes.TimeTaskMeasurements) <= 0 then -- Vai fazer a missão após 20h
			npcHandler:say({"The heat down here is not the only problem we have but one of our greatest concerns. Not only is it almost unbearable for us, it also seems to be rising. ...",
							"We need to find out if this is true and what that means for this place - and for us gnomes. You can help us do this by grabbing one of our trignometres and collecting as much as data from the heat in this area as possible. ...",
							"We'd need at least 5 measurements. Are you willing to do this?"}, cid)
			playerTopic[cid] = 2
			npcHandler.topic[cid] = 2
		end
		if player:getStorageValue(Storage.DangerousDepths.Gnomes.Measurements) < 1 then -- Não possuía a missão, agora possui!
			npcHandler:say({"The heat down here is not the only problem we have but one of our greatest concerns. Not only is it almost unbearable for us, it also seems to be rising. ...",
							"We need to find out if this is true and what that means for this place - and for us gnomes. You can help us do this by grabbing one of our trignometres and collecting as much as data from the heat in this area as possible. ...",
							"We'd need at least 5 measurements. Are you willing to do this?"}, cid)
			playerTopic[cid] = 2
			npcHandler.topic[cid] = 2
		elseif (player:getStorageValue(Storage.DangerousDepths.Gnomes.Measurements) == 1) and (player:getStorageValue(Storage.DangerousDepths.Gnomes.LocationCount) < 5) then -- Está na missão porém não terminou a task!
			npcHandler:say({"Come back when you have finished your job."}, cid)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.DangerousDepths.Gnomes.Measurements) == 1 and player:getStorageValue(Storage.DangerousDepths.Gnomes.LocationCount) == 5 then -- Não possuía a missão, agora possui!
			npcHandler:say({"Excellent, you returned with more data! Let me see... hmm. ...",
							"Well, we need more data on this but first I will have to show this to our grand horticulturist. Thank you for getting this for us!"}, cid)
			player:setStorageValue(Storage.DangerousDepths.Gnomes.TimeTaskMeasurements, os.time() + tempo)
			player:addItem(32014, 1)
			player:setStorageValue(Storage.DangerousDepths.Gnomes.Status, player:getStorageValue(Storage.DangerousDepths.Gnomes.Status) + 1)
			player:setStorageValue(Storage.DangerousDepths.Gnomes.Measurements, 2)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
	elseif npcHandler.topic[cid] == 2 and msgcontains(msg, "yes") then
		npcHandler:say({"How fortunate! There are some trignometres lying around next to that device behind me. Take one and hold it next to high temperature heat sources. ...",
						"If you gathered enough data, you will actually smell it from the device. ...",
						"Return to me with the results afterwards. Best of luck, we count on you!"}, cid)
		if player:getStorageValue(Storage.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.DangerousDepths.Gnomes.Measurements, 1)
		player:setStorageValue(Storage.DangerousDepths.Gnomes.GnomeChartChest, 1) -- Permissão para usar o baú
		player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationCount, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationA, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationB, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationC, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationD, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationE, 0) -- Garantindo que a task não inicie com -1
		playerTopic[cid] = 1
		npcHandler.topic[cid] = 1
	end

	-- missão ordnance
	if msgcontains(msg, "ordnance") and npcHandler.topic[cid] == 1 then
		if player:getStorageValue(Storage.DangerousDepths.Gnomes.Ordnance) == 3 and player:getStorageValue(Storage.DangerousDepths.Gnomes.TimeTaskOrdnance) > 0 then -- Ainda não se passaram as 20h
			npcHandler:say({"I don't need your help for now. Come back later."}, cid)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
		if player:getStorageValue(Storage.DangerousDepths.Gnomes.Ordnance) == 3 and player:getStorageValue(Storage.DangerousDepths.Gnomes.TimeTaskOrdnance) <= 0 then -- Vai fazer a missão após 20h
			npcHandler:say({"I am constantly waiting for ordnance to arrive. A lot of gnomes intend to travel out here to help us but the main access path to our base is not safe anymore. ...",
							"Tragically we lost several gnomes after an outbreak of what I can only describe as a force from below. We were completely surprised by their onslaught and retreated to this outpost. ...",
							"All our reinforcements arrive at the crystal teleporter to the east of the cave system. We need someone to navigate the new arrivals through the hazards of the dangerous caves. ...",
							"Hideous creatures and hot lava makes travelling extremely dangerous. And on top of that there is also the constant danger from falling rocks in the area. ...",
							"Are you willing to help?"}, cid)
			playerTopic[cid] = 22
			npcHandler.topic[cid] = 22
		end
		if player:getStorageValue(Storage.DangerousDepths.Gnomes.Ordnance) < 1 then -- Não possuía a missão, agora possui!
			npcHandler:say({"I am constantly waiting for ordnance to arrive. A lot of gnomes intend to travel out here to help us but the main access path to our base is not safe anymore. ...",
							"Tragically we lost several gnomes after an outbreak of what I can only describe as a force from below. We were completely surprised by their onslaught and retreated to this outpost. ...",
							"All our reinforcements arrive at the crystal teleporter to the east of the cave system. We need someone to navigate the new arrivals through the hazards of the dangerous caves. ...",
							"Hideous creatures and hot lava makes travelling extremely dangerous. And on top of that there is also the constant danger from falling rocks in the area. ...",
							"Are you willing to help?"}, cid)
			playerTopic[cid] = 22
			npcHandler.topic[cid] = 22
		elseif (player:getStorageValue(Storage.DangerousDepths.Gnomes.Ordnance) == 1) or (player:getStorageValue(Storage.DangerousDepths.Gnomes.Ordnance) == 2 and player:getStorageValue(Storage.DangerousDepths.Gnomes.GnomesCount) < 5) then -- Está na missão porém não terminou a task!
			npcHandler:say({"Come back when you have finished your job."}, cid)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.DangerousDepths.Gnomes.Ordnance) == 2 and player:getStorageValue(Storage.DangerousDepths.Gnomes.GnomesCount) >= 5 then -- Não possuía a missão, agora possui!
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.CrawlersCount) >= 3 then
				npcHandler:say({"AMAZING! Not only did you salve all our friends - you also rescued the animals! Here is your reward and bonus! ...",
								"The other are already telling stories about you. Please return to me later if you want to help out some more!"}, cid)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.TimeTaskOrdnance, os.time() + tempo)
				player:addItem(32014, 2)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.Status, player:getStorageValue(Storage.DangerousDepths.Gnomes.Status) + 2)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.Ordnance, 3)
			else
				npcHandler:say({"The other are already telling stories about you. Please return to me later if you want to help out some more!"}, cid)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.TimeTaskOrdnance, os.time() + tempo)
				player:addItem(32014, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.Status, player:getStorageValue(Storage.DangerousDepths.Gnomes.Status) + 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.Ordnance, 3)
			end
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
	elseif npcHandler.topic[cid] == 22 and msgcontains(msg, "yes") then
		npcHandler:say({"Excellent, just follow the path to east until you reach a dead end, there is a hole that leads to a small cave underneath which will bring you right to the old trail. ...",
						"Help whoever you can and return them to the save cave exit - oh, and while you're at it... some of them will have pack animals. If you can rescue those as well, I'll hand you a bonus. Good luck!"}, cid)
		if player:getStorageValue(Storage.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.DangerousDepths.Gnomes.Ordnance, 1)
		player:setStorageValue(Storage.DangerousDepths.Gnomes.GnomesCount, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Gnomes.CrawlersCount, 0) -- Garantindo que a task não inicie com -1
		playerTopic[cid] = 1
		npcHandler.topic[cid] = 1
	end

	-- missão charting
	if msgcontains(msg, "charting") and npcHandler.topic[cid] == 1 then
		if player:getStorageValue(Storage.DangerousDepths.Gnomes.Charting) == 2 and player:getStorageValue(Storage.DangerousDepths.Gnomes.TimeTaskCharting) > 0 then -- Ainda não se passaram as 20h
			npcHandler:say({"I don't need your help for now. Come back later."}, cid)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
		if player:getStorageValue(Storage.DangerousDepths.Gnomes.Charting) == 2 and player:getStorageValue(Storage.DangerousDepths.Gnomes.TimeTaskCharting) <= 0 then -- Vai fazer a missão após 20h
			npcHandler:say({"While exploring these caves to find places to collect spores and grow mushrooms, we found several strange structures. I am convinced that this system was once home to intelligent beings. ...",
							"However, the creatures from below are now disturbing our research as well as some particularly pesky dwarves who just would not leave us alone. ...",
							"As we have our hands full with a lot of things right now, we could need someone to chart the unknown parts of this underground labyrinth ...",
							"I am especially interested in the scattered dark structures around these parts. Would you do that?"}, cid)
			playerTopic[cid] = 33
			npcHandler.topic[cid] = 33
		end
		if player:getStorageValue(Storage.DangerousDepths.Gnomes.Charting) < 1 then -- Não possuía a missão, agora possui!
			npcHandler:say({"While exploring these caves to find places to collect spores and grow mushrooms, we found several strange structures. I am convinced that this system was once home to intelligent beings. ...",
							"However, the creatures from below are now disturbing our research as well as some particularly pesky dwarves who just would not leave us alone. ...",
							"As we have our hands full with a lot of things right now, we could need someone to chart the unknown parts of this underground labyrinth ...",
							"I am especially interested in the scattered dark structures around these parts. Would you do that?"}, cid)
			playerTopic[cid] = 33
			npcHandler.topic[cid] = 33
		elseif (player:getStorageValue(Storage.DangerousDepths.Gnomes.Charting) == 1) and (player:getStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount) < 3) then -- Está na missão porém não terminou a task!
		npcHandler:say({"Come back when you have finished your job."}, cid)
		playerTopic[cid] = 1
		npcHandler.topic[cid] = 1
		end
		if player:getStorageValue(Storage.DangerousDepths.Gnomes.Charting) == 1 and player:getStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount) >= 3 then -- Não possuía a missão, agora possui!
			npcHandler:say({"Thank you very much! With those structures mapped out we will be able to complete the puzzle in no time!"}, cid)
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount) == 6 then
				player:addItem(32014, 2)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.Status, player:getStorageValue(Storage.DangerousDepths.Gnomes.Status) + 2)
			else
				player:addItem(32014, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.Status, player:getStorageValue(Storage.DangerousDepths.Gnomes.Status) + 1)
			end
			player:setStorageValue(Storage.DangerousDepths.Gnomes.Charting, 2)
			player:setStorageValue(Storage.DangerousDepths.Gnomes.TimeTaskCharting, os.time() + tempo)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
	elseif npcHandler.topic[cid] == 33 and msgcontains(msg, "yes") then
		npcHandler:say({"Very good. We prepared a lot of maps as the complete mapping of this system will probably take a lot of research. ...",
						"Take one from the stack here next to me and map as many structures as possible. However, we need at least three locations to make any sense of this ancient layout at all. ...",
						"If you manage to map one of each structure around these parts - I assume there must be at least two times as many around here - I will hand you a bonus!"}, cid)
		if player:getStorageValue(Storage.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.DangerousDepths.Gnomes.Charting, 1)
		player:setStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Gnomes.GnomeChartPaper, 1) -- Permissão para usar o papel
		player:setStorageValue(Storage.DangerousDepths.Gnomes.OldGate, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Gnomes.TheGaze, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Gnomes.LostRuin, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Gnomes.Outpost, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Gnomes.Bastion, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Gnomes.BrokenTower, 0) -- Garantindo que a task não inicie com -1
		playerTopic[cid] = 1
		npcHandler.topic[cid] = 1
	end


	local plural = ""
	if msgcontains(msg, "suspicious devices") or msgcontains(msg, "suspicious device") then
		npcHandler:say({"If you bring me any suspicious devices on creatures you slay down here, I'll make it worth your while by telling the others of your generosity. How many do you want to offer? "}, cid)
		playerTopic[cid] = 55
		npcHandler.topic[cid] = 55
	elseif npcHandler.topic[cid] == 55 then
		quantidade[cid] = tonumber(msg)
		if quantidade[cid] then
			if quantidade[cid] > 1 then
				plural = plural .. "s"
			end
			npcHandler:say({"You want to offer " .. quantidade[cid] .. " suspicious device" ..plural.. ". Which leader shall have it, (Gnomus) of the {gnomes}, (Klom Stonecutter) of the {dwarves} or the {scouts} (Lardoc Bashsmite)?"}, cid)
			playerTopic[cid] = 56
			npcHandler.topic[cid] = 56
		else
			npcHandler:say({"Don't waste my time."}, cid)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "gnomes") and npcHandler.topic[cid] == 56 then
		if player:getItemCount(30888) >= quantidade[cid] then
			npcHandler:say({"Done."}, cid)
			if quantidade[cid] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned ".. quantidade[cid] .." point"..plural.." on the gnomes mission.")
			player:removeItem(30888, quantidade[cid])
			player:setStorageValue(Storage.DangerousDepths.Gnomes.Status, player:getStorageValue(Storage.DangerousDepths.Gnomes.Status) + quantidade[cid])
		else
			npcHandler:say({"You don't have enough suspicious devices."}, cid)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "dwarves") and npcHandler.topic[cid] == 56 then
		if player:getItemCount(30888) >= quantidade[cid] then
			npcHandler:say({"Done."}, cid)
			if quantidade[cid] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned ".. quantidade[cid] .." point"..plural.." on the dwarves mission.")
			player:removeItem(30888, quantidade[cid])
			player:setStorageValue(Storage.DangerousDepths.Dwarves.Status, player:getStorageValue(Storage.DangerousDepths.Dwarves.Status) + quantidade[cid])
		else
			npcHandler:say({"You don't have enough suspicious devices."}, cid)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "scouts") and npcHandler.topic[cid] == 56 then
		if player:getItemCount(30888) >= quantidade[cid] then
			npcHandler:say({"Done."}, cid)
			if quantidade[cid] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned ".. quantidade[cid] .." point"..plural.." on the scouts mission.")
			player:removeItem(30888, quantidade[cid])
			player:setStorageValue(Storage.DangerousDepths.Scouts.Status, player:getStorageValue(Storage.DangerousDepths.Scouts.Status) + quantidade[cid])
		else
			npcHandler:say({"You don't have enough suspicious devices."}, cid)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
	end



		-- Início checagem de pontos de tasks!!
	if msgcontains(msg, "status") then
		npcHandler:say({"So you want to know what we all think about your deeds? What leader\'s opinion are you interested in, the {gnomes} (Gnomus), the {dwarves} (Klom Stonecutter) or the {scouts} (Lardoc Bashsmite)?"}, cid)
		playerTopic[cid] = 5
		npcHandler.topic[cid] = 5
	elseif msgcontains(msg, "gnomes") and npcHandler.topic[cid] == 5 then
		npcHandler:say({'The gnomes are still in need of your help, member of Bigfoot\'s Brigade. Prove your worth by answering their calls! (' .. math.max(player:getStorageValue(Storage.DangerousDepths.Gnomes.Status), 0) .. '/10)'}, cid)
	elseif msgcontains(msg, "dwarves") and npcHandler.topic[cid] == 5 then
		npcHandler:say({'The dwarves are still in need of your help, member of Bigfoot\'s Brigade. Prove your worth by answering their calls! (' .. math.max(player:getStorageValue(Storage.DangerousDepths.Dwarves.Status), 0) .. '/10)'}, cid)
	elseif msgcontains(msg, "scouts") and npcHandler.topic[cid] == 5 then
		npcHandler:say({'The scouts are still in need of your help, member of Bigfoot\'s Brigade. Prove your worth by answering their calls! (' .. math.max(player:getStorageValue(Storage.DangerousDepths.Scouts.Status), 0) .. '/10)'}, cid)
	end
	return true
end



npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
