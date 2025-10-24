local mType = Game.createMonsterType("Quara Constrictor")
local monster = {}

monster.description = "a quara constrictor"
monster.experience = 380
monster.outfit = {
	lookType = 46,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 239
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Calassa, Frozen Trench underwater sites, Yalahar (Sunken Quarter).",
}

monster.health = 450
monster.maxHealth = 450
monster.race = "blood"
monster.corpse = 6065
monster.speed = 190
monster.manaCost = 0

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
	convinceable = false,
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
	{ text = "Boohaa!", yell = false },
	{ text = "Tssss!", yell = false },
	{ text = "Gluh! Gluh!", yell = false },
	{ text = "Gaaahhh!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 86325, maxCount = 100 }, -- Gold Coin
	{ id = 11487, chance = 13204 }, -- Quara Tentacle
	{ id = 3285, chance = 5102 }, -- Longsword
	{ id = 3581, chance = 4698, maxCount = 5 }, -- Shrimp
	{ id = 3359, chance = 2417 }, -- Brass Armor
	{ id = 3033, chance = 945 }, -- Small Amethyst
	{ id = 5895, chance = 582 }, -- Fish Fin
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150, effect = CONST_ME_DRAWBLOOD, condition = { type = CONDITION_POISON, totalDamage = 20, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -90, radius = 3, effect = CONST_ME_HITAREA, target = false },
	{ name = "quara constrictor freeze", interval = 2000, chance = 10, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -40, maxDamage = -70, range = 7, radius = 4, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "quara constrictor electrify", interval = 2000, chance = 10, range = 1, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 14,
	mitigation = 0.94,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
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
