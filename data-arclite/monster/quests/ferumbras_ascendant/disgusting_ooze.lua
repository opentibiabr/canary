local mType = Game.createMonsterType("Disgusting Ooze")
local monster = {}

monster.description = "a disgusting ooze"
monster.experience = 3700
monster.outfit = {
	lookType = 238,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3650
monster.maxHealth = 3650
monster.race = "venom"
monster.corpse = 6532
monster.speed = 130
monster.manaCost = 0

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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 85,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.events = {
	"DisgustingOozeDeath"
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Blubb", yell = false},
	{text = "Blubb Blubb", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 272}, -- gold coin
	{id = 3035, chance = 95660, maxCount = 6}, -- platinum coin
	{id = 6499, chance = 20340}, -- demonic essence
	{id = 5944, chance = 20130}, -- soul orb
	{id = 9054, chance = 14190}, -- glob of acid slime
	{id = 9055, chance = 11550}, -- glob of tar
	{id = 3034, chance = 5930}, -- talon
	{id = 3032, chance = 5400, maxCount = 3}, -- small emerald
	{id = 3030, chance = 2750, maxCount = 2}, -- small ruby
	{id = 3028, chance = 2650, maxCount = 2}, -- small diamond
	{id = 6299, chance = 2440}, -- death ring
	{id = 3039, chance = 1590}, -- red gem
	{id = 3037, chance = 1380}, -- yellow gem
	{id = 3038, chance = 640}, -- green gem
	{id = 3041, chance = 320} -- blue gem
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 50, attack = 80, condition = {type = CONDITION_POISON, totalDamage = 300, interval = 4000}},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_LIFEDRAIN, minDamage = -160, maxDamage = -295, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = true},
	{name ="defiler paralyze 3", interval = 2000, chance = 9, target = false},
	{name ="defiler paralyze 1", interval = 2000, chance = 6, target = false},
	{name ="defiler paralyze 2", interval = 2000, chance = 8, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -300, maxDamage = -500, radius = 8, effect = CONST_ME_HITBYPOISON, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -400, maxDamage = -725, length = 8, spread = 3, effect = CONST_ME_SMALLPLANTS, target = false},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_EARTHDAMAGE, minDamage = -120, maxDamage = -170, radius = 3, effect = CONST_ME_POISONAREA, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 450, effect = CONST_ME_MAGIC_GREEN, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -25},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
