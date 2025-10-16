local mType = Game.createMonsterType("Brain Head")
local monster = {}

monster.description = "Brain Head"
monster.experience = 0
monster.outfit = {
	lookTypeEx = 32418,
}

monster.health = 75000
monster.maxHealth = monster.health
monster.race = "undead"
monster.corpse = 32272
monster.speed = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1862,
	bossRace = RARITY_ARCHFOE,
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
	{ id = 3043, chance = 80000, maxCount = 2 }, -- crystal coin
	{ id = 32769, chance = 80000, maxCount = 2 }, -- white gem
	{ id = 3038, chance = 80000, maxCount = 2 }, -- green gem
	{ id = 23375, chance = 80000, maxCount = 6 }, -- supreme health potion
	{ id = 23374, chance = 80000, maxCount = 6 }, -- ultimate spirit potion
	{ id = 23373, chance = 80000, maxCount = 6 }, -- ultimate mana potion
	{ id = 32770, chance = 80000 }, -- diamond
	{ id = 7439, chance = 80000, maxCount = 10 }, -- berserk potion
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 32771, chance = 80000 }, -- moonstone
	{ id = 32703, chance = 80000 }, -- death toll
	{ id = 32773, chance = 80000 }, -- ivory comb
	{ id = 32589, chance = 80000 }, -- angel figurine
	{ id = 32774, chance = 80000 }, -- cursed bone
	{ id = 32623, chance = 80000 }, -- giant topaz
	{ id = 32772, chance = 80000 }, -- silver hand mirror
	{ id = 32631, chance = 80000 }, -- ghost claw
	{ id = 32636, chance = 80000 }, -- ring of souls
	{ id = 32616, chance = 80000 }, -- phantasmal axe
	{ id = 32578, chance = 80000 }, -- brain heads giant neuron
	{ id = 32579, chance = 80000 }, -- brain heads left hemisphere
	{ id = 32580, chance = 80000 }, -- brain heads right hemisphere
	{ id = 32705, chance = 80000 }, -- pair of old bracers
	{ id = 32622, chance = 80000 }, -- giant amethyst
	{ id = 32630, chance = 80000 }, -- spooky hood
}

monster.attacks = {
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2000, chance = 80, minDamage = -700, maxDamage = -1200, effect = CONST_ME_MORTAREA, shootEffect = CONST_ANI_SUDDENDEATH, target = true, range = 7 },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 20, length = 8, spread = 0, minDamage = -900, maxDamage = -1300, effect = CONST_ME_ELECTRICALSPARK },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 3.27,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
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
