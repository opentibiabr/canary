local mType = Game.createMonsterType("Cave Devourer")
local monster = {}

monster.description = "a cave devourer"
monster.experience = 3380
monster.outfit = {
	lookType = 1036,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1544
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

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 27559
monster.speed = 120
monster.manaCost = 305

monster.changeTarget = {
	interval = 5000,
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
	convinceable = true,
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
	{ id = 27599, chance = 23000 }, -- cave devourer eyes
	{ id = 27600, chance = 23000 }, -- cave devourer maw
	{ id = 675, chance = 23000 }, -- small enchanted sapphire
	{ id = 676, chance = 23000 }, -- small enchanted ruby
	{ id = 15793, chance = 23000, maxCount = 40 }, -- crystalline arrow
	{ id = 16119, chance = 23000 }, -- blue crystal shard
	{ id = 16121, chance = 23000 }, -- green crystal shard
	{ id = 16125, chance = 23000 }, -- cyan crystal fragment
	{ id = 21194, chance = 23000, maxCount = 4 }, -- slime heart
	{ id = 27601, chance = 23000 }, -- cave devourer legs
	{ id = 16120, chance = 5000 }, -- violet crystal shard
	{ id = 3049, chance = 5000 }, -- stealth ring
	{ id = 27653, chance = 5000 }, -- suspicious device
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
	armor = 70,
	mitigation = 2.02,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
