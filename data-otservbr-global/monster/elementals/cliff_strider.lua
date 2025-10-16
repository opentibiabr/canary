local mType = Game.createMonsterType("Cliff Strider")
local monster = {}

monster.description = "a cliff strider"
monster.experience = 7100
monster.outfit = {
	lookType = 497,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 889
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 3.",
}

monster.health = 9400
monster.maxHealth = 9400
monster.race = "undead"
monster.corpse = 16075
monster.speed = 123
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{ text = "Knorrrr", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 195 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 10 }, -- platinum coin
	{ id = 238, chance = 80000, maxCount = 4 }, -- great mana potion
	{ id = 7643, chance = 80000, maxCount = 2 }, -- ultimate health potion
	{ id = 3026, chance = 23000, maxCount = 3 }, -- white pearl
	{ id = 3027, chance = 23000 }, -- black pearl
	{ id = 5880, chance = 23000 }, -- iron ore
	{ id = 5944, chance = 23000 }, -- soul orb
	{ id = 10310, chance = 23000 }, -- shiny stone
	{ id = 16119, chance = 23000 }, -- blue crystal shard
	{ id = 16124, chance = 23000, maxCount = 2 }, -- blue crystal splinter
	{ id = 16125, chance = 23000 }, -- cyan crystal fragment
	{ id = 16133, chance = 23000 }, -- pulverized ore
	{ id = 16134, chance = 23000 }, -- cliff strider claw
	{ id = 16135, chance = 23000, maxCount = 2 }, -- vein of ore
	{ id = 16141, chance = 23000, maxCount = 8 }, -- prismatic bolt
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3048, chance = 5000 }, -- might ring
	{ id = 5904, chance = 5000 }, -- magic sulphur
	{ id = 7437, chance = 5000 }, -- sapphire hammer
	{ id = 7452, chance = 5000 }, -- spiked squelcher
	{ id = 9028, chance = 5000 }, -- crystal of balance
	{ id = 9067, chance = 5000 }, -- crystal of power
	{ id = 16096, chance = 5000 }, -- wand of defiance
	{ id = 16118, chance = 5000 }, -- glacial rod
	{ id = 3041, chance = 1000 }, -- blue gem
	{ id = 3281, chance = 1000 }, -- giant sword
	{ id = 3371, chance = 1000 }, -- knight legs
	{ id = 3391, chance = 1000 }, -- crusader helmet
	{ id = 16160, chance = 1000 }, -- crystalline sword
	{ id = 16163, chance = 1000 }, -- crystal crossbow
	{ id = 3332, chance = 260 }, -- hammer of wrath
	{ id = 3381, chance = 260 }, -- crown armor
	{ id = 3554, chance = 260 }, -- steel boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -499 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -800, radius = 4, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true },
	{ name = "cliff strider skill reducer", interval = 2000, chance = 10, target = false },
	{ name = "cliff strider electrify", interval = 2000, chance = 15, range = 1, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1000, length = 6, spread = 0, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -300, radius = 4, effect = CONST_ME_YELLOWENERGY, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 89,
	mitigation = 2.60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 35 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
