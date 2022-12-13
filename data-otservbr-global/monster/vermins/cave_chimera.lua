local mType = Game.createMonsterType("Cave Chimera")
local monster = {}

monster.description = "a cave chimera"
monster.experience = 6800
monster.outfit = {
	lookType = 1406,
	lookHead = 60,
	lookBody = 77,
	lookLegs = 64,
	lookFeet = 70,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 2096
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Dwelling of the Forgotten"
}

monster.health = 8000
monster.maxHealth = 8000
monster.race = "blood"
monster.corpse = 36768
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	targetDistance = 4,
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
	{text = "Gruaaar!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 70000, maxCount = 24},
	{name = "great spirit potion", chance = 25220, maxCount = 2},
	{name = "ultimate health potion", chance = 20000, maxCount = 4},
	{name = "gold ingot", chance = 19130, maxCount = 2},
	{name = "violet crystal shard", chance = 6090, maxCount = 3},
	{name = "violet gem", chance = 6960, maxCount = 1},
	{name = "cave chimera leg", chance = 4350},
	{name = "cave chimera head", chance = 3480},
	{id = 281, chance = 1740}, -- giant shimmering pearl (green)
	{name = "yellow gem", chance = 2660},
	{name = "glacier amulet", chance = 2480},
	{id = 23529, chance = 1720}, -- ring of blue plasma
	{name = "glacier kilt", chance = 1540},
	{name = "gold ring", chance = 1430},
	{name = "fur armor", chance = 970},
	{name = "gemmed figurine", chance = 970},
	{name = "ornate crossbow", chance = 850},
	{name = "crystal crossbow", chance = 180},
	{name = "composite hornbow", chance = 100},
	{name = "elvish bow", chance = 80}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_HOLYDAMAGE, minDamage = -600, maxDamage = -700, range = 4, radius = 3, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true},
	{name ="combat", interval = 2000, chance = 60, type = COMBAT_ICEDAMAGE, minDamage = -560, maxDamage = -650, radius = 4, effect = CONST_ME_BLUE_ENERGY_SPARK, target = false},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_ICEDAMAGE, minDamage = -750, maxDamage = -850, range = 4, shootEffect = CONST_ANI_ICE, target = true},
}

monster.defenses = {
	defense = 60,
	armor = 60,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 200, maxDamage = 700, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 100},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
