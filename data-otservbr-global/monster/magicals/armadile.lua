local mType = Game.createMonsterType("Armadile")
local monster = {}

monster.description = "an armadile"
monster.experience = 3200
monster.outfit = {
	lookType = 487,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 880
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 1.",
}

monster.health = 3800
monster.maxHealth = 3800
monster.race = "undead"
monster.corpse = 15868
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
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Creak!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 198 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 7 }, -- platinum coin
	{ id = 11447, chance = 23000 }, -- battle stone
	{ id = 12600, chance = 23000 }, -- coal
	{ id = 16138, chance = 23000 }, -- crystalline spikes
	{ id = 16142, chance = 23000, maxCount = 5 }, -- drill bolt
	{ id = 16143, chance = 23000, maxCount = 10 }, -- envenomed arrow
	{ id = 239, chance = 23000, maxCount = 2 }, -- great health potion
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 16127, chance = 23000, maxCount = 2 }, -- green crystal fragment
	{ id = 268, chance = 23000, maxCount = 3 }, -- mana potion
	{ id = 236, chance = 23000, maxCount = 2 }, -- strong health potion
	{ id = 237, chance = 23000, maxCount = 2 }, -- strong mana potion
	{ id = 16122, chance = 5000, maxCount = 2 }, -- green crystal splinter
	{ id = 813, chance = 5000 }, -- terra boots
	{ id = 3053, chance = 5000 }, -- time ring
	{ id = 7413, chance = 5000 }, -- titan axe
	{ id = 3428, chance = 1000 }, -- tower shield
	{ id = 7428, chance = 1000 }, -- bonebreaker
	{ id = 8050, chance = 260 }, -- crystalline armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150 },
	{ name = "drunk", interval = 2000, chance = 10, radius = 4, effect = CONST_ME_FIREAREA, target = true, duration = 5000 },
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -200, maxDamage = -400, radius = 4, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 66,
	mitigation = 1.96,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 45 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
