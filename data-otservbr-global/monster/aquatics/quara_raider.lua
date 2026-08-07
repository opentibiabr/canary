local mType = Game.createMonsterType("Quara Raider")
local monster = {}

monster.description = "a quara raider"
monster.experience = 8150
monster.outfit = {
	lookType = 1759,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2541
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Podzilla Bottom, Podzilla Underwater",
}

monster.health = 12500
monster.maxHealth = 12500
monster.race = "undead"
monster.corpse = 48393
monster.speed = 215
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 11,
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
	rewardBoss = false,
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
	{ text = "<blubber>", yell = false },
	{ text = "Gloh! Gloooh!", yell = false },
	{ text = "Boohacha!!!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 65000, maxCount = 25 }, -- Platinum Coin
	{ id = 48508, chance = 6900 }, -- Amber Souvenir
	{ id = 3039, chance = 5100 }, -- Red Gem
	{ id = 48509, chance = 3900 }, -- Resinous Fish Fin
	{ id = 3324, chance = 1500 }, -- Skull Staff
	{ id = 3041, chance = 1100 }, -- Blue Gem
	{ id = 824, chance = 810 }, -- Glacier Robe
	{ id = 11490, chance = 640 }, -- Quara Pincers
	{ id = 8050, chance = 490 }, -- Crystalline Armor
	{ id = 7414, chance = 150 }, -- Abyss Hammer
	{ id = 45654, chance = 60 }, -- Preserved Light Blue Seed
	{ id = 45655, chance = 45 }, -- Preserved Violet Seed
	{ id = 45656, chance = 30 }, -- Preserved Purple Seed
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -320 },
	{ name = "quaralargeicering", interval = 2000, chance = 20, minDamage = -1250, maxDamage = -1400, target = false },
	{ name = "quararaidershoot", interval = 2000, chance = 35, minDamage = -650, maxDamage = -900, range = 7, target = true },
	{ name = "quarawatersplash", interval = 2000, chance = 18, minDamage = -1350, maxDamage = -1600, target = false },
	{ name = "quaraseamonster", interval = 2000, chance = 18, minDamage = -1350, maxDamage = -1600, target = false },
}

monster.defenses = {
	defense = 95,
	armor = 95,
	mitigation = 2.75,
	{ name = "combat", interval = 2000, chance = 7, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
