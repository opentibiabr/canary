local internalNpcName = "Kendra"
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
	lookHead = 77,
	lookBody = 0,
	lookLegs = 76,
	lookFeet = 132,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
	profession = "sailor",
}
npcConfig.speechBubble = SPEECHBUBBLE_SAILOR

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Passages to Thais" },
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

-- Travel
local function addTravelKeyword(keyword, cost, destination, action, condition)
	if condition then
		keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry but I don't sail there." }, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "Do you seek a passage to " .. keyword:titleCase() .. " for |TRAVELCOST|?", cost = cost, discount = "postman" })
	travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = true, cost = cost, discount = "postman", destination = destination }, nil, action)
	travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "We would like to serve you some time.", reset = true })
end

addTravelKeyword("thais", 180, Position(32259, 32262, 7))

-- Kick
--keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(32320, 32219, 6), Position(32321, 32210, 6)}})

-- Basic
keywordHandler:addKeyword({ "passenger" }, StdModule.say, { npcHandler = npcHandler, text = "We would like to welcome you on board." })
keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Thais}" })
keywordHandler:addKeyword({ "sail" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Thais}" })
keywordHandler:addKeyword({ "go" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Thais}" })
keywordHandler:addKeyword({ "Thais" }, StdModule.say, { npcHandler = npcHandler, text = "This is Thais. Where do you want to go?" })

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Recommend us if you were satisfied with our service.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "first dragon" }, StdModule.say, { npcHandler = npcHandler, text = "So many claimed to have found and slain him but they had nothing to prove it." })
keywordHandler:addKeyword({ "ab'dendriel" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "liberty bay" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "ankrahmun" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "roshamuul" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "svargrond" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "vigintia" }, StdModule.say, { npcHandler = npcHandler, text = "This lovely island is close to Nostalgia. There are a fair, beautiful beaches, some festive diversion and of course enough to eat and drink." })
keywordHandler:addKeyword({ "darashia" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "krailos" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "oramond" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "yalahar" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "travora" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, but I've never heard of this place." })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "darama" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "venore" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "edron" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I don't sail there." })
keywordHandler:addKeyword({ "ferry" }, StdModule.say, { npcHandler = npcHandler, text = "I can sail you to the islands Vigintia and Nostalgia." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Kendra." })
keywordHandler:addKeyword({ "ship" }, StdModule.say, { npcHandler = npcHandler, text = "I'd rather call it a boat or a ferry, to be honest." })
keywordHandler:addKeyword({ "boat" }, StdModule.say, { npcHandler = npcHandler, text = "It is a ferry. I can sail you to the islands Vigintia and Nostalgia." })
keywordHandler:addKeyword({ "kick" }, StdModule.say, { npcHandler = npcHandler, text = "Off with you!" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I run a ferry service between Thais and the islands Vigintia and Nostalgia." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
