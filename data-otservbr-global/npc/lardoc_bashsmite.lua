local internalNpcName = "Lardoc Bashsmite"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 160,
	lookHead = 57,
	lookBody = 47,
	lookLegs = 47,
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

	if MsgContains(message, "diremaws") then
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Diremaw) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.TimeTaskDiremaws) > 0 then
			npcHandler:say("I don't need your help for now. Come back later.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Diremaw) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.TimeTaskDiremaws) <= 0 then
			npcHandler:say({
				"The gnomes say that these creatures seem to thrive on mushroom sponges. But not only that, apparently they also lay eggs in their own cadavers to breed even faster. ...",
				"Yes, disgusting. I guess it provides everything their offspring needs... well, we probably shouldn't go into that much further. Instead we should focus on preventing that from happening. ... ",
				"If I understood that correctly, the gnomes 'grew' a device to completely neutralise diremaw corpses. Acting as a very effective counter measure. ... ",
				"A lot of corpses are lying around wherever these creatures are being hunted. Now all we need are, you guessed it, volunteers to clean up as many of those remains as possible ... ",
				"Are you willing to help? ",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Diremaw) < 1 then
			npcHandler:say({
				"The gnomes say that these creatures seem to thrive on mushroom sponges. But not only that, apparently they also lay eggs in their own cadavers to breed even faster. ...",
				"Yes, disgusting. I guess it provides everything their offspring needs... well, we probably shouldn't go into that much further. Instead we should focus on preventing that from happening. ... ",
				"If I understood that correctly, the gnomes 'grew' a device to completely neutralise diremaw corpses. Acting as a very effective counter measure. ... ",
				"A lot of corpses are lying around wherever these creatures are being hunted. Now all we need are, you guessed it, volunteers to clean up as many of those remains as possible ... ",
				"Are you willing to help? ",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Diremaw) == 1) and (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.DiremawsCount) < 20) then
			npcHandler:say("Come back when you have finished your job.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Diremaw) == 1 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.DiremawsCount) >= 20 then
			npcHandler:say("You got rid of a lot of corpses, very good. Now we have a realistic chance of pushing them back! Return to me later for more work if you want.", npc, creature)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.TimeTaskDiremaws, os.time() + time)
			player:addItem(27654, 1)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Points) + 1)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Diremaw, 2)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 2 and MsgContains(message, "yes") then
		npcHandler:say("Noted. Get one of the gnomish devices from the container next to me and 'use' it on any diremaw corpses to effectively neutralise them. At least the gnomes told me this will work - good luck!", npc, creature)
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Diremaw, 1)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.GnomishChest, 1)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.DiremawsCount, 0)
		npcHandler:setTopic(playerId, 1)
	end

	if MsgContains(message, "growth") then
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Growth) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.TimeTaskGrowth) > 0 then
			npcHandler:say("I don't need your help for now. Come back later.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Growth) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.TimeTaskGrowth) <= 0 then
			npcHandler:say({
				"I can't explain that stuff, even the gnomes don't know what grows in those caves. All we know is that this stuff brought about all the diremaws we are now facing. ...",
				"This vermin is somehow attracted to this sponge, my guess is they use it as a nourishment, too. We need to get rid of the stuff regularly to reduce their numbers to a manageable level. ...",
				"We hauled our explosives down there - and I mean ALL our explosives. Dangerous? Indeed, so we positioned someone down there to actually watch this depot. ...",
				"We built an iron fence around it and added a mechanism to quickly get barrel if need be. Then an... accident happened to our guard down there and ...",
				"Well, to make a long story short, the barrels are unguarded right now and the diremaws are now too numerous and we are in desperate need of volunteers. ... ",
				"We need someone to take those barrels to the source of the ever growing sponge and burn it down. All of it. There should be at least five locations. Are you up for that? ",
			}, npc, creature)
			npcHandler:setTopic(playerId, 22)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Growth) < 1 then
			npcHandler:say({
				"I can't explain that stuff, even the gnomes don't know what grows in those caves. All we know is that this stuff brought about all the diremaws we are now facing. ...",
				"This vermin is somehow attracted to this sponge, my guess is they use it as a nourishment, too. We need to get rid of the stuff regularly to reduce their numbers to a manageable level. ...",
				"We hauled our explosives down there - and I mean ALL our explosives. Dangerous? Indeed, so we positioned someone down there to actually watch this depot. ...",
				"We built an iron fence around it and added a mechanism to quickly get barrel if need be. Then an... accident happened to our guard down there and ...",
				"Well, to make a long story short, the barrels are unguarded right now and the diremaws are now too numerous and we are in desperate need of volunteers. ... ",
				"We need someone to take those barrels to the source of the ever growing sponge and burn it down. All of it. There should be at least five locations. Are you up for that? ",
			}, npc, creature)
			npcHandler:setTopic(playerId, 22)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Growth) == 1 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.BarrelCount) >= 3 then
			npcHandler:say("You did a great job out there, the stuff will continue to grow, however. Return to me later for more work.", npc, creature)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.TimeTaskGrowth, os.time() + time)
			if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.BarrelCount) >= 5 then
				player:addItem(27654, 2)
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Points) + 2)
			else
				player:addItem(27654, 1)
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Points) + 1)
			end
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Growth, 2)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 22 and MsgContains(message, "yes") then
		npcHandler:say("Noted. Now, get down there and rain some fire on them.", npc, creature)
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Growth, 1)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.BarrelCount, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.FirstBarrel, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.SecondBarrel, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.ThirdBarrel, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.FourthBarrel, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.FifthBarrel, 0)

		npcHandler:setTopic(playerId, 1)
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

keywordHandler:addKeyword({ "work" }, StdModule.say, { npcHandler = npcHandler, text = "Here's the situation: a tide of hazardous bugs, the gnomes named them {diremaws}, threatens our base. Then there is some kind of {growth} which seems connected to them somehow. We need to get rid of both." })
keywordHandler:addKeyword({ "worth" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"You're already known amongst the gnomes, member of the Bigfoot Brigade. I will make sure that the alliance learns of your deeds but you'll still need to help the dwarves and gnomes of this outpost to show your worth. ...",
		"We also found suspicious devices carried by all kinds of creatures down here. Down here, they are of extreme worth to us since they could contain the key to what's happening all around us. ... ",
		"If you can aquire any, return them to me and I make sure to tell the others of your generosity. Return to me afterwards to check on your current {status}.",
	},
})
keywordHandler:addKeyword({ "job" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Leading the charge! It's a war down here. I maintain the outer defences and supplies which are organised back in Kazordoon and also by the gnomes. ...",
		"I have sealed some of the areas far too dangerous for anyone to enter. If you can prove you're capable, you'll get an oportunity to help destroying the weird machines, pumping lava into the caves leading to the most dangerous enemies.",
		"But even if we knew nothing more about them, the fact alone that they employ the help of those mockeries of all things dwarfish, marks them as an enemy of the dwarves and it's our obligation to annihilate them.",
	},
})
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Bashsmite. That's all you need to know." })

npcHandler:setMessage(MESSAGE_GREET, "Since you are obviously not one of my relatives who pays me a long overdue visit, we should get {work} right away. We'll see if you can prove your {worth} to our alliance.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
