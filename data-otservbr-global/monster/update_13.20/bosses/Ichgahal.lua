local mType = Game.createMonsterType("Ichgahal")
local monster = {}

monster.description = "Ichgahal"
monster.experience = 3250000
monster.outfit = {
	lookType = 1665,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.bosstiary = {
	bossRaceId = 2364,
	bossRace = RARITY_ARCHFOE
}

monster.health = 480000
monster.maxHealth = 480000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 44018
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
	{text = "Rott!", yell = false},
	{text = "Putrefy!", yell = false},
	{text = "Decay!", yell = false}
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
	{ name = "crystal coin", chance = 9573, maxCount = 115 },
	{ name = "ultimate spirit potion", chance = 5094, maxCount = 153 },
	{ name = "mastermind potion", chance = 6589, maxCount = 45 },
	{ name = "yellow gem", chance = 14663, maxCount = 5 },
	{ name = "amber with a bug", chance = 10093, maxCount = 2 },
	{ name = "ultimate mana potion", chance = 9622, maxCount = 179 },
	{ name = "violet gem", chance = 6119, maxCount = 4 },
	{ name = "raw watermelon tourmaline", chance = 9046, maxCount = 2 },
	{ id = 3039, chance = 11248, maxCount = 1 }, -- red gem
	{ name = "supreme health potion", chance = 13945, maxCount = 37 },
	{ name = "berserk potion", chance = 5564, maxCount = 45 },
	{ name = "amber with a dragonfly", chance = 7543, maxCount = 1 },
	{ name = "gold ingot", chance = 10693, maxCount = 1 },
	{ name = "blue gem", chance = 13070, maxCount = 1 },
	{ name = "bullseye potion", chance = 9155, maxCount = 36 },
	{ name = "putrefactive figurine", chance = 13208, maxCount = 1 },
	{ name = "ichgahal's fungal infestation", chance = 7123, maxCount = 1 },
	{ name = "white gem", chance = 12796, maxCount = 3 },
}

mType:register(monster)
