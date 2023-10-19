local mType = Game.createMonsterType("Chagorz")
local monster = {}

monster.description = "Chagorz"
monster.experience = 3250000
monster.outfit = {
	lookType = 1670,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.bosstiary = {
	bossRaceId = 2366,
	bossRace = RARITY_ARCHFOE
}

monster.health = 480000
monster.maxHealth = 480000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 44024
monster.speed = 222
monster.summonCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
}

monster.flags = {
	attackable = true,
	hostile = true,
	summonable = false,
	convinceable = false,
	illusionable = false,
	boss = true,
	ignoreSpawnBlock = false,
	pushable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "The light... that... drains!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.loot = {
	{ name = "crystal coin", chance = 6520, maxCount = 108 },
	{ name = "mastermind potion", chance = 7024, maxCount = 28 },
	{ name = "supreme health potion", chance = 10467, maxCount = 154 },
	{ name = "giant sapphire", chance = 11598, maxCount = 1 },
	{ name = "ultimate mana potion", chance = 11131, maxCount = 107 },
	{ name = "violet gem", chance = 12954, maxCount = 4 },
	{ id = 3039, chance = 10080, maxCount = 1 }, -- red gem
	{ name = "yellow gem", chance = 7133, maxCount = 1 },
	{ name = "blue gem", chance = 9319, maxCount = 3 },
	{ name = "bullseye potion", chance = 8293, maxCount = 21 },
	{ name = "giant amethyst", chance = 11485, maxCount = 1 },
	{ name = "giant topaz", chance = 14053, maxCount = 1 },
	{ name = "green gem", chance = 9242, maxCount = 1 },
	{ name = "ultimate spirit potion", chance = 9102, maxCount = 18 },
	{ name = "white gem", chance = 11346, maxCount = 3 },
}

mType:register(monster)
