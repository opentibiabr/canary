local mType = Game.createMonsterType("Quara Plunderer")
local monster = {}

monster.description = "a quara plunderer"
monster.experience = 10800
monster.outfit = {
	lookType = 1758,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2542
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Podzilla Bottom, Podzilla Underwater",
}

monster.health = 13500
monster.maxHealth = 13500
monster.race = "undead"
monster.corpse = 48389
monster.speed = 205
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	{ text = "Tssssh!!!", yell = false },
	{ text = "BLUP! BLUP!", yell = false },
	{ text = "Burp!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 57000, maxCount = 25 }, -- Platinum Coin
	{ id = 48509, chance = 6900 }, -- Resinous Fish Fin
	{ id = 48508, chance = 6700 }, -- Amber Souvenir
	{ id = 3041, chance = 5000 }, -- Blue Gem
	{ id = 3039, chance = 4700 }, -- Red Gem
	{ id = 7407, chance = 1300 }, -- Haunted Blade
	{ id = 11488, chance = 1000 }, -- Quara Eye
	{ id = 8074, chance = 880 }, -- Spellbook of Mind Control
	{ id = 3420, chance = 590 }, -- Demon Shield
	{ id = 7382, chance = 290 }, -- Demonrage Sword
	{ id = 45656, chance = 65 }, -- Preserved Purple Seed
	{ id = 45654, chance = 33 }, -- Preserved Light Blue Seed
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ICEDAMAGE, minDamage = -800, maxDamage = -1100, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = false },
	{ name = "quaracrossdeath", interval = 2000, chance = 20, minDamage = -1100, maxDamage = -1700, target = false },
	{ name = "quarasmokedeath", interval = 2000, chance = 20, minDamage = -850, maxDamage = -1150, target = false },
}

monster.defenses = {
	defense = 95,
	armor = 90,
	mitigation = 2.75,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
