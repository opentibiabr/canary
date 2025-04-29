local internalNpcName = "Klom Stonecutter"
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
	lookHead = 3,
	lookBody = 77,
	lookLegs = 68,
	lookFeet = 76,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Ah." },
	{ text = "We need more volunteers!" },
	{ text = 'And they call this "deep"...' },
	{ text = "Preparation is paramount." },
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

local count = {}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local time = 20 * 60 * 60 -- 20 hours

	if MsgContains(message, "subterraneans") then
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Subterranean) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.TimeTaskSubterranean) > 0 then
			npcHandler:say("I don't need your help for now. Come back later.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Subterranean) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.TimeTaskSubterranean) <= 0 then
			npcHandler:say({
				"Vermin. Everywhere. We get a lot of strange four-legged crawlers and worms down here lately. It's getting out of hand and... well, I need a real killer for this. ",
				"Prepared to get rid of some seriously foul creepers for us?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Subterranean) < 1 then
			npcHandler:say({
				"Vermin. Everywhere. We get a lot of strange four-legged crawlers and worms down here lately. It's getting out of hand and... well, I need a real killer for this. ",
				"Prepared to get rid of some seriously foul creepers for us?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Subterranean) == 1) and (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Organisms) < 50) then
			npcHandler:say("Come back when you have finished your job.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Subterranean) == 1) and (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Organisms) >= 50) then
			npcHandler:say("I'l say I'm blown away but a Klom Stonecutter is not that easily impressed. Still, your got your hands dirt for us and I appreciate that.", npc, creature)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.TimeTaskSubterranean, os.time() + time)
			player:addItem(27654, 1)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Points) + 1)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Subterranean, 2)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 2 and MsgContains(message, "yes") then
		npcHandler:say("Alright, good. Those things are strolling about and I ain't gonna have that. If it moves more than two legs, destroy it. If it moves legs and tentacles, destroy it again.", npc, creature)
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Subterranean, 1)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Organisms, 0)
		npcHandler:setTopic(playerId, 1)
	end

	if MsgContains(message, "home") then
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Home) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.TimeTaskHome) > 0 then
			npcHandler:say("I don't need your help for now. Come back later.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Home) == 2 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.TimeTaskHome) <= 0 then
			npcHandler:say({
				"We need to find a way to drive off the exiles from these caves. Countless makeshift homes are popping up at every corner. Destroy them and get the Lost out of hiding to eliminate them. ... ",
				"If you can capture a few of them, you'll receive a bonus. Just bring 'em to the border of our outpost and we will take care of the rest. ... ",
				"Are you ready for that? ",
			}, npc, creature)
			npcHandler:setTopic(playerId, 22)
		end
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Home) < 1 then
			npcHandler:say({
				"We need to find a way to drive off the exiles from these caves. Countless makeshift homes are popping up at every corner. Destroy them and get the Lost out of hiding to eliminate them. ... ",
				"If you can capture a few of them, you'll receive a bonus. Just bring 'em to the border of our outpost and we will take care of the rest. ... ",
				"Are you ready for that? ",
			}, npc, creature)
			npcHandler:setTopic(playerId, 22)
		elseif (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Home) == 1) and (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.LostExiles) < 20 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Prisoners) < 3) then
			npcHandler:say("Come back when you have finished your job.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Home) == 1) and (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.LostExiles) >= 20 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Prisoners) < 3) then
			npcHandler:say("So you did it. Well, that won't be the last of 'em but this sure helps our situation down here. Return to me later if you want to help me again!", npc, creature)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.TimeTaskHome, os.time() + time)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Home, 2)
			player:addItem(27654, 1)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Points) + 1)
			npcHandler:setTopic(playerId, 1)
		elseif (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Home) == 1) and (player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.LostExiles) >= 20 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Prisoners) >= 3) then
			npcHandler:say("So you did it. And you even made prisoners, the bonus is yours! Well, that won't be the last of 'em but this sure helps our situation down here. Return to me later if you want to help me again!", npc, creature)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.TimeTaskHome, os.time() + time)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Home, 2)
			player:addItem(27654, 2)
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Points) + 2)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 22 and MsgContains(message, "yes") then
		npcHandler:say("Very well, now try to find some of their makeshift homes and tear'em down. There's bound to be some stragglers you can 'persuade' to surrender, eliminate any resistance. Get back here when you're done.", npc, creature)
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Home, 1)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.LostExiles, 0)
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Prisoners, 0)
		npcHandler:setTopic(playerId, 1)
	end

	local plural = ""

	if MsgContains(message, "suspicious devices") or MsgContains(message, "suspicious device") then
		npcHandler:say("If you bring me any suspicious devices on creatures you slay down here, I'll make it worth your while by telling the others of your generosity. How many do you want to offer?", npc, creature)
		npcHandler:setTopic(playerId, 55)
	elseif npcHandler:getTopic(playerId) == 55 then
		count[playerId] = tonumber(message)
		if count[playerId] then
			if count[playerId] > 1 then
				plural = plural .. "s"
			end
			npcHandler:say("You want to offer " .. count[playerId] .. " suspicious device" .. plural .. ". Which leader shall have it, (Gnomus) of the {gnomes}, (Klom Stonecutter) of the {dwarves} or the {scouts} (Lardoc Bashsmite)?", npc, creature)
			npcHandler:setTopic(playerId, 56)
		else
			npcHandler:say("Don't waste my time.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "gnomes") and npcHandler:getTopic(playerId) == 56 then
		if player:getItemCount(27653) >= count[playerId] then
			npcHandler:say("Done.", npc, creature)
			if count[playerId] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned " .. count[playerId] .. " point" .. plural .. " on the gnomes mission.")
			player:removeItem(27653, count[playerId])
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Points) + count[playerId])
		else
			npcHandler:say("You don't have enough suspicious devices.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "dwarves") and npcHandler:getTopic(playerId) == 56 then
		if player:getItemCount(27653) >= count[playerId] then
			npcHandler:say("Done.", npc, creature)
			if count[playerId] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned " .. count[playerId] .. " point" .. plural .. " on the dwarves mission.")
			player:removeItem(27653, count[playerId])
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Points) + count[playerId])
		else
			npcHandler:say("You don't have enough suspicious devices.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "scouts") and npcHandler:getTopic(playerId) == 56 then
		if player:getItemCount(27653) >= count[playerId] then
			npcHandler:say("Done.", npc, creature)
			if count[playerId] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned " .. count[playerId] .. " point" .. plural .. " on the scouts mission.")
			player:removeItem(27653, count[playerId])
			player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Points, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Points) + count[playerId])
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

keywordHandler:addKeyword({ "help" }, StdModule.say, { npcHandler = npcHandler, text = "Well, the biggest problem we need to address are the ever charging {subterraneans} around here. And on top of that, there's the threat of the Lost, who quite made themselves at {home} in these parts." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Maintainin' this whole operation, the dwarven involvement 'course. Don't know about them gnomes but if I ain't gettin' those dwarves in line, there'll be chaos down here. I also oversee the {defences} and {counterattacks}." })
keywordHandler:addKeyword({ "defences" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"The attacks of the enemy forces are fierce but we hold our ground. ... ",
		"I'd love to face one of their generals in combat but as their masters they cowardly hide far behind enemy lines and I have other duties to fulfil. ... ",
		"I envy you for the chance to thrust into the heart of the enemy, locking weapons with their jaws... or whatever... and see the fear in their eyes when they recognise they were bested.",
	},
})
keywordHandler:addKeyword({ "counterattacks" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"I welcome a fine battle as any dwarf worth his beard should do. As long as it's a battle against something I can hit with my trusty axe. ...",
		"But here the true {enemy} eludes us. We fight wave after wave of their lackeys and if the gnomes are right the true enemy is up to something far more sinister. ",
	},
})
keywordHandler:addKeyword({ "enemy" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"I have no idea what kind of creeps are behind all this. Even the gnomes don't and they have handled that stuff way more often. ...",
		"But even if we knew nothing more about them, the fact alone that they employ the help of those mockeries of all things dwarfish, marks them as an enemy of the dwarves and it's our obligation to annihilate them.",
	},
})
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Klom Stonecutter's the name. " })

npcHandler:setMessage(MESSAGE_GREET, {
	"Greetings. A warning straight ahead: I don't like loiterin'. If you're not here to {help} us, you're here to waste my time. Which I consider loiterin'. Now, try and prove your {worth} to our alliance. ... ",
	"I have sealed some of the areas far too dangerous for anyone to enter. If you can prove you're capable, you'll get an opportunity to help destroy the weird machines, pumping lava into the caves leading to the most dangerous enemies.",
})
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
