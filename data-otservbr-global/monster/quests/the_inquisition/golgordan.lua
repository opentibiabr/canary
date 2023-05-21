local mType = Game.createMonsterType("Golgordan")
local monster = {}

monster.description = "Golgordan"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 52,
	lookBody = 99,
	lookLegs = 52,
	lookFeet = 91,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 40000
monster.maxHealth = 40000
monster.race = "fire"
monster.corpse = 7893
monster.speed = 195
monster.manaCost = 0

monster.changeTarget = {
	interval = 7000,
	chance = 10
}

monster.bosstiary = {
	bossRaceId = 416,
	bossRace = RARITY_BANE
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 85,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Latrivan, you fool!", yell = true},
	{text = "We are the right hand and the left hand of the seven!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 273}, -- gold coin
	{id = 239, chance = 55000}, -- great health potion
	{id = 3275, chance = 30000}, -- double axe
	{id = 6299, chance = 25000}, -- death ring
	{id = 3098, chance = 25000}, -- ring of healing
	{id = 3027, chance = 20000, maxCount = 13}, -- black pearl
	{id = 3032, chance = 20000, maxCount = 10}, -- small emerald
	{id = 3284, chance = 15000}, -- ice rapier
	{id = 3046, chance = 15000}, -- magic light wand
	{id = 3054, chance = 15000}, -- silver amulet
	{id = 3029, chance = 15000, maxCount = 10}, -- small sapphire
	{id = 3026, chance = 15000, maxCount = 13}, -- white pearl
	{id = 3420, chance = 10000}, -- demon shield
	{id = 6499, chance = 10000}, -- demonic essence
	{id = 3051, chance = 10000}, -- energy ring
	{id = 3281, chance = 10000}, -- giant sword
	{id = 9058, chance = 10000}, -- gold ingot
	{id = 3063, chance = 10000}, -- gold ring
	{id = 3364, chance = 10000}, -- golden legs
	{id = 3041, chance = 5000}, -- blue gem
	{id = 3356, chance = 5000}, -- devil helmet
	{id = 3320, chance = 5000}, -- fire axe
	{id = 3038, chance = 5000}, -- green gem
	{id = 3048, chance = 5000}, -- might ring
	{id = 3290, chance = 5000}, -- silver dagger
	{id = 3033, chance = 15000, maxCount = 12}, -- small amethyst
	{id = 3066, chance = 5000}, -- snakebite rod
	{id = 3049, chance = 5000}, -- stealth ring
	{id = 3081, chance = 5000} -- stone skin amulet
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -60, maxDamage = -200, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 1000, chance = 11, minDamage = -30, maxDamage = -30, length = 5, spread = 3, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 3000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -50, maxDamage = -600, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -600, range = 4, radius = 1, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -600, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 1000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -50, maxDamage = -60, radius = 6, effect = CONST_ME_GROUNDSHAKER, target = false}
}

monster.defenses = {
	defense = 54,
	armor = 48
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 1},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -1},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -1},
	{type = COMBAT_HOLYDAMAGE , percent = 1},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
