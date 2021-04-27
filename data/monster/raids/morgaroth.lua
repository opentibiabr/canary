local mType = Game.createMonsterType("Morgaroth")
local monster = {}

monster.description = "Morgaroth"
monster.experience = 15000
monster.outfit = {
	lookType = 12,
	lookHead = 0,
	lookBody = 94,
	lookLegs = 79,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 55000
monster.maxHealth = 55000
monster.race = "fire"
monster.corpse = 6068
monster.speed = 400
monster.manaCost = 0
monster.maxSummons = 6

monster.changeTarget = {
	interval = 10000,
	chance = 20
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 100,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summons = {
	{name = "Demon", chance = 33, interval = 4000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I AM MORGAROTH, LORD OF THE TRIANGLE... AND YOU ARE LOST!", yell = true},
	{text = "MY SEED IS FEAR AND MY HARVEST ARE YOUR SOULS!", yell = true},
	{text = "ZATHROTH! LOOK AT THE DESTRUCTION I AM CAUSING IN YOUR NAME!", yell = true},
	{text = "THE TRIANGLE OF TERROR WILL RISE!", yell = true}
}

monster.loot = {
	{name = "platinum coin", chance = 95000, maxCount = 74},
	{name = "demonic essence", chance = 95000, maxCount = 5},
	{name = "green gem", chance = 50000},
	{name = "great mana potion", chance = 45000},
	{name = "small amethyst", chance = 36000, maxCount = 18},
	{name = "devileye", chance = 36000},
	{name = "small emerald", chance = 27000, maxCount = 7},
	{name = "small sapphire", chance = 27000, maxCount = 9},
	{name = "red tome", chance = 27000},
	{name = "ultimate health potion", chance = 27000},
	{name = "talon", chance = 22000, maxCount = 7},
	{name = "demon horn", chance = 22000, maxCount = 2},
	{id = 6300, chance = 22000},
	{name = "ring of healing", chance = 22000},
	{name = "chain bolter", chance = 22000},
	{name = "dark lord's cape", chance = 22000},
	{name = "ironworker", chance = 25000},
	{name = "double axe", chance = 18000},
	{name = "great spirit potion", chance = 18000},
	{name = "magic plate armor", chance = 18000},
	{name = "might ring", chance = 18000},
	{name = "mind stone", chance = 18000},
	{name = "stealth ring", chance = 18000},
	{name = "fireborn giant armor", chance = 18000},
	{name = "royal crossbow", chance = 18000},
	{name = "teddy bear", chance = 18000},
	{name = "white pearl", chance = 13000, maxCount = 11},
	{name = "black pearl", chance = 13000, maxCount = 13},
	{name = "assassin star", chance = 13000, maxCount = 35},
	{name = "demonbone", chance = 13000},
	{name = "golden mug", chance = 13000},
	{name = "Morgaroth's heart", chance = 13000},
	{name = "obsidian truncheon", chance = 13000},
	{name = "stomper", chance = 13000},
	{name = "blue gem", chance = 9000},
	{name = "gold ring", chance = 9000},
	{name = "demon shield", chance = 9000},
	{name = "energy ring", chance = 9000},
	{name = "giant sword", chance = 9000},
	{name = "golden legs", chance = 9000},
	{name = "life crystal", chance = 9000},
	{id = 2162, chance = 9000},
	{name = "orb", chance = 9000},
	{name = "strange symbol", chance = 9000},
	{name = "steel boots", chance = 9000},
	{name = "thunder hammer", chance = 9000},
	{name = "small diamond", chance = 4500, maxCount = 5},
	{id = 2124, chance = 4500},
	{name = "fire axe", chance = 4500},
	{name = "great health potion", chance = 4500},
	{name = "mastermind shield", chance = 4500},
	{name = "dragon robe", chance = 4500},
	{name = "molten plate", chance = 4500},
	{name = "great shield", chance = 500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2250},
	{name ="combat", interval = 3000, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1210, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 1800, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -580, range = 7, radius = 5, effect = CONST_ME_HITAREA, target = false},
	{name ="combat", interval = 3000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -1450, length = 8, spread = 3, effect = CONST_ME_ENERGYHIT, target = false},
	{name ="combat", interval = 2500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -480, range = 7, radius = 5, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -500, range = 7, radius = 13, effect = CONST_ME_SOUND_RED, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -450, radius = 14, effect = CONST_ME_LOSEENERGY, target = false},
	{name ="combat", interval = 3000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -200, range = 7, radius = 3, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -400, range = 7, effect = CONST_ME_SOUND_RED, target = false, duration = 20000},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -70, maxDamage = -320, radius = 3, effect = CONST_ME_HITAREA, target = true},
	{name ="dark torturer skill reducer", interval = 2000, chance = 5, target = false}
}

monster.defenses = {
	defense = 65,
	armor = 55,
	{name ="combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1100, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="combat", interval = 9000, chance = 15, type = COMBAT_HEALING, minDamage = 3800, maxDamage = 4000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 4000, chance = 80, speedChange = 470, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 80},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 80}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType.onThink = function(monster, interval)
end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature)
end

mType.onMove = function(monster, creature, fromPosition, toPosition)
end

mType.onSay = function(monster, creature, type, message)
end

mType:register(monster)
