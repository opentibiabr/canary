local mType = Game.createMonsterType("Bashmu")
local monster = {}

monster.description = "a bashmu"
monster.experience = 5000
monster.outfit = {
	lookType = 1408,
	lookHead = 0,
	lookBody = 50,
	lookLegs = 42,
	lookFeet = 79,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2100
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Salt Caves.",
}

monster.health = 8200
monster.maxHealth = 8200
monster.race = "blood"
monster.corpse = 36804
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	hasGroupedSpells = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Hsssssss!", yell = false },
	{ text = "Hiss!", yell = false },
	{ text = "*rattle*", yell = false },
}

monster.loot = {
	{ name = "platinum coin", chance = 70260, maxCount = 19 },
	{ name = "guardian halberd", chance = 9040 },
	{ name = "bashmu feather", chance = 5760 },
	{ name = "bashmu tongue", chance = 4110 },
	{ name = "sacred tree amulet", chance = 4340 },
	{ name = "great spirit potion", chance = 3930 },
	{ name = "green crystal shard", chance = 3070 },
	{ name = "blue crystal shard", chance = 3190 },
	{ name = "small diamond", chance = 4020 },
	{ name = "violet gem", chance = 3310 },
	{ name = "bashmu fang", chance = 2220 },
	{ name = "rainbow quartz", chance = 1890 },
	{ name = "terra amulet", chance = 1450 },
	{ name = "glacier amulet", chance = 890 },
	{ name = "glorious axe", chance = 830 },
	{ id = 23544, chance = 710 }, -- collar of red plasma
	{ name = "haunted blade", chance = 710 },
	{ name = "magma amulet", chance = 800 },
	{ id = 23542, chance = 830 }, -- collar of blue plasma
}

monster.attacks = {
	{ name = "melee", group = MONSTER_SPELL_GROUP_BASIC, chance = 100, minDamage = 0, maxDamage = -600 },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -800, length = 4, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -500, range = 3, radius = 3, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -800, range = 7, shootEffect = CONST_ANI_EARTHARROW, target = true },
}

monster.defenses = {
	defense = 72,
	armor = 72,
	mitigation = 2.16,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 150, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
