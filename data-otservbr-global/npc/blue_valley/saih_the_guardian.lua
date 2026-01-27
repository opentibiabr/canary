local internalNpcName = "Saih The Guardian"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 1816,
	lookHead = 115,
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
	text = "Name is Saih, I greet you, pilgrim.",
})

keywordHandler:addKeyword({ "blue valley", "Blue Valley" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The valley has been our home as it has been the home of our ancestors who were separated from the birth-place. It is a place worth fighting for. As is the legacy of the Merudri and everything we achieved.",
})

keywordHandler:addKeyword({ "merudri", "Merudri" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "We are Merudri, this valley has been our sanctuary for centuries and is the only thing left from our true ancestral home.",
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

	local message = isMonk and "Beware, especially as a monk, there are rules to obey when visiting the valley." or "Careful there. You are welcome here but treat this sacred place with respect."

	npcHandler:setMessage(MESSAGE_GREET, message)
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:setMessage(MESSAGE_FAREWELL, "Beware!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Mh.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
