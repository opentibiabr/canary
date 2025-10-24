local mType = Game.createMonsterType("Undead Prospector")
local monster = {}

monster.description = "an undead prospector"
monster.experience = 85
monster.outfit = {
	lookType = 18,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 595
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 1,
	Locations = "West of Edron, in a some Lost Mines.",
}

monster.health = 100
monster.maxHealth = 100
monster.race = "blood"
monster.corpse = 5976
monster.speed = 72
monster.manaCost = 440

monster.changeTarget = {
	interval = 4000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Our mine... leave us alone.", yell = false },
	{ text = "Turn back...", yell = false },
	{ text = "These mine is ours... you shall not pass.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 70681, maxCount = 30 }, -- Gold Coin
	{ id = 3492, chance = 80393, maxCount = 6 }, -- Worm
	{ id = 2920, chance = 61238 }, -- Torch
	{ id = 3354, chance = 18826 }, -- Brass Helmet
	{ id = 3291, chance = 14606 }, -- Knife
	{ id = 3081, chance = 1000 }, -- Stone Skin Amulet
	{ id = 3377, chance = 3890 }, -- Scale Armor
	{ id = 3114, chance = 2890 }, -- Skull (Item)
	{ id = 3367, chance = 5820 }, -- Viking Helmet
	{ id = 5913, chance = 1101 }, -- Brown Piece of Cloth
	{ id = 3052, chance = 251 }, -- Life Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -50 },
}

monster.defenses = {
	defense = 0,
	armor = 8,
	mitigation = 0.43,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 5, maxDamage = 15, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
