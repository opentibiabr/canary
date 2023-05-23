local mType = Game.createMonsterType("Behemoth")
local monster = {}

monster.description = "a behemoth"
monster.experience = 2500
monster.outfit = {
	lookType = 55,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 55
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Cyclopolis, deepest part of Tarpit Tomb after the flame, Forbidden Lands, Vandura Mountain, \z
		Deeper Banuta, Serpentine Tower (unreachable), deep into the Formorgar Mines, Arena and Zoo Quarter, \z
		The Dark Path, Lower Spike, Chyllfroest, Medusa Tower and Underground Glooth Factory (west side)."
	}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "blood"
monster.corpse = 5999
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{text = "You're so little!", yell = false},
	{text = "Human flesh -  delicious!", yell = false},
	{text = "Crush the intruders!", yell = false}
}

monster.loot = {
	{id = 2893, chance = 100}, -- amphora
	{name = "crystal necklace", chance = 2530},
	{name = "gold coin", chance = 100000, maxCount = 200},
	{name = "small amethyst", chance = 6380, maxCount = 5},
	{name = "platinum coin", chance = 59800, maxCount = 5},
	{name = "strange symbol", chance = 750},
	{id = 3116, chance = 670}, -- big bone
	{name = "two handed sword", chance = 5980},
	{name = "double axe", chance = 10510},
	{name = "giant sword", chance = 1006},
	{name = "crowbar", chance = 100},
	{name = "war axe", chance = 50},
	{name = "plate armor", chance = 3930},
	{name = "dark armor", chance = 4370},
	{id = 3456, chance = 650}, -- pick
	{name = "steel boots", chance = 380},
	{name = "meat", chance = 30000, maxCount = 6},
	{name = "perfect behemoth fang", chance = 1090},
	{name = "behemoth claw", chance = 430},
	{name = "assassin star", chance = 9750, maxCount = 5},
	{id = 7396, chance = 170}, -- behemoth trophy
	{name = "titan axe", chance = 90},
	{name = "great health potion", chance = 5120},
	{name = "battle stone", chance = 14000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 50,
	{name ="speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 80},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
