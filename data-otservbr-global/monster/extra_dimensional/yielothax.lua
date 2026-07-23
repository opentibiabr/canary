local mType = Game.createMonsterType("Yielothax")
local monster = {}

monster.description = "a yielothax"
monster.experience = 1250
monster.outfit = {
	lookType = 408,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"YielothaxDeath",
}

monster.raceId = 717
monster.Bestiary = {
	class = "Extra Dimensional",
	race = BESTY_RACE_EXTRA_DIMENSIONAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "In another dimension, through a portal in the Raging Mage tower, southern Zao.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "venom"
monster.corpse = 12595
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
	staticAttackChance = 75,
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
	{ text = "IIEEH!! Iiih iih ih iiih!!!", yell = true },
	{ text = "Bsssssssm Bssssssm Bsssssssssssm!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 226 }, -- Gold Coin
	{ id = 237, chance = 21000 }, -- Strong Mana Potion
	{ id = 236, chance = 20000 }, -- Strong Health Potion
	{ id = 3725, chance = 9900, maxCount = 3 }, -- Brown Mushroom
	{ id = 3028, chance = 5200, maxCount = 5 }, -- Small Diamond
	{ id = 3048, chance = 1500 }, -- Might Ring
	{ id = 3034, chance = 1000 }, -- Talon
	{ id = 816, chance = 670 }, -- Lightning Pendant
	{ id = 3326, chance = 570 }, -- Epee
	{ id = 822, chance = 520 }, -- Lightning Legs
	{ id = 7440, chance = 460 }, -- Mastermind Potion
	{ id = 3073, chance = 440 }, -- Wand of Cosmic Energy
	{ id = 12742, chance = 380 }, -- Yielowax
	{ id = 12805, chance = 360 }, -- Yielocks
	{ id = 12737, chance = 250 }, -- Broken Ring of Ending
	{ id = 9304, chance = 230 }, -- Shockwave Amulet
}

monster.attacks = {
	{ name = "melee", interval = 1000, chance = 100, minDamage = 0, maxDamage = -203 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -130, length = 4, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -250, radius = 3, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -70, maxDamage = -120, radius = 3, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -150, length = 4, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
