local mType = Game.createMonsterType("Goblin")
local monster = {}

monster.description = "a goblin"
monster.experience = 25
monster.outfit = {
	lookType = 61,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 61
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 250,
	FirstUnlock = 10,
	SecondUnlock = 100,
	CharmsPoints = 5,
	Stars = 1,
	Occurrence = 0,
	Locations = "Femor Hills, north east of Carlin, Edron Goblin Cave, Rookgaard (Premium Area), \z
		Maze of Lost Souls and Fenrock.",
}

monster.health = 50
monster.maxHealth = 50
monster.race = "blood"
monster.corpse = 6002
monster.speed = 60
monster.manaCost = 290

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
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
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Zig Zag! Gobo attack!", yell = false },
	{ text = "Me green, me mean!", yell = false },
	{ text = "Bugga! Bugga!", yell = false },
	{ text = "Help! Goblinkiller!", yell = false },
	{ text = "Me have him!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 9 }, -- gold coin
	{ id = 7885, chance = 23000 }, -- fish
	{ id = 3294, chance = 23000 }, -- short sword
	{ id = 3462, chance = 23000 }, -- small axe
	{ id = 1781, chance = 23000 }, -- small stone
	{ id = 3337, chance = 5000 }, -- bone club
	{ id = 3361, chance = 5000 }, -- leather armor
	{ id = 7573, chance = 5000 }, -- bone
	{ id = 3267, chance = 5000 }, -- dagger
	{ id = 3355, chance = 5000 }, -- leather helmet
	{ id = 11539, chance = 1000 }, -- goblin ear
	{ id = 3120, chance = 1000 }, -- mouldy cheese
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -10 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -25, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = false },
}

monster.defenses = {
	defense = 10,
	armor = 6,
	mitigation = 0.20,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
