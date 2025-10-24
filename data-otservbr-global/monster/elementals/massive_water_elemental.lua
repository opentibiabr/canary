local mType = Game.createMonsterType("Massive Water Elemental")
local monster = {}

monster.description = "a massive water elemental"
monster.experience = 1100
monster.outfit = {
	lookType = 11,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 279
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Calassa, Frozen Trench, Water Elemental Dungeon through the water channels, before Zugurosh in The Inquisition Quest.",
}

monster.health = 1250
monster.maxHealth = 1250
monster.race = "undead"
monster.corpse = 9582
monster.speed = 215
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
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 143,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 92155, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 27587, maxCount = 2 }, -- Platinum Coin
	{ id = 3578, chance = 39437, maxCount = 2 }, -- Fish
	{ id = 239, chance = 10043 }, -- Great Health Potion
	{ id = 238, chance = 9672 }, -- Great Mana Potion
	{ id = 3028, chance = 4866, maxCount = 2 }, -- Small Diamond
	{ id = 3032, chance = 3859, maxCount = 2 }, -- Small Emerald
	{ id = 3048, chance = 5770 }, -- Might Ring
	{ id = 3051, chance = 1063 }, -- Energy Ring
	{ id = 7159, chance = 1574 }, -- Green Perch
	{ id = 3052, chance = 819 }, -- Life Ring
	{ id = 7158, chance = 1030 }, -- Rainbow Trout
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -220, condition = { type = CONDITION_POISON, totalDamage = 300, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DROWNDAMAGE, minDamage = -330, maxDamage = -450, range = 7, radius = 2, effect = CONST_ME_LOSEENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -170, maxDamage = -210, range = 7, shootEffect = CONST_ANI_SMALLICE, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 20, minDamage = -355, maxDamage = -420, radius = 5, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 45,
	mitigation = 1.32,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 120, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 40 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
