local mType = Game.createMonsterType("Murcion")
local monster = {}

monster.description = "Murcion"
monster.experience = 3250000
monster.outfit = {
	lookType = 1664,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.bosstiary = {
	bossRaceId = 2362,
	bossRace = RARITY_ARCHFOE
}

monster.health = 480000
monster.maxHealth = 480000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 44015
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
	{ name = "crystal coin", chance = 11268, maxCount = 91 },
	{ id = 3039, chance = 11685, maxCount = 2 }, -- red gem
	{ name = "amber with a bug", chance = 10202, maxCount = 1 },
	{ name = "amber with a dragonfly", chance = 9474, maxCount = 1 },
	{ name = "bullseye potion", chance = 12662, maxCount = 44 },
	{ name = "green gem", chance = 9150, maxCount = 4 },
	{ name = "mastermind potion", chance = 8073, maxCount = 15 },
	{ name = "supreme health potion", chance = 7410, maxCount = 102 },
	{ name = "ultimate mana potion", chance = 14663, maxCount = 29 },
	{ name = "ultimate spirit potion", chance = 13873, maxCount = 161 },
}

mType:register(monster)
