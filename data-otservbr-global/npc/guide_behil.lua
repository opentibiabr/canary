local internalNpcName = "Guide Behil"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 146,
	lookHead = 114,
	lookBody = 87,
	lookLegs = 85,
	lookFeet = 126,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'Hello, is this your first visit to Darashia? I can show you around a little.' },
	{ text = 'I\'m well informed about the status of the world despite all the recent changes.'},
	{ text = 'Need some help finding your way through Darashia? Let me assist you.' },
	{ text = 'Free escort to the depot for newcomers!' }
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
	{mark = "shops", position = Position(33223, 32422, 7), markId = MAPMARK_BAG, description = "Shops"},
	{mark = "depottp", position = Position(33214, 32453, 7), markId = MAPMARK_LOCK, description = "Depot and Temple"}
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

keywordHandler:addKeyword({'information'}, StdModule.say, {npcHandler = npcHandler, text = 'Currently, I can tell you all about the town, its temple, the bank, shops, spell trainers and the depot, as well as about the world status.'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'The temple is a few floors over the depot. Just walk up the numerous stairs there.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'Muzir takes care of our bank business. His office is in the north-western part of the caliph\'s palace.'})
keywordHandler:addKeyword({'shops'}, StdModule.say, {npcHandler = npcHandler, text = 'You can buy weapons, armor, tools, gems, magical equipment, furniture, spells and food here.'})
keywordHandler:addKeyword({'depot'}, StdModule.say, {npcHandler = npcHandler, text = 'The depot is a place where you can safely store your belongings. You are also protected against attacks there. I escort newcomers there.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'ll show you around Darashia if you like. I can mark important locations on your map and give you some information about the town and the world status.'})
keywordHandler:addKeyword({'town'}, StdModule.say, {npcHandler = npcHandler, text = 'Darashia is an oriental settlement ruled by Caliph Kazzan Ibn Gadral. We have a lot of shops, carpet travel and a rotworm plague, that sums it about up.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Behil. Glad to be your guide.'})

npcHandler:setMessage(MESSAGE_GREET, "Daraman's blessings, Black Sabbatth, welcome to Darashia! Would you like some information and a map guide?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Daraman's blessings, enjoy your stay in Darashia, |PLAYERNAME|")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
