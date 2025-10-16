local mType = Game.createMonsterType("Enslaved Dwarf")
local monster = {}

monster.description = "an enslaved dwarf"
monster.experience = 2700
monster.outfit = {
	lookType = 494,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 886
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Caves of the Lost and Lower Spike.",
}

monster.health = 3800
monster.maxHealth = 3800
monster.race = "blood"
monster.corpse = 16063
monster.speed = 135
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
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
	{ text = "Bark!", yell = false },
	{ text = "Blood!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 149 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 6 }, -- platinum coin
	{ id = 3725, chance = 23000, maxCount = 2 }, -- brown mushroom
	{ id = 239, chance = 23000 }, -- great health potion
	{ id = 238, chance = 23000 }, -- great mana potion
	{ id = 5880, chance = 23000 }, -- iron ore
	{ id = 3033, chance = 23000, maxCount = 2 }, -- small amethyst
	{ id = 3032, chance = 23000, maxCount = 2 }, -- small emerald
	{ id = 3279, chance = 5000 }, -- war hammer
	{ id = 3432, chance = 5000 }, -- ancient shield
	{ id = 16142, chance = 5000, maxCount = 5 }, -- drill bolt
	{ id = 7454, chance = 5000 }, -- glorious axe
	{ id = 16123, chance = 5000, maxCount = 2 }, -- brown crystal splinter
	{ id = 16122, chance = 5000 }, -- green crystal splinter
	{ id = 3415, chance = 5000 }, -- guardian shield
	{ id = 16126, chance = 5000 }, -- red crystal fragment
	{ id = 10310, chance = 5000 }, -- shiny stone
	{ id = 3092, chance = 5000 }, -- axe ring
	{ id = 12600, chance = 5000 }, -- coal
	{ id = 16121, chance = 5000 }, -- green crystal shard
	{ id = 7413, chance = 5000 }, -- titan axe
	{ id = 7437, chance = 1000 }, -- sapphire hammer
	{ id = 3428, chance = 1000 }, -- tower shield
	{ id = 3369, chance = 260 }, -- warrior helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -501 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -340, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -250, range = 7, radius = 3, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "drunk", interval = 2000, chance = 20, radius = 5, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000 },
	{ name = "enslaved dwarf skill reducer 1", interval = 2000, chance = 5, target = false },
	{ name = "enslaved dwarf skill reducer 2", interval = 2000, chance = 5, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 60,
	mitigation = 1.88,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 396, maxDamage = 478, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -3 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
