local mType = Game.createMonsterType("Memory Of A Yalahari")
local monster = {}

monster.description = "a memory of a yalahari"
monster.experience = 1640
monster.outfit = {
	lookType = 309,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3540
monster.maxHealth = 3540
monster.race = "blood"
monster.corpse = 18269
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Welcome to Yalahar, outsider.", yell = false},
	{text = "Hail Yalahar.", yell = false},
	{text = "You can learn a lot from us.", yell = false},
	{text = "Our wisdom and knowledge are unequalled in this world.", yell = false},
	{text = "That knowledge would overburden your fragile mind.", yell = false},
	{text = "I wouldn't expect you to understand.", yell = false},
	{text = "One day Yalahar will return to its former glory.", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 15000, maxCount = 3},
	{id = 37531, chance = 5155}, -- candy floss
	{name = "bottle of champagne", chance = 7280},
	{name = "special fx box", chance = 1500},
	{name = "violet crystal shard", chance = 5000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -160}
}

monster.defenses = {
	defense = 0,
	armor = 0
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
