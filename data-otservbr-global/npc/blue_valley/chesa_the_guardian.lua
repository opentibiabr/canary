local internalNpcName = "Chesa The Guardian"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 1817,
	lookHead = 21,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 95,
	lookAddons = 1,
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

keywordHandler:addKeyword({ "name", "Name" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "My name is Chesa, I greet you.",
})

keywordHandler:addKeyword({ "blue valley", "Blue Valley" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The valley of the Merudri has been our home for a long time. There have been guardians around here since I remember. I always wanted to become one of them and here I am.",
})

keywordHandler:addKeyword({ "merudri", "Merudri" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Indeed, we are Merudri. You are now in the centre of our sacred sanctuary and ancestral home, the Blue Valley.",
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

npcHandler:setMessage(MESSAGE_FAREWELL, "Safe travels!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Alright then.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
