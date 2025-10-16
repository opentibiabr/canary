local mType = Game.createMonsterType("Alptramun")
local monster = {}

monster.description = "Alptramun"
monster.experience = 55000
monster.outfit = {
	lookType = 1143,
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
monster.corpse = 30155
monster.speed = 125
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
	bossRaceId = 1698, -- or 1715 need test
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
	{ id = 23535, chance = 80000 }, -- energy bar
	{ id = 3035, chance = 80000, maxCount = 9 }, -- platinum coin
	{ id = 22516, chance = 80000, maxCount = 5 }, -- silver token
	{ id = 22721, chance = 80000, maxCount = 3 }, -- gold token
	{ id = 3043, chance = 80000, maxCount = 3 }, -- crystal coin
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 2995, chance = 80000 }, -- piggy bank
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 23374, chance = 80000, maxCount = 35 }, -- ultimate spirit potion
	{ id = 23375, chance = 80000, maxCount = 35 }, -- supreme health potion
	{ id = 23373, chance = 80000, maxCount = 35 }, -- ultimate mana potion
	{ id = 7439, chance = 80000, maxCount = 20 }, -- berserk potion
	{ id = 7443, chance = 80000, maxCount = 20 }, -- bullseye potion
	{ id = 7440, chance = 80000, maxCount = 20 }, -- mastermind potion
	{ id = 25759, chance = 80000, maxCount = 200 }, -- royal star
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 36706, chance = 80000, maxCount = 2 }, -- red gem
	{ id = 3037, chance = 80000, maxCount = 2 }, -- yellow gem
	{ id = 3041, chance = 80000, maxCount = 2 }, -- blue gem
	{ id = 3038, chance = 80000, maxCount = 2 }, -- green gem
	{ id = 3036, chance = 80000, maxCount = 2 }, -- violet gem
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 19400, chance = 80000 }, -- arcane staff
	{ id = 7414, chance = 80000 }, -- abyss hammer
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 5809, chance = 80000 }, -- soul stone
	{ id = 29424, chance = 80000 }, -- pair of dreamwalkers
	{ id = 29423, chance = 80000 }, -- dream shroud
	{ id = 29943, chance = 80000 }, -- alptramuns toothbrush
	{ id = 30055, chance = 80000 }, -- crunor idol
	{ id = 30169, chance = 80000 }, -- pomegranate
	{ id = 30171, chance = 80000 }, -- purple tendril lantern
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -1000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -2000, range = 7, length = 6, spread = 0, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -700, range = 3, length = 6, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -500, range = 3, length = 6, spread = 0, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "stone shower rune", interval = 2000, chance = 10, minDamage = -230, maxDamage = -450, range = 7, target = false },
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
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
