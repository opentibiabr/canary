local mType = Game.createMonsterType("Diremaw")
local monster = {}

monster.description = "a diremaw"
monster.experience = 2770
monster.outfit = {
	lookType = 1034,
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

monster.raceId = 1532
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Gnome Deep Hub north and south tasking areas, Warzone 6",
}

monster.health = 3600
monster.maxHealth = 3600
monster.race = "blood"
monster.corpse = 27494
monster.speed = 150
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
}

monster.loot = {
	{ id = 3582, chance = 41068 }, -- Ham
	{ id = 27597, chance = 23977 }, -- Diremaw Brainpan
	{ id = 9640, chance = 18367 }, -- Poisonous Slime
	{ id = 16119, chance = 10658 }, -- Blue Crystal Shard
	{ id = 16120, chance = 7594 }, -- Violet Crystal Shard
	{ id = 16121, chance = 9192 }, -- Green Crystal Shard
	{ id = 22193, chance = 9269 }, -- Onyx Chip
	{ id = 27598, chance = 9558 }, -- Diremaw Legs
	{ id = 281, chance = 3194 }, -- Giant Shimmering Pearl (Green)
	{ id = 677, chance = 4780 }, -- Small Enchanted Emerald
	{ id = 3032, chance = 6418 }, -- Small Emerald
	{ id = 9058, chance = 3704 }, -- Gold Ingot
	{ id = 27653, chance = 624 }, -- Suspicious Device
	{ id = 16099, chance = 155 }, -- Mushroom Backpack
	{ id = 16164, chance = 242 }, -- Mycological Bow
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -200, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -250, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POFF, target = true },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 21, minDamage = -200, maxDamage = -310, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 5,
	armor = 71,
	mitigation = 1.94,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
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
