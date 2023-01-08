local mType = Game.createMonsterType("Burning Gladiator")
local monster = {}

monster.description = "a burning gladiator"
monster.experience = 7350
monster.outfit = {
	lookType = 541,
	lookHead = 95,
	lookBody = 113,
	lookLegs = 3,
	lookFeet = 3,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 1798
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Issavi Sewers, Kilmaresh Catacombs and Kilmaresh Mountains (above and under ground)."
	}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 31646
monster.speed = 145
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	canPushCreatures = false,
	staticAttackChance = 70,
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
	{text = "Burn, infidel!", yell = false},
	{text = "Only the Wild Sun shall shine down on this world!", yell = false},
	{text = "Praised be Fafnar, the Smiter!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 3},
	{name = "fafnar symbol", chance = 6600},
	{id = 31433, chance = 5600}, -- secret instruction
	{id = 31435, chance = 5600}, -- secret instruction
	{id = 31436, chance = 5600}, -- secret instruction
	{name = "dragon necklace", chance = 4700},
	{name = "lightning pendant", chance = 4100},
	{name = "magma amulet", chance = 3700},
	{name = "strange talisman", chance = 3000},
	{name = "magma boots", chance = 2700},
	{id = 31331, chance = 2400}, -- empty honey glass
	{name = "elven amulet", chance = 2100},
	{name = "lightning legs", chance = 2000},
	{name = "lightning headband", chance = 1700},
	{name = "lightning boots", chance = 1400},
	{name = "spellweaver's robe", chance = 850},
	{id = 31369, chance = 570}, -- gryphon mask
	{name = "sea horse figurine", chance = 140}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550},
	{name ="firering", interval = 2000, chance = 10, minDamage = -300, maxDamage = -500, target = false},
	{name ="firex", interval = 2000, chance = 15, minDamage = -300, maxDamage = -500, target = false},
	{name ="combat", interval = 2000, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -500, radius = 2, effect = CONST_ME_FIREATTACK, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -500, length = 3, spread = 0, effect = CONST_ME_ENERGYHIT, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 89
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -20},
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
