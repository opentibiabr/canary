local mType = Game.createMonsterType("Iks Yapunac")
local monster = {}

monster.description = "an iks yapunac"
monster.experience = 3125
monster.outfit = {
	lookType = 1702,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2437
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 500,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Iksupan Waterways",
}

monster.health = 3125
monster.maxHealth = 3125
monster.race = "blood"
monster.corpse = 44447
monster.speed = 120
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
	{ text = "MIT-MAH!", yell = false },
	{ text = "Grrrmh...", yell = false },
	{ text = "CHAHAAAR!!!", yell = false },
}

monster.loot = {
	{ name = "platinum coin", chance = 100000, maxCount = 10 },
	{ name = "gold coin", chance = 100000, maxCount = 50 },
	{ id = 281, chance = 14830 }, -- giant shimmering pearl
	{ name = "great health potion", chance = 14530 },
	{ name = "tiger eye", chance = 4820 },
	{ name = "green crystal splinter", chance = 4190 },
	{ name = "brown crystal splinter", chance = 4160 },
	{ name = "opal", chance = 3450, maxCount = 2 },
	{ name = "gearwheel chain", chance = 3150 },
	{ name = "onyx chip", chance = 2490 },
	{ name = "ritual tooth", chance = 2410 },
	{ name = "spiked squelcher", chance = 1700 },
	{ id = 11514, chance = 1500 }, -- colorful feather
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250, effect = CONST_ME_PURPLEENERGY },
	{ name = "iksyapunacwave", interval = 2000, chance = 20, minDamage = -175, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_DEATHDAMAGE, minDamage = -140, maxDamage = -260, range = 5, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 45,
	armor = 45,
	mitigation = 2.02,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
