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
	{ id = 3043, chance = 97727, maxCount = 2 }, -- Crystal Coin
	{ id = 32769, chance = 62500, maxCount = 2 }, -- White Gem
	{ id = 3038, chance = 1000, maxCount = 2 }, -- Green Gem
	{ id = 23375, chance = 40909, maxCount = 6 }, -- Supreme Health Potion
	{ id = 23374, chance = 35227, maxCount = 6 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 23863, maxCount = 6 }, -- Ultimate Mana Potion
	{ id = 32770, chance = 52272 }, -- Diamond
	{ id = 7439, chance = 23863, maxCount = 10 }, -- Berserk Potion
	{ id = 7443, chance = 15909, maxCount = 10 }, -- Bullseye Potion
	{ id = 7440, chance = 12500, maxCount = 10 }, -- Mastermind Potion
	{ id = 32771, chance = 7954 }, -- Moonstone
	{ id = 32703, chance = 13636 }, -- Death Toll
	{ id = 32773, chance = 11363 }, -- Ivory Comb
	{ id = 32589, chance = 5681 }, -- Angel Figurine
	{ id = 32774, chance = 21590 }, -- Cursed Bone
	{ id = 32623, chance = 2857 }, -- Giant Topaz
	{ id = 32772, chance = 14772 }, -- Silver Hand Mirror
	{ id = 32631, chance = 5555 }, -- Ghost Claw
	{ id = 32621, chance = 1000 }, -- Ring of Souls
	{ id = 32616, chance = 1000 }, -- Phantasmal Axe
	{ id = 32578, chance = 1000 }, -- Brain Head's Giant Neuron
	{ id = 32579, chance = 1000 }, -- Brain Head's Left Hemisphere
	{ id = 32580, chance = 2857 }, -- Brain Head's Right Hemisphere
	{ id = 32705, chance = 1000 }, -- Pair of Old Bracers
	{ id = 32622, chance = 5681 }, -- Giant Amethyst
	{ id = 32630, chance = 5555 }, -- Spooky Hood
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
