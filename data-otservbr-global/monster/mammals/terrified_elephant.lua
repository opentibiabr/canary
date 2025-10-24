local mType = Game.createMonsterType("Terrified Elephant")
local monster = {}

monster.description = "a terrified elephant"
monster.experience = 160
monster.outfit = {
	lookType = 211,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 771
monster.Bestiary = {
	class = "Mammal",

	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "East of Port Hope, close to the Deeper Banuta shortcut, Mapper Coords128.84127.16872texthere.",
}

monster.health = 320
monster.maxHealth = 320
monster.race = "blood"
monster.corpse = 6052
monster.speed = 105
monster.manaCost = 500

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
	convinceable = true,
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
	{ text = "Hooooot-Toooooot!", yell = false },
	{ text = "Tooooot!", yell = false },
	{ text = "Trooooot!", yell = false },
}

monster.loot = {
	{ id = 3582, chance = 29900, maxCount = 3 }, -- Ham
	{ id = 3577, chance = 40400, maxCount = 4 }, -- Meat
	{ id = 3044, chance = 7990, maxCount = 2 }, -- Tusk
	{ id = 3443, chance = 70 }, -- Tusk Shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
}

monster.defenses = {
	defense = 0,
	armor = 20,
	mitigation = 0.41,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 800, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
