local mType = Game.createMonsterType("Medusa")
local monster = {}

monster.description = "a medusa"
monster.experience = 4050
monster.outfit = {
	lookType = 330,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 570
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Vandura Mountain (single spawn), Talahu (Medusa Cave), Deeper Banuta, Medusa Tower.",
}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 9607
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 600,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will make sssuch a fine ssstatue!", yell = false },
	{ text = "There isss no chhhanccce of essscape", yell = false },
	{ text = "Are you tired or why are you moving thhat ssslow <chuckle>", yell = false },
	{ text = "Jussst look at me!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 190 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 6 }, -- platinum coin
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 10309, chance = 23000 }, -- strand of medusa hair
	{ id = 7643, chance = 23000, maxCount = 2 }, -- ultimate health potion
	{ id = 814, chance = 5000 }, -- terra amulet
	{ id = 3032, chance = 5000, maxCount = 4 }, -- small emerald
	{ id = 3436, chance = 5000 }, -- medusa shield
	{ id = 3370, chance = 5000 }, -- knight armor
	{ id = 7413, chance = 5000 }, -- titan axe
	{ id = 811, chance = 1000 }, -- terra mantle
	{ id = 9302, chance = 1000 }, -- sacred tree amulet
	{ id = 812, chance = 260 }, -- terra legs
	{ id = 8896, chance = 260 }, -- slightly rusted armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450, condition = { type = CONDITION_POISON, totalDamage = 840, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -21, maxDamage = -350, range = 7, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_CARNIPHILA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -250, maxDamage = -500, length = 8, spread = 0, effect = CONST_ME_CARNIPHILA, target = false },
	{ name = "speed", interval = 2000, chance = 25, radius = 7, effect = CONST_ME_POFF, target = true },
	{ name = "outfit", interval = 2000, chance = 1, range = 7, target = true, duration = 3000, outfitMonster = "clay guardian" },
}

monster.defenses = {
	defense = 30,
	armor = 45,
	mitigation = 1.74,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 150, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
