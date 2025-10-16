local mType = Game.createMonsterType("Phantasm")
local monster = {}

monster.description = "a Phantasm"
monster.experience = 4400
monster.outfit = {
	lookType = 241,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 292
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, The Inquisition Quest, Deeper Banuta.",
}

monster.health = 3950
monster.maxHealth = 3950
monster.race = "undead"
monster.corpse = 6343
monster.speed = 170
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 350,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 3,
	color = 203,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Phantasm Summon", chance = 35, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Oh my, you forgot to put your pants on!", yell = false },
	{ text = "Weeheeheeheehee!", yell = false },
	{ text = "Its nothing but a dream.", yell = false },
	{ text = "Dream a little dream with me!", yell = false },
	{ text = "Give in.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 238 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 4 }, -- platinum coin
	{ id = 3147, chance = 80000, maxCount = 2 }, -- blank rune
	{ id = 238, chance = 80000, maxCount = 2 }, -- great mana potion
	{ id = 3740, chance = 80000 }, -- shadow herb
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 3033, chance = 23000, maxCount = 3 }, -- small amethyst
	{ id = 3032, chance = 23000, maxCount = 3 }, -- small emerald
	{ id = 3030, chance = 23000, maxCount = 3 }, -- small ruby
	{ id = 9057, chance = 23000, maxCount = 3 }, -- small topaz
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 7451, chance = 1000 }, -- shadow sceptre
	{ id = 3049, chance = 1000 }, -- stealth ring
	{ id = 3381, chance = 1000 }, -- crown armor
	{ id = 6299, chance = 1000 }, -- death ring
	{ id = 7414, chance = 260 }, -- abyss hammer
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -475 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -610, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -5, maxDamage = -80, radius = 3, effect = CONST_ME_YELLOW_RINGS, target = false },
	{ name = "phantasm drown", interval = 2000, chance = 15, target = false },
	{ name = "drunk", interval = 2000, chance = 15, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.defenses = {
	defense = 0,
	armor = 80,
	mitigation = 1.10,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 228, maxDamage = 449, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = 500, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
	{ name = "invisible", interval = 2000, chance = 25, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
