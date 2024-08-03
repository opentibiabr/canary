local npcName = "Hunt Refiller"

local npcType = Game.createNpcType(npcName)
local npcConfig = {}

npcConfig.name = npcName
npcConfig.description = npcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 1252,
	lookHead = 19,
	lookBody = 86,
	lookLegs = 87,
	lookFeet = 95,
	lookAddons = 3
}

npcConfig.sounds = {
	ticks = 5000,
	chance = 25,
	ids = {
		SOUND_EFFECT_TYPE_ACTION_HITING_FORGE,
		SOUND_EFFECT_TYPE_ACTION_WOOD_HIT,
		SOUND_EFFECT_TYPE_ACTION_CRATE_BREAK_MAGIC_DUST,
		SOUND_EFFECT_TYPE_ACTION_SWORD_DRAWN
	}
}

npcConfig.voices = {
	interval = 15000,
	chance = 20,
	{ text = "Bem vindo ao Sistema Hunt Refiller!" }
}

npcConfig.flags = {
	floorchange = false
}

-- Npc shop
npcConfig.shop = {
	{ itemName = "avalanche rune", clientId = 3161, buy = 57 },
	{ itemName = "blank rune", clientId = 3147, buy = 10 },
	{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
	{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
	{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
	{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
	{ itemName = "durable exercise rod", clientId = 35283, buy = 945000, count = 1800 },
	{ itemName = "durable exercise wand", clientId = 35284, buy = 945000, count = 1800 },
	{ itemName = "empty potion flask", clientId = 283, sell = 5 },
	{ itemName = "empty potion flask", clientId = 284, sell = 5 },
	{ itemName = "empty potion flask", clientId = 285, sell = 5 },
	{ itemName = "energy field rune", clientId = 3164, buy = 38 },
	{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
	{ itemName = "exercise rod", clientId = 28556, buy = 262500, count = 500 },
	{ itemName = "exercise wand", clientId = 28557, buy = 262500, count = 500 },
	{ itemName = "explosion rune", clientId = 3200, buy = 31 },
	{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },
	{ itemName = "fire field rune", clientId = 3188, buy = 28 },
	{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
	{ itemName = "great fireball rune", clientId = 3191, buy = 57 },
	{ itemName = "great health potion", clientId = 239, buy = 225 },
	{ itemName = "great mana potion", clientId = 238, buy = 144 },
	{ itemName = "great spirit potion", clientId = 7642, buy = 228 },
	{ itemName = "health potion", clientId = 266, buy = 50 },
	{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
	{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
	{ itemName = "lasting exercise rod", clientId = 35289, buy = 7560000, count = 14400 },
	{ itemName = "lasting exercise wand", clientId = 35290, buy = 7560000, count = 14400 },
	{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
	{ itemName = "mana potion", clientId = 268, buy = 56 },
	{ itemName = "moonlight rod", clientId = 3070, buy = 1000 },
	{ itemName = "necrotic rod", clientId = 3069, buy = 5000 },
	{ itemName = "poison field rune", clientId = 3172, buy = 21 },
	{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
	{ itemName = "snakebite rod", clientId = 3066, buy = 500 },
	{ itemName = "spellbook", clientId = 3059, buy = 150 },
	{ itemName = "spellwand", clientId = 651, sell = 299 },
	{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
	{ itemName = "strong health potion", clientId = 236, buy = 115 },
	{ itemName = "strong mana potion", clientId = 237, buy = 93 },
	{ itemName = "sudden death rune", clientId = 3155, buy = 135 },
	{ itemName = "terra rod", clientId = 3065, buy = 10000 },
	{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
	{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
	{ itemName = "vial", clientId = 2874, sell = 5 },
	{ itemName = "wand of cosmic energy", clientId = 3073, buy = 10000 },
	{ itemName = "wand of decay", clientId = 3072, buy = 5000 },
	{ itemName = "wand of dragonbreath", clientId = 3075, buy = 1000 },
	{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
	{ itemName = "supreme health potion", clientId = 23375, buy = 625 },
	{ itemName = "ultimate mana potion", clientId = 23373, buy = 438 },
	{ itemName = "wand of vortex", clientId = 3074, buy = 500 },
	{ itemName = "vortex bolt", clientId = 14252, buy = 6 },
	{ itemName = "arrow", clientId = 3447, buy = 3 },
	{ itemName = "assassin star", clientId = 7368, buy = 100 },
	{ itemName = "blue quiver", clientId = 35848, buy = 400 },
	{ itemName = "bolt", clientId = 3446, buy = 4 },
	{ itemName = "bow", clientId = 3350, buy = 400 },
	{ itemName = "burst arrow", clientId = 3449, buy = 10 },
	{ itemName = "crossbow", clientId = 3349, buy = 250 },
	{ itemName = "crystalline arrow", clientId = 15793, buy = 20 },
	{ itemName = "diamond arrow", clientId = 35901, buy = 100 },
	{ itemName = "drill bolt", clientId = 16142, buy = 12 },
	{ itemName = "earth arrow", clientId = 774, buy = 5 },
	{ itemName = "envenomed arrow", clientId = 16143, buy = 12 },
	{ itemName = "flaming arrow", clientId = 763, buy = 5 },
	{ itemName = "flash arrow", clientId = 761, buy = 5 },
	{ itemName = "infernal bolt", clientId = 6528, buy = 110 },
	{ itemName = "onyx arrow", clientId = 7365, buy = 7 },
	{ itemName = "piercing bolt", clientId = 7363, buy = 5 },
	{ itemName = "power bolt", clientId = 3450, buy = 7 },
	{ itemName = "prismatic bolt", clientId = 16141, buy = 20 },
	{ itemName = "quiver", clientId = 35562, buy = 400 },
	{ itemName = "protective charm", clientId = 11444, sell = 60 },
	{ itemName = "purified soul", clientId = 32228, sell = 260 },
	{ itemName = "purple robe", clientId = 11473, sell = 110 },
	{ itemName = "quara bone", clientId = 11491, sell = 500 },
	{ itemName = "quara eye", clientId = 11488, sell = 350 },
	{ itemName = "quara pincers", clientId = 11490, sell = 410 },
	{ itemName = "quara tentacle", clientId = 11487, sell = 140 },
	{ itemName = "quill", clientId = 28567, sell = 1100 },
	{ itemName = "rare earth", clientId = 27301, sell = 80 },
	{ itemName = "ratmiral's hat", clientId = 35613, sell = 150000 },
	{ itemName = "ravenous circlet", clientId = 32597, sell = 220000 },
	{ itemName = "red dragon leather", clientId = 5948, sell = 200 },
	{ itemName = "red dragon scale", clientId = 5882, sell = 200 },
	{ itemName = "red goanna scale", clientId = 31558, sell = 270 },
	{ itemName = "red hair dye", clientId = 17855, sell = 40 },
	{ itemName = "red piece of cloth", clientId = 5911, sell = 300 },
	{ itemName = "rhino hide", clientId = 24388, sell = 175 },
	{ itemName = "rhino horn", clientId = 24389, sell = 265 },
	{ itemName = "rhino horn carving", clientId = 24386, sell = 300 },
	{ itemName = "rod", clientId = 33929, sell = 2200 },
	{ itemName = "roots", clientId = 33938, sell = 1200 },
	{ itemName = "rope belt", clientId = 11492, sell = 66 },
	{ itemName = "rorc egg", clientId = 18996, sell = 120 },
	{ itemName = "rorc feather", clientId = 18993, sell = 70 },
	{ itemName = "rotten heart", clientId = 31589, sell = 74000 },
	{ itemName = "rotten piece of cloth", clientId = 10291, sell = 30 },
	{ itemName = "sabretooth", clientId = 10311, sell = 400 },
	{ itemName = "safety pin", clientId = 11493, sell = 120 },
	{ itemName = "red quiver", clientId = 35849, buy = 400 },
	{ itemName = "jungle quiver", clientId = 35524, buy = 5000 },
	{ itemName = "eldritch quiver", clientId = 36666, buy = 50000 },
	{ itemName = "royal spear", clientId = 7378, buy = 15 },
	{ itemName = "shiver arrow", clientId = 762, buy = 5 },
	{ itemName = "small stone", clientId = 1781, buy = 100 },
	{ itemName = "sniper arrow", clientId = 7364, buy = 5 },
	{ itemName = "spear", clientId = 3277, buy = 9 },
	{ itemName = "spectral bolt", clientId = 35902, buy = 70 },
	{ itemName = "tarsal arrow", clientId = 14251, buy = 6 },
	{ itemName = "throwing star", clientId = 3287, buy = 42 },
	{ itemName = "vortex bolt", clientId = 14252, buy = 6 },
	{ itemName = "brown mushroom", clientId = 3725, buy = 10 }
	
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

-- Create keywordHandler and npcHandler
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

-- onThink
npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

-- onAppear 
npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

-- onDisappear
npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

-- onMove
npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

-- onSay
npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

-- Function called by the callback "npcHandler:setCallback(CALLBACK_GREET, greetCallback)" in end of file
local function greetCallback(npc, creature)
	local player = Player(creature)
    if player and not HUNT_REFILLER[player:getId()] or (HUNT_REFILLER[player:getId()] and HUNT_REFILLER[player:getId()].npc ~= npc:getId()) then
        npcHandler:removeInteraction(npc, creature)
        return false
    end
    
    npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, let's {trade} and refill?")
    return true
end

-- On creature say callback
local function creatureSayCallback(npc, creature, type, message)
    if not npcHandler:checkInteraction(npc, creature) then
        return false
    end

    if MsgContains(message, "Trade") then
        npcHandler:say({
            "It is a pleasure."
        }, npc, creature, 3000)
    end
    return true
end

-- Set to local function "greetCallback"
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
-- Set to local function "creatureSayCallback"
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Bye message
npcHandler:setMessage(MESSAGE_FAREWELL, "Obrigado! Va e ande pela sombra!")
-- Walkaway message
npcHandler:setMessage(MESSAGE_WALKAWAY, "Voce nao tem educacao filhao?")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- Register npc
npcType:register(npcConfig)