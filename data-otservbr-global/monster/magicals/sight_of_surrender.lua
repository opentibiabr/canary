local mType = Game.createMonsterType("Sight of Surrender")
local monster = {}

monster.description = "a sight of surrender"
monster.experience = 17000
monster.outfit = {
	lookType = 583,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1012
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Dark Grounds, Guzzlemaw Valley (if less than 100 Blowing Horns tasks \z
		have been done the day before) and the Silencer Plateau (when Silencer Resonating Chambers are used there).",
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "undead"
monster.corpse = 20144
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "BOW LOW!", yell = true },
	{ text = "FEEL THE TRUE MEANING OF VANQUISH!", yell = true },
	{ text = "HAHAHAHA DO YOU WANT TO AMUSE YOUR MASTER?", yell = true },
	{ text = "NOW YOU WILL SURRENDER!", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 20 }, -- platinum coin
	{ id = 20184, chance = 80000 }, -- broken visor
	{ id = 20183, chance = 80000 }, -- sight of surrenders eye
	{ id = 238, chance = 80000, maxCount = 5 }, -- great mana potion
	{ id = 7643, chance = 80000, maxCount = 5 }, -- ultimate health potion
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 16124, chance = 80000, maxCount = 5 }, -- blue crystal splinter
	{ id = 16122, chance = 80000, maxCount = 5 }, -- green crystal splinter
	{ id = 16123, chance = 80000, maxCount = 5 }, -- brown crystal splinter
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 16119, chance = 80000, maxCount = 3 }, -- blue crystal shard
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 3081, chance = 23000 }, -- stone skin amulet
	{ id = 3048, chance = 5000 }, -- might ring
	{ id = 3333, chance = 5000 }, -- crystal mace
	{ id = 20062, chance = 5000 }, -- cluster of solace
	{ id = 3366, chance = 5000 }, -- magic plate armor
	{ id = 3554, chance = 5000 }, -- steel boots
	{ id = 7422, chance = 5000 }, -- jade hammer
	{ id = 3428, chance = 5000 }, -- tower shield
	{ id = 3332, chance = 1000 }, -- hammer of wrath
	{ id = 7421, chance = 1000 }, -- onyx flail
	{ id = 3391, chance = 1000 }, -- crusader helmet
	{ id = 3382, chance = 1000 }, -- crown legs
	{ id = 20208, chance = 260 }, -- string of mending
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1100 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 0, effect = CONST_ME_YELLOWENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -500, radius = 1, shootEffect = CONST_ANI_LARGEROCK, target = true },
}

monster.defenses = {
	defense = 70,
	armor = 92,
	mitigation = 2.31,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 550, maxDamage = 1100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 520, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
