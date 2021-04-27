local mType = Game.createMonsterType("Goblin Assassin")
local monster = {}

monster.description = "a goblin assassin"
monster.experience = 52
monster.outfit = {
	lookType = 296,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 463
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Femor Hills, Edron Goblin Cave and Fenrock."
	}

monster.health = 75
monster.maxHealth = 75
monster.race = "blood"
monster.corpse = 6002
monster.speed = 140
monster.manaCost = 360
monster.maxSummons = 0

monster.changeTarget = {
	interval = 10000,
	chance = 0
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
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Goblin Powahhh!", yell = false},
	{text = "Me kill you!", yell = false},
	{text = "Me green menace!", yell = false},
	{text = "Gobabunga!", yell = false},
	{text = "Gooobliiiins!", yell = false}
}

monster.loot = {
	{name = "small stone", chance = 9900, maxCount = 3},
	{name = "gold coin", chance = 50000, maxCount = 9},
	{id = 2230, chance = 13000},
	{name = "mouldy cheese", chance = 6610},
	{name = "dagger", chance = 17000},
	{name = "short sword", chance = 8820},
	{name = "bone club", chance = 4770},
	{name = "leather helmet", chance = 13000},
	{name = "leather armor", chance = 7240},
	{name = "small axe", chance = 9800},
	{id = 2667, chance = 12400}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -15},
	{name ="drunk", interval = 2000, chance = 10, shootEffect = CONST_ANI_POISON, target = false, duration = 10000},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -35, range = 6, shootEffect = CONST_ANI_THROWINGKNIFE, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE},
	{name ="speed", interval = 2000, chance = 15, speedChange = 100, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 1},
	{type = COMBAT_DEATHDAMAGE , percent = -1}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
