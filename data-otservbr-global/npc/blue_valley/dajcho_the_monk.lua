local internalNpcName = "Dajcho The Monk"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1816,
	lookHead = 78,
	lookBody = 78,
	lookLegs = 78,
	lookFeet = 78,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 0,
	{
		text = "",
	},
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

keywordHandler:addKeyword({ "blue valley", "Blue Valley" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Our valley has been the center of our lives for generations. We are born here, learn the Merudri ways of our ancestors and no matter where our paths may take us, will return to this place eventually.",
})

keywordHandler:addKeyword({ "pilgrimage", "Pilgrimage" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"I am currently on the path, my pilgrimage has led to severe difficulties, however and I have returned, prematurely, to the valley. ...",
		"My journey along the path is not yet complete. I am here to gather strength and focus to continue. My {experiences} have been straining and dire. ...",
		"Since you are a pilgrim as well, talk to our {Enpa-Deia}, she will help you on your path.",
	},
})

keywordHandler:addKeyword({ "experiences", "Experiences" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The experiences I made on my pilgrimage are mine and mine alone. It is of my own free will to share them with fellow Merudri only as of now.",
})

keywordHandler:addKeyword({ "Enpa-Deia", "enpa-deia" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Pema will be the successor to our Enpa Rudra. She will continue to fight for our legacy with just as much passion and wisdom when her time comes.",
})

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
	local player = Player(creature)
	local playerId = player:getId()
	local isMonk = player:getVocation():getBaseId() == VOCATION.BASE_ID.MONK

	local title = isMonk and "fellow monk" or "traveller"
	local message = string.format("Welcome, %s. Into this valley's blue, warm bosom you are invited. Stay with us, listen and learn.", title)

	npcHandler:setMessage(MESSAGE_GREET, message)
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:setMessage(MESSAGE_FAREWELL, "Safe passage, friend!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Harmony, friend.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
