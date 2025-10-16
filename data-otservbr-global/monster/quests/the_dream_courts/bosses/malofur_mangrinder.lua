local mType = Game.createMonsterType("Malofur Mangrinder")
local monster = {}

monster.description = "Malofur Mangrinder"
monster.experience = 55000
monster.outfit = {
	lookType = 1120,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "blood"
monster.corpse = 30017
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
	bossRaceId = 1696,
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
	{ text = "RAAAARGH! I'M MASHING YE TO DUST BOOM!", yell = true },
	{ text = "BOOOM!", yell = true },
	{ text = "BOOOOM!!!", yell = true },
	{ text = "BOOOOOM!!!", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 23374, chance = 80000, maxCount = 6 }, -- ultimate spirit potion
	{ id = 23373, chance = 80000, maxCount = 14 }, -- ultimate mana potion
	{ id = 23375, chance = 80000, maxCount = 6 }, -- supreme health potion
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 2995, chance = 80000 }, -- piggy bank
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 23535, chance = 80000 }, -- energy bar
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 22516, chance = 80000, maxCount = 2 }, -- silver token
	{ id = 22721, chance = 80000, maxCount = 2 }, -- gold token
	{ id = 30055, chance = 80000 }, -- crunor idol
	{ id = 29419, chance = 80000 }, -- resizer
	{ id = 29420, chance = 80000 }, -- shoulder plate
	{ id = 30088, chance = 80000 }, -- malofurs lunchbox
	{ id = 30169, chance = 80000 }, -- pomegranate
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 25759, chance = 80000 }, -- royal star
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 7414, chance = 80000 }, -- abyss hammer
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 19400, chance = 80000 }, -- arcane staff
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 5809, chance = 80000 }, -- soul stone
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 30060, chance = 80000 }, -- giant emerald
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -2500, target = true }, -- basic attack
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -5500, effect = CONST_ME_GROUNDSHAKER, radius = 4, target = false }, -- groundshaker
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
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
