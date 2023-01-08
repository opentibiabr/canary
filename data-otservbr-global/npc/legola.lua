local internalNpcName = "Legola"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 137,
	lookHead = 72,
	lookBody = 68,
	lookLegs = 68,
	lookFeet = 95,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'Teaching paladin spells! Just come to me!'}
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

-- Sniper Gloves
keywordHandler:addKeyword({'sniper gloves'}, StdModule.say, {npcHandler = npcHandler, text = 'We are always looking for sniper gloves. They are supposed to raise accuracy. If you find a pair, bring them here. Maybe I can offer you a nice trade.'}, function(player) return player:getItemCount(5875) == 0 end)

local function addGloveKeyword(text, condition, action)
	local gloveKeyword = keywordHandler:addKeyword({'sniper gloves'}, StdModule.say, {npcHandler = npcHandler, text = text[1]}, condition)
		gloveKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = text[2], reset = true}, function(player) return player:getItemCount(5875) == 0 end)
		gloveKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = text[3], reset = true}, nil, action)
		gloveKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = text[2], reset = true})
end

-- Free Account
addGloveKeyword({
		'You found sniper gloves?! Incredible! I would love to grant you the sniper gloves accessory, but I can only do that for premium warriors. However, I would pay you 2000 gold pieces for them. How about it?',
		'Maybe another time.',
		'Alright! Here is your money, thank you very much.'
	}, function(player) return not player:isPremium() end, function(player) player:removeItem(5875, 1) player:addMoney(2000) end
)

-- Premium account with addon
addGloveKeyword({
		'Did you find sniper gloves AGAIN?! Incredible! I cannot grant you other accessories, but would you like to sell them to me for 2000 gold pieces?',
		'Maybe another time.',
		'Alright! Here is your money, thank you very much.'
	}, function(player) return player:getStorageValue(Storage.OutfitQuest.Hunter.AddonGlove) == 1 end, function(player) player:removeItem(5875, 1) player:addMoney(2000) end
)

-- If you don't have the addon
addGloveKeyword({
		'You found sniper gloves?! Incredible! Listen, if you give them to me, I will grant you the right to wear the sniper gloves accessory. How about it?',
		'No problem, maybe another time.',
		'Great! I hereby grant you the right to wear the sniper gloves as an accessory. Congratulations!'
	}, function(player) return player:getStorageValue(Storage.OutfitQuest.Hunter.AddonGlove) == -1 end, function(player) player:removeItem(5875, 1) player:setStorageValue(Storage.OutfitQuest.Hunter.AddonGlove, 1) player:addOutfitAddon(129, 2) player:addOutfitAddon(137, 1) player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE) end
)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "girlish hair decoration", clientId = 11443, sell = 30 },
	{ itemName = "hunters quiver", clientId = 11469, sell = 80 },
	{ itemName = "protective charm", clientId = 11444, sell = 60 }
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

npcType:register(npcConfig)
