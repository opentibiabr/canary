local mType = Game.createMonsterType("The Percht Queen")
local monster = {}

monster.description = "The Percht Queen"
monster.experience = 500
monster.outfit = {
	lookTypeEx = 30340, -- (frozen) // lookTypeEx = 30341 (thawed)
}

monster.bosstiary = {
	bossRaceId = 1744,
	bossRace = RARITY_NEMESIS,
}

monster.health = 2300
monster.maxHealth = 2300
monster.race = "undead"
monster.corpse = 30272
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
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
	{ id = 7414, chance = 80000 }, -- abyss hammer
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 25759, chance = 80000, maxCount = 100 }, -- royal star
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 23374, chance = 80000, maxCount = 20 }, -- ultimate spirit potion
	{ id = 23373, chance = 80000, maxCount = 20 }, -- ultimate mana potion
	{ id = 23375, chance = 80000, maxCount = 20 }, -- supreme health potion
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 2995, chance = 80000 }, -- piggy bank
	{ id = 23535, chance = 80000 }, -- energy bar
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3043, chance = 80000, maxCount = 2 }, -- crystal coin
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 7439, chance = 80000, maxCount = 10 }, -- berserk potion
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 5809, chance = 80000 }, -- soul stone
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 30195, chance = 80000 }, -- golden bell
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 30320, chance = 80000 }, -- lucky pig
	{ id = 30283, chance = 80000 }, -- ice hatchet
	{ id = 30281, chance = 80000 }, -- frozen chain
	{ id = 30322, chance = 80000 }, -- small ladybug
	{ id = 30318, chance = 80000 }, -- horseshoe
	{ id = 30319, chance = 80000 }, -- golden horseshoe
	{ id = 30285, chance = 80000 }, -- golden cotton reel
	{ id = 30279, chance = 80000 }, -- frozen claw
	{ id = 30282, chance = 80000 }, -- percht broom
	{ id = 30284, chance = 80000 }, -- percht handkerchief
	{ id = 30280, chance = 80000 }, -- percht queens frozen heart
	{ id = 30278, chance = 80000 }, -- flames of the percht queen
	{ id = 30192, chance = 80000 }, -- percht skull
	{ id = 19400, chance = 80000 }, -- arcane staff
	{ id = 2958, chance = 80000 }, -- war horn
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -200, range = 7, shootEffect = CONST_ANI_ICE, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 79,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 90 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 80 },
	{ type = COMBAT_DEATHDAMAGE, percent = 90 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
