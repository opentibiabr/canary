local mType = Game.createMonsterType("Plagirath")
local monster = {}

monster.description = "plagirath"
monster.experience = 58000
monster.outfit = {
	lookType = 862,
	lookHead = 84,
	lookBody = 62,
	lookLegs = 60,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "venom"
monster.corpse = 25151
monster.speed = 320
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "BOOOOOOOMMM!!!!!", yell = false},
	{text = "WITHER AND DIE!", yell = true},
	{text = "DEATH AND DECAY!", yell = true},
	{text = "I CAN SENSE YOUR BODIES ROOTING!", yell = true}
}

monster.loot = {
	{id = 25172, chance = 1000000},
	{id = 11306, chance = 3000},
	{id = 18411, chance = 1820},
	{id = 18419, chance = 23000, maxCount = 6},
	{id = 18420, chance = 23000, maxCount = 6},
	{id = 18421, chance = 23000, maxCount = 6},
	{id = 2143, chance = 12000, maxCount = 8},
	{id = 2146, chance = 12000, maxCount = 9},
	{id = 2148, chance = 98000, maxCount = 200},
	{id = 2150, chance = 10000, maxCount = 5},
	{id = 2152, chance = 8000, maxCount = 58},
	{id = 25383, chance = 800},
	{id = 25415, chance = 500, unique = true},
	{id = 25522, chance = 800},
	{id = 25523, chance = 800},
	{id = 6500, chance = 11000},
	{id = 7386, chance = 5000},
	{id = 7632, chance = 14000, maxCount = 5},
	{id = 7633, chance = 14000, maxCount = 5},
	{id = 7887, chance = 5000},
	{id = 8473, chance = 23000, maxCount = 15},
	{id = 8901, chance = 4000},
	{id = 9970, chance = 10000, maxCount = 8}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -1300, maxDamage = -2250},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -900, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, range = 4, radius = 4, effect = CONST_ME_POFF, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -1000, maxDamage = -1200, length = 10, spread = 3, effect = CONST_ME_POFF, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -1500, maxDamage = -1900, length = 10, spread = 3, effect = CONST_ME_POFF, target = false},
	{name ="speed", interval = 2000, chance = 20, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000},
	{name ="plagirath bog", interval = 20000, chance = 25, target = false}
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 3000, maxDamage = 4000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 30, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000},
	{name ="plagirath summon", interval = 2000, chance = 15, target = false},
	{name ="plagirath heal", interval = 2000, chance = 17, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
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
