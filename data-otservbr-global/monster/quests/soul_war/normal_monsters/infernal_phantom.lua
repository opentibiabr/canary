local mType = Game.createMonsterType("Infernal Phantom")
local monster = {}

monster.description = "an infernal phantom"
monster.experience = 15770
monster.outfit = {
	lookType = 1298,
	lookHead = 114,
	lookBody = 80,
	lookLegs = 94,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1933
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Claustrophobic Inferno.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 26000
monster.maxHealth = 26000
monster.race = "undead"
monster.corpse = 34125
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{ text = "Ashes to ashes.", yell = false },
	{ text = "Burn, baby! Burn!", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 3065, chance = 80000 }, -- terra rod
	{ id = 3067, chance = 23000 }, -- hailstorm rod
	{ id = 7643, chance = 23000, maxCount = 2 }, -- ultimate health potion
	{ id = 3320, chance = 5000 }, -- fire axe
	{ id = 3333, chance = 5000 }, -- crystal mace
	{ id = 3342, chance = 5000 }, -- war axe
	{ id = 7413, chance = 5000 }, -- titan axe
	{ id = 7427, chance = 5000 }, -- chaos mace
	{ id = 7454, chance = 5000 }, -- glorious axe
	{ id = 8082, chance = 5000 }, -- underworld rod
	{ id = 8084, chance = 5000 }, -- springsprout rod
	{ id = 8092, chance = 5000 }, -- wand of starstorm
	{ id = 8094, chance = 5000 }, -- wand of voodoo
	{ id = 14040, chance = 5000 }, -- warriors axe
	{ id = 34139, chance = 5000 }, -- infernal heart
	{ id = 34146, chance = 5000 }, -- infernal robe
	{ id = 3081, chance = 5000 }, -- stone skin amulet
	{ id = 34109, chance = 260 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -950, maxDamage = -1300, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "extended fire chain", interval = 2000, chance = 15, minDamage = -700, maxDamage = -900, range = 7 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -900, maxDamage = -1350, radius = 4, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -980, maxDamage = -1250, length = 6, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 3000, chance = 24, type = COMBAT_DEATHDAMAGE, minDamage = -850, maxDamage = -1200, range = 7, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 1 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
