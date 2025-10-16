local mType = Game.createMonsterType("Ahau")
local monster = {}

monster.description = "Ahau"
monster.experience = 17500
monster.outfit = {
	lookType = 1591,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2346,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 42069
monster.speed = 350
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	rewardBoss = true,
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
	{ text = "WAAAHNGH!!!", yell = true },
	{ text = "Awrrrgh!", yell = false },
	{ text = "IKSPUTUTU!!", yell = true },
	{ text = "Hwaaarrrh!!!", yell = false },
	{ text = "Wraaahgh?!", yell = false },
	{ text = "AAAAAH!!", yell = true },
}

monster.loot = {
	{ id = 40578, chance = 80000 }, -- the living idol of tukh
	{ id = 3031, chance = 80000, maxCount = 250 }, -- gold coin
	{ id = 14112, chance = 80000, maxCount = 2 }, -- bar of gold
	{ id = 32770, chance = 80000, maxCount = 8 }, -- diamond
	{ id = 32624, chance = 80000 }, -- amber with a bug
	{ id = 239, chance = 80000, maxCount = 5 }, -- great health potion
	{ id = 238, chance = 80000, maxCount = 6 }, -- great mana potion
	{ id = 7642, chance = 80000, maxCount = 3 }, -- great spirit potion
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 40532, chance = 80000 }, -- broken iks headpiece
	{ id = 40531, chance = 80000 }, -- broken iks faulds
	{ id = 40530, chance = 80000 }, -- broken macuahuitl
	{ id = 40533, chance = 80000 }, -- broken iks cuirass
}

monster.attacks = {
	{ name = "melee", interval = 1700, chance = 100, minDamage = 0, maxDamage = -456, effect = 244 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -422, range = 1, radius = 0, effect = CONST_ME_GREENSMOKE, target = true },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_FIREDAMAGE, minDamage = -400, maxDamage = -500, length = 5, spread = 0, effect = 216, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -415, maxDamage = -570, radius = 2, effect = CONST_ME_STONE_STORM, target = false },
	{ name = "boulder ring", interval = 2000, chance = 20, minDamage = -460, maxDamage = -500 },
}

monster.defenses = {
	defense = 64,
	armor = 0,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
