local internalNpcName = "Hunt Refiller"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 3

npcConfig.outfit = {
	lookType = 136,
	lookHead = 97,
	lookBody = 34,
	lookLegs = 3,
	lookFeet = 116,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if MsgContains(message, "Trade") then
        npcHandler:say({
            "It is a pleasure."
        }, npc, creature, 3000)
    end

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end
	return true
end

local function greetCallback(npc, creature)
    local player = Player(creature)
    if player and not HUNT_REFILLER[player:getId()] or (HUNT_REFILLER[player:getId()] and HUNT_REFILLER[player:getId()].npc ~= npc:getId()) then
        npcHandler:removeInteraction(npc, creature)
        return false
    end
    
    npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, let's {trade} and refill?")
    return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, let's {trade} and refill?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, |PLAYERNAME|, may the winds guide your way.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Come back soon!")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Take all the time you need to decide what you want!")

local function onTradeRequest(npc, creature)
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {


	-- distance
	{ itemName = "arrow", clientId = 3447, buy = 2 },
	{ itemName = "bolt", clientId = 3446, buy = 4 },
	{ itemName = "crystalline arrow", clientId = 15793, buy = 450 },
	{ itemName = "drill bolt", clientId = 16142, buy = 12 },
	{ itemName = "diamond arrow", clientId = 35901, buy = 100 },
	{ itemName = "earth arrow", clientId = 774, buy = 5 },
	{ itemName = "envenomed arrow", clientId = 16143, buy = 12 },
	{ itemName = "flaming arrow", clientId = 763, buy = 5 },
	{ itemName = "flash arrow", clientId = 761, buy = 5 },
	{ itemName = "onyx arrow", clientId = 7365, buy = 7 },
	{ itemName = "piercing bolt", clientId = 7363, buy = 5 },
	{ itemName = "power bolt", clientId = 3450, buy = 7 },
	{ itemName = "prismatic bolt", clientId = 16141, buy = 20 },
	{ itemName = "quiver", clientId = 35562, buy = 400 },
	{ itemName = "royal spear", clientId = 7378, buy = 15 },
	{ itemName = "shiver arrow", clientId = 762, buy = 5 },
	{ itemName = "sniper arrow", clientId = 7364, buy = 5 },
	{ itemName = "spectral bolt", clientId = 35902, buy = 70 },
	{ itemName = "tarsal arrow", clientId = 14251, buy = 6 },
	{ itemName = "throwing star", clientId = 3287, buy = 42 },
	{ itemName = "vortex bolt", clientId = 14252, buy = 6 },

	-- potions
	{ itemName = "great health potion", clientId = 239, buy = 225 },
	{ itemName = "great mana potion", clientId = 238, buy = 144 },
	{ itemName = "great spirit potion", clientId = 7642, buy = 228 },
	{ itemName = "health potion", clientId = 266, buy = 50 },
	{ itemName = "mana potion", clientId = 268, buy = 56 },
	{ itemName = "strong health potion", clientId = 236, buy = 115 },
	{ itemName = "strong mana potion", clientId = 237, buy = 93 },
	{ itemName = "supreme health potion", clientId = 23375, buy = 625 },
	{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
	{ itemName = "ultimate mana potion", clientId = 23373, buy = 438 },
	{ itemName = "ultimate spirit potion", clientId = 23374, buy = 438 },
	{ itemName = "empty potion flask", clientId = 283, sell = 5 },
	{ itemName = "empty potion flask", clientId = 284, sell = 5 },
	{ itemName = "empty potion flask", clientId = 285, sell = 5 },
	{ itemName = "vial", clientId = 2874, sell = 5 },

	-- runes
	{ itemName = "animate dead rune", clientId = 3203, buy = 375 },
	{ itemName = "avalanche rune", clientId = 3161, buy = 57 },
	{ itemName = "blank rune", clientId = 3147, buy = 10 },
	{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
	{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
	{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
	{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
	{ itemName = "disintegrate rune", clientId = 3197, buy = 26 },
	{ itemName = "energy bomb rune", clientId = 3149, buy = 203 },
	{ itemName = "energy field rune", clientId = 3164, buy = 38 },
	{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
	{ itemName = "explosion rune", clientId = 3200, buy = 31 },
	{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },
	{ itemName = "fire field rune", clientId = 3188, buy = 28 },
	{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
	{ itemName = "fireball rune", clientId = 3189, buy = 30 },
	{ itemName = "great fireball rune", clientId = 3191, buy = 57 },
	{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
	{ itemName = "holy missile rune", clientId = 3182, buy = 16 },
	{ itemName = "icicle rune", clientId = 3158, buy = 30 },
	{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
	{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
	{ itemName = "magic wall rune", clientId = 3180, buy = 116 },
	{ itemName = "paralyse rune", clientId = 3165, buy = 700 },
	{ itemName = "poison bomb rune", clientId = 3173, buy = 85 },
	{ itemName = "poison field rune", clientId = 3172, buy = 21 },
	{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
	{ itemName = "soulfire rune", clientId = 3195, buy = 46 },
	{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
	{ itemName = "stone shower rune", clientId = 3175, buy = 37 },
	{ itemName = "sudden death rune", clientId = 3155, buy = 135 },
	{ itemName = "thunderstorm rune", clientId = 3202, buy = 47 },
	{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
	{ itemName = "wild growth rune", clientId = 3156, buy = 160 },

	-- supplies
	{ itemName = "brown mushroom", clientId = 3725, buy = 10 },
	{ itemName = "ham", clientId = 3582, buy = 10 },
	{ itemName = "meat", clientId = 3577, buy = 5 },
	{ itemName = "shapeshifter ring", clientId = 907, buy = 5500, subType = 15 },
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
