local mType = Game.createMonsterType("Amenef the Burning")
local monster = {}

monster.description = "Amenef the Burning"
monster.experience = 21500
monster.outfit = {
	lookType = 541,
	lookHead = 113,
	lookBody = 114,
	lookLegs = 113,
	lookFeet = 113,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 26000
monster.maxHealth = 26000
monster.race = "blood"
monster.corpse = 31646
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "crystal coin", chance = 4494, maxCount = 1},
	{name = "slightly rusted legs", chance = 1392},
	{name = "slightly rusted armor", chance = 1203},
	{name = "guardian halberd", chance = 1139},
	{id = 3097, chance = 886}, -- dwarven ring
	{name = "mastermind potion", chance = 823},
	{name = "doublet", chance = 633},
	{name = "knight armor", chance = 570},
	{id = 23529, chance = 506}, -- ring of blue plasma
	{name = "epee", chance = 443},
	{name = "underworld rod", chance = 443},
	{name = "knight axe", chance = 380},
	{name = "springsprout rod", chance = 380},
	{name = "wand of cosmic energy", chance = 316},
	{name = "wand of inferno", chance = 316},
	{id = 281, chance = 253}, -- giant shimmering pearl (green)
	{name = "spellbook of warding", chance = 253},
	{name = "violet gem", chance = 253},
	{name = "wand of starstorm", chance = 253},
	{name = "amber staff", chance = 190},
	{name = "assassin dagger", chance = 190},
	{name = "blue gem", chance = 190},
	{name = "eye-embroidered veil", chance = 190},
	{name = "warrior's axe", chance = 190},
	{name = "focus cape", chance = 127},
	{name = "noble axe", chance = 127},
	{name = "sacred tree amulet", chance = 127},
	{name = "golden mask", chance = 63},
	{name = "mercenary sword", chance = 63}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -510},
	{name ="firering", interval = 2000, chance = 10, minDamage = -300, maxDamage = -600, target = false},
	{name ="firex", interval = 2000, chance = 15, minDamage = -450, maxDamage = -750, target = false},
	{name ="combat", interval = 2000, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -600, radius = 2, effect = CONST_ME_FIREATTACK, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -750, length = 3, spread = 0, effect = CONST_ME_ENERGYHIT, target = false}
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)