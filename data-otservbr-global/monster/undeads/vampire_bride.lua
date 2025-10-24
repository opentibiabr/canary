local mType = Game.createMonsterType("Vampire Bride")
local monster = {}

monster.description = "a vampire bride"
monster.experience = 1050
monster.outfit = {
	lookType = 312,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 483
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Drefia and Vampire Castle on Vengoth, Edron Vampire Crypt.",
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 8744
monster.speed = 100
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
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
	{ text = "Kneel before your Mistress!", yell = false },
	{ text = "Dead is the new alive.", yell = false },
	{ text = "Come, let me kiss you, darling. Oh wait, I meant kill.", yell = false },
	{ text = "Enjoy the pain - I know you love it.", yell = false },
	{ text = "Are you suffering nicely enough?", yell = false },
	{ text = "You won't regret you came to me, sweetheart.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 93446, maxCount = 149 }, -- Gold Coin
	{ id = 3035, chance = 10027 }, -- Platinum Coin
	{ id = 237, chance = 9863 }, -- Strong Mana Potion
	{ id = 9685, chance = 10139 }, -- Vampire Teeth
	{ id = 3070, chance = 4981 }, -- Moonlight Rod
	{ id = 11449, chance = 5177 }, -- Blood Preservation
	{ id = 236, chance = 4809 }, -- Strong Health Potion
	{ id = 3010, chance = 919 }, -- Emerald Bangle
	{ id = 8045, chance = 1122 }, -- Hibiscus Dress
	{ id = 8895, chance = 923 }, -- Rusted Armor
	{ id = 3028, chance = 1483, maxCount = 2 }, -- Small Diamond
	{ id = 8923, chance = 958 }, -- Velvet Tapestry
	{ id = 3079, chance = 188 }, -- Boots of Haste
	{ id = 649, chance = 235 }, -- Flower Bouquet
	{ id = 5668, chance = 92 }, -- Mysterious Voodoo Skull
	{ id = 8531, chance = 124 }, -- Blood Goblet
	{ id = 12306, chance = 24 }, -- Leather Whip
	{ id = 3081, chance = 100 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -190 },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -60, maxDamage = -130, range = 1, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -60, maxDamage = -150, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 4000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -60, maxDamage = -150, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_HEARTS, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -60, maxDamage = -150, range = 7, shootEffect = CONST_ANI_ENERGY, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 55,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 40, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 10 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
