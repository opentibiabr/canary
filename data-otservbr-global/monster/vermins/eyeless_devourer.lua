local mType = Game.createMonsterType("Eyeless Devourer")
local monster = {}

monster.description = "an eyeless devourer"
monster.experience = 6000
monster.outfit = {
	lookType = 1399,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 2092
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Antrum of the Fallen"
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 36696
monster.speed = 165
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
	{text = "Chrchrchr", yell = true},
	{text = "Klonklonk", yell = true},
	{text = "Chrrrrr", yell = true},
	{text = "Crunch crunch", yell = true}
}

monster.loot = {
	{name = "platinum coin", chance = 70000, maxCount = 22},
	{name = "ultimate health potion", chance = 29210, maxCount = 3},
	{name = "eyeless devourer maw", chance = 14680, maxCount = 1},
	{name = "blue crystal shard", chance = 6700, maxCount = 3},
	{name = "green crystal shard", chance = 6380, maxCount = 3},
	{name = "violet crystal shard", chance = 6230, maxCount = 3},
	{name = "eyeless devourer legs", chance = 7500, maxCount = 2},
	{name = "green gem", chance = 6300},
	{name = "eyeless devourer tongue", chance = 3590},
	{name = "sacred tree amulet", chance = 3190},
	{name = "crystal mace", chance = 1840},
	{name = "glacier amulet", chance = 2790},
	{name = "noble axe", chance = 1840},
	{name = "warrior's axe", chance = 1440},
	{name = "relic sword", chance = 880},
	{name = "giant sword", chance = 880},
	{name = "mercenary sword", chance = 640},
	{name = "war axe", chance = 1360, maxCount = 1},
	{name = "execowtioner axe", chance = 640},
	{name = "ornate crossbow", chance = 1040},
	{name = "jade hammer", chance = 1200},
	{name = "shadow sceptre", chance = 400},
	{name = "metal bat", chance = 320}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400, effect = CONST_ME_DRAWBLOOD},
	{name ="combat", interval = 2750, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -700, maxDamage = -800, range = 5, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true},
	{name ="combat", interval = 2000, chance = 60, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -700, radius = 3, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -560, length = 5, spread = 0, effect = CONST_ME_GREEN_RINGS, target = false},
}

monster.defenses = {
	defense = 63,
	armor = 63
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
