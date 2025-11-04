local mType = Game.createMonsterType("Deepworm")
local monster = {}

monster.description = "a deepworm"
monster.experience = 2520
monster.outfit = {
	lookType = 1033,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"WarzoneWormDeath",
}

monster.raceId = 1531
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Gnome Deep Hub",
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 27545
monster.speed = 102
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 10,
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
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 27594, chance = 24082 }, -- Deepworm Jaws
	{ id = 3727, chance = 23041 }, -- Wood Mushroom
	{ id = 3577, chance = 19323 }, -- Meat
	{ id = 3582, chance = 19156 }, -- Ham
	{ id = 3732, chance = 18262 }, -- Green Mushroom
	{ id = 3728, chance = 14112 }, -- Dark Mushroom
	{ id = 27593, chance = 12735 }, -- Deepworm Spike Roots
	{ id = 27592, chance = 10833 }, -- Deepworm Spikes
	{ id = 3052, chance = 8291 }, -- Life Ring
	{ id = 16121, chance = 5993 }, -- Green Crystal Shard
	{ id = 814, chance = 5186 }, -- Terra Amulet
	{ id = 678, chance = 3903 }, -- Small Enchanted Amethyst
	{ id = 9302, chance = 2321 }, -- Sacred Tree Amulet
	{ id = 8084, chance = 1361 }, -- Springsprout Rod
	{ id = 27653, chance = 1473 }, -- Suspicious Device
	{ id = 282, chance = 1185 }, -- Giant Shimmering Pearl (Brown)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -190, maxDamage = -300, range = 7, length = 6, spread = 2, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -400, length = 3, spread = 3, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 5,
	armor = 73,
	mitigation = 1.88,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
