local mType = Game.createMonsterType("Streaked Devourer")
local monster = {}

monster.description = "a streaked devourer"
monster.experience = 6300
monster.outfit = {
	lookType = 1398,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2091
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Grotto of the Lost.",
}

monster.health = 7000
monster.maxHealth = 7000
monster.race = "blood"
monster.corpse = 36692
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	targetDistance = 4,
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
	{ id = 3035, chance = 100000, maxCount = 25 }, -- Platinum Coin
	{ id = 3039, chance = 9018 }, -- Red Gem
	{ id = 9058, chance = 13347 }, -- Gold Ingot
	{ id = 36772, chance = 10581 }, -- Streaked Devourer Eyes
	{ id = 36773, chance = 12830 }, -- Streaked Devourer Maw
	{ id = 36774, chance = 5837 }, -- Streaked Devourer Legs
	{ id = 3037, chance = 3736 }, -- Yellow Gem
	{ id = 3281, chance = 1365 }, -- Giant Sword
	{ id = 3315, chance = 1292 }, -- Guardian Halberd
	{ id = 3333, chance = 1715 }, -- Crystal Mace
	{ id = 3342, chance = 1019 }, -- War Axe
	{ id = 7383, chance = 1936 }, -- Relic Sword
	{ id = 7386, chance = 1757 }, -- Mercenary Sword
	{ id = 7456, chance = 1150 }, -- Noble Axe
	{ id = 14040, chance = 1453 }, -- Warrior's Axe
	{ id = 14247, chance = 1091 }, -- Ornate Crossbow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -800, maxDamage = -900, radius = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -580, maxDamage = -620, range = 5, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true },
	{ name = "devourer death wave", interval = 2000, chance = 40, minDamage = -730, maxDamage = -770 },
}

monster.defenses = {
	defense = 62,
	armor = 62,
	mitigation = 1.60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
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
