local mType = Game.createMonsterType("Blightwalker")
local monster = {}

monster.description = "a blightwalker"
monster.experience = 6400
monster.outfit = {
	lookType = 246,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 298
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, Edron (In the Vats during The Inquisition Quest), Roshamuul Prison, Grounds of Undeath.",
}

monster.health = 8100
monster.maxHealth = 8100
monster.race = "undead"
monster.corpse = 6353
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	runHealth = 800,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "I can see you decaying!", yell = false },
	{ text = "Let me taste your mortality!", yell = false },
	{ text = "Your lifeforce is waning!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 195 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 3605, chance = 51000 }, -- Bunch of Wheat
	{ id = 6499, chance = 30000 }, -- Demonic Essence
	{ id = 238, chance = 29000, maxCount = 3 }, -- Great Mana Potion
	{ id = 5944, chance = 26000 }, -- Soul Orb
	{ id = 3147, chance = 24000, maxCount = 2 }, -- Blank Rune
	{ id = 7643, chance = 15500, maxCount = 2 }, -- Ultimate Health Potion
	{ id = 9688, chance = 15300 }, -- Bundle of Cursed Straw
	{ id = 3067, chance = 9600 }, -- Hailstorm Rod
	{ id = 7368, chance = 7800, maxCount = 10 }, -- Assassin Star
	{ id = 9058, chance = 5500 }, -- Gold Ingot
	{ id = 281, chance = 4900 }, -- Giant Shimmering Pearl (Green)
	{ id = 647, chance = 4000 }, -- Seeds
	{ id = 812, chance = 3200 }, -- Terra Legs
	{ id = 3453, chance = 3000 }, -- Scythe
	{ id = 3324, chance = 2200 }, -- Skull Staff
	{ id = 3083, chance = 1900 }, -- Garlic Necklace
	{ id = 3063, chance = 1500 }, -- Gold Ring
	{ id = 6299, chance = 1400 }, -- Death Ring
	{ id = 811, chance = 850 }, -- Terra Mantle
	{ id = 3081, chance = 500 }, -- Stone Skin Amulet
	{ id = 3057, chance = 300 }, -- Amulet of Loss
	{ id = 3306, chance = 190 }, -- Golden Sickle
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -490 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -220, maxDamage = -405, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -65, maxDamage = -135, radius = 4, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "blightwalker curse", interval = 2000, chance = 15, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -300, range = 7, shootEffect = CONST_ANI_POISON, target = true, duration = 15000 },
}

monster.defenses = {
	defense = 50,
	armor = 63,
	mitigation = 1.18,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
