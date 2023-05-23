local internalNpcName = "Captain Haba"
local npcType = Game.createNpcType("Captain Haba (Open Sea)")
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 98,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
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

local TheHuntForTheSeaSerpent = Storage.Quest.U8_2.TheHuntForTheSeaSerpent
local function greetCallback(npc, creature)
	local player = Player(creature)

	if player:getStorageValue(TheHuntForTheSeaSerpent.QuestLine) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Wha'd ya want? Ask me 'bout the {instructions} if you don't know what to do! If you wanna head back to {Svargrond}, let me know.")
	elseif player:getStorageValue(TheHuntForTheSeaSerpent.QuestLine) == 2 then
		npcHandler:setMessage(MESSAGE_GREET, "You found the spot |PLAYERNAME|!! Grab yourself a helmet of the deep and go explore the {caves} down there.")
	end
	return true
end
local randomMessages = {
	straight = {
		"STRAIGHT AHED! WE GOT FOLLOWING WINDS, LETS'S GO!!",
		"STRAIGHT AHED!! WHY DOES THIS TAKE SO LONG?!? HURRY UP!",
		"LOOKOUT REPORTS SEA SERPENT ON SIGHT!! STRAIGHT AHEAD!!",
		"GO GO GO, SEA SERPENT STRAIGHT AHEAD!!",
		"SET FULL SAILS! SEA SERPENT RIGHT IN FRONT OF US!!"},
	starboard = {
		"SET FULL SAILS! SEA SERPENT ON THE STARBOARD SIDE!!",
		"LOOKOUT REPORTS SEA SERPENT ON SIGHT!! SEA SERPENT ON THE STARBOARD SIEDE!!",
		"COME ON YOU LAZY FOOLS!! SEA SERPENT ON THE STARBOARD SIDE!!",
		"GO GO GO, SEA SERPENT ON THE STARBOARD SIDE!!",
		"CHANGE COURSE TO STARBOARD!! WHY DOES THIS TAKE SO LONG?!? HURRY UP!"},
	larboard = {
		"SET FULL SAILS! SEA SERPENT ON THE LARBOARD SIDE!!",
		"SEA SERPENT AHEAD!! LARBOARD SIDE!!",
		"SEA SERPENT ON SIGHT!! TO THE LARBOARD SIDE, FAST!",
		"LARBOARD!! THY DOES THIS TAKE SO LONG?!? LET'S GET IT ON!",
		"LET'S GO YOU LAZY FOOLS. WE GOT A SEA SERPENT TO CATCH! TO LARBOARD SIDE, GO, GO, GO!"}
}
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local randomMessagesResult
	if MsgContains(message, "instructions") then
		npcHandler:say({
			"A'right, first of all you need a bait which isn't for free, though. I sell them for 50 gold each. Use the bait on the crane over there when you see something in the telescope. ...",
			"Then go up to the lookout and check the telescope for a sight of the sea serpent. ...",
			"If you see it in front of ya, get down at once. And what d'ya gonna say to me?"}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif npcHandler:getTopic(playerId) == 1 and message:lower() ~= "straight" then
		npcHandler:say("Harharhar, landlubber, no no!! The correct command would be STRAIGHT. Remember that! Next, what you gonna say when you see something to left?", npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif npcHandler:getTopic(playerId) == 1 and message:lower() ~= "larboard" then
		npcHandler:say("Harharhar, landlubber, ya got it all wrong!! The correct command would be LARBOARD side. Don't forget that, 'kay? Last one, what you gonna say to me when ya see somethin' to the right?", npc, creature)
		npcHandler:setTopic(playerId, 3)
	elseif npcHandler:getTopic(playerId) == 1 and message:lower() ~= "starboard" then
		npcHandler:say({
			"Ya gotta learn a lot! The correct command would be STARBOARD side. ...",
			"After you told me about the direction, put a bait on the crane again and go up to the lookout! That would be all sailor, let's go hunt down the sea serpent!!"}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message:lower(), "straight") then
		randomMessagesResult = randomMessages.straight[math.random(#randomMessages.straight)]
		npcHandler:say(randomMessagesResult, npc, creature)
		if player:getStorageValue(TheHuntForTheSeaSerpent.Direction) == 1 then
			player:setStorageValue(TheHuntForTheSeaSerpent.SuccessSwitch, 1)
			player:setStorageValue(TheHuntForTheSeaSerpent.Direction, 0)
		else
			player:setStorageValue(TheHuntForTheSeaSerpent.SuccessSwitch, 0)
			player:setStorageValue(TheHuntForTheSeaSerpent.Direction, 0)
		end
	elseif MsgContains(message:lower(), "starboard") then
		randomMessagesResult = randomMessages.starboard[math.random(#randomMessages.starboard)]
		npcHandler:say(randomMessagesResult, npc, creature)
		if player:getStorageValue(TheHuntForTheSeaSerpent.Direction) == 2 then
			player:setStorageValue(TheHuntForTheSeaSerpent.SuccessSwitch, 1)
			player:setStorageValue(TheHuntForTheSeaSerpent.Direction, 0)
		else
			player:setStorageValue(TheHuntForTheSeaSerpent.SuccessSwitch, 0)
			player:setStorageValue(TheHuntForTheSeaSerpent.Direction, 0)
		end
	elseif MsgContains(message:lower(), "larboard") then
		randomMessagesResult = randomMessages.larboard[math.random(#randomMessages.larboard)]
		npcHandler:say(randomMessagesResult, npc, creature)
		if player:getStorageValue(TheHuntForTheSeaSerpent.Direction) == 3 then
			player:setStorageValue(TheHuntForTheSeaSerpent.SuccessSwitch, 1)
			player:setStorageValue(TheHuntForTheSeaSerpent.Direction, 0)
		else
			player:setStorageValue(TheHuntForTheSeaSerpent.SuccessSwitch, 0)
			player:setStorageValue(TheHuntForTheSeaSerpent.Direction, 0)
		end
	elseif MsgContains(message:lower(), "speed") then
		npcHandler:say("IS THAT ALL?!? SPEED UP, TIGHTEN THE MAINSAIL!!!", npc, creature)
		if player:getStorageValue(TheHuntForTheSeaSerpent.Direction) == 4 then
			player:setStorageValue(TheHuntForTheSeaSerpent.SuccessSwitch, 1)
			player:setStorageValue(TheHuntForTheSeaSerpent.Direction, 0)
		else
			player:setStorageValue(TheHuntForTheSeaSerpent.SuccessSwitch, 0)
			player:setStorageValue(TheHuntForTheSeaSerpent.Direction, 0)
		end
	elseif isInArray({"god", "svargrond", "back", "hunt", "passage", "trip"}, message:lower()) then
		if isInArray({"god", "svargrond", "back", "hunt"}, message:lower()) then
			npcHandler:say("Already got enough, huh? I kind o' expected that, landlubber! Let's head for Svargrond! Ready?", npc, creature)
		else
			npcHandler:say("Y' already wanna give up?? I should've known. I bring ya back to Svargrond, 'kay?", npc, creature)
		end
		npcHandler:setTopic(playerId, 4)
	elseif message:lower() == "yes" and npcHandler:getTopic(playerId) == 4 then
		npcHandler:setMessage(MESSAGE_WALKAWAY, "See ya, landlubber!")
		player:teleportTo(Position(32342, 31123, 6))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end
--Basic
keywordHandler:addKeyword({"caves"}, StdModule.say, {npcHandler = npcHandler, text = "I'd go by myself and tear that beast's heart out if I were younger. I hope ya can do that for me. Now go and good luck to ya!"})
keywordHandler:addKeyword({"wares"}, StdModule.say, {npcHandler = npcHandler, text = "Ya're a coward, aren't ya? Prove that I'm wrong and get your lazy bones up to the lookout!!"})
keywordHandler:addAliasKeyword({"go"})
keywordHandler:addKeyword({"bait"}, StdModule.say, {npcHandler = npcHandler, text = "Just ask me for a trade if you need a bait."})
keywordHandler:addKeyword({"test"}, StdModule.say, {npcHandler = npcHandler, text = "I can give ya a challenge to test if ya have the guts to be a real sailor. Go up to the lookout and remain there for 24 hours during a storm! Harharhar!"})

npcHandler:setMessage(MESSAGE_SENDTRADE, "Here ya go! Use it on the crane when you see the monster. Then refill it every time you use the telescope.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bait", clientId = 939, buy = 50 }
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

npcType:register(npcConfig)
