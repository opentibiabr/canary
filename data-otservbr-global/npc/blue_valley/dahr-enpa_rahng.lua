local internalNpcName = "Dahr-Enpa Rahng"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1820,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
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
	text = "The valley is rich in vegetation. Bursting of fragrance and colour in the spring and summer, it truly is a sight to behold. You need an eye and a nose for things like this, of course.",
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()
	local isMonk = player:getVocation():getBaseId() == VOCATION.BASE_ID.MONK

	if not isMonk then
		return false
	end

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local player = Player(creature)
	local isMonk = player and player:getVocation():getBaseId() == VOCATION.BASE_ID.MONK

	if not isMonk then
		return true
	end

	if MsgContains(message, "blue valley") then
		npcHandler:say("This valley has been my home and will be for the foreseeable time.", npc, creature)
	elseif MsgContains(message, "pilgrimage") then
		npcHandler:say("Every monk must undertake the Three-Fold Path. So did I and so is the way of the Merudri of the valley.", npc, creature)
	elseif MsgContains(message, "merudri") then
		npcHandler:say("I am Merudri, yet every monk can become Dhar-Enpa, once inducted to our ways and given the proper training.", npc, creature)
	end
	return true
end

local function greetCallback(npc, creature)
	local player = Player(creature)
	local isMonk = player:getVocation():getBaseId() == VOCATION.BASE_ID.MONK

	local message = isMonk and "Welcome, monk. This is not your place to be." or "<The metaphysical essence of the Dhar-Enpa does not react.>"

	npcHandler:setMessage(MESSAGE_GREET, message)
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:setMessage(MESSAGE_FAREWELL, "Harmony, enlightenment, power.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
