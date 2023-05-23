local mType = Game.createMonsterType("Crazed Dwarf")
local monster = {}

monster.description = "a crazed dwarf"
monster.experience = 50
monster.outfit = {
	lookType = 69,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 105
monster.maxHealth = 105
monster.race = "blood"
monster.corpse = 6007
monster.speed = 78
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
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
}

monster.loot = {
	{id = 3274, chance = 12860}, -- axe
	{id = 3031, chance = 100000, maxCount = 4}, -- gold coin
	{id = 3276, chance = 25710}, -- hatchet
	{id = 3559, chance = 8570}, -- leather legs
	{id = 3505, chance = 4290}, -- letter
	{id = 3456, chance = 8570}, -- pick
	{id = 3410, chance = 17140}, -- plate shield
	{id = 3378, chance = 8570}, -- studded armor
	{id = 3723, chance = 47140} -- white mushroom
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 10, attack = 26}
}

monster.defenses = {
	defense = 10,
	armor = 7
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
