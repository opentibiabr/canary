local mType = Game.createMonsterType("The Nightmare Beast")
local monster = {}

monster.description = "The Nightmare Beast"
monster.experience = 75000
monster.outfit = {
	lookType = 1144,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 850000
monster.maxHealth = 850000
monster.race = "blood"
monster.corpse = 30159
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1718,
	bossRace = RARITY_ARCHFOE,
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
	{ id = 23375, chance = 80000, maxCount = 6 }, -- supreme health potion
	{ id = 23374, chance = 80000, maxCount = 20 }, -- ultimate spirit potion
	{ id = 23373, chance = 80000, maxCount = 14 }, -- ultimate mana potion
	{ id = 7439, chance = 80000, maxCount = 10 }, -- berserk potion
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 25759, chance = 80000, maxCount = 100 }, -- royal star
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 2995, chance = 80000 }, -- piggy bank
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 23535, chance = 80000 }, -- energy bar
	{ id = 22516, chance = 80000, maxCount = 6 }, -- silver token
	{ id = 22721, chance = 80000, maxCount = 3 }, -- gold token
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 7414, chance = 80000 }, -- abyss hammer
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 5809, chance = 80000 }, -- soul stone
	{ id = 29946, chance = 80000 }, -- beasts nightmarecushion
	{ id = 30170, chance = 80000 }, -- turquoise tendril lantern
	{ id = 30171, chance = 80000 }, -- purple tendril lantern
	{ id = 30168, chance = 80000 }, -- ice shield
	{ id = 29427, chance = 80000 }, -- dark whispers
	{ id = 30343, chance = 80000 }, -- enchanted sleep shawl
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 30053, chance = 80000 }, -- dragon figurine
	{ id = 30054, chance = 80000 }, -- unicorn figurine
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 19400, chance = 80000 }, -- arcane staff
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 30059, chance = 80000 }, -- giant ruby
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -1000, maxDamage = -3500, target = true }, -- basic attack (1000-3500)
	{ name = "death beam", interval = 2000, chance = 25, minDamage = -1000, maxDamage = -2100, target = false }, -- -_death_beam(1000-2100)
	{ name = "big death wave", interval = 2000, chance = 25, minDamage = -1000, maxDamage = -2000, target = false }, -- -_death_wave(1000-2000)
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1000, radius = 5, effect = CONST_ME_MORTAREA, target = false }, -- -_great_death_bomb(700-1000)
}

monster.defenses = {
	defense = 160,
	armor = 160,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
