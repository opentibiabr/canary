local mType = Game.createMonsterType("Knowledge Elemental")
local monster = {}

monster.description = "a knowledge elemental"
monster.experience = 10603
monster.outfit = {
	lookType = 1065,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1670
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Secret Library energy section.",
}

monster.health = 10500
monster.maxHealth = 10500
monster.race = "undead"
monster.corpse = 28605
monster.speed = 230
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
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 71,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Did you know... there are over 200 bones in your body to break?", yell = false },
	{ text = "Did you know... a lot of so-called trivia facts aren't even remotely true?", yell = false },
	{ text = "Did you know... fear can be smelled?", yell = false },
	{ text = "Did you know... you could die in 1.299.223 ways within the next ten seconds?", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 15 }, -- platinum coin
	{ id = 28566, chance = 80000 }, -- silken bookmark
	{ id = 28569, chance = 80000, maxCount = 5 }, -- book page
	{ id = 28570, chance = 80000, maxCount = 10 }, -- glowing rune
	{ id = 3033, chance = 80000, maxCount = 6 }, -- small amethyst
	{ id = 28567, chance = 23000 }, -- quill
	{ id = 3051, chance = 23000 }, -- energy ring
	{ id = 761, chance = 23000, maxCount = 15 }, -- flash arrow
	{ id = 3415, chance = 23000 }, -- guardian shield
	{ id = 268, chance = 23000 }, -- mana potion
	{ id = 3287, chance = 23000, maxCount = 15 }, -- throwing star
	{ id = 7449, chance = 23000 }, -- crystal sword
	{ id = 7643, chance = 23000, maxCount = 2 }, -- ultimate health potion
	{ id = 3073, chance = 5000 }, -- wand of cosmic energy
	{ id = 23373, chance = 5000 }, -- ultimate mana potion
	{ id = 16096, chance = 5000 }, -- wand of defiance
	{ id = 3313, chance = 5000 }, -- obsidian lance
	{ id = 3054, chance = 5000 }, -- silver amulet
	{ id = 6093, chance = 5000 }, -- crystal ring
	{ id = 816, chance = 5000 }, -- lightning pendant
	{ id = 3048, chance = 1000 }, -- might ring
	{ id = 10438, chance = 260 }, -- spellweavers robe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -200, maxDamage = -680, radius = 3, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -680, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
}

monster.defenses = {
	defense = 33,
	armor = 76,
	mitigation = 2.08,
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = 100, maxDamage = 300, radius = 3, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 200, chance = 55, type = COMBAT_PHYSICALDAMAGE, minDamage = 100, maxDamage = 300, radius = 3, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
