local mType = Game.createMonsterType("Megasylvan Yselda")
local monster = {}

monster.description = "Megasylvan Yselda"
monster.experience = 19900
monster.outfit = {
	lookTypeEx = 36928,
}

monster.bosstiary = {
	bossRaceId = 2114,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 32000
monster.maxHealth = 32000
monster.race = "blood"
monster.corpse = 36929
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 70,
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

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "Carnisylvan Sapling", chance = 70, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "What are you... doing!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 100000, minCount = 1, maxCount = 9 }, -- platinum coin
	{ id = 8010, chance = 100000, minCount = 1, maxCount = 5 }, -- potato
	{ id = 23375, chance = 57140, minCount = 1, maxCount = 33 }, -- supreme health potion
	{ id = 23373, chance = 57140, minCount = 1, maxCount = 31 }, -- ultimate mana potion
	{ id = 23374, chance = 30000, minCount = 1, maxCount = 11 }, -- ultimate spirit potion
	{ id = 7443, chance = 22860, minCount = 4, maxCount = 19 }, -- bullseye potion
	{ id = 7439, chance = 21430, minCount = 1, maxCount = 16 }, -- berserk potion
	{ id = 3041, chance = 18570, count = 1 }, -- blue gem
	{ id = 7440, chance = 17140, minCount = 4, maxCount = 19 }, -- mastermind potion
	{ id = 3038, chance = 17140, minCount = 1, maxCount = 2 }, -- green gem
	{ id = 3036, chance = 15710, minCount = 1, maxCount = 2 }, -- violet gem
	{ id = 3039, chance = 14290, minCount = 1, maxCount = 2 }, -- red gem
	{ id = 30060, chance = 11430, count = 1 }, -- giant emerald
	{ id = 3037, chance = 10000, count = 1 }, -- yellow gem
	{ id = 3043, chance = 8570, count = 1 }, -- crystal coin
	{ id = 36809, chance = 4290 }, -- curl of hair
	{ id = 14112, chance = 4290 }, -- bar of gold
	{ id = 814, chance = 2860 }, -- terra amulet
	{ id = 3065, chance = 2860 }, -- terra rod
	{ id = 830, chance = 2860 }, -- terra hood
	{ id = 36811, chance = 1430 }, -- megasylvan sapling
	{ id = 36808, chance = 1430 }, -- old royal diary
	{ id = 812, chance = 1430 }, -- terra legs
	{ id = 811, chance = 1430 }, -- terra mantle
	{ id = 32623, chance = 1200, count = 1 }, -- giant topaz
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -270, maxDamage = -500 },
	{ name = "earth beamMY", interval = 2000, chance = 50, minDamage = -400, maxDamage = -900, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -800, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -800, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "mana leechMY", interval = 2000, chance = 50, minDamage = -100, maxDamage = -400, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 82,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 85 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 90 },
	{ type = COMBAT_FIREDAMAGE, percent = 60 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 90 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 70 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
