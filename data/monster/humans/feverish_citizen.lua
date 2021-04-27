local mType = Game.createMonsterType("Feverish Citizen")
local monster = {}

monster.description = "a feverish citizen"
monster.experience = 30
monster.outfit = {
	lookType = 425,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 719
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 2,
	Locations = "Venore."
	}

monster.health = 125
monster.maxHealth = 125
monster.race = "blood"
monster.corpse = 20395
monster.speed = 146
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
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
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
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
	{text = "Arrrgh!", yell = false},
	{text = "I am the king of the world!", yell = false},
	{text = "Die Ferumbras!", yell = false},
	{text = "Tigerblood is running through my veins!", yell = false},
	{text = "You! It's you again!", yell = false},
	{text = "Stand still you tasty morsel!", yell = false},
	{text = "<giggle>", yell = false},
	{text = "Burn heretic! Burn!", yell = false},
	{text = "Harrr!", yell = false},
	{text = "This is Venore!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 30300, maxCount = 35},
	{id = 2230, chance = 4920},
	{name = "worm", chance = 25730, maxCount = 3},
	{name = "ominous piece of cloth", chance = 1660},
	{name = "dubious piece of cloth", chance = 1720},
	{name = "voluminous piece of cloth", chance = 2290},
	{name = "obvious piece of cloth", chance = 2006},
	{name = "ludicrous piece of cloth", chance = 2060},
	{name = "luminous piece of cloth", chance = 2290}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -18},
	{name ="drunk", interval = 2000, chance = 15, length = 3, spread = 2, effect = CONST_ME_POISONAREA, target = false, duration = 3000}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="outfit", interval = 2000, chance = 1, radius = 3, effect = CONST_ME_GREEN_RINGS, target = false, duration = 5000, outfitMonster = "bog raider"}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 80},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
