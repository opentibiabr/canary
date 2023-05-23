local mType = Game.createMonsterType("Girtablilu Warrior")
local monster = {}

monster.description = "a girtablilu warrior"
monster.experience = 5800
monster.outfit = {
	lookType = 1407,
	lookHead = 114,
	lookBody = 39,
	lookLegs = 113,
	lookFeet = 114,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 2099
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Ruins of Nuur"
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 36800
monster.speed = 180
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
	staticAttackChance = 90,
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
	{text = "Tip tap tip tap!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 70000, maxCount = 25},
	{name = "ultimate health potion", chance = 15360, maxCount = 4},
	{name = "gold ingot", chance = 14130, maxCount = 2},
	{name = "green crystal shard", chance = 6420, maxCount = 3},
	{name = "red crystal fragment", chance = 5830, maxCount = 3},
	{name = "girtablilu warrior carapace", chance = 4650, maxCount = 1},
	{name = "cyan crystal fragment", chance = 4530, maxCount = 3},
	{name = "scorpion charm", chance = 4240},
	{name = "green gem", chance = 4060},
	{name = "violet gem", chance = 3410},
	{name = "blue crystal shard", chance = 2880, maxCount = 3},
	{name = "crowbar", chance = 2830},
	{name = "diamond sceptre", chance = 2590},
	{name = "violet crystal shard", chance = 2470},
	{name = "yellow gem", chance = 2350},
	{name = "ice rapier", chance = 2240},
	{name = "magma coat", chance = 2180},
	{name = "epee", chance = 2120},
	{name = "dragonbone staff", chance = 2000},
	{name = "knight axe", chance = 2000},
	{name = "beastslayer axe", chance = 1940},
	{name = "green crystal fragment", chance = 1710},
	{name = "blue gem", chance = 1530},
	{id = 3039, chance = 1530}, -- red gem
	{name = "blue robe", chance = 1060},
	{name = "focus cape", chance = 1060},
	{name = "fur armor", chance = 820},
	{name = "glacier robe", chance = 650}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -450},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -650, radius = 4, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -450, range = 5, shootEffect = CONST_ANI_POISONARROW, target = true},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -400, length = 3, spread = 2, effect = CONST_ME_GREEN_RINGS, target = false}
}

monster.defenses = {
	defense = 76,
	armor = 76,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -15},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
