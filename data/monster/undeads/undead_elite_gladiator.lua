local mType = Game.createMonsterType("Undead Elite Gladiator")
local monster = {}

monster.description = "an undead elite gladiator"
monster.experience = 4740
monster.outfit = {
	lookType = 306,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1675
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Deep Desert."
	}

monster.health = 8000
monster.maxHealth = 8000
monster.race = "undead"
monster.corpse = 9823
monster.speed = 300
monster.manaCost = 0
monster.maxSummons = 0

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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
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
}

monster.loot = {
	{name = "Platinum Coin", chance = 44000, maxCount = 40},
	{name = "Belted Cape", chance = 500},
	{name = "Ultimate Health Potion", chance = 500, maxCount = 2},
	{name = "Throwing Star", chance = 500, maxCount = 18},
	{name = "Knight Axe", chance = 250},
	{id = 2419, chance = 500},
	{name = "protection amulet", chance = 250},
	{name = "hunting spear", chance = 250},
	{name = "broken gladiator shield", chance = 250},
	{name = "dark helmet", chance = 250},
	{name = "flask of warrior's sweat", chance = 250},
	{name = "plate armor", chance = 250},
	{name = "plate legs", chance = 250},
	{name = "two handed sword", chance = 250},
	{name = "Great Health Potion", chance = 250, maxCount = 2},
	{name = "stealth ring", chance = 230},
	{name = "crusader helmet", chance = 150},
	{name = "Relic Sword", chance = 150}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 100, maxDamage = 550},
	{name ="combat", interval = 1500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 300, maxDamage = 550, range = 7, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = false},
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = 300, maxDamage = 500, range = 5, radius = 3, effect = CONST_ME_HITAREA, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 85,
	{name ="invisible", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 80},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
