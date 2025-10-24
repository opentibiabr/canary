local mType = Game.createMonsterType("Quara Constrictor Scout")
local monster = {}

monster.description = "a quara constrictor scout"
monster.experience = 200
monster.outfit = {
	lookType = 46,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 240
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Malada, Arena Quarter, Treasure Island Eastern Caves, \z
		Hrodmir Quara Scout Caves, Quara Grotto, Oramond.",
}

monster.health = 450
monster.maxHealth = 450
monster.race = "blood"
monster.corpse = 6065
monster.speed = 75
monster.manaCost = 600

monster.changeTarget = {
	interval = 4000,
	chance = 5,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 45,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Tssss!", yell = false },
	{ text = "Gaaahhh!", yell = false },
	{ text = "Gluh! Gluh!", yell = false },
	{ text = "Boohaa!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 69075, maxCount = 49 }, -- Gold Coin
	{ id = 3285, chance = 6830 }, -- Longsword
	{ id = 3581, chance = 10030, maxCount = 3 }, -- Shrimp
	{ id = 11487, chance = 11607 }, -- Quara Tentacle
	{ id = 3033, chance = 1524 }, -- Small Amethyst
	{ id = 3359, chance = 2829 }, -- Brass Armor
	{ id = 5895, chance = 580 }, -- Fish Fin
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -135, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -80, radius = 3, effect = CONST_ME_HITAREA, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 14,
	mitigation = 0.86,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
