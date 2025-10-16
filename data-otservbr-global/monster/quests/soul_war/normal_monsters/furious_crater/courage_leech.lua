local mType = Game.createMonsterType("Courage Leech")
local monster = {}

monster.description = "a courage leech"
monster.experience = 18900
monster.outfit = {
	lookType = 1315,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1941
monster.Bestiary = {
	class = "Extra Dimensional",
	race = BESTY_RACE_EXTRA_DIMENSIONAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Furious Crater",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 27000
monster.maxHealth = 27000
monster.race = "undead"
monster.corpse = 33909
monster.speed = 226
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	{ text = "Hiss.", yell = false },
	{ text = "Zap! Zap!", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 7643, chance = 23000, maxCount = 7 }, -- ultimate health potion
	{ id = 822, chance = 5000 }, -- lightning legs
	{ id = 816, chance = 5000 }, -- lightning pendant
	{ id = 828, chance = 5000 }, -- lightning headband
	{ id = 3063, chance = 5000 }, -- gold ring
	{ id = 7422, chance = 1000 }, -- jade hammer
	{ id = 3332, chance = 1000 }, -- hammer of wrath
	{ id = 7421, chance = 1000 }, -- onyx flail
	{ id = 11657, chance = 1000 }, -- twiceslicer
	{ id = 3081, chance = 1000 }, -- stone skin amulet
	{ id = 7382, chance = 1000 }, -- demonrage sword
	{ id = 7418, chance = 260 }, -- nightmare blade
	{ id = 7419, chance = 260 }, -- dreaded cleaver
	{ id = 7412, chance = 260 }, -- butchers axe
	{ id = 34109, chance = 260 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -700 },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_ENERGYDAMAGE, minDamage = -1100, maxDamage = -1400, radius = 4, shootEffect = CONST_ANI_ETHEREALSPEAR, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -1100, maxDamage = -1400, radius = 4, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -900, maxDamage = -1100, length = 7, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -1100, maxDamage = -1300, range = 7, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "energy chain", interval = 2000, chance = 20, minDamage = -900, maxDamage = -1000, range = 3, target = true },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 3.04,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = -25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
