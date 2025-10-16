local mType = Game.createMonsterType("Izcandar Champion of Winter")
local monster = {}

monster.description = "Izcandar Champion of Winter"
monster.experience = 6900
monster.outfit = {
	lookType = 1137,
	lookHead = 48,
	lookBody = 38,
	lookLegs = 48,
	lookFeet = 48,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 130000
monster.maxHealth = 130000
monster.race = "blood"
monster.corpse = 25151
monster.speed = 200
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
	"izcandarThink",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Dream or nightmare?", yell = false },
}

monster.loot = {
	{ id = 23535, chance = 80000 }, -- energy bar
	{ id = 22721, chance = 80000, maxCount = 2 }, -- gold token
	{ id = 2995, chance = 80000 }, -- piggy bank
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 22516, chance = 80000, maxCount = 2 }, -- silver token
	{ id = 3037, chance = 80000, maxCount = 2 }, -- yellow gem
	{ id = 23375, chance = 80000, maxCount = 20 }, -- supreme health potion
	{ id = 23373, chance = 80000, maxCount = 14 }, -- ultimate mana potion
	{ id = 23374, chance = 80000, maxCount = 20 }, -- ultimate spirit potion
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 25759, chance = 80000, maxCount = 100 }, -- royal star
	{ id = 29422, chance = 80000 }, -- winterblade
	{ id = 7439, chance = 80000, maxCount = 10 }, -- berserk potion
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 3043, chance = 80000, maxCount = 2 }, -- crystal coin
	{ id = 30056, chance = 80000 }, -- ornate locket
	{ id = 30169, chance = 80000 }, -- pomegranate
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 29944, chance = 80000 }, -- izcandars snow globe
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 30168, chance = 80000 }, -- ice shield
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 23531, chance = 80000 }, -- ring of green plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -320, maxDamage = -750 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -500, maxDamage = -850, radius = 6, effect = false, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DROWNDAMAGE, minDamage = -300, maxDamage = -850, length = 8, spread = 3, effect = false, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -444, maxDamage = -850, radius = 4, effect = false, shootEffect = CONST_ANI_SUDDENDEATH, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -410, maxDamage = -850, length = 9, effect = false, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -410, maxDamage = -850, length = 9, effect = false, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -410, maxDamage = -850, length = 9, effect = false, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -410, maxDamage = -850, radius = 3, shootEffect = CONST_ANI_EARTH, effect = false, target = false },
}

monster.defenses = {
	defense = 76,
	armor = 76,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 310, maxDamage = 640, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "invisible", condition = true },
	{ type = "ice", condition = true },
}

mType:register(monster)
