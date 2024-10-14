local internalNpcName = "One-Eyed Joe"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 155,
	lookHead = 94,
	lookBody = 114,
	lookLegs = 105,
	lookFeet = 97,
	lookAddons = 1,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Did you hear that, too?" },
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

local function greetCallback(npc, creature)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local playerId = player:getId()
	local currentTime = os.time()

	if player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) == 3 and player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Questline) == 3 then
		player:addAchievement("Wail of the Banshee")
		player:addItem(16119, 1)
		player:addItem(16120, 1)
		player:addItem(16121, 1)

		local chanceToPirate = math.random(1, 4)
		local pirateItems = { [1] = 5926, [2] = 6098, [3] = 6097, [4] = 6126 }
		player:addItem(pirateItems[chanceToPirate], 1)

		player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe, 4)
		player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Questline, 4)
		player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Time, currentTime + 20 * 60 * 60)
		npcHandler:setMessage(MESSAGE_GREET, "Well done! But know this: The cursed crystal seems to regenerate over time. It could be necessary to come back and repeat whatever you have done down there.")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hello there. I'm sorry, I hardly noticed you. I'm a bit nervous. The spooky {sounds} down there, you know")
	end

	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local playerId = player:getId()
	local currentTime = os.time()
	local questTime = player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Time)

	if questTime > 0 and currentTime >= questTime then
		player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe, -1)
		player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Questline, -1)
		player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.MedusaOil, -1)
		player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.SheetOfPaper, -1)
		player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.SmallCrystalBell, -1)
	end

	if MsgContains(message, "mission") and player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) < 0 and npcHandler:getTopic(playerId) < 1 then
		npcHandler:say({
			"As for myself I haven't been down there. But I heard some disturbing rumours. In these caves are wonderful crystal formations. Some more poetically inclined fellows call them the crystal gardens. ...",
			"At first glance it seems to be a beautiful - and precious - surrounding. But in truth, deep down in these caverns exists an old evil. Want to hear more?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") and player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) > 0 and player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) < 3 then
		npcHandler:say("Hmm. No, I don't think so. I still feel this strange prickling in my toes.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "no") and player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) > 0 and player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) < 3 then
		npcHandler:say("Too bad.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "protect ears") then
		npcHandler:say("Protect your ears? Hmm ... Wasn't there some fabulous seafarer who used wax or something to plug his ears? There was a story about horrible bird-women or something ...? No, sounds like hogwash, doesn't it.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say({
			"The evil I mentioned is a strange crystal, imbued with some kind of unholy energy. It is very hard to destroy, no weapon is able to shatter the thing. Maybe a jarring, very loud sound could destroy it. ...",
			"I heard of creatures, that are able to utter ear-splitting sounds. Don't remember the name, though. Would you go down there and try to destroy the crystal?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 2 then
		player:setStorageValue(Storage.Quest.U8_1.TibiaTales.DefaultStart, 1)
		if player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Questline) < 0 then
			player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Questline, 0)
		end
		player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe, 0)
		npcHandler:say("Great! Good luck and be careful down there!", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "crystals") then
		npcHandler:say({
			"In my humble opinion a pirate should win a fortune by boarding ships not by crawling through caves and tunnels. But who am I to bring into question the captain's decision. All I know is that they sell the crystals at a high price. ...",
			"A certain amount of the crystals is ground to crystal dust with a special kind of mill. Don't ask me why. Some kind of magical component perhaps that they sell to mages and sorcerers.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "cursed") and player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) < 0 and npcHandler:getTopic(playerId) < 1 then
		npcHandler:say({
			"As for myself I haven't been down there. But I heard some disturbing rumours. In these caves are wonderful crystal formations. Some more poetically inclined fellows call them the crystal gardens. ...",
			"At first glance it seems to be a beautiful - and precious - surrounding. But in truth, deep down in these caverns exists an old evil. Want to hear more?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "sounds") then
		npcHandler:say({
			"These caves are incredibly beautiful, {crystals} in vibrant colours grow there like exotic flowers. There are more than a few captains who send down their men in order to quarry the precious crystals. ...",
			"But there are few volunteers. Often the crystal gatherers disappear and are never seen again. Other poor fellows then meet their former shipmates in the form of ghosts or skeletons. It's a {cursed} area, something evil is down there!",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "job") then
		npcHandler:say("I'm a pirate. Normally I'm sailing the seas, boarding other ships and gathering treasures. But at the moment my captain graciously assigned me to watch this {cursed} entrance.", npc, creature)
	elseif MsgContains(message, "name") then
		npcHandler:say("I'm One-Eyed Joe. From Josephina, got that? And I regard this eye patch as a personal feature of beauty!", npc, creature)
	elseif MsgContains(message, "bye") then
		npcHandler:say("Good bye adventurer. It was nice to talk with you.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) >= 0 and player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) < 3 then
		npcHandler:say("Ah, the brave adventurer who sought to destroy the evil crystal down there. Have you been successful?", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
