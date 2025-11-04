local mType = Game.createMonsterType("Headpecker")
local monster = {}

monster.description = "a headpecker"
monster.experience = 12026
monster.outfit = {
	lookType = 1557,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2275
monster.Bestiary = {
	class = "Bird",
	race = BESTY_RACE_BIRD,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Crystal Enigma",
}

monster.health = 16300
monster.maxHealth = 16300
monster.race = "blood"
monster.corpse = 39319
monster.speed = 217
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 70,
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
}

monster.loot = {
	{ id = 3043, chance = 34435 }, -- Crystal Coin
	{ id = 7432, chance = 5737 }, -- Furry Club
	{ id = 39387, chance = 11806 }, -- Headpecker Beak
	{ id = 39388, chance = 7377, maxCount = 5 }, -- Headpecker Feather
	{ id = 3041, chance = 1829 }, -- Blue Gem
	{ id = 3271, chance = 3971 }, -- Spike Sword
	{ id = 3279, chance = 2197 }, -- War Hammer
	{ id = 3291, chance = 4117 }, -- Knife
	{ id = 3595, chance = 4469 }, -- Carrot
	{ id = 7413, chance = 1735 }, -- Titan Axe
	{ id = 8092, chance = 1000 }, -- Wand of Starstorm
	{ id = 9058, chance = 910 }, -- Gold Ingot
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000 },
	{ name = "combat", interval = 2500, chance = 37, type = COMBAT_EARTHDAMAGE, minDamage = -700, maxDamage = -1100, range = 1, effect = CONST_ME_BLACKSMOKE, target = true },
	{ name = "combat", interval = 4200, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -700, maxDamage = -1050, length = 4, spread = 3, effect = CONST_ME_SLASH, target = false },
	{ name = "headpecker explosion", interval = 3500, chance = 35, minDamage = -700, maxDamage = -850 },
}

monster.defenses = {
	defense = 100,
	armor = 68,
	mitigation = 2.05,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

RegisterPrimalPackBeast(monster)
