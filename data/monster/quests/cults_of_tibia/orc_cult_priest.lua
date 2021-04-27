local mType = Game.createMonsterType("Orc Cult Priest")
local monster = {}

monster.description = "an orc cult priest"
monster.experience = 1000
monster.outfit = {
	lookType = 6,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1504
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "Edron Orc Cave."
	}

monster.health = 1300
monster.maxHealth = 1300
monster.race = "blood"
monster.corpse = 5978
monster.speed = 70
monster.manaCost = 0
monster.maxSummons = 0

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
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
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
	{text = "We will crush all opposition!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 176},
	{name = "strong health potion", chance = 16340},
	{name = "small ruby", chance = 12870, maxCount = 6},
	{name = "black pearl", chance = 1980},
	{name = "cultish robe", chance = 18870},
	{name = "orc leather", chance = 8420, maxCount = 3},
	{name = "orc tooth", chance = 5940, maxCount = 2},
	{name = "green piece of cloth", chance = 12380},
	{name = "mysterious fetish", chance = 8910},
	{name = "shamanic hood", chance = 14360},
	{name = "broken shamanic staff", chance = 5940},
	{name = "heavy old tome", chance = 99}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -310, range = 7, shootEffect = CONST_ANI_ENERGYBALL, target = false},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -250, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="outfit", interval = 4000, chance = 15, target = true, duration = 30000, outfitMonster = "orc warlord"},
	{name ="outfit", interval = 4000, chance = 10, target = true, duration = 30000, outfitMonster = "orc shaman"},
	{name ="outfit", interval = 4000, chance = 20, target = true, duration = 30000, outfitMonster = "orc"}
}

monster.defenses = {
	defense = 27,
	armor = 27,
	{name ="heal monster", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
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
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
