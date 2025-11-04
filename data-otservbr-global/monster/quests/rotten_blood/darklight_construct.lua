local mType = Game.createMonsterType("Darklight Construct")
local monster = {}

monster.description = "a darklight construct"
monster.experience = 22050
monster.outfit = {
	lookType = 1622,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2378
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Darklight Core",
}

monster.health = 32200
monster.maxHealth = 32200
monster.race = "undead"
monster.corpse = 43840
monster.speed = 220
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
	targetDistance = 0,
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

monster.loot = {
	{ id = 3043, chance = 61615 }, -- Crystal Coin
	{ id = 43850, chance = 7650 }, -- Dark Obsidian Splinter
	{ id = 43853, chance = 7508 }, -- Darklight Core (Object)
	{ id = 43781, chance = 9458 }, -- Darklight Obsidian Axe
	{ id = 817, chance = 5559 }, -- Magma Amulet
	{ id = 3039, chance = 3479 }, -- Red Gem
	{ id = 3032, chance = 4308, maxCount = 3 }, -- Small Emerald
	{ id = 10386, chance = 1666 }, -- Zaoan Shoes
	{ id = 3030, chance = 4588, maxCount = 3 }, -- Small Ruby
	{ id = 3038, chance = 630 }, -- Green Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1050 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -1300, maxDamage = -1500, length = 8, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_FIREDAMAGE, minDamage = -1100, maxDamage = -1400, radius = 5, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -1500, maxDamage = -1600, radius = 5, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "extended fire chain", interval = 2000, chance = 15, minDamage = -800, maxDamage = -1200, target = true },
	{ name = "largefirering", interval = 2800, chance = 20, minDamage = -1000, maxDamage = -1300, target = false },
}

monster.defenses = {
	defense = 117,
	armor = 117,
	mitigation = 2.98,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 55 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
