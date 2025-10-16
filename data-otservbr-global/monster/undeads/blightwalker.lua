local mType = Game.createMonsterType("Blightwalker")
local monster = {}

monster.description = "a blightwalker"
monster.experience = 6400
monster.outfit = {
	lookType = 246,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 298
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, Edron (In the Vats during The Inquisition Quest), Roshamuul Prison, Grounds of Undeath.",
}

monster.health = 8100
monster.maxHealth = 8100
monster.race = "undead"
monster.corpse = 6353
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	runHealth = 800,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I can see you decaying!", yell = false },
	{ text = "Let me taste your mortality!", yell = false },
	{ text = "Your lifeforce is waning!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 199 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 3147, chance = 80000, maxCount = 2 }, -- blank rune
	{ id = 3605, chance = 80000 }, -- bunch of wheat
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 238, chance = 80000, maxCount = 3 }, -- great mana potion
	{ id = 5944, chance = 80000 }, -- soul orb
	{ id = 7368, chance = 23000, maxCount = 10 }, -- assassin star
	{ id = 9688, chance = 23000 }, -- bundle of cursed straw
	{ id = 3067, chance = 23000 }, -- hailstorm rod
	{ id = 7643, chance = 23000, maxCount = 2 }, -- ultimate health potion
	{ id = 9058, chance = 5000 }, -- gold ingot
	{ id = 3083, chance = 5000 }, -- garlic necklace
	{ id = 3453, chance = 5000 }, -- scythe
	{ id = 647, chance = 5000 }, -- seeds
	{ id = 812, chance = 5000 }, -- terra legs
	{ id = 6299, chance = 5000 }, -- death ring
	{ id = 3063, chance = 5000 }, -- gold ring
	{ id = 3324, chance = 5000 }, -- skull staff
	{ id = 811, chance = 1000 }, -- terra mantle
	{ id = 3057, chance = 260 }, -- amulet of loss
	{ id = 3306, chance = 260 }, -- golden sickle
	{ id = 3081, chance = 260 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -490 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -220, maxDamage = -405, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -65, maxDamage = -135, radius = 4, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "blightwalker curse", interval = 2000, chance = 15, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -300, range = 7, shootEffect = CONST_ANI_POISON, target = true, duration = 15000 },
}

monster.defenses = {
	defense = 50,
	armor = 63,
	mitigation = 1.18,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
