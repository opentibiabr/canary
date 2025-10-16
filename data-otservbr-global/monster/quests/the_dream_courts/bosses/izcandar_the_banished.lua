local mType = Game.createMonsterType("Izcandar the Banished")
local monster = {}

monster.description = "Izcandar the Banished"
monster.experience = 55000
monster.outfit = {
	lookType = 1137,
	lookHead = 19,
	lookBody = 95,
	lookLegs = 76,
	lookFeet = 38,
	lookAddons = 2,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1699,
	bossRace = RARITY_NEMESIS,
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "blood"
monster.corpse = 6068
monster.speed = 125
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
}

monster.loot = {
	{ id = 23535, chance = 80000 }, -- energy bar
	{ id = 2995, chance = 80000 }, -- piggy bank
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 22516, chance = 80000, maxCount = 3 }, -- silver token
	{ id = 29944, chance = 80000 }, -- izcandars snow globe
	{ id = 23373, chance = 80000, maxCount = 14 }, -- ultimate mana potion
	{ id = 7439, chance = 80000, maxCount = 10 }, -- berserk potion
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 22721, chance = 80000, maxCount = 2 }, -- gold token
	{ id = 25759, chance = 80000, maxCount = 100 }, -- royal star
	{ id = 23374, chance = 80000, maxCount = 14 }, -- ultimate spirit potion
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 3038, chance = 80000, maxCount = 2 }, -- green gem
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 23375, chance = 80000, maxCount = 6 }, -- supreme health potion
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 29422, chance = 80000 }, -- winterblade
	{ id = 29421, chance = 80000 }, -- summerblade
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 19400, chance = 80000 }, -- arcane staff
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 30169, chance = 80000 }, -- pomegranate
	{ id = 29945, chance = 80000 }, -- izcandars sundial
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 30056, chance = 80000 }, -- ornate locket
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 5809, chance = 80000 }, -- soul stone
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 30170, chance = 80000 }, -- turquoise tendril lantern
	{ id = 7414, chance = 80000 }, -- abyss hammer
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000 },
	{ name = "combat", interval = 3600, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1500, length = 5, spread = 2, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 4100, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -2000, length = 8, spread = 0, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 4700, chance = 17, type = COMBAT_ICEDAMAGE, minDamage = -500, maxDamage = -1500, length = 5, spread = 2, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 3100, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -500, maxDamage = -2000, length = 8, spread = 0, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -700, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	--	mitigation = ???,
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
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
