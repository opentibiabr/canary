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
	{ id = 23544, chance = 22220 }, -- collar of red plasma
	{ id = 23529, chance = 13890 }, --  ring of blue plasma
	{ id = 23531, chance = 8330 }, -- ring of green plasma
	{ id = 23542, chance = 8330 }, -- collar of blue plasma
	{ id = 23543, chance = 16670 }, -- collar of green plasma
	{ id = 3039, chance = 47220 }, -- red gem
	{ name = "berserk potion", chance = 20000 },
	{ name = "blue gem", chance = 20000 },
	{ name = "bullseye potion", chance = 20000 },
	{ name = "chaos mace", chance = 8330 },
	{ name = "crystal coin", chance = 25000, maxCount = 2 },
	{ name = "energy bar", chance = 88890 },
	{ id = 282, chance = 8330 }, -- giant shimmering pearl
	{ name = "gold ingot", chance = 22220 },
	{ name = "gold token", chance = 60000, maxCount = 3 },
	{ name = "green gem", chance = 11110 },
	{ name = "huge chunk of crude iron", chance = 40000 },
	{ name = "magic sulphur", chance = 5560 },
	{ name = "mastermind potion", chance = 22220 },
	{ name = "mysterious remains", chance = 88890 },
	{ name = "piggy bank", chance = 97220 },
	{ name = "platinum coin", chance = 100000, maxCount = 8 },
	{ name = "pomegranate", chance = 16670 },
	{ name = "resizer", chance = 2780 },
	{ id = 23533, chance = 5560 }, -- ring of red plasma
	{ name = "ring of the sky", chance = 2780 },
	{ name = "royal star", chance = 52780 },
	{ name = "silver token", chance = 91670, maxCount = 3 },
	{ name = "skull staff", chance = 8330 },
	{ name = "soul stone", chance = 8330 },
	{ name = "supreme health potion", chance = 80000, maxCount = 29 },
	{ name = "ultimate mana potion", chance = 55560, maxCount = 20 },
	{ name = "ultimate spirit potion", chance = 80000, maxCount = 13 },
	{ name = "violet gem", chance = 8330 },
	{ name = "yellow gem", chance = 44440, maxCount = 2 },
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
