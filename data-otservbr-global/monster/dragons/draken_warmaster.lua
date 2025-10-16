local mType = Game.createMonsterType("Draken Warmaster")
local monster = {}

monster.description = "a draken warmaster"
monster.experience = 2400
monster.outfit = {
	lookType = 334,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 617
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Zao Palace, Chazorai, Razzachai, and Zzaion.",
}

monster.health = 4150
monster.maxHealth = 4150
monster.race = "blood"
monster.corpse = 10190
monster.speed = 162
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
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
	{ text = "Attack aggrezzively! Dezztroy zze intruderzz!", yell = false },
	{ text = "Hizzzzzz!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 3577, chance = 80000 }, -- meat
	{ id = 10404, chance = 23000 }, -- bone shoulderplate
	{ id = 10405, chance = 23000 }, -- warmasters wristguards
	{ id = 10406, chance = 23000 }, -- zaoan halberd
	{ id = 239, chance = 5000, maxCount = 3 }, -- great health potion
	{ id = 7643, chance = 5000 }, -- ultimate health potion
	{ id = 10386, chance = 5000 }, -- zaoan shoes
	{ id = 3030, chance = 5000, maxCount = 5 }, -- small ruby
	{ id = 3428, chance = 5000 }, -- tower shield
	{ id = 10388, chance = 1000 }, -- drakinata
	{ id = 10384, chance = 1000 }, -- zaoan armor
	{ id = 10387, chance = 1000 }, -- zaoan legs
	{ id = 3006, chance = 260 }, -- ring of the sky
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -240, maxDamage = -520, length = 4, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 55,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 510, maxDamage = 600, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
