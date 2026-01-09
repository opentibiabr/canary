local mType = Game.createMonsterType("Boar Man")
local monster = {}

monster.description = "a boar man"
monster.experience = 7720
monster.outfit = {
	lookType = 1603,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2339
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Ingol",
}

monster.health = 9200
monster.maxHealth = 9200
monster.race = "blood"
monster.corpse = 42218
monster.speed = 160
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
	illusionable = true,
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
	{ text = "Oink!", yell = false },
	{ text = "Hungerrr!", yell = false },
	{ text = "Grunt!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 79070 }, -- Platinum Coin
	{ id = 3039, chance = 6360 }, -- Red Gem
	{ id = 16126, chance = 9850 }, -- Red Crystal Fragment
	{ id = 40584, chance = 200 }, -- Boar Man Hoof
	{ id = 239, chance = 3790 }, -- Great Health Potion
	{ id = 3333, chance = 2120 }, -- Crystal Mace
	{ id = 7437, chance = 2660 }, -- Sapphire Hammer
	{ id = 7449, chance = 1280 }, -- Crystal Sword
	{ id = 3428, chance = 920 }, -- Tower Shield
	{ id = 3007, chance = 680 }, -- Crystal Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -498 },
	{ name = "combat", interval = 2300, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -375, maxDamage = -392, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, target = true },
	{ name = "combat", interval = 2600, chance = 40, type = COMBAT_DEATHDAMAGE, minDamage = -386, maxDamage = -480, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, target = true },
	{ name = "combat", interval = 2900, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -60, maxDamage = -140, range = 1, radius = 4, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 3200, chance = 35, type = COMBAT_ENERGYDAMAGE, minDamage = -311, maxDamage = -400, length = 8, spread = 3, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 72,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
