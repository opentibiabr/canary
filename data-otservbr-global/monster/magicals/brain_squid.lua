local mType = Game.createMonsterType("Brain Squid")
local monster = {}

monster.description = "a brain squid"
monster.experience = 17672
monster.outfit = {
	lookType = 1059,
	lookHead = 17,
	lookBody = 41,
	lookLegs = 77,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1653
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library."
	}

monster.health = 18000
monster.maxHealth = 18000
monster.race = "undead"
monster.corpse = 28582
monster.speed = 215
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
}

monster.loot = {
	{name = "violet crystal shard", chance = 900, maxCount = 4},
	{name = "platinum coin", chance = 100000, maxCount = 12},
	{name = "glowing rune", chance = 900, maxCount = 4},
	{name = "instable proto matter", chance = 1200, maxCount = 4},
	{name = "energy ball", chance = 1200, maxCount = 4},
	{name = "energy bar", chance = 1200, maxCount = 4},
	{name = "energy drink", chance = 1200, maxCount = 4},
	{name = "odd organ", chance = 1200, maxCount = 4},
	{name = "frozen lightning", chance = 1200, maxCount = 4},
	{id = 28568, chance = 1200, maxCount = 3}, -- inkwell
	{name = "small ruby", chance = 1200, maxCount = 4},
	{name = "violet gem", chance = 1200, maxCount = 4},
	{name = "blue crystal splinter", chance = 1200, maxCount = 4},
	{name = "cyan crystal fragment", chance = 1200, maxCount = 4},
	{name = "ultimate mana potion", chance = 1200, maxCount = 4},
	{name = "piece of dead brain", chance = 1200, maxCount = 4},
	{name = "wand of defiance", chance = 800},
	{name = "lightning headband", chance = 950},
	{name = "lightning pendant", chance = 850},
	{name = "might ring", chance = 1300},
	{name = "slime heart", chance = 1200, maxCount = 4},
	{id = 23544, chance = 560}, -- collar of red plasma
	{id = 23542, chance = 560}, -- collar of blue plasma
	{id = 23543, chance = 560}, -- collar of green plasma
	{id = 23533, chance = 560}, -- ring of red plasma
	{id = 23529, chance = 560}, -- ring of blue plasma
	{id = 23531, chance = 560} -- ring of green plasma
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -470, range = 7, shootEffect = CONST_ANI_ENERGY, target = false},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -505, radius = 3, effect = CONST_ME_ENERGYAREA, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 82
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 100},
	{type = COMBAT_DEATHDAMAGE , percent = -15}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
