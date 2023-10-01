local internalNpcName = "Zirella"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 157,
	lookHead = 57,
	lookBody = 111,
	lookLegs = 67,
	lookFeet = 95,
	lookAddons = 2
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'I wish someone could spare a minute and help me...' },
	{ text = 'This is too hard for an old woman like me.' },
	{ text = 'Hello, young adventurer, you look strong enough to help me!' }
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


local storeTalkCid = {}
local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh, heaven must have sent you! Could you please help me with a {quest}?")
		storeTalkCid[playerId] = 0
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back, darling... so about that firewood, could you please {help} me?")
		storeTalkCid[playerId] = 2
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 2 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back, darling... so about the {dead trees}, let me explain that a little more, {yes}?")
		storeTalkCid[playerId] = 3
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 3 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back, darling... so about the {branches}, let me explain that a little more, {yes}?")
		storeTalkCid[playerId] = 4
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back, darling... so about the {pushing}, let me explain that a little more, {yes}?")
		storeTalkCid[playerId] = 5
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 5 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back, darling... so about the {cart}, let me explain that a little more, {yes}?")
		storeTalkCid[playerId] = 6
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 6 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh, sweetheart, is there a problem with the quest? Should I {explain} it again?")
		storeTalkCid[playerId] = 7
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 7 then
		npcHandler:setMessage(MESSAGE_GREET, "Right, thank you sweetheart! This will be enough to heat my oven. Oh, and you are probably waiting for your reward, {yes}?")
		storeTalkCid[playerId] = 8
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 8 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh, welcome back, dear Isleth Eagonst! Are you here for a little chat? Just use the highlighted {keywords} again to choose a {topic}.")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if isInArray({"yes", "quest", "ok"}, message) then
		if storeTalkCid[playerId] == 0 then
			npcHandler:say("By the way, 'quest' is a keyword that many NPCs react to, especially those which have tasks for you. So darling, about that {quest}... are you listening?", npc, creature)
			storeTalkCid[playerId] = 1
		elseif storeTalkCid[playerId] == 1 then
			npcHandler:say("Thank you so much for your kindness. I'm an old woman and I desperately need firewood for my oven. Could you please help me?", npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 1)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 1)
			storeTalkCid[playerId] = 2
		elseif storeTalkCid[playerId] == 2 then
			npcHandler:say("You're such a treasure. In the forest south of here, there are {dead trees} without any leaves. The first thing you have to do is search for one, {okay}?", npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 2)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 2)
			storeTalkCid[playerId] = 3
		elseif storeTalkCid[playerId] == 3 then
			npcHandler:say("Splendid, once you've found one, 'Use' it to break a branch from it. Did you understand that so far?", npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 3)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 3)
			storeTalkCid[playerId] = 4
		elseif storeTalkCid[playerId] == 4 then
			npcHandler:say("Good... so after you broke a branch, please push it here and select 'use with'. That will turn your mouse cursor into crosshairs. Then left-click on my cart. {Alright}?", npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 4)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 4)
			storeTalkCid[playerId] = 5
		elseif storeTalkCid[playerId] == 5 then
			npcHandler:say("To push the branch, drag and drop it on the grass by holding the left mousebutton and moving the cursor to where you want to throw the branch. Just push it near my cart before you 'Use' it, {alright}?", npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 5)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 5)
			storeTalkCid[playerId] = 6
		elseif storeTalkCid[playerId] == 6 then
			npcHandler:say({
				"Thank you darling! My cart is right beside me. It's a little complicated: I need some firewood, but it's very difficult for my slightly advanced age. ...",
				"Please go into the the forest southeast of here. You will find fine old rotten brown trees. Please RIGHT-CLICK in the lower right corner of that tree and choose 'USE'. That way, a branch should appear on the map. ...",
				"Don't put it in your inventory like before, but instead DRAG it over the map by LEFT-CLICKING the loose branch, HOLDING the LEFT MOUSE BUTTON and moving it over the map. ...",
				"When you are close to my cart, USE the branch WITH the cart: RIGHT-CLICK the branch on the floor and select 'USE WITH', Then LEFT-CLICK on the cart. Don't worry, you will see what I mean on the way. Thanks and {bye} for now!"
			}, npc, creature)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 6)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 6)
			Position(32064, 32273, 7):sendMagicEffect(CONST_ME_TUTORIALARROW)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		elseif storeTalkCid[playerId] == 7 then
			npcHandler:say({
				"Well, you know that old women like me like to talk a lot. If you see three dots at the end of a sentence, I have still something to say and you should not interrupt, like now ...",
				"Patience is a virtue, young adventurer! So, the quest was to go into the forest south of here and to find a dead tree. Wait, let me continue! ...",
				"'Use' a tree to break a dry branch from it. Afterwards, drag and drop the branch back to my cart and select 'Use with', then left-click on my cart. Thanks again for offering your help!"
			}, npc, creature)
			storeTalkCid[playerId] = nil
		elseif storeTalkCid[playerId] == 8 then
			npcHandler:say("Oh, you deserve it. You really have earned some experience! Also, you may enter my little house now and take what's in that chest beside my bed. Good {bye} for now!", npc, creature)
			player:addExperience(50, true)
			Position(32058, 32266, 6):sendMagicEffect(CONST_ME_TUTORIALARROW)
			player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 8)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 8)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		end
	elseif MsgContains(message, "no") then
		if storeTalkCid[playerId] == 7 then
			npcHandler:say("Well then, I hope you find nice and dry branches for me! Good {bye}!", npc, creature)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		end
	end
	return true
end

local function onReleaseFocus(npc, creature)
	local playerId = creature:getId()
	storeTalkCid[playerId] = nil
end

npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye |PLAYERNAME|, may Uman bless you!.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye traveller, take care.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
