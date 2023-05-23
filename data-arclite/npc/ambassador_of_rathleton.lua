local internalNpcName = "Ambassador Of Rathleton"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 472,
	lookHead = 19,
	lookBody = 53,
	lookLegs = 61,
	lookFeet = 3,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = "What a beautiful palace. The Kilmareshians are highly skilful architects."},
	{text = "The new treaty of amity and commerce with Kilmaresh is of utmost importance."},
	{text = "The pending freight from the saffron coasts is overdue."}
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

keywordHandler:addKeyword(
	{"present"}, StdModule.say, { npcHandler = npcHandler,
	text = "This is a very beautiful ring. Thank you for this generous present!"},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Third.Recovering) == 2 and player:getItemById(31263, true) end,
	function (player) 
		player:removeItem(31263, 1)
		player:setStorageValue(Storage.Kilmaresh.Fourth.Moe, 1)
		player:setStorageValue(Storage.Kilmaresh.Third.Recovering, 3)
	end
)

keywordHandler:addKeyword(
	{"present"}, StdModule.say, { npcHandler = npcHandler,
	text = "Didn't you bring my gift?"},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Third.Recovering) == 2 end
)
npcHandler:setMessage(MESSAGE_GREET, "Greetings, friend.")
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
