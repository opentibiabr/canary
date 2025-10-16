local mType = Game.createMonsterType("Plagueroot")
local monster = {}

monster.description = "Plagueroot"
monster.experience = 55000
monster.outfit = {
	lookType = 1121,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "venom"
monster.corpse = 30022
monster.speed = 85
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
	"facelessHealth",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1695,
	bossRace = RARITY_NEMESIS,
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
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 2995, chance = 80000 }, -- piggy bank
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 23535, chance = 80000 }, -- energy bar
	{ id = 22516, chance = 80000, maxCount = 3 }, -- silver token
	{ id = 22721, chance = 80000, maxCount = 2 }, -- gold token
	{ id = 23375, chance = 80000, maxCount = 20 }, -- supreme health potion
	{ id = 23373, chance = 80000, maxCount = 14 }, -- ultimate mana potion
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 23374, chance = 80000, maxCount = 20 }, -- ultimate spirit potion
	{ id = 25759, chance = 80000, maxCount = 100 }, -- royal star
	{ id = 3038, chance = 80000, maxCount = 2 }, -- green gem
	{ id = 30169, chance = 80000 }, -- pomegranate
	{ id = 36706, chance = 80000, maxCount = 2 }, -- red gem
	{ id = 3037, chance = 80000, maxCount = 2 }, -- yellow gem
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 3043, chance = 80000, maxCount = 2 }, -- crystal coin
	{ id = 29418, chance = 80000 }, -- living armor
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 7414, chance = 80000 }, -- abyss hammer
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 30087, chance = 80000 }, -- plagueroot offshoot
	{ id = 29417, chance = 80000 }, -- living vine bow
	{ id = 30170, chance = 80000 }, -- turquoise tendril lantern
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 5809, chance = 80000 }, -- soul stone
	{ id = 30055, chance = 80000 }, -- crunor idol
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 19400, chance = 80000 }, -- arcane staff
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 210, attack = -560 },
	-- fire
	{ name = "condition", type = CONDITION_FIRE, interval = 1000, chance = 7, minDamage = -200, maxDamage = -1000, range = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 1000, chance = 7, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -1050, radius = 6, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 1000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -20, maxDamage = -100, radius = 5, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "firefield", interval = 1000, chance = 4, radius = 8, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -650, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -600, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -600, length = 8, spread = 0, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 500, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 200, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 10, speedChange = 1800, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 1 },
	{ type = COMBAT_EARTHDAMAGE, percent = 120 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
