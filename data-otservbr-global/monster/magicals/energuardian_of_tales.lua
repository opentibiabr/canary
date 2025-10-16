local mType = Game.createMonsterType("Energuardian of Tales")
local monster = {}

monster.description = "an energuardian of tales"
monster.experience = 11361
monster.outfit = {
	lookType = 1063,
	lookHead = 86,
	lookBody = 85,
	lookLegs = 82,
	lookFeet = 93,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1666
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "The Secret Library (energy section).",
}

monster.health = 14000
monster.maxHealth = 14000
monster.race = "undead"
monster.corpse = 28873
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Die, enervating mortal!", yell = false },
	{ text = "Let the energy flow!", yell = false },
}

monster.loot = {
	{ id = 28569, chance = 80000, maxCount = 6 }, -- book page
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 28570, chance = 23000, maxCount = 4 }, -- glowing rune
	{ id = 761, chance = 23000, maxCount = 15 }, -- flash arrow
	{ id = 822, chance = 23000 }, -- lightning legs
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 23373, chance = 23000 }, -- ultimate mana potion
	{ id = 8092, chance = 23000 }, -- wand of starstorm
	{ id = 8073, chance = 23000 }, -- spellbook of warding
	{ id = 816, chance = 5000, maxCount = 2 }, -- lightning pendant
	{ id = 3048, chance = 5000 }, -- might ring
	{ id = 3055, chance = 5000 }, -- platinum amulet
	{ id = 16096, chance = 1000 }, -- wand of defiance
	{ id = 10438, chance = 1000 }, -- spellweavers robe
	{ id = 9304, chance = 1000 }, -- shockwave amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -10, maxDamage = -550 },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -555, radius = 3, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 77,
	mitigation = 1.94,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = -12 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
