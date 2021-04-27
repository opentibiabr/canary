local mType = Game.createMonsterType("Orshabaal")
local monster = {}

monster.description = "Orshabaal"
monster.experience = 10000
monster.outfit = {
	lookType = 201,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 22500
monster.maxHealth = 22500
monster.race = "fire"
monster.corpse = 5995
monster.speed = 380
monster.manaCost = 0
monster.maxSummons = 4

monster.changeTarget = {
	interval = 2000,
	chance = 10
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
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 2500,
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
	{name = "demon", chance = 10, interval = 1000, max = 4}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "PRAISED BE MY MASTERS, THE RUTHLESS SEVEN!", yell = false},
	{text = "YOU ARE DOOMED!", yell = false},
	{text = "ORSHABAAL IS BACK!", yell = false},
	{text = "Be prepared for the day my masters will come for you!", yell = false},
	{text = "SOULS FOR ORSHABAAL!", yell = false}
}

monster.loot = {
	{name = "purple tome", chance = 20000},
	{name = "golden mug", chance = 12500},
	{name = "crystal necklace", chance = 20000},
	{name = "white pearl", chance = 33333, maxCount = 15},
	{name = "black pearl", chance = 25000, maxCount = 8},
	{name = "small diamond", chance = 20000, maxCount = 5},
	{name = "small sapphire", chance = 33333, maxCount = 8},
	{name = "small emerald", chance = 25000, maxCount = 7},
	{name = "small amethyst", chance = 20000, maxCount = 17},
	{name = "talon", chance = 20000, maxCount = 3},
	{name = "platinum coin", chance = 100000, maxCount = 69},
	{name = "green gem", chance = 6666},
	{name = "blue gem", chance = 20000},
	{id = 2162, chance = 6666},
	{name = "might ring", chance = 6666},
	{name = "silver amulet", chance = 20000},
	{name = "platinum amulet", chance = 12500},
	{name = "strange symbol", chance = 20000},
	{name = "orb", chance = 6666},
	{name = "life crystal", chance = 12500},
	{name = "mind stone", chance = 20000},
	{name = "boots of haste", chance = 12500},
	{name = "protection amulet", chance = 20000},
	{name = "ring of healing", chance = 33333},
	{name = "two handed sword", chance = 12500},
	{name = "giant sword", chance = 25000},
	{name = "silver dagger", chance = 6666},
	{name = "golden sickle", chance = 6666},
	{name = "fire axe", chance = 12500},
	{name = "dragon hammer", chance = 6666},
	{name = "devil helmet", chance = 33333},
	{name = "golden legs", chance = 12500},
	{name = "magic plate armor", chance = 6666},
	{name = "mastermind shield", chance = 6666},
	{name = "demon shield", chance = 25000},
	{name = "Orshabaal's brain", chance = 6666},
	{name = "thunder hammer", chance = 6666},
	{name = "demon horn", chance = 50000},
	{id = 6300, chance = 50000},
	{name = "demonic essence", chance = 100000},
	{name = "assassin star", chance = 12500, maxCount = 42},
	{name = "great mana potion", chance = 33333},
	{name = "great health potion", chance = 20000},
	{name = "great spirit potion", chance = 12500},
	{name = "ultimate health potion", chance = 33333},
	{name = "gold ingot", chance = 6666}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1990},
	{name ="combat", interval = 1000, chance = 13, type = COMBAT_MANADRAIN, minDamage = -300, maxDamage = -600, range = 7, target = false},
	{name ="combat", interval = 1000, chance = 6, type = COMBAT_MANADRAIN, minDamage = -150, maxDamage = -350, radius = 5, effect = CONST_ME_POISONAREA, target = false},
	{name ="effect", interval = 1000, chance = 6, radius = 5, effect = CONST_ME_HITAREA, target = false},
	{name ="combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -310, maxDamage = -600, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="firefield", interval = 1000, chance = 10, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -850, length = 8, spread = 3, effect = CONST_ME_ENERGYHIT, target = false}
}

monster.defenses = {
	defense = 111,
	armor = 90,
	{name ="combat", interval = 1000, chance = 9, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 2500, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="combat", interval = 1000, chance = 17, type = COMBAT_HEALING, minDamage = 600, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 1000, chance = 5, speedChange = 1901, effect = CONST_ME_MAGIC_RED, target = false, duration = 7000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -1},
	{type = COMBAT_HOLYDAMAGE , percent = -1},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
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
