local mType = Game.createMonsterType("Frost Flower Asura")
local monster = {}

monster.description = "a frost flower asura"
monster.experience = 4200
monster.outfit = {
	lookType = 150,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 86,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1619
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Asura Palace.",
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 28807
monster.speed = 110
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
	staticAttackChance = 80,
	targetDistance = 3,
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
}

monster.loot = {
	{ id = 3031, chance = 70980, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80500, maxCount = 6 }, -- platinum coin
	{ id = 3567, chance = 680 }, -- blue robe
	{ id = 7368, chance = 6640, maxCount = 5 }, -- assassin star
	{ id = 3027, chance = 5320, maxCount = 1 }, -- black pearl
	{ id = 3007, chance = 250 }, -- crystal ring
	{ id = 6558, chance = 19650 }, -- flask of demonic blood
	{ id = 6499, chance = 15850 }, -- demonic essence
	{ id = 3028, chance = 8200, maxCount = 1 }, -- small diamond
	{ id = 3032, chance = 3970, maxCount = 1 }, -- small emerald
	{ id = 3030, chance = 4560, maxCount = 1 }, -- small ruby
	{ id = 3029, chance = 7600, maxCount = 3 }, -- small sapphire
	{ id = 9057, chance = 4770, maxCount = 1 }, -- small topaz
	{ id = 239, chance = 12080, maxCount = 2 }, -- great health potion
	{ id = 3026, chance = 7480 }, -- white pearl
	{ id = 7404, chance = 550 }, -- assassin dagger
	{ id = 3041, chance = 300 }, -- blue gem
	{ id = 9058, chance = 380 }, -- gold ingot
	{ id = 21974, chance = 19650 }, -- golden lotus brooch
	{ id = 21981, chance = 340 }, -- oriental shoes
	{ id = 21975, chance = 17280 }, -- peacock feather fan
	{ id = 8061, chance = 250 }, -- skullcracker armor
	{ id = 3017, chance = 5790 }, -- silver brooch
	{ id = 3054, chance = 1100 }, -- silver amulet
	{ id = 5944, chance = 19520 }, -- soul orb
	{ id = 8074, chance = 420 }, -- spellbook of mind control
	{ id = 3403, chance = 3380 }, -- tribal mask
	{ id = 3037, chance = 1820 }, -- yellow gem
	{ id = 3067, chance = 19520 }, -- hailstorm rod
	{ id = 8083, chance = 19520 }, -- northwind rod
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -110, maxDamage = -400 },
	{ name = "combat", interval = 1300, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -185, maxDamage = -210, length = 8, spread = 0, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "combat", interval = 1000, chance = 9, type = COMBAT_ICEDAMAGE, minDamage = -120, maxDamage = -200, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 56,
	mitigation = 1.62,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 90, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
