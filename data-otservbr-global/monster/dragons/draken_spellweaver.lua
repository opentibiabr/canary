local mType = Game.createMonsterType("Draken Spellweaver")
local monster = {}

monster.description = "a draken spellweaver"
monster.experience = 3100
monster.outfit = {
	lookType = 340,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 618
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Zao Palace, Razachai, and Zzaion.",
}

monster.health = 5000
monster.maxHealth = 5000
monster.race = "blood"
monster.corpse = 10399
monster.speed = 168
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
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
	{ text = "Zzzzzooom!", yell = false },
	{ text = "Fissziss!", yell = false },
	{ text = "Kazzzzzzuuum!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 97266, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 11021, maxCount = 5 }, -- Platinum Coin
	{ id = 3577, chance = 29971 }, -- Meat
	{ id = 3030, chance = 2263, maxCount = 5 }, -- Small Ruby
	{ id = 10397, chance = 15190 }, -- Weaver's Wandtip
	{ id = 238, chance = 2104 }, -- Great Mana Potion
	{ id = 3071, chance = 1645 }, -- Wand of Inferno
	{ id = 8043, chance = 875 }, -- Focus Cape
	{ id = 10386, chance = 2165 }, -- Zaoan Shoes
	{ id = 11454, chance = 2020 }, -- Luminous Orb
	{ id = 11658, chance = 3950 }, -- Draken Sulphur
	{ id = 3038, chance = 1000 }, -- Green Gem
	{ id = 10387, chance = 823 }, -- Zaoan Legs
	{ id = 10438, chance = 778 }, -- Spellweaver's Robe
	{ id = 10439, chance = 785 }, -- Zaoan Robe
	{ id = 12549, chance = 68 }, -- Bamboo Leaves
	{ id = 3006, chance = 372 }, -- Ring of the Sky
	{ id = 10398, chance = 16 }, -- Draken Trophy
	{ id = 12307, chance = 19 }, -- Harness
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -252 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -240, maxDamage = -480, length = 4, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -250, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -150, maxDamage = -300, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -380, radius = 4, effect = CONST_ME_POFF, target = true },
	{ name = "soulfire rune", interval = 2000, chance = 10, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -280, maxDamage = -360, shootEffect = CONST_ANI_POISON, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 1.35,
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_RED },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 270, maxDamage = 530, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 80 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
