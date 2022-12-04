local internalNpcName = "Captain Haba"
local npcType = Game.createNpcType(internalNpcName)
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

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = "Is this a mutiny or what? Move, move!!"},
	{text = "In the rigging ya lazy fools!"},
	{text = "I wanna see you movin' ya lazy fools!!"},
	{text = "Full sails!! There's a sea serpent to catch!!"}
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

local FishForASerpent = Storage.Quest.U8_2.FishForASerpent
local TheHuntForTheSeaSerpent = Storage.Quest.U8_2.TheHuntForTheSeaSerpent
local function greetCallback(npc, creature)
	local player = Player(creature)

	if player:getStorageValue(TheHuntForTheSeaSerpent.QuestLine) == 2 then
		npcHandler:setMessage(MESSAGE_GREET, "Harrr, landlubber wha'd ya want? Askin' for a {passage}?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Harrr, landlubber wha'd ya want?")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if isInArray({"mission", "hunt", "passage"}, message:lower()) then
		if MsgContains(message, "passage") then
			if player:getStorageValue(FishForASerpent.QuestLine) < 5 then
				npcHandler:say("Hold your horses! First we need to get more {bait} fo' the sea serpent. Bring me the fish I requested and we can set sails immediately.", npc, creature)
				return true
			end
		end
		if player:getStorageValue(FishForASerpent.QuestLine) < 0 then
			npcHandler:say("Ya wanna join the hunt fo' the {sea serpent}? Be warned ya may pay with ya life! Are ya in to it?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(FishForASerpent.QuestLine) < 5 then
			npcHandler:say("You got any {baits} for me?", npc, creature)
		elseif player:getStorageValue(FishForASerpent.QuestLine) >= 5 then
			npcHandler:say("A'right, wanna put out to sea?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("A'right, we are here to resupply our stock of baits to catch the sea serpent. Your first task is to bring me 5 fish they are easy to catch. When you got them ask me for the {bait} again.", npc, creature)
			player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
			player:setStorageValue(FishForASerpent.QuestLine, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Let's go fo' a {hunt} and bring the beast down!", npc, creature) --test
			player:teleportTo(Position(31942, 31047, 6))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			if player:getStorageValue(TheHuntForTheSeaSerpent.QuestLine) < 0 then
				player:setStorageValue(TheHuntForTheSeaSerpent.QuestLine, 1)
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "bait") then
		if player:getStorageValue(FishForASerpent.QuestLine) == 1 then
			if player:removeItem(3578, 5) then
				npcHandler:say("Excellent, now bring me 5 northern pike.", npc, creature)
				player:setStorageValue(FishForASerpent.QuestLine, 2)
			end
		elseif player:getStorageValue(FishForASerpent.QuestLine) == 2 then
			if player:removeItem(3580, 5) then
				npcHandler:say("Excellent, now bring me 5 green perch.", npc, creature)
				player:setStorageValue(FishForASerpent.QuestLine, 3)
			end
		elseif player:getStorageValue(FishForASerpent.QuestLine) == 3 then
			if player:removeItem(7159, 5) then
				npcHandler:say("Excellent, now bring me 5 rainbow trout.", npc, creature)
				player:setStorageValue(FishForASerpent.QuestLine, 4)
			end
		elseif player:getStorageValue(FishForASerpent.QuestLine) == 4 then
			if player:removeItem(7158, 5) then
				npcHandler:say("Excellent, that should be enough fish to make the bait. Tell me when ya're ready fo' the {hunt}.", npc, creature)
				player:setStorageValue(FishForASerpent.QuestLine, 5)
			end
		elseif player:getStorageValue(FishForASerpent.QuestLine) >= 5 then
			npcHandler:say("The bait is ready, tell me if ya're ready to start the hunt.", npc, creature)
		end
	end
	return true
end
--Basic
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "My name is Haba, Captain Haba for ya little worm."})
keywordHandler:addKeyword({"pirate"}, StdModule.say, {npcHandler = npcHandler, text = "I ain't no pirate. Don't let yourself mislead by my pirate hat. I got it from a friend of mine."})
keywordHandler:addKeyword({"friend"}, StdModule.say, {npcHandler = npcHandler, text = "Most o' my friends are dead the others don't like me anymore......well, seems there aren't many left."})
keywordHandler:addKeyword({"yeti"}, StdModule.say, {npcHandler = npcHandler, text = "What fo' godsake shall that be??"})
keywordHandler:addAliasKeyword({"chakoya"})
keywordHandler:addKeyword({"barbarian"}, StdModule.say, {npcHandler = npcHandler, text = "Who are ya calling a barbarian?!? Watch your tongue here on board or you end up as fish fodder!"})
keywordHandler:addKeyword({"port hope"}, StdModule.say, {npcHandler = npcHandler, text = "Dis is no passenger ship it's a WARship. I'm on hunting business."})
keywordHandler:addAliasKeyword({"liberty bay"})
keywordHandler:addAliasKeyword({"edron"})
keywordHandler:addAliasKeyword({"ab'dendriel"})
keywordHandler:addAliasKeyword({"darashia"})
keywordHandler:addAliasKeyword({"ankrahmun"})
keywordHandler:addAliasKeyword({"issavi"})
keywordHandler:addAliasKeyword({"kazordoon"})
keywordHandler:addAliasKeyword({"krailos"})
keywordHandler:addAliasKeyword({"rathleton"})
keywordHandler:addAliasKeyword({"roshamuul"})
keywordHandler:addAliasKeyword({"farmine"})
keywordHandler:addKeyword({"ferumbras"}, StdModule.say, {npcHandler = npcHandler, text = "Never heard of him. He is no captain that's for sure, otherwise I'd know him. I was on the sea for the last 20 years hunting this, this monster."})
keywordHandler:addKeyword({"monster"}, StdModule.say, {npcHandler = npcHandler, text = "Yee, I've been chasing that monster for over 20 years now. I promise I'll bring it down!"})
keywordHandler:addAliasKeyword({"beast"})
keywordHandler:addAliasKeyword({"sea serpent"})
keywordHandler:addKeyword({"rum"}, StdModule.say, {npcHandler = npcHandler, text = "It lets me forget the long years, the lost years. The years I was chasing after THAT monster, the sea serpent."})
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "Ye, I command 'is ship!"})
keywordHandler:addKeyword({"ship"}, StdModule.say, {npcHandler = npcHandler, text = "Our last ship has been destroyed by the most evil creature of the ocean: the sea serpent. To continue our hunt, I've bought this ship here."})
keywordHandler:addKeyword({"bonelord"}, StdModule.say, {npcHandler = npcHandler, text = "Never seen one."})
keywordHandler:addKeyword({"banor"}, StdModule.say, {npcHandler = npcHandler, text = "I'm faithful - I'll catch that monster one day. Yes I will, as sure as my name is Captain Haba!!"})
keywordHandler:addAliasKeyword({"uman"})
keywordHandler:addAliasKeyword({"zathroth"})
keywordHandler:addKeyword({"queen"}, StdModule.say, {npcHandler = npcHandler, text = "On the high seas there is no queen. At least I didn't see her yet. Hararar!"})
keywordHandler:addKeyword({"king"}, StdModule.say, {npcHandler = npcHandler, text = "On the high seas there is no king. At least I didn't see him yet. Hararar!"})
keywordHandler:addKeyword({"body"}, StdModule.say, {npcHandler = npcHandler, text = "Arms, legs, head, whatever. I got injuries on almost every part of my body!"})
keywordHandler:addKeyword({"buy"}, StdModule.say, {npcHandler = npcHandler, text = "This is no shop boy, this is a warship!"})
keywordHandler:addAliasKeyword({"shop"})
keywordHandler:addAliasKeyword({"sell"})
keywordHandler:addKeyword({"camp"}, StdModule.say, {npcHandler = npcHandler, text = "We aren't even near that location! Wanna swim? Harharhar!"})
keywordHandler:addAliasKeyword({"grimlund"})
keywordHandler:addAliasKeyword({"nibelor"})
keywordHandler:addAliasKeyword({"tyrusng"})
keywordHandler:addAliasKeyword({"okolnir"})
keywordHandler:addKeyword({"druid"}, StdModule.say, {npcHandler = npcHandler, text = "I know Marvik in Thais. He once helped me with a furuncle I had on my ...ahh, doesn't matter. He's a nice gran'pa, though!"})
keywordHandler:addKeyword({"enemies"}, StdModule.say, {npcHandler = npcHandler, text = "My worst enemy is a huge sea serpent. I dunno when I started to follow it's trail. I'll kill it and if it's the last thing I'll do, I'll kill it!"})
keywordHandler:addAliasKeyword({"victory"})
keywordHandler:addKeyword({"leader"}, StdModule.say, {npcHandler = npcHandler, text = "This is a ship and the captain is some kind o' leader, isn't he? <mumbles>..stupid..landlubber."})
keywordHandler:addKeyword({"raiders"}, StdModule.say, {npcHandler = npcHandler, text = "What fo' godsake shall that be??"})
keywordHandler:addKeyword({"shaman"}, StdModule.say, {npcHandler = npcHandler, text = "Seems that they are some sort o' druids fo' the Norseman."})
keywordHandler:addKeyword({"story"}, StdModule.say, {npcHandler = npcHandler, text = "I'm full of stories mate! Name a body part and I tell you the story what happened to it!"})

npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
