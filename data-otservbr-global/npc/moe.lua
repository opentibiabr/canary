local internalNpcName = "Moe"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 118,
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
	{text = "The menu of the day sounds delicious!"}, 
	{text = "The last visit to the theatre was quite rewarding."}, 
	{text = "Such a beautiful and wealthy city - with so many opportunities ..."}
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
	{"help"}, StdModule.say, { npcHandler = npcHandler,
	text = "I guess I could do this, yes. But I have to impose a condition. If you bring me ten sphinx {feathers} I will steal this ring for you."},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Fourth.Moe) == 1 end,
	function (player) player:setStorageValue(Storage.Kilmaresh.Fourth.Moe, 2) end
)

keywordHandler:addKeyword(
	{"feathers"}, StdModule.say, { npcHandler = npcHandler,
	text = "Thank you! They look so pretty, I'm very pleased. Agreed, now I will steal the ring from the Ambassador of Rathleton. Just be patient, I have to wait for a good moment."},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Fourth.Moe) == 2 and player:getItemById(31437, 10) end,
	function (player) 
		player:removeItem(31437, 10)
		player:setStorageValue(Storage.Kilmaresh.Fourth.Moe, 3)
		player:setStorageValue(Storage.Kilmaresh.Fourth.MoeTimer, os.time() + 60 * 60 ) -- one hour
	end
)

keywordHandler:addKeyword(
	{"feathers"}, StdModule.say, { npcHandler = npcHandler,
	text = "If you bring me ten sphinx {feathers} I will steal this ring for you."},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Fourth.Moe) == 2 and not player:getItemById(31437, 10) end
)

keywordHandler:addKeyword(
	{"ring"}, StdModule.say, { npcHandler = npcHandler,
	text = "You're arriving at the right time. I have the ring you asked for. It was not too difficult. I just had to wait until the Ambassador left his residence and then I climbed in through the window. Here it is."},
	function (player) 
		return player:getStorageValue(Storage.Kilmaresh.Fourth.Moe) == 3 and 
			player:getStorageValue(Storage.Kilmaresh.Fourth.MoeTimer) - os.time() <= 0
	end,
	function (player)
		player:addItem(31306, 1)
		player:setStorageValue(Storage.Kilmaresh.Fourth.Moe, 4)
	end
)

keywordHandler:addKeyword(
	{"ring"}, StdModule.say, { npcHandler = npcHandler,
	text = "I will steal it, promised. I\'m just waiting for a good moment."},
	function (player) 
		return player:getStorageValue(Storage.Kilmaresh.Fourth.Moe) == 3 and 
			player:getStorageValue(Storage.Kilmaresh.Fourth.MoeTimer) - os.time() > 0
	end
)
keywordHandler:addKeyword(
	{"lyre"}, StdModule.say, { npcHandler = npcHandler,
	text = "I'm upset to accuse myself, the lyre is hidden in a tomb west of Kilmaresh."},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Thirteen.Lyre) == 1 end,
	function (player) player:setStorageValue(Storage.Kilmaresh.Thirteen.Lyre, 2) end
)

npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveller. It seems, you're a {guest} here, just like me.")
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
