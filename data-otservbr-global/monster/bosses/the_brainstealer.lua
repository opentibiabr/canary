local mType = Game.createMonsterType("The Brainstealer")
local monster = {}

monster.description = "The Brainstealer"
monster.experience = 72000
monster.outfit = {
	lookType = 1412,
	lookHead = 94,
	lookBody = 88,
	lookLegs = 88,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2055,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = monster.health
monster.race = "undead"
monster.corpse = 36843
monster.speed = 425

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "brain parasite", chance = 20, interval = 4000, count = 1 },
	},
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.loot = {
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 7443, chance = 80000 }, -- bullseye potion
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 32771, chance = 80000 }, -- moonstone
	{ id = 23373, chance = 80000 }, -- ultimate mana potion
	{ id = 23374, chance = 80000 }, -- ultimate spirit potion
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 32769, chance = 80000 }, -- white gem
	{ id = 23375, chance = 80000 }, -- supreme health potion
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 34025, chance = 80000 }, -- diabolic skull
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 36794, chance = 80000 }, -- brainstealers tissue
	{ id = 36795, chance = 80000 }, -- brainstealers brain
	{ id = 36796, chance = 80000 }, -- brainstealers brainwave
	{ id = 36835, chance = 80000 }, -- eldritch crystal
	{ id = 36667, chance = 80000 }, -- eldritch breeches
	{ id = 36670, chance = 80000 }, -- eldritch cowl
	{ id = 36671, chance = 80000 }, -- eldritch hood
	{ id = 36664, chance = 80000 }, -- eldritch bow
	{ id = 36666, chance = 80000 }, -- eldritch quiver
	{ id = 36657, chance = 80000 }, -- eldritch claymore
	{ id = 36661, chance = 80000 }, -- eldritch greataxe
	{ id = 36659, chance = 80000 }, -- eldritch warmace
	{ id = 36656, chance = 80000 }, -- eldritch shield
	{ id = 36663, chance = 80000 }, -- eldritch cuirass
	{ id = 36672, chance = 80000 }, -- eldritch folio
	{ id = 36673, chance = 80000 }, -- eldritch tome
	{ id = 36674, chance = 80000 }, -- eldritch rod
	{ id = 36668, chance = 80000 }, -- eldritch wand
	{ id = 36658, chance = 80000 }, -- gilded eldritch claymore
	{ id = 36662, chance = 80000 }, -- gilded eldritch greataxe
	{ id = 36660, chance = 80000 }, -- gilded eldritch warmace
	{ id = 36669, chance = 80000 }, -- gilded eldritch wand
	{ id = 36675, chance = 80000 }, -- gilded eldritch rod
	{ id = 36665, chance = 80000 }, -- gilded eldritch bow
	{ id = 30059, chance = 80000 }, -- giant ruby
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, minDamage = 0, maxDamage = -900 },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2000, chance = 20, radius = 4, minDamage = -1200, maxDamage = -1900, effect = CONST_ME_MORTAREA, shootEffect = CONST_ANI_SUDDENDEATH, target = true, range = 7 },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 20, radius = 4, minDamage = -700, maxDamage = -1000, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 10, length = 8, spread = 0, minDamage = -1200, maxDamage = -1600, effect = CONST_ME_ELECTRICALSPARK },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 3.27,
	{ name = "combat", type = COMBAT_HEALING, chance = 15, interval = 2000, minDamage = 1450, maxDamage = 5350, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 3 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "invisible", condition = true },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Feel the power of death unleashed!", yell = false },
	{ text = "I will rule again and my realm of death will span the world!", yell = false },
	{ text = "My lich-knights will conquer this world for me!", yell = false },
}

mType:register(monster)
