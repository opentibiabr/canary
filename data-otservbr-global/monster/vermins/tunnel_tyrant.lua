local mType = Game.createMonsterType("Tunnel Tyrant")
local monster = {}

monster.description = "a tunnel tyrant"
monster.experience = 4420
monster.outfit = {
	lookType = 1035,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1545
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Warzone 5",
}

monster.health = 5200
monster.maxHealth = 5200
monster.race = "blood"
monster.corpse = 27555
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
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
}

monster.loot = {
	{ id = 27596, chance = 19446 }, -- Tunnel Tyrant Shell
	{ id = 27595, chance = 12168 }, -- Tunnel Tyrant Head
	{ id = 675, chance = 9847 }, -- Small Enchanted Sapphire
	{ id = 9692, chance = 9250 }, -- Lump of Dirt
	{ id = 676, chance = 8004 }, -- Small Enchanted Ruby
	{ id = 3036, chance = 5623 }, -- Violet Gem
	{ id = 3041, chance = 2470 }, -- Blue Gem
	{ id = 23508, chance = 2547 }, -- Energy Vein
	{ id = 3038, chance = 1915 }, -- Green Gem
	{ id = 3333, chance = 1162 }, -- Crystal Mace
	{ id = 27653, chance = 1163 }, -- Suspicious Device
	{ id = 8050, chance = 696 }, -- Crystalline Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "stalagmite rune", interval = 2000, chance = 15, minDamage = -190, maxDamage = -300, range = 7, shootEffect = CONST_ANI_POISON, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -70, maxDamage = -160, range = 3, length = 6, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -90, maxDamage = -160, range = 3, length = 6, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "stone shower rune", interval = 2000, chance = 10, minDamage = -230, maxDamage = -450, range = 7, radius = 3, effect = CONST_ME_STONES, target = true },
}

monster.defenses = {
	defense = 5,
	armor = 76,
	mitigation = 1.82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
