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
		npcHandler:setMessage(MESSAGE_GREET, {"Since you are obviously not one of my relatives who pays me a long overdue visit, we should get {work} right away. We'll see if you can prove your {worth} to our alliance."})
		playerTopic[cid] = 1
	end
	npcHandler:addFocus(cid)
	return true
end

keywordHandler:addKeyword({'work'}, StdModule.say, {npcHandler = npcHandler, text = 'Here\'s the situation: a tide of hazardous bugs, the gnomes named them {diremaws}, threatens our base. Then there is some kind of {growth} which seems connected to them somehow. We need to get rid of both.'})
keywordHandler:addKeyword({'worth'}, StdModule.say, {npcHandler = npcHandler, text = {'You\'re already known amongst the gnomes, member of the Bigfoot Brigade. I will make sure that the alliance learns of your deeds but you\'ll still need to help the dwarves and gnomes of this outpost to show your worth. ...',
																					  'We also found suspicious devices carried by all kinds of creatures down here. Down here, they are of extreme worth to us since they could contain the key to what\'s happening all around us. ... ',
																					  'If you can aquire any, return them to me and I make sure to tell the others of your generosity. Return to me afterwards to check on your current {status}.'}})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = {'Leading the charge! It\'s a war down here. I maintain the outer defences and supplies which are organised back in Kazordoon and also by the gnomes. ...',
																				   'I have sealed some of the areas far too dangerous for anyone to enter. If you can prove you\'re capable, you\'ll get an oportunity to help destroying the weird machines, pumping lava into the caves leading to the most dangerous enemies.',
																				   'But even if we knew nothing more about them, the fact alone that they employ the help of those mockeries of all things dwarfish, marks them as an enemy of the dwarves and it\'s our obligation to annihilate them.'}})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Bashsmite. That\'s all you need to know.'})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	npcHandler.topic[cid] = playerTopic[cid]
	local player = Player(cid)
	npc = Npc(cid)

	local tempo = 20*60*60

	-- missão diremaws
	if msgcontains(msg, "diremaws") and npcHandler.topic[cid] == 1 then
		if player:getStorageValue(Storage.DangerousDepths.Scouts.Diremaw ) == 2 and player:getStorageValue(Storage.DangerousDepths.Scouts.TimeTaskDiremaws) > 0 then -- Ainda não se passaram as 20h
			npcHandler:say({"I don't need your help for now. Come back later."}, cid)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
		if player:getStorageValue(Storage.DangerousDepths.Scouts.Diremaw) == 2 and player:getStorageValue(Storage.DangerousDepths.Scouts.TimeTaskDiremaws) <= 0 then -- Vai fazer a missão após 20h
			npcHandler:say({"The gnomes say that these creatures seem to thrive on mushroom sponges. But not only that, apparently they also lay eggs in their own cadavers to breed even faster. ...",
							"Yes, disgusting. I guess it provides everything their offspring needs... well, we probably shouldn't go into that much further. Instead we should focus on preventing that from happening. ... ",
							"If I understood that correctly, the gnomes 'grew' a device to completely neutralise diremaw corpses. Acting as a very effective counter measure. ... ",
							"A lot of corpses are lying around wherever these creatures are being hunted. Now all we need are, you guessed it, volunteers to clean up as many of those remains as possible ... ",
							"Are you willing to help? "}, cid)
			playerTopic[cid] = 2
			npcHandler.topic[cid] = 2
		end
		if player:getStorageValue(Storage.DangerousDepths.Scouts.Diremaw) < 1 then -- Não possuía a missão, agora possui!
			npcHandler:say({"The gnomes say that these creatures seem to thrive on mushroom sponges. But not only that, apparently they also lay eggs in their own cadavers to breed even faster. ...",
							"Yes, disgusting. I guess it provides everything their offspring needs... well, we probably shouldn't go into that much further. Instead we should focus on preventing that from happening. ... ",
							"If I understood that correctly, the gnomes 'grew' a device to completely neutralise diremaw corpses. Acting as a very effective counter measure. ... ",
							"A lot of corpses are lying around wherever these creatures are being hunted. Now all we need are, you guessed it, volunteers to clean up as many of those remains as possible ... ",
							"Are you willing to help? "}, cid)
			playerTopic[cid] = 2
			npcHandler.topic[cid] = 2
		elseif (player:getStorageValue(Storage.DangerousDepths.Scouts.Diremaw) == 1) and (player:getStorageValue(Storage.DangerousDepths.Scouts.DiremawsCount) < 20) then -- Está na missão porém não terminou a task!
			npcHandler:say({"Come back when you have finished your job."}, cid)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.DangerousDepths.Scouts.Diremaw) == 1 and player:getStorageValue(Storage.DangerousDepths.Scouts.DiremawsCount) >= 20 then -- Não possuía a missão, agora possui!
			npcHandler:say({"You got rid of a lot of corpses, very good. Now we have a realistic chance of pushing them back! Return to me later for more work if you want."}, cid)
			player:setStorageValue(Storage.DangerousDepths.Dwarves.TimeTaskDiremaws, os.time() + tempo)
			player:addItem(32014, 1)
			player:setStorageValue(Storage.DangerousDepths.Scouts.Status, player:getStorageValue(Storage.DangerousDepths.Scouts.Status) + 1)
			player:setStorageValue(Storage.DangerousDepths.Scouts.Diremaw, 2)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
	elseif npcHandler.topic[cid] == 2 and msgcontains(msg, "yes") then
		npcHandler:say({"Noted. Get one of the gnomish devices from the container next to me and 'use' it on any diremaw corpses to effectively neutralise them. At least the gnomes told me this will work - good luck!"}, cid)
		if player:getStorageValue(Storage.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.DangerousDepths.Scouts.Diremaw, 1)
		player:setStorageValue(Storage.DangerousDepths.Scouts.GnomishChest, 1) -- Permissão para usar o baú
		player:setStorageValue(Storage.DangerousDepths.Scouts.DiremawsCount, 0) -- Garantindo que a task não inicie com -1
		playerTopic[cid] = 1
		npcHandler.topic[cid] = 1
	end

	-- missão growth
	if msgcontains(msg, "growth") and npcHandler.topic[cid] == 1 then
		if player:getStorageValue(Storage.DangerousDepths.Scouts.Growth ) == 2 and player:getStorageValue(Storage.DangerousDepths.Scouts.TimeTaskGrowth) > 0 then -- Ainda não se passaram as 20h
			npcHandler:say({"I don't need your help for now. Come back later."}, cid)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
		if player:getStorageValue(Storage.DangerousDepths.Scouts.Growth) == 2 and player:getStorageValue(Storage.DangerousDepths.Scouts.TimeTaskGrowth) <= 0 then -- Vai fazer a missão após 20h
			npcHandler:say({"I can't explain that stuff, even the gnomes don't know what grows in those caves. All we know is that this stuff brought about all the diremaws we are now facing. ...",
							"This vermin is somehow attracted to this sponge, my guess is they use it as a nourishment, too. We need to get rid of the stuff regularly to reduce their numbers to a manageable level. ...",
							"We hauled our explosives down there - and I mean ALL our explosives. Dangerous? Indeed, so we positioned someone down there to actually watch this depot. ...",
							"We built an iron fence around it and added a mechanism to quickly get barrel if need be. Then an... accident happened to our guard down there and ...",
							"Well, to make a long story short, the barrels are unguarded right now and the diremaws are now too numerous and we are in desperate need of volunteers. ... ",
							"We need someone to take those barrels to the source of the ever growing sponge and burn it down. All of it. There should be at least five locations. Are you up for that? "}, cid)
			playerTopic[cid] = 22
			npcHandler.topic[cid] = 22
		end
		if player:getStorageValue(Storage.DangerousDepths.Scouts.Growth) < 1 then -- Não possuía a missão, agora possui!
			npcHandler:say({"I can't explain that stuff, even the gnomes don't know what grows in those caves. All we know is that this stuff brought about all the diremaws we are now facing. ...",
							"This vermin is somehow attracted to this sponge, my guess is they use it as a nourishment, too. We need to get rid of the stuff regularly to reduce their numbers to a manageable level. ...",
							"We hauled our explosives down there - and I mean ALL our explosives. Dangerous? Indeed, so we positioned someone down there to actually watch this depot. ...",
							"We built an iron fence around it and added a mechanism to quickly get barrel if need be. Then an... accident happened to our guard down there and ...",
							"Well, to make a long story short, the barrels are unguarded right now and the diremaws are now too numerous and we are in desperate need of volunteers. ... ",
							"We need someone to take those barrels to the source of the ever growing sponge and burn it down. All of it. There should be at least five locations. Are you up for that? "}, cid)
			playerTopic[cid] = 22
			npcHandler.topic[cid] = 22
		end
		if player:getStorageValue(Storage.DangerousDepths.Scouts.Growth) == 1 and player:getStorageValue(Storage.DangerousDepths.Scouts.BarrelCount) >= 3 then -- Não possuía a missão, agora possui!
			npcHandler:say({"You did a great job out there, the stuff will continue to grow, however. Return to me later for more work."}, cid)
			player:setStorageValue(Storage.DangerousDepths.Dwarves.TimeTaskGrowth, os.time() + tempo)
			if player:getStorageValue(Storage.DangerousDepths.Scouts.BarrelCount) >= 5 then
				player:addItem(32014, 2)
				player:setStorageValue(Storage.DangerousDepths.Scouts.Status, player:getStorageValue(Storage.DangerousDepths.Scouts.Status) + 2)
			else
				player:addItem(32014, 1)
				player:setStorageValue(Storage.DangerousDepths.Scouts.Status, player:getStorageValue(Storage.DangerousDepths.Scouts.Status) + 1)
			end
			player:setStorageValue(Storage.DangerousDepths.Scouts.Growth, 2)
			playerTopic[cid] = 1
			npcHandler.topic[cid] = 1
		end
	elseif npcHandler.topic[cid] == 22 and msgcontains(msg, "yes") then
		npcHandler:say({"Noted. Now, get down there and rain some fire on them."}, cid)
		if player:getStorageValue(Storage.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.DangerousDepths.Scouts.Growth, 1)
		player:setStorageValue(Storage.DangerousDepths.Scouts.BarrelCount, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Scouts.FirstBarrel, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Scouts.SecondBarrel, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Scouts.ThirdBarrel, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Scouts.FourthBarrel, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Scouts.FifthBarrel, 0) -- Garantindo que a task não inicie com -1

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
