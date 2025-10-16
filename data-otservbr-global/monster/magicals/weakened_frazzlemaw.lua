local mType = Game.createMonsterType("Weakened Frazzlemaw")
local monster = {}

monster.description = "a weakened frazzlemaw"
monster.experience = 1000
monster.outfit = {
	lookType = 594,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ThreatenedDreamsNightmareMonstersDeath",
}

monster.raceId = 1442
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Feyrist.",
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 20233
monster.speed = 150
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
	{ text = "Mwaaahgod! Overmwaaaaah! *gurgle*", yell = false },
	{ text = "Mwaaaahnducate youuuuuu *gurgle*, mwaaah!", yell = false },
	{ text = "MMMWAHMWAHMWAHMWAAAAH!", yell = true },
	{ text = "Mmmwhamwhamwhah, mwaaah!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 20199, chance = 23000 }, -- frazzle skin
	{ id = 7573, chance = 23000 }, -- bone
	{ id = 25694, chance = 23000 }, -- fairy wings
	{ id = 238, chance = 23000, maxCount = 3 }, -- great mana potion
	{ id = 3125, chance = 23000 }, -- remains of a fish
	{ id = 20198, chance = 23000 }, -- frazzle tongue
	{ id = 7885, chance = 23000, maxCount = 3 }, -- fish
	{ id = 239, chance = 23000, maxCount = 2 }, -- great health potion
	{ id = 3582, chance = 23000, maxCount = 2 }, -- ham
	{ id = 3116, chance = 5000 }, -- big bone
	{ id = 3110, chance = 5000 }, -- piece of iron
	{ id = 5895, chance = 5000 }, -- fish fin
	{ id = 5880, chance = 5000 }, -- iron ore
	{ id = 10389, chance = 260 }, -- sai
	{ id = 7418, chance = 260 }, -- nightmare blade
	{ id = 20062, chance = 260 }, -- cluster of solace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 80 },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 10, minDamage = -80, maxDamage = -200, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, length = 5, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -80, maxDamage = -50, radius = 4, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 45,
	mitigation = 1.37,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 80, maxDamage = 225, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
