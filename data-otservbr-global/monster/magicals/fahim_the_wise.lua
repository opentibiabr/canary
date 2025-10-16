local mType = Game.createMonsterType("Fahim the Wise")
local monster = {}

monster.description = "Fahim the Wise"
monster.experience = 1500
monster.outfit = {
	lookType = 104,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 2000
monster.maxHealth = 2000
monster.race = "blood"
monster.corpse = 6033
monster.speed = 90
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
	rewardBoss = true,
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

monster.summon = {
	maxSummons = 3,
	summons = {
		{ name = "blue djinn", chance = 10, interval = 2000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You should know better than to be an enemy of the Marid", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 118 }, -- gold coin
	{ id = 3588, chance = 80000, maxCount = 22 }, -- blueberry
	{ id = 647, chance = 80000 }, -- seeds
	{ id = 2933, chance = 80000 }, -- small oil lamp
	{ id = 5912, chance = 80000, maxCount = 4 }, -- blue piece of cloth
	{ id = 3029, chance = 80000, maxCount = 2 }, -- small sapphire
	{ id = 237, chance = 80000, maxCount = 3 }, -- strong mana potion
	{ id = 7378, chance = 80000, maxCount = 3 }, -- royal spear
	{ id = 3262, chance = 80000 }, -- wooden flute
	{ id = 3330, chance = 80000 }, -- heavy machete
	{ id = 3574, chance = 80000 }, -- mystic turban
	{ id = 11486, chance = 80000 }, -- noble turban
	{ id = 11470, chance = 80000 }, -- jewelled belt
	{ id = 3041, chance = 1000 }, -- blue gem
	{ id = 827, chance = 1000 }, -- magma monocle
	{ id = 10310, chance = 1000 }, -- shiny stone
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -130 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -300, range = 7, shootEffect = CONST_ANI_ENERGYBALL, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -30, maxDamage = -90, range = 7, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -650, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 1500 },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, target = false, duration = 6000 },
	{ name = "outfit", interval = 2000, chance = 1, range = 7, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 4000, outfitMonster = "rabbit" },
	{ name = "djinn electrify", interval = 2000, chance = 15, range = 5, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -30, maxDamage = -90, radius = 3, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	mitigation = 1.29,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 1 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
