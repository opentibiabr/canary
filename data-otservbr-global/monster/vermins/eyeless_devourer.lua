local mType = Game.createMonsterType("Eyeless Devourer")
local monster = {}

monster.description = "an eyeless devourer"
monster.experience = 6000
monster.outfit = {
	lookType = 1399,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2092
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Antrum of the Fallen.",
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 36696
monster.speed = 165
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	{ id = 3035, chance = 80000, maxCount = 21 }, -- platinum coin
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 3038, chance = 23000 }, -- green gem
	{ id = 16119, chance = 23000 }, -- blue crystal shard
	{ id = 16120, chance = 23000 }, -- violet crystal shard
	{ id = 16121, chance = 23000 }, -- green crystal shard
	{ id = 36775, chance = 23000 }, -- eyeless devourer maw
	{ id = 36776, chance = 23000 }, -- eyeless devourer legs
	{ id = 815, chance = 5000 }, -- glacier amulet
	{ id = 3333, chance = 5000 }, -- crystal mace
	{ id = 3342, chance = 5000 }, -- war axe
	{ id = 7383, chance = 5000 }, -- relic sword
	{ id = 7386, chance = 5000 }, -- mercenary sword
	{ id = 7456, chance = 5000 }, -- noble axe
	{ id = 9302, chance = 5000 }, -- sacred tree amulet
	{ id = 14040, chance = 5000 }, -- warriors axe
	{ id = 14247, chance = 5000 }, -- ornate crossbow
	{ id = 36777, chance = 5000 }, -- eyeless devourer tongue
	{ id = 3281, chance = 1000 }, -- giant sword
	{ id = 7422, chance = 1000 }, -- jade hammer
	{ id = 7451, chance = 1000 }, -- shadow sceptre
	{ id = 21171, chance = 1000 }, -- metal bat
	{ id = 21176, chance = 1000 }, -- execowtioner axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 2750, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -700, maxDamage = -800, range = 5, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 60, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -700, radius = 3, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -560, length = 5, spread = 0, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 63,
	armor = 63,
	mitigation = 1.82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
