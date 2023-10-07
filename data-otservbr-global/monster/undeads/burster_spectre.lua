local mType = Game.createMonsterType("Burster Spectre")
local monster = {}

monster.description = "a burster spectre"
monster.experience = 6000
monster.outfit = {
	lookType = 1122,
	lookHead = 9,
	lookBody = 10,
	lookLegs = 86,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1726
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Haunted Tomb west of Darashia, Buried Cathedral.",
}

monster.health = 6500
monster.maxHealth = 6500
monster.race = "blood"
monster.corpse = 30163
monster.speed = 200
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
	{ text = "We came tooo thiiiiss wooorld to... get youuu!", yell = false },
	{ text = "WuuuuAhhhhh!!!", yell = false },
}

monster.loot = {
	{ name = "platinum coin", chance = 75000, maxCount = 7 },
	{ name = "great spirit potion", chance = 22000, maxCount = 3 },
	{ name = "protection amulet", chance = 7350 },
	{ name = "life crystal", chance = 9300 },
	{ name = "wand of voodoo", chance = 4930 },
	{ name = "wand of cosmic energy", chance = 4000 },
	{ name = "dragon necklace", chance = 2580 },
	{ name = "stone skin amulet", chance = 2200 },
	{ id = 30082, chance = 1830 }, -- blue ectoplasm
	{ name = "glacier amulet", chance = 2130 },
	{ name = "orb", chance = 1290 },
	{ name = "hailstorm rod", chance = 900 },
	{ name = "elven amulet", chance = 500 },
	{ name = "garlic necklace", chance = 400 },
	{ name = "platinum amulet", chance = 1490 },
	{ name = "mind stone", chance = 150 },
	{ name = "glacial rod", chance = 560 },
	{ name = "shockwave amulet", chance = 360 },
	{ name = "strange symbol", chance = 110 },
	{ name = "hexagonal ruby", chance = 640 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2700, chance = 25, type = COMBAT_ICEDAMAGE, minDamage = -250, maxDamage = -400, radius = 1, range = 5, effect = CONST_ME_ICEAREA, target = true }, --ice box
	{ name = "combat", interval = 3500, chance = 25, type = COMBAT_ICEDAMAGE, minDamage = -300, maxDamage = -400, radius = 5, range = 5, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true }, --ava
	{ name = "combat", interval = 3900, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -300, maxDamage = -400, range = 5, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true }, -- icicle
	{ name = "combat", interval = 4400, chance = 27, type = COMBAT_ICEDAMAGE, minDamage = -300, maxDamage = -450, length = 4, spread = 2, effect = CONST_ME_ICEATTACK, target = false }, -- wave
	{ name = "combat", interval = 5500, chance = 47, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -400, radius = 3, effect = CONST_ME_BLUE_ENERGY_SPARK, target = false }, -- life drain bomb
}

monster.defenses = {
	defense = 70,
	armor = 70,
	mitigation = 2.11,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.reflects = {
	{ type = COMBAT_ICEDAMAGE, percent = 166 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 70 },
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
