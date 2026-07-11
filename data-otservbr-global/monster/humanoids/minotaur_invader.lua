local mType = Game.createMonsterType("Minotaur Invader")
local monster = {}

monster.description = "a minotaur invader"
monster.experience = 1600
monster.outfit = {
	lookType = 29,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1109
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Second floor Glooth Underground Factory, east side during the Oramond Minotaurs raid.",
}

monster.health = 1850
monster.maxHealth = 1850
monster.race = "blood"
monster.corpse = 5983
monster.speed = 120
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
	canWalkOnFire = false,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "For the victory!", yell = false },
	{ text = "We will crush the enemy!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 50000, maxCount = 4 }, -- Platinum Coin
	{ id = 11482, chance = 15000 }, -- Piece of Warrior Armor
	{ id = 9057, chance = 10300, maxCount = 2 }, -- Small Topaz
	{ id = 11472, chance = 8100, maxCount = 2 }, -- Minotaur Horn
	{ id = 3033, chance = 5200 }, -- Small Amethyst
	{ id = 5878, chance = 5100 }, -- Minotaur Leather
	{ id = 3030, chance = 4700 }, -- Small Ruby
	{ id = 21166, chance = 910 }, -- Mooh'tah Plate
	{ id = 5912, chance = 860 }, -- Blue Piece of Cloth
	{ id = 3415, chance = 770 }, -- Guardian Shield
	{ id = 3039, chance = 740 }, -- Red Gem
	{ id = 5911, chance = 620 }, -- Red Piece of Cloth
	{ id = 3318, chance = 590 }, -- Knight Axe
	{ id = 3369, chance = 550 }, -- Warrior Helmet
	{ id = 7413, chance = 220 }, -- Titan Axe
	{ id = 7401, chance = 220 }, -- Minotaur Trophy
	{ id = 3041, chance = 160 }, -- Blue Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
}

monster.defenses = {
	defense = 20,
	armor = 40,
	mitigation = 1.76,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
