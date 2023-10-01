local internalNpcName = "Guide Rahlkora"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 150,
	lookHead = 79,
	lookBody = 97,
	lookLegs = 78,
	lookFeet = 96,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'Need some help finding your way through Ankrahmun? Let me assist you.' },
	{ text = 'Free escort to the depot for newcomers!' },
	{ text = 'Need to know something about the status of this world? Let me answer your questions.' },
	{ text = 'Hello, is this your first visit to Ankrahmun? I can show you around a little.' },
	{ text = 'Talk to me if you need directions.' }
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

local configMarks = {
	{mark = "shops", position = Position(33130, 32815, 7), markId = MAPMARK_BAG, description = "Shops"},
	{mark = "depot", position = Position(33126, 32841, 7), markId = MAPMARK_LOCK, description = "Depot"},
	{mark = "temple", position = Position(33195, 32852, 7), markId = MAPMARK_TEMPLE, description = "Temple"}
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if isInArray({"map", "marks"}, message) then
		npcHandler:say("Would you like me to mark locations like - for example - the depot, bank and shops on your map?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Here you go.", npc, creature)
		local mark
		for i = 1, #configMarks do
			mark = configMarks[i]
			player:addMapMark(mark.position, mark.markId, mark.description)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) >= 1 then
		npcHandler:say("Well, nothing wrong about exploring the town on your own. Let me know if you need something!", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

keywordHandler:addKeyword({'information'}, StdModule.say, {npcHandler = npcHandler, text = 'Currently, I can tell you all about the town, its temple, the bank, shops, spell trainers and the depot.'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'The temple is in the south-eastern part of town. If you exit the depot to the south and walk east - slightly south-east - you can\'t miss it.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'Tesha is in charge of both the bank and the gem store. You can find her on the market pyramid. Just exit the depot on the north side and walk up the next pyramid.'})
keywordHandler:addKeyword({'shops'}, StdModule.say, {npcHandler = npcHandler, text = 'You can buy weapons, armor, tools, gems, magical equipment, furniture, spells and food here.'})
keywordHandler:addKeyword({'depot'}, StdModule.say, {npcHandler = npcHandler, text = 'The depot is a place where you can safely store your belongings. You are also protected against attacks there. I escort newcomers there.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I will help you to find your way around Ankrahmun. I can mark important locations on your map and give you some information about the town.'})
keywordHandler:addKeyword({'town'}, StdModule.say, {npcHandler = npcHandler, text = 'Ankrahmun consists almost completely of pyramids. You can walk up and down those pyramids just like you\'d climb up stairs. Most shops are on the upper floors.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Rahlkora. I\'m a guide.'})

npcHandler:setMessage(MESSAGE_GREET, "Welcome to Ankrahmun, |PLAYERNAME| This city can be a bit confusing at first. Would you like some information and a map guide?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and enjoy your stay in Ankrahmun, |PLAYERNAME|")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
