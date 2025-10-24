local mType = Game.createMonsterType("Primitive")
local monster = {}

monster.description = "a primitive"
monster.experience = 45
monster.outfit = {
	lookType = 143,
	lookHead = 1,
	lookBody = 1,
	lookLegs = 1,
	lookFeet = 1,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 200
monster.maxHealth = 200
monster.race = "blood"
monster.corpse = 111
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 5,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{ text = "We don't need a future!", yell = false },
	{ text = "I'll rook you all!", yell = false },
	{ text = "They thought they'd beaten us!", yell = false },
	{ text = "You are history!", yell = false },
	{ text = "There can only be one world!", yell = false },
	{ text = "Guido who?", yell = false },
	{ text = "Die noob!", yell = false },
	{ text = "There are no dragons!", yell = false },
	{ text = "I'll quit forever! Again ...", yell = false },
	{ text = "You all are noobs!", yell = false },
	{ text = "Beware of the cyclops!", yell = false },
	{ text = "Just had a disconnect.", yell = false },
	{ text = "Magic is only good for girls!", yell = false },
	{ text = "We'll be back!", yell = false },
	{ text = "I need some vitamins!", yell = false },
	{ text = "Uh, I can't hear anymore. I am deaf!", yell = false },
	{ text = "They've ruined it! I can't cheat anymore!", yell = false },
	{ text = "This world is ours!", yell = false },
	{ text = "Back to the roots!", yell = false },
	{ text = "Kill all magic users!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 1000, maxCount = 10 }, -- Gold Coin
	{ id = 3426, chance = 1000 }, -- Studded Shield
	{ id = 3376, chance = 1000 }, -- Studded Helmet
	{ id = 3378, chance = 1000 }, -- Studded Armor
	{ id = 3274, chance = 1000 }, -- Axe
	{ id = 3273, chance = 1000 }, -- Sabre
	{ id = 6570, chance = 1000 }, -- Surprise Bag (Blue)
	{ id = 6571, chance = 1000 }, -- Surprise Bag (Red)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -32 },
	{ name = "drunk", interval = 1000, chance = 20, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -20, maxDamage = -20, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "outfit", interval = 1000, chance = 2, radius = 4, effect = CONST_ME_LOSEENERGY, target = false, duration = 10000, outfitMonster = "primitive" },
}

monster.defenses = {
	defense = 25,
	armor = 20,
	mitigation = 0.43,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
