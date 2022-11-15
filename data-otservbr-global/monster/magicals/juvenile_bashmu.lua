local mType = Game.createMonsterType("Juvenile Bashmu")
local monster = {}

monster.description = "a juvenile bashmu"
monster.experience = 4500
monster.outfit = {
	lookType = 1408,
	lookHead = 0,
	lookBody = 112,
	lookLegs = 3,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 2101
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Salt Caves"
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "blood"
monster.corpse = 36967
monster.speed = 195
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20
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
	level = 1,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "platinum coin", chance = 70000, maxCount = 19},
	{name = "great spirit potion", chance = 14700, maxCount = 4},
	{name = "ultimate health potion", chance = 1300, maxCount = 4},
	{name = "blue crystal shard", chance = 6160, maxCount = 3},
	{name = "bashmu tongue", chance = 5840, maxCount = 3},
	{name = "bashmu feather", chance = 4620, maxCount = 2},
	{name = "green crystal shard", chance = 3666},
	{name = "cyan crystal fragment", chance = 3340},
	{id = 3039, chance = 2390, maxCount = 1}, -- red gem
	{name = "violet gem", chance = 2340, maxCount = 1},
	{name = "lightning legs", chance = 2230},
	{name = "diamond sceptre", chance = 2180},
	{name = "lightning pendant", chance = 2180},
	{name = "bashmu fang", chance = 2120},
	{name = "yellow gem", chance = 2070},
	{name = "war hammer", chance = 1540},
	{name = "violet crystal shard", chance = 1490},
	{name = "dragonbone staff", chance = 1430},
	{name = "amber staff", chance = 1270},
	{name = "lightning boots", chance = 1270},
	{name = "green gem", chance = 1220},
	{name = "spellweaver's robe", chance = 1110},
	{name = "pair of iron fists", chance = 1010},
	{name = "skull staff", chance = 960},
	{name = "crystal mace", chance = 800},
	{name = "chaos mace", chance = 530}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400},
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -400, length = 4, spread = 0, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -500, range = 3, radius = 3, effect = CONST_ME_ENERGYHIT, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -500, range = 7, shootEffect = CONST_ANI_EARTHARROW, target = true},
}

monster.defenses = {
	defense = 75,
	armor = 75,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 5},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
