local mType = Game.createMonsterType("Abyssal Calamary")
local monster = {}

monster.description = "an abyssal calamary"
monster.experience = 200
monster.outfit = {
	lookType = 451,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1105
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 50,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Seacrest Grounds."
	}

monster.health = 300
monster.maxHealth = 300
monster.race = "blood"
monster.corpse = 15280
monster.speed = 280
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
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
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 89,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
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
	{id = 2670, chance = 9680},--shrimp
	{id = 2667, chance = 10770},--fish
	{name = "black pearl", chance = 1500, maxCount = 1},
	{name = "white pearl", chance = 830, maxCount = 1},
	{name = "small sapphire", chance = 250, maxCount = 3},
	{name = "small ruby", chance = 500, maxCount = 3},
	{name = "small amethyst", chance = 750, maxCount = 3}
}

monster.attacks = {
	{name ="drunk", interval = 2000, chance = 10, range = 2, target = false, duration = 5000}
}

monster.defenses = {
	defense = 13,
	armor = 13
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
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
