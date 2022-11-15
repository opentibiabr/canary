local internalNpcName = "Guide Luke"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 132,
	lookBody = 39,
	lookLegs = 38,
	lookFeet = 114,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'Free escort to the depot for newcomers!' },
	{ text = 'Hello, is this your first visit to Thais? I can show you around a little.' },
	{ text = 'Need some help finding your way through Thais? Let me assist you.' },
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
	{mark = "shops", position = Position(32367, 32197, 7), markId = MAPMARK_BAG, description = "Shops"},
	{mark = "depot", position = Position(32321, 32212, 7), markId = MAPMARK_LOCK, description = "Depot"},
	{mark = "temple", position = Position(32369, 32241, 7), markId = MAPMARK_TEMPLE, description = "Temple"}
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

keywordHandler:addKeyword({'information'}, StdModule.say, {npcHandler = npcHandler, text = 'I can tell you all about the {town}, its {temple}, the {bank}, {shops}, {spell trainers} and the {depot}, as well as about the {world status}.'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'The temple is in the centre of Thais. Walk east from the harbour and pass by the {depot} until you reach the infamous crossroads, then turn south.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'We have two bankers, Suzy and Naji. Naji is right in the depot. For Suzi, exit the {depot} to the west and walk south-west. Don\'t forget that I can {mark} important locations on your map.'})
keywordHandler:addKeyword({'shops'}, StdModule.say, {npcHandler = npcHandler, text = 'You can buy {weapons}, {armor}, {tools}, {gems}, {magical} equipment, {furniture} and {food} here.'})
keywordHandler:addKeyword({'depot'}, StdModule.say, {npcHandler = npcHandler, text = 'The depot is a place where you can safely store your belongings. You are also protected against attacks there. I {escort} newcomers there.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a guide, overworked and underpaid. I can mark important locations on your map and give you some information about the town and the world status.'})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'Thais is the oldest settlement in Tibia. You can hear its history whisper when walking through the streets. Beware of criminals, but else it\'s a fine city.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m Luke. No jokes, please, I heard them all!'})

npcHandler:setMessage(MESSAGE_GREET, "Hello there, |PLAYERNAME| and welcome to Thais! Would you like some {information} and a {map} guide?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and enjoy your stay in Thais, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
