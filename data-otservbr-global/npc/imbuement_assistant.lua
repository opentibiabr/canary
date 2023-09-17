local internalNpcName = "Imbuement Assistant"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 141,
	lookHead = 41,
	lookBody = 72,
	lookLegs = 39,
	lookFeet = 96,
	lookAddons = 3,
	lookMount = 688,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Hello adventurer, looking for Imbuement items? Just ask me!" },
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

-- start of sales of imbuement packages
keywordHandler:addKeyword({"imbuement packages"}, StdModule.say, {npcHandler = npcHandler, text = "Skill Increase: {Bash}, {Blockade}, {Chop}, {Epiphany}, {Precision}, {Slash}. Additional Attributes: {Featherweight}, {Strike}, {Swiftness}, {Vampirism}, {Vibrancy}, {Void}. Elemental Damage: {Electrify}, {Frost}, {Reap}, {Scorch}, {Venom}. Elemental Protection: {Cloud Fabric}, {Demon Presence}, {Dragon Hide}, {Lich Shroud}, {Quara Scale}, {Snake Skin}."})

-- skill increase packages
local stoneKeyword = keywordHandler:addKeyword({"bash"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for skill club imbuement for 6250 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 6250 end,
    function(player)
        if player:removeMoneyBank(6250) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(9657, 20) -- cyclops toe
            shoppingBag:addItem(22189, 15) -- ogre nose ring
            shoppingBag:addItem(10405, 10) -- warmaster's wristguards
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"blockade"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for skill shield imbuement for 16150 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 16150 end,
    function(player)
        if player:removeMoneyBank(16150) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(9641, 20) -- piece of scarab shell
            shoppingBag:addItem(11703, 25) -- brimstone shell
            shoppingBag:addItem(20199, 25) -- frazzle skin
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"chop"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for skill axe imbuement for 13050 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 13050 end,
    function(player)
        if player:removeMoneyBank(13050) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(10196, 20) -- orc tooth
            shoppingBag:addItem(11447, 25) -- battle stone
            shoppingBag:addItem(21200, 20) -- moohtant horn
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"epiphany"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for magic level imbuement for 10650 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 10650 end,
    function(player)
        if player:removeMoneyBank(10650) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(9635, 25) -- elvish talisman
            shoppingBag:addItem(11452, 15) -- broken shamanic staff
            shoppingBag:addItem(10309, 15) -- strand of medusa hair
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"precision"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for skill distance imbuement for 6750 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 6750 end,
    function(player)
        if player:removeMoneyBank(6750) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(11464, 25) -- elven scouting glass
            shoppingBag:addItem(18994, 20) -- elven hoof
            shoppingBag:addItem(10298, 10) -- metal spike
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"slash"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for skill sword imbuement for 6550 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 6550 end,
    function(player)
        if player:removeMoneyBank(6550) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(9691, 25) -- lion's mane
            shoppingBag:addItem(21202, 25) -- mooh'tah shell
            shoppingBag:addItem(9654, 5) -- war crystal
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

-- additional attributes packages
local stoneKeyword = keywordHandler:addKeyword({"featherweight"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for capacity increase imbuement for 12250 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 12250 end,
    function(player)
        if player:removeMoneyBank(12250) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(25694, 20) -- fairy wings
            shoppingBag:addItem(25702, 10) -- little bowl of myrrh
            shoppingBag:addItem(20205, 5) -- goosebump leather
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"strike"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for critical imbuement for 16700 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 16700 end,
    function(player)
        if player:removeMoneyBank(16700) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(11444, 20) -- protective charm
            shoppingBag:addItem(10311, 25) -- sabretooth
            shoppingBag:addItem(22728, 5) -- vexclaw talon
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"swiftness"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for speed imbuement for 5225 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 5225 end,
    function(player)
        if player:removeMoneyBank(5225) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(17458, 15) -- damselfly wing
            shoppingBag:addItem(10302, 25) -- compass
            shoppingBag:addItem(14081, 20) -- waspoid wing
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"vampirism"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for life leech imbuement for 10475 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 10475 end,
    function(player)
        if player:removeMoneyBank(10475) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(9685, 25) -- vampire teeth
            shoppingBag:addItem(9633, 15) -- bloody pincers
            shoppingBag:addItem(9663, 5) -- piece of dead brain
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"vibrancy"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for paralysis removal imbuement for 15000 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 15000 end,
    function(player)
        if player:removeMoneyBank(15000) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(22053, 20) -- wereboar hooves
            shoppingBag:addItem(23507, 15) -- crystallized anger
            shoppingBag:addItem(28567, 5) -- quill
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"void"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for mana leech imbuement for 17400 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 17400 end,
    function(player)
        if player:removeMoneyBank(17400) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(11492, 25) -- rope belt
            shoppingBag:addItem(20200, 25) -- silencer claws
            shoppingBag:addItem(22730, 5) -- some grimeleech wings
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

-- elemental damage packages
local stoneKeyword = keywordHandler:addKeyword({"electrify"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for energy damage imbuement for 3770 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 3770 end,
    function(player)
        if player:removeMoneyBank(3770) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(18993, 25) -- rorc feather
            shoppingBag:addItem(21975, 5) -- peacock feather fan
            shoppingBag:addItem(23508, 1) -- energy vein
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"frost"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for ice damage imbuement for 9750 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 9750 end,
    function(player)
        if player:removeMoneyBank(9750) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(9661, 25) -- frosty heart
            shoppingBag:addItem(21801, 10) -- seacrest hair
            shoppingBag:addItem(9650, 5) -- polar bear paw
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"reap"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for death damage imbuement for 3475 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 3475 end,
    function(player)
        if player:removeMoneyBank(3475) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(11484, 25) -- pile of grave earth
            shoppingBag:addItem(9647, 20) -- demonic skeletal hand
            shoppingBag:addItem(10420, 5) -- petrified scream
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"scorch"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for fire damage imbuement for 15875 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 15875 end,
    function(player)
        if player:removeMoneyBank(15875) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(9636, 25) -- fiery heart
            shoppingBag:addItem(5920, 5) -- green dragon scale
            shoppingBag:addItem(5954, 5) -- demon horn
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"venom"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for earth damage imbuement for 1820 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 1820 end,
    function(player)
        if player:removeMoneyBank(1820) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(9686, 25) -- swamp grass
            shoppingBag:addItem(9640, 20) -- poisonous slime
            shoppingBag:addItem(21194, 2) -- slime heart
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

-- elemental protection packages
local stoneKeyword = keywordHandler:addKeyword({"cloud fabric"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for energy protection imbuement for 13775 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 13775 end,
    function(player)
        if player:removeMoneyBank(13775) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(9644, 20) -- wyvern talisman
            shoppingBag:addItem(14079, 15) -- crawler head plating
            shoppingBag:addItem(9665, 10) -- wyrm scale
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"demon presence"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for holy protection imbuement for  20250 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 20250 end,
    function(player)
        if player:removeMoneyBank(20250) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(9639, 25) -- cultish robe
            shoppingBag:addItem(9638, 25) -- cultish mask
            shoppingBag:addItem(10304, 20) -- hellspawn tail
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"dragon hide"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for fire protection imbuement for 10850 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 10850 end,
    function(player)
        if player:removeMoneyBank(10850) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(5877, 20) -- green dragon leather
            shoppingBag:addItem(16131, 10) -- blazing bone
            shoppingBag:addItem(11658, 5) -- draken sulphur
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"lich shroud"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for death protection imbuement for 5650 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 5650 end,
    function(player)
        if player:removeMoneyBank(5650) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(11466, 25) -- flask of embalming fluid
            shoppingBag:addItem(22007, 20) -- gloom wolf fur
            shoppingBag:addItem(9660, 5) -- mystical hourglass
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"quara scale"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for ice protection imbuement for 3650 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 3650 end,
    function(player)
        if player:removeMoneyBank(3650) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(10295, 25) -- winter wolf fur
            shoppingBag:addItem(10307, 15) -- thick fur
            shoppingBag:addItem(14012, 10) -- deepling warts
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})

local stoneKeyword = keywordHandler:addKeyword({"snake skin"}, StdModule.say, {npcHandler = npcHandler, text = "Do you want to buy items for earth protection imbuement for 12550 gold?"})
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "You have successfully completed your purchase of the items.", reset = true},
    function(player) return player:getMoney() + player:getBankBalance() >= 12550 end,
    function(player)
        if player:removeMoneyBank(12550) then
            local shoppingBag = player:addItem(2856, 1) -- present box
            shoppingBag:addItem(17823, 25) -- piece of swampling wood
            shoppingBag:addItem(9694, 20) -- snake skin
            shoppingBag:addItem(11702, 10) -- brimstone fangs
        end
    end
)
stoneKeyword:addChildKeyword({"yes"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true})
-- end of imbuement packages sales

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME| say {imbuement packages} or {trade} for buy imbuement items.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "See you later |PLAYERNAME| come back soon.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you later |PLAYERNAME| come back soon.") 

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "battle stone", clientId = 11447, buy = 290 },
	{ itemName = "blazing bone", clientId = 16131, buy = 610 },
	{ itemName = "bloody pincers", clientId = 9633, buy = 100 },
	{ itemName = "brimstone fangs", clientId = 11702, buy = 380 },
	{ itemName = "brimstone shell", clientId = 11703, buy = 210 },
	{ itemName = "broken shamanic staff", clientId = 11452, buy = 35 },
	{ itemName = "compass", clientId = 10302, buy = 45 },
	{ itemName = "crawler head plating", clientId = 14079, buy = 210 },
	{ itemName = "crystallized anger", clientId = 23507, buy = 400 },
	{ itemName = "cultish mask", clientId = 9638, buy = 280 },
	{ itemName = "cultish robe", clientId = 9639, buy = 150 },
	{ itemName = "cyclops toe", clientId = 9657, buy = 55 },
	{ itemName = "damselfly wing", clientId = 17458, buy = 20 },
	{ itemName = "deepling warts", clientId = 14012, buy = 180 },
	{ itemName = "demon horn", clientId = 5954, buy = 1000 },
	{ itemName = "demonic skeletal hand", clientId = 9647, buy = 80 },
	{ itemName = "draken sulphur", clientId = 11658, buy = 550 },
	{ itemName = "elven hoof", clientId = 18994, buy = 115 },
	{ itemName = "elven scouting glass", clientId = 11464, buy = 50 },
	{ itemName = "elvish talisman", clientId = 9635, buy = 45 },
	{ itemName = "energy vein", clientId = 23508, buy = 270 },
	{ itemName = "fairy wings", clientId = 25694, buy = 200 },
	{ itemName = "fiery heart", clientId = 9636, buy = 375 },
	{ itemName = "flask of embalming fluid", clientId = 11466, buy = 30 },
	{ itemName = "frazzle skin", clientId = 20199, buy = 400 },
	{ itemName = "frosty heart", clientId = 9661, buy = 280 },
	{ itemName = "gloom wolf fur", clientId = 22007, buy = 70 },
	{ itemName = "goosebump leather", clientId = 20205, buy = 650 },
	{ itemName = "green dragon leather", clientId = 5877, buy = 100 },
	{ itemName = "green dragon scale", clientId = 5920, buy = 100 },
	{ itemName = "hellspawn tail", clientId = 10304, buy = 475 },
	{ itemName = "lion's mane", clientId = 9691, buy = 60 },
	{ itemName = "little bowl of myrrh", clientId = 25702, buy = 500 },
	{ itemName = "metal spike", clientId = 10298, buy = 320 },
	{ itemName = "mooh'tah shell", clientId = 21202, buy = 110 },
	{ itemName = "moohtant horn", clientId = 21200, buy = 140 },
	{ itemName = "mystical hourglass", clientId = 9660, buy = 700 },
	{ itemName = "ogre nose ring", clientId = 22189, buy = 210 },
	{ itemName = "orc tooth", clientId = 10196, buy = 150 },
	{ itemName = "peacock feather fan", clientId = 21975, buy = 350 },
	{ itemName = "petrified scream", clientId = 10420, buy = 250 },
	{ itemName = "piece of dead brain", clientId = 9663, buy = 420 },
	{ itemName = "piece of scarab shell", clientId = 9641, buy = 45 },
	{ itemName = "piece of swampling wood", clientId = 17823, buy = 30 },
	{ itemName = "pile of grave earth", clientId = 11484, buy = 25 },
	{ itemName = "poisonous slime", clientId = 9640, buy = 50 },
	{ itemName = "polar bear paw", clientId = 9650, buy = 30 },
	{ itemName = "protective charm", clientId = 11444, buy = 60 },
	{ itemName = "quill", clientId = 28567, buy = 1100 },
	{ itemName = "rope belt", clientId = 11492, buy = 66 },
	{ itemName = "rorc feather", clientId = 18993, buy = 70 },
	{ itemName = "sabretooth", clientId = 10311, buy = 400 },
	{ itemName = "seacrest hair", clientId = 21801, buy = 260 },
	{ itemName = "silencer claws", clientId = 20200, buy = 390 },
	{ itemName = "slime heart", clientId = 21194, buy = 160 },
	{ itemName = "snake skin", clientId = 9694, buy = 400 },
	{ itemName = "some grimeleech wings", clientId = 22730, buy = 1200 },
	{ itemName = "strand of medusa hair", clientId = 10309, buy = 600 },
	{ itemName = "swamp grass", clientId = 9686, buy = 20 },
	{ itemName = "thick fur", clientId = 10307, buy = 150 },
	{ itemName = "vampire teeth", clientId = 9685, buy = 275 },
	{ itemName = "vexclaw talon", clientId = 22728, buy = 1100 },
	{ itemName = "war crystal", clientId = 9654, buy = 460 },
	{ itemName = "warmaster's wristguards", clientId = 10405, buy = 200 },
	{ itemName = "waspoid wing", clientId = 14081, buy = 190 },
	{ itemName = "wereboar hooves", clientId = 22053, buy = 175 },
	{ itemName = "winter wolf fur", clientId = 10295, buy = 20 },
	{ itemName = "wyrm scale", clientId = 9665, buy = 400 },
	{ itemName = "wyvern talisman", clientId = 9644, buy = 265 },
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
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
