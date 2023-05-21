local mType = Game.createMonsterType("Muglex Clan Assassin")
local monster = {}

monster.description = "a muglex clan assassin"
monster.experience = 48
monster.outfit = {
	lookType = 296,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 75
monster.maxHealth = 75
monster.race = "blood"
monster.corpse = 6002
monster.speed = 70
monster.manaCost = 0
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
	runHealth = 15,
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
	{id = 3115, chance = 10760}, -- bone
	{id = 3337, chance = 4890}, -- bone club
	{id = 3267, chance = 18090}, -- dagger
	{id = 3578, chance = 11000, maxCount = 2}, -- fish
	{id = 3031, chance = 100000, maxCount = 18}, -- gold coin
	{id = 3361, chance = 6460}, -- leather armor
	{id = 3355, chance = 8070}, -- leather helmet
	{id = 3120, chance = 6850}, -- mouldy cheese
	{id = 3294, chance = 9780}, -- short sword
	{id = 3462, chance = 9540}, -- small axe
	{id = 1781, chance = 11980, maxCount = 3}, -- small stone
	{id = 3378, chance = 1710} -- studded armor
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 10, attack = 15},
	{name ="drunk", interval = 2000, chance = 11, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false, duration = 3000},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -30, range = 6, shootEffect = CONST_ANI_THROWINGKNIFE, target = false}
}

monster.defenses = {
	defense = 5,
	armor = 3,
	{name ="invisible", interval = 2000, chance = 11, effect = CONST_ME_MAGIC_BLUE},
	{name ="speed", interval = 2000, chance = 10, speedChange = 145, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000}
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
